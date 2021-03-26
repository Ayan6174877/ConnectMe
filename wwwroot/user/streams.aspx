<%@ Page Language="C#" AutoEventWireup="true" CodeFile="streams.aspx.cs" Inherits="user_streams" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Streams</title>
     <!-- cdn scripts -->
     <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://unpkg.com/masonry-layout@4/dist/masonry.pkgd.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
    <link href="https://emoji-css.afeld.me/emoji.css" rel="stylesheet" />

    <!-- page styles -->
    <link href="styles/navigation.css" rel="stylesheet" />
    <link href="styles/fonts.css" rel="stylesheet" />
    <link href="styles/color.css" rel="stylesheet" />
    <link href="styles/newsfeed.css" rel="stylesheet" />
    <link href="styles/recommendations.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
         <div>
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
<!-- end of navbar -->
<div class="clear-gap"></div>

          <asp:HiddenField ID="usertype" runat="server" />
         <asp:HiddenField ID="postid" runat="server" />
        <asp:HiddenField ID="username" runat="server" />
        <asp:HiddenField ID="companyusername" runat="server" />
        <asp:Image ID="profilepic" runat="server"  style="display:none"/>

        <div class="container" style="margin-top:-15px;padding:0">
            <div class="row">
                <div class="col-md-7">
                     <div id="loadposts"></div>
                </div>
            </div>
        </div>
            
             
<!-- loading like people overlay -->

    <div id="loading_reactions_modal" class="post-modal-data">
        <div class="post-modal-dialogue modal-md">
            <div class="post-modal-header">
                <span class="fa fa-close fa-close-reaction-modal"></span>
                <p id="total_post_reactions">
                    0 people reacted </p>
                </div>
            <div id="load_like_user" class="post-modal-body load-reaction-users">
            </div>
        </div>
    </div>

                   <!-- reporting the post as spam or some other content -->
                <div id="reportpost" class="modal fade" role="dialog">
                    <div class="modal-dialog ui-front" style="margin-top: 100px">
                        <!-- Modal content-->
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title" style="font-family: Verdana; font-weight: 100; color: black">What you din't like about this post?
                                </h4>
                            </div>
                            <asp:Label ID="reportpostid" Style="display: none" runat="server"></asp:Label>
                            <div class="modal-body" align="center" style="padding: 2px;">
                                <div id="reportsuccess" style="display: none">
                                    <h5 style="font-family: Verdana; font-weight: 200; padding: 5px; line-height: 1.5em">You have just reported this post. You will be no longer seeing this post on your newsfeed
                                    </h5>
                                </div>
                                <div id="reportsuccessdone">
                                    <table style="border-collapse: separate; border-spacing: 5px">
                                        <tr>
                                            <td>
                                                <asp:LinkButton ID="inappropriate" runat="server" CssClass="btn btn-lg  btn-default img-thumbnail reprtingpost" Width="100%" Style="font-family: Verdana; font-weight: 500; font-size: 15px;" BorderStyle="None">I think this post is inappropraite for Jobeneur</asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:LinkButton ID="spam" runat="server" CssClass="btn btn-lg  btn-default img-thumbnail reprtingpost" Width="100%" Style="font-family: Verdana; font-weight: 500; font-size: 15px" BorderStyle="None">I think this post is a spam or scam</asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:LinkButton ID="offensive" runat="server" CssClass="btn btn-lg  btn-default img-thumbnail reprtingpost" Width="100%" Style="font-family: Verdana; font-weight: 500; font-size: 15px" BorderStyle="None">I think the language is offensive or abusive</asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:LinkButton ID="pornographic" runat="server" CssClass="btn btn-lg  btn-default img-thumbnail reprtingpost" Width="100%" Style="font-family: Verdana; font-weight: 500; font-size: 15px" BorderStyle="None">I think the content is pornographic or extremely violent </asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:LinkButton ID="threat" runat="server" CssClass="btn btn-lg  btn-default img-thumbnail reprtingpost" Width="100%" Style="font-family: Verdana; font-weight: 500; font-size: 15px" BorderStyle="None">I think it's harrasment or a threat </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
           <!-- end of reporting the post as spam or some other content -->
    

        </div>
            <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../userpagescripts/jquery.linky.js"></script>
         <script src="../userpagescripts/jquery.linky.min.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../../userpagescripts/postactions.js"></script>
        <script src="../userpagescripts/loadpost.js"></script>
    </form>
</body>
</html>
