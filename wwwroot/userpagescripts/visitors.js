// loading the profile visitors

$(document).ready(function () {



    counttotalvisitors();

    function counttotalvisitors() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/visitors.asmx/countvisitors',
            success: function (data) {
                $("#countvisitors").html(data.d);
                if (data.d == "0") {
                    $(".novisitor").css("display", "block");
                }
                else {
                    $(".novisitor").css("display", "none");
                    loadprofilevisitors();
                }
            },
            error: function (err) {
                $("#countvisitors").html("0");
                $(".novisitor").css("display", "block");
            }
        });
    }

    countrecentvisitors();
    function countrecentvisitors() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/visitors.asmx/countrecentvisitor',
            success: function (data) {
                $("#recentvisitor").html(data.d);
            },
            error: function (err) {
                alert(err);
                $("#recentvisitor").html("0");
            }
        });
    }

    // loading the people in the network
    function loadprofilevisitors() {
        $('#loadsharedprofiles').html('');
        $.ajax({
            url: '../../userpagewebservices/visitors.asmx/loadprofilevisitors',
            method: 'POST',
            dataType: 'json',
            cache: 'true',
            beforeSend: function () {
                $("#visitorloader").css("display", "block");
            },
            success: function (data) {
                $("#visitorloader").css("display", "none");
                if (data.length == 0) {
                    $(".novisitor").css("display", "block");
                }
                else {
                    $(data).each(function (index, item) {
                        $(".novisitor").css("display", "none");
                        if (item.profilepic != null) {
                            $('<li><div class="user-short-profile"><div class="user-profile-main-body"><a href="profile_guest.aspx?username=' + item.username + '"><img class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' /></a><h3>' + item.name + ' </h3><h5>' + item.companydeatils + ' </h4><p >' + item.profiletitle + ' </p><p class="timeago" title=\"' + item.time + '\" >' + item.time + '</p></div></div></li>').appendTo($('#loadvisitors'));
                        }
                        else {
                            $('<li><div class="user-short-profile"><div class="user-profile-main-body"><a href="profile_guest.aspx?username=' + item.username + '"><img class="user-profile-pic" src ="../images/user.jpg" /></a><h3>' + item.name + ' </h3><h5>' + item.companydeatils + ' </h4><p>' + item.profiletitle + ' </p><p class="timeago" title=\"' + item.time + '\" >' + item.time + '</p></div></div></li>').appendTo($('#loadvisitors'));
                        }
                    });
                    $(".timeago").timeago();
                }

            },

            error: function (err) {
                $("#visitorloader").css("display", "none");
                $(".novisitor").css("display", "block");
            }
        });

    }

    countrecentworking();
    function countrecentworking() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/visitors.asmx/countrecentworking',
            success: function (data) {
                if (data.d == '') {
                    $("#recentworking").html("0");
                }
                else {
                    $("#recentworkingname").html("as <b>" + data.d + "</b>");
                    $("#recentworkingname").css("display", "block");
                    recentvistorcompanytitlecount(data.d);
                }
            },
            error: function (err) {
                $("#recentworking").html("0");
            }
        });
    }

    function recentvistorcompanytitlecount(datas) {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/visitors.asmx/countrecentworkingnumber',
            data: JSON.stringify({ jobtitle: datas }),
            success: function (data) {
                $("#recentvworking").html(data.d);
            },
            error: function (err) {
                $("#recentworking").html("0");
            }
        });
    }


});