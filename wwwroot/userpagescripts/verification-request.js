
showverifyrequest();
function showverifyrequest() {
    $.ajax({
        url: '../../companypagewebservices/network.asmx/loadverificationrequests',
        method: 'POST',
        dataType: 'json',
        beforeSend: function () {
            $("#loader2").css("display", "block");
        },
        success: function (data) {
            $("#loader2").css("display", "none");
            if (data.length == 0) {
                $(".noverify").css("display", "block");
            }
            else {
                $(data).each(function (index, item) {
                    $(".noverify").css("display", "none");
                    $('<li><div class="user-short-profile"><ul class="network-options"><li class="acceptverify" data-expid = ' + item.expid + '><span class="fa fa-check"></span> Accept verification request</li><li class="declineverify" data-expid = ' + item.expid + '><span class="fa fa-remove"></span> Remove verification request</li></ul><a href="portfolio.aspx?username=' + item.username + '"><div class="user-short-profile-header"><img id = "profile_image_' + item.username + '" class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ></div></a><div class="user-profile-main-body"><h3>' + item.name + ' </h3><h5 >' + item.companydeatils + ' </h4><p >' + item.expdate + ' </p></div></div></li>').appendTo($('#loadingverify'));

                    if (item.profilepic == null) {
                        $('img[id = "profile_image_' + item.username + '"').attr("src", "../../images/user.png");
                    }
                });
            }
        },

        error: function (err) {
            $(".noverify").css("display", "block");
            $("#loader2").css("display", "none");
        }

    });
}


// accepting the verification request for the data of the user
$(document).on("click", ".acceptverify", function () {
    expid = $(this).data("expid");
    panel = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../companypagewebservices/network.asmx/acceptverifyrequest',
        data: JSON.stringify({ expid: expid }),
        success: function () {
            $(panel).closest('.user-short-profile').fadeOut();
            countverification();
        }
    });
});

// declining the verification request for the data of the user
$(document).on("click", ".declineverify", function () {
    expid = $(this).data("expid");
    panel = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../companypagewebservices/network.asmx/declineverifyrequest',
        data: JSON.stringify({ expid: expid }),
        success: function () {
            $(panel).closest('.user-short-profile').fadeOut();
        }
    });
});
