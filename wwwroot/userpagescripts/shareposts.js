// script file for sharing the post with other users

$(document).ready(function () {


    $(document).on("click", "#close_image_overlay", function () {
        $("#Image_stream_overlay").fadeOut();
        $('body, html').css("overflow", "auto");
        $('#fileupload1').val('');
        $("#postimagecontent").attr("src", "");
        $("#ImageCaptionInput").html('');
        $("#sharedImagepost").addClass("disable-btn");
    });

    $(document).on("click", ".share-post", function () {
        $("#Image_stream_overlay").fadeIn();
        $('body, html').css("overflow", "auto");
        $('#fileupload1').val('');
        $("#postimagecontent").attr("src", "");
        $("#ImageCaptionInput").html('');
   });

    $(document).on("click", ".share-text", function () {
        $("#Image_stream_overlay").fadeIn();
        $('body, html').css("overflow", "auto");
        $('#fileupload1').val('');
        $("#postimagecontent").attr("src", "");
        $("#ImageCaptionInput").html('');
        $("#PostInput").focus();

    });

    let ImageCaptionLimit = 240;
    let ImageCaptionCounter = 240;
    // fileupload control to apppend and upload image file to the upload controller and img src attribute
    $(function () {
        $("#fileupload1").change(function () {
            if (typeof (FileReader) != "undefined") {
                var regex = /^([a-zA-Z0-9\s_\\.\-\():])+(.jpg|.jpeg|.jfif|.gif|.png|.bmp)$/;
                    $($(this)[0].files).each(function () {
                    var file = $(this);
                    if (regex.test(file[0].name.toLowerCase())) {
                        var reader = new FileReader();
                        var img = document.createElement("img");
                        reader.onload = function (e) {
                            $("#sharedImagepost").removeClass("disable-btn");
                            $("#postimagecontent").attr("src", e.target.result);
                            $("#Image_stream_overlay").fadeIn(1000);
                            $('body, html').css("overflow", "hidden");
                            $(".post-share-body-image").fadeIn(1000);
                            $('body').css("overflow", "hidden");
                            $("#ImageCaptionInput").focus();
                            if (ImageCaptionCounter < 0 ) {
                                $("#sharedImagepost").addClass("disable-btn");
                            }
                            else {
                                $("#sharedImagepost").removeClass("disable-btn");
                            }
                        }
                            reader.readAsDataURL(file[0]);
                    } else {
                        alert(file[0].name + " is not a valid image file.");
                        return false;
                    }
                });
            }
        });
    });


    function placeCaretAtEnd(el) {
        el.focus();
        if (typeof window.getSelection != "undefined"
            && typeof document.createRange != "undefined") {
            var range = document.createRange();
            range.selectNodeContents(el);
            range.collapse(false);
            var sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
        } else if (typeof document.body.createTextRange != "undefined") {
            var textRange = document.body.createTextRange();
            textRange.moveToElementText(el);
            textRange.collapse(false);
            textRange.select();
        }
    }

    
    // disabling the button post if both textbox and fileupload is emptu
    $("#PostInput").on("keyup paste", function (e) {
        TextLength = $(this).text().length;
        ImageCaptionCounter = ImageCaptionLimit - TextLength;
        $("#ImageCaptionCounter").html(ImageCaptionCounter);
      
        if (TextLength == 0) {
            $("#sharedImagepost").addClass("disable-btn");
        } 
        else if (ImageCaptionCounter < 0) {
                let TextCurrentData = $(this).text();
                $("#ImageCaptionCounter").css("color", "red");
                let existing = TextCurrentData.substring(0, 240);
                let createNewElement = "<span class='warning-limit'>"+ TextCurrentData.substring(240, TextLength) +"</span>";
                $("#PostInput").html(existing + createNewElement);
                $("#sharedImagepost").addClass("disable-btn");
                placeCaretAtEnd(document.getElementById("PostInput"));
        }
        else {
            $("#ImageCaptionInput span").removeClass("warning-limit");
            $("#ImageCaptionCounter").css("color", "black");
            $("#sharedImagepost").removeClass("disable-btn");
        }

        textvalue = $(this).html();
        fileimage = $("#fileupload1").html();
        imgsrc = $("#postimagecontent").attr("src");

        // for usertags
        var userTagStart = new RegExp((/@/ig));
        var userTag = new RegExp((/@(\w+)/ig)); // @ Match

        // for hastags
        //var hashTagStart = new RegExp((/#/ig));
        //var hashTag = new RegExp((/#(\w+)/ig)); // # Match
        var hashTagStart = new RegExp(/(?:\s|^)#[A-Za-z0-9\-\.\_]+(?:\s|$)/ig);

        //  var resUrl = new RegExp(/(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g);
     
        // converting anchors, hastags and url into anchor tags
        if (e.which === 32 || e.which === 13) {
            //$("#ImageCaptionInput").linky();
            if (textvalue.match(hashTagStart)) {
                $(this).html(textvalue.replace(hashTagStart, '<a href="$1" target="_blank">'+ textvalue.match(hashTagStart) +'</a>'));
            }

            //if (textvalue.match(UserTagStart)) {
            //    $(this).html(textvalue.replace(hashTag, "hello"));
            //}
        }

        // autocomplete div area to tag people
        // load hastags
        if (textvalue.match(hashTagStart)) {
            let tags = textvalue.match(hashTagStart);
            let tagString = tags[0];
        }
        else if (textvalue.match(userTagStart)) {
            // load user load tags
            var name = textvalue.match(userTag);
            let dataString = name[0];
            alert(dataString);
            //if @abc avalable
            if (name.length > 0) {
                dataString = dataString.substring(1, dataString.length);
                $('#loadautocomplete').html('');
                $.ajax({
                    url: 'companypagewebservices/show_autocomplete.asmx/getautocompletename',
                    method: 'POST',
                    data: { namestring: dataString },
                    dataType: 'json',
                    success: function (data) {
                        if (data.length == 0) {
                            $('#loadautocomplete').html('');
                            $('#loadautocomplete').css("display", "none");
                        }
                        else {
                            $(data).each(function (index, item) {
                                $('#loadautocomplete').css("display", "block");
                                if (item.profilepic != null) {
                                    $("<li class='autocomplete-list' data-username =\'" + item.username + "\'  data-name='" + item.name + "'  ><ul><li><img class='autocomplete-image' src = data:Image/png;base64," + item.profilepic + " /></li><li><label class='autocomplete-name'>" + item.name + "</label><label class='autocomplete-title'>" + item.profiletitle + "</label><li></ul></li>").appendTo($('#loadautocomplete'));
                                }
                                else {
                                    $("<li class='autocomplete-list' data-username =\'" + item.username + "\' data-name ='" + item.name + "' ><ul><li><img class='autocomplete-image' src= 'images/grey.png' /></li><li><label class='autocomplete-name'>" + item.name + "</label><label class='autocomplete-title'>" + item.profiletitle + "</label><li></ul></li>").appendTo($('#loadautocomplete'));
                                }
                            });
                        }
                    },
                    error: function (response) {
                        //
                    },
                });
            }
            else {
                //
            }
        }
        else {
            //
        }
    });


    // append the name and username and name to the status textbox when the user clicks on any name

    $(document).on("click", ".autocomplete-list", function () {
        tagusername = $(this).data("username");
        name = $(this).data("name");
        var word = /@(\w+)/ig; //@abc Match
        var old = $("#postcontents").html();
        var content = old.replace(word, " "); //replacing @abc to (" ") space
        $("#postcontents").html(content);
        $('<a contenteditable="false" class="tagged-link" href=profile_guest.aspx?username=' + tagusername + ' data-username =' + tagusername + '>' + name + '</a>').appendTo($('#postcontents'));

        $('#postcontents').focus();


        $('#loadautocomplete').html('');
        $('#loadautocomplete').css("display", "none");

    });


    // posting the post to the database
    let postprivacy = "public";

    $(document).on("click", "#privateprivacy", function () {
        $(".post-privacy span").removeClass("active-profile-privacy");
        $(this).addClass("active-profile-privacy");
        postprivacy = "private";
    });

    $(document).on("click", "#publicprivacy", function () {
        $(".post-privacy span").removeClass("active-profile-privacy");
        $(this).addClass("active-profile-privacy");
        postprivacy = "public";
    });


    $(document).on("click", "#sharedpost", function () {
        var taggedusername = "";
        let textvalues = $("#postcontents").html();
        textvalue = encodeURI(textvalues);

        imgsrc = $("#postimagecontent").attr("src");
        // if textbox, fileupload is empty or more than 1500 length
        if (textvalue == '' && imgsrc == '') {
            $("#postcontents").focus();
        }
        else {
            // getting the username to which the user has tagged
            $("#postcontents a.tagged-link").each(function () {
                taggedusername += $(this).data("username") + ",";
            });

            let fd = new FormData();
            imgdata = $("#fileupload1").get(0).files[0];

            // if only text is there
            if (imgdata == "" || imgdata == null) {
                fd.append('activitypostdata', textvalue);
                fd.append('tag', taggedusername);
                fd.append('privacytype', postprivacy);

                // sending the data to activities.asmx 
                $.ajax({
                    contentType: "application/json; charset=utf-8",
                    method: 'post',
                    enctype: 'multipart/form-data',
                    url: 'userpagewebservices/loadnewsfeed.asmx/insertpoststext',
                    data: JSON.stringify({ activitypostdata: textvalue, tag: taggedusername, privacytype: postprivacy }),
                    processData: false,
                    cache: false,
                    success: function () {
                        $("#postcontents").html('');
                        $("#clearimage").trigger("click");
                        $(".load-new-posts").fadeIn(500);
                        $(".postdiv").css("display", "none");
                        $(".fake-post-share-div ").fadeIn();
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        //
                        //if (jqXHR.status == 500) {
                        //    alert('Internal error: ' + jqXHR.responseText);
                        //} else {
                        //    alert('Unexpected error.');
                        //}
                    }

                });

                return false;
            }
            // when there is a image to be inserted
            else {

                fd.append('imagefile', imgdata);
                fd.append('activitypostdata', textvalue);
                fd.append('tag', taggedusername);
                fd.append('privacytype', postprivacy);

                // sending the data to activities.asmx 
                $.ajax({
                    method: 'post',
                    enctype: 'multipart/form-data',
                    url: '../userpagewebservices/shareimagepost.ashx',
                    //url: '../userpagewebservices/shareimagepost.ashx?activitypostdata=" + textvalue',
                    // data: JSON.stringify({ fd: fd }),
                    data: fd,
                    // contentType: "application/json;charset=utf-8",
                    contentType: false,
                    processData: false,
                    cache: false,
                    success: function () {
                        $("#postcontents").html('');
                        $("#clearimage").trigger("click");
                        $(".load-new-posts").fadeIn(500);
                        $(".postdiv").css("display", "none");
                        $(".fake-post-share-div ").fadeIn();
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        //
                        //if (jqXHR.status == 500) {
                        //    alert('Internal error: ' + jqXHR.responseText);
                        //} else {
                        //    alert('Unexpected error.');
                        //}
                    }

                });
            }
        }

        return false;

    });


});
