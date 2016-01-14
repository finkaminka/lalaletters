<%
' Update /lala/maps/public.xml and /private321.xml for use in public (found lalas) and private (hidden lalas) maps
Sub UpdateXML()
	dim rsXML, sWhere, fs, fMap, sHTML
	set rsXML=server.createobject("adodb.recordset")
	set fs = CreateObject("Scripting.FileSystemObject")

	for iFile = 1 to 2	' loop twice: 1) public.xml, 2) private321.xml (includes codeword and unfound letters)
		if iFile = 1 then 
			sWhere = " AND FoundDate IS NOT NULL"
			sFile = "public.xml"
		else
			sWhere = ""
			sFile = "private321.xml"
		end if
		rsXML.Open "SELECT * FROM tblLalaLocation WHERE intYear=" & Session("intYear") & " AND Latitude IS NOT NULL" & sWhere, Session("myADO")

		set fMap = fs.CreateTextFile(Server.MapPath("/") & "\espressomap\lala\maps\" & sFile,true) 
		fMap.Writeline("<?xml version=""1.0"" encoding=""UTF-8""?>")
		fMap.Writeline("<markers>")
	
		
        Do Until rsXML.EOF
			dt = rsXML("FoundDate")
			' Create clear markers for hidden/not found, and red for found
            if IsNull(dt) then
				sColor="clear"
			else
				sColor="red"
			end if
			sHTML = "<marker id=""" & rsXML("CodeID") & """ lat=""" & rsXML("Latitude") & """ lng=""" & rsXML("Longitude") & """ color=""" & sColor & """>" & vbCrLf & _
				"  <desc><![CDATA["
			if iFile = 2 then sHTML = sHTML & rsXML("Root")& " #"& rsXML("CodeID") & ": "
		   If rsXML("FoundDate")<>"" then sHTML = sHTML & monthname(month(dt),True) & " " & day(dt)
			If rsXML("MoreDescription")<>"" then sHTML = sHTML & " - " & Server.HTMLEncode(rsXML("MoreDescription"))
			fMap.Writeline(sHTML & "]]></desc>" & vbCrLf & "</marker>") 
			rsXML.MoveNext
		Loop
    
		fMap.Writeline("</markers>")
		fMap.Close: set fMap=nothing

		rsXML.close

	next
	set fs=nothing: set rsXML=nothing
End Sub
%>
