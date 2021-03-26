// loding the posts on the scroll down page effect of the browser - on demand page load
$(document).ready(function () {

    var currentPage = 1;
    loadPageData(currentPage);
    $(window).scroll(function () {
        if ($(window).scrollTop() + $(window).height() > $(document).height() - 10) {
            currentPage += 1;
            loadPageData(currentPage);
        }
    });

    $(document).on("click", ".load-new-posts", function () {
        $("#loadposts").html('');
        currentPage = 1;
        loadPageData(currentPage);
        $(this).fadeOut();
    });

   

    imgfile = $("#profilepic").attr("src");
    function loadPageData(currentPageNumber) {
        var username = $("#username").val();
        var usertype = $("#usertype").val();
        var companyusername = $("#companyusername").val();
        $.ajax({
            url: '../../userpagewebservices/loadnewsfeed.asmx/loadnewsfeeddata',
            method: 'post',
            dataType: "json",
            data: { pageNumber: currentPageNumber, pageSize:8, datausername: username, companyusername: companyusername },
            beforeSend: function () {
                $('#postloader').fadeIn();
            },
            success: function (data) {
                if (data.length == 0) {
                    $('#postloader').fadeOut();
                    //$('#nofeed').css("display", "block");
                }
                else {
                    $('#nofeed').css("display", "none");
                    $(data).each(function (index, item) {
                        $('#postloader').fadeOut();
                        // redering post
                        $('<div id="loading-post_' + item.postid + '"  class="post-panel" > \
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
                            <div data-id="'+ item.postid +'" class="post-main-padding redirect-post">\
                            <div class= "post-panel-body" > \
                               <p id="postdescription_' + item.postid + '" data-postid=' + item.postid + ' class="text" ></p> \
                                <a id="showmorecontent_' + item.postid + '" data-postid=' + item.postid + ' class="show-full-post" >..Read more</a> \
                                <img id="postimage_' + item.postid +'" data-postid=' + item.postid + ' class="load-post-overlay-data" src=' + "data:Image/png;base64," + item.postimage + ' /> \
                               </div>\
                            </div>\
                            <div class="post-data-counts">\
                            <div class="post-data-count-left">\
                            <div class="data-margin load-likes" data-postid='+ item.postid +'><span id="likecounts_' + item.postid + '" class="font-600">' + item.likescounts + '</span> Likes</div>\
                            <div class="data-margin load-overlay-comments" data-postid='+ item.postid + '><span class="load-post-overlay-data" data-postid=' + item.postid + ' id="commentcounts_' + item.postid + '" class="font-600">' + item.commentcounts + '</span>  Comments</div>\
                            </div>\
                             <div class= "post-action-other-actions" >\
                                 <span id = "postliked_' + item.postid + '" role = "button" data-postid=' + item.postid + ' data-likeusername= \"' + item.username + '\" class="fa like-post" ></span>\
                                 <span class="fa fa-comment-o show-comment-box hide-on-mobile" data-postid='+ item.postid +'></span>\
                                 <span class="fa fa-share-square-o"></span>\
                                 <span class="fa fa-bookmark-o"></span>\
                            </div></div>\
                            </div> </div></div></a>').appendTo($("#loadposts"));



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
                        if (dataposts.length > 200) {
                            datapost = decodeURI(item.postdescription);
                            $('#postdescription_' + item.postid).html(datapost);

                            var onlytext = document.getElementById('postdescription_' + item.postid).innerText;
                            onlytext = onlytext.replace(/(?:\r\n|\r|\n)/g, '<br>');

                            subtext = onlytext.substring(0, 199) + "....";
                            $('#postdescription_' + item.postid).html(subtext);
                            $('#showmorecontent_' + item.postid).css("display", "none");
                        }

                        else if (item.postdescription == "" || item.postdescription == null) {
                            $('#showmorecontent_' + item.postid).css("display", "none");
                            $('#postdescription_' + item.postid).css("display", "none");
                        }
                        else {
                            $('#postdescription_' + item.postid).html(dataposts);
                            $('#showmorecontent_' + item.postid).css("display", "none");
                        }

                        // hiding the image box if there is no image
                        if (item.postimage == null) {
                            $('#postimage_' + item.postid).css("display", "none");
                        }
                        else {
                            $('#postimage_' + item.postid).css("display", "block");
                        }

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
            //error: function (jqXHR, textStatus, errorThrown) {
            //    if (jqXHR.status == 500) {
            //        alert('Internal error: ' + jqXHR.responseText);
            //    } else {
            //        alert('Unexpected error.');
            //    }
            //}
            error: function (err) {
                $('#postloader').fadeOut();
               // $('#nofeed').css("display", "block");
            }
        });

    }

    // loading images of few users who has liked the post
    function loadlikeuserimage(id) {
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
                            $('<img id="like_username_' + item.username + '"  data-postid = ' + id + ' src= ' + "data:Image/png;base64," + item.profilepic + ' />').appendTo($('#load_like_image_' + id));
                        }
                        else {
                            $('<img id="like_username_' + item.username + '"  data-postid = '+ id + ' src= "images/user.jpg" />').appendTo($('#load_like_image_' + id));
                        }

                    });
                }
            },
            error: function (err) {
                $('#load_like_image_' + id).fadeOut();
            }
        });

    }


    $(document).on("click", ".show-comment-box", function () {
        let postid = $(this).data("postid");
        $("#show_comment_section_" + postid).css("display", "flex");
        $("#commentbox_" + postid).focus();
    });

    $(document).on("click", ".redirect-post", function () {
        let postid = $(this).data("id");
        location.href = "streams.aspx?id=" + postid;
    });
    

});
