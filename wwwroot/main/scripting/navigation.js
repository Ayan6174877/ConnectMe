
  $(document).on("click",".reg-btn", function(){
    window.location.href = "signup.html";
  });

  $(document).on("click",".sign-in", function(){
    window.location.href = "/signin.html";
  });

  $(document).on("click",".about-nav", function(){
    window.location.href = "/about.html";
  });

  $(document).on("click",".team-nav", function(){
    window.location.href = "/team.html";
  });

  $(document).on("click",".business-nav", function(){
    window.location.href = "/business.html";
  });

  $(document).on("click",".business-pricing", function(){
    window.location.href = "/business.html#pricing";
  });

  $(document).on("click",".req-demo-focus", function(){
    $("#name").focus();
  });


// inserting values of the B2B users requesting for demo

$(document).on("click", ".request-demo-btn", function () {

    username = $("#company_username").val();
    companyname = $("#companyname").val();
    email = $("#company_email").val();
    var emailpattern = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i;
    mobile = $("#company_mobile").val();

    if (username == '' || companyname == '' || email == '') {
        $(".business-reg-form input").each(function () {
            if ($(this).val() == '') {
                $(this).focus();
                return false;
            }
        });
    }
    else if (!emailpattern.test(email)) {
        $("#company_email").focus();
    }
    else if (mobile != '') {
        if (!mobile.match('[0-9]{10}') || mobile.length != 10) {
            $("#company_mobile").focus();
        }
        else {
            // insert value in database
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: 'userpagewebservices/signup.asmx/company_demo',
                data: JSON.stringify({ username: username, companyname: companyname, email: email, mobile: mobile }),
                success: function () {
                    $("#demo_success").html("Thank You! We received your request. One of our team members will be in touch with you shortly.");
                    $("#demo_success").css("display", "block");
                    $(".business-reg-form input").each(function () {
                        $(this).val('');
                    });
                },
                error: function (err) {
                    $("#demo_success").html("OOPS! We are facing problems while placing your request. Please try back after sometime. Thanks for choosing us.");
                    $("#demo_success").css("display", "block");
                }
            });
        }
    }
    else {
        // insert value in database
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: 'userpagewebservices/signup.asmx/company_demo',
            data: JSON.stringify({ username: username, companyname: companyname, email: email, mobile: mobile }),
            success: function () {
                $("#demo_success").html("Thank You! We received your request. One of our team members will be in touch with you shortly.");
                $("#demo_success").css("display", "block");
                $(".business-reg-form input").each(function () {
                    $(this).val('');
                });
            },
            error: function (err) {
                $("#demo_success").html("OOPS! We are facing problems while placing your request. Please try back after sometime. Thanks for choosing us.");
                $("#demo_success").css("display", "block");
            }
        });

    }

});

    