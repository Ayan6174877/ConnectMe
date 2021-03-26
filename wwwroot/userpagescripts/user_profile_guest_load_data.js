
$(document).ready(function () {

    // network related queries ; likes connection request, etc


    let requeststringuser = $("#requeststringuser").val();
    let sessionuser = $("#sessionuser").val();
    var friendstatus;

    checkfriendstatus();
    function checkfriendstatus() {
        shareprofilepriavcy = $("#profileprivacy").val();
        messageprivacy = $("#messageprivacy").val();
        alert("called");
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/checkfriendstatus',
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
                        $("#email").html("connections can only see email address");
                        $("#show_endorse_btn").css("display", "none");
                    }
                    else {
                        if (item.friendshipstatus == "friends") {
                            $("#cancel-request,#accept-request,#decline-request,#send-request ").css("display", "none");
                            $("#remove-network").css("display", "block");
                            friendstatus = true;
                            $("#show_endorse_btn").css("display", "block");
                        }
                        else {
                            // if there is a friend request sent by the session user to quert=y string user
                            if (item.requestedby === sessionuser && item.requestedto === requeststringuser) {
                                $("#remove-network ,#accept-request,#decline-request,#send-request ").css("display", "none");
                                $("#cancel-request").css("display", "block");
                                friendstatus = false;
                                $("#email").html("connections can see email address");
                                $("#show_endorse_btn").css("display", "none");
                            }
                            else {
                                alert("called");
                                $("#remove-network, #cancel-request ,#send-request ").css("display", "none");
                                $("#accept-request, #decline-request").css("display", "block");
                                $(".network-request-panel").css("display", "block");
                                friendstatus = false;
                                $("#email").html("connections can see email address");
                                $("#show_endorse_btn").css("display", "none");
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


                    // for profile sharing
                    if (shareprofilepriavcy == "only me") {
                        $("#show_profileshare_btn").css("display", "none");
                    }
                    else if (shareprofilepriavcy == "only me") {
                        $("#show_profileshare_btn").css("display", "block");
                    }
                    else {
                        if (friendstatus == true) {
                            $("#show_profileshare_btn").css("display", "block");
                        }
                        else {
                            $("#show_profileshare_btn").css("display", "none");
                        }
                    }

                });
            },
            error: function (err) {
                //
            }
        });
    }


    checkfollow();
    let Followstatus;
    function checkfollow() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            url: '../userpagewebservices/user_profile_guest_main.asmx/checkfollow',
            method: 'post',
            data: JSON.stringify({ username: requeststringuser }),
            success: function (data) {
                // user is not following
                if (data.d == false) {
                    Followstatus = "false";
                    $("#follow-user").css("display", "block");
                    $("#unfollow-user").css("display", "none");
                }
                else {
                    Followstatus = "true";
                    $("#follow-user").css("display", "none");
                    $("#unfollow-user").css("display", "block");
                }
            },
            error: function (err) {
                alert(err);
            }
        });
    }

    // sending connection request to the user
    $(document).on("click", "#send-request", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/Sendrequest',
            data: JSON.stringify({ username: requeststringuser, Followstatus: Followstatus }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#remove-network ,#accept-request,#decline-request,#send-request ").css("display", "none");
                $("#cancel-request").css("display", "block");

                // shoiwing unfollow button and hiding follow button
                $("#follow-user").css("display", "none");
                $("#unfollow-user").css("display", "block");

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
            url: '../userpagewebservices/user_profile_guest_main.asmx/deleteconnection',
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

    // cancel request of the user
    $(document).on("click", "#cancel-request", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/Cancelrequest',
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
            url: '../userpagewebservices/user_profile_guest_main.asmx/Acceptrequest',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#send-request ,#accept-request,#decline-request,#cancel-request").css("display", "none");
                $("#remove-network ").css("display", "block");
                $(".network-request-panel").css("display", "none");
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    // accepting the request
    $(document).on("click", "#decline-request", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/Declinerequest',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                // on showing cancel friend request therwise hiding every other button
                $("#remove-network ,#accept-request,#decline-request,#cancel-request").css("display", "none");
                $("#send-request ").css("display", "block");
                $(".network-request-panel").css("display", "none");
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    // following the user
    $(document).on("click", "#follow-user", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/StartFollowing',
            data: JSON.stringify({ username: requeststringuser, Followstatus: Followstatus }),
            success: function () {
                Followstatus = "True";
                $("#follow-user").css("display", "none");
                $("#unfollow-user").css("display", "block");

            },
            error: function (err) {
                alert(err);
            }
        });
    });

    // accepting the request
    $(document).on("click", "#unfollow-user", function () {
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/StopFollowing',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                Followstatus = "false";
                $("#follow-user").css("display", "block");
                $("#unfollow-user").css("display", "none");
            },
            error: function (err) {
                alert(err);
            }
        });
    });


    // end of network related queries


    // loading about me part of the user
    loadabout();
    function loadabout() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/getabout',
            data: JSON.stringify({ username: requeststringuser }),
            delay: '10',
            beforeSend: function () {
                $("#loader-about").css("display", "block");
            },
            success: function (data) {
                $("#loader-about").css("display", "none");
                if (data.d == '' || data.d == null) {
                    $("#hide_about").css("display", "none");
                }
                else {
                    if (data.d.length > 400) {
                        $("#aboutme").html(data.d.substring(0, 299));
                        $("#showmoreabout").css("display", "block");
                        $("#hide_about").css("display", "block");
                    }
                    else {
                        $("#aboutme").html(data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                        $("#showmoreabout").css("display", "none");
                        $("#hide_about").css("display", "block");
                    }
                }
            },
            error: function (err) {
                // there is no data present in the database
                $("#loader-about").css("display", "none");
                $("#hide_about").css("display", "none");
            }
        });
    }


    $(document).on("click", ".showaboutfulldata", function () {
        showaboutmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/getabout',
            data: JSON.stringify({ username: requeststringuser }),
            success: function (data) {
                $("#aboutme").html(data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                $(showaboutmorebtn).css("display", "none");
            },
            error: function (err) {
                alert(err);
            }
        });
    });



    // externam links and see more info

    $(document).on("click", ".see-more-info", function () {
        $("#profile-more-info").modal('show');
    });

    bindlinks();
    function bindlinks() {
        $.ajax({
            // contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/bindweblinks',
            dataType: "json",
            data: { username: requeststringuser },
            beforeSend: function () {
                // $("#web_loader").css("display", "block");
            },
            success: function (data) {
                // $("#web_loader").css("display", "none");
                var count = Object.keys(data).length;
                if (count == 0) {
                    $(".no-link").css("display", "none");
                }
                else {
                    //  $(".no-interests").css("display", "none");
                    $(data).each(function (index, item) {
                        $('<a href = ' + item.link + ' target="_blank"><span class=\"' + item.website + '\"  title =' + item.link + ' ></span></a>').appendTo($(".social-web"));
                    });
                }
            },
            error: function (err) {
                $(".no-link").css("display", "none");
            }
        });

    }

    // getting network count

    shownetworkcount();
    function shownetworkcount() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/countnetwork',
            data: JSON.stringify({ username: requeststringuser }),
            success: function (data) {
                $("#networkcount").html(data.d);
                $("#networkcount").addClass("secondary-notification");
                if (data.d == "0") {
                    $("#totalnetwork").html(data.d);
                }
                else {
                    $("#totalnetwork").html(data.d);
                }
            },
            error: function (err) {
                $("#totalnetwork").html(data.d);
            }
        });
    }



    // loading video cover letter
    let covervideoutl;
    loadcovervideoletter();
    function loadcovervideoletter() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/getvideourl',
            data: JSON.stringify({ username: requeststringuser }),
            success: function (data) {
                // showing the iframe if the video url is available
                if (data.d == "" || data.d == null) {
                    covervideoutl = "";
                    $("#cover-video").css("display", "none");
                }
                else {
                    covervideoutl = data.d;
                }
            },
            error: function (err) {
                // there is no data present in the database
                $("#cover-video").css("display", "none");
            }
        });

    }

    $(document).on("click", ".show-cover-letter", function () {
        $("#video-url").attr("src", covervideoutl);
        $("#video-cover-letter-load").fadeIn(500);
    })


    // scripts for experience

    // loading all the experience of the user

    loadexperience();
    function loadexperience() {
        // getting the data from the database
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadexperience',
            method: 'post',
            dataType: 'json',
            data: { username: requeststringuser },
            cache: 'false',
            processData: 'false',
            beforeSend: function () {
                $("#experience-loader").css("display", "block");
            },
            success: function (data) {
                $("#experience-loader").css("display", "none");
                if (data.length == 0) {
                    $("#no_experience_data").css("display", "none");
                    $("#hide-experience-div").css("display", "none");
                }
                else {
                    $("#hide-experience-div").css("display", "block");
                    $(data).each(function (index, item) {

                        $('<div class="card card-panel">   <div class="relative"><a id="experience_comapnylink_' + item.id + '" ><img id="experience_comapnylogo_' + item.id + '" class="exp-company-logo"  /></a><a id="experience_verifyuserlink_' + item.id + '" ><img id="experience_verifyuserlogo_' + item.id + '" class="verified-logo" /></a></div>    <ul class="profile-data-details-list" ><li><li id="exp_jobrole_' + item.id + '" class="profile-data-main-title" data-role = \"' + item.jobrole + '\">' + item.jobrole + ' </li><li id="exp_companyname_' + item.id + '">' + item.companyname + '</li><li>' + item.location + '</li><li>' + item.dates + '</li><li id="exp_nohighlight_' + item.id + '" > <div class="profile-descriptions"> <div class="description-header font-weight-600">  Job profile summary </div><div class="description-para margin-top-10">  <p  id="exp_details_' + item.id + '"></p> <a id="exp_showmore_' + item.id + '" data-expid = ' + item.id + ' class="show-expdescription">show more.... </a> </li> <li id="hideteam_' + item.id + '" > <div class="margin-top-15"><div class="team-header font-weight-600">Teams</div> <div id ="experience_loadingteam_' + item.id + '" class="team-load margin-top-20"></div> </div></li></ul>   </div>').appendTo($(".load-experience-div"));


                        if (item.description == "") {
                            $("#exp_nohighlight_" + item.id).css("display", "none");
                            $("#exp_showmore_" + item.id).css("display", "none");
                        }
                        else {
                            if (item.description.length > 300) {
                                expdetails = item.description.substring(0, 289).replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                                $("#exp_showmore_" + item.id).css("display", "block");
                                $("#exp_details_" + item.id).html(expdetails);
                            }
                            else {
                                $("#exp_details_" + item.id).html(item.description.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                                $("#exp_showmore_" + item.id).css("display", "none");
                            }
                        }

                        // loading the company logo and username if company is there in the jobeneur directory
                        if (item.companypresent === false) {
                            $('#experience_comapnylogo_' + item.id).attr("src", "../logo/briefcase.png");
                        }
                        else if (item.companylogo === null) {
                            $("#experience_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#experience_comapnylogo_' + item.id).attr("src", "../logo/briefcase.png");
                        }
                        else {
                            $("#experience_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#experience_comapnylogo_' + item.id).attr("src", "data:Image/png;base64," + item.companylogo);
                        }


                        // checking whether the experience is verified or not
                        if (item.verified == "verified") {
                            $("#experience_verifyuserlink_" + item.id).attr("href", item.verifyuserlink);
                            $("#experience_verifyuserlink_" + item.id).attr("title", item.name);


                            if (item.verifyuserimage != null) {
                                $("#experience_verifyuserlogo_" + item.id).attr("src", "data:Image/png;base64," + item.verifyuserimage);
                            }
                            else {
                                $("#experience_verifyuserlogo_" + item.id).attr("src", "../images/user.png");
                            }

                        }
                        else {
                            $("#experience_verifyuserlink_" + item.id).css("display", "none");
                        }

                        // loading the teams the user has worked with
                        loadexperienceteams(item.id);
                    });
                }
            },
            error: function (err) {
                $("#no_experience_data").css("display", "none");
                $("#experience-loader").css("display", "none");
            }
        });

    }

    function loadexperienceteams(expid) {
        $("#hideteam_" + expid).css("display", "none");

        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadingteams',
            method: 'post',
            dataType: 'json',
            data: { expid: expid },
            beforeSend: function () {
                //
            },
            success: function (data) {
                $(data).each(function (index, item) {
                    var count = Object.keys(data).length;
                    // hideteam_id
                    if (count === 0) {
                        $("#hideteam_" + expid).css("display", "none");
                        $('#experience_loadingteam_' + expid).css("display", "none");
                    }
                    else {
                        $("#hideteam_" + expid).css("display", "block");

                        $('<div class="profile-main-section-panel" >' + item.name + '<p class="font-size-10 opacity-text">' + item.teampagetitle + '</p> </div>').appendTo($('#experience_loadingteam_' + expid));
                        // loading the cover image for the team

                        if (item.teamcoverimage != null) {
                            $("#expteam_cover_" + item.teamid).attr("src", "data:Image/png;base64," + item.teamcoverimage);
                        }
                        else {
                            $("#expteam_cover_" + item.teamid).attr("src", "../images/grey.png");
                        }
                    }
                });
            },
            error: function (err) {
                $("#hideteam_" + expid).css("display", "none");
                $('#experience_loadingteam_' + expid).css("display", "none");
            }
        });
    }



    // showing the fulll experience content
    $(document).on("click", ".show-expdescription", function () {
        expid = $(this).data("expid");
        expshowmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadexpcontents',
            data: JSON.stringify({ expid: expid }),
            success: function (data) {
                $(expshowmorebtn).css("display", "none");
                value = data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                $("#exp_details_" + expid).html(value);

            },
            error: function (err) {
                alert(err);
            }

        });
    });


    $(document).on("click", ".screen-overlay-close", function () {
        $(this).closest($(".screen-overlay")).fadeOut(500);
        $("#video-url").attr("src", "");
    });



    // end of experience

    // education starts here
    // loading all the education  of the user



    loadeducation();
    function loadeducation() {
        // getting the data from the database
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadeducation',
            method: 'post',
            dataType: 'json',
            data: { username: requeststringuser },
            cache: 'false',
            processData: 'false',
            beforeSend: function () {
                $("#education-loader").css("display", "block");
            },
            success: function (data) {
                $("#education-loader").css("display", "none");
                if (data.length == 0) {
                    $("#no_education_data").css("display", "none");
                }
                else {
                    $(data).each(function (index, item) {
                        // $('<div class="card"><ul class="profile-main-data" ><li><a id="education_comapnylink_' + item.id + '" ><img id="education_comapnylogo_' + item.id + '" class="profile-data-company-logo"  /></a></li><li id="edu_qualification_' + item.id + '" class="heading-title" data-quali = \"' + item.qualification + '\">' + item.qualification + ' </li><li><label id="edu_instiname_' + item.id + '" class="heading-sub-heading" >' + item.institute + '</label></li><li><label class="heading-sub-heading" >' + item.specialization + '</label></li><li><label class="heading-sub-heading" >' + item.dates + '</label></li><li id="edu_nohighlight_' + item.id + '" class="heading-sub-heading-title" > Coursework highlights </li><li><p class="profile-para" id="edu_details_' + item.id + '"></p><a id="edu_showmore_' + item.id + '" data-eduid = ' + item.id + ' class="show-edudescription">show more.... </a></li></ul>      </div></div>').appendTo($(".load-education-div"));

                        $('<div class="card card-panel"><div class="relative"><a id="esucation_comapnylink_' + item.id + '" ><img id="education_comapnylogo_' + item.id + '" class="exp-company-logo"  /></a></div><ul class="profile-data-details-list" ><li><li id="edu_qualification_' + item.id + '" data-quali = \"' + item.qualification + '\" class="profile-data-main-title" data-role = \"' + item.jobrole + '\">' + item.qualification + ' </li><li id="exp_companyname_' + item.id + '">' + item.institute + '</li><li>' + item.specialization + '</li><li>' + item.dates + '</li><li id="edu_nohighlight_' + item.id + '" > <div class="profile-descriptions"> <div class="description-header font-weight-600">  Coursework highlights </div><div class="description-para margin-top-10">  <p  id="edu_details_' + item.id + '"></p> <a id="edu_showmore_' + item.id + '" data-eduid = ' + item.id + ' class="show-edudescription">show more.... </a> </div></div></li></ul>  </div>').appendTo($(".load-education-div"));

                        if (item.description == "") {
                            $("#edu_nohighlight_" + item.id).css("display", "none");
                            $("#edu_showmore_" + item.id).css("display", "none");
                        }
                        else {
                            if (item.description.length > 300) {
                                edudetails = item.description.substring(0, 289).replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                                $("#edu_showmore_" + item.id).css("display", "block");
                                $("#edu_details_" + item.id).html(edudetails);
                            }
                            else {
                                $("#edu_details_" + item.id).html(item.description.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                                $("#edu_showmore_" + item.id).css("display", "none");
                            }
                        }

                        // loading the company logo and username if company is there in the jobeneur directory
                        if (item.companypresent === false) {
                            $('#education_comapnylogo_' + item.id).attr("src", "../logo/education.png");
                        }
                        else if (item.companylogo === null) {
                            $("#education_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#education_comapnylogo_' + item.id).attr("src", "../logo/education.png");
                        }
                        else {
                            $("#education_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#education_comapnylogo_' + item.id).attr("src", "data:Image/png;base64," + item.companylogo);
                        }
                    });
                }
            },
            error: function (err) {
                $("#no_education_data").css("display", "none");
                $("#education-loader").css("display", "none");
            }
        });

    }

    // showing the fulll education content
    $(document).on("click", ".show-edudescription", function () {
        eduid = $(this).data("eduid");
        edushowmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_main.asmx/loadeducontents',
            data: JSON.stringify({ eduid: eduid }),
            success: function (data) {
                $(edushowmorebtn).css("display", "none");
                value = data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                $("#edu_details_" + eduid).html(value);

            },
            error: function (err) {
                //
            }

        });
    });



    // end of education

    // start of project


    loadproject();
    function loadproject() {
        // getting the data from the database
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadproject',
            method: 'post',
            dataType: 'json',
            data: { username: requeststringuser },
            cache: 'false',
            processData: 'false',

            beforeSend: function () {
                $("#project-loader").css("display", "block");
            },
            success: function (data) {
                $("#project-loader").css("display", "none");
                if (data.length == 0) {
                    $("#no_project_data").css("display", "none");
                }
                else {
                    $(data).each(function (index, item) {

                        //  $('<div class="card div-load-profile-data"><ul class="profile-main-data" ><li id="projectname_' + item.id + '" class="heading-title" >' + item.projectname + ' </li><li><label id="project_type_' + item.id + '" class="heading-sub-heading" >' + item.projecttype + '</label></li><li id="noprojectlink_' + item.id + '"><a class="heading-sub-heading" href=' + item.projectlink + ' > Project Link : ' + item.projectlink + '</a> </li><li><label class="heading-sub-heading">' + item.dates + ' </label></li><li id="project_nohighlight_' + item.id + '" class="heading-sub-heading-title" >  Project Description / Role </li><li><p class="profile-para" id="project_details_' + item.id + '"></p><a id="project_showmore_' + item.id + '" data-projectid = ' + item.id + ' class="show-projectdescription">show more.... </a></li><li id="noprojecttext_' + item.id + '"> <h3 class="heading-sub-heading-title" style="margin-bottom: 15px"> Project Team </h3></li><li id="loadteammemberslist_' + item.id + '"><ul class="project-team-member" id="loadteammembersload_' + item.id + '" ></ul></li></ul>       </div></div>').appendTo($(".load-project-div"));

                        $('<div class="card card-panel"><ul class="profile-data-details-list" ><li id="projectname_' + item.id + '" class="profile-data-main-title" >' + item.projectname + ' </li><li id="project_type_' + item.id + '">' + item.projecttype + '</li><li id="noprojectlink_' + item.id + '"><a  href=' + item.projectlink + ' > Project Link : ' + item.projectlink + '</a> </li><li>' + item.dates + '</li><li id="project_nohighlight_' + item.id + '" > <div class="profile-descriptions"> <div class="description-header font-weight-600"> Project Description / Role </div> <div class="description-para margin-top-10"><p id="project_details_' + item.id + '"></p><a id="project_showmore_' + item.id + '" data-projectid = ' + item.id + ' class="show-projectdescription">show more.... </a></div></div></li><li id="noprojecttext_' + item.id + '"> <p class="font-weight-600"> Project Team </p></li><li id="loadteammemberslist_' + item.id + '"><ul class="project-team-member" id="loadteammembersload_' + item.id + '" ></ul></li></ul>        </div></div>').appendTo($(".load-project-div"));


                        if (item.description == "") {
                            $("#project_nohighlight_" + item.id).css("display", "none");
                            $("#project_showmore_" + item.id).css("display", "none");
                        }
                        else {
                            if (item.description.length > 300) {
                                projectdetails = item.description.substring(0, 289).replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                                $("#project_showmore_" + item.id).css("display", "block");
                                $("#project_details_" + item.id).html(projectdetails);
                            }
                            else {
                                $("#project_details_" + item.id).html(item.description.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                                $("#project_showmore_" + item.id).css("display", "none");
                            }
                        }
                        if (item.projectlink == "") {
                            $("#noprojectlink_" + item.id).css("display", "none");
                        }

                        loadprojectteammember(item.id);
                    });
                }
            },
            error: function (err) {
                $("#no_project_data").css("display", "none");
                $("#project-loader").css("display", "none");
            }
        });

    }

    function loadprojectteammember(projectid) {
        $('#loadteammembersload_' + projectid).html('');
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadingprojectteams',
            method: 'post',
            dataType: 'json',
            data: { projectid: projectid },
            beforeSend: function () {
                //
            },
            success: function (data) {
                var count = Object.keys(data).length;
                // hideteam_id
                if (count == 0) {
                    $("#loadteammemberslist_" + projectid).css("display", "none");
                    $("#noprojecttext_" + projectid).css("display", "none");
                }
                $(data).each(function (index, item) {
                    $('<li class="load-project-member-list"><a id="project_userlink_' + item.id + '" href="profile_guest.aspx?username=' + item.username + '"  ><img id="projectteam_image_' + item.id + '" class="project-team-profile-size" /></a></li>').appendTo($('#loadteammembersload_' + projectid));
                    // loading the cover image for the team
                    if (item.profileimage != null) {
                        $("#projectteam_image_" + item.id).attr("src", "data:Image/png;base64," + item.profileimage);
                    }
                    else {
                        $("#projectteam_image_" + item.id).attr("src", "../images/grey.png");
                    }
                });
            },
            error: function (err) {
                $("#noprojecttext_" + projectid).css("display", "none");
                $("#hideteam_" + expid).css("display", "none");
                $('#experience_loadingteam_' + expid).css("display", "none");
            }
        });
    }

    // showing the fulll project content
    $(document).on("click", ".show-projectdescription", function () {
        projectid = $(this).data("projectid");
        projectshowmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadprojectcontents',
            data: JSON.stringify({ projectid: projectid }),
            success: function (data) {
                $(projectshowmorebtn).css("display", "none");
                value = data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                $("#project_details_" + projectid).html(value);

            },
            error: function (err) {
                //
            }

        });
    });



    // end of project

    // start of skills



    loadskills();
    function loadskills() {
        // loading the skills
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadingskills',
            method: 'post',
            dataType: 'json',
            data: { username: requeststringuser },
            delay: '10',
            beforeSend: function () {
                $("#skillloader").css("display", "block");
            },
            success: function (data) {
                $("#skillloader").css("display", "none");
                var count = Object.keys(data).length;
                var skillcount = 0;
                if (count == 0) {
                    $("#no_skills").css("display", "none");
                    $("#show_endorse_btn").css("display", "none");
                }
                else {
                    $("#no_skill").css("display", "block");
                    $(data).each(function (index, item) {
                        if (skillcount < 3) {
                            $('<div class="top-skill-div"><div class="top-skill-div-flex"><div class="left-flex-div">' + item.skillname + '</div> <div id="loadendorsepeople_' + item.id + '" class="right-flex-div" > </div></div></div>').appendTo($('#load_skills'));
                        }
                        else {
                            if (count > 3) {
                                $("#show_skill_more").html("Show all " + count + " skills");
                                $("#show_skill_more").css("display", "block");
                            }
                            else {
                                $("#show_skill_more").css("display", "none");
                            }
                            return false;
                        }


                        loadingendorsepeople(item.id, item.skillname);
                        skillcount++;
                    });
                }
            },
            error: function (err) {
                $("#skillloader").css("display", "none");
                $("#no_skills").css("display", "none");
                $("#show_endorse_btn").css("display", "none");
            }
        });
    }


    // loading the endorse people
    function loadingendorsepeople(id, skillname) {
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/endorsedpeople',
            method: 'post',
            dataType: 'json',
            data: { skillname: skillname, username: requeststringuser },
            delay: '10',
            success: function (data) {
                var count = Object.keys(data).length;
                if (count == 0) {

                }
                else {
                    $(data).each(function (index, item) {
                        if (item.profilepic == null) {
                            $('<img src = "images/grey.png"  />').appendTo($('#loadendorsepeople_' + id));
                        }
                        else {
                            $('<img src = data:Image/png;base64,' + item.profilepic + ' />').appendTo($('#loadendorsepeople_' + id));
                        }
                    });
                }
            },
            error: function (err) {
                //
            }
        });
    }

    $(document).on("click", ".show-more-skill", function () {
        $('#load_skills').empty();
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadingskills',
            method: 'post',
            dataType: 'json',
            data: { username: requeststringuser },
            delay: '10',
            beforeSend: function () {
                $("#skill_list_loader").css("display", "block");
            },
            success: function (data) {
                $("#skill_list_loader").css("display", "none");
                var count = Object.keys(data).length;
                $("#total_skills_added").html(count + " Skills");
                // hideteam_id
                if (count == 0) {
                    //  $(".no-skills").css("display", "block");
                }
                else {
                    $(data).each(function (index, item) {
                        $('<div class="top-skill-div"><div class="top-skill-div-flex"><div class="left-flex-div">' + item.skillname + '</div> <div id="loadendorsepeople_' + item.id + '" class="right-flex-div" > </div></div></div>').appendTo($('#load_skills'));
                        loadingendorsepeople(item.id, item.skillname);
                    });
                }
            },
            error: function (err) {
                $("#skill_list_loader").css("display", "block");
            }
        });
    });

    // loading all the skills
    $(document).on("click", "#show_endorse_btn", function () {
        $('#load_endorse_skill_list').empty();
        $(this).removeClass("fa-close");
        $(this).addClass("fa-navicon");
        $(".profile-nav-options").css("width", "0%");
        $('#load_all_skills').empty();
        $("#show_skill_modal").fadeIn();
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/loadingskills',
            method: 'post',
            dataType: 'json',
            data: { username: requeststringuser },
            delay: '10',
            beforeSend: function () {
                $("#skill_list_loader").css("display", "block");
            },
            success: function (data) {
                $("#skill_list_loader").css("display", "none");
                var count = Object.keys(data).length;
                $("#total_skills_added").html(count + " Skills");
                // hideteam_id
                if (count == 0) {
                    //  $(".no-skills").css("display", "block");
                }
                else {
                    $(data).each(function (index, item) {
                        $('<li><div class="skill-endorse-load-div"><div class="skill-endorse-left-side"> <span data-id = ' + item.id + ' data-skillname = \"' + item.skillname + '\" class="endorse-text-count">' + item.skillrating + '</span> <div class="endorse-text"> <div class="skill-text-data"><p>' + item.skillname + ' </p></div> <div id="skill_meter_' + item.id + '" class="skill-rating-meter"> <h5> Endorse this skill </h5> <div id="skill_rating_' + item.id + '" data-skillname = \"' + item.skillname + '\" class="endorse-option"><span data-score = "1"> Beginner </span><span data-score = "2"> Apprentice </span><span data-score = "3" > Intermediate </span><span data-score = "4"> Advanced </span><span data-score = "5"> Expert </span> </div></div></div></div>  <div id="loadendorsepeople_all_' + item.id + '" class="skill-endorse-right-side"> </div></div>  </li>').appendTo($('#load_endorse_skill_list'));
                        loadingendorseallpeople(item.id, item.skillname);
                    });
                }
            },
            error: function (err) {
                $("#skill_list_loader").css("display", "block");
            }
        });

    });




    var IsEndorsedBefore;
    $(document).on("click", ".endorse-text-count", function () {
        $(".skill-rating-meter").css("display", "none");
        skillname = $(this).data("skillname");
        skillid = $(this).data("id");
        panelskill = $('#skill_meter_' + skillid);
        ratingmeter = $('#skill_rating_' + skillid);
        if (friendstatus == true) {
            // checking whther the user has already endorsed or not
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/user_profile_guest_main.asmx/CheckEndorse',
                data: JSON.stringify({ username: requeststringuser, skillname: skillname }),
                success: function (data) {
                    score_user_given = data.d;
                    if (data.d == "") {
                        IsEndorsedBefore = false;
                        $(panelskill).slideToggle();
                    }
                    else {
                        IsEndorsedBefore = true;
                        $(panelskill).slideToggle();
                        $('div#skill_rating_' + skillid + ' span').removeClass("active-skill");
                        $('div#skill_rating_' + skillid + ' span:nth-child(' + data.d + ')').addClass("active-skill");
                    }
                },
                error: function (err) {
                    alert(err);
                }
            });
        }
        else {
            //
        }
    });



    $(document).on("click", ".endorse-option span", function () {
        nameskill = $(this).closest($('.endorse-option')).data("skillname");
        expertlevel = $(this).html();
        score = $(this).data("score");
        ratingbtn = $(this);
        imgsrc = $('#navprofilepic1').attr("src");
        // if the user has never endorsed for the above skills then insert value to the database
        // otherwise update existing value to the database
        if (IsEndorsedBefore == false) {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/user_profile_guest_main.asmx/insertskillendorse',
                data: JSON.stringify({ username: requeststringuser, skill: skillname, rate: score }),
                success: function () {
                    $(ratingbtn).addClass("active-skill");
                    $('<img src = ' + imgsrc + '  />').appendTo($(ratingbtn).closest('.skill-endorse-load-div').children('.skill-endorse-right-side'));
                    //skill-endorse-load-div
                },
                error: function (err) {

                }
            });
        }
        else {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/user_profile_guest_main.asmx/updateskillendorse',
                data: JSON.stringify({ username: requeststringuser, skill: skillname, rate: score }),
                success: function () {
                    $(ratingbtn).closest('.endorse-option').children('span').removeClass("active-skill");
                    $(ratingbtn).addClass("active-skill");
                },
                error: function (err) {
                    alert(err);
                }
            });

        }

    });

    // loading the endorse people
    function loadingendorseallpeople(id, skillname) {
        $('#loadendorsepeople_all_' + id).empty();
        $.ajax({
            url: '../userpagewebservices/user_profile_guest_main.asmx/endorsedpeople',
            method: 'post',
            dataType: 'json',
            data: { skillname: skillname, username: requeststringuser },
            delay: '10',
            success: function (data) {
                var count = Object.keys(data).length;
                var total_skill_count = 0;
                if (count == 0) {

                }
                else {
                    $(data).each(function (index, item) {
                        if (total_skill_count < 7) {
                            if (item.profilepic == null) {
                                $('<img src = "images/grey.png"  />').appendTo($('#loadendorsepeople_all_' + id));
                            }
                            else {
                                $('<img src = data:Image/png;base64,' + item.profilepic + ' />').appendTo($('#loadendorsepeople_all_' + id));
                            }
                            total_skill_count++;
                        }
                        else {
                            return false;
                        }

                    });
                }

                if (count < 6) {
                    //
                }
                else if (count < 99) {
                    $('<div class="total-endorse">' + count + '</div>').appendTo($('#loadendorsepeople_all_' + id));
                }
                else {
                    $('<div class="total-endorse">99+</div>').appendTo($('#loadendorsepeople_all_' + id));
                }


            },
            error: function (err) {
                alert(err);
            }
        });

    }



    // end of skills

    // blocking the user

    $(document).on("click", ".block-user", function () {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/BlockUser',
            data: JSON.stringify({ username: requeststringuser }),
            success: function () {
                window.location.href = 'user.aspx';
            },
            error: function (err) {
                alert(err);
            }
        });
    });




    // closing the animation overlay screen
    setTimeout(closeanimationoverlay, 6000);
    function closeanimationoverlay() {
        $("#profile-animation").fadeOut(1000);
    }

    var IsProfileShared;
    $(document).on("click", "#show_profileshare_btn", function () {
        imgsrc = $('#navprofilepic1').attr("src");
        name = $('#loginusername').html();
        name1 = $('#Label1').html();
        profiletitle = $('#titlesprofile').html();
        requeststringuser = $('#requeststringuser').val();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/user_profile_guest_main.asmx/checkprofileshare',
            data: JSON.stringify({ username: requeststringuser }),
            success: function (data) {
                IsProfileShared = data.d;
                $("#share_image").attr("src", imgsrc);
                $("#name_shareprofile").html(name);

                if (profiletitle.length > 80) {
                    profiletitle = profiletitle.substring(0, 79) + "...";
                    $("#share_profiletitle").html(profiletitle);
                }
                else {
                    $("#share_profiletitle").html(profiletitle);
                }

                $(".profile-share-demo-panel").css({ 'opacity': 0, 'bottom': '-100px' }).animate({ 'opacity': '1', 'bottom': 0 }, 3000);

                $("#image-share-loader").css("display", "none");
                $("#share_image").css("display", "block");

                $("#share-text").css("display", "none");
                $("#show_profiletext").css("display", "block");
                $("#share_profile_modal").fadeIn();
            },
            errot: function (err) {
                alert(err);
            }

        });

    });

    $("#share_message_text").on("keyup focus", function () {
        messagetext = $(this).val().trim();
        if (messagetext.length > 70) {
            $("#share_profile_button").removeClass("btn-disable");
        }
        else {
            $("#share_profile_button").addClass("btn-disable");
        }
    });


    $(document).on("click", "#share_profile_button", function () {
        messagetext = $("#share_message_text").val().replace(/\n/g, "<br>").trim();
        name = $("#Label1").html();
        sharebtn = $(this);
        // if shared within 30 days then restrict the user by sharing his/her profile
        if (IsProfileShared == false) {
            // inserting the profile share data to the database
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/user_profile_guest_main.asmx/Insertprofileshare',
                data: JSON.stringify({ username: requeststringuser, message: messagetext }),
                success: function () {
                    $(".profile-share-demo-panel").animate({ 'opacity': '0' });
                    $(".profile-share-demo-panel").animate({ 'margin-top': '-100px' }, 500);

                    $("#share_image").css("display", "none");
                    $("#show_profiletext").css("display", "none");

                    $("#share-text").css("display", "block");
                    $("#image-share-loader").css("display", "block");

                    $(".profile-share-demo-panel").animate({ 'margin-top': '10px', 'opacity': '1' }, 3000);

                    $("#share_message_text").val('');
                    $(sharebtn).addClass("btn-disable");

                    $("#profile_share_message").html("Congratulations, your profile is on its way to " + name + ". The person to whom you are sharing your profile with can directly reach out to you using message. ")
                    $("#profile_share_message").css({ "background-color": "green", "display": "block" });

                    IsProfileShared = "true";
                },
                error: function (err) {
                    $("#profile_share_message").html("Sorry, We are having trouble in sharing your profile at this moment. Please try back later.")
                    $("#profile_share_message").css({ "background-color": "red", "display": "block" });
                }
            });
        }
        else {
            $("#share_message_text").val('');
            $(sharebtn).addClass("btn-disable");
            $("#profile_share_message").html("You have recently shared your profile with " + name + ". You can only share your profile once in 30 days with a person only if the user's privacy policies allows.");
            $("#profile_share_message").css({ "background-color": "red", "display": "block" });
        }

        $(document).on("click", ".close-modal", function () {
            $(this).closest(".modal-box").fadeOut();
        });


    });


});  