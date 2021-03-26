<%@ Page Language="C#" AutoEventWireup="true" CodeFile="blocking.aspx.cs" Inherits="blocking" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Settings</title>
   

     <meta name="viewport" content="width=device-width, initial-scale=0" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />

    <!-- jQuery library -->

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="scripts/jquery.autosize.min.js"></script>
    <script type="text/javascript" src="scripts/moment.js"></script>


    <link href="companypagestyle/style.css" rel="stylesheet" />
    <link href="companypagestyle/mainpagestyle.css" rel="stylesheet" />
    <script src="userpagescripts/notifications.js"></script>
    <link href="userpagestyle/mainpagestyle.css" rel="stylesheet" />
    <link href="userpagestyle/settings-design.css" rel="stylesheet" />
    <link href="userpagestyle/loader-design.css" rel="stylesheet" />

</head>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="updatedata" runat="server"></asp:ScriptManager>
      <!-- Header Container
================================================== -->
        <header id="header-container" class="fullwidth">

            <!-- Header -->

            <div id="header" style="box-shadow: none; border-bottom: solid; border-bottom-width: 1px; border-bottom-color: rgba(0,0,0,.12)">
                <div class="container">
                    <!-- Left Side Content -->
                    <div class="left-side">

                        <!-- Logo -->
                        <div id="logo">
                            <a href="user.aspx">
                                <img src="logo/logo.png" alt="" /></a>
                        </div>

                        <!-- Main Navigation -->
                        <nav id="navigationbuttons">
                            <ul id="responsivelist">
                                <li><a href="user.aspx">Home</a>
                                </li>
                              <%--  <li><a href="#">Jobs</a>
                                    <ul class="dropdown-navmenu">
                                        <li><a href="user_jobs.aspx">Find a Job</a></li>
                                        <li><a href="savedjobs.aspx">Saved Jobs</a></li>
                                        <li><a href="job-status.aspx">Applied Jobs</a></li>
                                    </ul>
                                </li>--%>
                            </ul>
                        </nav>
                        <div class="clearfix"></div>
                        <!-- Main Navigation / End -->
                        <!-- Left Side Content / End -->

                    </div>
                    <!-- Right Side Content / End -->
                    <div class="right-side">

                        <!--  User Notifications -->
                        <div class="header-widget hide-on-mobile">

                            <!-- network -->
                            <ul class="notificationsstyle">
                                <li>
                                    <a href="friends.aspx"><i class="fa fa-user-o"></i>
                                        <asp:Label runat="server" class="notificationbadge" ID="peoplecount"></asp:Label></a>
                                </li>
                                <li>
                                    <a href="notifications.aspx"><i class="fa fa-bell-o"></i>
                                        <asp:Label runat="server" ID="countnotifications" class="notificationbadge"></asp:Label></a>
                                </li>
                                <li>
                                    <a href="messages.aspx"><i class="fa fa-inbox"></i>
                                        <asp:Label runat="server" ID="countmessage" class="notificationbadge"></asp:Label></a>
                                </li>
                            </ul>

                            <!--  User Notifications / End -->

                            <!-- User Menu -->
                            <div class="header-widget">

                                <!-- Messages -->
                                <div class="header-notifications user-menu">
                                    <div class="header-notifications-trigger">
                                        <a href="#">
                                            <div class="user-avatar">
                                                <asp:Image ID="navprofilepic1" runat="server" class="navbar-profilepic-size" alt="" />
                                            </div>
                                        </a>
                                    </div>

                                    <!-- Dropdown -->
                                    <div class="header-notifications-dropdown">
                                        <div class="navbar-dropdown-top-header">
                                            <div class="container-fluid">
                                                <div class="row">
                                                    <div class="col-lg-12">
                                                        <asp:Image ID="profilepic" runat="server" class="navbar-profilepic-size" alt="" />
                                                        <p>
                                                            <asp:Label ID="loginusername" runat="server" CssClass="navname"></asp:Label>
                                                        </p>
                                                        <p>
                                                            <asp:Label ID="titlesprofile" runat="server" CssClass="nav-title"></asp:Label>
                                                        </p>
                                                        <a href="profile.aspx" class="btn viewprofile">My Profile
                                                        </a>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                        <ul class="user-menu-small-nav">
                                            <li><a href="sharedprofiles.aspx"><i class="fa fa-id-card-o"></i>Shared profiles</a></li>
                                            <li><a href="profileviews.aspx"><i class="fa fa-eye-slash"></i>Profile visitors</a></li>
                                            <li><a href="general-settings.aspx"><i class="fa fa-lock"></i>Settings and privacy</a></li>
                                             <li>
                                               <asp:LinkButton ID="LinkButton11" OnClick="logout_Click" runat="server">
                                                <i class="fa fa-power-off"></i> Logout</asp:LinkButton></li>
                                        </ul>

                                    </div>
                                </div>

                            </div>
                            <!-- User Menu / End -->
                        </div>
                        <!-- Right Side Content / End -->

                    </div>
                </div>
            </div>
            <!-- Header / End -->

        </header>
        <!-- main content of the page -->
        <div class="cleargap"></div>
        <div class="succesfully-change">
             Changes applied successfully
            <span class="fa fa-close close-successful"></span>
        </div>
        <br />

    <div class="container">
        <div class="row">
            <div class="col-lg-4">
                   <div class="setting-right-panel">
                       <div class="setting-right-panel-header">
                           <img id="image1" src="images/grey.png" />
                           <h3 id="names">
                                <asp:Label ID="name" runat="server" ></asp:Label>
                           </h3>
                           <p id="joined_date">
                           </p>
                       </div>
                       <div class="setting-right-panel-body">
                           <ul>
                               <li>
                                   <a href="general-settings.aspx">
                                      <h4> General </h4>
                                       <p>
                                           Change your personal information
                                       </p>  
                                   </a>
                               </li>
                                <li>
                                <a href="privacy-settings.aspx">
                                  <h4> Privacy </h4>
                                   <p>
                                       Take complete control of your account and data privacy
                                   </p>  
                                </a>
                               </li>
                               <li>
                                    <a href="security.aspx">
                                      <h4> Security and logging </h4>
                                       <p>
                                            Change your logging information
                                       </p>  
                                    </a>
                               </li>
                                <li class="active-settting">
                                      <h4> Blocking </h4>
                                       <p>
                                           Secure your account 
                                       </p>  
                               </li>
                                <%-- <li>
                                    <a href="account-settings.aspx">
                                      <h4> Account </h4>
                                       <p>
                                           Make changes to your basic account settings
                                       </p>  
                                    </a>
                               </li>--%>
                           </ul>
                       </div>
                   </div>
            </div>


          <div class="col-lg-8" >
              <div class="setting-main-panel">
                  <div class="setting-main-panel-header">
                      Block users whom you don't want to connect on Jobeneur
                  </div>
                <!-- name -->
                
              
            <div id="block_loader" >
                  <ul class="block-user-loader">
                      <li>
                          <div class="initial-loader-circle-large" ></div>
                      </li>
                      <li>
                          <div class="initial-loader-large"></div>
                          <div class="initial-loader-small width-60"></div>
                      </li>
                  </ul>
                  <ul class="block-user-loader">
                      <li>
                          <div class="initial-loader-circle-large" ></div>
                      </li>
                      <li>
                          <div class="initial-loader-large"></div>
                          <div class="initial-loader-small width-60"></div>
                      </li>
                  </ul>
                  <ul class="block-user-loader">
                      <li>
                          <div class="initial-loader-circle-large" ></div>
                      </li>
                      <li>
                          <div class="initial-loader-large"></div>
                          <div class="initial-loader-small width-60"></div>
                      </li>
                  </ul>
                  <ul class="block-user-loader">
                      <li>
                          <div class="initial-loader-circle-large" ></div>
                      </li>
                      <li>
                          <div class="initial-loader-large"></div>
                          <div class="initial-loader-small width-60"></div>
                      </li>
                  </ul>
                  <ul class="block-user-loader">
                      <li>
                          <div class="initial-loader-circle-large" ></div>
                      </li>
                      <li>
                          <div class="initial-loader-large"></div>
                          <div class="initial-loader-small width-60"></div>
                      </li>
                  </ul>
             </div>  
           
                 <div id="load_block_user">
                </div>
                   
                  <div class="no-block">
                      <span class="fa fa-ban">
                      </span>
                      <h2 style="color:rgba(0,0,0,0.4)">
                          You have blocked no one
                      </h2>
                  </div>
        
              </div>


                </div></div></div>
        

          
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <%--     <script src="scripts/settings.js"></script>      
  --%>      <script src="userpagescripts/settings_page.js"></script>
        <script src="userpagescripts/blockuser.js"></script>


   </form>
</body>
</html>
