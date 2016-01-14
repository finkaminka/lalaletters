<!doctype HTML>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width" />

<title>hiders</title>
<link title="style" rel="stylesheet" type="text/css" href="style.css">
</head>

<body>
<div id="crumb"><a href="Default.asp">lalaletters admin (<%=Session("intYear")%>)</a></div>
<div id="content">
<h1>Lala hiders</h1>
<p><a href="editHider.asp">Add new hider</a>&nbsp;&nbsp;(check the list first)</p>
<table class="thin">
<%
set rs=server.createobject("adodb.recordset")
rs.CursorLocation=adUseClient
rs.Open "select * from tblHider", Session("myADO")

response.write "<tr><td>Initials</td><td>Name</td><td>Email</td><td>City</td><td>Lala #s</td></tr>"
do until rs.eof
	response.write "<td><a href=""editHider.asp?Initials=" & Replace(rs("Initials"),"'","''") & """>" & rs("Initials") & "</td>"
	response.write "<td>" & rs("FullName") & "</td>"
    response.write "<td>" & rs("Email") & "</td>"
    response.write "<td>" & rs("City") & "</td>"
    
    CodeIDs = rs("CodeIDList")
    if rs("CodeIDMin")<>"" then
        if CodeIDs<>"" then CodeIDs = CodeIDs & ", "
        CodeIDs = CodeIDs & rs("CodeIDMin") & "-" & rs("CodeIDMax")
    end if
    if rs("CodeIDMin2")<>"" then
        if CodeIDs<>"" then CodeIDs = CodeIDs & ", "
        CodeIDs = CodeIDs & rs("CodeIDMin2") & "-" & rs("CodeIDMax2")
    end if

    response.write "<td>" & CodeIDs & "</td></tr>" & vbCrLf
	rs.Movenext
loop
rs.close
%></table>
</div>
</body>

</html>
