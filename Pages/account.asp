<%
EMAIL = Request.Form("txtEmail")

Response.Buffer = true
Response.ExpiresAbsolute = now() - 1
Response.Expires = 0
Response.CacheControl = "no-cache"
'Response.AddHeader "Content-Type", "text/xml"
Response.AddHeader "Access-Control-Allow-Origin", "*"

SERVERIP = "."
CONNECT = "Driver={SQL Server};Server=" & SERVERIP & ";Uid=ali;Pwd=ali;Initial Catalog=Pavilion"
set conn=server.createobject("adodb.connection")
conn.Open CONNECT

Function RunSQL(ByVal sql,ByRef myRS)
	On Error Resume Next
	if lcase(left(trim(sql),6)) = "select" then
			set myRS = server.CreateObject("adodb.recordset")
			myRS.CursorLocation = 3
			myRS.CursorType = 3
			myRS.LockType = 4
			myRS.ActiveConnection = conn
			myRS.open sql
	else
		select case lcase(left(trim(sql),6))
			case "update", "delete"
				if instr(lcase(sql),"where") = 0 then
					response.write "Dork, you tried to run a "& lcase(left(trim(sql),6)) &" query without the where clause!"
					boolDoNotRunQuery = true
					response.end
				end if
		end select
		if boolDoNotRunQuery <> true then
			set myRS = conn.Execute(sql)
		end if
	end if
	if err.number <> 0 then
		Response.Clear
		Response.Write "Error Occured:<BR><BR>"
		Response.Write "Error # " & CStr(Err.Number) & " " & Err.Description & "<BR>" 
		Response.Write "SQL = " & sql & "<BR>"	
		Response.End
	End if
	On Error Goto 0	
end Function

sql = "select MemberID,FirstName,LastName,Street,City,State,ZipCode,EmailAddress "
sql = sql & "from Member where EmailAddress = '" & EMAIL & "' "

sql = "select m.MemberID,mc.MemberCardID,mc.CardNumber,ExpirationMonth,ExpirationYear "
sql = sql & "from PavilionMembership..MemberCard mc "
sql = sql & "join PavilionMembership..Member m on mc.MemberID = m.MemberID "
sql = sql & "where EmailAddress = '" & EMAIL & "' "
sql = sql & "and mc.IsActive = 1 "

call RunSQL(sql,rsMember)
if rsMember.EOF then
    Response.Redirect "preview.html"
