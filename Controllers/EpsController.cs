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
        public EpsController(IConfiguration config, ILogger<EpsController> logger) :
            base(config, logger) {}

        [HttpGet]
        public async Task<JsonElement> Get()
        {
            return await this.Query("get", "alleps");
        }

        [HttpGet("{downlinkId}")]
        public async Task<JsonElement> Get(int downlinkId)
        {
            return await this.Query("get", "eps", downlinkId);
        }
        
        [HttpGet("AverageBatteryVoltage")]
        public async Task<JsonElement> GetAverageBatteryVoltage()
        {
            return await this.Query("get", "allepsavgbatvol");
        }
        
        [HttpGet("Brownouts")]
        public async Task<JsonElement> GetBrownouts()
        {
            return await this.Query("get", "allbrownouts");
        }
        
        [HttpGet("ChargeTime")]
        public async Task<JsonElement> GetChargeTime()
        {
            return await this.Query("get", "allchargetime");
        }
        
        [HttpGet("PeakChargePower")]
        public async Task<JsonElement> GetPeakChargePower()
        {
            return await this.Query("get", "allpeakchargepower");
        }

        [HttpPut]
        public async Task<JsonElement> Put([FromBody]JsonElement payload)
        {
            return await this.Query("put", "eps", payload: payload);
        }
    }
}
