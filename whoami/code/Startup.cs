using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

namespace code
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.Use(async (context, next) =>
            {
                var environmentVariable = Environment.GetEnvironmentVariables().GetEnumerator();
                while (environmentVariable.MoveNext())
                {
                    var value = environmentVariable.Value.ToString().Replace("\r", string.Empty).Replace("\n", string.Empty);
                    context.Response.Headers.Add(environmentVariable.Key.ToString(), value);
                }
                await next();
            });

            app.Run(async (context) =>
            {
                var environmentVariable = Environment.GetEnvironmentVariables().GetEnumerator();
                await context.Response.WriteAsync("<HTML><BODY><TABLE>");
                while (environmentVariable.MoveNext())
                {
                    await context.Response.WriteAsync($"<TR><TD>{environmentVariable.Key}</TD><TD>{environmentVariable.Value}</TD></TR>");
                }
                await context.Response.WriteAsync("</TABLE></BODY>");
            });
        }
    }
}
