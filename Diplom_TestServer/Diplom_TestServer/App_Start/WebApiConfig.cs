using System.Web.Http;

namespace Diplom_TestServer
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            //config.Routes.Add(name: "ApiWithStationId1", route: config.Routes.MapHttpRoute(
            //name: "ApiWithStationId",
            //    routeTemplate: "api/{controller}/{action}/{stationId}"
            //));

            //config.Routes.Add(name: "ApiWithDriverId", route: config.Routes.MapHttpRoute(
            //name: "ApiWithDriverId2",
            //    routeTemplate: "api/{controller}/{action}/{driverId}"
            //));

            //config.Routes.Add(name: "ApiLogin3", route: config.Routes.MapHttpRoute(
            //name: "ApiLogin",
            //    routeTemplate: "api/{controller}/{action}/{number}/{password}"
            //));

            //config.Routes.Add(name: "DefaultApi4", route: config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{id}",
            //    defaults: new { id = RouteParameter.Optional }
            //));

            //config.Routes.MapHttpRoute(
            //name: "ApiWithStationId",
            //    routeTemplate: "api/{controller}/{action}/{stationId}"
            //);

            //config.Routes.MapHttpRoute(
            //name: "ApiWithDriverId",
            //    routeTemplate: "api/{controller}/{action}/{driverId}"
            //);

            //config.Routes.MapHttpRoute(
            //name: "DriverRegistration",
            //    routeTemplate: "api/{controller}/{action}/{driver}"
            //);

            //config.Routes.MapHttpRoute(
            //name: "ApiLogin",
            //    routeTemplate: "api/{controller}/{action}/{number}/{password}"
            //);

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}