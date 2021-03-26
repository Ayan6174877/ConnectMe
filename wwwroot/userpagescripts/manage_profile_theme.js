$(document).ready(function () {
    // checking which theme is selected
    var requestUser = $("#requestUser").val();
    let bodycolor;
    let headercolor;
    let textcolor;
    checktheme();
    function checktheme() {
        $.ajax({
            url: '../../userpagewebservices/user_profile_main.asmx/checktheme',
            method: 'post',
            dataType: "json",
            data: { requestuserdetails: requestUser },
            success: function (data) {
                if (data.length == 0) {
                    document.documentElement.style.setProperty('--background-color', "#696969");
                    document.documentElement.style.setProperty('--text-color', "#ffffff");
                }
                else {
                    // body color is the header color
                    // background-color is the main color goes to the body and other elements
                    $(data).each(function (index, item) {
                        if (item.bodycolor == '') {
                            document.documentElement.style.setProperty('--background-color', "#F69454");
                           document.documentElement.style.setProperty('--text-color', "#ffffff");
                        }
                        else {
                            bodycolor = item.bodycolor
                            headercolor = item.headercolor;
                            textcolor = item.textcolor;

                            document.documentElement.style.setProperty('--background-color', bodycolor);
                            document.documentElement.style.setProperty('--text-color', textcolor);
                        }
                    });
                }
            },
            error: function (err) {
                document.documentElement.style.setProperty('--background-color', "#696969");
                document.documentElement.style.setProperty('--text-color', "#ffffff");
            }
        });
    }

});



