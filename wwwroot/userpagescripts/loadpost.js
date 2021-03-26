LoadPost();
function LoadPost() {
    let postid = $("#postid").val();
    imgfile = $('#profilepic').attr('src');
    var username = $("#username").val();
    var usertype = $("#usertype").val();

    if (postid == "") {
        $("#loaders").css("display", "block");
        $(".nofeed").css("display", "block");
    }
    else {
        $.ajax({
            url: '../../userpagewebservices/loadnewsfeed.asmx/loadpostdata',
            method: 'post',
            dataType: "json",
            data: { postid: postid },
            delay: '10',
            beforeSend: function () {
                $("#loaders").css("display", "block");
            },
            success: function (data) {
                if (data.length == 0) {
                    $("#loaders").css("display", "none");
                    $(".nofeed").css("display", "block");
                }
                else {
                    $("#loaders").css("display", "none");
                    $(".nofeed").css("display", "none");
                    $("#post_load").css("display", "block");

                    $(data).each(function (index, item) {
                        $('<div id="loading-post_' + item.postid + '" data-id="' + item.postid + '" class="post-panel" style="border-radius:0px;border-top-color:transparent" > \
                           <div class="post-panel-header > \
                           <a id=" redirect_' + item.postid + '"> \
                           <img id="profilepic_' + item.postid + '"  class="posted-by-profilepic" src= ' + "data:Image/png;base64," + item.profilepic + ' /></a> \
                           <ul><li class="name"> ' + item.name + '</li> \
                           <li id="companydetails_' + item.postid + '" class="title">' + item.companydetails + '</li> \
                           </ul><span class="time">' + item.postedtime + '</span>\
                            <div class= "dropdown post-actions" > \
                            <span class="fa fa-ellipsis-h" data-toggle="dropdown"></span> \
                            <div class="dropdown-menu post-action-option dropdown-menu-right"><ul> \
                            <li id="deletepost_' + item.postid + '" class="remove-post option-li" data-postid=' + item.postid + ' >Remove this stream</li> \
                            <li id="editpost_' + item.postid + '" class="Edit-post option-li" data-postid=' + item.postid + ' >Edit and update</li> \
                            <li id="reportpost_' + item.postid + '" class="report-post option-li" data-postid=' + item.postid + ' >Report this stream </li> \
                            <li id="hidepost_' + item.postid + '" class="hide-post option-li" data-postid=' + item.postid + ' > Hide this stream </li></ul>\
                            </div></div> \
                            </div> \
                            <div class="post-main-padding">\
                            <div class= "post-panel-body" > \
                               <p id="postdescription_' + item.postid + '" data-postid=' + item.postid + ' class="post-text-large" ></p> \
                                <img id="postimage_' + item.postid + '" data-postid=' + item.postid + ' class="load-post-overlay-data" src=' + "data:Image/png;base64," + item.postimage + ' /> \
                               </div>\
                          </div>\
                            <div class="post-data-counts">\
                            <div class="post-data-count-left">\
                            <div class="data-margin load-likes" data-postid='+ item.postid + '><span id="likecounts_' + item.postid + '" class="font-600">' + item.likescounts + '</span> Likes</div>\
                            <div class="data-margin" data-postid='+ item.postid + '><span class="load-post-overlay-data" data-postid=' + item.postid + ' id="commentcounts_' + item.postid + '" class="font-600">' + item.commentcounts + '</span>  Comments</div>\
                            </div>\
                             <div class= "post-action-other-actions" >\
                                 <span id = "postliked_' + item.postid + '" role = "button" data-postid=' + item.postid + ' data-likeusername= \"' + item.username + '\" class="fa like-post" ></span>\
                                 <span class="fa fa-comment-o show-comment-box hide-on-mobile" data-postid='+ item.postid + '></span>\
                                 <span class="fa fa-share-square-o"></span>\
                                 <span class="fa fa-bookmark-o"></span>\
                            </div></div>\
                            <div id="loadingcomments_'+ item.postid + '" class="load-comment-data-newsfeed"></div> \
                            <div id="show_comment_section_' + item.postid + '" class="comment-input-div"> \
                            <img id="image1_' + item.postid + '" src="' + imgfile + '" class="profile-picture-render" /> \
                            <div ID="commentbox_' + item.postid + '" data-id=' + item.postid + ' class="comment-input post-comment-textbox" contenteditable="true" ></div> \
                            <span id="enable_comment_btn_' + item.postid + '" role="button" data-postid=' + item.postid + ' data-username= \"' + item.username + '\" class="disable-btn post-comment-btn comment-btn fa fa-filter" ></span>\
                            <div class="post-data-like-btn"> \
                            </div> \
                            </div>\
                            <div id="load_comment_user" class="load-comment-users" >\
                            <div class="loading-comment-overlay">\
                            </div></div>\
                            </div></div></div>').appendTo($("#loadposts"));

                        // checking if the user has already liked the post
                        // has liked the post
                        if (item.likeunlike == true) {
                            $('#postliked_' + item.postid).removeClass("fa-heart-o");
                            $('#postliked_' + item.postid).addClass("fa-heart");
                            $('#postliked_' + item.postid).attr("title", "Dislike");
                        }
                        // has not liked the post
                        else {
                            $('#postliked_' + item.postid).removeClass("fa-heart");
                            $('#postliked_' + item.postid).addClass("fa-heart-o");
                            $('#postliked_' + item.postid).attr("title", "Like");
                        }

                        // checking whetehr the post is posed by the same session user or not
                        // hifing the post options according to that

                        // if the post user and the session user are the same
                        if (item.username == username) {
                            $('#reportpost_' + item.postid).css("display", "none");
                            $('#hidepost_' + item.postid).css("display", "none");

                            if (item.usertype == "user") {
                                $('#redirect_' + item.postid).prop("href", "profile.aspx");
                            }
                            else {
                                $('#redirect_' + item.postid).prop("href", "Company-page.aspx");
                            }
                        }
                        else {
                            $('#deletepost_' + item.postid).css("display", "none");
                            $('#editpost_' + item.postid).css("display", "none");

                            if (item.usertype == "user") {
                                $('#redirect_' + item.postid).prop("href", "profile_guest.aspx?username=" + item.username);
                            }
                            else {
                                //  $('#nodetails_' + item.postid).css("display", "none")
                                $('#redirect_' + item.postid).prop("href", "companies.aspx?username=" + item.username);
                                //  $('#profilepic_' + item.postid).css("border-radius", "0%");
                            }
                        }

                        // if the posted user has no profile picture
                        if (item.profilepic == null || item.profilepic == '') {
                            $('#profilepic_' + item.postid).attr("src", "images/user.jpg");
                        }

                        if (imgfile == null || imgfile == '') {
                            $('#image1_' + item.postid).attr("src", "images/user.jpg");
                        }

                        // if the company details is null
                        if (item.companydetails == "" || item.companydetails == null) {
                            $('#companydetails_' + item.postid).css("display", "none");
                        }

                        let dataposts = decodeURI(item.postdescription);
                        // if postcontent is greather than 350 than show a show more button else hide it
                       
                        if (item.postdescription == "" || item.postdescription == null) {
                            $('#showmorecontent_' + item.postid).css("display", "none");
                            $('#postdescription_' + item.postid).css("display", "none");
                        }
                        else {
                            $('#postdescription_' + item.postid).html(dataposts);
                        }

                        // hiding the image box if there is no image
                        if (item.postimage == null) {
                            $('#postimage_' + item.postid).css("display", "none");
                        }
                        else {
                            $('#postimage_' + item.postid).css("display", "block");
                        }

                        loadingSpecificComments(item.postid);
                        // loading the liked users if the post has got likes
                        totallikes = parseInt(item.likescounts);
                        //if (totallikes > 0) {
                        //    loadlikeuserimage(item.postid);
                        //}
                        //else {
                        //    // 
                        //}
                    });


                }
            },
            error: function (err) {
                $("#loaders").css("display", "none");
                $(".nofeed").css("display", "block");
                $("#post_load").css("display", "none");
            }
        });

    }

}


