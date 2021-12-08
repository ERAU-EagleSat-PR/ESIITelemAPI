using System;
using System.Data;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ESIITelemAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MdeController : ControllerQuery
    {
        public MdeController(IConfiguration config, ILogger<MdeController> logger) :
            base(config, logger) {}

        [HttpGet]
        public async Task<JsonElement> Get()
        {
            return await this.Query("get", "allmde");
        }

        [HttpGet("{downlinkId}")]
        public async Task<JsonElement> Get(int downlinkId)
        {
            return await this.Query("get", "eps", downlinkId);
        }

        [HttpPut]
        public async Task<JsonElement> Put([FromBody]JsonElement payload)
        {
            return await this.Query("put", "eps", payload: payload);
        }
    }
}
