
$(document).ready(function () {

    getslidernews();
    // loading the top slider news from the database
    slidercount = 0;
    indicatorcount = 0;
    function getslidernews() {
        slidercount = 0;
        $.ajax({
            // contentType: "application/json; charset=utf-8",
            url: 'userpagewebservices/beat.asmx/loadslidernews',
            method: 'post',
            dataType: "json",
            beforeSend: function () {
                $("#loader1").css("display", "block");
            },
            success: function (data) {
                $("#loader1").css("display", "none");
                if (data.length == 0) {
                    $(".nonews").css("display", "block");
                    $(".load-news").css("display", "none");
                }
                else {
                    $(data).each(function (index, item) {
                        slidercount += 1;
                        if (slidercount == 1) {
                            $('<a class="newslinks" data-link=' + item.newslink + ' data-id=' + item.postid + ' target="_blank" ><div class="item active"><img class="newsimage" src= ' + "data:Image/png;base64," + item.newsimage + ' /></a> <div class="news-posted-by-large"><img class="posted-by-small-img" src=' + "data:Image/png;base64," + item.profilepic + ' /></div><div class="left-news-overlay"><h4 class="left-title">' + item.newstitle + '</h4><label class="left-count-news">' + item.count + '</label><p class="left-para">' + item.postdescription + '<p></div></div></div>').appendTo($(".left-panel-news #myCarousel .carousel-inner"));
                            var element = "<li data-target='#myCarousel' class='active' data-slide-to='" + indicatorcount + "'></li>"
                            $(".indicator-position").append(element);
                        }
                        else {
                            indicatorcount += 1;
                            $('<a class="newslinks" data-link=' + item.newslink + ' data-id=' + item.postid + ' target="_blank" ><div class="item"><img class="newsimage" src= ' + "data:Image/png;base64," + item.newsimage + ' /></a> <div class="news-posted-by-large"><img class="posted-by-small-img" src=' + "data:Image/png;base64," + item.profilepic + ' /></div><div class="left-news-overlay"><h4 class="left-title">' + item.newstitle + '</h4><label class="left-count-news">' + item.count + '</label><p class="left-para">' + item.postdescription + '<p></div></div></div>').appendTo($(".left-panel-news #myCarousel .carousel-inner"));
                            var element = "<li data-target='#myCarousel' data-slide-to='" + indicatorcount + "'></li>"
                            $(".indicator-position").append(element);
                        }
                    });
                }
            },
            error: function (err) {
                //
            }
        });

    }

    loadmorenews();
    function loadmorenews() {
        $.ajax({
            // contentType: "application/json; charset=utf-8",
            url: 'userpagewebservices/beat.asmx/loadmorenews',
            method: 'post',
            dataType: "json",
            beforeSend: function () {
                $("#loader2").css("display", "block");
            },
            success: function (data) {
                $("#loader2").css("display", "none");
                if (data.length == 0) {

                }
                else {
                    $(data).each(function (index, item) {
                        $('<div class="load-div-news"><div class="news-posted-by"><img class="posted-by-small-img" src= ' + "data:Image/png;base64," + item.profilepic + ' /></div><a class="newslinks" data-link=' + item.newslink + ' data-id=' + item.postid + ' target="_blank" ><img class="newsimage" src= ' + "data:Image/png;base64," + item.newsimage + ' /></a><h4>' + item.newstitle + '</h4><label class="right-count-news">' + item.count + '</label><p>' + item.postdescription + '<p></div>').appendTo($(".right-news-panel"));
                    });
                }
            },
            error: function (err) {
                //
            }
        });

    }

    // removing the news 

    $(document).on("click", ".newslinks", function () {
        btn = $(this);
        newsid = $(this).attr("data-id");
        link = $(this).attr("data-link");
        $.ajax({
            contentType: "application/json; charset=utf-8",
            method: 'post',
            url: 'userpagewebservices/beat.asmx/updatviewcount',
            data: '{id: ' + newsid.toString() + '}',
            success: function () {
                window.open(link);
            },
            error: function (err) {
                alert(err);
            }
        });
    });
});
