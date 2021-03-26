$(document).ready(function () {

    //  setInterval(loadchatlist , 15000);
    loadchatlist();
    function loadchatlist() {
        $("#load_chatlist").html('');
        $.ajax({
            url: '../userpagewebservices/messages.asmx/getchatlist',
            method: 'post',
            dataType: "json",
            dalay: '10',
            beforeSend: function () {
                $("#loader_chatlist").css("display", "none");
            },
            success: function (data) {
                if (data.length == 0) {
                    $(".no-chats").css("display", "block");
                    $(".hide_conversation").css("display", "none");
                    $(".no-messages").css("display", "block");
                }
                else {
                    $("#loader_chatlist").css("display", "none");
                    $(".no-chat").css("display", "none");
                    $(".hide_conversation").css("display", "block");
                    $(".no-messages").css("display", "none");
                    $(data).each(function (index, item) {
                        $('<li data-chatusername = "' + item.username + '"  class="load-chats">  <img id="image_' + item.username + '" src= ' + "data:Image/png;base64," + item.profilepic + ' />   <div class="chat-data"><h3 id="messagename_' + item.username + '" class="chat-name-user">' + item.name + '</h3><h4 class="short-message-user" >' + item.chat + '</h4> </div>   <span class="chatlist-time" >' + item.messagetime + '</span> <span id="count_' + item.username + '"   class="message-count" >' + item.count + '</span></li>').appendTo($("#load_chatlist"));

                        if (item.profilepic == null) {
                            $('#image_' + item.username).attr("src", "images/user.jpg");
                        }

                        if (item.count == "0") {
                            //  $('#count_' + item.username).css("display", "none");
                            $('span[id = "count_' + item.username + '"]').css("display", "none");
                        }


                    });

                    triggerfirstchat();
                }
            },
            error: function (err) {
                $("#loader_chatlist").css("display", "none");
                $(".no-chats").css("display", "block");
            }
        });
    }



    function triggerfirstchat() {
        $('#load_chatlist li:first-child').trigger('click');
    }


    let SendMessageToUsername;
    $(document).on("click", ".load-chats", function () {
        chatusername = $(this).data("chatusername");
        SendMessageToUsername = chatusername;
        sessionusername = $("#usernameuser").val();
        $('#load_chatlist li').removeClass("active-chat");
        $(this).addClass("active-chat");


        let imgsrc = $('img[id = "image_' + chatusername + '"]').attr("src");
        let name = $('h3[id = "messagename_' + chatusername + '"]').html();

        $("#messageuserredirect").attr("href", "profile_guest.aspx?username=" + chatusername);

        $("#load_chat_data").html('');
        // loading the message chat for specific user
        $.ajax({
            url: '../userpagewebservices/messages.asmx/getchat',
            method: 'post',
            dataType: "json",
            data: { usernamedata: chatusername },
            beforeSend: function () {
                $('#message_loader').css("display", "block");
            },
            success: function (data) {
                $("#message_userimage").attr("src", imgsrc);
                $("#message_user_name").html(name);

                if (data.length == 0) {
                    $('#message_loader').css("display", "none");
                }
                else {
                    $(data).each(function (index, item) {
                        $('#message_loader').css("display", "none");
                        // not the session user
                        $("#message_user_title").html(item.profiletitle);
                        $('span[id = "count_' + chatusername + '"]').css("display", "none");
                        if (item.messageby == chatusername) {
                            $('<div class="non-session-user-chat-theme" ><div class="loading-non-session-user-message">' + item.chat + '</div></br><span class="message-time-chats">' + item.messagetime + '</span></div>').appendTo($("#load_chat_data"));
                        }
                        // the session user
                        else {
                            $('<div class="session-user-chat-theme" ><div class="loading-session-user-message">' + item.chat + '</div></br><div class="message-check"><span id="message_read_' + item.id + '" class="fa fa-check" > </span> <span class="message-time-chats">' + item.messagetime + '</span></div></div>').appendTo($("#load_chat_data"));

                            if (item.messagestatus == "0") {
                                $('#message_read_' + item.id).css("color", "lightgrey");
                            }
                            else {
                                $('#message_read_' + item.id).css("color", "darkcyan");
                            }

                        }

                        // $("#load_chat_data").animate({ scrollTop: $("#load_chat_data").scrollTop() }, 1000);

                        var $target = $('#load_chat_data');
                        $target.scrollTop(99999999999);
                        //  $target.animate({ scrollTop: $target.prop("scrollHeight") } , 'fast' );
                    });
                }

            },
            error: function (err) {
                alert(err);
            }
        });


    });

    $('#sendmessagetext').on("keyup focus paste", function () {
        var messagetext = $('#sendmessagetext').val().trim();

        if (messagetext == "" || messagetext.length < 1) {
            $("#send_message_btn").addClass("disable-btn");
        }
        else {
            $("#send_message_btn").removeClass("disable-btn");
        }
    });


    // sending the message to the user
    $(document).on("click", "#send_message_btn", function () {

        var messagetext = $('#sendmessagetext').val().replace(/\n/g, "<br>");

        if (messagetext == "" || messagetext.length < 1) {
            $("#send_message_btn").addClass("disable-btn");
            $('#sendmessagetext').focus();
        }
        else {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/messages.asmx/sendmessage',
                data: JSON.stringify({ textmessage: messagetext, sendto: SendMessageToUsername }),
                success: function () {
                    $('#sendmessagetext').val("");
                    loadnewmessage(messagetext);

                },
                error: function (err) {
                    alert(err);
                }

            });
        }
    });


    function loadnewmessage(messagetext) {
        sessionusername = $("#usernameuser").val();

        // loading the message chat for specific user
        $.ajax({
            url: '../userpagewebservices/messages.asmx/getnewmessages',
            method: 'post',
            dataType: "json",
            data: { usernamedata: SendMessageToUsername },
            beforeSend: function () {
                //  $('#message_loader').css("display", "block");
            },
            success: function (data) {
                if (data.length == 0) {
                    $('<div class="session-user-chat-theme" ><div class="loading-session-user-message">' + messagetext + '</div></br><div class="message-check"><span class="fa fa-check" > </span> <span class="message-time-chats">Just now</span></div></div>').appendTo($("#load_chat_data"));

                    $("#load_chat_data").animate({ scrollTop: $('#load_chat_data').height() + 1000 }, 0);

                }
                else {
                    $(data).each(function (index, item) {

                        // not the session user

                        if (item.messageby == SendMessageToUsername) {
                            $('<div class="non-session-user-chat-theme" ><div class="loading-non-session-user-message">' + item.chat + '</div></br><span class="message-time-chats">' + item.messagetime + '</span></div>').appendTo($("#load_chat_data"));
                        }
                        // the session user
                        else {

                            //

                        }

                        $('<div class="session-user-chat-theme" ><div class="loading-session-user-message">' + messagetext + '</div></br><div class="message-check"><span class="fa fa-check" > </span> <span class="message-time-chats">Just now</span></div></div>').appendTo($("#load_chat_data"));

                        $("#load_chat_data").animate({ scrollTop: $('#load_chat_data').height() + 1000 }, 0);

                    });
                }

            },
            error: function (err) {
                alert(err);
            }
        });

    }

});
