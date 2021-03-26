getnotification();
function getnotification() {
    $.ajax({
        // contentType: "application/json; charset=utf-8",
        url: '../../userpagewebservices/userloadingnotifications.asmx/loadnotification',
        method: 'post',
        dataType: "json",
        beforeSend: function () {
            $("#notiloader").css("display", "block");
        },
        success: function (data) {
            $("#notiloader").css("display", "none");
            if (data.length == 0) {
                $("#notiloader").css("display", "none");
                $("#no_notifications").css("display", "block");
            }
            else {
                $(data).each(function (index, item) {
                    if (item.notitype == "like") {
                        $('<a class="notilinks" href=' + item.notificationnavigateurl + ' target="_blank" ><li id="customlikeread_' + item.notiid + '" class="load-noti-li">  <div class="notitime" data-livestamp = ' + item.time + '>' + item.time + '</div>   <div id="customliketext_' + item.notiid + '" class="load-notification-content" > ' + item.name + '</div>     <div id="customlikepost_' + item.notiid + '" class="notification-post-content"></div>    <div id="customlikeimagedata_' + item.notiid + '" class="likenotificationimage"></div>   </li></a>').appendTo($("#loadingnotifications"));

                        // checking whther the notiifcation is already read or not
                        if (item.flag == "1") {
                            $('#customlikeread_' + item.notiid).addClass("notification-read");
                        }
                        else {
                            $('#customlikeread_' + item.notiid).addClass("notification-unread");
                        }

                        // counting the name of the usrs liked the post
                        var countname = 0;
                        let customcontent = "";
                        $('div#customliketext_' + item.notiid + ' span.nameuser').each(function () {
                            countname++;
                            if (countname == 1) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " liked your post";
                            }
                            else if (countname == 2) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " liked your post";
                            }
                            else if (countname == 3) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " liked your post";
                            }
                            else {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " and <b>" + (item.count - 3).toString() + " others</b> liked your post";
                            }
                        });

                        $('#customliketext_' + item.notiid).html(customcontent);
                        // loading the image for the likes for this notification
                        loadnotificationimage(item.notiid, item.postid);
                        loadnotificationpost(item.notiid, item.postid);
                    }

                    // notification generated for comments
                    else if (item.notitype == "comment") {

                        $('<a class="notilinks" href=' + item.notificationnavigateurl + ' target ="_self" >  <li id="customlikeread_' + item.notiid + '" class="load-noti-li">  <div class="notitime" data-livestamp = ' + item.time + '>' + item.time + '</div>   <div id="customliketext_' + item.notiid + '" class="load-notification-content" > ' + item.name + '</div>     <div id="customlikepost_' + item.notiid + '" class="notification-post-content"></div>    <div id="customlikeimagedata_' + item.notiid + '" class="likenotificationimage"></div>    </li></a> ').appendTo($("#loadingnotifications"));

                        // checking whther the notiifcation is already read or not
                        if (item.flag == "1") {
                            $('#customlikeread_' + item.notiid).addClass("notification-read");
                        }
                        else {
                            $('#customlikeread_' + item.notiid).addClass("notification-unread");
                        }

                        // counting the name of the usrs liked the post
                        var countname = 0;
                        let customcontent = "";
                        $('div#customliketext_' + item.notiid + ' span.nameuser').each(function () {
                            countname++;
                            if (countname == 1) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " commented on your post";
                            }
                            else if (countname == 2) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " commented on your post";
                            }
                            else if (countname == 3) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " commented on your post";
                            }
                            else {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " and <b>" + (item.count - 3).toString() + " others</b> commented on your post";
                            }
                        });

                        $('#customliketext_' + item.notiid).html(customcontent);
                        // loading the image for the likes for this notification
                        loadnotificationimagecomments(item.notiid, item.postid);
                        loadnotificationpost(item.notiid, item.postid);

                    }

                    // if someone has mentioed the user in a post
                    else if (item.notitype == "mentioned") {

                        $('<a class="notilinks" href=' + item.notificationnavigateurl + ' target ="_self"  ><li id="customlikeread_' + item.notiid + '" class="load-noti-li">  <div class="notitime" data-livestamp = ' + item.time + '>' + item.time + '</div>   <div id="customliketext_' + item.notiid + '" class="load-notification-content" > ' + item.name + '</div>    <div id="customlikepost_' + item.notiid + '" class="notification-post-content"></div>   </li></a>').appendTo($("#loadingnotifications"));

                        // checking whther the notiifcation is already read or not
                        if (item.flag == "1") {
                            $('#customlikeread_' + item.notiid).addClass("notification-read");
                        }
                        else {
                            $('#customlikeread_' + item.notiid).addClass("notification-unread");
                        }

                        loadnotificationpost(item.notiid, item.postid);

                    }

                    else if (item.notitype == 'visitors') {

                        $('<a class="notilinks" href=' + item.notificationnavigateurl + ' target ="_self"  >  <li id="customlikeread_' + item.notiid + '" class="load-noti-li">  <div class="notitime" data-livestamp = ' + item.time + '>' + item.time + '</div>   <div id="customliketext_' + item.notiid + '" class="load-notification-content" > ' + item.name + '</div>       <div id="customlikeimagedata_' + item.notiid + '" class="likenotificationimage"></div>    </li></a> ').appendTo($("#loadingnotifications"));

                        // checking whther the notiifcation is already read or not
                        if (item.flag == "1") {
                            $('#customlikeread_' + item.notiid).addClass("notification-read");
                        }
                        else {
                            $('#customlikeread_' + item.notiid).addClass("notification-unread");
                        }

                        // counting the name of the usrs liked the post
                        var countname = 0;
                        let customcontent = "";
                        $('div#customliketext_' + item.notiid + ' span.nameuser').each(function () {

                            countname++;
                            if (countname == 1) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " viewed your profile";
                            }
                            else if (countname == 2) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " viewed your profile";
                            }
                            else if (countname == 3) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " viewed your profile";
                            }
                            else {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " and <b>" + (item.count - 3).toString() + " others</b> viewed your profile";
                            }

                        });

                        $('#customliketext_' + item.notiid).html(customcontent);
                        loadnotificationvisitors(item.notiid);
                    }

                    else if (item.notitype == 'shared profile') {

                        $('<a class="notilinks" href=' + item.notificationnavigateurl + ' target ="_self" >  <li id="customlikeread_' + item.notiid + '" class="load-noti-li">  <div class="notitime" data-livestamp = ' + item.time + '>' + item.time + '</div>   <div id="customliketext_' + item.notiid + '" class="load-notification-content" > ' + item.name + '</div>          </li></a> ').appendTo($("#loadingnotifications"));

                        // checking whther the notiifcation is already read or not
                        if (item.flag == "1") {
                            $('#customlikeread_' + item.notiid).addClass("notification-read");
                        }
                        else {
                            $('#customlikeread_' + item.notiid).addClass("notification-unread");
                        }

                        // counting the name of the usrs liked the post
                        var countname = 0;
                        let customcontent = "";
                        $('div#customliketext_' + item.notiid + ' span.nameuser').each(function () {

                            countname++;
                            if (countname == 1) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " shared profile with you";
                            }
                            else if (countname == 2) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " shared profiles with you";
                            }
                            else if (countname == 3) {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + " and " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " shared profiles with you";
                            }
                            else {
                                customcontent = "<b>" + $('span.nameuser:nth-child(1)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(2)').html() + "</b>" + ", " + "<b>" + $('span.nameuser:nth-child(3)').html() + "</b>" + " and <b>" + (item.count - 3).toString() + " others</b> shared profiles with you";
                            }

                        });

                        $('#customliketext_' + item.notiid).html(customcontent);

                    }

                    else if (item.notitype == 'following') {
                        $('<a class="notilinks" href=' + item.notificationnavigateurl + ' target ="_self"  >  <li id="customlikeread_' + item.notiid + '" class="load-noti-li">  <div class="notitime" data-livestamp = ' + item.time + '>' + item.time + '</div>   <div id="customliketext_' + item.notiid + '" class="load-notification-content" > ' + item.name + '</div>          </li></a> ').appendTo($("#loadingnotifications"));
                    }


                    else if (item.notitype == 'job status') {
                        $('<a class="notilinks" href=' + item.notificationnavigateurl + ' target ="_self"  >  <li id="customlikeread_' + item.notiid + '" class="load-noti-li">  <div class="notitime" data-livestamp = ' + item.time + '>' + item.time + '</div>   <div id="customliketext_' + item.notiid + '" class="load-notification-content" > ' + item.customtext + '</div>          </li></a> ').appendTo($("#loadingnotifications"));
                    }


                });
            }
        },
        error: function (err) {
            $("#notiloader").css("display", "none");
            $("#no_notifications").css("display", "block");
        }
    });

}


