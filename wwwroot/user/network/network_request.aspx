<%@ Page Language="C#" AutoEventWireup="true" CodeFile="network_request.aspx.cs" Inherits="user_network_network" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Network request</title>
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
    <link href="../styles/message_feature_style.css" rel="stylesheet" />
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
              </div>
               <div class="profile-navigations">
                <a href="" >My Profile</a>
                <a href="" >Activities</a>
                <a href="" >Visitors</a>
                <a href="" class="active-profile">Network</a>
                <!-- <a href="" >Career Growth</a> -->
            </div>

        </div>
            </div>
         
        </div>
    </div>
    <!-- end of container -->
  <br />
      <!--   container for loading network -->
        <div id="loadnetworkdiv" class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="network-navigation">
                        <ul>
                            <li>
                                Network
                                <span id="networkcount" class="network-count">0</span>
                            </li>
                             <li>
                                Following
                                <span id="followingcount" class="network-count">0</span>
                            </li>
                             <li>
                                Followers
                                <span id="followerscount" class="network-count">0</span>
                            </li>
                             <li class="active-network-tab">
                                Network request
                                <span id="networkrequestcount" class="network-count">0</span>
                            </li>
                             <li>
                                Verification request
                                <span id="verificationrequestcount" class="network-count">0</span>
                            </li>
                        </ul>
                    </div>
                </div>

              <div class="col-md-9">
                         <div class="nonetworkrequest" >
                            <span class="fa fa-group" style="font-size:50px"></span>
                                 <h3>
                                       There are no network request
                                </h3>
                           </div>
                      <ul id="loadingnetworkrequest">
                     </ul>
                </div>
            </div>
       </div>

        
</div>

         <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../../userpagescripts/manage_profile_theme.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../../userpagescripts/visitors.js"></script>
        <script src="../../userpagescripts/network_count.js"></script>
        <script src="../../userpagescripts/network-request.js"></script>
    

    </form>
  </body>
</html>

