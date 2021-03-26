<%@ Page Language="C#" AutoEventWireup="true" CodeFile="feed.aspx.cs" Inherits="user_feed" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home - Feed</title>
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
      <!-- icons -->
    <script defer src="https://friconix.com/cdn/friconix.js"> </script>
  

    <!-- page styles -->
    <link href="styles/style.css" rel="stylesheet" />
    <link href="styles/fonts.css" rel="stylesheet" />
    <link href="styles/color.css" rel="stylesheet" />
    <link href="styles/newsfeed.css" rel="stylesheet" />
  
</head>
<body>
    <form id="form1" runat="server">

        <!-- left navbar -->
              <div class="left-navbar">
                <div class="left-navbar-top-icons">
                                <ul>
                                    <li>
                                        <i class="fi-xnluxl-plus"></i>
                                        <span class="navbar-tooltip" >Share</span>
                                    </li>
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
                <div class="main-content">
                   <div class="row">
                        <div class="col-md-12">
                                <!-- main containers for all the components -->
                                <div class="main-container">
                                 <div class="container-fluid">
                                    <div class="row">
                                     <div class="col-md-3">
                                            <div class="newsfeed-user-panel">
                                                <img class="profile-picture-render" />
                                                <h4 class="profile-name-render"></h4>
                                                <p class="profile-title-render"></p>
                                                <hr>
                                                <div class="mewsfeed-counts">
                                                    <ul>
                                                        <li>
                                                            <p class="heading">Streams</p>
                                                            <p class="count">1,450</p>
                                                        </li>
                                                        <li>
                                                            <p class="heading">following</p>
                                                            <p class="count">1,4 K</p>
                                                        </li>
                                                        <li>
                                                            <p class="heading">Followers</p>
                                                            <p class="count">7,769,58</p>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <br>
                                         <div class="recommendation-panel">
                                                <div class="recommendation-panel-heading">
                                                    Want to follow
                                                </div>
                                               <div class="recommendation-panel-body">
                                                  <div id="load_people_suggestions" class="load-connection-suggestion">
                                                  </div>
                                               </div>
                                         </div>   
                                        </div>
                                        <div class="col-md-5">
                                            <div class="row">
                                                <div class="col-md-12">
                                                  <div class="no-posts">  
                                                    <p class="no-post-heading">
                                                        It's quite empty over here
                                                    </p>
                                                    <p class="no-post-para">
                                                       Start following people and communities that your are most 
                                                       interested in and we will collect all the streams for you and show it down here.
                                                    </p><br/><br/>
                                                    <div class="quick-post-action">
                                                        <i class="fi-xtluxl-plus-thin share-post" ></i>
                                                        <i class="fi-xtluxl-edit-thin share-text" role="button"  ></i>
                                                        <i class="fi-xtluxl-camera-thin" role="button" onclick="$('#fileupload1').click();return false;" ></i>
                                                    </div>
                                                  </div>
                                              </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div id="loadposts" class="loading-post grid"></div>
                                                      <!-- end of post panel -->  
                                                   <div id="postloader" class="load-post-loader text-center">
                                                   </div>
                                                </div>
                                            </div>
                                        </div>
                                      <div class="col-md-3">
                                        <div class="recommendation-panel">
                                            <div class="recommendation-panel-heading">
                                                Trending communities
                                            </div>
                                     </div>   
                                      </div>
                                </div>  
                        </div>
                    </div>
                   </div>
                </div>
              </div>
            </div>
        </div>
    </div>
  </div>


       <!-- hidden field to load post data to match few parameters -->
        <asp:HiddenField ID="usertype" runat="server" />
        <asp:HiddenField ID="username" runat="server" />
        <asp:HiddenField ID="companyusername" runat="server" />
        <asp:Image ID="profilepic" runat="server"  style="display:none"/>

  <!-- post renders hers-->
        
<!-- post share overlay -->
     <div id="Image_stream_overlay" class="post-share-overlay" >  
            <div class="post-share-panel">
                <div class="post-share-top-header">
                    <h5>
                        What's on your mind
                    </h5>
                    <span id="close_image_overlay" class="fa fa-close close-share-post"></span>
                   <span id="sharedImagepost" class="btn btn-md btn-primary share-post-btn disable-btn">Share</span>
                </div>
                 <div class="post-share-header">
                            <img class="profile-picture-render" />
                            <ul>
                                <li class="profile-name-render">
                                </li>
                                <li class="profile-title-render">
                                </li>
                                <li>
                                    <div class="post-privacy">
                                        <span id="privateprivacy" class="public-post" title="Anyone can see this">Public</span>
                                        <span id="publicprivacy" class="private-post active-profile-privacy" title="Only you and people been tagged can see this">Private</span>
                                    </div>
                                </li>
                            </ul>    
                      </div> 
                    <div class="post-main-share-body">
                       <div class="post-share-body-text">
                            <div id="PostInput" contenteditable="true" onkeyup="saveSelection();" onfocus="restoreSelection();"  class="image-caption-input" ></div>
                       </div>
                      <div class="post-share-body-image">
                            <img id="postimagecontent"  />
                            <asp:FileUpload ID="fileupload1" Visible="true" Style="width: 0px; height: 0px; display: none" runat="server" />
                     </div>
                    </div>
                       <div class="post-share-footer">
                           <div class="post-share-more-options">
                               <span class="fa fa-image" title="Add Image" onclick="$('#fileupload1').click();return false;"></span>
                               <span class="fa fa-eercast" title="Choose a community"></span>
                           </div>
                            <div class="post-counter">
                                <span id="ImageCaptionCounter" class="counter-increment">240 </span>
                            </div>
                         </div>
                    </div>
                </div>
        <!-- post share overlay end -->

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

<!-- loading people comments -->

     <div id="loading_comments_modal" class="post-modal-data">
        <div class="post-modal-dialogue modal-md">
            <div class="post-modal-header">
                <span class="fa fa-close fa-close-reaction-modal"></span>
                <p id="total_comments">
                    0 comments </p>
                </div>
               <div id="load_comment_user" class="post-modal-body load-comment-users" >
                  <div class="no-comment-overlay">
                        <span class="fa fa-comments-o"></span>
                        <br />
                        <h4>
                            Be the first to comment
                        </h4>
                    </div>
                   <div class="loading-comment-overlay">
                   </div>
              </div>
             <div class="post-modal-comment-footer" >
                 <div class="overlay-comment">
                    <img id="overlay_profilepic" class="profile-picture-render"  alt="none" />
                    <div id="overlay_comment_input" contenteditable="true" class="comment-input overlay-comment-input"></div>
                    <span class="fa fa-filter overlay-comment-btn disable-btn" ></span>
                </div>
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
          <!-- post ends hers -->
    
   
    </div>  

        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="../userpagescripts/jquery.linky.js"></script>
         <script src="../userpagescripts/jquery.linky.min.js"></script>
        <script src="../../userpagescripts/navbar.js"></script>
        <script src="../../userpagescripts/suggesstions.js"></script>
        <script src="../../userpagescripts/shareposts.js"></script>
        <script src="../../userpagescripts/newsfeedposts.js"></script>
        <script src="../../userpagescripts/postactions.js"></script>
    </form>
    
</body>
</html>
