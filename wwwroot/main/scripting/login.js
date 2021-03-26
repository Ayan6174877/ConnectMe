$(document).ready(function () {

    $(".panel-signup-action input").on("keyup", function (e) {
        if (e.which === 13 || e.keyCode === 13) {
            $("#logging_user").trigger("click");
        }
    });

    $("#get_username").focus();

   $(document).on("click", "#logging_user", function () {
        // getting username
        var get_username = $("#get_username").val();
        var get_password = $("#get_password").val();
 
       if (get_username != '' && get_password != '') {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: 'userpagewebservices/logging.asmx/checkcredentials',
                data: JSON.stringify({ username: get_username, password: get_password }),
                success: function (data) {
                    // wrong credentials
                    if (data.d == false) {
                        $("#warning_message").html("You have entered a wrong username or password");
                        $("#warning_message").fadeIn();
                    }
                    else {
                        window.location.href = "../user/feed.aspx";
                    }
                },
                error: function (err) {
                    $("#warning_message").html("You have entered a wrong username or password");
                    $("#warning_message").fadeIn();
                }
            });
        }
        else {
            $("#login_user_form input").each(function () {
                if ($(this).val() == '') {
                    $(this).focus();
                    $("#warning_message").html("Make sure to fill both the fields");
                    $("#warning_message").fadeIn();
                    return false;
                }
            });
        }
    });


});
