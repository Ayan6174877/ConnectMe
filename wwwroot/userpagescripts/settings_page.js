$(document).ready(function () {
    joineddate();

    function joineddate() {
        //joined_date
        $.ajax({
            contentType: "application/json; charset=utf-8",
            url: 'userpagewebservices/settings.asmx/getjoineddate',
            method: 'post',
            success: function (data) {
                $("#joined_date").html(data.d);
            },
            error: function (err) {
                alert(err);
            }
        });

    }

    $(document).on("click", ".close-successful", function () {
        $(".succesfully-change").css("display", "none");
    });


    $(document).on("click", ".change-option-text", function () {
        these = $(this).closest("li").children("div.update-input");
        $('div.update-input').not(these).slideUp(500);
        $(this).closest("li").children("div.update-input").slideDown(1000);
    });

    // scripts for changing the names

    Existedname = $('#change_name').val();
    $('#change_name').on("focus paste keyup", function () {
        value = $(this).val();
        if (value.length < 3 || value == Existedname) {
            $('.update-name').addClass('btn-disable');
        }
        else {
            $('.update-name').removeClass('btn-disable');
        }
    });

    $(document).on("click", ".update-name", function () {
        namevalue = $('#change_name').val();
        if (namevalue.length < 3) {
            $('.update-name').addClass('btn-disable');
        }
        else {
            $('.update-name').removeClass('btn-disable');
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/settings.asmx/updatename',
                data: JSON.stringify({ name: namevalue }),
                success: function () {
                    $('.succesfully-change').css("display", "block");
                    Existedname = namevalue;
                    $("#loginusername").html(namevalue);
                    $("#name").html(namevalue);
                },
                error: function (err) {
                    alert("err");
                }
            });
        }
    });


    // changing the location
    Existedlocation = $('#change_location').val();
    $('#change_location').on("focus paste keyup", function () {
        value = $(this).val();
        if (value.length < 3 || value == Existedlocation) {
            $('.update-location').addClass('btn-disable');
        }
        else {
            $('.update-location').removeClass('btn-disable');
        }
    });

    $(document).on("click", ".update-location", function () {
        locationvalue = $('#change_location').val();
        if (locationvalue.length < 3) {
            $('.update-location').addClass('btn-disable');
        }
        else {
            $('.update-location').removeClass('btn-disable');
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/settings.asmx/updatelocation',
                data: JSON.stringify({ location: locationvalue }),
                success: function () {
                    $('.succesfully-change').css("display", "block");
                    Existedlocation = locationvalue;
                },
                error: function (err) {
                    alert("err");
                }
            });
        }
    });

    // update mobile
    Existedmobile = $('#change_mobile').val();
    $('#change_mobile').on("focus paste keyup", function () {
        value = $(this).val();
        if (value.length < 10 || value.length > 10 || value == Existedmobile) {
            $('.update-mobile').addClass('btn-disable');
        }
        else {
            $('.update-mobile').removeClass('btn-disable');
        }
    });

    $(document).on("click", ".update-mobile", function () {
        mobilevalue = $('#change_mobile').val();
        if (mobilevalue.length < 10 || mobilevalue.length > 10) {
            $('.update-mobile').addClass('btn-disable');
        }
        else {
            $('.update-mobile').removeClass('btn-disable');
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/settings.asmx/updatemobile',
                data: JSON.stringify({ mobile: mobilevalue }),
                success: function () {
                    $('.succesfully-change').css("display", "block");
                    Existedmobile = mobilevalue;
                },
                error: function (err) {
                    alert("err");
                }
            });
        }
    });


    // closing the closest div for updating values
    $(document).on("click", ".cancel", function () {
        $(this).closest(".update-input").slideUp(1000);
    });


    // privacy page scripts


    $(document).on("change", "#posts", function () {
        value = $(this).val();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/settings.asmx/updatepostprivacy',
            data: JSON.stringify({ valuedata: value }),
            success: function () {
                $('.succesfully-change').css("display", "block");
            },
            error: function (err) {
                alert("err");
            }
        });

    });

    $(document).on("change", "#friends", function () {
        value = $(this).val();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/settings.asmx/updatenetworkprivacy',
            data: JSON.stringify({ valuedata: value }),
            success: function () {
                $('.succesfully-change').css("display", "block");
            },
            error: function (err) {
                alert("err");
            }
        });

    });


    $(document).on("change", "#message", function () {
        value = $(this).val();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/settings.asmx/updatemessageprivacy',
            data: JSON.stringify({ valuedata: value }),
            success: function () {
                $('.succesfully-change').css("display", "block");
            },
            error: function (err) {
                alert("err");
            }
        });

    });



    $(document).on("change", "#activities", function () {
        value = $(this).val();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/settings.asmx/updateactivityprivacy',
            data: JSON.stringify({ valuedata: value }),
            success: function () {
                $('.succesfully-change').css("display", "block");
            },
            error: function (err) {
                alert("err");
            }
        });

    });

    $(document).on("change", "#profiles", function () {
        value = $(this).val();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/settings.asmx/updateprofilerivacy',
            data: JSON.stringify({ valuedata: value }),
            success: function () {
                $('.succesfully-change').css("display", "block");
            },
            error: function (err) {
                alert("err");
            }
        });

    });




});
