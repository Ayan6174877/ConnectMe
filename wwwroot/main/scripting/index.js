$(document).ready(function(){

    $(document).on("click",".error-close", function(){
        $(this).closest(".error-message").fadeOut();
    });

    setInterval(changeimage, 10000);
    var imageCount = 1;
    function changeimage() {
        var leftOffset1 = $('#img_' + imageCount).offset().left - $('#main_landing_scroll').offset().left + $('#main_landing_scroll').scrollLeft();
        $('#main_landing_scroll').animate({ scrollLeft: leftOffset1 }, 2000);
        var leftOffset2 = $('#img_small_' + imageCount).offset().left - $('#small_image_scroll').offset().left + $('#small_image_scroll').scrollLeft();
        $('#small_image_scroll').animate({ scrollLeft: leftOffset2 }, 2000);

        imageCount++;
        if (imageCount == 5) {
            imageCount = 1;
        }
    }

   
    $(document).on("click", ".community-dot", function () {
        $(".community-move span.fa").css("opacity", "0.6");
        $(this).css("opacity", "1");
        id = $(this).data("id");
        var leftOffset1 = $('#community_' + id).offset().left - $('.community-section').offset().left + $('.community-section').scrollLeft();
        $('.community-section').animate({ scrollLeft: leftOffset1 }, 1000);
    });


    setInterval(callSecondSection, 5000);
    ExploreCount = 1;
    function callSecondSection() {
        $(".toggle-section span:nth-child(" + ExploreCount + ")").trigger('click');
        ExploreCount += 1;
        if (ExploreCount == 4) {
            ExploreCount = 1;
        }
    }

    // clicking different tabs in the second section
    $(document).on("click", "#toggle_job", function () {
        $(".toggle-section span").each(function () {
            $(this).removeClass("active-tab");
        });
        // hiding all other sections
        $(".explore-options").fadeOut();
        $(this).addClass("active-tab");
        $("#job_explore").fadeIn(500);
    });

    $(document).on("click", "#toggle_people", function () {
        $(".toggle-section span").each(function () {
            $(this).removeClass("active-tab");
        });
        // hiding all other sections
        $(".explore-options").fadeOut();
        $(this).addClass("active-tab");
        $("#people_explore").fadeIn(500);
    });

    $(document).on("click", "#toggle_stream", function () {
        $(".toggle-section span").each(function () {
            $(this).removeClass("active-tab");
        });
        // hiding all other sections
        $(".explore-options").fadeOut();
        $(this).addClass("active-tab");
        $("#stream_explore").fadeIn(500);
    });

    $(document).on("click", "#toggle_community", function () {
        $(".toggle-section span").each(function () {
            $(this).removeClass("active-tab");
        });
        // hiding all other sections
        $(".explore-options").fadeOut();
        $(this).addClass("active-tab");
        $("#community_explore").fadeIn(500);
    });

        


    $(document).on("click","#pass_email_btn", function(){
        var EmailVal = $("#pass_email_inout").val();
        var emailpattern = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i;

        if(EmailVal == '' || !emailpattern.test(EmailVal)){
            $("#pass_email_inout").focus();
        }
        else{
            localStorage.setItem("storageName", EmailVal);
            window.location.href = "signup.html";
        }
    });

});

//window.onload = function () {
//    let sectionCount = 1;
//    document.body.focus();
//    document.addEventListener("keydown", checkKeyPressed, false);

//    function checkKeyPressed(event) {
//        var x = event.which || event.keyCode;
//        // scrolling to different sections on arrow keys pressed
//        if (x === 40) {
//            if (sectionCount == 6) {
//                // do nothing
//                ``
//            }
//            else {
//                sectionCount += 1;
//                $('html, body').animate({ scrollTop: $('#section_' + sectionCount).offset().top }, 1000);
//            }
//        }
//        else if (x === 38) {
//            if (sectionCount == 1) {
//                // do nothing
//            }
//            else {
//                sectionCount = sectionCount - 1;
//                $('html, body').animate({ scrollTop: $('#section_' + sectionCount).offset().top }, 1000);
//            }
//        }
//        else {
//            //
//        } ''
//        // if section 2 is active then
//        if (sectionCount == 2) {
//            //
//        }

//    }

//};

