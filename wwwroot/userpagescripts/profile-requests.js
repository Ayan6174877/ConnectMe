$(document).ready(function () {

    let requeststringuser = $("#requestUser").val();
    let IsSessionEqualsRequest = $("#IsSessionEqualsRequest").val();
    let sessionuser = $("#sessionuser").val();
    let messageprivacy = $("#messageprivacy").val();


    let friendstatus;
    // session user is different than the request user
    // for example  username != username
    // call follow status, connection status, block status, much more
    if (IsSessionEqualsRequest == "false") {
        checkfriendstatus();
        checkfollow();
    }
    // if username == username
    else {
        $('#profile_nav').addClass("active-center-nav");
    }

    // firend status
    function checkfriendstatus() {
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/checkfriendstatus',
            method: 'post',
            dataType: 'json',
            data: { username: requeststringuser },
            success: function (data) {
                $(data).each(function (index, item) {
                    // nothing found in the database
                    // both can send friiend request in this case
                    if (item.requeststatus == false) {
                        $("#cancel-request,#accept-request,#decline-request,#remove-network").css("display", "none");
                        $("#send-request").css("display", "block");
                        friendstatus = false;
                    }
                    else {
                        if (item.friendshipstatus == "friends") {
                            $("#cancel-request,#accept-request,#decline-request,#send-request ").css("display", "none");
                            $("#remove-network").css("display", "block");
                            friendstatus = true;
                        }
                        else {
                            // if there is a friend request sent by the session user to quert=y string user
                            if (item.requestedby === sessionuser && item.requestedto === requeststringuser) {
                                $("#remove-network ,#accept-request,#decline-request,#send-request ").css("display", "none");
                                $("#cancel-request").css("display", "block");
                                friendstatus = false;
                            }
                            else {
                                $("#remove-network, #cancel-request ,#send-request ").css("display", "none");
                                $(".network-request-panel").css("display", "block");
                                friendstatus = false;
                            }
                        }
                    }
                    // showing or hiding some of the nav options as per the privacy chhosen by the user

                    // for message privacy
                    if (messageprivacy == "public") {
                        $("#show_message_btn").css("display", "block");
                    }
                    else {
                        if (friendstatus == true) {
                            $("#show_message_btn").css("display", "block");
                        }
                        else {
                            $("#show_message_btn").css("display", "none");
                        }
                    }
                });
            },
            error: function (err) {
                //
            }
        });
    }

    // check the follow status, whether the person is already following or not
    let Followstatus;
    function checkfollow() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            url: '../../userpagewebservices/user_profile_main.asmx/checkfollow',
            method: 'post',
            data: JSON.stringify({ username: requeststringuser }),
            success: function (data) {
                // user is not following
                if (data.d == false) {
                    Followstatus = "false";
                    //$("#follow-user").css("display", "block");
                    //$("#unfollow-user").css("display", "none");
                    $("#following_btn").removeClass("unfollow-user");
                    $("#following_btn").addClass("follow-user");
                    $("#following_btn").html("Follow");
                }
                else {
                    // already following
                    Followstatus = "true";
                    //$("#follow-user").css("display", "none");
                    //$("#unfollow-user").css("display", "block");
                    $("#following_btn").removeClass("follow-user");
                    $("#following_btn").addClass("unfollow-user");
                    $("#following_btn").html("Following");
                }
            },
            error: function (err) {
                $("#folllowing_btn").html("Error");
            }
        });
    }

    // database value will be 1 if follow is done
    // following the user
    $(document).on("click", ".follow-user", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/StartFollowing',
            data: JSON.stringify({ username: requeststringuser, Followstatus: Followstatus }),
            success: function () {
                Followstatus = "True";
                $("#following_btn").removeClass("follow-user");
                $("#following_btn").addClass("unfollow-user");
                $("#following_btn").html("Following");
            },
            error: function (err) {
                $("#following_btn").html("Error");
            }
        });
    });

    // accepting the request
    $(document).on("click", ".unfollow-user", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/StopFollowing',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                Followstatus = "false";
                $("#following_btn").removeClass("unfollow-user");
                $("#following_btn").addClass("follow-user");
                $("#following_btn").html("Follow");
            },
            error: function (err) {
                $("#following_btn").html("Error");
            }
        });
    });

    // sending connection request to the user
    $(document).on("click", "#send-request", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/Sendrequest',
            data: JSON.stringify({ username: requeststringuser, Followstatus: Followstatus }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#remove-network ,#accept-request,#decline-request,#send-request ").css("display", "none");
                $("#cancel-request").css("display", "block");

                // shoiwing unfollow button and hiding follow button
                $("#following_btn").removeClass("follow-user");
                $("#following_btn").addClass("unfollow-user");
                $("#following_btn").html("Following");

                Followstatus = "true";
            },
            error: function (err) {
                alert(err);
            }
        });

    });


    // cancel request of the user
    $(document).on("click", "#remove-network", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/deleteconnection',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#remove-network ,#accept-request,#decline-request,#cancel-request").css("display", "none");
                $("#send-request").css("display", "block");
                friendstatus = false;
                // for message privacy
                if (messageprivacy == "public") {
                    $("#show_message_btn").css("display", "block");
                }
                else {
                    if (friendstatus == true) {
                        $("#show_message_btn").css("display", "block");
                    }
                    else {
                        $("#show_message_btn").css("display", "none");
                    }
                }
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    // cancel request of the user
    $(document).on("click", "#cancel-request", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/Cancelrequest',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#remove-network ,#accept-request,#decline-request,#cancel-request").css("display", "none");
                $("#send-request").css("display", "block");
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    // accepting the request
    $(document).on("click", "#accept-request", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/Acceptrequest',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#send-request ,#accept-request,#decline-request,#cancel-request, .request-panel").css("display", "none");
                $("#remove-network ").css("display", "block");
                friendstatus = true;
                // for message privacy
                if (messageprivacy == "public") {
                    $("#show_message_btn").css("display", "block");
                }
                else {
                    if (friendstatus == true) {
                        $("#show_message_btn").css("display", "block");
                    }
                    else {
                        $("#show_message_btn").css("display", "none");
                    }
                }

            },
            error: function (err) {
                //
            }
        });
    });

    // accepting the request
    $(document).on("click", "#decline-request", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/Declinerequest',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#remove-network ,#accept-request,#decline-request,#cancel-request, .request-panel").css("display", "none");
                $("#send-request ").css("display", "block");
            },
            error: function (err) {
                //
            }
        });
    });


    // blocking the user
    $(document).on("click", ".block-user", function () {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/BlockUser',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                window.location.href = '../feed.aspx';
            },
            error: function (err) {
                alert(err);
            }
        });
    });



});