<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<HTML>

<head>
</head>

<BODY>


    <Script runat="server">
        string response = "";
  protected void Page_Load(object sender, EventArgs e)
        {
            System.Diagnostics.Stopwatch sw = new System.Diagnostics.Stopwatch();
            sw.Start();

            while (sw.Elapsed < TimeSpan.FromSeconds(600)) {

            }

        }
    </Script>
    <!-- <% Response.Write(response.ToString()); %> -->
</BODY>

</HTML>