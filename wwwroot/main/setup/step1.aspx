<%@ Page Language="C#" AutoEventWireup="true" CodeFile="step1.aspx.cs" Inherits="step1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server" >
 <title>Profile Setup | Step 1</title>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
  
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
  
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
 <link href="../styling/style.css" rel="stylesheet" />
   </head>
<body >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="script1" runat="server"></asp:ScriptManager>

    <div class="setup-body">
        <div class="container">
            <div class="row">
                <div class="col-md-offset-1 col-md-10 col-xs-12">
                    <div class="block">
                      <p class="Setup-heading">
                            Welcome to Jobeneur <asp:Label ID="username" runat="server" >Ayan</asp:Label>
                     </p>
                     <p class="Setup-heading-title">
                             Let's quickly help you to set up your account
                      </p>
                      <hr />
                    <!-- form to setup the account -->
                    <div class="setup-form">
                        <div class="cover-setup">
                            <img id="cover_background" />
                            <span class="change-cover">
                                <span class="fa fa-image"></span> &nbsp; Chnage cover
                            </span>
                        </div>
                        <div class="main-profile-setup">
                               <div class="relative">
                                   <img src="../images/background-2.jpg" class="setup-dp" />
                                <span class="change-dp fa fa-camera"></span>
                             </div>
                            <br />
                            <div class="setup-form-data">
                                <ul>
                                    <li>
                                        <input id="name" type="text" readonly="true" placeholder="Ayn Bhattachrya" />
                                    </li>
                                    <li>
                                          <input id="title" type="text"  maxlength="80" placeholder="Profile Heading" />
                                    </li>
                                    <li>
                                 
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- end of form to setup the account -->


                </div>
            </div>
        </div>
    </div>  
  </div>

   <main>  
    <div class="container padding-40">
        <div class="row">
            <div class="col-md-12 text-center color-white">
                    <img class="logo-size" src="landingimages/logo-alt.png" alt="Jobeneur"> 
                  
                  
            </div>
        </div>
    </div>
   
    <div id="dob-form" class="container padding-top-40 text-left">
            <div class="row">
                <div class="col-md-6 col-md-offset-3 color-white">
                    <h4>
                        Date of Birth
                    </h4>
                    <ul class="form-input-list">
                        <li>
                            <input id="get_dob" type="date" class="white-input" />
                        </li>
                        <li class="text-right">
                           <span id="validate-dob" class="btn btn-lg btn-transparent">Next</span>
                        </li>
                    </ul>
                </div>
         </div>
  </div>        


 <div id="location-form" class="container padding-top-40 text-left">
        <div class="row">
            <div class="col-md-6 col-md-offset-3 color-white">
                <h4>
                   Current Location
                </h4>
                <ul class="form-input-list">
                    <li>
                        <input id="get_location" type="text" class="white-input" />
                    </li>
                    <li class="text-right">
                       <span id="validate-location" class="btn btn-lg btn-transparent">Next</span>
                    </li>
                </ul>
            </div>
     </div>
</div>        


<div id="dp-form" class="container padding-top-40 text-left">
        <div class="row">
            <div class="col-md-6 col-md-offset-3 color-white text-center">
                <h4>
                   Upload your profile picture
                </h4>
                    <img id="changing_picture" src="landingimages/user-dp.png" class="form-dp-size"  />
                    <input type="file" id="profilepicupload" style="display: none" />
                       <span id="upload-dp" class="btn btn-lg btn-block btn- btn-transparent">Upload & Next</span>
                    <br/>
            </div>
     </div>
</div>  

<div id="headline-form" class="container padding-top-40 text-left">
        <div class="row">
            <div class="col-md-8 col-md-offset-2 color-white">
                <h4>
                   Profile headline ( maximum 120 characters )
                </h4>
                <h6>
                Ex - UI / UX Designer - Seeking entry level opportunity
                </h6>   
                <ul class="form-input-list">
                    <li>
                        <textarea id="addprofiletitle"  type="text" maxlength="120" class="white-input" style="height: 70px;width: 100%;resize: none;overflow: hidden" ></textarea>
                    </li>
                    <li class="text-right">
                       <span id="validate-headline" class="btn btn-lg btn-transparent">Next</span>
                    </li>
                </ul>
            </div>
     </div>
</div>    


<div id="experinece-form" class="container padding-top-40 text-left">
        <div class="row">
            <div class="col-md-6 col-md-offset-3 color-white">
                <h4>
                   Are you currently working ?
                </h4>
                <ul id="experience_form" class="form-input-list">
                    <li>
                        <input id="jobrole" class="white-input" type="text"  />
                        <label class="movable-placeholder color-white">Job role / Desinition</label>
                    </li>
                    <li>
                            <input id="organization" type="text" class="white-input" />
                            <label class="movable-placeholder color-white">Employer ( company name )</label>
                    </li>
                    <li>
                            <label class="color-white">Started working</label>
                    </li>
                      <li style="margin-top: -15px">
                       <input id="expstartdate" type="date" class="white-input" />
                     </li>
                      <li>
                            <input id="joblocations" type="text" class="white-input" />
                            <label class="movable-placeholder color-white">Work Location</label>
                   </li>
                   <li>
                        <input id="industry" type="date" class="white-input" />
                        <label class="movable-placeholder color-white">Industry</label>
                   </li>
                   <li>
                        <textarea id="expdescription" type="text"  class="white-input" style="height:120px;width: 100%;resize: none;overflow: hidden" ></textarea>
                        <label class="movable-placeholder color-white">Job role description</label>
                   </li>
                    <li class="text-right">
                       <span id="skip-education" class="btn btn-lg btn-transparent">Skip</span>
                       <span id="add-education" class="btn btn-lg btn-transparent">Next</span>
                    </li>
                </ul>
            </div>
     </div>
</div>    

 </main>


  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script src="/scripting/index.js" type="text/javascript"></script>
  <script src="/scripting/signup.js" type="text/javascript"></script>
</form>
</body>
</html>
