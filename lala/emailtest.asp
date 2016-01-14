<!DOCTYPE html >
<html>

<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<title>Untitled 1</title>
</head>

<body>
<%
	Set objMail=CreateObject("CDO.Message")
	With objMail
		Set .Configuration=Session("config")  ' from global.asa

		.From="eschrepel@espressomap.com"
		.To = "eschrepel@gmail.com" 
		.Subject="testing2 from eric via espressomap"
		.TextBody="test email"
		.Send
	End With
	set objMail=nothing
%>

<p>Message sent.</p>

</body>

</html>
