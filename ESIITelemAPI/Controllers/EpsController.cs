using System;
using System.Data;
using System.Text.Json;
using System.Threading.Tasks;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ESIITelemAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EpsController : ControllerQuery
    {
        private readonly IConfiguration _config;

        public EpsController(IConfiguration config, ILogger<EpsController> logger) :
            base(config, logger)
        {
            _config = config;
        }

        [HttpGet]
        public async Task<JsonElement> Get()
        {
            JsonDocument result = null;
            
            using(var conn = new SqlConnection(_config.GetConnectionString("ReadOnlyConnection"))) {
                DynamicParameters parameters = new DynamicParameters();

                string procedure = $"web.get_alleps";
                
                var qr = await conn.ExecuteScalarAsync<string>(
                    sql: procedure, 
                    param: parameters, 
                    commandType: CommandType.StoredProcedure
                ); 
                
                if (qr != null)
                    result = JsonDocument.Parse(qr);
            };
            
            if (result == null) 
                result = JsonDocument.Parse("[]");
                        
            return result.RootElement;
        }

        [HttpGet("{downlinkId}")]
        public async Task<JsonElement> Get(int downlinkId)
        {
            return await this.Query("get", this.GetType(), downlinkId);
        }

        [HttpPut]
        public async Task<JsonElement> Post([FromBody]JsonElement payload)
        {
            return await this.Query("put", this.GetType(), payload: payload);
        }
    }
}
