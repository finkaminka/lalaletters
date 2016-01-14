<!doctype HTML >

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>edit fortune</title>
<link title="style" rel="stylesheet" type="text/css" href="style.css">
<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
</head>

<body onload="document.frm.Letter.focus();">
<%
Sub upd(fld)
	if trim(request.form(fld))="" then
		rs(fld)=null
	else
		rs(fld)=request.form(fld)
	end if
End Sub

Dim rs, sSQL, CodeID
set rs=server.createobject("adodb.recordset")
rs.CursorType = adOpenKeyset
rs.LockType = adLockOptimistic

CodeID=Replace(request("CodeID"),"'","''")      ' prevent SQL injection

' If user clicks "Delete", delete this fortune
if request("action")="delete" then	' Delete record
	sSQL = "spFortuneDel '" & CodeID & "'"
	set cn = server.createobject("adodb.connection")
   	cn.open Session("myADO")
   	cn.Execute sSQL, lngRecs, adCmdText OR adExecuteNoRecords
   	cn.close: set cn=nothing
	response.redirect "fortunes.asp"
end if

sSQL = "SELECT * FROM tblLala WHERE CodeID='" & CodeID & "'"
rs.Open sSQL, Session("myADO")
if rs.EOF then rs.AddNew


' If user clicks "Save", write record to database
if request.form("cmdSave")<>"" then
	upd("CodeID")
	upd("Fortune")
	upd("Letter")
	upd("BlogURL")
	rs("LastUpdate")=Date()
	rs.Update
	response.redirect "fortunes.asp"
end if

%>
<div id="crumb"><a href="Default.asp">lalaletters admin</a>  
	<img alt="arrow" src="../../images/arrow_white.gif" width="13" height="6">  <a href="fortunes.asp">fortunes</a></div>
<div id="content">
    <form name="frm" method="POST">
        <p><b>Code word </b><input type="text" name="CodeID" size="20" value="<%=CodeID%>"><b>:</b></p>
        <p><b>Lalaletter</b><br><textarea name="Letter" rows="3" cols="80"><%=rs("Letter")%></textarea></p>
        <p><b>Fortune</b><br><textarea name="Fortune" rows="3" cols="80"><%=rs("Fortune")%></textarea></p>
        <p>If there's a picture on the blog, enter the <b> URL</b>:<br>
        (should be something like 
        http://lalaletters.blogspot.com/2008/01/sweetlips.html)&nbsp;&nbsp;&nbsp; </p>
        <p><input type="text" name="BlogURL" size="73" value="<%=rs("BlogURL")%>"></p>
        <input type="submit" value="save this" name="cmdSave">
        <%
        if CodeID<>"" then
	        response.write "&nbsp;&nbsp;<a href=""edit.asp?action=delete&CodeID=" & CodeID & """ onclick=""return confirm('Delete this fortune?');"">delete</a>"
        else
	        rs.CancelUpdate
        end if

        rs.close
        %>
    </form>

    <script type="text/javascript">

        // Load the Visualization API and the piechart package.
        google.load('visualization', '1', { 'packages': ['corechart','table'] });

        // Set a callback to run when the Google Visualization API is loaded.
        google.setOnLoadCallback(drawChart);

        function drawChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string','year');
            data.addColumn('number','hidden');
            data.addColumn('number','found');
            data.addRows([
            <%

set rs=server.createobject("adodb.recordset")
sSQL = "exec spTotalForRoot '" & CodeID & "'"
rs.Open sSQL, Session("myADO")

if not rs.eof or not rs.bof then
do until rs.eof
%>    
 ['<%=rs("intYear")%>', <%=rs("Hidden")%>, <%=rs("Found")%> ]<%' place starting asp tag here for comma
          if not rs.eof then response.write "," end if 'add comma if more data is avail
rs.movenext
loop
end if
%>
            ]);

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
            chart.draw(data, { 
                title: 'Hidden and found history', 
                backgroundColor: 'transparent',
                fontName: 'trebuchet ms',
                fontSize: '13',
                chartArea: { width: '90%', height: '70%', left:30, top:40 },
                legend: { position: 'in'},
                hAxis: { format: '#', slantedText: true, slantedTextAngle: 90, showTextEvery: 1 },
                colors: ['#0066FF', '#FF3399']
            });
            
        }

    </script>
    <div id="chart_div" style="width: 500px; height: 300px"></div>

</div>
</body>
</html>

