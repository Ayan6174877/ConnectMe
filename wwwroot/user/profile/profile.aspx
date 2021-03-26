<%@ Page Language="C#" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="user_profile_profile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title>Profile</title>
    <!-- cdn scripts -->
     <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <!-- Latest compiled JavaScript -->
   <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
    <!-- icons -->
    <script defer src="https://friconix.com/cdn/friconix.js"> </script>
  
    <!-- page styles -->
     <link href="../styles/style.css" rel="stylesheet" />
    <link href="../styles/fonts.css" rel="stylesheet" />
    <link href="../styles/color.css" rel="stylesheet" />
    <link href="../styles/profile-page.css" rel="stylesheet" />
    <link href="../styles/manage-profile-page.css" rel="stylesheet" />
  

</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="requestUser" runat="server" />
        <asp:HiddenField ID="sessionuser" runat="server" />
        <asp:HiddenField ID="IsSessionEqualsRequest" runat="server" />
        <asp:HiddenField ID="IsSessionActive" runat="server" />

           <!-- left navbar -->
              <div class="left-navbar">
                <div class="left-navbar-top-icons">
                                <ul>
                                    <li class="navigation-home">
                                        <i class="fi-xnluxl-home-thin"></i>
                                        <span class="navbar-tooltip" >Home</span>
                                   </li>
                                    <li class="navigation-discover">
                                        <i class="fi-xtluxl-beating-heart-thin"></i>
                                        <span class="navbar-tooltip" >Discover</span>
                                    </li>
                                    <li class="navigation-jobs">
                                        <i class="fi-xtluxl-folder-thin"></i>
                                        <span class="navbar-tooltip" >Jobs</span>
                                    </li>
                                    <li class="navigation-network">
                                        <i class="fi-xnluxl-user-thin"></i>
                                        <span class="navbar-tooltip" >Network</span>
                                        <i id="peoplecount" class="fi-xtsuxl-dot-solid notification-dot"></i>
                                    </li>
                                    <li class="navigation-notifications">
                                        <i class="fi-xtluxl-envelope-thin"></i>
                                        <span class="navbar-tooltip" >Messaging</span>
                                        <i id="countmessage" class="fi-xtsuxl-dot-solid notification-dot"></i>
                                    </li>
                                    <li class="navigation-inbox">
                                        <i class="fi-xtluxl-bell-thin"></i>
                                        <span class="navbar-tooltip" >Notification</span>
                                        <i id="countnotifications" class="fi-xtsuxl-dot-solid notification-dot"></i>
                                    </li>
                                </ul>
                            </div>
                            <div class="left-navbar-bottom-icons">
                                <ul>
                                     <li class="navigation-profile">
                                            <img class="navbar-profile-icon profile-picture-render" />
                                            <span class="navbar-tooltip" >My profile</span>
                                     </li>
                                    <li>
                                        <i class="fi-xtluxl-setting-thin"></i>
                                        <span class="navbar-tooltip" >Settings</span>
                                   </li>
                                   <li>
                                    <i class="fi-ctluxl-smiley-happy-thin"></i>
                                    <span class="navbar-tooltip" >Feedback</span>
                               </li>
                                </ul>
                            </div>
                    </div>
        <!-- end of left navbar -->             

         <!-- main component area -->

  <div class="main-componenet">   
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="rrow">
                    <div class="col-md-12">
                        <div class="top-navbar">
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-md-8 col-xs-3">
                                        <img src="../../user/images/logo.png" class="brand-logo-navbar" />
                                    </div>
                                    <div class="col-md-3 col-xs-9">
                                      <div class="quick-search-input">
                                            <input id="quick_search" placeholder="Type for Search" />
                                            <i class="fi-xnluxl-magnifying-glass quick-search-btn " ></i>
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
                                                           </div>
                                                         </div>
                                                    </div>
                    </div>
               </div>
              <!-- end of navbar -->

          <!-- connection request sent by the user if any -->
              <div class="network-request-panel request-panel">
                  <div class="network-request-header">
                      <h4>
                          Network Request
                      </h4>
                      <span class="fa fa-close close-network-req"></span>
                  </div>
                  <div class="network-request-body">
                       <p style="font-size:14px;line-height:1.6em;opacity:0.8">
                          You have a network request from <span class="profile-guest-name-render"></span>. Do you want to accept it or decline it?
                       </p>
                       <br />
                           <div class="request-absolute">
                                  <span id="accept-request" class="request-btn-filled">
                                        Accept
                            </span>
                            <span id="decline-request" class="request-btn">
                                Decline
                      </span>
                  </div>
              </div>
        </div>

        <div class="main-content">
 
           <!-- main profile -->

            <div class="row">
                <div class="col-md-12">
                    <!-- main containers for all the components -->
                    <div class="main-container">
                        <div class="container-fluid">
                                <div class="row">
                                    <div class="col-md-12">
                                        <!-- for cover -->
                                        <div class="cover-div">
                                          <img class="cover-img coverpic" />
                                            <!-- options for guest users -->
                                                 <div class="profile-action-options request-user">
                                                     <span class="profile-action-btn">More actions</span>
                                                </div>
                                            <!-- end of options -->
                                          </div>
                                    </div>
                                 </div>
                                 <div class="row" >
                                <div class="col-md-3">
                                    <div class="profile-data-margin">
                                                 <div class="image-profile-picture"> 
                                                     <img class="profile-guest-picture-render" />
                                                     <span id="cover-video" title="Click to play" class="fa fa-play-circle show-cover-letter" role="button" ></span>
                                                 </div>
                                                 <div class="heading-padding">
                                                     <p class="profile-main-name profile-guest-name-render">
                                                    </p>
                                                      <p class="profile-main-title profile-guest-title-render">
                                                    </p>
                                                     <div class="social-links">
                                                    </div>
                                                 </div>
                                                <%--<h5>
                                                    More Info
                                                </h5>--%>
                                            <hr />
                                                <ul class="more-info">
                                                    <li>
                                                        <i class="fi-xtluxl-map-marker-thin"></i>
                                                        <p id="locations" runat="server">
                                                        </p>
                                                    </li>
                                                    <li>
                                                         <i class="fi-xnluxl-gift-thin"></i>
                                                         <p id="dob" runat="server">
                                                        </p>
                                                    </li>
                                                    <li>
                                                          <i class="fi-xtluxl-user-thin"></i>
                                                         <p id="totalnetwork">
                                                        </p>
                                                    </li>
                                                    <li>
                                                          <i class="fi-xtluxl-user-plus-thin"></i>
                                                         <p id="totalfollowers">
                                                        </p>
                                                    </li>
                                                </ul>
                                            </div>
                                <!-- to network and some other profile actions to take -->
                               <asp:HiddenField ID="messageprivacy" runat="server" />
                               <asp:HiddenField ID="networkprivacy" runat="server" />
                            </div>
                     

                             <!-- modal that contains options to intearct with the guest user -->
                                   <div class="profilw-action-modal">
                                                    <div class="profilw-action-modal-content">
                                                    <div class="profile-action-header">
                                                        More Actions
                                                        <span class="fa fa-close close-action-modal"></span>
                                                    </div>
                                                    <div class="profile-action-body">
                                                      <ul>
                                                       <li id="following_btn" class="follow-btn follow-user">
                                                           Follow
                                                       </li>
                                                       <li id="send-request">
                                                           Build network
                                                        </li>
                                                         <li id="cancel-request">
                                                           Cancel request
                                                        </li>
                                                         <li id="remove-network">
                                                            Connected
                                                        </li>
                                                         <li id="shhare-profile">
                                                           Share profile via message
                                                        </li>
                                                        <li id="show_message_btn">
                                                           Write a message
                                                        </li>
                                                         <li class="block-user">
                                                            Block
                                                        </li>
                                                        <li class="block-user">
                                                            Report this user
                                                        </li>
                                                   </ul>
                                                    </div>
                                                </div>
                                              </div>
                             <!-- end -->
                                
                                <!-- middle main section -->
                                      <div class="col-md-6" >
                                         <div class="profile-navigations">
                                            <a href="" class="active-profile" >Profile</a>
                                            <a href="" >Activities</a>
                                            <a href="" >Saved</a>
                                        </div>
   
   <!-- profile data -->
      <!-- row to load profile strengths -->
         <div class="row">
             <div class="col-md-12">
                     <div class="profile-panel">
                         <div class="profile-panel-body" style="padding:15px 0;">
                             <p class="profile-panel-heading-small">
                               <%-- Let's have a quick look at your Profile highlights and how
                                well are you doing--%>
                                 Profile strength and highlights
                             </p>
                              <p style="font-size:13px;opacity:0.6;margin-top:-8px">
                                  Private to you only
                              </p>
                        </div>
                         <div class="strength-panel-flex">
                             <!-- profile complete -->
                             <div class="strength-panels">
                                 <div class="strength-heading">
                                     <p class="strngth-title">
                                          Profile Strength
                                     </p>
                                      <p class="strngth-title-para">
                                          Always keep your profile data authentic and up-to-date, It increase your chances of success
                                     </p>
                                 </div>
                                 <div class="profile-complete-body">
                                     <div class="profile-complete-body-left">
                                           <div class="div-meter-circle">
                                                <div class="meter-circle-filled-one"></div>
                                                <div id="profile_complete_percent" class="meter-circle-filled-two"></div>
                                             </div>
                                     </div>
                                     <div class="profile-complete-body-right">
                                          <p id="profile_complete_percent_data" class="strength-counts">
                                                 0
                                          </p>
                                          <p class="strength-remarks">
                                              Your profile looks great
                                          </p>
                                     </div>
                                  </div>
                                 <div class="strength-footer">
                                     Make changes <span class="fa fa-angle-right"></span>
                                 </div>
                              </div>

                             <!-- recent profile visitors -->
                               <div class="strength-panels">
                                 <div class="strength-heading">
                                    <p class="strngth-title">
                                          Recent visitors
                                     </p>
                                      <p class="strngth-title-para">
                                         Anyone on Jobeneur can find your profile and reach out to you if your privacy policies allow it..
                                      </p>
                                   </div>
                                 <div class="profile-complete-body">
                                     <div class="profile-complete-body-left">
                                            <p class="strength-counts recent-profile-views">
                                                0
                                            </p>
                                          <p class="strength-remarks">
                                             People visits your profile in last 7 days
                                          </p>
                                     </div>
                                     <div class="profile-complete-body-right visitor-profile">
                                     </div>
                                  </div>
                                 <div class="strength-footer">
                                     Make changes <span class="fa fa-angle-right"></span>
                                 </div>
                              </div>

                             <!-- jobs applied -->
                               <div class="strength-panels">
                                 <div class="strength-heading">
                                    <p class="strngth-title">
                                          Jobs Applied
                                     </p>
                                      <p class="strngth-title-para">
                                            We always suggest you to apply for Jobs that you find most compatible. It Increases your chances of success
                                      </p>
                                   </div>
                                 <div class="profile-complete-body">
                                     <div class="profile-complete-body-left">
                                            <p class="strength-counts total-Jobs-applied">
                                                 0
                                           </p>
                                          <p class="strength-remarks">
                                             Applied for 80 Jobs in last 7 days
                                          </p>
                                     </div>
                                     <div class="profile-complete-body-right visitor-profile">
                                         <img src="../../jobeneur/images/faces/face1.jpg" />
                                         <img src="../../jobeneur/images/faces/face2.jpg" />
                                     </div>
                                  </div>
                                 <div class="strength-footer">
                                     Check out jobs <span class="fa fa-angle-right"></span>
                                 </div>
                              </div>

                             <!-- post engagemtnt -->
                              <div class="strength-panels">
                                 <div class="strength-heading">
                                    <p class="strngth-title">
                                        Streams Engagement
                                     </p>
                                      <p class="strngth-title-para">
                                          Engagement with the streams shared by the people in your community may helps you to learn and leverage your network
                                      </p>
                                   </div>
                                 <div class="profile-complete-body">
                                     <div class="profile-complete-body-left">
                                            <p class="strength-counts total-post-engagement">
                                                0
                                           </p>
                                          <p class="strength-remarks">
                                              Streams engagement in last 7 days
                                          </p>
                                     </div>
                                     <div class="profile-complete-body-right visitor-profile">
                                         <img src="../../jobeneur/images/faces/face1.jpg" />
                                         <img src="../../jobeneur/images/faces/face2.jpg" />
                                         <img src="../../jobeneur/images/faces/face1.jpg" />
                                         <img src="../../jobeneur/images/faces/face2.jpg" />
                                
                                         <img src="../../jobeneur/images/faces/face1.jpg" />
                                         <img src="../../jobeneur/images/faces/face2.jpg" />
                                     </div>
                                  </div>
                                 <div class="strength-footer">
                                     Check my activities <span class="fa fa-angle-right"></span>
                                 </div>
                              </div>
                         </div>
                  </div>
             </div>
          </div>
     
    <!-- fresh row to load information about the user -->
      <div class="row">
        <div class="col-md-12">
       <!-- row to load contact information and other stuff -->
              <!-- about part -->
                <div class="profile-panel-default">
                         <div class="profile-panel-header">
                              About me
                          </div>
                         <div class="profile-panel-body">
                           <p id="aboutme" class="profile-panel-para">
                          </p>
                             <a id="showmoreabout" role="button" style="display:none;text-decoration:none;"  class="showaboutfulldata">....Read more </a>
                      </div>
                  </div>
              
                <!-- end of about part -->
         

           <!-- experience part -->
            <div class="row">
                <div class="col-md-12">
                   <div class="profile-panel-default">
                         <div class="profile-panel-header">
                             Work Experience
                        <div id="exp_scroll_overflow_btns" class="scroll-overflow-buttons">
                            <span id="exp_scrool_left"" class="fa fa-angle-left"></span>
                            <span id="exp_scrool_right" class="fa fa-angle-right"></span>
                        </div>
                     </div>
                    </div>
                     <div class="profile-panel-body no-horizontal-padding no-vertical-padding">
                     <div id="exp_scroll" class="profile-data-scroll-horizontal">
                    <div class="profile-data-flex exp-data-flex">
                    </div>
                </div>
             <!-- loading experience data on demand -->
                <div class="load-data-profile exp-ondemand-data">
                  <div class="demand-data exp-demand-data"></div>
                    <div class="team-data">
                         <h3 id="count_teams">
                         </h3>
                    </div>
                   </div>
                 </div>
                 </div>
              </div>
                <!-- end of experience part -->
            <!-- education part -->    
             <div class="row">
                <div class="col-md-12">
                    <div class="profile-panel-default">
                         <div class="profile-panel-header">
                            Education and Courses
                        <div id="edu_scroll_overflow_btns" class="scroll-overflow-buttons">
                            <span id="edu_scrool_left"" class="fa fa-angle-left"></span>
                            <span id="edu_scrool_right" class="fa fa-angle-right"></span>
                        </div>
                    </div>
                 </div>
               <div class="profile-panel-body no-horizontal-padding no-vertical-padding">
                <div id="edu_scroll" class="profile-data-scroll-horizontal">
                    <div class="profile-data-flex edu-data-flex">
                    </div>
                </div>
                 <!-- loading education data on demand -->
                 <div class="load-data-profile edu-ondemand-data">
                  <div class="demand-data edu-demand-data"></div>
                   </div>
               </div>
            </div>
         </div>
           <!-- end of education part -->
               <!-- skills -->
                
               <div class="profile-panel">
                    <div class="profile-panel-header">
                        Skills and services
                    </div>
                     <div id="load_skills" class="skill-panel-body">
                    </div>
                    <div id="show_skill_more" class="profile-main-section-panel-footer font-size-14 font-weight-600 show-more-skill">
                    </div>
                </div>

                <!-- end of skills -->
                <!-- start of projects -->
                  <%-- <div class="profile-panel">
                     <div class="profile-panel-header">
                        Projects
                     </div>
                     <div class="load-project-data"></div>
                  </div>--%>
                <!-- end of projects -->
         
          </div>
        <!-- end of column-8 -->

      <!-- end of column-4 -->
       </div>
    </div>
    <!-- end of container -->
   
              <!-- ne do fmiddle section -->
               <div class="col-md-3">
                                      <div class="explore-section-panel section-panel-hide hide-on-mobile">
                                                <div class="profile-section-count-footer">
                                                   <img class="profile-guest-picture-render" />
                                                   <p class="text-left">
                                                       Let's just help you add different career sections to your portfolio
                                                       and make it look good
                                                   </p>
                                                  <span role="button" class="show-section"> Create sections  &nbsp;<span class="fa fa-angle-down"></span> </span>
                                               </div>
                                               <div class="profile-sections-count">
                                                    <div id="edit_profile" class="not-session-user profile-sections-add manage-profile" >
                                                         <span class="fa fa-id-card-o"></span>
                                                        <div>
                                                            Make changes to the profile theme, profile picture, profile heading and more
                                                        </div>
                                                     </div>
                                                     <div class="profile-sections-add show-about">
                                                         <span class="fa fa-pencil"></span>
                                                        <div>
                                                             Write a brief summary about yourself sharing about your achievent, persoanl experiences and much more
                                                        </div>
                                                     </div>
                                                     <div class="profile-sections-add show-video-cover-section">
                                                         <span class="fa fa-play"></span>
                                                        <div>
                                                             Write a brief summary about yourself sharing about your achievent, persoanl experiences and much more
                                                        </div>
                                                     </div>
                                                     <div class="profile-sections-add show-exp">
                                                        <p id="total_work" class="profile-data-score">
                                                              0
                                                        </p>
                                                        <div>
                                                              Add your past and present work experience to your portfolio so that your colleagues and other 
                                                              can easily look for you
                                                        </div>
                                                   </div>
                                                  <div class="profile-sections-add show-edu">
                                                        <p id="total_education" class="profile-data-score">
                                                          0
                                                        </p>
                                                        <div>
                                                               Add your education history and coursework details to your portfolio
                                                        </div>
                                                  </div>
                                                  <div class="profile-sections-add show-skill">
                                                        <p class="profile-data-score">
                                                              144
                                                        </p>
                                                        <div>
                                                              Add your personal and professional skills to your portfolio
                                                        </div>
                                                  </div>
                                                   <div class="profile-sections-add show-project">
                                                        <p class="profile-data-score">
                                                              17
                                                        </p>
                                                        <div>
                                                              Add your personal and professioanl projects to your portfolio
                                                        </div>
                                                  </div>
                                                     <div class="profile-sections-add show-link">
                                                        <p class="profile-data-score">
                                                              17
                                                        </p>
                                                        <div>
                                                              Add url's of other websites to better showcase your project work and other stuffs
                                                        </div>
                                                  </div>
                                                </div>
                 
                                          </div>
    
                                    </div>
              </div>
           <br />
     
        <!-- end of profile-top panel -->
        </div>
 

        <div id="cover_modal" class="modal fade" role="dialog" style="background-color:rgba(0,0,0,0.8)" onclick="return false;">
          <div class="modal-dialog modal-md" style="border:none;">
            <!-- Modal content-->
            <div class="modal-content" style="background-color:transparent;box-shadow:none;">
              <div class="modal-header" style="border:none">
                <button type="button" class="close close-cover-modal" style="font-size:24px;color:white!important" >&times;</button>
              </div>
              <div class="modal-body">
                   <iframe id="video-url"  style="height:50vh;width:100%;min-width:300px;min-height:250px;"  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
              </div>
            </div>
          </div>
        </div>

    <!-- modal for loading profile sections to edit, add and delete them -->
    <!-- Modal -->
        <div id="edit_profile_modal" class="modal fade" role="dialog">
          <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Edit Profile</h4>
              </div>
              <div class="modal-body">
                   <div class="form-section" >
                                     <div class="theme-body text-center">
                                          <div class="theme-background-cover">
                                              <img id="changing_cover" class="profile-cover-render" />
                                              <span class="change-cover" onclick="$('#coverupload').click();return false;">Change cover</span>
                                              <asp:FileUpload ID="coverupload" runat="server" style="display:none" />
                                          </div>
                                           <div class="relative" style="margin-top:-80px;z-index:8">
                                               <img id="changing_picture" class="theme-profile-picture profile-picture-render" />
                                               <span id="trigger_change" class="fa fa-camera edit-dp" onclick="$('#profilepicupload').click();return false;"></span>
                                                <asp:FileUpload ID="profilepicupload" runat="server" style="display:none" />
                                             </div>
                                            <h3 class="profile-main-name profile-name-render">
                                            </h3>
                                            <asp:TextBox ID="addprofiletitle" runat="server" placeholder="Add your profile heading ( maximum 80 characters )" MaxLength="140" style="width:80%;border:none;outline:none;font-size:18px;text-align:center"></asp:TextBox>
                                            <div class="theme-choose-colors">
                                                <span data-bodycolor="#A43820" data-headercolor="#A43820" data-textcolor="#FFFFFF" class="fa fa-square choose-theme-main-1 apply-theme"></span>
                                                <span data-bodycolor="#FA6775" data-headercolor="#F52549" data-textcolor="#ffffff" class="fa fa-square choose-theme-main-2 apply-theme"></span>
                                                <span data-bodycolor="#66A5AD" data-headercolor="#375E97" data-textcolor="#ffffff" class="fa fa-square choose-theme-main-3 apply-theme"></span>
                                                <span data-bodycolor="#6AB187" data-headercolor="#20948B" data-textcolor="#ffffff" class="fa fa-square choose-theme-main-4 apply-theme"></span>
                                                <span data-bodycolor="#EE693F" data-headercolor="#F69454" data-textcolor="#ffffff" class="fa fa-square choose-theme-main-5 apply-theme"></span>
                                                <span data-bodycolor="#808080" data-headercolor="#696969" data-textcolor="#ffffff" class="fa fa-square choose-theme-main-6 apply-theme"></span>
                                                <span data-bodycolor="#FFFF00" data-headercolor="#CCCC00" data-textcolor="#000000" class="fa fa-square choose-theme-main-7 apply-theme"></span>
                                           </div>
                                         </div>  
                                      </div>
                                  </div>
                                  <div class="modal-footer">
                                       <span id="update_profile" class="form-buttons-modal" role="button" >Save changes</span>
                                  </div>
                            </div>
                          </div>
                        </div>
   
     
    <!-- div which will manage all the profile section activities -->
  
    <!-- about section -->
      <div  id="about_section" class="fixed-profile-section">
           <span class="close-profile-section fa fa-close"></span>
            <div class="fixed-profile-section-content">
             <div class="container">
                <div class="row">
                    <div class="col-md-12 col-xs-12">
                             <h3 class="profile-section-heading">
                                  Profile summary
                             </h3>
                              <p class="profile-section-tilte-para">
                                Write a brief summary about your personal and professional experiences in the best way possible. It way help 
                                visitors to understand about your perspective in a better way.
                              </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class=" col-md-6 col-xs-12">
                            <div class="form-main">
                                 <ul>
                                     <li>
                                       <div id="aboutme_update" contenteditable="true" class="long-textbox" data-placeholder="Write something"></div>
                                    </li>
                                     <li class="text-right">
                                          <span id="addabout" class="form-buttons" role="button">Save Changes</span>
                                     </li>
                                 </ul>
                             </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <!-- end of about section -->

      <!-- cover section -->
        <div  id="cover_section" class="fixed-profile-section">
           <span class="close-profile-section fa fa-close"></span>
            <div class="fixed-profile-section-content">
             <div class="container">
                <div class="row">
                    <div class="col-md-12 col-xs-12">
                        <div id="add-video">
                             <h3 class="profile-section-heading">
                                  Video cover letter
                             </h3>
                              <p class="profile-section-tilte-para">
                                  Add your personalized video link where you specially talk about your strengths, work ethics, achievements in the
                                  most summarized way possible. Adding a video cover letter can increase your chances of getting noticed by someone by almost 3x times
                             </p>
                            </div>
                        </div>
                   </div>
                  <div class="row">
                    <div class="col-md-6 col-xs-12">
                             <div class="form-main">
                                 <ul>
                                     <li>
                                          <asp:TextBox ID="covervideourl" TextMode="Url" runat="server" placeholder="Paste here your embedded youtube url" ></asp:TextBox>
                                     </li>
                                     <li>
                                          <div class="showremove cover-video-frame">
                                             <span id="removevideocover" title="Removr video cover letter" class="remove-video-letter fa fa-remove"></span>
                                             <iframe id="loadcovervideoletter" frameborder="0" class="iframesize" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                         </div>
                                     </li>
                                     <li class="text-right">
                                          <span id="addvideocover" class="form-buttons" role="button">Save Changes</span>
                                     </li>
                                 </ul>
                             </div>
                           </div>
                        </div>
                    </div>
            </div>
        </div>
    <!-- end of cover section -->

    <!-- adding website links -->
      <div  id="link_section" class="fixed-profile-section" >
           <span class="close-profile-section fa fa-close"></span>
            <div class="fixed-profile-section-content">
             <div class="container">
                <div class="row">
                    <div class="col-md-12 col-xs-12">
                             <h3 class="profile-section-heading">
                                 Links
                             </h3>
                              <p class="profile-section-tilte-para">
                                 Add website url's to your other social accounts, personal portfolio and more
                              </p>
                        </div>
                   </div>
                 <div class="row">
                     <div class="col-md-5">
                       <div class="form-main exp-forms">
                                 <ul>
                                       <li>
                                         <asp:DropDownList ID="DropDownList1" runat="server">
                                             <asp:ListItem Text="facebook" Value="../web-logo/facebook.png"></asp:ListItem>
                                             <asp:ListItem Text="Twitter" Value="../web-logo/twitter.png"></asp:ListItem>
                                             <asp:ListItem Text="Instagram" Value="../web-logo/instagram.png"></asp:ListItem>
                                             <asp:ListItem Text="Slideshare" Value="../web-logo/slideshare.png"></asp:ListItem>
                                             <asp:ListItem Text="Github" Value="../web-logo/github.png"></asp:ListItem>
                                             <asp:ListItem Text="Quora" Value="../web-logo/quora.png"></asp:ListItem>
                                             <asp:ListItem Text="Youtube" Value="../web-logo/youtube.png"></asp:ListItem>
                                             <asp:ListItem Text="Other" Value="../web-logo/link.png"></asp:ListItem>
                                         </asp:DropDownList>
                                     </li>
                                     <li>
                                        <asp:TextBox ID="TextBox1" runat="server" placeholder="Exter url"></asp:TextBox>
                                    </li>
                                 </ul>
                                   <ul>
                                        <li class="text-right">
                                              <span id="addlink" class="form-buttons" role="button">Add Link</span>
                                        </li>
                                  </ul>
                        </div>
                     </div>
                  </div>
                 </div>
                </div>
          </div>
     

    <!-- experience section -->
        <!-- adding exp -->
        <div id="exp_section" class="fixed-profile-section" >
           <span class="close-profile-section fa fa-close"></span>
            <div class="fixed-profile-section-content">
             <div class="container">
                <div class="row">
                    <div class="col-md-12 col-xs-12">
                             <h3 class="profile-section-heading">
                                 Work Experience
                             </h3>
                              <p id="exp_rand_para" class="profile-section-tilte-para">
                                     Mention your Job role ( ex - Senior manager , software engineer, CEO, Fashion designer and more )
                              </p>
                        </div>
                   </div>
                 <div class="row">
                     <div class="col-md-5">
                       <div class="form-main exp-forms">
                                 <ul>
                                     <li>
                                         <asp:TextBox ID="jobrole" runat="server" MaxLength="30" placeholder="Job role"></asp:TextBox>
                                     </li>
                                 </ul>
                                  <ul class="hide-input">
                                     <li>
                                         <asp:TextBox ID="organization" runat="server" placeholder="Company name"></asp:TextBox>
                                     </li>
                                   </ul>
                                    <ul class="hide-input">
                                     <li>
                                         <asp:TextBox ID="expstartdate" runat="server" placeholder="Start date"></asp:TextBox>
                                          <asp:TextBox ID="expenddate" runat="server" placeholder="End date"></asp:TextBox>
                                     </li>
                                       <li style="justify-content:flex-start">
                                             <input type="checkbox" id="currentlyworking" style="width:45px;height:20px;background:transparent;color:white;margin-left:-10px;margin-top:10px" />
                                                <label for="currentlyworking" style="margin-top:12px;margin-left:-10px">Currently working</label>
                                       </li>
                                    </ul>
                                    <ul class="hide-input">
                                         <li>
                                            <asp:TextBox ID="joblocations" runat="server" placeholder="location"></asp:TextBox>
                                         </li>
                                    </ul>
                                     <ul class="hide-input">
                                         <li>
                                             <asp:TextBox ID="industry" runat="server" placeholder="Industry"></asp:TextBox>
                                         </li>
                                    </ul>
                                     <ul class="hide-input">
                                       <li>
                                            <div id="expdescription" contenteditable="true" class="long-textbox" data-placeholder="Write here"></div>
                                       </li>
                                     </ul>
                                        <ul>
                                            <li class="text-right">
                                                  <span id="add_exp" class="form-buttons" role="button">Next</span>
                                            </li>
                                       </ul>
                                </div>
                           </div>
                   </div>
               </div>
             </div>
            </div>
         <!-- end of adding experience -->

        <!-- edit experience -->
         <div  id="edit_exp_section" class="fixed-profile-section" >
           <span class="close-profile-section fa fa-close"></span>
            <div class="fixed-profile-section-content">
             <div class="container">
                <div class="row">
                    <div class="col-md-12 col-xs-12">
                             <h3 class="profile-section-heading">
                                Edit Work Experience
                             </h3>
                              <p id="wrongdate" class="profile-section-tilte-para">
                             </p>
                      </div>
                   </div>
                 <div class="row">
                     <div class="col-md-5">
                       <div class="form-main">
                                 <ul>
                                     <li>
                                         <asp:TextBox ID="edit_jobrole" runat="server" MaxLength="30" placeholder="Job role"></asp:TextBox>
                                     </li>
                                 </ul>
                                  <ul>
                                     <li>
                                         <asp:TextBox ID="edit_organization" runat="server" placeholder="Company name"></asp:TextBox>
                                     </li>
                                   </ul>
                                    <ul>
                                     <li>
                                         <asp:TextBox ID="edit_expstartdate" runat="server" placeholder="Start date"></asp:TextBox>
                                          <asp:TextBox ID="edit_expenddate" runat="server" placeholder="End date"></asp:TextBox>
                                     </li>
                                       <li style="justify-content:flex-start">
                                             <input type="checkbox" id="edit_currentlyworking" style="width:45px;height:20px;background:transparent;color:white;margin-left:-10px;margin-top:10px" />
                                             <label for="edit_currentlyworking" style="margin-top:12px;margin-left:-10px">Currently working</label>
                                       </li>
                                    </ul>
                                    <ul>
                                         <li>
                                            <asp:TextBox ID="edit_joblocations" runat="server" placeholder="location"></asp:TextBox>
                                         </li>
                                    </ul>
                                     <ul>
                                         <li>
                                             <asp:TextBox ID="edit_industry" runat="server" placeholder="Industry"></asp:TextBox>
                                         </li>
                                    </ul>
                                     <ul>
                                       <li>
                                            <div id="edit_expdescription" contenteditable="true" class="long-textbox" data-placeholder="Write here"></div>
                                       </li>
                                     </ul>
                                        <ul>
                                            <li class="text-right">
                                                  <span id="edit_exp" class="form-buttons update-experience" role="button">Save Changes</span>
                                            </li>
                                       </ul>
                                </div>
                           </div>
                   </div>
               </div>
             </div>
            </div>
    <!-- end of edit experience -->

    <!-- end of experience section -->
        <!-- education section forms -->
        <!-- adding education -->
         <div  id="edu_section" class="fixed-profile-section" >
           <span class="close-profile-section fa fa-close"></span>
            <div class="fixed-profile-section-content">
             <div class="container">
                <div class="row">
                    <div class="col-md-12 col-xs-12">
                             <h3 class="profile-section-heading">
                                 Education
                             </h3>
                              <p id="edu_rand_para" class="profile-section-tilte-para">
                                     Mention the type of degree
                              </p>
                        </div>
                   </div>
                 <div class="row">
                     <div class="col-md-5">
                       <div class="form-main edu-forms">
                                <ul>
                                    <li>
                                         <asp:DropDownList ID="degreetype" runat="server"  Style="border:solid;border-width:1px;border-color:lightcyan; width: 100%;height:50px">
                                            <asp:ListItem Text="Associate Degree" Value="Associate Degree"></asp:ListItem>
                                            <asp:ListItem Text="Diploma Degree" Value="Diploma Degree"></asp:ListItem>
                                            <asp:ListItem Text="Bachelor's Degree" Value="Bachelors Degree"></asp:ListItem>
                                            <asp:ListItem Text="Master's Degree" Value="Masters Degree"></asp:ListItem>
                                            <asp:ListItem Text="Doctoral Degree" Value="Doctoral Degree"></asp:ListItem>
                                            <asp:ListItem Text="Other" Value="othere"></asp:ListItem>
                                        </asp:DropDownList>    
                                     </li>
                                 </ul>
                                  <ul class="hide-input">
                                     <li>
                                               <asp:TextBox ID="qualification" runat="server" placeholder="Degree / Course name" ></asp:TextBox>
                                   </li>
                                   </ul>
                                    <ul class="hide-input">
                                        <li>
                                               <asp:TextBox ID="institute" runat="server" placeholder="Institute name" ></asp:TextBox>
                                        </li>
                                    </ul>
                                    <ul class="hide-input">
                                     <li>
                                           <asp:TextBox ID="starteducation" runat="server" TextMode="Month" ></asp:TextBox>
                                           <asp:TextBox ID="endeducation" runat="server" TextMode="Month"></asp:TextBox>
                                     </li>
                                    </ul>
                                    <ul class="hide-input">
                                         <li>
                                             <asp:TextBox ID="educationspecialize" runat="server"  placeholder="Specialization"></asp:TextBox>
                                              <asp:TextBox ID="grade" runat="server" placeholder="Grade"></asp:TextBox>
                                         </li>
                                    </ul>
                                     <ul class="hide-input">
                                       <li>
                                            <div id="edudescription" contenteditable="true" class="long-textbox" data-placeholder="Write here"></div>
                                       </li>
                                     </ul>
                                        <ul>
                                            <li class="text-right">
                                                  <span id="add_edu" class="form-buttons" role="button">Next</span>
                                            </li>
                                       </ul>
                                </div>
                           </div>
                       </div>
                    </div>
                 </div>
             </div>
        <!-- end of adding exp -->
        <!-- edit education section -->
         <div  id="edit_edu_section" class="fixed-profile-section">
           <span class="close-profile-section fa fa-close"></span>
            <div class="fixed-profile-section-content">
             <div class="container">
                <div class="row">
                    <div class="col-md-12 col-xs-12">
                             <h3 class="profile-section-heading">
                                Edit Education
                             </h3>
                              <p id="edit_edu__rand_para" class="profile-section-tilte-para">
                              </p>
                        </div>
                   </div>
                 <div class="row">
                     <div class="col-md-5">
                       <div class="form-main edit-edu-forms">
                                <ul>
                                    <li>
                                         <asp:DropDownList ID="edit_degreetype" runat="server"  Style="border:solid;border-width:1px;border-color:lightcyan; width: 100%;height:50px">
                                            <asp:ListItem Text="Associate Degree" Value="Associate Degree"></asp:ListItem>
                                            <asp:ListItem Text="Diploma Degree" Value="Diploma Degree"></asp:ListItem>
                                            <asp:ListItem Text="Bachelor's Degree" Value="Bachelors Degree"></asp:ListItem>
                                            <asp:ListItem Text="Master's Degree" Value="Masters Degree"></asp:ListItem>
                                            <asp:ListItem Text="Doctoral Degree" Value="Doctoral Degree"></asp:ListItem>
                                            <asp:ListItem Text="Other" Value="othere"></asp:ListItem>
                                        </asp:DropDownList>    
                                     </li>
                                 </ul>
                                  <ul>
                                     <li>
                                            <asp:TextBox ID="edit_qualification" runat="server" placeholder="Degree / Course name" ></asp:TextBox>
                                   </li>
                                   </ul>
                                    <ul>
                                        <li>
                                               <asp:TextBox ID="edit_institute" runat="server" placeholder="Institute name" ></asp:TextBox>
                                        </li>
                                    </ul>
                                    <ul>
                                     <li>
                                           <asp:TextBox ID="edit_starteducation" runat="server" TextMode="Month" ></asp:TextBox>
                                           <asp:TextBox ID="edit_endeducation" runat="server" TextMode="Month"></asp:TextBox>
                                     </li>
                                    </ul>
                                    <ul>
                                         <li>
                                             <asp:TextBox ID="edit_educationspecialize" runat="server"  placeholder="Specialization"></asp:TextBox>
                                              <asp:TextBox ID="edit_grade" runat="server" placeholder="Grade"></asp:TextBox>
                                         </li>
                                    </ul>
                                     <ul>
                                       <li>
                                            <div id="edit_edudescription" contenteditable="true" class="long-textbox" data-placeholder="Write here"></div>
                                       </li>
                                     </ul>
                                        <ul>
                                            <li class="text-right">
                                                  <span id="update_education" class="form-buttons" role="button">Save Changes</span>
                                            </li>
                                       </ul>
                                </div>
                           </div>
                       </div>
                    </div>
                 </div>
             </div>
         <!-- end of edit education section -->
       <!-- end of education section forms -->

    <div class="successfull-div">
    </div>
