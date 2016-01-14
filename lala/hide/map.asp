<!-- #include virtual="/espressomap/lala/updatexml.asp" -->
<!doctype HTML>

<html>

<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>locate lalaletter</title>
    <link title="style" rel="stylesheet" type="text/css" href="style.css">
<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=true"></script>
<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script src="jquery.cookie.js"></script>
<style type="text/css">
    html { height: 100% }
    body { height: 100%; margin: 0; padding: 0 }
/*    #map-canvas { height: 90% }*/
    #map-canvas {width:600px; height:430px;}
    #markerct {margin: 1em; }
    #infowindow { 
	    width:100px; height:100px;
		font-size:90%;
	}
    textarea {
            -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */
            -moz-box-sizing: border-box;    /* Firefox, other Gecko */
             box-sizing: border-box;         /* Opera/IE 8+ */
    }

</style>
</head>
<%
CodeID=Request("CodeID")

Sub upd(fld)
	if trim(request.form(fld))="" then
		rs(fld)=null
	else
		rs(fld)=request.form(fld)
	end if
End Sub

Dim rs, sSQL
set rs=server.createobject("adodb.recordset")
rs.CursorType = adOpenKeyset
rs.LockType = adLockOptimistic

sSQL = "SELECT * FROM tblLalaLocation WHERE intYear=" & Session("intYear") & " AND CodeID=" & CInt(CodeID)
sSQL1 = sSQL
rs.Open sSQL, Session("myADO")

