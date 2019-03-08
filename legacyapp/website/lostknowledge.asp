<HTML>
<SCRIPT LANGUAGE=VBScript RUNAT=Server>
dim fs,f
set fs=Server.CreateObject("Scripting.FileSystemObject") 
set f=fs.CreateTextFile(Server.MapPath("/content/file.txt"),true)
f.write("Hello World!")
f.close
set f=nothing
set fs=nothing
Response.Write "Successfully created a file"
    </SCRIPT>
    
    </HTML>