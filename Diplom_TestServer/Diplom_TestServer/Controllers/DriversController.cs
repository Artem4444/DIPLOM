using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using Diplom_TestServer.Model;
using Newtonsoft.Json;

namespace Diplom_TestServer.Controllers
{
    public class DriversController : ApiController
    {
        [HttpPost]
        public HttpResponseMessage Registration(string driver)
        {
            if (driver == null || driver == "")
            {
                var bad = Request.CreateResponse(HttpStatusCode.BadRequest);
                bad.Content = new StringContent($"Произошла ошибка!", Encoding.UTF8);
                return bad;
            }
            User user = JsonConvert.DeserializeObject<User>(driver);
            if (user == null)
            {
                var bad = Request.CreateResponse(HttpStatusCode.BadRequest);
                bad.Content = new StringContent($"Произошла ошибка!", Encoding.UTF8);
                return bad;
            }
            if (user.mobileNumber == "+375298034287")
            {
                var found = Request.CreateResponse(HttpStatusCode.Found);
                found.Content = new StringContent($"Пользoватель с телефоном {user.mobileNumber} уже зарегистрирован!", Encoding.UTF8);
                return found;
            }
            else
            {
                var ok = Request.CreateResponse(HttpStatusCode.OK);
                ok.Content = new StringContent($"Пользoватель {user.firstName} {user.secondName} успешно зарегистрирован!", Encoding.UTF8);
                return ok;
            }
        }

        // this controller adress http://localhost:8080/api/drivers/login?mobile=375298034287&password=1111

        [HttpGet]
        public HttpResponseMessage Login(string mobile, string password)
        {
            if (mobile == "375298034287" && password == "1111")
            {
                User driver = new User();
                string jsonDriver = JsonConvert.SerializeObject(driver);
                var ok = Request.CreateResponse(HttpStatusCode.OK);
                ok.Content = new StringContent(jsonDriver, Encoding.UTF8);
                return ok;
            }
            else
            {
                var bad = Request.CreateResponse(HttpStatusCode.BadRequest);
                bad.Content = new StringContent($"Неверно указан логин или пароль!", Encoding.UTF8);
                return bad;
            }

        }
    }
}
