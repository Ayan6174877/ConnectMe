totalblockcount = 0;
showblockpeople();
function showblockpeople() {
    $('#load_block_user').html('');
    $.ajax({
        url: 'userpagewebservices/settings.asmx/checkblock',
        method: 'POST',
        dataType: 'json',
        cache: 'true',
        beforeSend: function () {
            $("#block_loader").css("display", "block");
        },
        success: function (data) {
            totalblockcount = Object.keys(data).length;
            $("#block_loader").css("display", "none");
            if (data.length == 0) {
                $(".no-block").css("display", "block");
            }
            else {
                $(data).each(function (index, item) {
                    $(".no-block").css("display", "none");
                    $('<div class="block-user-div"><img id="profile_image_' + item.username + '"  src = data:Image/png;base64,' + item.profilepic + ' ><div class="block-user-details"><h3>' + item.name + ' </h3><p>' + item.profiletitle + ' </p></div><span data-username = \"' + item.username + '\" class="unblock" >Unblock</span> </div>').appendTo($('#load_block_user'));
                    if (item.profilepic == null) {
                        $('img[id = "profile_image_' + item.username + '"').attr("src", "images/grey.png");
                    }
                });
            }
        },
        error: function (err) {
            $("#block_loader").css("display", "none");
            $(".no-block").css("display", "block");
        }
    });
}


$(document).on("click", ".unblock", function () {
    username = $(this).data("username");
    btn = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: 'userpagewebservices/settings.asmx/unblockuser',
        data: JSON.stringify({ username: username }),
        success: function () {
            $(btn).closest('.block-user-div').fadeOut();
            totalblockcount = totalblockcount - 1;
        },
        error: function (err) {
            //
        }
    });
});