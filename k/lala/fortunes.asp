<!doctype HTML >

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>fortunes</title>
<link title="style" rel="stylesheet" type="text/css" href="style.css">
</head>

<body>
<div id="crumb"><a href="Default.asp">lalaletters admin (<%=Session("intYear")%>)</a></div>
<div id="content">
<p>click codewords to edit fortunes and/or letters, and to indicate whether a blog photo
has been posted.</p>
<p><a href="edit.asp">Add new code word</a>&nbsp;&nbsp;(check the list first)</p>
<table class="thin">
<%
set rs=server.createobject("adodb.recordset")
rs.CursorLocation=adUseClient
rs.Open "select * from tblLala left join vewTotalByRoot v on v.Root = tblLala.CodeID", Session("myADO")

if request("sort") = "CodeID" then rs.sort = "CodeID"
if request("sort") = "LastUpdate" then rs.sort = "LastUpdate DESC, CodeID"
if request("sort") = "Found" then rs.sort = "Found DESC, CodeID"

strSort = "<a title=""click to sort on this column"" href=""fortunes.asp?sort="

response.write "<tr><td>" & strSort & "CodeID"">Codeword</td>"
response.write "<td>" & strSort & "LastUpdate"">Last edit</td>"
response.write "<td>" & strSort & "Found"">Found since 2008</td>"

response.write "<td>Blog photo?</td><td>Lalaletter</td><td>Fortune</td></tr>"
do until rs.eof
	response.write "<td><a href=""edit.asp?CodeID=" & Replace(rs("CodeID"),"'","''") & """>" & rs("CodeID") & "</td>"
	response.write "<td>" & FormatDateTime(rs("LastUpdate"),vbShortDateTime) & "</td>"
	response.write "<td align='right'>" & rs("Found") & "</td>"
	response.write "<td>"
	if Not IsNull(rs("BlogURL")) then
		response.write "<a href=""" & rs("BlogURL") & """ target=""_blank"">Yes</a>"
	else
		response.write "No"
	end if
	response.write "<td>" & rs("Letter") & "</td>"
	response.write "<td>" & rs("Fortune") & "</td></tr>" & vbCrLf
	rs.Movenext
loop
rs.close
%>
</table>
</div>
</body>

</html>