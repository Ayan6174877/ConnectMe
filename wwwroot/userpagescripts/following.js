// loading the people the user is foolowing
showfollowing();
function showfollowing() {
    $('#loadingfollowing').html('');
    $.ajax({
        url: '../../userpagewebservices/network.asmx/loadfollowing',
        method: 'POST',
        dataType: 'json',
        cache: 'true',
        beforeSend: function () {
            $("#followingloader").css("display", "block");
        },
        success: function (data) {
            $("#followingloader").css("display", "none");
            if (data.length == 0) {
                $(".nofollowing").css("display", "block");
            }
            else {
                $(data).each(function (index, item) {
                    $(".nofollowing").css("display", "none");
                    
                    $('<div class="user-limited-profile"> \
                          <span data-username = '+ item.username + ' class="network-btn unfollow-connection">Following</span>\
                            <a href = "../../user/profile/profile.aspx?id='+ item.username + '" > <img id="profile_image_' + item.username + '" /></a > \
                            <div class="block-network" > \
                            <p class = "user-limited-name" > '+ item.name + ' </p > \
                            <p class = "user-limited-title" > '+ item.profiletitle + ' </p> \
                            <p class = "user-limited-company" > '+ item.companydeatils + ' </p> \
                            </div> \
                            </div>').appendTo($('#loadingfollowing'));
                    //unfollow-connection
                            if (item.profilepic == null) {
                                $('img[id = "profile_image_' + item.username + '"').attr("src", "../images/user.jpg");
                                // $('img[id = "profile_image_' + item.username + '"').css("background-color", "purple");
                            }
                            else {
                                $('img[id = "profile_image_' + item.username + '"').attr("src", "data: Image/png;base64," + item.profilepic);

                            }
                });
            }
        },

        error: function (err) {
            $("#followingloader").css("display", "none");
            $(".nofollowing").css("display", "block");
        }
    });

}

$(document).on("mouseenter", ".unfollow-connection", function (e) {
    $(this).html("Unfollow");
});

$(document).on("mouseleave", ".unfollow-connection", function (e) {
    $(this).html("Following");
});


// unfollow the connection from the list
$(document).on("click", ".unfollow-connection", function () {
    let username = $(this).data("username");
    let panel = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/network.asmx/unfollowconnection',
        data: JSON.stringify({ username: username }),
        success: function () {
            $(panel).closest('.user-limited-profile').fadeOut(1000);
            showfollowingcount();
        }
    });
});
