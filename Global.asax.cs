using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Routing;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace GeneralPublic
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
            SerializeSettings(GlobalConfiguration.Configuration);
        }

        void SerializeSettings(HttpConfiguration config)
        {
            JsonSerializerSettings jsonSetting = new JsonSerializerSettings();
            jsonSetting.Converters.Add(new StringEnumConverter());
            config.Formatters.JsonFormatter.SerializerSettings = jsonSetting;
        }
    }
}
