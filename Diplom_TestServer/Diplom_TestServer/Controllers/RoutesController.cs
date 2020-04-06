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
    public class RoutesController : ApiController
    {
        // this controller adress http://localhost:8080/api/routes/

        public HttpResponseMessage Get()
        {
            string jsonRoutes = File.ReadAllText(@"/Users/artem/Projects/Diplom_TestServer/Diplom_TestServer/Data/routes.json");
            var response = this.Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(jsonRoutes, Encoding.UTF8);
            return response;
        }
    }
}
