// all the different actions ahpppening inside a post
// like like a post, cooment, delet comment, delete post, report amd others
$(document).ready(function () {

    $(document).on("click", ".show-full-post", function () {
            var username = $("#username").val();
            postid = $(this).data("postid");
            postmorebtn = $(this);
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/loadnewsfeed.asmx/showcompletepost',
                data: JSON.stringify({ postid: postid }),
                success: function (data) {
                    $(postmorebtn).css("display", "none");
                    datapost = decodeURI(data.d);
                    $('#postdescription_' + postid).html(datapost);
                },
                error: function (err) {
                    //
                }
            });
        });


    // liking and disliking the post
    $(document).on("click", ".like-post", function () {
        imgfile = $('#profilepic').attr('src');
        postid = $(this).data("postid");
        let username = $(this).data("likeusername");
        likebtn = $(this);
        // if user has already liked the post
        if ($(likebtn).hasClass("fa-heart")) {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/loadnewsfeed.asmx/unlikes_Click',
                data: JSON.stringify({ likepostid: postid }),
                success: function (data) {
                    totallikescounts = parseInt($('#likecounts_' + postid).html());
                    totallikescounts = totallikescounts - 1
                    $('#likecounts_' + postid).html(totallikescounts);

                  
                    $(likebtn).removeClass("fa-heart");
                    $(likebtn).addClass("fa-heart-o");
                    $(likebtn).attr("title", "Like this post");
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
                data: JSON.stringify({ likepostid: postid, username: username }),
                success: function (data) {
                    $(likebtn).removeClass("fa-heart-o");
                    $(likebtn).addClass("fa-heart");
                    $(likebtn).attr("title", "disLike this post");

                    totallikescounts = parseInt($('#likecounts_' + postid).html());
                    totallikescounts = totallikescounts + 1
                    $('#likecounts_' + postid).html(totallikescounts);
                },
                error: function (err) {
                    //
                }
            });
        }
    });

    $(document).on("click", ".fa-close-reaction-modal", function () {
        $(this).closest(".post-modal-data").css("display", "none");
        $('body,html').css("overflow", "auto");

    });

    // loading the likes
    $(document).on("click", ".load-likes", function () {
        $('#load_like_user').empty();
        let postid = $(this).data("postid");
        $("#loading_reactions_modal").css({ "visibility": "visible", "display": "flex" });
        $('body,html').css("overflow", "hidden");
        $.post({
            url: '../../userpagewebservices/loadnewsfeed.asmx/Getlikeuser',
            method: 'post',
            dataType: "json",
            data: { postid: postid },
            beforeSend: function () {
                $("#likeloader").css("display", "block");
            },
            success: function (data) {
                var count = Object.keys(data).length;
                $("#total_post_reactions").html(count + " People reacted")
                $("#likeloader").css("display", "none");
                if (count == 0) {
                    $(".no-likes").css("display", "block");
                }
                else {
                    $(data).each(function (index, item) {
                        if (item.usertype == 'company') {
                            if (item.coverpic != null) {
                                $('<li><div class="user-short-profile"><a href="companies.aspx?username=' + item.username + '"><div class="user-short-profile-company-header"><img class="user-cover-pic" src = data:Image/png;base64,' + item.coverpic + ' ></div></a><div class="user-profile-main-company-body"><img class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ><h3>' + item.name + ' </h3><h4>' + item.tagline + ' </h4><ul class="company-more-info"><li>' + item.industry + '<li><li>' + item.totalcount + '</li></ul></div></div></li>').appendTo($('#load_like_user'));
                            }
                            else {
                                $('<li><div class="user-short-profile"><a href="companies.aspx?username=' + item.username + '"><div class="user-short-profile-company-header"><img class="user-cover-pic" src ="images/grey.png"  ></div></a><div class="user-profile-main-company-body"><img class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ><h3>' + item.name + ' </h3><h4>' + item.tagline + ' </h4><ul class="company-more-info"><li>' + item.industry + '<li><li>' + item.totalcount + '</li></ul></div></div></li>').appendTo($('#load_like_user'));
                            }
                        }
                        else {
                            $('<div class="reaction-user-data-flex">\<a href="profile/profile.aspx?id=' + item.username + '">\
                            <img id="profilepic_' + item.username + '" class="user-profile-pic" src = data:Image/png;base64,' + item.profilepic + ' ></a>\
                            <div class="reaction-user-main-data">\
                            <p class="reaction-name">' + item.name + ' </p>\
                            <p class="reaction-title">' + item.profiletitle + ' </p>\
                            </div>').appendTo($('#load_like_user'));

                            if (item.profilepic == null || item.profilepic == '') {
                                $('#profilepic_' + item.username).attr("src", "images/user.jpg");
                            }

                        }
                    });
                }
            },
            error: function (err) {
                //
            }
        });

    });


      $(document).on("keyup", ".post-comment-textbox", function () {
            textdata = $(this).text();
            id = $(this).data("id");
            if (textdata.length >= 1) {
                $("#enable_comment_btn_" + id).removeClass("disable-btn");
            }
            else {
                $("#enable_comment_btn_" + id).addClass("disable-btn");
            }
        });

        // posting comment in the modal box
        
    // loading all the specufic comments for a post once something is inserted
    let active_postid;
    let active_username;
    $(document).on("click", ".load-overlay-comments", function () {
        post_commmentbtn = $(this);
        let postid = $(this).data("postid");
        active_postid = postid;
        $('.loading-comment-overlay').html('');
        var username = $("#username").val();
        $("#loading_comments_modal").css({ "visibility":"visible", "display":"flex" });
        $('body,html').css("overflow", "hidden");
        $("#overlay_comment_input").focus();
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
                $("#total_comments").html(count + " comments")

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
                        <img id="picture_'+ item.commentid +'"  src='+ "data:Image/png;base64,"+ item.profilepic +' /></a>\
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
    });


    // loading the full comments ( not using right now )
    $(document).on("click", ".load-full-comment", function () {
        let commentid = $(this).data("commentid");
        commentmorebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/loadnewsfeed.asmx/showfullcomment',
            data: JSON.stringify({ commentid: commentid }),
            success: function (data) {
                $(commentmorebtn).css("display", "none");
                $('#commentmess_' + commentid).html(data.d);
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    // post a comment
    $(document).on("keyup", ".overlay-comment-input", function () {
        textdata = $(this).text();
        if (textdata.length >= 1) {
            $(".overlay-comment-btn").removeClass("disable-btn");
        }
        else {
            $(".overlay-comment-btn").addClass("disable-btn");
        }
    });


    // posting a comment form the overlay screen
    $(document).on("click", ".overlay-comment-btn", function () {
        let commentpostid = active_postid;
        let commentdata = $("#overlay_comment_input").html();
        if (commentdata == "") {
            $(".overlay-comment-input").focus();
        }
        else {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../../userpagewebservices/loadnewsfeed.asmx/Postcomment',
                data: JSON.stringify({ postid: active_postid, comment: commentdata, username: active_username }),
                beforeSend: function () {
                    //
                },
                success: function (data) {
                    $(".overlay-comment-input").html('');
                    count = $('#commentcounts_' + active_postid).html();
                    increaseoount = parseInt(count) + 1;
                    $('#commentcounts_' + active_postid).html(increaseoount);
                    $('#overlay_comments_count').html(increaseoount);
                   // loadallcomments(active_postid);
                },
                error: function (err) {
                    alert(err);
                }
            });
        }
    });


    // deleting the comments
    $(document).on("click", ".remove-comment", function () {
        let commentid = $(this).data("commentid");
        commentbtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/loadnewsfeed.asmx/deletecomments',
            data: JSON.stringify({ commentid: commentid, postid: active_postid }),
            success: function () {
                $(commentbtn).closest($('.load-overlay-comment')).fadeOut(1000);
                // decreasing the comment count
                count = $('#commentcounts_' + active_postid).html();
                increaseoount = parseInt(count) - 1;
                $('#commentcounts_' + active_postid).html(increaseoount);
                $('#overlay_comments_count').html(increaseoount);
            },
            error: function (err) {
                alert(err);
            }
        });

    });


        // posting comments in the posts directly not ionside the modal
        let commentpostid;
        $(document).on("click", ".post-comment-btn", function () {
            post_commmentbtn = $(this);
            let postid = $(this).data("postid");
            let username = $(this).data("username");
            commentpostid = postid;
            // let commentdata = $('#commentbox_' + postid).innerText();
            var commentdata = document.getElementById('commentbox_' + postid).innerText;
            commentdata = commentdata.replace(/(?:\r\n|\r|\n)/g, '<br>');

            if (commentdata == "") {
                $('#commentbox_' + postid).focus();
            }
            else {
                $.ajax({
                    contentType: "application/json; charset=utf-8",
                    method: 'post',
                    url: '../../userpagewebservices/loadnewsfeed.asmx/Postcomment',
                    data: JSON.stringify({ postid: postid, comment: commentdata, username: username }),
                    beforeSend: function () {
                        //
                    },
                    success: function (data) {
                        $('#commentbox_' + postid).html('');
                        count = $('#commentcounts_' + postid).html();
                        increaseoount = parseInt(count) + 1;
                        $('#commentcounts_' + postid).html(increaseoount);
                        loadsomecomments(postid);
                    },
                    error: function (err) {
                        // alert(err);
                    }
                });
            }
        });


        // loading all the specufic comments for a post once something is inserted
        function loadsomecomments(postid) {
            $('#loadingcomments_' + postid).html('');
            var username = $("#username").val();
            combtn = $(this);
            $.ajax({
                url: '../../userpagewebservices/loadnewsfeed.asmx/loadcommentssome',
                method: 'post',
                data: { postid: postid },
                dataType: 'json',
                cache: false,
                beforeSend: function () {

                },
                success: function (data) {
                    if (data.length == 0) {
                        $('#loadingcomments_' + postid).fadeOut();
                    }
                    else {
                        $('#loadingcomments_' + postid).fadeIn();
                        $(data).each(function (index, item) {
                            // if the comment is too large
                            if (item.commentmessage.length > 100) {
                                commentdata = $('#commentmess_' + item.commentid).html();
                                commentdata = commentdata.substring(0, 99) + "...";
                                commentdata = commentdata.replace("<br>", " ", "g");
                                $('#commentmess_' + item.commentid).html(commentdata);
                            }
                            else {
                                commentdata = $('#commentmess_' + item.commentid).html();
                                commentdata = commentdata.replace("<br>", " ", "g");
                                $('#commentmess_' + item.commentid).html(commentdata);
                            }

                        });
                    }
                },
                complete: function () {

                },
                error: function (err) {
                    //
                }
            });
        }

        
    // deleting the post for ever
    $(document).on("click", ".remove-post", function () {
        postid = $(this).data("postid");
        removebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/loadnewsfeed.asmx/deletepost',
            data: JSON.stringify({ postid: postid }),
            success: function () {
                $(removebtn).closest('.loading-post-div').fadeOut(2000);
            },
            error: function (err) {
                alert(err);
            }

        });
    });

    // hiding the post of some other user if do not likes
    $(document).on("click", ".hide-post", function () {
        postid = $(this).data("postid");
        hidebtn = $(this);
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/loadnewsfeed.asmx/hidepost',
            data: JSON.stringify({ postid: postid }),
            success: function () {
                $(hidebtn).closest('.loading-post-div').fadeOut(2000);
            },
            error: function (err) {
                alert(err);
            }
        });
    });

    // reporting a post as spam
    let reportbtn;
    $(document).on("click", ".report-post", function () {
        postid = $(this).data("postid");
        reportbtn = $(this);
        $('#reportpostid').html(postid);
        $('#reportsuccessdone').css("display", "block");
        $('#reportsuccess').css("display", "none");
        $("#reportpost").modal('show');
    });


    // reporting the post
    $(document).on("click", ".reprtingpost", function () {
        let e = $(this).attr("id");
        //Assigning the unique number in the ID to a variable  
        postid = $('#reportpostid').html();
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: '../../userpagewebservices/loadnewsfeed.asmx/reportingpost',
            data: JSON.stringify({ postid: postid, message: e }),
            success: function () {
                $('#reportsuccessdone').css("display", "none");
                $('#reportsuccess').css("display", "block");
                $('#loading-post_' + postid).fadeOut(2000);
            },
            error: function (err) {
                alert(err);
            }
        });

        return false;
    });

    
    // remove-comment
    

});