<!doctype HTML>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>fortunes</title>
<link title="style" rel="stylesheet" type="text/css" href="style.css"/>
<style type="text/css">
    table {margin-top:1em}
</style>
</head>

<body>
<div id="crumb"><a href="Default.asp">lalaletters admin</a></div>
<div id="content">
<%
set rs=server.createobject("adodb.recordset")
rs.CursorLocation=adUseClient
rs.Open "select * from tblLala", Session("myADO")
rs.MoveLast
intCt = rs.RecordCOunt
rs.MoveFirst

set rsCode=server.createobject("adodb.recordset")
rsCode.CursorLocation=adUseClient
rsCode.Open "select * from tblLalaRoot ORDER BY RootID", Session("myADO")

response.write "<table class='thin zebra'><thead><tr><td>Codeword</td>"

' header row
do until rsCode.EOF
	response.write "<td>" & rsCode(0) & "</td>"
	rsCode.MoveNext
	intCtCode=intCtCode+1
loop
response.write "</tr></thead><tbody>"

do until rs.EOF
	response.write "<tr><td>" & rs("CodeID") & "</td>"
	for i = 1 to intCtCode
        ' For 2015, add 1500 so that old lalas can be hidden along with new
		response.write "<td>" & 1500 + rs.AbsolutePosition + (i-1) * intCt & "</td>"
	next
	response.write "</tr>"
	rs.movenext
loop
response.write "</tbody></table>"
		
rs.close
%>

</div>
</body>

</html>