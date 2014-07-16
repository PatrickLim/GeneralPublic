<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemberAccount.aspx.cs" Inherits="GeneralPublic.MemberAccount" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>Pavilion Member Account</title>
    <link href="Styles/bootstrap.min.css" rel="stylesheet" media="screen" />
    <link href="Styles/memberaccount.css" rel="stylesheet" media="screen" />
</head>
<body>

    <div id="wrapper">
        <div id="top-border">
            <div id="divTransactionMask">
                <form class="form-inline" role="form" onsubmit="return false;">
                    <div class="form-group fieldDate">Date</div>
                    <div class="form-group fieldTransaction">Transaction</div>
                    <div class="form-group fieldAmount">Amount</div>
                </form>
            </div>
        </div>
        <ul class="nav nav-tabs nav-justified">
          <li class="active menuitem" id="miAccount"><a href="javascript:SwitchView('miAccount');">Account Information</a></li>
          <li class="menuitem" id="miTransaction"><a href="javascript:SwitchView('miTransaction');">Transaction History</a></li>
          <li class="menuitem" id="miLoad"><a href="javascript:SwitchView('miLoad');">Load Funds</a></li>
          <li class="menuitem" id="miLogout"><a href="Pages/preview.html">Logout</a></li>
        </ul>
        <div id="divAccount" class="panelcontainer">
            <form class="form-horizontal" role="form" onsubmit="return false;">
                <div class="form-group">
                    <label for="txtFirstName" class="col-lg-2 control-label">First Name</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control accountfield" id="txtFirstName" placeholder="First Name" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="txtLastName" class="col-lg-2 control-label">Last Name</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control accountfield" id="txtLastName" placeholder="Last Name" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="txtEmail" class="col-lg-2 control-label">Email</label>
                    <div class="col-lg-10">
                        <input type="email" class="form-control accountfield" id="txtEmail" placeholder="Email Address" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="txtAddress" class="col-lg-2 control-label">Address</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control accountfield" id="txtAddress" placeholder="Street Address" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="txtCity" class="col-lg-2 control-label">City</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control accountfield" id="txtCity" placeholder="City" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="txtState" class="col-lg-2 control-label">State</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control accountfield" id="txtState" placeholder="State" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="txtZip" class="col-lg-2 control-label">Zip</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control accountfield" id="txtZip" placeholder="Zip" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-lg-offset-2 col-lg-10">
                        <button type="submit" class="btn btn-default btn-lg" onclick="SaveMember();">
                            <span class="glyphicon glyphicon-floppy-disk"></span> Save
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <div id="divTransaction" class="panelcontainer">
            <h2 id="divDisplayBalance"></h2>
            <div id="divTransactionDetails"></div>
        </div>
        <div id="divLoadFunds" class="panelcontainer">
            <form class="form-horizontal" role="form" onsubmit="return false;">
                <div class="form-group">
                    <div class="form-group row margintight">
                        <label for="txtCardAmount" class="col-lg-2 control-label">Load Funds</label>
                        <div class="col-lg-4 paddingtight">
                            <input class="form-control" type="text" placeholder="Amount to Load" id="txtCardAmount" />
                        </div>
                    </div>
                    <div class="form-group row margintight">
                        <span class="col-lg-2"></span>
                        <div class="col-lg-4 paddingtight">
                            <input class="form-control" type="text" placeholder="Card Number" id="txtCardNumber" />
                        </div>
                        <label for="cmbExpMonth" class="col-lg-2 control-label">Expires</label>
                        <div class="col-lg-2 paddingtight">
                            <select id="cmbExpMonth" class="form-control">
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
                        </div>
                        <div class="col-lg-2 paddingtight">
                            <select id="cmbExpYear" class="form-control">
                                <option>2014</option>
                                <option>2015</option>
                                <option>2016</option>
                                <option>2017</option>
                                <option>2018</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-group">
	                <div class="form-group row margintight">
                        <label for="txtCardFirstName" class="col-lg-2 control-label">Cardholder</label>
                        <div class="col-lg-5 paddingtight">
                            <input class="form-control" type="text" placeholder="First Name" id="txtCardFirstName" />
                        </div>
                        <div class="col-lg-5 paddingtight">
                            <input class="form-control" type="text" placeholder="Last Name" id="txtCardLastName" />
                        </div>
	                </div>
                </div>

                <div class="form-group">
                    <div class="form-group row margintight">
                        <label for="txtCardStreet" class="col-lg-2 control-label">Address</label>
                        <div class="col-lg-10 paddingtight">
                            <input class="form-control" type="text" placeholder="Street" id="txtCardStreet" />
                        </div>
                    </div>
	                        
	                <div class="form-group row margintight">
                        <span class="col-lg-2"></span>
                        <div class="col-lg-6 paddingtight">
                            <input class="form-control" type="text" placeholder="City" id="txtCardCity" />
                        </div>
                        <div class="col-lg-2 paddingtight">
                            <input class="form-control" type="text" placeholder="ST" id="txtCardState" />
                        </div>
                        <div class="col-lg-2 paddingtight">
                            <input class="form-control" type="text" placeholder="Zip" id="txtCardZip" />
                        </div>
	                </div>
                </div>

                <div class="form-group">
	                <div class="form-group row margintight">
                        <span class="col-lg-2"></span>
                        <div class="col-lg-10 paddingtight">
                            <button class="btn btn-default btn-lg" type="button" onclick="Authorize();">Authorize</button>
                        </div>
	                </div>
                </div>

            </form>
            <img src="Styles/images/credit_card_logos_10.gif" />
        </div>

        <div id="panelLoading" class="panelcontainer">
            <img src="Styles/images/loading.gif" style="float:left;" />
            <p style="padding-left:5em;font-size:larger;">
                Please do not navigate away from this page.<br />
                Processing may take a few minutes.
            </p>
        </div>
        <div id="panelLoaded" class="panelcontainer">
            <div class="panelRightDiv">
                <button type="button" class="btn btn-default" onclick="SwitchView('miLoad');">Load More Funds</button>
            </div>
            <div id="divAuthorizeResult"></div>
        </div>
        <div id="divTransDetailMask">
            <div class="fieldDetailItem"><h4>Item</h4></div>
            <div class="fieldDetailPrice"><h4>Price</h4></div>
            <div class="fieldDetailQty"><h4>Qty</h4></div>
        </div>

    </div>

    <script src="Scripts/jquery-1.10.2.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>

    <script type="text/javascript">
        var EMAIL = '<%=Request.Form["txtEmail"] %>';
        var PWD = '<%=Request.Form["txtPwd"] %>';
        var oMember;

        $(Init());

        function Init() {
            FetchMemberAccount();
            SwitchView('miAccount');
            $('#txtCardAmount').keydown(function (e) {
                // Allow: backspace, delete, tab, escape, enter and .
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                    // Allow: Ctrl+A
                    (e.keyCode == 65 && e.ctrlKey === true) ||
                    // Allow: home, end, left, right
                    (e.keyCode >= 35 && e.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                }
                // Ensure that it is a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
        }

        function SwitchView(whichview) {
            $('.menuitem').removeClass('active');
            $('#' + whichview).addClass('active');
            $('.panelcontainer').hide();
            switch (whichview) {
                case 'miAccount':
                    $('#divAccount').show();
                    break;
                case 'miTransaction':
                    $('#divTransaction').show();
                    break;
                case 'miLoad':
                    $('#divLoadFunds').show();
                    break;
            }
        }

        function ShowLoading() {
            $('.panelcontainer').hide();
            $('#panelLoading').show();
        }

        function ShowLoaded() {
            $('.panelcontainer').hide();
            $('#panelLoaded').show();
        }

        function FetchMemberAccount() {
            var options = {
                year: "numeric", month: "short", day: "numeric", hour: "2-digit", minute: "2-digit"
            };
            var uri = 'api/member/login/' + EMAIL + '/' + PWD;
            $.getJSON(uri)
            .done(function (data) {
                oMember = data;
                $('#divDisplayBalance').html('Balance for ' + oMember.Member.FirstName + ' ' + oMember.Member.LastName + ': $' + oMember.Member.CurrentBalance.toFixed(2));
                $("#txtFirstName").val(oMember.Member.FirstName);
                $("#txtLastName").val(oMember.Member.LastName);
                $("#txtEmail").val(oMember.Member.EmailAddress);
                $("#txtAddress").val(oMember.Member.Street);
                $("#txtCity").val(oMember.Member.City);
                $("#txtState").val(oMember.Member.State);
                $("#txtZip").val(oMember.Member.ZipCode);
                $('#divTransactionDetails').html('');
                $.each(oMember.Cards, function (index, item) {
                    $.each(item.Transactions, function (index, item) {
                        dtTransaction = new Date(item.TransTime);
                        oNewTrans = $('<div>').addClass('transaction').appendTo('#divTransactionDetails');
                        oNewTrans.html($('#divTransactionMask').html());
                        oFieldTrans = oNewTrans.find('.fieldTransaction').html('');
                        if (item.TransTypeLabel == 'Sales') {
                            oTransLabel = $('<button>').html(item.TransTypeLabel).attr('data-cardtransid',item.ReferenceID);
                            oTransLabel.addClass('btn btn-default').appendTo(oFieldTrans);
                            oTransLabel.click(FetchTransDetails);
                        } else {
                            oTransLabel = $('<span>').html(item.TransTypeLabel).appendTo(oFieldTrans);
                        }
                        oNewTrans.find('.fieldDate').html(dtTransaction.toLocaleTimeString("en-us", options));
                        oNewTrans.find('.fieldAmount').html(item.TransAmount.toFixed(2));
                        if (index % 2 == 1) oNewTrans.addClass('alternaterow');
                    });
                });
            })
            .fail(function (jqXHR, textStatus, err) {
                $('#divAccount').html('Error: ' + err);
            });
        }

        function FetchTransDetails() {
            oTrans = $(this).parents('.transaction');
            iCardTrans = $(this).attr('data-cardtransid');
            if (oTrans.attr('data-fetched') != 'yes') {
                var uri = 'api/member/transdetails/' + iCardTrans;
                $.getJSON(uri)
                .done(function (data) {
                    oTrans.attr('data-fetched', 'yes');
                    oTransHolder = $('<div>').addClass('transdetailholder').attr('data-cardtransid', iCardTrans).insertAfter(oTrans);
                    $('<div>').html($('#divTransDetailMask').html()).appendTo(oTransHolder);
                    $.each(data, function (index, item) {
                        oDetail = $('<div>').html($('#divTransDetailMask').html()).appendTo(oTransHolder);
                        oDetail.find('.fieldDetailItem').html(item.ProductName);
                        oDetail.find('.fieldDetailPrice').html(item.Price);
                        oDetail.find('.fieldDetailQty').html(item.Qty);
                    });
                    oTransHolder.slideToggle('slow');
                })
                .fail(function (jqXHR, textStatus, err) {
                    alert('Error: ' + err);
                });

            }
            $('.transdetailholder:visible').slideToggle('slow');
            $('.transdetailholder[data-cardtransid="' + iCardTrans + '"').slideToggle('slow');
        }

        function Authorize() {
            ShowLoading();
            var uri = 'api/member/reload';
            var oRunParam = {
                MemberCardID: oMember.Member.MemberCardID,
                Amount: $('#txtCardAmount').val(),
                CardNumber: $('#txtCardNumber').val(),
                MachineSerialNumber: 'Website',
                PaymentType: 'CreditCard',
                IsLoadedViaMachine: 0,
                Expiration: $('#cmbExpMonth').val() + $('#cmbExpYear').val().substring(2,4),
                FName: $('#txtCardFirstName').val(),
                LName: $('#txtCardLastName').val(),
                Address: $('#txtCardStreet').val(),
                City: $('#txtCardCity').val(),
                State: $('#txtCardState').val(),
                Zip: $('#txtCardZip').val(),
                CVV2: '796'
            };
            var param = {
                url: uri,
                type: "POST",
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(oRunParam)
            };
            $.ajax(param)
            .error(function () { alert("ajax error!"); })
            .done(function (data) {
                sResponseMessage = data.ResponseMessage;
                sApprovedAmount = data.ApprovedAmount;
                sErrorMessage = data.ErrorMessage;
                if (!sErrorMessage) sErrorMessage = '';
                sOut = '';
                sOut += '<p><h3>' + sResponseMessage + '</h3></p>';
                if (sApprovedAmount.length > 0) sOut += '<p>Approved Amount: ' + sApprovedAmount + '</p>';
                if (sErrorMessage.length > 0) sOut += '<p>Error Message: ' + sErrorMessage + '</p>';
                if (sResponseMessage == 'Approved') {
                    FetchMemberAccount();
                    sOut += '<p>Thank you for your business. Please check your Transaction History.</p>';
                } else {
                    sOut += '<p>Please contact our office for assistance.</p>';
                }
                $('#divAuthorizeResult').html(sOut);
                ShowLoaded();
            });
        }

        function SaveMember() {
            var uri = 'api/member/savemember';
            var oRunParam = {
                MemberID: oMember.Member.MemberID,
                FirstName: $('#txtFirstName').val(),
                LastName: $('#txtLastName').val(),
                Street: $('#txtAddress').val(),
                City: $('#txtCity').val(),
                State: $('#txtState').val(),
                ZipCode: $('#txtZip').val(),
                EmailAddress: $('#txtEmail').val()
            };
            var param = {
                url: uri,
                type: "POST",
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(oRunParam)
            };
            $.ajax(param)
            .error(function () { alert("ajax error!"); })
            .done(function (data) {
                //alert('saved!');
            });
        }
    </script>
</body>
</html>
