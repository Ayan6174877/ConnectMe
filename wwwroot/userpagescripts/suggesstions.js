
// people recommendations

loadpeoplesuggestions();
function loadpeoplesuggestions() {
    $('#load_people_suggestions').html('');
    $.ajax({
        url: '../../userpagewebservices/suggesstions.asmx/showusersuggesstions',
        method: 'POST',
        dataType: 'json',
        cache: 'true',
        delay: '10',
        beforeSend: function () {
           // $("#user_sugeestion_loader").css("display", "block");
        },
        success: function (data) {
           // $("#user_sugeestion_loader").css("display", "none");
            if (data.length == 0) {
                $('#load_people_suggestions').css("display", "none");
            }
            else {
                $(data).each(function (index, item) {
                    if (item.profiletitle == '') {
                        item.profiletitle = 'Looking for new opportunities';
                    }

                    $('<div class="load-suggestion-user">\
                        <a href="profile/profile?id=' + item.username + '">\
                        <img id="suggestion_image_' + item.username + '" src = data:Image/png;base64,' + item.profilepic + ' />\
                        </a >\
                        <div class="block-recommentdation">\
                        <p class="user-name">'+ item.name +'</p><p class="user-title">'+ item.profiletitle +'</p>\
                        </div></div>').appendTo($('#load_people_suggestions'));
                    if (item.profilepic == null) {
                        $('img[id = "suggestion_image_' + item.username + '"').attr("src", "../../user/images/user.jpg");
                        // <span data-username= \"'+ item.username + '\" class="add-people-suggesstion" title="Follow">Follow</span>
                    }
                });
            }
        },
        error: function (err) {
            $("#user_sugeestion_loader").css("display", "none");
            $(".hide-suggestion").css("display", "none");
        }
    });
}

$(document).on("click", ".add-people-suggesstion", function () {
    username = $(this).data("username");
    let Followstatus = "requested";
    suggestbtn = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/user_profile_guest_main.asmx/Sendrequest',
        data: JSON.stringify({ username: username, Followstatus: Followstatus }),
        success: function () {
            // on showing cancel friend request therwise hiding every other button
            $(suggestbtn).fadeOut(1000);
        },
        error: function (err) {
            alert(err);
        }
    });

});
