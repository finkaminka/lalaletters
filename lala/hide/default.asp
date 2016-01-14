<!doctype HTML>
  
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width" />
<link title="style" rel="stylesheet" type="text/css" href="style.css">
<title>hide/map lala letters</title>
<script type="text/javascript">

    function ValidateForm(frm) {
        var val = frm.CodeID.value;
        if (val == null || val == "") {
            alert('Pick a lalaletter number between 1 and 4000.');
            frm.CodeID.focus();
            return false;
        }
        
        val = parseInt(val);
        if (val < 1 || 4000 < val) {
            alert('Pick a lalaletter between 1 and 4000.');
            frm.CodeID.focus();
            return false;
        }
        
        val = frm.City.value;
        if (val == null || val == "") {
            alert('Enter city/state/country (i.e. Portland, OR; Paris, France) near where you\'ll hide the lalas. That will center the map for you on the next step.');
            frm.City.focus();
            return false;
        }
        /* Update cookies if changes made, keep alive for 30 days */
        if ($.cookie("Initials") != $('#Initials').val()) {
            $.cookie("Initials", $('#Initials').val(), { expires: 30 });
        }
        
        if ($.cookie("City") != $('#City').val()) {
            $.cookie("City", $('#City').val(), { expires: 30 });
        }

        return true;
    }
</script>
<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script src="jquery.cookie.js"></script>

<style type="text/css">
    label {display:inline-block;width:9em;}
    #divfirsttime, #divupdate {display: none;}
    #divupdate {
        margin-top: 1em;
    }
</style>
</head>

<body>
<div id="crumb">&nbsp; </div>
<div id="content">
    <form name="frm" action="map.asp" method="POST" onsubmit="return ValidateForm(this);">
        <div id="divfirsttime">
            <h2>Welcome to lala letters!</h2>
            <p>Since this is your first time (on this device/computer), enter the Initials assigned to these lala letters, 
                your email address (if you'd like notifications when lalas are found), 
                and city near where you'll hide them.</p>
            <p>(You can unsubscribe from notifications at any time, but we think it's fun getting little "love was found!" notes.)</p>
        </div>
        <div id="divupdate">
            <label>Initials </label>
            <input type="text" name="Initials" size="7" id="Initials">&nbsp;&nbsp;&nbsp;(will 
                match the group of lala letters you're hiding)<br />
            <label>City/state/country </label>
            <input type="text" name="City" size="25" id="City">&nbsp; (i.e. Portland, OR; Paris, France; this centers the map near you)<br />
        </div>
        <br/><label>Lalaletter number </label>
	    <input type="number" min="1" max="2000" id="CodeID" name="CodeID" size="7">&nbsp;<input type="submit" value="next -&gt;" name="cmdNext">
    </form>
    <ul>
	    <li><a href="mapall.htm">see the map</a> (then hit Refresh to show new 
	    letters)</li>
        <li><a href="#" id="update">update Initials or City</a></li>
    </ul>
    <table><tr><td><img src="laladude.jpg"></td><td>Thanks for y'all's patience as we worked out a couple bugs. If you have any troubles at all in hiding the lala's, please email <a href="mailto:finkaminka@gmail.com">minka</a> and her technical geekboy will fix things tootsweet.</td></tr></table>
</div>
<script type="text/javascript">
    $(function () {
        /* If first time here, or returning because of validation errors, show fields for initials, City. Otherwise, populate those fields with existing cookie. */
        if ($.cookie("Initials") == null) {
            $('#divfirsttime').show();
            $('#divupdate').show();
            $('#Initials').focus();
            $('#update').parent().hide();
        } else {
            $('#Initials').val($.cookie("Initials"));
            $('#City').val($.cookie("City"));
            $('#CodeID').focus();
            $('#update').parent().show();
        }
    });

    $('#update').click(function (e) {
        e.preventDefault();
        $('#divupdate').show();
        $('#Initials').focus();
    });


</script>
</body>
</html>