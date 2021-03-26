$(document).ready(function () {

    $(document).on("click", ".chat-box-header", function () {
        $(this).parent("div").find('div.chat-main-body').slideToggle();
    });

    $(document).on("click", ".close-chat-box", function () {
        username = $(this).data("username");
        $('div[id = "chat_box_' + username + '"]').remove();
    });

    // sending private message to the user
    $(document).on("click", ".send-private-message", function () {
        let profileusername = $(this).data("username");
        let name = $(this).data("name");
        imgsrc = $('img[id = "profile_image_' + profileusername + '"').attr("src");

        var IsDivExist = $('div[id = "chat_box_' + profileusername + '"]').html();

        if (IsDivExist == undefined) {
            $('<div id="chat_box_' + profileusername + '" class="chat-box-panel"><div class="chat-box-panel"><div class="chat-box-header"><img src = ' + imgsrc + ' /><h3>' + name + '</h3><span data-username = ' + profileusername + ' class="fa fa-close close-chat-box"></span></div>  <div class="chat-main-body">  <div id="chat_load_message_' + profileusername + '" class="chat-box-body"><div id="chat_message_loader_' + profileusername + '" class="loader" ></div>  </div> <div class="chat-box-input-div"><textarea id="chat_message_textbox_' + profileusername + '" data-username = ' + profileusername + ' placeholder="Start typing your message" class="chat-box-input-text"  ></textarea></div>  <div class="chat-box-footer"> <span id="sending_chat_message_btn_' + profileusername + '" class="disable-btn send-chat-message-btn" data-sendmessageusername = ' + profileusername + ' >Send</span> </div></div>   </div></div>   ').appendTo($("#chat_box_load"));;
        }
        else {
            //
        }

        loadallmessages(profileusername);

    });


    let requeststringuser = $("#requeststringuser").val();
    $(document).on("click", "#show_message_btn", function () {
        let name = $('#profilename').html();
        imgsrc = $('#postimagecontent').attr("src");

        var IsDivExist = $('div[id = "chat_box_' + requeststringuser + '"]').html();

        if (IsDivExist == undefined) {
            $('<div id="chat_box_' + requeststringuser + '" class="chat-box-panel"><div class="chat-box-panel"><div class="chat-box-header"><img src = ' + imgsrc + ' /><h3>' + name + '</h3><span data-username = ' + requeststringuser + ' class="fa fa-close close-chat-box"></span></div>  <div class="chat-main-body">  <div id="chat_load_message_' + requeststringuser + '" class="chat-box-body"><div id="chat_message_loader_' + requeststringuser + '" class="loader" ></div>  </div> <div class="chat-box-input-div"><textarea id="chat_message_textbox_' + requeststringuser + '" data-username = ' + requeststringuser + ' placeholder="Start typing your message" class="chat-box-input-text"  ></textarea></div>  <div class="chat-box-footer"> <span id="sending_chat_message_btn_' + requeststringuser + '" class="disable-btn send-chat-message-btn" data-sendmessageusername = ' + requeststringuser + ' >Send</span> </div></div>   </div></div>   ').appendTo($("#chat_box_load"));;
        }
        else {
            //
        }
        loadallmessages(requeststringuser);
    });

    function loadallmessages(chatusername) {
        sessionusername = $("#usernameuser").val();
        // loading the message chat for specific user
        $.ajax({
            url: '../userpagewebservices/messages.asmx/getchat',
            method: 'post',
            dataType: "json",
            data: { usernamedata: chatusername },
            delay: '10',
            beforeSend: function () {
                $('div[id = "chat_message_loader_' + chatusername + '"]').css("display", "block");;
            },
            success: function (data) {
                $('div[id = "chat_message_loader_' + chatusername + '"]').css("display", "block");;
                if (data.length == 0) {
                    //
                }
                else {
                    $('div[id = "chat_load_message_' + chatusername + '"]').html('');
                    $(data).each(function (index, item) {
                        // $('#message_loader').css("display", "none");
                        // not the session user
                        if (item.messageby == chatusername) {
                            $('<div class="non-session-user-chat-div" ><div class="non-session-message">' + item.chat + '</div></br><span class="message-time">' + item.messagetime + '</span></div>').appendTo($('div[id = "chat_load_message_' + chatusername + '"]'));
                        }
                        // the session user
                        else {

                            $('<div class="session-user-chat-div" ><div class="session-message">' + item.chat + '</div></br><div class="message-time-div"><span id="message_read_' + item.id + '" class="fa fa-check" > </span> <span class="message-time">' + item.messagetime + '</span></div></div>').appendTo($('div[id = "chat_load_message_' + chatusername + '"]'));

                            if (item.messagestatus == "0") {
                                $('#message_read_' + item.id).css("color", "lightgrey");
                            }
                            else {
                                $('#message_read_' + item.id).css("color", "darkcyan");
                            }

                        }

                        var $target = $('div[id = "chat_load_message_' + chatusername + '"]');
                        $target.scrollTop(99999999999);

                    });
                }

            },
            error: function (err) {
                //
            }
        });

    }



    $(document).on("keyup paste", ".chat-box-input-text", function () {
        var messagetext = $(this).val().trim();
        let username = $(this).data("username");

        if (messagetext == "" || messagetext.length < 1) {
            $('span[id = "sending_chat_message_btn_' + username + '"]').addClass("disable-btn");
        }
        else {
            $('span[id = "sending_chat_message_btn_' + username + '"]').removeClass("disable-btn");
        }
    });


    $(document).on("click", ".send-chat-message-btn", function () {

        SendMessageToUsername = $(this).data("sendmessageusername");
        // chat_message_textbox_
        var messagetext = $('textarea[id = "chat_message_textbox_' + SendMessageToUsername + '"]').val().replace(/\n/g, "<br>");


        if (messagetext == "" || messagetext.length < 1) {
            $(this).addClass("disable-btn");
        }
        else {
            $.ajax({
                contentType: "application/json; charset=utf-8",
                method: 'post',
                url: '../userpagewebservices/messages.asmx/sendmessage',
                data: JSON.stringify({ textmessage: messagetext, sendto: SendMessageToUsername }),
                success: function () {
                    $('textarea[id = "chat_message_textbox_' + SendMessageToUsername + '"]').val("");
                    loadingnewmessage(messagetext, SendMessageToUsername);
                },
                error: function (err) {
                    alert(err);
                }

            });
        }

    });


    function loadingnewmessage(messagetext, chatusername) {
        sessionusername = $("#usernameuser").val();

        // loading the message chat for specific user
        $.ajax({
            url: '../userpagewebservices/messages.asmx/getnewmessages',
            method: 'post',
            dataType: "json",
            data: { usernamedata: chatusername },
            beforeSend: function () {
                //  $('#message_loader').css("display", "block");
            },
            success: function (data) {

                if (data.length == 0) {
                    $('<div class="session-user-chat-div" ><div class="session-message">' + messagetext + '</div></br><div class="message-time-div"><span id="message_read_" class="fa fa-check" > </span> <span class="message-time">Just now</span></div></div>').appendTo($('div[id = "chat_load_message_' + chatusername + '"]'));

                    var $target = $('div[id = "chat_load_message_' + chatusername + '"]');
                    $target.scrollTop(99999999999);
                }
                else {
                    $(data).each(function (index, item) {
                        // not the session user

                        if (item.messageby == chatusername) {
                            $('<div class="non-session-user-chat-div" ><div class="non-session-message">' + item.chat + '</div></br><span class="message-time">' + item.messagetime + '</span></div>').appendTo($('div[id = "chat_load_message_' + chatusername + '"]'));
                        }
                        // the session user
                        else {

                            //

                        }

                        $('<div class="session-user-chat-div" ><div class="session-message">' + messagetext + '</div></br><div class="message-time-div"><span id="message_read_" class="fa fa-check" > </span> <span class="message-time">Just now</span></div></div>').appendTo($('div[id = "chat_load_message_' + chatusername + '"]'));


                        var $target = $('div[id = "chat_load_message_' + chatusername + '"]');
                        $target.scrollTop(99999999999);

                    });
                }

            },
            error: function (err) {
                alert(err);
            }
        });

    }




});