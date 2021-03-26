loadjobs();
function loadjobs() {
    $('#loading_job').html('');
    $.ajax({
        url: 'userpagewebservices/jobs.asmx/loadjobs',
        method: 'POST',
        dataType: 'json',
        cache: 'true',
        dekay: '10',
        beforeSend: function () {
            $("#loader_jobs").css("display", "block");
        },
        success: function (data) {
            $("#jobs_found").html(data.length);
            $("#loader_jobs").css("display", "none");
            if (data.length == 0) {
                $("#no_jobs").css("display", "block");
            }
            else {
                $(data).each(function (index, item) {
                    $("#no_jobs").css("display", "none");
                    $('<div class="load-job-div"><img src = data:Image/png;base64,' + item.profilepic + ' /><ul class="load-job-details"><li class="job-role">' + item.jobtitle + '</li><li><ul class="load-more-job-details"><li> <span class="fa fa-building-o"></span>' + item.companyname + ' </li><li> <li><span class="fa fa-map-marker"></span>' + item.joblocation + ' </li><li> <li><span class="fa fa-briefcase"></span>' + item.jobtype + ' </li><li> <li><span class="fa fa-clock-o"></span>' + item.date + ' </li></ul><li><ul class="job-action"><li><a href="loadjobdetails.aspx?id=' + item.jobid + '"><span class="job-btn-action fa fa-expand"> &nbsp; View Details</span></a></li><li><span id="savejob_' + item.jobid + '" class="save-job-btn job-btn-action fa fa-bookmark-o"> &nbsp; Save Job</span></li></ul></li></ul></div>').appendTo($('#loading_job'));

                    // if job is already been saved by the user

                    if (item.jobsaved === false) {
                        $('#savejob_' + item.jobid).css("display", "block");
                    }
                    else {
                        $('#savejob_' + item.jobid).css("display", "none");
                    }

                });
            }
        },
        error: function (err) {
            $("#loader_jobs").css("display", "none");
            $("#no_jobs").css("display", "block");
        }
    });
}

countsavejob();
function countsavejob() {
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: 'userpagewebservices/jobs.asmx/savedjobcounts',
        success: function (data) {
            $("#save_job_count").html(data.d);
        },
        error: function (err) {
            $("#save_job_count").html("0");
        }
    });

}

countappliedjob();
function countappliedjob() {
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: 'userpagewebservices/jobs.asmx/appliedjobcounts',
        success: function (data) {
            $("#applied_job_count").html(data.d);
        },
        error: function (err) {
            $("#applied_job_count").html("0");
        }
    });

}

// svaed job page scripts

loadsavedjobs();
function loadsavedjobs() {
    $('#loading_saved_job').html('');
    $.ajax({
        url: 'userpagewebservices/jobs.asmx/loadsavedjobs',
        method: 'POST',
        dataType: 'json',
        cache: 'true',
        dekay: '10',
        beforeSend: function () {
            $("#loader_jobs").css("display", "block");
        },
        success: function (data) {
            $("#loader_jobs").css("display", "none");
            $("#saved_jobs").html(data.length + " Saved Jobs");
            if (data.length == 0) {
                $("#no_jobs").css("display", "block");
            }
            else {
                $("#no_jobs").css("display", "none");
                $(data).each(function (index, item) {
                    $('<div class="load-job-div"><img src = data:Image/png;base64,' + item.profilepic + ' /><ul class="load-job-details"><li class="job-role">' + item.jobtitle + '</li><li><ul class="load-more-job-details"><li> <span class="fa fa-building-o"></span>' + item.companyname + ' </li><li> <li><span class="fa fa-map-marker"></span>' + item.joblocation + ' </li><li> <li><span class="fa fa-briefcase"></span>' + item.jobtype + ' </li><li> <li><span class="fa fa-clock-o"></span>' + item.date + ' </li></ul><li><ul class="job-action"><li><a href="loadjobdetails.aspx?id=' + item.jobid + '"><span class="job-btn-action fa fa-expand"> &nbsp; View Details</span></a></li><li><span id="savejob_' + item.jobid + '" data-jobid = ' + item.jobid + ' class="unsave-job-btn job-btn-action fa fa-bookmark"> &nbsp; Unsave</span></li></ul></li></ul></div>').appendTo($('#loading_saved_job'));
                });
            }
        },
        error: function (err) {
            $("#loader_jobs").css("display", "none");
            $("#no_jobs").css("display", "block");
        }
    });
}


$(document).on("click", ".unsave-job-btn", function () {
    jobid = $(this).data("jobid");
    unsavebtn = $(this);
    $.ajax({
        contentType: "application/json; charset=utf-8",
        method: 'post',
        url: '../userpagewebservices/jobs.asmx/unsavejob',
        data: JSON.stringify({ jobid: jobid }),
        success: function () {
            $(unsavebtn).fadeOut();
        },
        error: function (err) {
            alert(err);
        }
    });

});




loadapplicationstatus();
function loadapplicationstatus() {
    $('#load_job_applied').html('');
    $.ajax({
        url: 'userpagewebservices/jobs.asmx/loadjobstatus',
        method: 'POST',
        dataType: 'json',
        cache: 'true',
        dekay: '10',
        beforeSend: function () {
            $("#job_status_loader").css("display", "block");
        },
        success: function (data) {
            $("#job_status_loader").css("display", "none");
            if (data.length == 0) {
                $("#no_jobs").css("display", "block");
            }
            else {
                $("#no_jobs").css("display", "none");
                $(data).each(function (index, item) {
                    $('<div class="col-lg-3"><div class="applied-job-panel"><ul><li><img src = data:Image/png;base64,' + item.profilepic + ' /></li><li class="job-role">' + item.jobtitle + '</li><li class="job-location">' + item.joblocation + '</li></ul><ul class="job-status"><li>' + item.applicationstatus + '</li><li>' + item.date + '</li></ul></div></div>').appendTo($('#load_job_applied'));
                });
            }
        },
        error: function (err) {
            $("#job_status_loader").css("display", "none");
            $("#no_jobs").css("display", "block");
        }
    });
}