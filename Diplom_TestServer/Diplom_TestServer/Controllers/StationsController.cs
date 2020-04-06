using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Http;
using System.Web.Http.Results;
using Newtonsoft.Json;

namespace Diplom_TestServer.Controllers
{
    public class StationsController : ApiController
    {
        //http://localhost:8080/api/stations/getcarpassangers?driverid=4
        [HttpGet]
        public int GetCarPassangers(int driverId)
        {
            Random rnd = new Random();
            return rnd.Next(1, 5);
        }

        //http://localhost:8080/api/stations/getstationpassangers?stationid=4
        [HttpGet]
        public int GetStationPassangers(int stationId)
        {
            Random rnd = new Random();
            return rnd.Next(1, 5);
        }

        //http://localhost:8080/api/stations/updatestationdata?currstationid=4&currdriverid=4
        [HttpPost]
        public void UpdateStationData(int currtationId, int currDriverId)
        {
            Console.WriteLine("UPDATE!");
        }
    }
} 
