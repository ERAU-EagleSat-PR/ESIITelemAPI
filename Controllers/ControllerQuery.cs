using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using System.Data;
using Microsoft.Data.SqlClient;
using Dapper;
using Microsoft.Extensions.Configuration;

namespace ESIITelemAPI.Controllers
{
    public class ControllerQuery : ControllerBase
    {
        private readonly ILogger<ControllerQuery> _logger;
        private readonly IConfiguration _config;

        public ControllerQuery(IConfiguration config, ILogger<ControllerQuery> logger)
        {
            _logger = logger;
            _config = config;
        }

        protected async Task<JsonElement> Query(string verb, string entityName, int? id = null, JsonElement payload = default(JsonElement))
        {
            JsonDocument result = null;
            string query = "";

            if (!(new string[] {"get", "put"}).Contains(verb.ToLower()))
            {
                throw new ArgumentException($"verb '{verb}' not supported", nameof(verb));
            }
            
            //string entityName = entity.Name.Replace("Controller", string.Empty).ToLower();
            string procedure = $"web.{verb}_{entityName}";
            _logger.LogDebug($"Executing {procedure}");

            var connectionStringName = verb.ToLower() != "get" ? "ReadWriteConnection" : "ReadOnlyConnection";

            using(var conn = new SqlConnection(_config.GetConnectionString(connectionStringName))) {
                DynamicParameters parameters = new DynamicParameters();
                
                /*
                if (payload.ValueKind != default(JsonValueKind))
                {
                    var json = JsonSerializer.Serialize(payload);
                    parameters.Add("Json", json);
                }
                
                if (id.HasValue)
                    parameters.Add("Id", id.Value);
                */
                
                await using (var command = new SqlCommand())
                {
                    conn.Open();
                    command.Connection = conn;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = procedure;
                    
                    if (id.HasValue)
                    {
                        command.Parameters.Add("@Id", SqlDbType.Int);
                        command.Parameters["@Id"].Value = id;
                    }

                    if (payload.ValueKind != default(JsonValueKind))
                    {
                        var json = JsonSerializer.Serialize(payload);
                        command.Parameters.Add("@Json", SqlDbType.NVarChar);
                        command.Parameters["@Json"].Value = json;
                    }
                    
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        query += reader[0];
                    }
                    conn.Close();
                }

                if (query != "")
                    result = JsonDocument.Parse(query);
            };

            if (result == null)
                result = JsonDocument.Parse("[]");
                        
            return result.RootElement;
        }
    }
}