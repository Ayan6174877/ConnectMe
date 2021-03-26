<%@ Page Language="C#" AutoEventWireup="true" CodeFile="visitors.aspx.cs" Inherits="user_visitors" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Visitors</title>
      <!-- cdn scripts -->
     <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
 
    <!-- page styles -->
    <link href="../styles/navigation.css" rel="stylesheet" />
    <link href="../styles/profile-page.css" rel="stylesheet" />
     <link href="../styles/visitors.css" rel="stylesheet" />
    <link href="../styles/user-short-profile.css" rel="stylesheet" />
    <link href="../styles/fonts.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
              <!-- nav bar top fixed -->
    
<div class="top-navbar">
 <div class="container">   
  <div class="navbar-contents">  
    <div class="navbar-left-side">
        <img src="../images/logo.png" class="navbar-owner-logo" />
        <!-- search -->
        <div class="navbar-search-inputs">
            <input id="quick-search" type="text" placeholder="Search" />
            <span class="fa fa-search" />
             <!-- search will load here -->
            <div class="loading-search-results">
                <div class="quick-search-filter">
                    <p class="search-for-text">
                         Search For
                     </p>
                     <div class="search-filters">
                         <span class="search-filter-active"> People</span>
                         <span> companies</span>
                         <span> Jobs</span>
                         <span> teams</span>
                     </div>
                  </div>
                       <div class="recent-search">
                                    <p class="search-for-text">
                                        Recent
                                    </p>
                                    <span class="clear-search" >Clear search</span>
                                    </div>
                                     <div class="no-search-result">
                                            <span class="fa fa-user-o"></span><br>
                                            We have Found no results
                                     </div>
                                    <div class="load-search">
                                   </div>
                        </div>
            <!-- end of search load -->
        </div>
    </div>
    <div class="navbar-right-side">
        <ul class="navbar-options">
            <li>
                <span class="fa fa-sun-o"></span>
            </li>
            <li>
                <span class="fa fa-user-o"></span>
                <span id="peoplecount" class="notification-toggle">0</span>
            </li>
            <li>
                <span class="fa fa-bell-o"></span>
                <span id="countnotifications" class="notification-toggle">0</span>
            </li>
            <li>
                <span class="fa fa-envelope-o"></span>
                <span id="countmessage" class="notification-toggle">0</span>
            </li>
            <li class="show-nav-options">
               <img class="navbar-user-icon profile-picture-render" />
                <div class="nav-more-options">
                    <div class="nav-more-header">
                        <img id="navbar_pic" src="" class="profile-picture-render" />
                        <p class="navbar-name profile-name-render">
                        </p>
                        <p class="navbar-title profile-title-render">
                        </p>
                        <span class="view-profile-btn" >View Profile</span>
                    </div>
                    <div class="nav-more-body">
                        <ul>
                            <li>
                                Jobs
                            </li>
                            <li>
                                Profile visitors
                            </li>
                            <li>
                                Shared profile
                            </li>
                        </ul>
                        <div class="nav-body-gap">
                        </div>
                        <ul>
                            <li>
                                General settings
                            </li>
                            <li>
                                Privacy
                            </li>
                            <li>
                                Blocked users
                            </li>
                            <li>
                                Sign Out
                            </li>
                        </ul>
                    </div>
                </div>
              </li>
          </ul>
      </div>
    </div>
  </div>
</div>
<!-- end of navbar -->
<div class="clear-gap"></div>

               <!-- main profile -->

            

