using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.IO;
using System.Web.Services;

public partial class user_profile_profile : System.Web.UI.Page
{
    public static string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();
    SqlConnection con = new SqlConnection(connStr);

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            if (Request.QueryString["id"] == null || Request.QueryString["id"] == "")
            {
                // login or sign up option the user
                Response.Redirect("../../jobeneur/index.html");
            }
            else if (Session["username"] == null && (Request.QueryString["id"] == "" || Request.QueryString["id"] == null))
            {
                IsSessionActive.Value = "false";
                requestUser.Value = Request.QueryString["id"].ToString();
                IsSessionEqualsRequest.Value = "false";
            }
            else if (Session["username"] == null && (Request.QueryString["id"] != "" || Request.QueryString["id"] != null))
            {
                IsSessionActive.Value = "false";
                requestUser.Value = Request.QueryString["id"].ToString();
                IsSessionEqualsRequest.Value = "false";
            }
            else
            {
                if (Session["username"].ToString() == Request.QueryString["id"].ToString())
                {
                    IsSessionActive.Value = "true";
                    requestUser.Value = Request.QueryString["id"].ToString();
                    IsSessionEqualsRequest.Value = "true";
                    getprofiledetails();
                }
                else
                {
                    IsSessionActive.Value = "true";
                    requestUser.Value = Request.QueryString["id"].ToString();
                    sessionuser.Value = Session["username"].ToString();
                    IsSessionEqualsRequest.Value = "false";
                    getprofiledetails();
                }
            }
        }
    }

    protected void getprofiledetails()
    {
        string str = ("select userdata123.name,userdata.location,userdata.profiletitle,userdata.dob,userdata.mobile,privacy.friends,privacy.messages from [dbo].[userdata123] INNER JOIN [dbo].[userdata] ON userdata123.username = userdata.username INNER JOIN [dbo].[privacy] ON privacy.username = userdata123.username  where userdata123.username='" + Request.QueryString["id"] + "'  ");
        SqlCommand com = new SqlCommand(str, con);
        try
        {
            con.Open();
            SqlDataReader reader = com.ExecuteReader();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    this.Title = reader["name"].ToString() + "'s Profile";
                    locations.InnerText = reader["location"].ToString();

                    // location
                    if (locations.InnerText == "")
                    {
                        if (Session["username"].ToString() == Request.QueryString["id"].ToString())
                        {
                            locations.InnerText = "Add your current location";
                        }
                        else
                        {
                          locations.InnerText = "Not specified";
                    }
                    }
                    else
                    {
                        //
                    }

                    // date of birth
                    dob.InnerText = reader["dob"].ToString();
                    if (dob.InnerText == "")
                    {
                        if (Session["username"].ToString() == Request.QueryString["id"].ToString())
                        {
                          dob.InnerText = "Add your birthday";
                        }
                        else
                        {
                            dob.InnerText = "Not specified";
                         }
                    }
                    else
                    {
                        String sDate = dob.InnerText;
                        string[] Words = sDate.Split(new char[] { '-' });
                        string month = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Convert.ToInt32(Words[1]));
                        foreach (string Word in Words)
                        {
                            dob.InnerText = Words[2].ToString() + "th of " + month;
                            // + " " + Words[0].ToString()
                        }
                    }

                    // mobile number
                    //mobile.Text = reader["mobile"].ToString();
                    //if (mobile.Text == "")
                    //{
                    //    mobile.Text = "Add your mobile number";
                    //}
                    //else
                    //{
                    //    mobile.Visible = true;
                    //}

                    // email
                    //email.InnerText = reader["email"].ToString();
                    messageprivacy.Value = reader["messages"].ToString();
                    networkprivacy.Value = reader["friends"].ToString();

                }
            }
    }
        catch
        { }
        finally
        {
            con.Close();
        }
    }
}
