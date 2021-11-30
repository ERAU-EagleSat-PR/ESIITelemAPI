using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ESIITelemAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EPSAverageBatteryVoltageController : ControllerQuery
    {
        public EPSAverageBatteryVoltageController(IConfiguration config, ILogger<EPSAverageBatteryVoltageController> logger):
            base(config, logger) {}

        [HttpGet]
        public async Task<JsonElement> Get()
        {
            return await this.Query("get", this.GetType());
        }

        [HttpPost]
        public async Task<JsonElement> Post([FromBody]JsonElement payload)
        {
            return await this.Query("post", this.GetType(), payload);
        }
    }
}