// loading all the specufic comments for a post once something is inserted
let active_postid;
let active_username;
function loadingSpecificComments(postid) {

    // post_commmentbtn = $(this);
    active_postid = postid;
    var username = $("#username").val();
    $.ajax({
        url: '../../userpagewebservices/loadnewsfeed.asmx/loadcomments',
        method: 'post',
        data: { postid: postid },
        dataType: 'json',
        cache: false,
        beforeSend: function () {

        },
        success: function (data) {
            var count = Object.keys(data).length;
            if (data.length == 0) {
                // $('#show_comment_section_' + postid).fadeIn();
            }
            else {
                $(data).each(function (index, item) {
                    $(".no-comment-overlay").css("display", "none");
                    $(".loading-comment-overlay").css("display", "block");
                    active_username = item.username;

                    $('<div class="load-overlay-comment" >\
                        <a id="anchor_' + item.commentid + '" href="profile/profile.aspx?id=' + item.username + '">\
                        <img id="picture_'+ item.commentid + '"  src=' + "data:Image/png;base64," + item.profilepic + ' /></a>\
                            <div class="comment-user-data">\
                            <p class="comment-name">' + item.name + '</p>\
                            <p class="comment-title"> ' + item.companyname + '</p> \
                            <p class= "comment-time" > '+ item.commenttime + ' </p>\
                            <div class="comment-para">' + item.commentmessage + ' </div></div> \
                            <div class="comment-options">\
                            <div class= "dropdown" > <span class="fa fa-ellipsis-h dropdown-toggle" data-toggle="dropdown"></span> \
                            <div class= "dropdown-menu comment-overlay-option dropdown-menu-right" > \
                            <ul><li id="removecomment_' + item.commentid + '" class="remove-comment" data-commentid=' + item.commentid + ' data-postid=' + item.postid + ' > Remove this comment </li> \
                            <li id = "reportcomment_' + item.commentid + '" class= "report-comment" data-commentid=' + item.commentid + ' data-postid=' + item.postid + ' > Report comment </li ></ul></div></div ></div>').appendTo($('.loading-comment-overlay'));

                    // now arranging the control as per the results generated
                    // if the post is posted by a company or a user and the post is been posted by them only then then they can delete all the comments
                    if (item.username == username) {
                        $('#removecomment_' + item.commentid).css("display", "block");
                    }
                    else if (item.commentedby == username) {
                        $('#removecomment_' + item.commentid).css("display", "block");
                        $('#reportcomment_' + item.commentid).css("display", "none");
                    }
                    else {
                        $('#removecomment_' + item.commentid).css("display", "none");
                    }

                    if (item.commentedby == username) {
                        $('#reportcomment_' + item.commentid).css("display", "none");
                    }

                    // if the user has no profile picture
                    if (item.profilepic == null) {
                        $('#picture_' + item.commentid).attr("src", "images/user.jpg");
                    }


                });
            }
        },
        complete: function () {

        },
        error: function (err) {
            alert(err);
        }
    });
}


// loading images of few users who has liked the post
function loadlikeuserimage(id) {
    $.ajax({
        url: '../userpagewebservices/loadnewsfeed.asmx/loadlikeuserimage',
        method: 'post',
        data: { postid: id },
        dataType: 'json',
        cache: false,
        beforeSend: function () {

        },
        success: function (data) {
            if (data.length == 0) {
                //
            }
            else {
                $(data).each(function (index, item) {
                    if (item.profilepic != null) {
                        $('<img id="like_username_' + item.username + '" class="load-likes" data-postid = ' + id + ' src= ' + "data:Image/png;base64," + item.profilepic + ' / >').appendTo($('#load_like_image_' + id));
                    }
                    else {
                        $('<img id="like_username_' + item.username + '" class="load-likes" data-postid = ' + id + ' src= "images/grey.png" / >').appendTo($('#load_like_image_' + id));
                    }

                });
            }
        },
        error: function (err) {
            alert(err);
        }
    });

}
