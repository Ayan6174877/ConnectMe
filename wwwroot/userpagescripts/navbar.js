// scripts for the navigation bars
// includes search and notification counts and image and some data rendering

$(document).ready(function () {

    // navigation between pages on click
    $(document).on("click", ".navigation-home", function () {
        window.location.href = "../../user/feed.aspx";
    });

    $(document).on("click", ".navigation-network", function () {
        window.location.href = "../../user/network/network.aspx";
    });

    $(document).on("click", ".navigation-notifications", function () {
        window.location.href = "../../user/notifications.aspx";
    });

    $(document).on("click", ".navigation-inbox", function () {
        window.location.href = "../../user/inbox.aspx";
    });

    $(document).on("click", ".navigation-profile", function () {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/notificationload.asmx/returnSession',
            success: function (data) {
                window.location.href = "../../user/profile/profile.aspx?id="+ data.d +"";
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    $(document).on("click", ".navigation-logout", function () {
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/notificationload.asmx/logout',
            success: function () {
                window.location = "../../jobeneur/index.html";
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    $(document).on("click", ".show-nav-options", function () {
        //$(".nav-more-options").css("width", "300px");
        //$('body,html').css("overflow", "hidden");

        $(".nav-more-options").fadeToggle();
    });

    $(document).on("click", ".close-nav-option", function () {
        $(".nav-more-options").css("width", "0px");
        $('body,html').css("overflow", "auto");
    });


// script for formatting div contenteditable auto styling while data is posted
    [].forEach.call(document.querySelectorAll('div[contenteditable="true"]'), function (el) {
        el.addEventListener('paste', function (e) {
            e.preventDefault();
            var text = (e.originalEvent || e).clipboardData.getData("text");
            text = text.replace(/(?:\r\n|\r|\n)/g, '<br>');
            document.execCommand("insertHTML", false, text);
        }, false);
    });


    // getting notification count for posts, activities, job updates

    getallnotificationcount();
    function getallnotificationcount() {
        $.ajax({
            url: '../../userpagewebservices/notificationload.asmx/bindnotificationscount',
            method: 'post',
            dataType: "json",
            success: function (data) {
                if (data.length == 0) {
                }
                else {
                    $(data).each(function (index, item) {
                        if (item.notificationcount == '0') {
                            $("#countnotifications").css("display", "none");
                        }
                        else {
                            $("#countnotifications").html(item.notificationcount);
                        }

                    });
                }
            },
            error: function (err) {
            }
        });
    }


    // counting the message for the user
    getmessagecount();
    function getmessagecount() {
        $.ajax({
            url: '../../userpagewebservices/notificationload.asmx/countmessages',
            method: 'post',
            dataType: "json",
            success: function (data) {
                if (data.length == 0) {
                }
                else {
                    $(data).each(function (index, item) {
                        if (item.messagecount == '0') {
                            $("#countmessage").css("display", "none");
                        }
                        else {
                            $("#countmessage").html(item.messagecount);
                        }

                    });
                }
            },

            error: function (err) {

            }

        });
    }

    // request count 
    requestcount();
    function requestcount() {
        $.ajax({
            url: '../../userpagewebservices/notificationload.asmx/bindverificationcount',
            method: 'post',
            dataType: "json",
            success: function (data) {
                if (data.length == 0) {
                }
                else {
                    $(data).each(function (index, item) {
                        if (item.networkcount == '0') {
                            $("#peoplecount").css("display", "none");
                        }
                        else {
                            $("#peoplecount").html(item.networkcount);
                        }

                    });
                }
            },
            error: function (err) {

            }
        });
    }


    // get nav bar image, title and other details
    getnameimage();
    function getnameimage() {
        $.ajax({
            url: '../../userpagewebservices/notificationload.asmx/getprofileimage',
            method: 'post',
            dataType: "json",
            success: function (data) {
                if (data.length == 0) {

                }
                else {
                    $(data).each(function (index, item) {
                        if (item.profilepic == null) {
                            $('.profile-picture-render').attr("src", "images/user.jpg");
                        }
                        else {
                            $('.profile-picture-render').attr("src", item.profilepic);
                        }

                        if (item.coverpic == null) {
                            $('.profile-cover-render').css("background-color", "darkcyan");
                        }
                        else {
                            $('.profile-cover-render').attr("src", item.coverpic);
                        }

                        $('.profile-name-render').html(item.name);
                        $('.profile-title-render').html(item.profiletitle);
                    });
                }
            },
            error: function (err) {
                alert(err);
            }
        });
    }


    // search bar and search autocomplete
    $("#quick_search").on('blur', function () {
        $(".loading-search-results").css("display", "none");
    });

    $("#quick_search").on('focus', function () {
        $(".loading-search-results").css("display", "block");
    });

    $("#quick_search").on("keyup", function () {
        var SearchVal = $("#quick_search").val();
        if (SearchVal.length === 0 || SearchVal === '') {
            $(".loading-search-results").css("display", "none");
        }
        else {
            $(".loading-search-results").css("display", "block");
            // calling the ajax function
            $.ajax({
                url: '../../userpagewebservices/quickautocomplete.asmx/people',
                method: 'post',
                dataType: "json",
                data: { searchkeyword: SearchVal },
                beforeSend: function () {
                    //  $("#networkloader").css("displa*y", "block");
                },
                success: function (data) {
                    $('.load-search').empty();
                    //  $("#networkloader").css("display", "none");
                    if (data.length == 0) {
                        //  $(".nonetwork").css("display", "block");
                    }
                    else {
                        $(data).each(function (index, item) {
                            // $(".nonetwork").css("display", "none");
                            $('<a href="profile_guest.aspx?username=' + item.username + '"> <div class="load-result-data"><img id="profile_image_' + item.username + '" src = data:Image/png;base64,' + item.profilepic + ' > <ul><li>' + item.name + '</li><li>' + item.profiletitle + '</li></ul></div></a>').appendTo($('.load-search'));

                            if (item.profilepic == null) {
                                $('img[id = "profile_image_' + item.username + '"').attr("src", "images/user.jpg");
                            }
                        });
                    }
                },
                error: function (xhr, status, error) {
                    var errorMessage = xhr.status + ': ' + xhr.statusText
                    alert('Error - ' + errorMessage);
                }
            });

        }

    });


});
