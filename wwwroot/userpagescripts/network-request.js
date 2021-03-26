// scripts fro network requests

shownetworkrequest();
function shownetworkrequest() {
    $.ajax({
        url: '../../userpagewebservices/network.asmx/loadnetworkrequests',
        method: 'POST',
        dataType: 'json',
        beforeSend: function () {
            $("#networkrequestloader").css("display", "block");
        },
        success: function (data) {
            $("#networkrequestloader").css("display", "none");
            if (data.length == 0) {
                $(".nonetworkrequest").css("display", "block");
            }
            else {
                $(data).each(function (index, item) {
                    $(".nonetworkrequest").css("display", "none");
                    $('<li><div class="user-short-profile"><ul class="network-options"><li class="acceptnetworkrequest" data-username = ' + item.username + '><span class="fa fa-check"></span> Accept request</li><li class="removenetworkrequest" data-username = ' + item.username + '><span class="fa fa-remove"></span> Decline request</li></ul><a href="profile_guest.aspx?username=' + item.username + '"><div class="user-short-profile-header"><img id = "profile_image_' + item.username + '" class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ></div></a><div class="user-profile-main-body"><h3>' + item.name + ' </h3><h5 >' + item.companydeatils + ' </h4><p >' + item.profiletitle + ' </p></div></div></li>').appendTo($('#loadingnetworkrequest'));

                    if (item.profilepic == null) {
                        $('img[id = "profile_image_' + item.username + '"').attr("src", "../images/user.png");
                    }

                });
            }
        },

        error: function (err) {
            $(".nonetworkrequest").css("display", "block");
        }

    });
}

// accepting the network request for the data of the user
$(document).on("click", ".acceptnetworkrequest", function () {
    username = $(this).data("username");
    panel = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/network.asmx/acceptrequest',
        data: JSON.stringify({ username: username }),
        success: function () {
            $(panel).closest('.user-short-profile').fadeOut();
        },
        error: function (err) {
            //
        }
    });
});


// declining the verification request for the data of the user
$(document).on("click", ".removenetworkrequest", function () {
    username = $(this).data("username");
    panel = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/network.asmx/removerequest',
        data: JSON.stringify({ username: username }),
        success: function () {
            $(panel).closest('.user-short-profile').fadeOut();
        }
    });
});
