$(document).ready(function () {

    // getting user hidden value from backend code
    var requestUser = $("#requestUser").val();
    var IsSessionEqualsRequest = $("#IsSessionEqualsRequest").val();
    var IsSessionActive = $("#IsSessionActive").val();
    let sessionuser = $("#sessionuser").val();
    var ProfileComplete = 0;

       if (IsSessionActive == "false") {
            $("#Reg_setup").css({ "display": "flex" });
            $("body, html").css({ "overflow": "hidden" });
        }
        else {
            //
        }



    // session user is different than the request user
    // for example  username != username
    // call follow status, connection status, block status, much more
    if (IsSessionEqualsRequest == "false") {
        $(".section-panel-hide").css("display", "none");
        $('.not-session-user').css("display", "none");
        $(".request-user").css("display", "block");
        $('#profile_nav').removeClass("active-center-nav");
    }
    // if username == username
    else {
        $('#profile_nav').addClass("active-center-nav");
        $('.not-session-user').css("display", "block");
        $(".profile-sections-add").css("display", "flex");
        $(".request-user").css("display", "none");
    }


    // hiding and showing the profile section on clicked by the user
    $(document).on("click", ".show-section", function () {
      //  $(".profile-section-count-footer img , .profile-section-count-footer p ").fadeToggle();
        $(".profile-sections-count").slideToggle(500);
        if ($(".show-section span").hasClass("fa-angle-down")) {
            $(".show-section span").removeClass("fa-angle-down");
            $(".show-section span").addClass("fa-angle-up");
        }
        else {
            $(".show-section span").removeClass("fa-angle-up");
            $(".show-section span").addClass("fa-angle-down");
        }
    });

    $(document).on("click", "#show_explore_options", function () {
        $(".explore-profile-options").fadeToggle();
    });


    $(document).mouseup(function (e) {
        if ($(e.target).closest(".explore-profile-options").length
            === 0) {
            if ($(window).width() < 768) {
                $(".explore-profile-options").fadeOut();
               // $(".navbar-menu-option").css("width", "0%");
            }
            else {
                $(".explore-profile-options").fadeOut();
            }
        }
    });

    jQuery(document).click(function (e) {
        var target = $(".explore-profile-options"); //target div recorded
        if (!jQuery(target).is('#tobehide')) {
            jQuery(this).fadeOut(); //if the click element is not the above id will hide
        }
    })


    // loading the profile picture for the user in the query string
    // get nav bar image, title and other details
    getRequestUserDetails();
    function getRequestUserDetails() {
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/getUserDetails',
            method: 'post',
            dataType: "json",
            data: { requestuserdetails: requestUser },
            success: function (data) {
                if (data.length == 0) {
                    //
                }
                else {
                    $(data).each(function (index, item) {
                        if (item.profilepic == null) {
                            $('.profile-guest-picture-render').attr("src", "../images/user-avatar1.jpg");
                        }
                        else {
                            $('.profile-guest-picture-render').attr("src", item.profilepic);
                            ProfileComplete = ProfileComplete + 20;
                        }

                        if (item.coverpic == null) {
                            $('.cover-div').css("background-color", "var(--background-color)");
                        }
                        else {
                            // $('.profile-guest-cover-render').attr("src", item.coverpic);
                            //  $('.cover-div').css("background-image", url('"' + item.coverpic + '"'));
                            $('.cover-img').attr("src", item.coverpic);
                        }
                        $('.profile-guest-name-render').html(item.name);
                        $('.profile-guest-title-render').html(item.profiletitle);

                    });
                }
            },
            error: function (err) {
                alert(err);
            }
        });
    }

    // profile complete
    function totalprofilecomplete() {
        $("#profile_complete_percent_data").html(ProfileComplete);
        document.documentElement.style.setProperty('--strength2', ProfileComplete + "%");
        profileleftpercent = 100 - ProfileComplete;
        document.documentElement.style.setProperty('--strength1', profileleftpercent + "%");

        // giving profile remark
        if (ProfileComplete <= 30) {
            $(".profile-remark").html("Your profile is not complete");
        }
        else if (ProfileComplete > 30 && ProfileComplete <= 70) {
            $(".profile-remark").html("Your profile Looks average");
        }
        else if (ProfileComplete > 70 && ProfileComplete <= 90) {
            $(".profile-remark").html("Your profile Looks pretty good");
        }
        else {
            $(".meter-circle-filled-one").css("display", "none");
            $(".profile-remark").html("Your profile Looks awesome");
        }
    }

    RecentProfileViews();
    function RecentProfileViews() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/loadRecentVisitors',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                var count = Object.keys(data).length;
                $(".recent-profile-views").html(count);
                if (count == 0) {
                    $(".visitor-profile").css("display", "none");
                }
                else {
                    $(data).each(function (index, item) {
                        $('<img id="pic_'+ item.username +'" />').appendTo($(".visitor-profile"));

                        if (item.profilepic != null) {
                            $('#pic_' + item.username).attr("src", "data:Image/png;base64," + item.companylogo);
                        }
                        else {
                            $('#pic_' + item.username).attr("src", "../../user/images/user.jpg");
                        }
                    });
                }
            },
            error: function (err) {
                $(".recent-profile-views").html("0");
            }
        });
    }


    showPostCount();
    function showPostCount() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/CountPostEngagement',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                $(".total-post-engagement").html(data.d);
            },
            error: function (err) {
                $(".total-post-engagement").html("0");
            }
        });
    }

    Jobapplycount();
    function Jobapplycount() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/TotalJobapply',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                $(".total-Jobs-applied").html(data.d);
            },
            error: function (err) {
                $(".total-Jobs-applied").html("0");
            }
        });
    }

  
    countfollowers();
    function countfollowers() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/countfollowers',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                $("#totalfollowers").html(data.d + " Followers");
            },
            error: function (err) {
                $("#totalfollowers").html("0" + " Followers");
            }
        });
    }


    // network
    shownetworkcount();
    function shownetworkcount() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/countnetwork',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                $("#networkcount").addClass("secondary-notification");
                if (data.d == "0") {
                    $("#totalnetwork").html(data.d + " Network");
                }
                else {
                    $("#totalnetwork").html(data.d + " Network");
                }
            },
            error: function (err) {
                $("#totalnetwork").html("0" + " Network");
            }
        });
    }

    $(document).on("click", ".profile-action-btn", function () {
        $(".profilw-action-modal").fadeIn();
        $("body,html").css("overflow-y", "hidden");
     });

    $(document).on("click", ".close-action-modal", function () {
        $(".profilw-action-modal").css("display", "none");
        $("body,html").css("overflow-y", "auto");
     });


    // load links
    // bind social links

    bindlinks();
    function bindlinks() {
        $.ajax({
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/bindweblinks',
            dataType: "json",
            data: { requestuserdetails: requestUser },
            beforeSend: function () {
                // $("#web_loader").css("display", "block");
            },
            success: function (data) {
                var count = Object.keys(data).length;
                if (count == 0) {
                    $(".link-panel").css("display", "none");
                    $(".no-link-data").css("display", "block");
                }
                else {
                    $(".link-panel").css("display", "block");
                    $(data).each(function (index, item) {
                        $('<div class="links"><span data-linkid = ' + item.id + ' class="fa fa-close remove-link" title="Remove this link"></span><a href = ' + item.link + ' target="_blank"><img src=\"' + item.website + '\"  title =' + item.link + ' /></a></div>').appendTo($(".social-links"));
                    });
                }
            },
            error: function (err) {
                // $(".link-panel").css("display", "none");
                //  $(".no-link-data").css("display", "block");
            }
        });

    }

    // profile highlight counts

   
    // about part
    loadabout();
    function loadabout() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/getabout',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            beforeSend: function () {
                $("#loader-about").css("display", "block");
            },
            success: function (data) {
                $("#loader-about").css("display", "none");
                if (data.d == "" || data.d == null) {
                    $("#hide_about").css("display", "none");
                    $(".no-about").css("display", "block");
                }
                else {
                    ProfileComplete = ProfileComplete + 15;
                    if (data.d.length > 400) {
                        $(".no-about").css("display", "none");
                        $("#aboutme").html(data.d.substring(0, 299));
                        $("#showmoreabout").css("display", "block");
                        $("#hide_about").css("display", "block");
                    }
                    else {
                        $(".no-about").css("display", "none");
                        $("#aboutme").html(data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                        $("#showmoreabout").css("display", "none");
                        $("#hide_about").css("display", "block");
                    }
                }
            },
            error: function (err) {
                // there is no data present in the database

                alert(err);
            }
        });
    }
    $(document).on("click", ".showaboutfulldata", function () {
        showaboutmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/getabout',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                $("#aboutme").html(data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                $(showaboutmorebtn).css("display", "none");
            },
            error: function (err) {
                //  alert(err);
            }
        });
    });


    // video coverletter
    let covervideoutl;
    loadcovervideoletter();
    function loadcovervideoletter() {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/getvideourl',
            data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                // showing the iframe if the video url is available
                if (data.d == "" || data.d == null) {
                    covervideoutl = "";
                    $("#cover-video").css("display", "none");
                }
                else {
                    ProfileComplete = ProfileComplete + 15;
                    covervideoutl = data.d;
                    $(".video-overlay").css("display", "block");
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
        $("#cover_modal").modal('show');
    })
    $(document).on("click", ".close-cover-modal", function () {
        $("#video-url").attr("src", '');
        $("#cover_modal").modal('hide');
    })
    // end of video cover letter

    // scripts for experience

    // moving experienc escroll 
    $(document).on("click", "#exp_scrool_right", function () {
        var leftPos = $('#exp_scroll').scrollLeft();
        $(".profile-data-scroll-horizontal").animate({ scrollLeft: leftPos + 100 }, 100);
    });
    $(document).on("click", "#exp_scrool_left", function () {
        var leftPos = $('#exp_scroll').scrollLeft();
        $(".profile-data-scroll-horizontal").animate({ scrollLeft: leftPos - 100 }, 100);
    });
    // loading all the experience of the user
    loadexperience();
    function loadexperience() {
        // getting the data from the database
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadexperience',
            method: 'post',
            dataType: 'json',
            data: { requestuserdetails: requestUser },
            cache: 'false',
            processData: 'false',
            beforeSend: function () {
                $("#experience-loader").css("display", "block");
            },
            success: function (data) {
                var count = Object.keys(data).length;
                if ($(window).width() < 768) {
                    $("#exp_scroll_overflow_btns").css("display", "flex");
                }
                else {
                    if (count > 3) {
                        $("#exp_scroll_overflow_btns").css("display", "flex");
                    }
                    else {
                        // do nothing
                    }
                }
               
                $("#total_work").html(count);
                $("#experience-loader").css("display", "none");
                if (data.length == 0) {
                    $(".no-experience-data").css("display", "block");
                    $("#hide-experience-div").css("display", "none");
                }
                else {
                    ProfileComplete = ProfileComplete + 15;
                    $(".no-experience-data").css("display", "none");
                    $("#hide-experience-div").css("display", "block");
                    $(data).each(function (index, item) {

                        $('<div class="profile-flex-panels" > <a id="experience_comapnylink_' + item.id + '" ><img id="experience_comapnylogo_' + item.id + '" /></a> \
                           <ul><li>'+ item.jobrole + ' <a id="experience_verifyuserlink_' + item.id + '" ><img id="experience_verifyuserlogo_' + item.id + '" /></a> </li> \
                            <li> ' + item.companyname + ' | ' + item.location + ' </li > <li>' + item.dates + '</li></ul > \
                           <div  class="profile-data-options"><span class="fa fa-ellipsis-v dropdown-toggle" style="font-size:20px" role="button" data-toggle="dropdown"></span> \
                            <ul class= "dropdown-menu dropdown-menu-right text-center" > \
                            <li id = "experience_verifybutton_' + item.id + '" data-expid=' + item.id +' data-username= \"' + item.companyusername + '\" class="verify-experience-user">Verify This Experience </li> \
                            <li  class="loading-teams" data-expid = '+ item.id +' data-username = \"' + item.companyusername + '\"  id="experience_addteams_' + item.id + '" > Add teams </li> \
                            <li class= "edit-experience" data-expid = '+ item.id + ' id = "experience_moreoptionbutton_' + item.id + '" > Edit experience </li>  \
                            <li class= "remove-experience" data-expid = '+ item.id +' id = "experience_moreoptionbutton_' + item.id + '" > Remove this experience </li> \
                           <li> </li> \
                            </ul></div> \
                            <span data-expid = '+ item.id +' class="show-data-details exp-panel-click">Show More</span> \
                            </div>').appendTo($(".exp-data-flex"));


                        // loading the company logo and username if company is not there in the jobeneur directory
                        if (item.companypresent === false) {
                            $('#experience_comapnylogo_' + item.id).attr("src", "../images/briefcase.png");
                            $('#experience_verifybutton_' + item.id).css("display", "none");
                            $('#experience_addteams_' + item.id).css("display", "none");

                        }
                        else if (item.companylogo === null) {

                            // if experience is already verified then hide the button
                            if (item.verified == "verified") {
                                $('#experience_verifybutton_' + item.id).css("display", "none");
                                $('#experience_addteams_' + item.id).css("display", "block");
                            }
                            else if (item.verified == "request sent") {
                                $('#experience_verifybutton_' + item.id).css("display", "none");
                                $('#experience_addteams_' + item.id).css("display", "none");
                            }
                            else {
                                $('#experience_verifybutton_' + item.id).css("display", "block");
                                $('#experience_addteams_' + item.id).css("display", "none");
                            }


                            $("#experience_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#experience_comapnylogo_' + item.id).attr("src", "../images/briefcase.png");
                        }
                        else {

                            // if experience is already verified then hide the button
                            if (item.verified == "verified") {
                                $('#experience_verifybutton_' + item.id).css("display", "none");
                                $('#experience_addteams_' + item.id).css("display", "block");
                            }
                            else if (item.verified == "request sent") {
                                $('#experience_verifybutton_' + item.id).css("display", "none");
                                $('#experience_addteams_' + item.id).css("display", "none");
                            }
                            else {
                                $('#experience_verifybutton_' + item.id).css("display", "block");
                                $('#experience_addteams_' + item.id).css("display", "none");
                            }


                            $("#experience_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#experience_comapnylogo_' + item.id).attr("src", "data:Image/png;base64," + item.companylogo);
                            $('#experience_comapnylogo_' + item.id).css("background-color", "white");
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
                    });
                }
            },
            error: function (err) {
                $(".no-experience-data").css("display", "block");
                $("#hide-experience-div").css("display", "none");
                $("#experience-loader").css("display", "none");
            }
        });
    }
    $(document).on("click", ".exp-panel-click", function () {
        $(".exp-demand-data").html('');
        var expid = $(this).data("expid");
        $(".exp-data-flex .profile-flex-panels").css({ "opacity": "0.7", "border-color": "rgba(0,0,0,.12)", "box-shadow": "0 0 10px 0 rgba(0,0,0,.12)" });
        var scrollArea = $('#exp_scroll');
        var toScroll = $('.exp-panel-click');
        var self = $(this).closest(".profile-flex-panels");


        // getting the complte experience data from the database
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadOnDemandExperience',
            method: 'post',
            dataType: 'json',
            data: { expid: expid },
            success: function (data) {
                if (data.length == 0) {
                    //
                }
                else {
                    $(data).each(function (index, item) {
                        $(".exp-ondemand-data").fadeIn();
                        $(self).closest(".profile-flex-panels").css({ "opacity": "1", "border-color": "transparent", "box-shadow": "none" });
                        var leftOffset = self.offset().left - scrollArea.offset().left + scrollArea.scrollLeft();
                        scrollArea.animate({ scrollLeft: leftOffset });

                        $('<ul><li>Job profile summary</li> \
                            <li><p class="profile-user-main-description exp-description"></p> \
                            <a id = "exp_showmore_' + expid + '" data-expid = ' + expid + ' class= "show-expdescription" > show more.... </a></li > \
                            </ul >').appendTo($(".exp-demand-data"));

                        if (item.description == "") {
                            $('.exp-demand-data').css("display", "none");
                        }
                        else {
                            if (item.description.length > 300) {
                                expdetails = item.description.substring(0, 289).replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                                $("#exp_showmore_" + expid).css("display", "block");
                                $(".exp-description").html(expdetails);
                            }
                            else {
                                $(".exp-description").html(item.description.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />'));
                                $("#exp_showmore_" + expid).css("display", "none");
                            }
                        }

                        // loading the teams the user has worked with
                        loadexperienceteams(expid);
                    });
                }
            },
            error: function (err) {
                alert(err);
            }

        });

    });
    $(document).on("click", ".see-other-option", function () {
        window.location.replace("../manage-profile.aspx");
    });
    function loadexperienceteams(expid) {
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadingteams',
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
                        $(".team-data").css("display", "none");
                    }
                    else {
                        $("#count_teams").html(count + " Teams");
                        $('<div class="team-panel"><p class="exp-team-title">' + item.name + ' </p><p class="exp-team-tagline">' + item.teampagetitle + '</p> <span data-teamid = ' + item.teamid + ' data-expid = ' + expid + ' class="fa fa-remove remove-team"></span></div>').appendTo($('.exp-teams'));
                    }
                });
            },
            error: function (err) {
                $(".team-data").css("display", "none");
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
            url: '../../userpagewebservices/user_profile_main.asmx/loadexpcontents',
            data: JSON.stringify({ expid: expid }),
            success: function (data) {
                $(expshowmorebtn).css("display", "none");
                value = data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                $('.exp-description').html(value);

            },
            error: function (err) {
                // alert(err);
            }

        });
    });

    // verifying the user experience by rendering data of the user who are already been verified
    // verify - experience - user
    let verifybtn;
    let verifyexperienceid;
    $(document).on("click", ".verify-experience-user", function () {
        let expid = $(this).data("expid");
        verifybtn = $(this);
        username = $(this).data("username");
        verifyexperienceid = expid;

        jobrole = $("#exp_jobrole_" + expid).data("role");
        companyname = $("#exp_companyname_" + expid).html();

        $("#verify-text").html("Let's find someone who can verify your work experience for the role " + jobrole + " at " + companyname);
        $("#render-verify-div").fadeIn(500);
        showVerifyRequestUser(username, companyname);

    });
    // loading the verified people who can verify
    function showVerifyRequestUser(username, companyname) {
        $('#loadingverifyuser').html('');
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadverifyuser',
            method: 'POST',
            dataType: 'json',
            data: { username: username, companyname: companyname },
            cache: 'true',
            delay: 20,
            beforeSend: function () {
                $("#verifyloader").css("display", "block");
            },
            success: function (data) {
                $("#verifyloader").css("display", "none");
                if (data.length == 0) {
                    $(".nofollowing").css("display", "block");
                }
                else {
                    $(data).each(function (index, item) {
                        $(".nofollowing").css("display", "none");
                        if (item.usertype == 'company') {
                            if (item.coverpic != null) {
                                $('<li><div class="user-short-profile"><div class="verify-request-option"><span class="fa fa-plus send-verify-request" data-verifyusername = \"' + item.username + '\"></span></div><div class="user-short-profile-company-header"><img class="user-cover-pic" src = data:Image/png;base64,' + item.coverpic + ' ></div><div class="user-profile-main-company-body"><img class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ><h3>' + item.name + ' </h3><h4>' + item.tagline + ' </h4></div></div></li>').appendTo($('#loadingverifyuser'));
                            }
                            else {
                                $('<li><div class="user-short-profile"><div class="verify-request-option"><span class="fa fa-plus send-verify-request" data-verifyusername = \"' + item.username + '\"></span></div><div class="user-short-profile-company-header"><img class="user-cover-pic" src = "images/grey.png" ></div><div class="user-profile-main-company-body"><img class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ><h3>' + item.name + ' </h3><h4>' + item.tagline + ' </h4></div></div></li>').appendTo($('#loadingverifyuser'));
                            }
                        }
                        else {
                            if (item.profilepic != null) {
                                $('<li><div class="user-short-profile"><div class="verify-request-option"><span class="fa fa-plus send-verify-request" data-verifyusername = \"' + item.username + '\"></span></div><div class="user-short-profile-header"><img class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ></div><div class="user-profile-main-body"><h3>' + item.name + ' </h3><h5 >' + item.companydeatils + ' </h4><p >' + item.profiletitle + ' </p></div></div></li>').appendTo($('#loadingverifyuser'));
                            }
                            else {
                                $('<li><div class="user-short-profile"><div class="verify-request-option"><span class="fa fa-plus send-verify-request" data-verifyusername = \"' + item.username + '\"></span></div><div class="user-short-profile-header"><img class="user-profile-pic" src ="images/grey.png" ></div><div class="user-profile-main-body"><h3>' + item.name + ' </h3><h5 >' + item.companydeatils + ' </h4><p >' + item.profiletitle + ' </p></div></div></li>').appendTo($('#loadingverifyuser'));
                            }
                        }
                    });
                }
            },

            error: function (err) {
                //  alert(err);
                $("#verifyloader").css("display", "none");
                $(".nofollowing").css("display", "block");
            }
        });

    }
    // sending the verify request to sonmeone who can veofy the user experince
    $(document).on("click", ".send-verify-request", function () {
        let verifyusername = $(this).data("verifyusername");
        sendverifybtn = $(this);
        // verifyexperienceid
        // verifybtn

        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/sendverificationrequest',
            data: JSON.stringify({ expid: verifyexperienceid, username: verifyusername }),
            success: function () {
                $(verifybtn).css("display", "none");
                $("#loadingverifyuser li .user-short-profile .verify-request-option span.fa").css("display", "block");
                $(sendverifybtn).removeClass("fa-plus");
                $(sendverifybtn).addClass("fa-check");
                $(sendverifybtn).css("display", "block");
            },
            error: function (err) {
                //  alert(err);
            }

        });
    });
    // loading teams for the verified user
    let teamexpid;
    $(document).on("click", ".loading-teams", function () {
        $('#loadingteams').html('');
        teamexpid = $(this).data("expid");
        let teamcompanyusername = $(this).data("username");
        companyname = $("#exp_companyname_" + teamexpid).html();
        $("#team-text").html("Teams at " + companyname);
        $("#render-team-div").fadeIn(500);
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadingallteams',
            method: 'post',
            dataType: 'json',
            data: { username: teamcompanyusername },
            delay: 10,
            beforeSend: function () {
                $("#teamloader").css("display", "block");
            },
            success: function (data) {
                $("#teamloader").css("display", "none");
                $(data).each(function (index, item) {
                    var count = Object.keys(data).length;
                    if (count === 0) {
                        //
                    }
                    else {
                        $('<div class="load-team-panel" ><div class="load-team-panel-header"> <img id="expteam_cover_' + item.teamid + '"  />  </div><div class="load-team-panel-body"><label class="team-name">' + item.name + '</label><label class="team-title">' + item.teampagetitle + '</label></div> <div class="adding-teams"><span data-teamid = ' + item.teamid + '  class="fa fa-plus add-experience-team" ></span></div></div>').appendTo($('#loadingteams'));
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
                $("#teamloader").css("display", "none");
            }
        });

    });
    $(document).on("click", ".add-experience-team", function () {
        teamid = $(this).data("teamid");
        teamclickbtn = $(this);
        // teamexpid;
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            dataType: "json",
            url: '../../userpagewebservices/user_profile_main.asmx/addingteams',
            data: JSON.stringify({ teamid: teamid, expid: teamexpid }),
            success: function (data) {
                $(teamclickbtn).removeClass("add-experience-team");
                $(teamclickbtn).removeClass("fa-plus");
                $(teamclickbtn).addClass("fa-check");
            },
            error: function (err) {
                //  alert(err);
            }
        });

    });
    $(document).on("click", ".remove-team", function () {
        teamid = $(this).data("teamid");
        expid = $(this).data("expid");
        teamremovebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/deleteuserteam',
            data: JSON.stringify({ teamid: teamid, expid: expid }),
            success: function () {
                $(teamremovebtn).closest(".team-panels").fadeOut(500);
            },
            error: function (err) {
                //  alert(err);
            }
        });
    });
    // end of experience
    // education starts here

    // loading all the education  of the user
    loadeducation();
    function loadeducation() {
        // getting the data from the database
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadeducation',
            method: 'post',
            dataType: 'json',
            data: { requestuserdetails: requestUser },
            cache: 'false',
            processData: 'false',
            beforeSend: function () {
                $("#education-loader").css("display", "block");
            },
            success: function (data) {
                var count = Object.keys(data).length;
                if ($(window).width() < 768) {
                    if (count > 1) {
                        $("#edu_scroll_overflow_btns").css("display", "flex");
                    }
                    else {
                        // do nothing
                    }
                }
                else {
                    if (count > 3) {
                        $("#edu_scroll_overflow_btns").css("display", "flex");
                    }
                    else {
                        // do nothing
                    }
                }

                $("#total_education").html(count);
                $("#education-loader").css("display", "none");
                if (data.length == 0) {
                    $(".no-education-data").css("display", "block");
                    $("#hide-education-div").css("display", "none");
                }
                else {
                    ProfileComplete = ProfileComplete + 15;
                    $(".no-education-data").css("display", "none");
                    $("#hide-education-div").css("display", "block");
                    $(data).each(function (index, item) {
                     
                     
                        $('<div class="profile-flex-panels" > \
                            <a id="education_comapnylink_' + item.id + '" ><img id="education_comapnylogo_' + item.id + '" /></a> \
                           <ul><li>'+ item.qualification + ' </li> \
                            <li> '+ item.institute +' | '+ item.specialization +' </li> <li>' + item.dates + '</li></ul > \
                           <div  class="profile-data-options"><span class="fa fa-ellipsis-v dropdown-toggle" style="font-size:20px" role="button" data-toggle="dropdown"></span> \
                            <ul class= "dropdown-menu dropdown-menu-right text-center" > \
                            <li class= "edit-education" data-eduid = '+ item.id +' id = "education_editoptionbutton_' + item.id + '" > Edit education </li>  \
                            <li class= "remove-education" data-eduid = '+ item.id + ' id = "education_removeoptionbutton_' + item.id + '" > Remove education </li> \
                            </ul></div> \
                            <span data-eduid= '+ item.id +'  class="show-data-details edu-panel-click">Show More</span> \
                            </div>').appendTo($(".edu-data-flex"));

                        // loading the company logo and username if company is there in the jobeneur directory
                        if (item.companypresent === false) {
                            $('#education_comapnylogo_' + item.id).attr("src", "../images/education.png");
                        }
                        else if (item.companylogo === null) {
                            $("#education_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#education_comapnylogo_' + item.id).attr("src", "../images/education.png");
                        }
                        else {
                            $("#education_comapnylink_" + item.id).attr("href", "companies.aspx?username=" + item.companyusername);
                            $('#education_comapnylogo_' + item.id).attr("src", "data:Image/png;base64," + item.companylogo);
                        }
                    });
                }
            },
            error: function (err) {
                $(".no-education-data").css("display", "block");
                $("#hide-exducation-div").css("display", "none");
                $("#education-loader").css("display", "none");
            }
        });

    }
    $(document).on("click", ".edu-panel-click", function () {
        $(".edu-demand-data").html('');
        var eduid = $(this).data("eduid");
        $(".edu-data-flex .profile-flex-panels").css({ "opacity": "0.7", "border-color": "rgba(0,0,0,.12)", "box-shadow": "0 0 10px 0 rgba(0,0,0,.12)" });
     
        var scrollArea = $('#edu_scroll');
        var toScroll = $('.edu-panel-click');
        var self = $(this);

        // getting the complte experience data from the database
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadOnDemandEducation',
            method: 'post',
            dataType: 'json',
            data: { eduid: eduid },
            success: function (data) {
                if (data.length == 0 ) {
                    //
                }
                else {
                    $(data).each(function (index, item) {
                        $(".edu-ondemand-data").fadeIn();
                        $(self).closest(".profile-flex-panels").css({ "opacity": "1", "border-color": "transparent", "box-shadow": "none" });
                        var leftOffset = self.offset().left - scrollArea.offset().left + scrollArea.scrollLeft();
                        scrollArea.animate({ scrollLeft: leftOffset });

                        if (item.description == '') {
                            //
                        }
                        else {
                            $('<ul><li>Coursework Details</li> \
                            <li><p class="profile-user-main-description edu-description"></p> \
                            <a  data-eduid =  '+ eduid + ' class= "show-edudescription" > show more.... </a></li> \
                            </ul>').appendTo($(".edu-demand-data"));

                            if (item.description == "") {
                                $('.edu-demand-data').css("display", "none");
                            }
                            else {
                                if (item.description.length > 300) {
                                    var edudetails = item.description.substring(0, 289);
                                    $(".show-edudescription").css("display", "block");
                                    $(".edu-description").html(edudetails);
                                }
                                else {
                                    $(".edu-description").html(item.description);
                                    $(".show-edudescription").css("display", "none");
                                }
                            }

                        }

                    });
                }
            },
            error: function (err) {
                alert(err);
            }

        });

    });
    // showing the fulll education content
    $(document).on("click", ".show-edudescription", function () {
        eduid = $(this).data("eduid");
        edushowmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/loadeducontents',
            data: JSON.stringify({ eduid: eduid }),
            success: function (data) {
                $(edushowmorebtn).css("display", "none");
                value = data.d.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '<br />');
                $(".edu-description").html(value);

            },
            error: function (err) {
                //
            }

        });
    });
   // end of education


     // start of project
    // loadproject();
    function loadproject() {
        // getting the data from the database
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadproject',
            method: 'post',
            dataType: 'json',
            data: { requestuserdetails: requestUser },
            cache: 'false',
            processData: 'false',
            beforeSend: function () {
                $("#project-loader").css("display", "block");
            },
            success: function (data) {
                var count = Object.keys(data).length;
                $("#total_project").html(count);
                $("#project-loader").css("display", "none");
                if (data.length == 0) {
                    $(".no-project-data").css("display", "block");
                    $("#hide-project-div").css("display", "none");
                }
                else {
                    ProfileComplete = ProfileComplete + 15;
                    $(".no-project-data").css("display", "none");
                    $("#hide-project-div").css("display", "block");
                    $(data).each(function (index, item) {
                        $('<div class="user-profile-data">  <ul><li><p id="projectname_' + item.id + '" data-quali = \"' + item.projectname + '\" >' + item.projectname + '</p></li><li id="project_type_' + item.id + '">' + item.projecttype + '<p></li><li id="noprojectlink_' + item.id + '"><p><a href=' + item.projectlink + ' >Project Link : ' + item.projectlink + '</a><p></li><li>' + item.dates + '</p></li><li id="project_nohighlight_' + item.id + '" > <b>Project Description</b><p id="project_details_' + item.id + '" class="profile-user-main-description"></p><a id="project_showmore_' + item.id + '" data-projectid = ' + item.id + ' class="show-projectdescription">show more.... </a></li><li id="noprojecttext_' + item.id + '"><b> Project teams </b> </li><li id="loadteammemberslist_' + item.id + '"><ul class="project-team-member" id="loadteammembersload_' + item.id + '" ></ul> <li></ul>     <div class="profile-data-options">  <span class="fa fa-ellipsis-v dropdown-toggle" role="button" data-toggle="dropdown"></span><ul class="dropdown-menu dropdown-menu-right text-center"><li class="see-project-team" data-projectid = ' + item.id + ' id="project_teamoptionbutton_' + item.id + '">Add project members </li><li class="remove-project" >Remove project</li></ul></div>   </div></div>').appendTo($(".load-project-data"));

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
                $(".no-project-data").css("display", "block");
                $("#hide-project-div").css("display", "none");
                $("#project-loader").css("display", "none");
            }
        });

    }
    function loadprojectteammember(projectid) {
        $('#loadteammembersload_' + projectid).html('');
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadingprojectteams',
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
                    $('<li class="load-project-member-list"><a id="project_userlink_' + item.id + '" href="profile_guest.aspx?username=' + item.username + '"  ><img id="projectteam_image_' + item.id + '" class="project-team-profile-size" /></a><div class="project-team-remove"><span data-teammemberid = ' + item.id + ' class="remove-project-member fa fa-remove" title="Remove team member" ></span></div></li>').appendTo($('#loadteammembersload_' + projectid));
                    // loading the cover image for the team
                    if (item.profileimage != null) {
                        $("#projectteam_image_" + item.id).attr("src", "data:Image/png;base64," + item.profileimage);
                    }
                    else {
                        $("#projectteam_image_" + item.id).attr("src", "../images/user.jpg");
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
    // removing the team member
    $(document).on("click", ".remove-project-member", function () {
        teammemberid = $(this).data("teammemberid");
        teamremovebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/deleteprojectteam',
            data: JSON.stringify({ teammemberid: teammemberid }),
            success: function () {
                $(teamremovebtn).closest(".load-project-member-list").fadeOut(500);
            },
            error: function (err) {
                //
            }
        });
    });
    // showing the fulll project content
    $(document).on("click", ".show-projectdescription", function () {
        projectid = $(this).data("projectid");
        projectshowmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/loadprojectcontents',
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

    let teamprojectmemberid;
    $(document).on("click", ".see-project-team", function () {
        projectid = $(this).data("projectid");
        teamprojectmemberid = projectid;

        let projectname = $("#projectname_" + projectid).html();
        $("#projectname-text").html("Add team members for " + projectname);
        $("#load-project-member-div").fadeIn(500);
    });
    $("#teammember").on('keyup paste', function (e) {
        $("#loadteammembers").html("");
        showteammembers();
    });
    function showteammembers() {
        $("#teammember").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: '../../promouser.ashx/ProcessRequest',
                    method: 'POST',
                    data: { prefix: request.term },
                    dataType: 'json',
                    delay: '10',
                    beforeSend: function () {
                        $("#memberloader").css("display", "block");
                    },
                    success: function (data) {
                        $("#memberloader").css("display", "none");
                        if (data.length == 0) {
                            $("#loadteammembers").html('');
                        }
                        else {
                            $(data).each(function (index, item) {
                                if (item.profilepic != null) {
                                    $('<li><div class="user-short-profile"><div class="project-team-add"><span data-username = \"' + item.username + '\" class="add-project-team-member fa fa-plus" ></span></div><div class="user-short-profile-header"><img class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ></div></a><div class="user-profile-main-body"><h3>' + item.name + ' </h3><h5 >' + item.companydeatils + ' </h4><p >' + item.profiletitle + ' </p><p class="timeago" title=\"' + item.time + '\" >' + item.time + '</p></div></div></li>').appendTo($('#loadteammembers'));
                                }
                                else {
                                    $('<li><div class="user-short-profile"><div class="project-team-add"><span data-username = \"' + item.username + '\" class="add-project-team-member fa fa-plus" ></span></div><div class="user-short-profile-header"><img class="user-profile-pic" src ="images/grey.png" ></div></a><div class="user-profile-main-body"><h3>' + item.name + ' </h3><h5 >' + item.companydeatils + ' </h4><p >' + item.profiletitle + ' </p><p class="timeago" title=\"' + item.time + '\" >' + item.time + '</p></div></div></li>').appendTo($('#loadteammembers'));
                                }
                            });
                        }
                    },
                    error: function (err) {
                        $("#memberloader").css("display", "none");
                    }
                });
            },
        });
    }
    // adding team members to the project
    $(document).on("click", ".add-project-team-member", function () {
        username = $(this).data("username");
        // teamprojectmemberid
        let addbtn = $(this);
        // calling hte ajax function
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/insertprojectteammember',
            data: JSON.stringify({ projectid: teamprojectmemberid, username: username }),
            success: function () {
                $(addbtn).removeClass("fa-plus");
                $(addbtn).removeClass("add-project-team-member");
                $(addbtn).addClass("fa-check");

                $("#loadteammemberslist_" + projectid).css("display", "block");
                $("#noprojecttext_" + projectid).css("display", "block");
                loadprojectteammember(projectid);
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
            url: '../../userpagewebservices/user_profile_main.asmx/loadingskills',
            method: 'post',
            dataType: 'json',
            data: { requestuserdetails: requestUser },
            delay: '10',
            beforeSend: function () {
                $("#skillloader").css("display", "block");
            },
            success: function (data) {
                $("#skillloader").css("display", "none");
                var count = Object.keys(data).length;
                $("#total_skill").html(count);
                // hideteam_id
                if (count == 0) {
                    $(".no-skills").css("display", "block");
                    $(".hide-skills-div").css("display", "none");
                    $("#show_skill_more").css("display", "none");
                }
                else {
                    ProfileComplete = ProfileComplete + 20;
                    $(".no-skills").css("display", "none");
                    var skillcount = 0;
                    $(data).each(function (index, item) {
                        if (skillcount < 3) {
                            $('<div class="skill-div-flex" > \
                                <div class="endorsement-score" >'+ item.skillrating +'</div> \
                                <ul><li>' + item.skillname + ' | '+ item.skillendorsement +'</li> \
                                <li id="loadendorsepeople_' + item.id +'"></li></ul> \
                                </div>').appendTo($('#load_skills'));
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
                alert(err);
            }
        });
    }
    // loading the endorse people
    function loadingendorsepeople(id, skillname) {
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/endorsedpeople',
            method: 'post',
            dataType: 'json',
            data: { skillname: skillname },
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

    // loading all the skills
    // loading all the skills
    $(document).on("click", ".show-more-skill", function () {
        $('#load_skills').empty();
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/loadingskills',
            method: 'post',
            dataType: 'json',
            data: { requestuserdetails: requestUser },
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
                      //  $('<div class="top-skill-div"><div class="top-skill-div-flex"><div class="left-flex-div">' + item.skillname + '</div> <div id="loadendorsepeople_' + item.id + '" class="right-flex-div" > </div></div></div>').appendTo($('#load_skills'));
                        $('<div class="skill-div-flex" > \
                                <div class="endorsement-score" >'+ item.skillrating +'</div> \
                                 <ul><li>' + item.skillname + ' | ' + item.skillendorsement +'</li> \
                                <li id="loadendorsepeople_'+ item.id +'"></li></ul> \
                                </div>').appendTo($('#load_skills'));
                                loadingendorsepeople(item.id, item.skillname);
                    });
                    $("#show_skill_more").css("display", "none");
                }
            },
            error: function (err) {
                $("#skill_list_loader").css("display", "block");
            }
        });
    });
    // end of skills

    $(document).on("click", ".close-network-req", function () {
        $(".network-request-panel").css("display", "none");
    });


    $(document).ajaxStop(function () {
        // 0 === $.active
        totalprofilecomplete();
    });


});


