<%@ Page Language="C#" AutoEventWireup="true" CodeFile="notifications.aspx.cs" Inherits="user_notifications" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Notifications</title>
      <!-- cdn scripts -->
     <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
 
    <!-- page styles -->
    <link href="styles/navigation.css" rel="stylesheet" />
    <link href="styles/fonts.css" rel="stylesheet" />
    <link href="styles/notification-page.css" rel="stylesheet" />

</head>

<body>
    <form id="form1" runat="server">
        <div>
              <!-- nav bar top fixed -->
    
<div class="top-navbar">
 <div class="container">   
  <div class="navbar-contents">  
    <div class="navbar-left-side">
        <img src="images/logo.png" class="navbar-owner-logo" />
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
             <br />

     
          <div class="container">
            <div class="row">
               <div class="col-md-4">
                <div class="notification-left-panel">
                   <div class="left-panel-header">
                        <h3 class="margin-bottom-15">
                            Notifications
                        </h3>
                        <p>
                            You have receieved <asp:Label ID="totnotify" runat="server" style="font-weight:600"></asp:Label> notifications till date 
                        </p>
                   </div>
                    <div class="left-panel-footer">
                       <h4 class="margin-bottom-25">
                            Notification Highlights
                       </h4>
                        <ul>
                            <li>
                                  Likes
                            </li>
                            <li>
                                   <asp:Label ID="likes" runat="server" ></asp:Label> 
                            </li>
                        </ul>
                          <ul>
                            <li>
                                 Comments
                            </li>
                            <li>
                                   <asp:Label ID="comments" runat="server" ></asp:Label> 
                            </li>
                        </ul>
                          <ul>
                            <li>
                                 Shared Posts
                            </li>
                            <li>
                                   <asp:Label ID="shared" runat="server" ></asp:Label> 
                           </li>
                          </ul>
                          <ul>
                            <li>
                                 Profile shares
                            </li>
                            <li>
                                   <asp:Label ID="profiles" runat="server" ></asp:Label> 
                            </li>
                           </ul>
                    </div>
                </div>
                </div>
           
                
                <div class="col-lg-8">
                    <div id="no_notifications" class="no-notification">
                        <span class="fa fa-bell-o"></span>
                        <br /><br />
                        <h3>
                            You have received no notifications do far
                        </h3>
                        <p>
                            You will receive all your notification updates here related to your posts, profiles, job updates and much more.
                        </p>
                    </div>

                   <div class="notification-load-panel">
                      <ul id="loadingnotifications" class="loadnotification">
                        </ul>
                       <div id="notiloader" class="loader" ></div>
                   </div>
       
               
           </div>
       </div>
    </div>

            

        </div>

         <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../userpagescripts/notification-page.js"></script>

    </form>
</body>
</html>
