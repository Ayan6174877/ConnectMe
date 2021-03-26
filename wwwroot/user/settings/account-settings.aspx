<%@ Page Language="C#" AutoEventWireup="true" CodeFile="account-settings.aspx.cs" Inherits="account_settings" %>

<DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Settings</title>
   <meta name="viewport" content="width=device-width, initial-scale=1" />
   <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>

<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   
  
  
    <link rel="stylesheet" type="text/css" href="styles/styles.css" />
    <link href="styles/homepage.css" rel="stylesheet" type="text/css" />
      <link href="styles/user.css" rel="stylesheet" type="text/css" />
  
    <style>
      body{
          background-color:whitesmoke;
          width:100%;
          overflow-x:hidden;
          overflow-y:auto;
      }
         .color:hover
      {
          background-color:dimgray;
          color:white;
          transition:0.6s;
      }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="updatedata" runat="server"></asp:ScriptManager>
          <nav class="navbar  navbar-fixed-top navbar-inverse " style="background-color:white;color:rgba(0,0,0,0.6);border:solid;border-width:1px;border-color:rgba(0,0,0,0.6)">
  <div class="container">
         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span> 
      </button>
       <div class="navbar-header">
              <asp:LinkButton ID="LinkButton1" runat="server"  OnClick="home_Click" CssClass="btn " title="Home"><span aria-hidden="true"><img src="images/jobeneur%20short%20logo.png" height="32" width="32" /></span></asp:LinkButton>
     </div>
      <div class="collapse navbar-collapse" id="myNavbar">
         <div class="navbar-form navbar-nav navbar-right">
               <asp:LinkButton id="logout" runat="server" OnClick="logout_Click" class="btn" style="text-decoration:none" title="Logout">Signout</asp:LinkButton>
         </div>
    </div>
</div>
         
  </nav>
         <div class="container" style="margin-top:-5px">
             <div class="row">
                 <div class="col-lg-3" style="margin-right:0;padding-right:0" >
                     <div class="panel panel-default">
                         <div class="panel-body">              
                            <table style="border-collapse:separate;border-spacing:10px;width:100%">
                             <tr>
                                 <td>
                                    <asp:Image runat="server" ID="profilepic"   class="img" width="60" height="60" style="border-radius:50%" />
                                   &nbsp; <asp:Label ID="name" runat="server" style="font-weight:500;font-size:16px;font-family:sans-serif" ></asp:Label>
                                 </td>
                             </tr>
                             </table>
                         </div>
                       </div>

                  <div class="panel panel-default" style="margin-top:-15px">
                      <div class="panel-heading" style="background-color:white">
                          <h4>
                              Settings
                          </h4>
                      </div>
                         <div class="panel-body">              
                               <table style="width:100%;border-collapse:separate;border-spacing:10px">
                           <tr>
                             <td>
                            <asp:LinkButton id="general" runat="server" OnClick="general_Click"  CssClass="btn btn-block btn-md btn-default color"  >General Settings</asp:LinkButton>
                             </td>
                         </tr>
                           <tr>
                             <td>
                                <asp:Panel ID="hideprivacy" runat="server">  
                                         <asp:LinkButton id="privacy" runat="server"   OnClick="privacy_Click"  CssClass="btn btn-block btn-default btn-md color"    >Privacy Settings</asp:LinkButton>
                            </asp:Panel>
                           </td>
                         </tr>
                           <tr>
                             <td>
                                 <asp:LinkButton id="account" runat="server"  Enabled="false"  CssClass="btn btn-block btn-md" BackColor="WhiteSmoke"  ForeColor="Black" >Account Settings</asp:LinkButton>
                             </td>
                         </tr>
                     </table>
                  </div>
                </div>
               </div>
                  <div class="col-lg-8" >
                  <div class="panel panel-default">
                      <div class="panel-heading" style="background-color:white">
                          <h3>
                              Account
                          </h3>
                          <h5>
                              Change your basic account settings
                          </h5>
                      </div>
                      <div class="panel-body">
                        <asp:Panel ID="success" runat="server" Visible="false" style="padding:10px" CssClass="bg-success" >
                            <asp:Label  ID="successmessage" runat="server" Text="We have successfully received your feedback. Thank you for your support" style="font-size:16px;font-weight:500;font-family:HelvLight"></asp:Label>
                        </asp:Panel>
                <div align="left">
             <!-- options for changing the General settings like name and all -->
           <!-- feedback -->
            <div class="row">
                <div class="col-lg-12">
                       <div class="panel-body">   
                              <h5 style="color:grey;font-size:14px;line-height:1.6em">
                                     We are always trying our best to improve our services so that we can always serve you in a better way. Your feedback will always help us to improve as a better service. So always feel free to reach out to us or give us your feedback. If we find it really necessary so we may contact you for more details.
                             </h5>
                                  <asp:TextBox ID="feedback"  TextMode="MultiLine" Height="150px" runat="server" Placeholder="Give us feedback" CssClass="form-control" style="transition:0.8s;background-color:transparent;border-top:none;outline:none"></asp:TextBox>
                                 <br />
                                    <div align="right">
                                        <asp:Button ID="givefeedback" style="display:none" OnClick="givefeedback_Click" runat="server" Text="Give Feedback" CssClass="btn btn-md btn-success" />
                                    </div>
                                 
                               </div> </div>
                               </div>
                </div>
            </div>

                










                        </div>
                     </div>
               </div>
       
                   
                   
                 </div>
             </div>
       
             <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
          <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
     
           <script src="scripts/settings.js"></script>           
   </form>
</body>
</html>
