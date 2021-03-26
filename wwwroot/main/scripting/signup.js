
$(document).ready(function () {

    $("#get_name").focus();
    $("#get_name").val('');
    $("#get_username").val('');
    $("#get_email").val('');
    $("#get_password").val('');

    $(".panel-signup-action input").on("keyup", function (e) {
        if (e.which === 13 || e.keyCode === 13) {
            $(".register-user").trigger("click");
        }
    });

    $("#get_dob").on("focus", function () {
        $(this).attr("type", "date");
    });

   
    $("#get_dob").on("blur", function () {
        $(this).attr("type", "text");
    });

    is_DobValid = false;
    $("#get_dob").change(function (e) {
        var vals = e.target.value.split('-');
        var year = vals[0];
        var month = vals[1];
        var day = vals[2];

        var age = 13;

        var mydate = new Date();
        mydate.setFullYear(year, month - 1, day);

        var currdate = new Date();
        currdate.setFullYear(currdate.getFullYear() - age);

        if (currdate < mydate) {
            is_DobValid = false;
        }
        else {
            is_DobValid = true;
        }
    });

   // registering the user
    $(document).on("click", ".register-user", function () {
        var get_firstname = $("#get_firstname").val().trim();
        var get_lastname = $("#get_lastname").val().trim();
        let get_name = get_firstname + ' ' + get_lastname;
        var get_username = $("#get_username").val().trim();
        var get_email = $("#get_email").val().trim();
        var emailpattern = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i;
        var get_dob = $("#get_dob").val().trim();
        var get_password = $("#get_password").val().trim();

        if (get_name == '' || get_username == '' || get_email == '' || get_password == '' || get_dob == '') {
            $("#register_user_form input").each(function () {
                if ($(this).val() == '') {
                    $("#register_user_form input").each(function () {
                        if ($(this).val() == '') {
                            $(this).css({ "border-width": "2", "border-color": "maroon" });
                        }
                    });
                    $(this).focus();
                    $("#warning_message").html("Make sure none of the fields are left empty");
                    $("#warning_message").fadeIn();
                    return false;
                }
                else {
                    $("#warning_message").fadeOut();
                }
            });
        }
        else if (get_firstname.length < 2) {
            $("#get_firstname").focus();
            $("#get_firstname").css({ "border-width": "2", "border-color": "maroon" });
            $("#warning_message").html("Name you have enteresed seems too short. Make sure you have entered a valid name");
            $("#warning_message").fadeIn();
        }
        else if (!emailpattern.test(get_email)) {
            $("#get_email").focus();
            $("#get_email").css({ "border-width": "2", "border-color": "maroon" });
            $("#warning_message").html("You have entered an invalid email address. ");
            $("#warning_message").fadeIn();
        }
        else if (get_username.length < 6 || get_username.length > 15) {
            $("#get_username").focus();
            $("#get_username").css({ "border-width": "2", "border-color": "maroon" });
            $("#warning_message").html("Username need to be between 6 to 15 character");
            $("#warning_message").fadeIn();
        }
        else if (is_DobValid == false) {
            $("#get_dob").focus();
            $("#get_dob").css({ "border-width": "2", "border-color": "maroon" });
            $("#warning_message").html("You are just too young to be on Jobeneur. The minimum age to be on Jobeneur is 13");
            $("#warning_message").fadeIn();
        }
        else if (get_password.length < 8) {
            $("#get_password").focus();
            $("#get_password").css({ "border-width": "2", "border-color": "maroon" });
            $("#warning_message").html("You password is too weak. Make sure that you enter a strong password");
            $("#warning_message").fadeIn();
        }
        else {
            $("#register_user_form input").css({ "border-width": "1", "border-color": "rgba(0,0,0,.12)" });
            window.location.href = "../user/profile/profile.aspx?id=" + get_username + "&Create_Profile=" + 'True' ;
            //$.ajax({
            //    contentType: "application/json; charset=utf-8",
            //    method: 'post',
            //    url: 'userpagewebservices/signup.asmx/register_user_credentials',
            //    data: JSON.stringify({ name: get_name, username: get_username, email: get_email, dob: get_dob, password: get_password }),
            //    success: function (data) {
            //        // wrong credentials
            //        if (data.d == true) {
            //            $("#warning_message").html("Username or email already exists. Please try a different username or email to register");
            //            $("#warning_message").fadeIn();
            //        }
            //        else {
            //        window.location.href = "../user/profile/profile.aspx?id=" + get_username + "&Create_Profile=" + 'True' ;
                 //     }
            //    },
            //    error: function (err) {
            //        $("#warning_message").html("Sorry for the inconvenience but we are facing an error while registering your account. Please try back later after sometime.");
            //        $("#warning_message").fadeIn();
            //    }
            //});
        }
    });

    $('#get_username').keyup(function () {
        this.value = this.value.replace(/\s/g, '');
    });

    // user info page scripts

    $(document).on("click", "#validate-dob", function () {
        dob = $("#get_dob").val().trim();
        if (dob == '') {
            $("#get_dob").focus();
        }
        else {
            // calling ajax
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/signup.asmx/updatedob',
                data: JSON.stringify({ dob: dob }),
                success: function () {
                    $("#dob-form").fadeOut();
                    $("#location-form").fadeIn(2000);
                },
                error: function (err) {
                    $("#dob-form").fadeOut();
                    $("#location-form").fadeIn(2000);
                }
            });

        }
    });


    $(function () {
        $("#profilepicupload").change(function () {
            if (typeof (FileReader) != "undefined") {
                var regex = /^([a-zA-Z0-9\s_\\.\-\():])+(.jpg|.jpeg|.gif|.png|.bmp)$/;
                $($(this)[0].files).each(function () {
                    var file = $(this);
                    if (regex.test(file[0].name.toLowerCase())) {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            $("#changing_picture").attr("src", e.target.result);
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


    // updating the profile picture
    $(document).on("click", "#upload-dp", function () {
        var fd = new FormData();
        imgdata = $("#profilepicupload").get(0).files[0];
        fileupload = $("#profilepicupload").val();
        fd.append('imagefile', imgdata);
        if (fileupload == '') {
            $("#dp-form").fadeOut();
            $("#headline-form").fadeIn(2000);
        }
        else {
            $.ajax({
                url: '../userpagewebservices/uploadpicture.ashx',
                type: 'POST',
                data: fd,
                cache: false,
                contentType: false,
                processData: false,
                success: function () {
                    $("#dp-form").fadeOut();
                    $("#headline-form").fadeIn(2000);
                },
                error: function (err) {
                    $("#dp-form").fadeOut();
                    $("#headline-form").fadeIn(2000);
                }
            });
        }
    });

});
