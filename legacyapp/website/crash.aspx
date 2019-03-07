<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Threading" %>
<%@ Page Language="c#"%>

<script runat="server">
  public bool ServerSideFunction()
  {
    /*var thread = new Thread(() =>
        {
            throw new InvalidOperationException("some failure on a helper thread");
        });
    thread.Start();
    thread.Join();
    return true; */
    return ThreadPool.QueueUserWorkItem(ThreadProc);
  }
  public static void ThreadProc(Object stateInfo) 
    {
        throw new System.ArgumentException("About to crash");
    }
</script>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
<title>ASP.NET inline</title>
</head>
<body>
    <% ServerSideFunction(); %>
<H1>About to crash</H1>
</body>
</html>