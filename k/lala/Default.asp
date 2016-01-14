<!doctype HTML>
<html>

<%
Session("intYear")=2015
' Get summary statistics (lalas hidden, found, found-with-location)
set rs=server.createobject("adodb.recordset")
rs.CursorType = adOpenKeyset
rs.LockType = adLockOptimistic
rs.Open "spLalaSummary " & session("intYear"), Session("myADO")
iHidden = rs("Hidden")
iFound = rs("Found")
iFoundWithLocation = rs("FoundWithLocation")
rs.Close

%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width" />
<title>lalaletters admin</title>
<link title="style" rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">
	#summary {font-size:120%; background-color:white; border: 1px solid maroon; padding:4px 8px; width:220px;}
</style>
</head>

<body>

<div id="crumb">lalaletters admin (<%=Session("intYear")%>)</div>
<div id="content">
<ul>
    <li style="font-size:140%"><a href="../../lala/hide/default.asp">map the letters</a> (see private map
	<a href="../../lala/maps/private321.xml">XML</a>)</li>
    <li>show <a href="http://www.espressomap.com/lala/map.htm">public</a> map or <a href="http://www.espressomap.com/k/lala/mapall.htm">private map (all markers, found or not)</a></li>
    <li><a  title="who loves mink?" href="fortunes.asp">fortunes and letters</a>

      </li>
    <li><a href="codewords.asp">printable grid of codewords/numbers</a></li>
    <li><a target="_blank" href="http://lalaletters.blogspot.com/">blog</a> (opens in 
new window)</li>
	<li><a href="https://www.blogger.com/home">blog posts and 
	comments (need to be logged in to Google as finkaminka)</a></li>
	<li><a href="startup.htm">how to start each year</a></li>
    <li><a href="hiders.asp" title="edit/add hiders">hiders</a></li>
	</ul>
  <p id="summary"><%=iHidden%> letters hidden, <%=iFound%> found (of those, <%=iFoundWithLocation%> were mapped)</p></div>
</body>

</html>