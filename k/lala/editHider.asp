<!DOCTYPE html>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width" />
<link title="style" rel="stylesheet" type="text/css" href="style.css">
<title>edit hider</title>
<style type="text/css">
    form {
        margin-top: 1em;
    }
    label {display:inline-block;width:9em;}
</style>
<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>

</head>

<body>
<%
Sub upd(fld)
	if trim(request.form(fld))="" then
		rs(fld)=null
	else
		rs(fld)=request.form(fld)
	end if
End Sub

Function IIf(i,j,k)
    If i Then IIf = j Else IIf = k
End Function

Dim rs, sSQL, Initials
set rs=server.createobject("adodb.recordset")
rs.CursorType = adOpenKeyset
rs.LockType = adLockOptimistic

Initials=Replace(request("Initials"),"'","''")

' If user clicks "Delete", delete this fortune
if request("action")="delete" then	' Delete record
	sSQL = "spHiderDel '" & Initials & "'"
	set cn = server.createobject("adodb.connection")
   	cn.open Session("myADO")
   	cn.Execute sSQL, lngRecs, adCmdText OR adExecuteNoRecords
   	cn.close: set cn=nothing
	response.redirect "hiders.asp"
end if

sSQL = "SELECT * FROM tblHider WHERE Initials='" & Initials & "'"
rs.Open sSQL, Session("myADO")
if rs.EOF then rs.AddNew


' If user clicks "Save", write record to database
if request.form("cmdSave")<>"" then
	upd("Initials")
    upd("FullName")
	upd("Email")
    upd("City")
	upd("CodeIDMin")
	upd("CodeIDMax")
	upd("CodeIDMin2")
	upd("CodeIDMax2")
    upd("CodeIDList")
	rs.Update
	response.redirect "hiders.asp"
end if

%>
<div id="crumb"><a href="Default.asp">lalaletters admin</a>  
	<img src="../../images/arrow_white.gif" alt="arrow" width="13" height="6">  <a href="hiders.asp">hiders</a></div>
<div id="content">
<form name="frm" method="POST">
<label>Initials </label><input type="text" name="Initials" size="20" value="<%=Initials%>"><br/>
<label>Full name </label><input type="text" name="FullName" size="20" value="<%=rs("FullName")%>"><br/>
<label>Email </label><input type="email" name="Email" size="30" value="<%=rs("Email")%>"><br/>
<label>Starting lala # </label><input type="number" name="CodeIDMin" size="5" value="<%=rs("CodeIDMin")%>">  Ending lala # <input type="number" name="CodeIDMax" size="5" value="<%=rs("CodeIDMax")%>"><br/>
<label>2nd starting lala # </label><input type="number" name="CodeIDMin2" size="5" value="<%=rs("CodeIDMin2")%>">  2nd ending lala # <input type="number" name="CodeIDMax2" size="5" value="<%=rs("CodeIDMax2")%>"><br/>
<label>or List of lalas </label><input type="text" name="CodeIDList" size="50" value="<%=rs("CodeIDList")%>"> (separate with commas)<br/>

<label>City </label><input type="text" name="City" size="15" value="<%=rs("City")%>"> (hider can also edit this)<br/>
<label></label><input type="submit" value="save this" name="cmdSave">
<%
if Initials<>"" then
	response.write "&nbsp;&nbsp;<a href=""editHider.asp?action=delete&Initials=" & Initials & """ onclick=""return confirm('Delete this hider?');"">delete</a>"
else
	rs.CancelUpdate
end if

rs.close: set rs=nothing
%></form>
</div>

<script type="text/javascript">
    $(function () {
        $('#Initials').focus();
    });
</script>

</body>