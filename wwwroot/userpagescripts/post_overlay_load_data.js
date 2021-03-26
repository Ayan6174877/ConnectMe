$(document).ready(function () {

    $(document).on("click", ".close-load-overlay", function () {
        $(".post-load-overlay").fadeOut();
        $("body").css("overflow", "auto");
    });

    profilepic_dp = $("#profilepic").attr("src");
    var active_postid;
    var active_username;
    $(document).on("click", ".load-post-overlay-data", function () {
        postid = $(this).data("postid");
        active_postid = postid;
        $("body").css("overflow", "hidden");
        if (profilepic_dp == null) {
            $("#overlay_profilepic").attr("src", "images/user.jpg");
        }
        else {
            $("#overlay_profilepic").attr("src", profilepic_dp);
        }

        $(".post-load-overlay").fadeIn();
        // loading post-data

        $.ajax({
            url: '../../userpagewebservices/loadnewsfeed.asmx/loadpostdata',
            method: 'post',
            dataType: "json",
            data: { postid: postid },
            delay: '10',
            beforeSend: function () {

            },
            success: function (data) {
                if (data.length == 0) {

                }
                else {
                    $(data).each(function (index, item) {
                        // rendering the data and fill it in th the controls

                        $("#overlay_share_profile_dp").attr("src", "data:Image/png;base64," + item.profilepic);
                        $("#overlay_share_name").html(item.name);
                        $("#overlay_share_title").html(item.companydetails);
                        $("#overlay_share_time").html(item.postedtime);
                        $("#overlay_likes_count").html(item.likescounts);
                        $("#overlay_comments_count").html(item.commentcounts);
                        active_username = item.username;

                        if (item.profilepic == null) {
                            $("#overlay_share_profile_dp").attr("src", "images/user.jpg");
                        }


                        // picture of the post
                        $(".main-post-overlay-img").attr("src", "data:Image/png;base64," + item.postimage);
                        $(".overlay-image-loader").css("display", "none");
                        $(".main-post-overlay-img").css("display", "block");


                        //  $('<div id="loading-post_' + item.postid + '" class="loading-post-div"><div class="posted-time-position"><label class="postedby-time">' + item.postedtime + '  </label></div><div class="dropdown post-options-position"><span class="glyphicon glyphicon-chevron-down dropdown-toggle"  data-toggle="dropdown"></span><ul class="dropdown-menu dropdown-menu-right"><li id="deletepost_' + item.postid + '" class="remove-post option-li" data-postid=' + item.postid + ' ><ul><li><span class="fa fa-remove"></span></li><li><h3 class="option-heading"> Remove This Post </h3><h5 class="option-text">You will never see this post on your newsfeed</h5></li></ul></li><li id="editpost_' + item.postid + '" class="Edit-post option-li" data-postid=' + item.postid + ' > <ul><li><span class="fa fa-edit"></span></li><li><h3 class="option-heading"> Edit Post </h3><h5 class="option-text">Make changes to this post</h5></li></ul> </li><li id="reportpost_' + item.postid + '" class="report-post option-li" data-postid=' + item.postid + ' ><ul><li><span class="fa fa-ban"></span></li><li><h3 class="option-heading"> Report Post </h3><h5 class="option-text">Unwanted post - Report this post as spam</h5></li></ul></li><li id="hidepost_' + item.postid + '" class="hide-post option-li" data-postid=' + item.postid + ' ><ul><li><span class="fa fa-eye-slash"></span></li><li><h3 class="option-heading"> Hide Post </h3><h5 class="option-text">You will never see this post on your feed</h5></li></ul></li></li></ul></div> <div class="post-padding" > <ul class="post-user-heading"><li><a id="redirect_' + item.postid + '"><img id="profilepic_' + item.postid + '"  class="posted-by-profilepic" src= ' + "data:Image/png;base64," + item.profilepic + ' /></a></li><li><ul class="user-details"><li><label class="postedby-name"> ' + item.name + ' </label></li><li>  <label id="companydetails_' + item.postid + '" class="postedby-title" > ' + item.companydetails + ' </label> </li></ul></li></ul>      <div class="post-content-body"><p class="post-content-para"> <label id="postdescription_' + item.postid + '" > </label><a id="showmorecontent_' + item.postid + '" data-postid = ' + item.postid + ' class="show-full-post" >..Read more</a> </p> <img id="postimage_' + item.postid + '" class="post-shared-image"  src=' + "data:Image/png;base64," + item.postimage + ' /></div>         <ul class="post-user-data"><li><span id="postliked_' + item.postid + '" role ="button"  data-postid =' + item.postid + ' data-likeusername = \"' + item.username + '\" class="fa like-post"  ></span><span id="post_like_count_' + item.postid + '">' + item.likescounts + '</span></li><li data-postid = ' + item.postid + ' class="load-comments"><span class="fa fa-comments-o"></span><span id = "post_commentcount_' + item.postid + '">' + item.commentcounts + '  </span></li> <li class="load-likes"><div id="load_like_image_' + item.postid + '" class="load-like-image" ></div></li><li id="load_posts_data_text_' + item.postid + '" class="load-data-text">' + item.customtextdata + ' </li></ul> </div> <div id="show_comment_section_' + item.postid + '" class="comment-section"> <div class="comment-posting"><img id="image1_' + item.postid + '"  class="post-comment-profilepic"  src="' + imgfile + '" /> <div ID="commentbox_' + item.postid + '" data-id = ' + item.postid + ' class="post-comment-textbox" contenteditable="true" data-placeholder="write a comment"></div></div> <br> <span id="enable_comment_btn_' + item.postid + '" role="button" data-postid = ' + item.postid + ' data-username = \"' + item.username + '\" class="comment-btn not-active post-comment-btn">Comment</span>   <div id="loadingcomments_' + item.postid + '" ></div>   </div></div>').appendTo($("#loadposts"));

                        // checking if the user has already liked the post
                        // has liked the post
                        if (item.likeunlike == true) {
                            $(".trigger-overlay-like").removeClass("fa-heart-o");
                            $(".trigger-overlay-like").addClass("fa-heart");
                            $(".trigger-overlay-like").attr("title", "Dislike this post");
                        }
                        // has not liked the post
                        else {
                            //$('#postliked__' + item.postid).removeClass("fa-heart");
                            $(".trigger-overlay-like").removeClass("fa-heart");
                            $(".trigger-overlay-like").addClass("fa-heart-o");
                            $(".trigger-overlay-like").attr("title", "Like this post");
                        }

                        // checking whetehr the post is posed by the same session user or not
                        // hifing the post options according to that

                        // if the post user and the session user are the same
                        //if (item.username == username) {
                        //    $('#reportpost_' + item.postid).css("display", "none");
                        //    $('#hidepost_' + item.postid).css("display", "none");

                        //    if (item.usertype == "user") {
                        //        $('#redirect_' + item.postid).prop("href", "profile.aspx");
                        //    }
                        //    else {
                        //        $('#redirect_' + item.postid).prop("href", "Company-page.aspx");
                        //    }
                        //}
                        //else {
                        //    $('#deletepost_' + item.postid).css("display", "none");
                        //    $('#editpost_' + item.postid).css("display", "none");

                        //    if (item.usertype == "user") {
                        //        $('#redirect_' + item.postid).prop("href", "profile_guest.aspx?username=" + item.username);
                        //    }
                        //    else {
                        //        //  $('#nodetails_' + item.postid).css("display", "none")
                        //        $('#redirect_' + item.postid).prop("href", "companies.aspx?username=" + item.username);
                        //        //  $('#profilepic_' + item.postid).css("border-radius", "0%");
                        //    }
                        //}


                        // if the posted user has no profile picture
                        if (item.profilepic == null) {
                            $('#profilepic_' + item.postid).attr("src", "images/user.png");
                        }

                        // if the company details is null
                        if (item.companydetails == "" || item.companydetails == null) {
                            $('#companydetails_' + item.postid).css("display", "none");
                        }

                        let dataposts = decodeURI(item.postdescription);
                        // if postcontent is greather than 350 than show a show more button else hide it
                        if (item.postdescription == "" || item.postdescription == null || item.postdescription == undefined) {
                            $(".overlay-post-description").css("display", "none");
                        }
                        else {
                            $("#load_overlay_post").html(dataposts);
                        }

                        // loading the liked users if the post has got likes
                        totallikes = parseInt(item.likescounts);
                        if (totallikes > 0) {
                            loadlikeuserimageoverlay(item.postid);
                        }
                        else {
                            // 
                        }

                        // loading the comments
                        totalcomments = parseInt(item.commentcounts);
                        if (totalcomments > 0) {
                            $(".no-comment-overlay").css("display", "none");
                            loadallcomments(active_postid);
                        }
                        else {
                            $(".no-comment-overlay").css("display", "block");
                            $(".loading-comment-overlay").css("display", "none");
                        }

                    });
                }
            },
            error: function (err) {
                //$("#loaders").css("display", "none");
                //$(".nofeed").css("display", "block");
                //$("#post_load").css("display", "none");
            }
        });

        return false;
    });


    // loading images of few users who has liked the post
    function loadlikeuserimageoverlay(id) {
        $('.overlay-post-like-users-dp').html('');
        $.ajax({
            url: '../../userpagewebservices/loadnewsfeed.asmx/loadlikeuserimage',
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
                            $('<img id="like_username_' + item.username + '"  data-postid = ' + id + ' src= ' + "data:Image/png;base64," + item.profilepic + ' / >').appendTo($('.overlay-post-like-users-dp'));
                        }
                        else {
                            $('<img id="like_username_' + item.username + '"  data-postid = ' + id + ' src= "images/user.jpg" / >').appendTo($('.overlay-post-like-users-dp'));
                        }

                    });
                }
            },
            error: function (err) {
                $('.overlay-post-like-users-dp').fadeOut();
            }
        });

    }


    // liking and disliking the post
    $(document).on("click", ".trigger-overlay-like", function () {
        imgfile = $('#profilepic').attr('src');
        //  let username = $(this).data("likeusername");
        likebtn = $(this);
        // if user has already liked the post
        if ($(likebtn).hasClass("fa-heart")) {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/loadnewsfeed.asmx/unlikes_Click',
                data: JSON.stringify({ likepostid: active_postid }),
                success: function (data) {
                    // updating the like count in overlay
                    var overlay_like_count = parseInt($("#overlay_likes_count").html());
                    overlay_like_count = overlay_like_count - 1;
                    $("#overlay_likes_count").html(overlay_like_count);

                    $(likebtn).removeClass("fa-heart");
                    $(likebtn).addClass("fa-heart-o");
                    $(likebtn).attr("title", "Like this post");


                    // has not liked the post
                    $('#likecounts_' + active_postid).html(overlay_like_count);
                    $('#postliked_' + active_postid).removeClass("fa-heart");
                    $('#postliked_' + active_postid).addClass("fa-heart-o");
                    $('#postliked_' + active_postid).attr("title", "Like this post");


                },
                error: function (err) {
                    //
                }

            });
        }

        else {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/loadnewsfeed.asmx/likes_Click',
                data: JSON.stringify({ likepostid: active_postid, username: active_username }),
                success: function (data) {

                    $(likebtn).removeClass("fa-heart-o");
                    $(likebtn).addClass("fa-heart");
                    $(likebtn).attr("title", "disLike this post");

                    $('#postliked_' + active_postid).removeClass("fa-heart-o");
                    $('#postliked_' + active_postid).addClass("fa-heart");
                    $('#postliked_' + active_postid).attr("title", "disLike this post");

                    // updating the like count
                    var overlay_like_count = parseInt($("#overlay_likes_count").html());
                    overlay_like_count = overlay_like_count + 1;
                    $("#overlay_likes_count").html(overlay_like_count);
                    $('#likecounts_' + active_postid).html(overlay_like_count);
                    // updating in the feed

                },
                error: function (err) {
                    //
                }
            });
        }
    });

   
  
});