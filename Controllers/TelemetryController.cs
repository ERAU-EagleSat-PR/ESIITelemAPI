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
    public class TelemetryController : ControllerQuery
    {
        public TelemetryController(IConfiguration config, ILogger<TelemetryController> logger) :
            base(config, logger) {}
        
        [HttpGet]
        public async Task<JsonElement> Get()
        {
            return await this.Query("get", "alltelemetry");
        }
        
        [HttpGet("{downlinkId}")]
        public async Task<JsonElement> Get(int downlinkId)
        {
            return await this.Query("get", "telemetry", downlinkId);
        }

        [HttpPut]
        public async Task<JsonElement> Put([FromBody]JsonElement payload)
        {
            return await this.Query("put", "telemetry", payload: payload);
        }
    }
}
