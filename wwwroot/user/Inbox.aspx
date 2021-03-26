<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Inbox.aspx.cs" Inherits="user_Inbox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Messages</title>

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
    <link href="styles/inbox.css" rel="stylesheet" />
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
                <div class="chat-theme-design">
                        <div class="chat-left-panel">
                            <div class="chat-left-header">
                                Messages
                            </div>

                            <!-- left panel of the chat page -->
                            <div class="chat-left-chat-user-body">
                             <div class="chat-load-div" >
                                <div class="no-chats">
                                    <span class="fa fa-inbox"></span>
                                    <br />
                                    You have received mo messgaes yet
                                </div>
                                   <ul id="load_chatlist" class="load-chat">
                                   </ul>
                                    <div id="loader_chatlist" class=" loader"></div>
                               </div>
                            </div>
                         </div>

                    <!-- end -->

                     <!-- right panel of the chat page -->
        
                     

                            <div class="chat-right-chat-user-body">
                                <div class="no-messages" >
                                    <span class="fa fa-inbox" ></span> <br /><br />
                                    Start a conversation with the people on Jobeneur 
                                    <br /><br />
                                    <a href="friends.aspx" >
                                        <span class="formbuttons" >
                                            Start a conversation
                                        </span>
                                    </a>
                               </div>
                            <div class="hide_conversation" >
                               <div class="right-panel-header">
                                   <a id="messageuserredirect" >
                                    <img id="message_userimage" />
                                  </a>
                                    <div class="load-user-data">
                                        <h4 id="message_user_name">
                                        </h4>
                                        <h5 id="message_user_title">
                                        </h5>
                                  </div>
                              </div>
                                <!-- main chat body where the chats foer a specific user sload -->
                                <div class="loader" id="message_loader"></div>
                                <div id="load_chat_data" class="main-chat-body">
                                </div>


                                <div class="right-chat-panel-footer">
                                    <asp:TextBox ID="sendmessagetext" runat="server" TextMode="MultiLine" CssClass="message-send-input" placeholder="Type a message" ></asp:TextBox>
                                    <div style="padding:10px;text-align:right" >
                                        <span id="send_message_btn" role="button" class="formbuttons disable-btn" >Send</span>
                                    </div>
                                </div>


                         </div>
                     </div>
                            <!-- end right panel -->
                </div>
                </div>
            </div>

    <asp:HiddenField ID="usernameuser" runat="server" />       

   
        </div>

          <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../userpagescripts/messaging_chat.js"></script>
    </form>
</body>
</html>
