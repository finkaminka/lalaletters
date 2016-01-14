<!-- #include file="updatexml.asp" -->
<!doctype HTML>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>your love fortune...</title>
<style type="text/css">
    body {width: 450px; margin: 1em auto; line-height: 1.4em; text-align: center; background-color:#FFDDF4; font-size: 14pt; font-family: georgia, "times new roman", times}
    div#content {text-align:left; background-color:white; width:450px; border: 2px solid purple; padding: 1em 8px}
    #close {margin-top:1em; font-size:10pt}
    #close a {color:#999}
    .blush {font-size: 10pt; margin:1.5em 0; padding: 0 1em; color:maroon; border-top:1px dotted maroon; border-bottom: 1px dotted maroon;}
    .blush p {margin:.25em 0}
</style>
</head>

<body>
<div id="content">
<%
' If this was a "lost" letter and user told us where it was found, email us that info, then redirect user back to blog
if InStr(request.form,"FoundLocation=") > 0 then
	if request.form("FoundLocation")<>"" then
		Dim objMail
		Set objMail=CreateObject("CDO.Message")
		With objMail
			Set .Configuration=Session("config")  ' from global.asa
			.From = """lalaletters"" <eric@espressomap.com>"
			.To="finkaminka@gmail.com"
			'.CC = "eschrepel@gmail.com"
            .Subject="add " & request.form("CodeID") & " to the map"
			.HTMLBody = "<a href=""http://www.espressomap.com/lala/hide/map.asp?CodeID=" & request.form("CodeID") & """>map it</a> as " & request.form("FoundLocation")
			.Send
		End With
		set objMail=nothing
	end if
	response.redirect request.form("url")
end if
	
sCode = replace(lcase(request.form("CodeID"))," ","")	' remove spaces & underscores (just in case)
sCode = replace(sCode,"_","")

set rs=server.createobject("adodb.recordset")
sSQL = "spLala '" & Replace(sCode,"'","''") & "', " & Session("intYear")

rs.Open sSQL, Session("myADO")
sURL = "http://lalaletters.blogspot.com/"


if rs.EOF then 
	response.write "didn't find that code word in our love files, but good fortune smiles on you anyway, valentine!"
else
	sFortune = rs("Fortune")
	if not IsNull(rs("BlogURL")) then sURL = rs("BlogURL")

	if IsNull(sFortune) then
		response.write "code word's great, but our fortune teller is still pondering. come back later today; you'll get yours for sure!"
		sFortune = "oh no - no fortune - write one quick (and post a photo, too)!"
	else
		response.write sFortune
		if rs("Latitude")<>"" then
			UpdateXML	' update XML file for google maps from #include of updatexml.asp
		else
			sHTML = "<div class=""blush""><p><b>oh no!</b> we forgot where we hid your lalaletter (less drinking!).</p>" &_
			"<p>if you want it mapped, tell us the codeword and where you found it.</p></div>"
		end if
		response.write sHTML
	end if

	blnUpdated=rs("blnUpdated")

	if blnUpdated=1 then		' only send us email notification if this is 1st time user has submitted their lalaletter
		Dim objMail2
		Set objMail2=CreateObject("CDO.Message")
		With objMail2
			Set .Configuration=Session("config")  ' from global.asa
			.From = """lalaletters"" <eric@espressomap.com>"
			.To="finkaminka@gmail.com"
            .Bcc=rs("Email")
			.Subject="found: " & sCode & " (letter #" & rs("CodeID") & ")"
			sURLmap = "<a href='http://www.espressomap.com/lala/map.htm?lat=" & rs("Latitude") & "&lng=" & rs("Longitude") & "'>"
			sBody = "<p>so they read this lalaletter:</p><blockquote>"& rs("Letter") & "</blockquote>" & _
			"<p>and got this fortune:</p><blockquote>"& sFortune & "</blockquote>"
			if rs("Latitude")<>"" then
				sBody = sBody & "<p>" & sURLMap & "see it on the map</a> (" & rs("MoreDescription") & ")</p>"
			else
				sBody = sBody & "<p style='color:red'>" & sURLmap & "LOST!</a>. Hopefully they'll tell us where it was found, and we'll map it later.</p>"
			end if
			.HTMLBody = sBody
			.Send
		
		End With
	end if

end if
rs.close
set rs=nothing
%>
<div id="close"><p><a href="<%=sURL%>">&lt; now, one last fortune!</a>
<br/>(and tell me something, valentine. whisper something sweet!)</p>
</div>
</div>
</body>

</html>