function loadnotificationpost(notiid, postid) {
    $.ajax({
        // contentType: "application/json; charset=utf-8",
        url: '../../userpagewebservices/userloadingnotifications.asmx/loadnotificationposts',
        method: 'post',
        dataType: "json",
        data: { postid: postid },
        success: function (data) {
            $(data).each(function (index, item) {
                let dataposts = decodeURI(item.postdescription);
                let subtext = dataposts.replace(/<[^>]+>/g, '');
                if (subtext.length > 150) {
                    subtext = subtext.substring(0, 149) + "....";
                }
                else {
                    subtext = subtext;
                }

                if (item.post != "") {
                    if (item.postimage != null) {
                        $('#customlikepost_' + notiid).css("display", "block");
                        $('<div class="row"><div class="col-lg-4" ><img class="noti-post-image" src= ' + "data:Image/png;base64," + item.postimage + ' /></div><div class="col-lg-7 noti-post-text" >' + subtext + '</div></div>').appendTo($('#customlikepost_' + notiid));
                    }
                    else {
                        $('<div class="row"><div class="col-lg-12 noti-post-text" style="padding:15px 25px" >' + subtext + '</div></div>').appendTo($('#customlikepost_' + notiid));
                    }
                }
                else {
                    $('#customlikepost_' + notiid).css("display", "none");
                }
            });
        },
        error: function (err) {
            $('#customlikepost_' + notiid).css("display", "none");
        }
    });


}

