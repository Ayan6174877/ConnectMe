showfollowers();
function showfollowers() {
    $('#loadingfollowers').html('');
    $.ajax({
        url: '../../companypagewebservices/network.asmx/loadfollowers',
        method: 'POST',
        dataType: 'json',
        cache: 'true',
        beforeSend: function () {
            $("#followerloader").css("display", "block");
        },
        success: function (data) {
            $("#followerloader").css("display", "none");
            if (data.length == 0) {
                $(".nofollowers").css("display", "block");
            }
            else {
                $(data).each(function (index, item) {
                    $(".nofollowers").css("display", "none");
                 
                    $('<div class="user-limited-profile"> \
                            <a href = "../../user/profile/profile.aspx?id='+ item.username + '" > <img id="profile_image_' + item.username + '" /></a > \
                            <div class="block-network" > \
                            <p class = "user-limited-name" > '+ item.name + ' </p > \
                            <p class = "user-limited-title" > '+ item.profiletitle + ' </p> \
                            <p class = "user-limited-company" > '+ item.companydeatils + ' </p> \
                            </div> \
                            </div>').appendTo($('#loadingfollowers'));

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
            $("#followerloader").css("display", "none");
            $(".nofollowers").css("display", "block");
        }

    });

}
