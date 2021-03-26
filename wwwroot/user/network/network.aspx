<%@ Page Language="C#" AutoEventWireup="true" CodeFile="network.aspx.cs" Inherits="user_network_network" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Network</title>
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
     <link href="../styles/network-list.css" rel="stylesheet" />
     <link href="../styles/color.css" rel="stylesheet" />
    <link href="../styles/fonts.css" rel="stylesheet" />
    <link href="../styles/message_feature_style.css" rel="stylesheet" />
    <link href="../styles/recommendations.css" rel="stylesheet" />
 
</head>
<body>
    <form id="form1" runat="server">
        <div>
              <!-- nav bar top fixed -->
    
     <!-- nav bar top fixed -->
 <div class="top-navbar">
 <div class="container-fluid">   
  <div class="navbar-contents">  
    <div class="navbar-left-side">
        <img src="../../user/images/logo.png" class="navbar-owner-logo navigation-home" />
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
      <div class="navbar-center-side hide-on-mobile">
          <ul>
              <li class="active-center-nav navigation-home">
                  Home
              </li>
              <li>
                  Discover
              </li>
              <li class="navigation-profile">
                   My profile
              </li>
            <%--  <li>
                  <span class="create-post" > Create &nbsp;<span class="fa fa-plus"></span></span>
              </li>--%>
          </ul>
      </div>
    <div class="navbar-right-side">
        <ul class="navbar-options">
            <li>
                <span class="fa fa-user-o navigation-network"></span>
                <span id="peoplecount" class="notification-toggle">0</span>
                 <span class="nav-tooltip"> Network</span>
            </li>
            <li>
                <span class="fa fa-bell-o navigation-notifications"></span>
                <span id="countnotifications" class="notification-toggle">0</span>
                   <span class="nav-tooltip"> Notifications </span>
            </li>
            <li>
                <span class="fa fa-envelope-o navigation-inbox"></span>
                <span id="countmessage" class="notification-toggle">0</span>
                  <span class="nav-tooltip"> Messages </span>
            </li>
            <li class="last-list">
               <img class="navbar-user-icon profile-picture-render show-nav-options" />
                <div class="nav-more-options">
                   <div class="relative">
                    <div class="nav-more-header">
                          <img id="navbar_pic" src="" class="profile-picture-render" />
                        <p class="navbar-name profile-name-render">
                        </p>
                        <p class="navbar-title profile-title-render">
                        </p>
                    </div>
                    <div class="nav-more-body">
                        <ul>
                             <li class="navigation-home show-on-mobile">
                                 Home
                            </li>
                            <li class="navigation-profile show-on-mobile">
                                My profile
                            </li>
                             <li class="navigation-discover show-on-mobile">
                                Discover
                            </li>
                            <li>
                                 Jobs
                            </li>
                            <li>
                                 Profile visitors
                            </li>
                            <li>
                                 General settings
                            </li>
                            <li>
                                 Privacy
                            </li>
                            <li>
                                 Account
                            </li>
                            <li>
                                 Blocked
                            </li>
                            <li class="navigation-logout">
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
</div>
<!-- end of navbar -->
<div class="clear-gap"></div>

      <!--   container for loading network -->
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="div-panel">
                        <div class="div-panel-body" >
                              <img src="" class="profile-picture-render" />
                            <p  class="profile-name-render" style="font-size:16px;font-weight:600;margin-top:10px"></p>
                           <p  class="profile-title-render" style="font-size:13px;opacity:0.7;margin-top:5px"></p>
                         </div>     
                      <div class="network-navigation-tabs">
                       <ul>
                           <li>
                            Network
                           <span id="networkcount" class="network-count">0</span>
                           </li>
                           <li class="active-navigation-tab">
                            <a href="following.aspx">
                                Following
                               <span id="followingcount">0</span> 
                                </a>
                           </li>
                           <li>
                              Followers
                             <span id="followerscount" class="network-count">0</span>
                           </li>
                           <li>
                                Pending Invites
                              <span id="networkrequestcount" class="network-count">0</span>
                           </li>
                         <%--  <li>
                               <span id="verificationrequestcount" class="network-count">0</span>
                                 &nbsp;  Pending verifications
                           </li>--%>
                       <%--    <li>
                               Tags
                                <span id="tags" class="network-count">768</span>
                           </li>
                       --%> <li>
                              Communities
                              <span id="community" class="network-count">4,256</span>
                           </li>
                       </ul>
                    </div>

                        </div>
                </div>
        
             <div class="col-md-6">
                 <div id="invites_panel" class="network-panel request-panel" style="margin-bottom:20px;">
                     <div class="network-heading-div">
                           Pending Invites
                    </div>
                     <div class="netowrk-main-body">
                           <div id="loadingnetworkrequest">
                          </div>
                   </div>
                </div>

                <div class="network-panel">
                     <div class="network-heading-div">
                           My network
                    </div>
                    <div class="netowrk-main-body">
                           <div id="loadingnetwork" class="load-network-data-flex"></div>
                          <div class="nonetwork" >
                              <span class="fa fa-user-o" style="font-size:40px"></span>
                                <br />
                                 <h4>
                                       You have got 0 people in your network
                                </h4>
                                 <h6>
                                       Start growing your network and unlock doors with great career opportunities
                                </h6>
                          </div>
                    </div>
                </div>
             </div>
              <!-- end of col -->
              <div class="col-md-3 hide-on-mobile">
                    <div class="div-panel" >
                      <div class="div-panel-body" >
                          <p style="font-size:18px;font-weight:100">
                               Want to follow
                          </p>
                      </div>
                    <div id="load_people_suggestions" class="load-connection-suggestion">
                    </div>
                 </div>
              </div>

            </div>
       </div>
   
     <!-- end of column-8 -->


              <!-- chat box for conversation with other people -->
            <asp:HiddenField ID="usernameuser" runat="server" />
           <div id="chat_box_load" class="chat-box">
           </div>
         <!-- chatbox ends here -->  


         <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../../userpagescripts/network_count.js"></script>
        <script src="../../userpagescripts/network.js"></script>
       <script src="../../userpagescripts/suggesstions.js"></script>
    
    </form>
  </body>
</html>

