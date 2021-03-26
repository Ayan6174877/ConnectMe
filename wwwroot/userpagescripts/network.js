// user side script for the frinds.aspx page

$(document).ready(function () {

    // loading the people in the network
    shownetworkpeople();
    function shownetworkpeople() {
        $('#loadingnetwork').html('');
        $.ajax({
            url: '../../userpagewebservices/network.asmx/loadnetwork',
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
                        $('<div class="user-limited-profile"> \
                          <span data-username = '+ item.username +' class="network-btn remove-connection">Connected</span>\
                          <a href="../../user/profile/profile.aspx?id='+ item.username +'" ><img id="profile_image_' + item.username + '"  /></a> \
                            <div class="block-network" > \
                            <p class = "user-limited-name" > '+ item.name +' </p > \
                            <p class = "user-limited-title" > '+ item.profiletitle +' </p> \
                            <p class = "user-limited-company" > '+ item.companydeatils +' </p> \
                            </div> \
                            </div>').appendTo($('#loadingnetwork'));

                               if (item.profilepic == null) {
                                    $('img[id = "profile_image_' + item.username + '"').attr("src", "../images/user.jpg");
                                   // $('img[id = "profile_image_' + item.username + '"').css("background-color", "purple");
                                }
                                else {
                                    $('img[id = "profile_image_' + item.username + '"').attr("src", "data: Image/png;base64," + item.profilepic );

                                }
                            });
                        }
            },

            error: function (err) {
                $("#networkloader").css("display", "none");
                $(".nonetwork").css("display", "block");
            }
        });

    }

  
    $(document).on("mouseenter", ".network-btn", function (e) {
        $(this).html("Remove");
    });

    $(document).on("mouseleave", ".network-btn", function (e) {
        $(this).html("Connected");
    });


    // remvoing the connection from the list
    $(document).on("click", ".remove-connection", function () {
        let username = $(this).data("username");
        let panel = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/network.asmx/deleteconnections',
            data: JSON.stringify({ username: username }),
            success: function () {
                $(panel).closest('.user-limited-profile').fadeOut(1000);
           }
        });
    });


    // pending invites ( only 3 )
    shownetworkrequest();
    function shownetworkrequest() {
        $.ajax({
            url: '../../userpagewebservices/network.asmx/loadnetworkrequests',
            method: 'POST',
            dataType: 'json',
            beforeSend: function () {
              //  $("#networkrequestloader").css("display", "block");
            },
            success: function (data) {
                if (data.length == 0) {
                    $("#invites_panel").css("display", "none");
                }
                else {
                    $(data).each(function (index, item) {
                        $('<div class="user-limited-profile"> \
                            <div class="request-btn-div">\
                            <span class="acceptnetworkrequest fa fa-check request-btn-style" title="Accept request" data-username = '+ item.username + '></span>\
                            <span class="removenetworkrequest fa fa-remove request-btn-style" title="Decline request" data-username = ' + item.username + '></span>\
                            </div>\
                            <a href = "../../user/profile/profile.aspx?id='+ item.username + '" > <img id="profile_image_' + item.username + '" /></a > \
                            <div class="block-network" > \
                            <p class = "user-limited-name" > '+ item.name + ' </p > \
                            <p class = "user-limited-title" > '+ item.profiletitle + ' </p> \
                            <p class = "user-limited-company" > '+ item.companydeatils + ' </p> \
                            </div> \
                            </div>').appendTo($('#loadingnetworkrequest'));

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
                $("#invites_panel").css("display", "none");
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
                $(panel).closest('.user-limited-profile').fadeOut();
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
                $(panel).closest('.user-limited-profile').fadeOut();
            }
        });
    });




});
