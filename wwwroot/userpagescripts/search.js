//hiding and showing the search box


//showing the search result to the user
$(document).ready(function () {

    $("#Search").on(' keyup paste keydown focus', function () {
        if ($("#Search").val() == "") {
            $('.searchresult').html('');
            $('.searchresult').fadeOut();
        }
        else {
            $('.searchresult').fadeIn();
            $('#Search').autocomplete({
                minLength: 0,
                source: function (request, response) {
                    $.ajax({
                        //  url: 'search1.asmx/GetCountries',
                        url: 'search.ashx/ProcessRequest',
                        method: 'post',
                        data: { term: request.term },
                        dataType: 'json',
                        cache: false,
                        success: function (data) {
                            if (data.length > 0) {
                                //$('#searchmore').fadeIn();
                                response(data);
                            }
                            else {
                                $('.showresult').html("<li style='padding:10px' class='mediumtext'>Found no results for '" + request.term + "' <br><br><a class='btn btn-md btn-default'  href=" + "search-results.aspx?search=" + request.term + ">Show better results</a></li>");
                            }
                        },

                        error: function (err) {
                            alert(err);
                        }

                    });

                },

                focus: updateTextBox,
                select: function (e, u) {
                    if (u.item.val == -1) {
                        return false;
                    }
                }
            })

      .autocomplete('instance')._renderItem = function (ul, item) {
          if (item.usertype == 'company') {
              var html = $("<li><a href=" + "companies.aspx?username=" + item.username + " ><div class='searchimage'> <img class='searchcompanylogo' src= " + "data:Image/png;base64," + item.profilepic + "  style=backgound-image:url(~/images/user.png)   /> </div> <div class='searchtextresult'><ul><li> " + item.name + " Company </li><li> " + item.industry + " </li></ul></div></a></li>");

             return $(html)
            .data("item.autocomplete", item)
            .appendTo($('.showresult'))
          }
          else {
              // calling a ajax call for getting the experience of the user
              if (item.profilepic != null) {
                  var html = $("<li><a href=" + "profile_guest.aspx?username=" + item.username + " ><div class='searchimage'> <img class='searchuserimage' src= " + "data:Image/png;base64," + item.profilepic + "  style=backgound-image:url(~/images/user.png)   /> </div> <div class='searchtextresult'><ul><li> " + item.name + " </li><li> " + item.profiletitle + " </li></ul></div></a></li>");
              }

              else {
                  var html = $("<li><a href=" + "profile_guest.aspx?username=" + item.username + " ><div class='searchimage'> <img class='searchuserimage' src= 'images/user.png'   /> </div> <div class='searchtextresult'><ul><li> " + item.name + " </li><li>  " + item.profiletitle + " </label> <li></ul></div></a></li>");
              }
              return (html)
               .data("item.autocomplete", item)
               .appendTo($('.showresult'))
          }

      };
            $('.searchresult').html('');
            function updateTextBox(event, ui) {
                return false;
            }
        }
    });

});

// closing and opening search menu

function clossearchmenu() {
    $(".searchnavbar").css("width", "0");
}

$('.searchtoggle').on("click", function () {
    var widthcheck = $(".searchnavbar").css("width");
    if (widthcheck == "0px") {
        $(".searchnavbar").css("width", "360px");
        $("#Search").focus();
    }
    else {
        $(".searchnavbar").css("width", "0px");
    }

});


// closing and opening right side menu

function closesidemenu() {
    $(".rightmenunavbar").css("width", "0");
}

$('#profilepic').on("click", function () {
    var widthcheck = $(".rightmenunavbar").css("width");
    if (widthcheck == "2px") {
        $(".rightmenunavbar").css("width", "250px");
    }
    else {
        $(".rightmenunavbar").css("width", "2px");
    }

});