using System;
namespace Diplom_TestServer.Model
{
    public class User
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string SecondName { get; set; }
        public string MobileNumber { get; set; }
        public string Password { get; set; }
        public User()
        {
            Id = 0;
            FirstName = "Артем";
            SecondName = "Супрунович";
            MobileNumber = "+375298034287";
            Password = "1111";
        }

    }
}