<div class="container">
    <div class="row">
        <!-- top section -->
        <div class="col-md-12">
           <div class="profile-top-panel"> 
            <div class="cover-div relative">
                <img class="profile-cover-render" />
            </div>
            <div class="main-profile-header relative">
                <div class="image-profile-picture relative"> 
                    <img class="profile-picture-render" />
                </div>
                <h3 class="profile-main-name profile-name-render">
                </h3>
                <p class="profile-main-title profile-title-render">
                </p>
                <!-- personal Info -->
           <%--     <ul class="header-personal-info">
                    <li>
                        <span class="fa fa-map-pin"></span> Gurgaon, India
                    </li>
                    <li>
                        <span class="fa fa-user-o"></span> 678 Network
                    </li>
                    <li>
                        <span class="fa fa-moon-o"></span> 786 Followers
                    </li>
                    <li>
                        <span class="fa fa-calendar-o"></span> 16th of may
                    </li>
                </ul>--%>
              </div>
               <div class="profile-navigations">
                <a href="" >My Profile</a>
                <a href="" >Activities</a>
                <a href="" class="active-profile">Visitors</a>
                <a href="" >Network</a>
                <!-- <a href="" >Career Growth</a> -->
            </div>

        </div>
            </div>
         
        </div>
    </div>
    <!-- end of container -->
      <br />
  
    <div class="container">
            <div class="row">
                <div class="col-lg-9">
                    <div class="visitors-highlight-panel">
                        <div class="visitor-panel-header">
                            <h3>Profile Visitors</h3>
                        </div>
                    </div>

                    <div class="panel-flex">
                        <div class="left-highlight-panel">
                            <div class="left-panel-body">
                                <h4>Highlights
                                </h4>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <p class="small-para">
                                            Visitors till date
                                        </p>
                                        <h1 id="countvisitors" class="total-visitors"></h1>
                                    </div>
                                    <div class="col-lg-6">
                                        <p class="small-right-para">
                                            In last 30 days
                                        </p>
                                        <ul class="visitors-highlgiht-info">
                                            <li>
                                                <strong id="recentvisitor">0</strong>&nbsp; Profile vsitors
                                            </li>
                                            <li>
                                                <strong id="recentvworking">0</strong>&nbsp; Currently working <label style="text-transform:lowercase;display:none" id="recentworkingname"></label>
                                            </li>
                                            <li>
                                                <strong  id="recentcompany">0</strong>&nbsp; Company available
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="right-highlight-panel">
                            <div class="right-panel-body">
                                <h4>
                                    Visitors location
                                </h4>

                                <div align="center" style="margin-top:50px;">
                                    <h4>
                                        Locations of the visitors will load here
                                    </h4>
                                </div>

                            </div>
                        </div>
                    </div>
                    <hr style="border-width: 3px; border-color: silver" />
                </div>
                <div class="col-lg-3">
                    <div class="profile-visitors-tips">
                        <div class="tips-header">
                            <h4>Why Profile visitors matters
                            </h4>
                            <small>Every visitors can add a lot of value to your career
                            </small>
                        </div>
                        <div class="tips-body">
                            <p class="useful-tips">
                                Some useful tips
                            </p>
                            <ul class="tips-ul">
                                <li>
                                    <b>Profile -</b> Always keep your profile up to date and help others to find you easily.
                                </li>
                                <li>
                                    <b>Engage-</b> Share your thoughts with others and keep yourself engaged with the activities happening on Jobeneur.
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- container for loading the visitors -->
        <div class="container  margin-bottom-25">
            <div class="row">
                <div class="col-lg-9">
                    <div class="novisitor">
                        <span class="fa fa-eye-slash"></span>
                        <h4 class="margin-bottom-15">People are not visiting your profile so far
                        </h4>
                        <p>
                            Make sure your profile is completed which will help others to find you quickly on Jobeneur
                        </p>
                        <br />
                        <a href="profile.aspx" class="formbuttons">See my Profile</a>
                    </div>
                </div>

                <div class="col-lg-12">
                    <ul id="loadvisitors">
                    </ul>
                    <div id="visitorloader" class="loader"></div>
                </div>
            </div>
        </div>



        </div>

         <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../../userpagescripts/manage_profile_theme.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../../userpagescripts/visitors.js"></script>

    </form>
</body>
</html>