else
    MEMBERID = rsMember("MemberID")
    MEMBERCARDID = rsMember("MemberCardID")
    CARDNUMBER = rsMember("CardNumber")
    EXPMONTH = rsMember("ExpirationMonth")
    EXPYEAR = rsMember("ExpirationYear")
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Nutrition Pavilion</title>
        <link href="styles/nutrition.css" rel="stylesheet" type="text/css" />
        <link href="styles/moodalbox.css" rel="stylesheet" type="text/css" />
        <link href="styles/navigation.css" rel="stylesheet" type="text/css" />
	    <link href="styles/jquery.validate.css" rel="stylesheet" type="text/css" />
	    <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
	    <script type="text/javascript" src="js/jquery.validate.js"></script>
    </head>

    <script type="text/javascript">

        serviceURL = "http://50.62.141.147:81/test.asp";

        function isValidDate(year, month, day) {
            var date = new Date(year, (month - 1), day);
            var DateYear = date.getFullYear();
            var DateMonth = date.getMonth();
            var DateDay = date.getDate();
            if (DateYear == year && DateMonth == (month - 1) && DateDay == day)
                return true;
            else
                return false;
        }

        function isNumber(n) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        }

        $(function() {
            $("#LastName").validate({
                expression: "if (VAL) return true; else return false;",
                message: "Cannot be blank"
            });
            $("#FirstName").validate({
                expression: "if (VAL) return true; else return false;",
                message: "Cannot be blank"
            });
            $("#Email").validate({
                expression: "if (VAL.match(/^[^\\W][a-zA-Z0-9\\_\\-\\.]+([a-zA-Z0-9\\_\\-\\.]+)*\\@[a-zA-Z0-9_]+(\\.[a-zA-Z0-9_]+)*\\.[a-zA-Z]{2,4}$/)) return true; else return false;",
                message: "Should be a valid Email id"
            });
            $("#HomePhone").validate({
                expression: "if (VAL.match(/^[0-9]{10}$/)) return true; else return false;",
                message: "Must be exactly ten digits such as: 3108281234"
            });
            $("#ConfirmEmail").validate({
                expression: "if (VAL == $('#Email').val() && VAL) return true; else return false;",
                message: "Confirm email does not match email field"
            });
            $("#txtAmount").validate({
                expression: "if (isNumber(VAL)) return true; else return false;",
                message: "Must be numeric"
            });
            $('.AdvancedForm').validated(function() {
                saveMember();
            });
            $('.LoadFundsForm').validated(function() {
                fnAuthorize();
            });
        });
        
        function showPanel(thechosenone) {
            $('.panel:visible').fadeOut('slow', function() {
                $('#' + thechosenone).fadeIn('slow');
            });
        }

        function fnLoadFunds() {
            //this uses a bogus method for testing purposes
            xmlhttp = new XMLHttpRequest();
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState < 4) {
                    authorizeLoad();
                } else {
                    displayResult();
                }
            }
            sParam = 'Query=LoadFunds';
            sParam += '&amount=' + $('#txtAmount').val();
            sParam += '&memberid=' + $('#txtMemberID').val();
            xmlhttp.open("POST", serviceURL, true);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send(sParam);
        }

        function fnAuthorize() {
            authorizeLoad();
            xmlHTTP = new XMLHttpRequest();
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }

            ServiceUrl = 'http://50.62.141.147:99/WebServices/MemberSvc.asmx';
            //ServiceUrl = 'http://pavtest.azurewebsites.net/WebServices/MemberSvc.asmx';
            soapMessage =
            '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"> \
            <soap:Body> \
            <Reload xmlns="http://tempuri.org/"> \
            <request> \
            <MemberCardID>' + <%=MEMBERCARDID %> + '</MemberCardID> \
            <Amount>' + Number($('#txtAmount').val()).toFixed(2) + '</Amount> \
            <CardNumber>' + $('#txtCardNumber').val() + '</CardNumber> \
            <MachineSerialNumber>Website</MachineSerialNumber> \
            <PaymentType>CreditCard</PaymentType> \
            <IsLoadedViaMachine>0</IsLoadedViaMachine> \
            <Expiration>' + $('#cmbExpireMonth').val() + $('#cmbExpireYear').val().substring(2,4) + '</Expiration> \
            <FName>' + $('#txtFirstName').val() + '</FName> \
            <LName>' + $('#txtLastName').val() + '</LName> \
            <Address>' + $('#txtAddress').val() + '</Address> \
            <City>' + $('#txtCity').val() + '</City> \
            <State>' + $('#cmbState').val() + '</State> \
            <Zip>' + $('#txtZip').val() + '</Zip> \
            <CVV2>796</CVV2> \
            </request> \
            </Reload> \
            </soap:Body> \
            </soap:Envelope>';

            xmlHTTP.open("POST", ServiceUrl, true);
            xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
            xmlHTTP.setRequestHeader("SOAPAction", "http://tempuri.org/Reload");
            xmlHTTP.onreadystatechange = function() {
                if (xmlHTTP.readyState < 4) {
                    authorizeLoad();
                } else {
                    sResponseMessage = $(xmlHTTP.responseXML).find('ResponseMessage').text();
                    sApprovedAmount = $(xmlHTTP.responseXML).find('ApprovedAmount').text();
                    sErrorMessage = $(xmlHTTP.responseXML).find('ErrorMessage').text();
                    sOut = '';
                    sOut += '<p><h3>' + sResponseMessage + '</h3></p>';
                    if (sApprovedAmount.length > 0) sOut += '<p>Approved Amount: ' + sApprovedAmount + '</p>';
                    if (sErrorMessage.length > 0) sOut += '<p>Error Message: ' + sErrorMessage + '</p>';
                    if (sResponseMessage == 'Approved') {
                        sOut += '<p>Thank you for your business. Please check your Transaction History.</p>';
                    } else {
                        sOut += '<p>Please contact our office for assistance.</p>';
                    }
                    $('#divAuthorizeResult').html(sOut);
                    displayResult();
                }
            }
            xmlHTTP.send(soapMessage);
        }

        function fnGetMember() {
            xmlHTTP = new XMLHttpRequest();
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }

            ServiceUrl = 'http://50.62.141.147:99/WebServices/MemberSvc.asmx';
            soapMessage =
            '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"> \
            <soap:Body> \
            <GetMemberInfo xmlns="http://tempuri.org/"> \
            <request> \
            <CardNumber>' + <%=CARDNUMBER %> + '</CardNumber> \
            <ExpirationMonth>' + <%=EXPMONTH %> + '</ExpirationMonth> \
            <ExpirationYear>' + <%=EXPYEAR %> + '</ExpirationYear> \
            </request> \
            </GetMemberInfo> \
            </soap:Body> \
            </soap:Envelope>';

            xmlHTTP.open("POST", ServiceUrl, true);
            xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
            xmlHTTP.setRequestHeader("SOAPAction", "http://tempuri.org/GetMemberInfo");
            xmlHTTP.onreadystatechange = function() {
                if (xmlHTTP.readyState < 4) {
                    //authorizeLoad();
                } else {
                    $('#LastName').val($(xmlHTTP.responseXML).find('LastName').text());
                    $('#FirstName').val($(xmlHTTP.responseXML).find('FirstName').text());
                    $('#Street').val($(xmlHTTP.responseXML).find('Street').text());
                    $('#City').val($(xmlHTTP.responseXML).find('City').text());
                    $('#State').val($(xmlHTTP.responseXML).find('State').text());
                    $('#Zip').val($(xmlHTTP.responseXML).find('ZipCode').text());
                    $('#Email').val($(xmlHTTP.responseXML).find('EmailAddress').text());
                    sBalance = '<h3>';
                    sBalance += $('#FirstName').val() + ' ' + $('#LastName').val();
                    sBalance += "'s Balance: $" + Number($(xmlHTTP.responseXML).find('CardBalance').text()).toFixed(2);
                    sBalance += '</h3>';
                    $('#spanBalance').html(sBalance);
                    fnGetTransactions();
                }
            }
            xmlHTTP.send(soapMessage);
        }

        function fnExpand(sThisID) {
            $('.divTrans:visible').slideToggle('slow');
            xmlhttp = new XMLHttpRequest();
            bReturn = false;
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    if (window.DOMParser) {
                        parser = new DOMParser();
                        xmlResponse = parser.parseFromString(xmlhttp.responseText, "text/xml");
                    }
                    else {
                        xmlResponse = new ActiveXObject("Microsoft.XMLDOM");
                        xmlResponse.async = "false";
                        xmlResponse.loadXML(xmlhttp.responseText);
                    }
                    sTable = '<table style="margin-left:2em">';
                    sTable += '<tr><th class="cellleft">Item</th>';
                    sTable += '<th class="transcell cellright">Price</th>';
                    sTable += '<th class="transcell cellright">Quantity</th></tr>';
                    $('transdetail', xmlResponse).find('record').each(function() {
                        sTable += '<tr>';
                        sTable += '<td>' + $(this).find('ProductName').text() + '</td>';
                        sTable += '<td class="transcell cellright">' + Number($(this).find('Price').text()).toFixed(2) + '</td>';
                        sTable += '<td class="transcell cellright">' + $(this).find('Qty').text() + '</td>';
                        sTable += '</tr>';
                    })
                    sTable += '</table>';
                    $('.divTrans' + sThisID).html(sTable);
                    $('.divTrans' + sThisID).slideToggle('slow');
                }
            }
            sParam = 'Query=TransactionDetail';
            sParam += '&transid=' + sThisID;
            xmlhttp.open("POST", serviceURL, false);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send(sParam);
        }
        
        function fnGetTransactions() {
            xmlhttp = new XMLHttpRequest();
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status != 200) {
                    $('#lblLoginError').html('Could not log in.');
                    //logOut();
                } else if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    $('#lblLoginError').html('');

                    if (window.DOMParser) {
                        parser = new DOMParser();
                        xmlResponse = parser.parseFromString(xmlhttp.responseText, "text/xml");
                    }
                    else {
                        xmlResponse = new ActiveXObject("Microsoft.XMLDOM");
                        xmlResponse.async = "false";
                        xmlResponse.loadXML(xmlhttp.responseText);
                    }

                    sOut = '<tr>';
                    sOut += '<th class="transcell cellleft">Transaction</th>';
                    sOut += '<th class="transcell cellright">Date</th>';
                    sOut += '<th class="transcell cellright">Amount</th>';
                    sOut += '</tr>';
                    $('transactions', xmlResponse).find('record').each(function() {
                        bPayment = ($(this).find('TransType').text() == '1');
                        sOut += '<tr>';
                        sOut += '<td class="transcell cellleft">';
                        if (bPayment) {
                            sOut += '<a href="javascript:fnExpand(' + $(this).find('TransID').text() + ');">';
                        }
                        sOut += $(this).find('Label').text();
                        if (bPayment) {
                            sOut += '</a>';
                        }
                        sOut += '</td>';
                        sOut += '<td class="transcell cellright">' + $(this).find('TransTime').text() + '</td>';
                        sOut += '<td class="transcell cellright">' + Number($(this).find('TransAmount').text()).toFixed(2) + '</td>';
                        sOut += '</tr>';
                        if (bPayment) {
                            sOut += '<tr><td colspan="3">';
                            sOut += '<div class="divTrans divTrans' + $(this).find('TransID').text() + '" style="display:none">';
                            sOut += $(this).find('TransID').text();
                            sOut += '</div></td></tr>';
                        }
                    })
                    $('#tableLedger').html(sOut);
                }
            }
            sParam = 'Query=Transactions';
            sParam += '&membercardid=<%=MEMBERCARDID%>';
            xmlhttp.open("POST", serviceURL, false);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send(sParam);
        }
        function fnFetch() {
            xmlhttp = new XMLHttpRequest();
            bReturn = false;
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status != 200) {
                    $('#lblLoginError').html('Could not log in.');
                    //logOut();
                } else if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    $('#lblLoginError').html('');

                    if (window.DOMParser) {
                        parser = new DOMParser();
                        xmlResponse = parser.parseFromString(xmlhttp.responseText, "text/xml");
                    }
                    else {
                        xmlResponse = new ActiveXObject("Microsoft.XMLDOM");
                        xmlResponse.async = "false";
                        xmlResponse.loadXML(xmlhttp.responseText);
                    }

                    $('#txtMemberID').val($('member', xmlResponse).find('record').find('MemberID').text());
                    $('#LastName').val($('member', xmlResponse).find('record').find('LastName').text());
                    $('#FirstName').val($('member', xmlResponse).find('record').find('FirstName').text());
                    $('#Street').val($('member', xmlResponse).find('record').find('Street').text());
                    $('#City').val($('member', xmlResponse).find('record').find('City').text());
                    $('#State').val($('member', xmlResponse).find('record').find('State').text());
                    $('#Zip').val($('member', xmlResponse).find('record').find('ZipCode').text());
                    $('#Email').val($('member', xmlResponse).find('record').find('EmailAddress').text());

                    sBalance = '<h3>';
                    sBalance += $('#FirstName').val() + ' ' + $('#LastName').val();
                    sBalance += "'s Balance: $" + Number($('mybalance', xmlResponse).find('Balance').text()).toFixed(2);
                    sBalance += '</h3>';
                    $('#spanBalance').html(sBalance);

                    sOut = '<tr>';
                    sOut += '<th class="transcell cellleft">Transaction</th>';
                    sOut += '<th class="transcell cellright">Date</th>';
                    sOut += '<th class="transcell cellright">Amount</th>';
                    sOut += '</tr>';
                    $('transactions', xmlResponse).find('record').each(function() {
                        bPayment = ($(this).find('TransType').text() == '1');
                        sOut += '<tr>';
                        sOut += '<td class="transcell cellleft">';
                        if (bPayment) {
                            sOut += '<a href="javascript:fnExpand(' + $(this).find('TransID').text() + ');">';
                        }
                        sOut += $(this).find('Label').text();
                        if (bPayment) {
                            sOut += '</a>';
                        }
                        sOut += '</td>';
                        sOut += '<td class="transcell cellright">' + $(this).find('TransTime').text() + '</td>';
                        sOut += '<td class="transcell cellright">' + Number($(this).find('TransAmount').text()).toFixed(2) + '</td>';
                        sOut += '</tr>';
                        if (bPayment) {
                            sOut += '<tr><td colspan="3">';
                            sOut += '<div class="divTrans divTrans' + $(this).find('TransID').text() + '" style="display:none">';
                            sOut += $(this).find('TransID').text();
                            sOut += '</div></td></tr>';
                        }
                    })
                    $('#tableLedger').html(sOut);

                    if ($('member', xmlResponse).find('record').find('MemberID').text() == '') {
                        $('#lblLoginError').html('Account not found.');
                    } else {
                        bReturn = true;
                    }
                }
            }
            sParam = 'Query=Member';
            sParam += '&email=<%=EMAIL%>';
            xmlhttp.open("POST", serviceURL, false);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send(sParam);
            return bReturn;
        }
        
        function saveMember() {
            sSave = '<payload>';
            sSave += '<MemberID>' + <%=MEMBERID %> + '</MemberID>';
            sSave += '<LastName>' + $('#LastName').val() + '</LastName>';
            sSave += '<FirstName>' + $('#FirstName').val() + '</FirstName>';
            sSave += '<Street>' + $('#Street').val() + '</Street>';
            sSave += '<City>' + $('#City').val() + '</City>';
            sSave += '<State>' + $('#State').val() + '</State>';
            sSave += '<Zip>' + $('#Zip').val() + '</Zip>';
            sSave += '<Email>' + $('#Email').val() + '</Email>';
            sSave += '</payload>';

            xhSave = new XMLHttpRequest();
            xhSave.onreadystatechange = function() {
                if (xhSave.readyState == 4 && xhSave.status == 200) {
                    fnGetMember();
                    var objToday = new Date(),
				curDay = objToday.getDate(),
				curMonth = objToday.getMonth() + 1,
				curYear = objToday.getFullYear(),
				curHour = objToday.getHours() > 12 ? objToday.getHours() - 12 : (objToday.getHours() < 10 ? "0" + objToday.getHours() : objToday.getHours()),
				curMinute = objToday.getMinutes() < 10 ? "0" + objToday.getMinutes() : objToday.getMinutes(),
				curSeconds = objToday.getSeconds() < 10 ? "0" + objToday.getSeconds() : objToday.getSeconds(),
				curMeridiem = objToday.getHours() >= 12 ? "PM" : "AM";
                    var today = curHour + ":" + curMinute + ":" + curSeconds + " " + curMeridiem + " " + curMonth + "/" + curDay + "/" + curYear;
                    $('#lblLastSaved').html('Last saved ' + today);
                }
            }
            sParam = 'Query=SaveMember';
            sParam += '&payload=' + encodeURIComponent(sSave);
            xhSave.open("POST", serviceURL, true);
            xhSave.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhSave.send(sParam);
        }

        function authorizeLoad() {
            $('#panelCardInfo').hide();
            $('#panelLoadFunds').hide();
            $('#panelLoading').show();
        }

        function displayResult() {
            fnGetMember();
            $('#panelCardInfo').hide();
            $('#panelLoadFunds').show();
            $('#panelLoading').hide();
        }

        function displayLoadFunds() {
            $('#panelCardInfo').show();
            $('#panelLoading').hide();
            $('#panelLoadFunds').hide();
        }
        
    </script>


    <body onload="fnGetMember();">
    
        <div id="wrapper">
        
            <div id="top-border"></div>
            
            <div id="nav">
            
                <div style="margin-left:45px">
                    <ul>
                        <li><a href="javascript:showPanel('panelAccount');">Account Information</a></li>
                        <li><a href="javascript:showPanel('panelLedger');">Transaction History</a></li>
                        <li><a href="javascript:showPanel('panelLoad');">Load Funds</a></li>
                        <li><a href="preview.html">Logout</a></li>
                    </ul>
                </div>
                
            </div>
            
            <div id="content">
                <div id="copy">

                    <div class="center panel panelShowInit" id="panelAccount">
                        <h1>Account Information</h1><br />
                        <form action="" method="post" class="AdvancedForm">
                            <div class="panelRightDiv">
                                <input type="submit" class="panelbutton" value="Save Changes" />
                                <input id="txtMemberID" type="hidden" /><br />
                                <label id="lblLastSaved"></label>
                            </div>
                            <table cellpadding=4em>
						        <tr>
							        <td>First Name</td>
							        <td class="padcell">
								        <input name="FirstName" id="FirstName" class="panelinput" /></td>
						        </tr>
						        <tr>
							        <td class=medium>Last Name</td>
							        <td class="padcell"><input name="LastName" id="LastName" class="panelinput" /></td>
						        </tr>
                                <tr>
							        <td class=medium>Email</td>
							        <td class="padcell"><input name="Email" id="Email" class="panelinput" /></td>
						        </tr>
                                <tr>
							        <td class=medium>Address</td>
							        <td class="padcell"><input name="Street" id="Street" class="panelinput" /></td>
						        </tr>
						        <tr>
							        <td>City</td>
							        <td class="padcell">
								        <input name="City" id="City" class="panelinput" />
							        </td>
						        </tr>
						        <tr>
							        <td>State</td>
							        <td class="padcell">
								        <input name="State" id="State" class="panelinput" />
							        </td>
						        </tr>
						        <tr>
							        <td>Zip</td>
							        <td class="padcell">
								        <input name="Zip" id="Zip" class="panelinput" />
							        </td>
						        </tr>

					        </table>
                        </form>
                    </div>
            
                    <div class="center panel" id="panelLedger">
                        <h1>Transaction History</h1><br />
                        <span id="spanBalance"><h3>balance</h3></span>
                        <div id="divTransactions">
                            <table id="tableLedger"></table>
                        </div>
                    </div>

                    <div class="center panel" id="panelLoad">
                        <h1>Load Funds</h1><br />
                        <div id="panelCardInfo">
                            <form action="" method="post" class="LoadFundsForm">
                                <div class="panelRightDiv">
                                    <input type="submit" class="panelbutton" value="Authorize" />
                                </div>
                                <table>
                                    <tr>
                                        <td>Amount to Load</td>
                                        <td class="padcell"><input id="txtAmount" class="panelinput" value="1.23" style="width:55px" /></td>
                                    </tr>
                                    <tr>
                                        <td>Card Number</td>
                                        <td class="padcell"><input id="txtCardNumber" class="panelinput" /></td>
                                    </tr>
                                    <tr>
                                        <td>Expiration Date</td>
                                        <td class="padcell">
                                            <select id="cmbExpireMonth" class="panelinput" style="width:75px">
                                                <option>01</option>
                                                <option>02</option>
                                                <option>03</option>
                                                <option>04</option>
                                                <option>05</option>
                                                <option>06</option>
                                                <option>07</option>
                                                <option>08</option>
                                                <option>09</option>
                                                <option>10</option>
                                                <option>11</option>
                                                <option>12</option>
                                            </select>
                                            <select id="cmbExpireYear" class="panelinput" style="width:75px">
                                                <option>2014</option>
                                                <option>2015</option>
                                                <option>2016</option>
                                                <option>2017</option>
                                                <option>2018</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Cardholder First Name</td>
                                        <td class="padcell"><input id="txtFirstName" class="panelinput" /></td>
                                    </tr>
                                    <tr>
                                        <td>Cardholder Last Name</td>
                                        <td class="padcell"><input id="txtLastName" class="panelinput" /></td>
                                    </tr>
                                    <tr>
                                        <td>Address</td>
                                        <td class="padcell"><input id="txtAddress" class="panelinput" /></td>
                                    </tr>
                                    <tr>
                                        <td>City</td>
                                        <td class="padcell"><input id="txtCity" class="panelinput" /></td>
                                    </tr>
                                    <tr>
                                        <td>State, Zip</td>
                                        <td class="padcell">
                                            <select id="cmbState" class="panelinput" style="width:75px">
                                                <option value="AL">AL</option><br />
                                                <option value="AK">AK</option><br />
                                                <option value="AZ">AZ</option><br />
                                                <option value="AR">AR</option><br />
                                                <option value="CA" selected="selected">CA</option><br />
                                                <option value="CO">CO</option><br />
                                                <option value="CT">CT</option><br />
                                                <option value="DE">DE</option><br />
                                                <option value="DC">DC</option><br />
                                                <option value="FL">FL</option><br />
                                                <option value="GA">GE</option><br />
                                                <option value="HI">HI</option><br />
                                                <option value="ID">ID</option><br />
                                                <option value="IL">IL</option><br />
                                                <option value="IN">IN</option><br />
                                                <option value="IA">IA</option><br />
                                                <option value="KS">KS</option><br />
                                                <option value="KY">KY</option><br />
                                                <option value="LA">LA</option><br />
                                                <option value="ME">ME</option><br />
                                                <option value="MD">MD</option><br />
                                                <option value="MA">MA</option><br />
                                                <option value="MI">MI</option><br />
                                                <option value="MN">MN</option><br />
                                                <option value="MS">MS</option><br />
                                                <option value="MO">MO</option><br />
                                                <option value="MT">MT</option><br />
                                                <option value="NE">NE</option><br />
                                                <option value="NV">NV</option><br />
                                                <option value="NH">NH</option><br />
                                                <option value="NJ">NJ</option><br />
                                                <option value="NM">NM</option><br />
                                                <option value="NY">NY</option><br />
                                                <option value="NC">NC</option><br />
                                                <option value="ND">ND</option><br />
                                                <option value="OH">OH</option><br />
                                                <option value="OK">OK</option><br />
                                                <option value="OR">OR</option><br />
                                                <option value="PA">PA</option><br />
                                                <option value="RI">RI</option><br />
                                                <option value="SC">SC</option><br />
                                                <option value="SD">SD</option><br />
                                                <option value="TN">TN</option><br />
                                                <option value="TX">TX</option><br />
                                                <option value="UT">UT</option><br />
                                                <option value="VT">VT</option><br />
                                                <option value="VA">VA</option><br />
                                                <option value="WA">WA</option><br />
                                                <option value="WV">WV</option><br />
                                                <option value="WI">WI</option><br />
                                                <option value="WY">WY</option><br />
                                            </select>
                                            <input id="txtZip" class="panelinput" style="width:55px" />
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <img src="images/credit_card_logos_10.gif" />
                        </div>
                        <div id="panelLoading" style="display:none;">
                            <img src="img/loading.gif" style="float:left;" />
                            <p style="padding-left:5em;">
                                Please do not navigate away from this page.<br />
                                Processing may take a few minutes.
                            </p>
                        </div>
                        <div id="panelLoadFunds" style="display:none;">
                            <div class="panelRightDiv">
                                <input type="button" onclick="displayLoadFunds();" class="panelbutton" value="Load More Funds" />
                            </div>
                            <p><div id=divAuthorizeResult></div></p>
                        </div>
                    </div>
                    
                </div>
            </div>

        </div>
    
    </body>
    
</html>