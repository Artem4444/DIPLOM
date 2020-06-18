using System;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;

namespace Diplom_TestServer.Controllers
{
    public class TestController : ApiController
    {
        public HttpResponseMessage Get()
        {
            var response = this.Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent("Server is ready!", Encoding.UTF8);
            return response;
        }
    }
}
