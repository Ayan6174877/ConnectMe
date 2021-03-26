// lcounting and loading the followers
shownetworkcount();
function shownetworkcount() {
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/network.asmx/countnetwork',
        success: function (data) {
            $("#networkcount").html(data.d);
        },
        error: function (err) {
            $("#networkcount").html("0");
        }
    });
}

showfollowingcount();
function showfollowingcount() {
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/network.asmx/countfollowing',
        success: function (data) {
            $("#followingcount").html(data.d);
        },
        error: function (err) {
            $("#followingcount").html("0");
        }
    });
}

//  countinf and loading the followers of the user
countfollowers();
function countfollowers() {
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/network.asmx/countfollowers',
        success: function (data) {
            $("#followerscount").html(data.d);
        },
        error: function (err) {
            $("#followerscount").html("0");
        }
    });
}

countverification();
function countverification() {
    $.ajax({
        contentType: "application/json;charset=utf-8",
        method: 'post',
        url: '../../companypagewebservices/network.asmx/countverification',
        success: function (data) {
            $("#verificationrequestcount").html(data.d);
          //  countrequest = parseInt($("#verificationrequestcount").html());
        },
        error: function (err) {
            $("#verificationrequestcount").html("0");
        }
    });
}

countnetworkrequest();
function countnetworkrequest() {
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../../userpagewebservices/network.asmx/countnetworkrequest',
        success: function (data) {
            $("#networkrequestcount").html(data.d);
           // countrequest = parseInt($("#verificationrequestcount").html());
        },
        error: function (err) {
            $("#networkrequestcount").html("0");
        }
    });
}