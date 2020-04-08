using System;
namespace Diplom_TestServer.Model
{
    public class User
    {
        public string id { get; set; }
        public string firstName { get; set; }
        public string secondName { get; set; }
        public string mobileNumber { get; set; }
        public string password { get; set; }
        public User()
        {
            id = "0";
            firstName = "Артем";
            secondName = "Супрунович";
            mobileNumber = "+375298034287";
            password = "1111";
        }

    }
}