' If user clicks "Save", write record to database
if request.form("cmdSave")<>"" then
	upd("Latitude")
	upd("Longitude")
	upd("MoreDescription")
    upd("Initials")
	rs.Update
	rs.close : set rs=nothing
    ' If user wants email updated, just email me (to prevent bots)
    if Request.Form("Email")<>"" then
        Dim objMail
		Set objMail=CreateObject("CDO.Message")
		With objMail
			Set .Configuration=Session("config")  ' from global.asa
			.From = """lalaletters"" <eric@espressomap.com>"
			.To="eschrepel@gmail.com"
            .Subject="add email address for " & Request.Form("Initials") & " as " & Request.Form("Email")
			.Send
		End With
		set objMail=nothing
    end if
        
    ' Update XML files used to populate Google maps (at /lala/map.htm) 
    UpdateXML   ' called from updatexml.asp <include>
	response.redirect "default.asp"
else
    ' Validate that initials and lala letter number range are in db
    set rsValidate=server.createobject("adodb.recordset") 
    rsValidate.CursorType = adOpenKeyset
    rsValidate.LockType = adLockOptimistic
    sSQL = "SELECT * FROM tblHider WHERE Initials='" & Trim(Left(Replace(Request("Initials"),"'","''"),5)) & "'"
    rsValidate.Open sSQL, Session("myADO")
    intCodeID = CInt(CodeID)
    if rsValidate.EOF Then
        ValidateFail = "Those initials aren't found in our list of hiders."
    else
        inRange1 = false
        if Not IsNull(rsValidate("CodeIDMin")) then
             inRange1 = (intCodeID>=rsValidate("CodeIDMin") AND intCodeID<=rsValidate("CodeIDMax"))
        end if
        inRange2 = false
        if Not IsNull(rsValidate("CodeIDMin2")) then
             inRange2 = (intCodeID>=rsValidate("CodeIDMin2") AND intCodeID<=rsValidate("CodeIDMax2"))
        end if
        inList = false
        if Not IsNull(rsValidate("CodeIDList")) then
            CodeIDArray = Split(Replace(rsValidate("CodeIDList")," ",""), ",")
            for each searchCodeID in CodeIDArray
                If StrComp(searchCodeID, intCodeID, 0) = 0 Then inList = true
            next
        end if
        if inRange1=false and inRange2=false and inList=false then
            ValidateFail = "The lala number you chose isn't in the collection of lala letters assigned to those initials."
        end if
    end if
    if ValidateFail<>"" then
        response.write "<div id='content'><p>" & ValidateFail & "</p><p><a href='default.asp'>Try again</a>, or contact " & _
            "<a href='mailto:finkaminka@gmail.com'>finkaminka@gmail.com</a> and we'll help you right quick.</p></div>"
        response.end
    else
        
        ' If the initials and letter number are valid, also check to see if tblHider should be updated with user-supplied
        ' city (if it changed)
        if (rsValidate("City")="" or rsValidate("City")<>Request("City")) then
            rsValidate("City")=Request("City")
            rsValidate.Update
        end if

        missingEmail = IsNull(rsValidate("Email")) or rsValidate("Email")=""       ' Display short form asking for email address below if we don't have it
    end if
    rsValidate.Close

end if
%>

<body>
<%
    ' Check for valid Code #
    if rs.RecordCount=0 then
        response.write "<div style='margin:2em'><h2>That lala number isn't valid. Are you sure that's what the number on the corner says?</h2>" & _
        "<h2><a href='javascript:history.back();'>&lt; return</a></h2></div>"
        response.end
    end if
%>
<div id="crumb"><a href="default.asp">choose
  lalaletter</a>  
</div>
<div id="content">
<form name="frm" action="#" onsubmit="showAddress(this.Location.value+',<%=Request("City")%>',true); return false">
<input type="hidden" name="CodeID" value="<%=rs("CodeID")%>">
    <p><b>Lalaletter # <%=rs("CodeID") & ": " & rs("Codeword")%></b></p>
<p><b>Street address or intersection </b>(don't include
&quot;<%=Request("City")%>&quot;)<b><br>
</b><input type="text" name="Location" size="39" value="<%=rs("Location")%>" tabindex="1">&nbsp; <input type="submit" value="put on map" name="cmdMap" tabindex="2">
(then zoom, and drag marker on map to more exact location)</p>
</form>
<div id="map-canvas"></div>
<form action="map.asp" name="frm2" method="POST">
<input type="hidden" name="CodeID" id="CodeID" value="<%=CodeID%>">
<input type="hidden" name="Latitude" id="Latitude" value="<%=rs("Latitude")%>">
<input type="hidden" name="Longitude" id="Longitude" value="<%=rs("Longitude")%>">
<input type="hidden" name="Initials" id="Initials" value="<%=Request("Initials")%>">
<p><strong>Optional: More notes</strong> (i.e. in the cute dog's collar)<br>
<textarea name="MoreDescription" rows="2" cols="35" tabindex="3"><%=rs("MoreDescription")%></textarea><br>
<%if missingEmail then%>    <p><strong>We don't have your email address; if you want notifications when these are found, provide it here</strong><br/>
    <input type="email" name="Email" size="39" value=""></p><% end if %>
<input type="submit" disabled="disabled" value="save location" name="cmdSave" tabindex="4">
<% 
rs.close: set rs=nothing
%></p>
</form>
</div>
<script type="text/javascript">

    // global variables
    var map = null;
    var marker = null;

    function createMarker(point) {
        map.setCenter(point);
        map.setZoom(17);
        if(marker){
            //if marker already was created change positon
            marker.setPosition(point);
        } else {
            marker = new google.maps.Marker({
                position: point,
                map: map,
                draggable: true
            });
        }
        
        document.frm2.cmdSave.disabled = false; // if there's a marker on the map, then enable "save this" button
        document.frm2.Latitude.value = marker.getPosition().lat();
        document.frm2.Longitude.value = marker.getPosition().lng();

        google.maps.event.addListener(marker, "dragend", function () {
            document.frm2.Latitude.value = this.getPosition().lat();
            document.frm2.Longitude.value = this.getPosition().lng();
        });
    }


    function initialize() {
        document.frm.Location.focus();  // put cursor in first field box
        geocoder = new google.maps.Geocoder();
        var lat;
        var long;
        var point;
        var marker;

        map = new google.maps.Map(document.getElementById('map-canvas'));

        // Do 1 of 3 things when loading map:

        // 1) If marker exists, center on marker
        if (document.frm2.Latitude.value.length != 0) {
            //console.log("marker exists");
            lat = parseFloat(document.frm2.Latitude.value);
            lng = parseFloat(document.frm2.Longitude.value);
            point = new google.maps.LatLng(lat, lng);
            createMarker(point);
        }
        // 2) If new marker, first try geolocating to center the map
        else if (navigator.geolocation) {
            console.log("geolocated");
            navigator.geolocation.getCurrentPosition(function(position) {
                point = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
                createMarker(point);
            }, function() {
        // 3) If geolocation fails, center on City
                console.log("city because geolocate failed");
                showAddress('<%=Request("City")%>', false)  // center on city but don't add a marker
            });
        }
    }
    

    function showAddress(address,addMarker) {
        geocoder.geocode({ 'address': address }, function (results, status) {
            console.log(results[0].geometry.location);
            if (status == google.maps.GeocoderStatus.OK) {
                if (addMarker) {
                    var marker = createMarker(results[0].geometry.location);
                } else {
                    map.setCenter(results[0].geometry.location);
                    map.setZoom(13);      // set higher-level zoom if no marker (assuming user needs more "looking around" room)
                }
            } else {
                alert(address + ' not found');
            }
        });
    }

    
    /* Resize map for mobile */
    function detectBrowser() {
      var useragent = navigator.userAgent;
      var mapdiv = document.getElementById("map-canvas");

      if (useragent.indexOf('iPhone') != -1 || useragent.indexOf('Android') != -1 ) {
        mapdiv.style.width = '330px';
        mapdiv.style.height = '330px';
      } else {
        mapdiv.style.width = '600px';
        mapdiv.style.height = '430px';
      }
    }

    google.maps.event.addDomListener(window, 'load', initialize);


    $(function () {
        detectBrowser();    /* resize map for mobile */
    });
</script>
</body>
</html>