function loadnotificationimage(notiid, postid) {
    $.ajax({
        // contentType: "application/json; charset=utf-8",
        url: '../../userpagewebservices/userloadingnotifications.asmx/loadnotificationimage',
        method: 'post',
        dataType: "json",
        data: { postid: postid },
        success: function (data) {
            $(data).each(function (index, item) {
                if (item.profilepic == null) {
                    $('<img class="imagesize" src="images/grey.png" />').appendTo($('#customlikeimagedata_' + notiid));
                }
                else {
                    $('<img class="imagesize" src= ' + "data:Image/png;base64," + item.profilepic + ' />').appendTo($('#customlikeimagedata_' + notiid));
                }

            });
        },
        error: function (err) {
            //
        }
    });
}


function loadnotificationimagecomments(notiid, postid) {
    $.ajax({
        // contentType: "application/json; charset=utf-8",
        url: '../../userpagewebservices/userloadingnotifications.asmx/loadnotificationimagecomments',
        method: 'post',
        dataType: "json",
        data: { postid: postid },
        success: function (data) {
            $(data).each(function (index, item) {
                if (item.profilepic == null) {
                    $('<img class="imagesize" src="images/grey.png" />').appendTo($('#customlikeimagedata_' + notiid));
                }
                else {
                    $('<img class="imagesize" src= ' + "data:Image/png;base64," + item.profilepic + ' />').appendTo($('#customlikeimagedata_' + notiid));
                }

            });
        },
        error: function (err) {
            //
        }
    });
}


function loadnotificationvisitors(notiid) {
    $.ajax({
        // contentType: "application/json; charset=utf-8",
        url: '../../userpagewebservices/userloadingnotifications.asmx/loadnotificationprofilevisitors',
        method: 'post',
        dataType: "json",
        success: function (data) {
            $(data).each(function (index, item) {
                if (item.profilepic == null) {
                    $('<img class="imagesize" src="images/user.jpg" />').appendTo($('#customlikeimagedata_' + notiid));
                }
                else {
                    $('<img class="imagesize" src= ' + "data:Image/png;base64," + item.profilepic + ' />').appendTo($('#customlikeimagedata_' + notiid));
                }

            });
        },
        error: function (err) {
            //
        }
    });

}
