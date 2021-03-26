// scrips for all the actions taken in a user profile
// adding. editing, updating and delete of a user profile data done her

$(document).ready(function () {
    // checking which theme is selected
    // getting the session selected theme
    var requestUser = $("#requestUser").val();

    let bodycolor;
    let headercolor;
    let textcolor;
    checkSectiontheme();
    function checkSectiontheme() {
        $("span.apply-theme").css("opacity", "1");
        $("span.apply-theme").css("pointer-events", "visible");
        $.ajax({
            method: 'post',
            url: '../../userpagewebservices/user_profile_main.asmx/checktheme',
            dataType: "json",
            data: { requestuserdetails: requestUser },
           // data: JSON.stringify({ requestuserdetails: requestUser }),
            success: function (data) {
                if (data.length == 0) {
                    document.documentElement.style.setProperty('--body-color', "#808080");
                    document.documentElement.style.setProperty('--background-color', "#696969");
                    document.documentElement.style.setProperty('--text-color', "#ffffff");
                }
                else {
                    // body color is the header color
                    // background-color is the main color goes to the body and other elements
                    $(data).each(function (index, item) {
                        if (item.bodycolor == '') {
                            document.documentElement.style.setProperty('--background-color', "#808080");
                            document.documentElement.style.setProperty('--body-color', "#696969");
                            document.documentElement.style.setProperty('--text-color', "#ffffff");
                        }
                        else {
                            bodycolor = item.bodycolor;
                            headercolor = item.headercolor;
                            textcolor = item.textcolor;

                            document.documentElement.style.setProperty('--background-color', bodycolor);
                            document.documentElement.style.setProperty('--body-color', headercolor);
                            document.documentElement.style.setProperty('--text-color', textcolor);

                            let color = item.bodycolor;
                            $(".theme-choose-colors span.apply-theme").each(function () {
                                colortheme = $(this).data("bodycolor");
                                if (color === colortheme) {
                                    $(this).css("opacity", "0.6");
                                    $(this).css("pointer-events", "none");
                                    return false;
                                }
                            });

                        }
                    });
                }
            },
            error: function (err) {
                alert(err);

                document.documentElement.style.setProperty('--background-color', "#808080");
                document.documentElement.style.setProperty('--body-color', "#696969");
                document.documentElement.style.setProperty('--text-color', "#ffffff");
            }
        });
    }

  
    // applying the new theme by updating the value to the database
    $(document).on('click', '.apply-theme', function () {
        let bodycolor = $(this).data("bodycolor");
        let headercolor = $(this).data("headercolor");
        let textcolor = $(this).data("textcolor");
        themebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/updatetheme',
            data: JSON.stringify({ bodycolor: bodycolor, headercolor: headercolor, textcolor: textcolor }),
            success: function () {

                document.documentElement.style.setProperty('--background-color', bodycolor);
                document.documentElement.style.setProperty('--body-color', headercolor);
                document.documentElement.style.setProperty('--text-color', textcolor);

                $("span.apply-theme").css("opacity", "1");
                $("span.apply-theme").css("pointer-events", "visible");

                let color = bodycolor;
                $("span.apply-theme").each(function () {
                    colortheme = $(this).data("bodycolor");
                    // $(".theme-background-cover").css("background-color", colortheme);
                    if (color === colortheme) {
                        $(this).css("opacity", "0.6");
                        $(this).css("pointer-events", "none");
                        return false;
                    }
                });

                $(".successfull-div").html("Theme applied successfully");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }
        });
       //  checkSectiontheme();
    });

    // showing the edit profile modal
    $(document).on('click', '#edit_profile', function () {
        let profileTitle = $(".profile-title-render").html();
        if (profileTitle == '') {
            // do nothing
        }
        else {
            $("#addprofiletitle").val(profileTitle);
        }
        $("#edit_profile_modal").modal('show');
    });

    // profile picture action
    // cover pic 

    let coverprofilepicc;
    let newcoverpic;
    $(function () {
        $("#coverupload").change(function () {
            if (typeof (FileReader) != "undefined") {
                var regex = /^([a-zA-Z0-9\s_\\.\-\():])+(.jpg|.jfif|.jpeg|.gif|.png|.bmp)$/;
                $($(this)[0].files).each(function () {
                    var file = $(this);
                    if (regex.test(file[0].name.toLowerCase())) {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            coverprofilepic = $("#changing_cover").attr("src");
                            $("#changing_cover").attr("src", e.target.result);
                            newcoverpic = e.target.result;
                            $("#apply_chnage_profilepic").css("display", "block");
                            $("#apply_chnage_profilepic").css("display", "flex");
                        }
                        reader.readAsDataURL(file[0]);
                    } else {
                        alert(file[0].name + " is not a valid image file.");
                        return false;
                    }
                });
            }
        });
    });


    let profilepicsrc;
    let newProfilePic;
    $(function () {
        $("#profilepicupload").change(function () {
            if (typeof (FileReader) != "undefined") {
                var regex = /^([a-zA-Z0-9\s_\\.\-\():])+(.jpg|.jfif|.jpeg|.gif|.png|.bmp)$/;
                $($(this)[0].files).each(function () {
                    var file = $(this);
                    if (regex.test(file[0].name.toLowerCase())) {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            profilepicsrc = $("#changing_picture").attr("src");
                            $("#changing_picture").attr("src", e.target.result);
                            newProfilePic = e.target.result;
                            $("#trigger_change").css("display", "none");
                        }
                        reader.readAsDataURL(file[0]);
                    } else {
                        alert(file[0].name + " is not a valid image file.");
                        return false;
                    }
                });
            }
        });
    });


    $(document).on("click", "#update_profile", function () {
        // profile pic
        var fd = new FormData();
        imgdata = $("#profilepicupload").get(0).files[0];
        fileupload = $("#profilepicupload").val();
        if (fileupload == '') {
            // do nothing
        }
        else {
            fd.append('imagefile', imgdata);
            $.ajax({
                url: '../../userpagewebservices/uploadpicture.ashx',
                type: 'POST',
                data: fd,
                cache: false,
                contentType: false,
                processData: false,
                success: function () {
                    $("img.profile-picture-render").attr('src', newProfilePic);
                    $("img.profile-guest-picture-render").attr('src', newProfilePic);
                    $("#trigger_change").css("display", "block");
                },
                error: function (err) {
                    alert(err);
                }
            });
        }

        // cover pic update
       // profile pic
        var fdCover = new FormData();
        imgdataCover = $("#coverupload").get(0).files[0];
        coverfileupload = $("#coverupload").val();
        if (coverfileupload == '') {
            // do nothing
        }
        else {
            fdCover.append('imagefile', imgdataCover);
            $.ajax({
                url: '../../userpagewebservices/uploadcoverpicture.ashx',
                type: 'POST',
                data: fdCover,
                cache: false,
                contentType: false,
                processData: false,
                success: function () {
                    $("img.profile-cover-render").attr('src', newcoverpic);
                    $("img.profile-guest-cover-render").attr('src', newcoverpic);
                },
                error: function (err) {
                    alert(err);
                }
            });
        }

        // updating profile title
        profiletitle = $("#addprofiletitle").val();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/updatetitle',
            data: JSON.stringify({ title: profiletitle }),
            success: function () {
                $(".profile-title-render").html(profiletitle);
                $(".profile-guest-title-render").html(profiletitle);

                $(".successfull-div").html("Changes applied successfully");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }
        });

    });

    // end of profile picture

    // links
    $(document).on("click", ".show-link", function () {
        $("body,html").css("overflow-y", "hidden");
        $("#link_section").fadeIn();
    });


    $(document).on("click", "#addlink", function () {
        link = $("#DropDownList1").val();
        linkurl = $("#TextBox1").val();

        var expression = /[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)?/gi;
        var regex = new RegExp(expression);
        Validurl = false;
        if (linkurl.match(regex)) {
            Validurl = true;
        } else {
            Validurl = false;
        }
      
        if (linkurl == '' || Validurl == false) {
            $("#TextBox1").focus();
        }
        else {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/manage-profile.asmx/insertlinks',
                data: JSON.stringify({ link: link, linkurl: linkurl }),
                success: function () {
                    $(".successfull-div").html("link is succrssfully added");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                    $("#TextBox1").val('');
                },
                error: function (err) {
                    $(".successfull-div").html("There was an error");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                }

            });
        }

    });


    // removing the link
    $(document).on('click', '.remove-link', function () {
        removebtn = $(this);
        linkid = $(this).data("linkid");
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/deletelink',
            data: JSON.stringify({ linkid: linkid }),
            success: function () {
                $(removebtn).closest('div.links').fadeOut(3000);
                $(".successfull-div").html("Link removed successfully");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }

        });
    });


    // showing the about me part

    // if there is no about part iserted

    let IsAboutpart;
    $(document).on('click', '.show-about', function () {
        $("body,html").css("overflow-y", "hidden");
        abouttab = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/getabout',
            success: function (data) {
                $("#about_section").fadeIn();
                if (data.d == null) {
                    IsAboutpart = false;
                    $(".fix-panel-body ul li").removeClass("active-fix-tab");
                    $("#add-theme, #add-profile-pic, #add-heading, #add-video, #add-exp, #add-edu, #add-project, #add-skill, #add-int, #add-link").css("display","none");
                    $(abouttab).addClass("active-fix-tab");
                    $("#add-about").fadeIn(500);
                }
                else {
                    IsAboutpart = true;
                    $("#aboutme_update").html(data.d);
                    $(".fix-panel-body ul li").removeClass("active-fix-tab");
                    $("#add-theme, #add-profile-pic, #add-heading, #add-video, #add-exp, #add-edu, #add-project, #add-skill, #add-int, #add-link").fadeOut();
                    $(abouttab).addClass("active-fix-tab");
                    $("#add-about").fadeIn(500);
                }
            },
            error: function (err) {
                // there is no data present in the database
                IsAboutpart = false;
                $(".fix-panel-body ul li").removeClass("active-fix-tab");
                $("#add-theme, #add-heading, #add-video, #add-exp, #add-edu, #add-project, #add-skill, #add-int").fadeOut();
                $(abouttab).addClass("active-fix-tab");
                $("#add-about").fadeIn(500);
            }
        });
    });

    // updating the about me part
    $("#addabout").on('click', function () {
        let aboutme = $("#aboutme_update").html();
        // if about me is not inserted before
        // insert the about me part to the database
        if (IsAboutpart == false) {
            if (aboutme == " " || aboutme == "") {
                $("#aboutme_update").focus();
            }
            else {
                $.ajax({
                    contentType: "application/json; charset=utf-8",
                    method: 'post',
                    url: '../../userpagewebservices/manage-profile.asmx/insertabout',
                    data: JSON.stringify({ aboutme: aboutme }),
                    success: function () {
                        $(".successfull-div").html("Successfully added to your profile");
                        $(".successfull-div").fadeIn(500);
                        $(".successfull-div").fadeOut(6000);
                    },
                    error: function (err) {
                        $(".successfull-div").html("There was an error");
                        $(".successfull-div").fadeIn(500);
                        $(".successfull-div").fadeOut(6000);
                    }
                });
            }
        }
        else {
            if (aboutme == " " || aboutme == "") {
                $("#aboutme_update").focus();
            }
            else {
                $.ajax({
                    contentType: "application/json; charset=utf-8",
                    method: 'post',
                    url: '../../userpagewebservices/manage-profile.asmx/updateabout',
                    data: JSON.stringify({ aboutme: aboutme }),
                    success: function () {
                        $(".successfull-div").html("Successfully added to your profile");
                        $(".successfull-div").fadeIn(500);
                        $(".successfull-div").fadeOut(6000);
                    },
                    error: function (err) {
                        $(".successfull-div").html("There was an error");
                        $(".successfull-div").fadeIn(500);
                        $(".successfull-div").fadeOut(6000);
                    }
                });
            }
        }
    });


    $(document).on("click", ".close-profile-section", function () {
        $(this).closest(".fixed-profile-section").fadeOut();
        $("body,html").css("overflow-y", "auto");
        $("#loadcovervideoletter").attr("src", "");
    });

    // video cover letters

    $(document).on('click', '.show-video-cover-section', function () {
        $("body,html").css("overflow-y", "hidden");
        covervideotab = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/getvideourl',
            success: function (data) {
                $("#cover_section").fadeIn();
                $("#covervideourl").val(data.d);
                $(".fix-panel-body ul li").removeClass("active-fix-tab");
                $("#add-theme, #add-profile-pic, #add-heading, #add-about, #add-exp, #add-edu, #add-project, #add-skill, #add-int, #add-link").css("display","none");
                $(covervideotab).addClass("active-fix-tab");
                $("#add-video").fadeIn(500);
                // showing the iframe if the video url is available
                if (data.d == '') {
                    $(".showremove").css("display", "none");
                    $("#addvideocover").css("display", "block");
                }
                else  {
                    $("#loadcovervideoletter").attr("src", data.d);
                    $(".videocoverlettersize").css("display", "block");
                    $(".showremove").css("display", "block");
                    $("#addvideocover").css("display", "none");
                }
            },
            error: function (err) {
                // there is no data present in the database
            }
        });
    });

    // updating the video cover letter
    $(document).on('click', '#addvideocover', function () {
        let url = $("#covervideourl").val();
        var p = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/;
        var matches = url.match(p);
        if (matches) {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/manage-profile.asmx/updatevideourl',
                data: JSON.stringify({ videourl: url }),
                success: function () {
                    $("#loadcovervideoletter").attr("src", url);
                    $(".showremove").css("display", "block");
                    $("#addvideocover").css("display", "none");
                    $(".successfull-div").html("Cover video letter updated");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                },
                error: function (err) {
                    $(".successfull-div").html("There was an error");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                }
            });
        }
        else {
            $("#covervideourl").focus();
            return false;
        }
    });

    // removevideocover
    $("#removevideocover").on('click', function () {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/deletevideourl',
            success: function () {
                $("#covervideourl").val('');
                $("#loadcovervideoletter").attr("src", "");
                $("#addvideocover").css("display", "block");
                $(".showremove").css("display", "none");
                $(".successfull-div").html("Cover video letter removed");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }
        });
    });

    // end of video cover letter

    // work experience
    $(document).on('click', '.show-exp', function () {
        $("#add_exp").html('Next');
        $("body,html").css("overflow-y", "hidden");
        $("#exp_section").fadeIn(500);
        $("#exp_section input").val('');
        $("#exp_section input").html('');
        $('.exp-forms ul:nth-child(2),.exp-forms ul:nth-child(3), .exp-forms ul:nth-child(4), .exp-forms ul:nth-child(5),.exp-forms ul:nth-child(6)').css("display", "none");
        $('.exp-forms ul:nth-child(1)').fadeIn();
        $("#jobrole").focus();
        $("#exp_rand_para").html("Mention your Job role ( ex - Senior manager , software engineer, CEO, Fashion designer and more )");
        expFormCount = 1;
    });

    // adding exp form 

    $(".exp-forms input").on("keyup", function (e) {
        if (e.which == 13 || e.keyCode == 13) {
            $("#add_exp").trigger("click");
        }
    });

    let expFormCount = 1;
    let CompareDateval;
    let companyname, jobrole, startdate, enddate, location, industry, description;
    $(document).on("click", "#add_exp", function () {
        if (expFormCount == 1) {
            jobrole = $("#jobrole").val().trim();
            if (jobrole == '') {
                $("#jobrole").focus();
            }
            else {
                $('.exp-forms ul:nth-child('+ expFormCount +')').css("display", "none");
                expFormCount++;
                $('.exp-forms ul:nth-child('+ expFormCount +')').fadeIn();
                $("#exp_rand_para").html("Where did you Join as " + jobrole + ". ( ex - Google, facebook, Ebay or other)");
                $("#organization").focus();
            }
        }
        else if (expFormCount == 2) {
            companyname = $("#organization").val().trim();
            if (companyname == '') {
                $("#organization").focus();
            }
            else {
                $('.exp-forms ul:nth-child(' + expFormCount + ')').css("display", "none");
                expFormCount++;
                $('.exp-forms ul:nth-child(' + expFormCount + ')').fadeIn();
                $("#exp_rand_para").html("When did you started working at " + companyname + " as  " + jobrole + " and what's your last date of employment with " + companyname + "? ");
                $("#expstartdate").focus();
            }
        }
        else if (expFormCount == 3) {
            startdate = $("#expstartdate").val().trim();
            enddate = $("#expenddate").val().trim();
            if (startdate == '' || enddate == '') {
                $("#expstartdate").focus();
            }
            else {
                // comparing the dates
                if (enddate == 'currently working') {
                    CompareDateval = true;
                    $('.exp-forms ul:nth-child(' + expFormCount + ')').css("display", "none");
                    expFormCount++;
                    $('.exp-forms ul:nth-child(' + expFormCount + ')').fadeIn();
                    $("#exp_rand_para").html(" For which location you were hired at " + companyname + "?");
                    $("#joblocations").focus();
                }
                else {
                    start = new Date(startdate);
                    end = new Date(enddate);
                    // if start is greater than enddate
                    if (start > end || start == end) {
                        CompareDateval = false;
                    }
                    else {
                        CompareDateval = true;
                        $('.exp-forms ul:nth-child(' + expFormCount + ')').css("display", "none");
                        expFormCount++;
                        $('.exp-forms ul:nth-child(' + expFormCount + ')').fadeIn();
                        $("#exp_rand_para").html(" For which location you were hired at " + companyname + "?");
                        $("#joblocations").focus();
                    }
                }
            }
        }
        else if (expFormCount == 4) {
            location = $("#joblocations").val().trim();
            if (location == '') {
                $("#joblocations").focus();
            }
            else {
                $('.exp-forms ul:nth-child(' + expFormCount + ')').css("display", "none");
                expFormCount++;
                $('.exp-forms ul:nth-child(' + expFormCount + ')').fadeIn();
                $("#exp_rand_para").html("Tell us about your Industry ( ex - Consumer Internet, Food, Hospitality etc ). We may give you future Job recommendations based on this");
                $("#industry").focus();
            }
        }
        else if (expFormCount == 5) {
            industry = $("#industry").val().trim();
            if (industry == '') {
                $("#industry").focus();
            }
            else {
                $('.exp-forms ul:nth-child(' + expFormCount + ')').css("display", "none");
                expFormCount++;
                $('.exp-forms ul:nth-child(' + expFormCount + ')').fadeIn();
                $("#exp_rand_para").html("What was you Job role looks like as a " + jobrole + " at " + companyname + "? (optional) ");
                $("#add_exp").html('Done');
                $("#expdescription").focus();
            }
        }
        else if (expFormCount == 6) {
            description = $("#expdescription").html().trim();
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/manage-profile.asmx/insertexperience',
                data: JSON.stringify({ company: companyname, jobrole: jobrole, startdate: startdate, enddate: enddate, location: location, industry: industry, description: description }),
                success: function () {
                    $(".successfull-div").html("Experience succrssfully added");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                    $('.exp-forms ul:nth-child(2),.exp-forms ul:nth-child(3), .exp-forms ul:nth-child(4), .exp-forms ul:nth-child(5),.exp-forms ul:nth-child(6)').css("display","none");
                    $('.exp-forms ul:nth-child(1)').fadeIn();
                    $("#jobrole").focus();
                    expFormCount = 1;
                    // making the experince form back to normal (empty state )
                },
                error: function (err) {
                    $(".successfull-div").html("There was an error");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                }

            });

        }
    });


    $(document).on("focus", "#expstartdate, #expenddate", function () {
        $(this).attr("type", "month");
    });

   
    $(document).on("blur", "#expstartdate, #expenddate", function () {
        $(this).attr("type", "text");
    });

    $('#currentlyworking').change(function () {
        if ($(this).prop("checked") == true) {
            $("#expenddate").attr("Type", "text");
            $("#expenddate").attr('disabled', true);
            $("#expenddate").val("currently working");
            $("#expenddate").css("border", "none");
        }
        else if ($(this).prop("checked") == false) {
            $("#expenddate").attr("Type", "month");
            $("#expenddate").prop('disabled', false);
            $("#expenddate").val('');
            $("#expenddate").css("border", "solid");
        }
    });

    // removing the experience{
    $(document).on('click', '.remove-experience', function () {
        removebtn = $(this);
        expid = $(this).data("expid");
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/deleteexperience',
            data: JSON.stringify({ expid: expid }),
            success: function () {
                $(removebtn).closest('div.profile-flex-panels').fadeOut(3000);
                $(".successfull-div").html("Experience removed successfully");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
                // making the experince form back to normal (empty state )
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }
        });
    });

    // editing the experience already submitted by the user before
    let updateexpid;
    let IsExpVerified;
    $(document).on('click', '.edit-experience', function () {
        paneleditbtn = $(this);
        let expid = $(this).data("expid");
        updateexpid = $(this).data("expid");
        // getting the data from the database
        $.ajax({
            url: '../../userpagewebservices/manage-profile.asmx/loadexpbyid',
            method: 'post',
            dataType: 'json',
            data: { expid: expid },
            beforeSend: function () {
                // $("#experience-left-loader").css("display", "block");
            },
            success: function (data) {
                $("body,html").css("overflow-y", "hidden");
                $("#edit_exp_section").fadeIn(500);
                if (data.length == 0) {
                    //
                }
                else {
                    $(data).each(function (index, item) {
                        $("#edit_organization").val(item.companyname);
                        $("#edit_jobrole").val(item.jobrole);
                        $("#edit_expstartdate").attr("Type", "text");
                        $("#edit_expstartdate").val(item.startdate);
                        $("#edit_expenddate").attr("Type", "text");
                        $("#edit_expenddate").val(item.enddate);
                        $("#edit_joblocations").val(item.location);
                        $("#edit_industry").val(item.industry);
                        $("#edit_expdescription").html(item.description.replace(/<br ?\/?>/g, "\n"));
                       
                        // if the user is currently working on this role
                        if (item.enddate == "currently working") {
                            $("#edit_currentlyworking").prop('checked', true);
                            $("#edit_expenddate").attr('disabled', true);
                            $("#edit_expenddate").css("border", "none");
                        }
                        else {
                            $("#edit_currentlyworking").prop('checked', false);
                            $("#edit_expenddate").attr('disabled', false);
                            $("#edit_expenddate").css("border", "solid");
                        }

                    });
                }
            },
            error: function (err) {
                // $("#experience-left-loader").css("display", "none");
            }
        });

    });

    $('#edit_currentlyworking').change(function () {
        if ($(this).prop("checked") == true) {
            $("#edit_expenddate").attr("Type", "text");
            $("#edit_expenddate").attr('disabled', true);
            $("#edit_expenddate").val("currently working");
            $("#edit_expenddate").css("border", "none");
        }
        else if ($(this).prop("checked") == false) {
            $("#edit_expenddate").attr("Type", "month");
            $("#edit_expenddate").prop('disabled', false);
            $("#edit_expenddate").val('');
            $("#edit_expenddate").css("border", "solid");
        }
    });

    $(document).on("focus", "#edit_expstartdate, #edit_expenddate", function () {
        $(this).attr("type", "month");
    });


    $(document).on("blur", "#edit_expstartdate, #edit_expenddate", function () {
        $(this).attr("type", "text");
    });

    // updating the experience of the user
    let EditCompareDateval;
    $(document).on("click", ".update-experience", function () {
      // getting the value form the textboxes
        let companyname = $("#edit_organization").val().trim();
        let jobrole = $("#edit_jobrole").val().trim();
        let startdate = $("#edit_expstartdate").val().trim();
        let enddate = $("#edit_expenddate").val().trim();
        let location = $("#edit_joblocations").val().trim();
        let industry = $("#edit_industry").val().trim();
        let description = $("#edit_expdescription").html().trim();

            // comparing the dates
            if (enddate == 'currently working') {
                EditCompareDateval = true;
            }
            else {
                start = new Date(startdate);
                end = new Date(enddate);
                // if start is greater than enddate
                if (start > end || start == end) {
                    EditCompareDateval = false;
                }
                else {
                    EditCompareDateval = true;
                }
            }

            if (companyname == '' || jobrole == '' || startdate == '' || enddate == '' || location == '' || industry == '') {
                $("#edit_organization").focus();
            }
            else if (EditCompareDateval == false) {
                $("#wrongdate").html("End date can not be smaller than the start date");
                $("#edit_expenddate").focus();
            }
            else {
                // getting the data from the forms
                // calling hte ajax function
                $.ajax({
                    contentType: "application/json; charset=utf-8",
                    method: 'post',
                    url: '../../userpagewebservices/manage-profile.asmx/updateexperience',
                    data: JSON.stringify({ expid: updateexpid, company: companyname, jobrole: jobrole, startdate: startdate, enddate: enddate, location: location, industry: industry, description: description }),
                    success: function () {
                        $(".successfull-div").html("Experience succrssfully updated");
                        $(".successfull-div").fadeIn(500);
                        $(".successfull-div").fadeOut(6000);
                    },
                    error: function (err) {
                        $(".successfull-div").html("There was an error");
                        $(".successfull-div").fadeIn(500);
                        $(".successfull-div").fadeOut(6000);
                    }

                });
            }
        
    });
  
    // experience ends here

    // education starts here

    let eduFormCount = 1;
    let eduCompareDateval;
    let degreetype;
    let qualification
    let institute;
    let edustartdate;
    let eduenddate;
    let specialize;
    let grade;
    let edudescription;

    $(document).on('click', '.show-edu', function () {
        $("#add_edu").html('Next');
        $("body,html").css("overflow-y", "hidden");
        $("#edu_section").fadeIn(500);
        $("#edu_section input").val('');
        $("#edu_section input").html('');
        $('.edu-forms ul:nth-child(2),.edu-forms ul:nth-child(3), .edu-forms ul:nth-child(4), .edu-forms ul:nth-child(5),.edu-forms ul:nth-child(6)').css("display", "none");
        $('.edu-forms ul:nth-child(1)').fadeIn();
        $("#edu_rand_para").html("Mention the type of degree");
        eduFormCount = 1;
    });

       // changing the type of the date type textbox
      $("#starteducation, #endeducation, #edit_starteducation, #edit_endeducation ").on('focus', function () {
            $(this).attr("Type", "month");
      });

     $("#starteducation, #endeducation, #edit_starteducation, #edit_endeducation").on('blur', function () {
         $(this).attr("Type", "text");
     });
   
    // adding experiecne to the database
  
   $(document).on("click", "#add_edu", function () {
        if (eduFormCount == 1) {
            degreetype = $("#degreetype").val();
            $('.edu-forms ul:nth-child(' + eduFormCount + ')').css("display", "none");
             eduFormCount++;
            $('.edu-forms ul:nth-child(' + eduFormCount + ')').fadeIn();
            $("#edu_rand_para").html("Which degree did you choose?");
            $("#qualification").focus();
        }
        else if (eduFormCount == 2) {
            qualification = $("#qualification").val().trim();
            if (qualification == '') {
                $("#qualification").focus();
            }
            else {
                $('.edu-forms ul:nth-child(' + eduFormCount + ')').css("display", "none");
                eduFormCount++;
                $('.edu-forms ul:nth-child(' + eduFormCount + ')').fadeIn();
                $("#edu_rand_para").html("Where did you go to complete your " + qualification + "?");
                $("#institute").focus();
            }
        }
        else if (eduFormCount == 3) {
            institute = $("#institute").val().trim();
            if (institute == '') {
                $("#institute").focus();
            }
            else {
                $('.edu-forms ul:nth-child(' + eduFormCount + ')').css("display", "none");
                eduFormCount++;
                $('.edu-forms ul:nth-child(' + eduFormCount + ')').fadeIn();
                $("#edu_rand_para").html("When did you enroll to the course and when it's completed or expected year to end?");
                $("#starteducation").focus();
            }
        }
        else if (eduFormCount == 4) {
            edustartdate = $("#starteducation").val().trim();
            eduenddate = $("#endeducation").val().trim();
            if (edustartdate == '' || eduenddate == '') {
                $("#starteducation").focus();
            }
            else {
                // comparing the dates
                start = new Date(edustartdate);
                end = new Date(eduenddate);
                // if start is greater than enddate
                if (start > end || start == end) {
                    eduCompareDateval = false;
                }
                else {
                    eduCompareDateval = true;
                    $('.edu-forms ul:nth-child(' + eduFormCount + ')').css("display", "none");
                    eduFormCount++;
                    $('.edu-forms ul:nth-child(' + eduFormCount + ')').fadeIn();
                    $("#edu_rand_para").html("What was your specialization and how much did you score at " + qualification + " (optional)?");
                    $("#educationspecialize").focus();
                }
            }
        }
        else if (eduFormCount == 5) {
            specialize = $("#educationspecialize").val().trim();
            grade = $("#grade").val().trim();
            if (specialize == '') {
                $("#educationspecialize").focus();
            }
            else {
                $('.edu-forms ul:nth-child(' + eduFormCount + ')').css("display", "none");
                eduFormCount++;
                $('.edu-forms ul:nth-child('+ eduFormCount +')').fadeIn();
                $("#edu_rand_para").html("Briefly Describe some of your achievements or skills you have learnt while pursing " + qualification + " (optional)");
                $("#add_edu").html("Done");
                $("#edudescription").focus();
            }
        }
        else if (eduFormCount == 6) {
            edudescription = $("#edudescription").html().trim();
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/manage-profile.asmx/inserteducation',
                data: JSON.stringify({ degreetype: degreetype, qualification: qualification, institute: institute, startdate: edustartdate, enddate: eduenddate, specialization: specialize, grade: grade, description: edudescription }),
                success: function () {
                    $(".successfull-div").html("Education succrssfully added");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);

                    $('.edu-forms ul:nth-child(2),.edu-forms ul:nth-child(3), .edu-forms ul:nth-child(4), .edu-forms ul:nth-child(5),.edu-forms ul:nth-child(6)').css("display", "none");
                    $('.edu-forms ul:nth-child(1)').fadeIn();
                    $('.edu-forms input').val("");
                    eduFormCount = 1;
                },
                error: function (err) {
                    $(".successfull-div").html("There was an error");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                }
            });
        }
    });

    
    // editing the experience already submitted by the user before
    let updateeduid;
    $(document).on('click', '.edit-education', function () {
        paneleditbtn = $(this);
        let eduid = $(this).data("eduid");
        updateeduid = $(this).data("eduid");
        $.ajax({
            url: '../../userpagewebservices/manage-profile.asmx/loadedubyid',
            method: 'post',
            dataType: 'json',
            data: { eduid: eduid },
            beforeSend: function () {
                // $("#experience-left-loader").css("display", "block");
            },
            success: function (data) {
                //  $("#experience-left-loader").css("display", "none");
                if (data.length == 0) {
                    //
                }
                else {
                    $(data).each(function (index, item) {
                        $("#edit_edu_section").fadeIn(500);
                        $("#edit_degreetype").val(item.degreetype);
                        $("#edit_qualification").val(item.qualification);
                        $("#edit_institute").val(item.institute);
                        $("#edit_starteducation").attr("Type", "text");
                        $("#edit_starteducation").val(item.startdate);
                        $("#edit_endeducation").attr("Type", "text");
                        $("#edit_endeducation").val(item.enddate);
                        $("#edit_educationspecialize").val(item.specialization);
                        $("#edit_grade").val(item.grade);
                        $("#edit_edudescription").html(item.description);

                    });
                }
            },
            error: function (err) {
               //
            }

        });
    });

    // updating the experience of the user
    $(document).on("click", "#update_education", function () {
        $("#wrongdateedu").html("When it's completed or expected to be completed ?")

        // getting the value form the textboxes
        let degreetype = $("#edit_degreetype").val();
        let qualification = $("#edit_qualification").val();
        let institute = $("#edit_institute").val();
        let startdate = $("#edit_starteducation").val();
        let enddate = $("#edit_endeducation").val();
        let specialize = $("#edit_educationspecialize").val();
        let grade = $("#edit_grade").val();
        let description = $("#edit_edudescription").html();

        start = new Date(startdate);
        end = new Date(enddate);
        // if start is greater than enddate
        if (start > end || start === end) {
            eduCompareDateval = false;
        }
        else {
            eduCompareDateval = true;
        }


        if (degreetype == '' || qualification == '' || institute == '' || startdate == '' || enddate == '' || specialize == '') {
            $('.edit-edu-forms input').each(function () {
                if ($(this).val() == '') {
                    $(this).focus();
                    return false;
                }
                else {
                    //
                }
            });
        }
        else if (eduCompareDateval == false) {
            $("#edit_edu__rand_para").html("Make sure you have entered a correct date");
            $("#edit_endeducation").focus();
        }
        else {
            // getting the data from the forms
            // calling hte ajax function
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/manage-profile.asmx/updateeducation',
                data: JSON.stringify({ eduid: updateeduid, degreetype: degreetype, qualification: qualification, institute: institute, startdate: startdate, enddate: enddate, specialization: specialize, grade: grade, description: description }),
                success: function () {
                    $(".successfull-div").html("Education succrssfully updated");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                },
                error: function (err) {
                    $(".successfull-div").html("There was an error");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                }

            });
        }

    });

    // removing the experience{
    $(document).on('click', '.remove-education', function () {
        removebtn = $(this);
        eduid = $(this).data("eduid");
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/manage-profile.asmx/deleteeducation',
            data: JSON.stringify({ eduid: eduid }),
            success: function () {
                $(removebtn).closest('div.profile-flex-panels').fadeOut(3000);
                $(".successfull-div").html("Education removed successfully");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }

        });
    });



    // education ends here

    // project starts here 

    $(document).on('click', 'li.show-project', function () {
        $(".fix-panel-body ul li").removeClass("active-fix-tab");
        $("#add-heading, #add-profile-pic, #add-about, #add-video, #add-theme, #add-exp, #add-edu, #add-skill, #add-int, #add-link").fadeOut(500);
        $(this).addClass("active-fix-tab");
        $(" #add-project").fadeIn(500);
        $('#submit-education-form li input').each(function () {
            $(this).val('');
            $('#submit-project-form li .multi-textbox').val('');
            $(this).prop('readonly', false);
            $("#starteducation").attr("Type", "date");
            $("#starteducation").val('');
            $("#endeducation").attr("Type", "date");
            $("#endeducation").val('');
            $("#addproject").removeClass("update-project");
            $("#addproject").addClass("add-project");
            $("#addproject").html("Add Project");
            $("#wrongdateproject").html("When it's completed or expected to be completed ?");

        });
        // if  project is not loaded previoudly
        if (IsProjectRendered == false) {
            loadProjectdata();
        }
        else {
            //
        }
    });

    let IsProjectRendered = false;
    function loadProjectdata() {
        $("#load-project").html('');
        $.ajax({
            // contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/manage-profile.asmx/loadallproject',
            dataType: "json",
            beforeSend: function () {
                $("#project-loader").css("display", "block");
            },
            success: function (data) {
                IsProjectRendered = true;
                var count = Object.keys(data).length;
                $("#total-project").html(count + " Projects added");
                $("#project-loader").css("display", "none");
                if (data.length == 0) {

                }
                else {
                    $(data).each(function (index, item) {
                        $('<li><div id="prodiv_' + item.id + '" class="rendered-data"><h3>' + item.projectname + '</h3><h4>' + item.projecttype + '</h4><h6>' + item.startdate + ' - ' + item.enddate + '</h6><ul class="rendered-data-options"><li>&nbsp;</li><li><span data-projectid =' + item.id + ' class="fa fa-remove remove-project" title="Remove project"></span></li></ul></div></li>').appendTo($("#load-project"));
                    });
                }
            },
            error: function (err) {
                $("#project-loader").css("display", "none");
            }
        });
    }

    // changing the type of the date type textbox
    $("#startproject, #endproject").on('focus', function () {
        $(this).attr("Type", "date");
    });

    $("#startproject, #endproject").on('blur', function () {
        $(this).attr("Type", "text");
    });

    // adding the project to the database
    $(document).on("click", ".add-project", function () {
        $("#wrongdateproject").html("When it's completed or expected to be completed ?");

        // getting the value form the textboxes

        let projectname = $("#projectname").val();
        let projecttype = $("#projecttype").val();
        let startdate = $("#startproject").val();
        let enddate = $("#endproject").val();
        let description = $("#projectsummary").val().replace("\g\n", "<br>");
        let link = $("#projectlink").val();

        // comparing for the dates
        start = new Date(startdate);
        end = new Date(enddate);
        // if start is greater than enddate
        if (start > end || start === end) {
            CompareDateval = false;
        }
        else {
            CompareDateval = true;
        }


        if (projectname == '' || projecttype == '' || startdate == '' || enddate == '') {
            $('#submit-project-form li input').each(function () {
                if ($(this).val() == '') {
                    $(this).focus();
                    return false;
                }
                else {
                    //
                }
            });
        }

        else if (CompareDateval == false) {
            $("#wrongdateproject").html("Make sure you have entered a correct date");
            $("#endproject").focus();
        }
        else {
            // getting the data from the forms
            // calling hte ajax function
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/manage-profile.asmx/insertproject',
                data: JSON.stringify({ projectname: projectname, projecttype: projecttype, startdate: startdate, enddate: enddate, link: link, description: description }),
                success: function () {
                    $(".successfull-div").html("Project is succrssfully added");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                    loadProjectdata()
                    // making the experince form back to normal (empty state )
                    $("li.show-project").trigger('click');
                },
                error: function (err) {
                    $(".successfull-div").html("There was an error");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                }

            });
        }

    });

    // removing the experience{
    $(document).on('click', '.remove-project', function () {
        removebtn = $(this);
        proid = $(this).data("projectid");
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/manage-profile.asmx/deleteproject',
            data: JSON.stringify({ projectid: proid }),
            success: function () {
                $(removebtn).closest('div.rendered-data').fadeOut(3000);
                $(".successfull-div").html("Project removed successfully");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
                // making the experince form back to normal (empty state )
                $("li.show-project").trigger('click');
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }

        });
    });



    // project ends here

    // skills starts here
    $(document).on('click', 'li.show-skills', function () {
        $(".fix-panel-body ul li").removeClass("active-fix-tab");
        $("#add-heading, #add-profile-pic, #add-about, #add-video, #add-exp, #add-edu, #add-project, #add-theme, #add-int, #add-link").fadeOut(500);
        $(this).addClass("active-fix-tab");
        $("#add-skill").fadeIn(500);
        loadaddedskills();
    });


    function loadaddedskills() {
        $(".added-skills").html('');
        $.ajax({
            // contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/manage-profile.asmx/loadskills',
            dataType: "json",
            beforeSend: function () {
                $("#skill_loader").css("display", "block");
            },
            success: function (data) {
                $("#skill_loader").css("display", "none");
                var count = Object.keys(data).length;
                if (count == 0) {
                    $(".skils-added-div").css("display", "none");
                }
                else {
                    $(".skils-added-div").css("display", "block");
                    $("#total_skills").html(count + " Skills added");
                    $(data).each(function (index, item) {
                        $('<li data-skillid =' + item.id + ' class="remove-skill"><span class="load"><span class="fa fa-remove"></span>' + item.skillname + '</span></li>').appendTo($(".added-skills"));
                    });
                }
            },
            error: function (err) {
               //
            }
        });
    }


    $(document).on("click", ".remove-skill", function () {
        skillid = $(this).data("skillid");
        removebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/manage-profile.asmx/deleteskill',
            data: JSON.stringify({ id: skillid }),
            success: function () {
                $(removebtn).fadeOut(1000);
                $(".successfull-div").html("Skill or service removed successfully");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
                // making the experince form back to normal (empty state )
            },
            error: function (err) {
                $(".successfull-div").html("There was an error");
                $(".successfull-div").fadeIn(500);
                $(".successfull-div").fadeOut(6000);
            }

        });

    });


        $("#addingskill").on("focus keyup", function () {
            textlength = $(this).val();
            if (textlength.length < 3 || $(this).val() == ' ') {
                $(".add-skill-btn").css("display", "none");
            }
            else {
                $(".add-skill-btn").css("display", "block");
            }
        });

   
    // adding skills to the database
    $(document).on("click", ".add-skill", function () {
        skillvalue = $("#addingskill").val();
        if (skillvalue == '') {
            $("#addingskill").focus();
        }
        else {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/manage-profile.asmx/insertskills',
                data: JSON.stringify({ skillname: skillvalue }),
                success: function () {
                    $(".successfull-div").html("Skill is succrssfully added");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                    loadaddedskills();
                    // making the experince form back to normal (empty state )
                    $("#addingskill").val('');
                    $("#addingskill").focus();
                },
                error: function (err) {
                    $(".successfull-div").html("There was an error");
                    $(".successfull-div").fadeIn(500);
                    $(".successfull-div").fadeOut(6000);
                }

            });
        }

    });

    // end of skill

    // start of interests 

    $(document).on("click", ".show-interests", function () {
        $(".fix-panel-body ul li").removeClass("active-fix-tab");
        $("#add-heading, #add-profile-pic, #add-about, #add-video, #add-exp, #add-edu, #add-project, #add-skill, #add-theme, #add-link").fadeOut(500);
        $(this).addClass("active-fix-tab");
        $("#add-int").fadeIn(500);
        loadint();
    });

    function loadint() {
        $(".added-int").html('');
        $.ajax({
            // contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/manage-profile.asmx/loadinterests',
            dataType: "json",
            beforeSend: function () {
                $("#int_loader").css("display", "block");
            },
            success: function (data) {
                $("#int_loader").css("display", "none");
                var count = Object.keys(data).length;
                if (count == 0) {
                    //
                }
                else {
                    $(data).each(function (index, item) {
                        $('<li data-skillid =' + item.id + ' ><span class="added">' + item.interests + '</span></li>').appendTo($(".added-int"));
                    });
                }
            },
            error: function (err) {
                //
            }
        });
    }

    // end of interests 

    // profile picture

    $(document).on('click', 'li.show-profile-pic', function () {
        $(".fix-panel-body ul li").removeClass("active-fix-tab");
        $("#add-heading, #add-about, #add-video, #add-exp, #add-edu, #add-project, #add-skill, #add-int, #add-theme, #add-link").fadeOut(500);
        $(this).addClass("active-fix-tab");
        $("#add-profile-pic").fadeIn(500);
    });




    // link
    $(document).on('click', 'li.show-link', function () {
        showlinktab = $(this);
        $("#load-link").html('');
        $.ajax({
            method: 'post',
            url: '../userpagewebservices/manage-profile.asmx/getlink',
            dataType: "json",
            success: function (data) {
                $("#add-theme, #add-profile-pic, #add-heading, #add-about, #add-exp, #add-edu, #add-project, #add-skill, #add-int, #add-video").fadeOut();
                $("#add-link").fadeIn(500);
                $(".fix-panel-body ul li").removeClass("active-fix-tab");
                $(showlinktab).addClass("active-fix-tab");

                var count = Object.keys(data).length;
                $("#total-link").html(count + " links added");
                $("#link-loader").css("display", "none");
                if (data.length == 0) {

                }
                else {
                    $(data).each(function (index, item) {
                        $('<li><div id="prodiv_' + item.id + '" class="rendered-data"><h6 style="word-break:break-all">' + item.link + '</h6><ul class="rendered-data-options"><li>&nbsp;</li><li><span data-linkid =' + item.id + ' class="fa fa-remove remove-link" title="Remove link"></span></li></ul></div></li>').appendTo($("#load-link"));
                    });
                }
            },
            error: function (err) {
                // there is no data present in the database
            }
        });
    });

  


});


