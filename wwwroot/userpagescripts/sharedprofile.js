
// shared profile page
$(document).ready(function () {

    loadsharedprofile();

    // loading the people in the network
    function loadsharedprofile() {
        $('#loadsharedprofiles').html('');
        $.ajax({
            url: 'userpagewebservices/network.asmx/loadsharedprofile',
            method: 'POST',
            dataType: 'json',
            cache: 'true',
            beforeSend: function () {
                $("#networkloader").css("display", "block");
            },
            success: function (data) {
                $("#networkloader").css("display", "none");
                if (data.length == 0) {
                    $(".nonetwork").css("display", "block");
                }
                else {
                    $(data).each(function (index, item) {
                        $(".nonetwork").css("display", "none");
                        $('<li><div class="user-short-profile"><ul class="network-options"><li class="view-profile-click" data-link = ' + item.username + '><span class="fa fa-user-o"></span> View profile</li><li  data-profileid = ' + item.id + ' data-name = \"' + item.name + '\" class="see-message"><span class="fa fa-sticky-note-o"></span> Check out message</li><li  data-username = ' + item.username + ' data-name = \"' + item.name + '\"  class="send-private-message" ><span class="fa fa-inbox"></span> Start a Conversation</li></ul><a href="profile_guest.aspx?username=' + item.username + '"><div class="user-short-profile-header"><img id="profile_image_' + item.username + '" class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ></div></a><div class="user-profile-main-body"><h3>' + item.name + ' </h3><h5 >' + item.companydeatils + ' </h4><p >' + item.profiletitle + ' </p><p class="timeago" title=\"' + item.time + '\" >' + item.time + '</p></div></div></li>').appendTo($('#loadsharedprofiles'));

                        if (item.profilepic == null) {
                            $('img[id = "profile_image_' + item.username + '"').attr("src", "images/grey.png");
                        }

                    });
                    $(".timeago").timeago();
                }

            },

            error: function (err) {
                $("#networkloader").css("display", "none");
                $(".nonetwork").css("display", "block");
            }
        });

    }

    // click to view the profile of the user 
    $(document).on("click", ".view-profile-click", function () {
        let username = $(this).data("link");
        window.open("profile_guest.aspx?username=" + username, "_self");
    });

    // click to view the short note
    $(document).on("click", ".see-message", function () {
        //  let message = $(this).data("message").replace(/\n/g, "<br>");
        profileid = $(this).data("profileid");
        let name = $(this).data("name");
        $("#headertext").html("Message by " + name);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../userpagewebservices/network.asmx/getfullmessage',
            data: JSON.stringify({ id: profileid }),
            delay: '10',
            beforeSend: function () {
                $("#loader-about").css("display", "block");
            },
            success: function (data) {
                $("#loadmessage").html(data.d);
                $("#short-note").modal('show');
            },
            error: function (err) {
                alert(err);
            }
        });

    });


});