<!-- cover video -->

    
 <div style="display:none">
        
  <!-- end of video -->
 
        <!-- section for projects -->
          <!-- loading the team for a specific project -->
         <div id="load-project-member-div" class="screen-overlay dark-cyan">
            <div class="screen-overlay-close" >
                <span class="fa fa-close"></span>
            </div>

             <div class="container">
                 <div class="row">
                      <div class="col-lg-7" >
                        <h1 id="projectname-text" style="color:white">
                       </h1>
                        </div>
                        <div class="col-lg-5">
                               <asp:TextBox  id="teammember" AutoCompleteType="None"  runat="server"  Width="100%"  Height="50px" CssClass="form-control" placeholder="Type a team member name"></asp:TextBox>
                         </div>
                         <div class="row">
                             <div class="col-lg-12">
                                 <ul id="loadteammembers" >
                                 </ul>   
                                 <div id="memberloader" class="loader"  ></div>
                             </div>
                         </div>
                       </div>
                    </div>
                 </div>
        
          <!-- en dof adding team to a project -->

    <!-- start of skill section -->
     <!-- overlay for verifying the user work experience -->
        <div id="render-team-div" class="screen-overlay dark-cyan">
            <div class="screen-overlay-close" >
                <span class="fa fa-close"></span>
            </div>

             <div class="container">
                 <div class="row">
                      <div class="col-lg-12" >
                        <h1 id="team-text" style="color:white">
                          
                       </h1>
                         <br />
                         <div class="row">
                             <div class="col-lg-12">
                                 <ul id="loadingteams">
                                 </ul>
                                 <div id="teamloader" class="loader"  ></div>
                             </div>
                         </div>
                       </div>
                    </div>
                 </div>
            </div>
    <!-- end of overlay -->

  <!-- overlay for verifying the user work experience -->
        <div id="render-verify-div" class="screen-overlay dark-cyan">
            <div class="screen-overlay-close" >
                <span class="fa fa-close"></span>
            </div>
             <div class="container">
                 <div class="row">
                      <div class="col-lg-12" >
                        <h1 id="verify-text" style="color:white">
                       </h1>
                         <br />
                         <div class="row">
                             <div class="col-lg-12">
                                 <ul id="loadingverifyuser">
                                 </ul>
                                 <div id="verifyloader" class="loader"  ></div>
                             </div>
                         </div>
                    </div>
                    </div>
                 </div>
            </div>

 <!-- end of experience section -->
        </div>


    <!-- profile sign up process if the session is not active -->
        <div id="Reg_setup" class="reg-setup-modal">
            <div class="reg-setup-dialogue">
                <div class="reg-setup-body">
                        <div class="short-profile-look text-center">
                        <img class="profile-guest-picture-render short-profile-dp" />
                         <h3 class="profile-guest-name-render short-profile-name">
                        </h3>
                        <p class="profile-guest-title-render short-profile-title">
                        </p>
                   </div>
                   <hr />
                    <h4>
                        Hey, Welcome to Jobeneur
                    </h4>
                    <h6>
                        Seems like you have not Signed In or registered. In order to view the profile you need to complete the process.
                    </h6>
                    <br />
                    <div class="signup-action-btns">
                        <span class="btn btn-primary btn-block btn-md show-signin-setup">Sign In with your account</span>
                       <span class="btn btn-danger btn-block btn-md">Create account</span>
                 </div>
              </div>
           </div>
        </div>


           <div id="signIn_setup" class="reg-setup-modal">
            <div class="reg-setup-dialogue">
                <div class="reg-setup-body">
                        <div class="short-profile-look text-center">
                        <img class="profile-guest-picture-render short-profile-dp" />
                         <h3 class="profile-guest-name-render short-profile-name">
                        </h3>
                        <p class="profile-guest-title-render short-profile-title">
                        </p>
                   </div>
                   <hr />
                    <h4>
                        Good to see you back!
                    </h4>
                    <h6>
                            Everytime you come in, we try to improve your expereicne
                   </h6>
                       <div id="login_user_form" class="sign-inputs">
                                <ul>
                                    <li>
                                        <input id="get_username" type="text" placeholder="Email / username" />
                                    </li>
                                    <li>
                                        <input id="get_password" type="password" placeholder="Password" />
                                    </li>
                                    <li class="flex-right">
                                        <span id="logging_user" class="btn btn-md btn-primary">Sign In</span>
                                    </li>
                                </ul>
                                <div style="position:absolute;bottom:20px;left:50px">
                                    <a>
                                        Not yet registered? Sign up here
                                    </a>
                                </div>
                        </div>
              </div>
           </div>
        </div>




     <!-- chat box for conversation with other people -->
          <asp:HiddenField ID="usernameuser" runat="server" /> 
          <div id="chat_box_load" class="chat-box">
         </div>
         <!-- chatbox ends here -->     


        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../../userpagescripts/suggesstions.js"></script>
        <script src="../../userpagescripts/manage_profile_theme.js"></script>
        <script src="../../userpagescripts/user_profile_load_data.js"></script>
        <script src="../../userpagescripts/manage-profile.js"></script>
        <script src="../../userpagescripts/profile-requests.js"></script>
        <script src="../../userpagescripts/profile_page_setup.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>

      </form>
    </body> 
</html>
