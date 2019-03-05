<html>

<body>
    <%
    Application.Lock
    set shell = CreateObject("WScript.Shell")
    Application("visits")=Application("visits")+1


 t1 = timer()
 sleep(1)
 t2 = timer()

 'response.write "waited "& t2-t1 &" secs"


 function sleep(seconds)
    if seconds>=1 then shell.popup "pausing",seconds,"pause",64
 end function
 
 Response.Write "<H1>ComputerName: " + Request.ServerVariables("SERVER_NAME") + "</H1>"
    Application.Unlock
    %>

</body>

</html>