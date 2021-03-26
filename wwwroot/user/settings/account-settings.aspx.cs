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

public partial class account_settings : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();
    SqlConnection con = new SqlConnection(connStr);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["username"] == null)
            {
                Response.Redirect("~/index.aspx");
            }
            else if (Session["username"] != null)
            {
                if(Session["usertype"].ToString() == "company")
                {
                    hideprivacy.Visible = false;
                    profilepic.Style.Add("border-radius", "0%");

                }
                string str = ("select name from userdata123 where username ='" + Session["username"].ToString() + "'");
                SqlCommand com = new SqlCommand(str, con);
                try
                {
                    con.Open();
                    SqlDataReader reader = com.ExecuteReader();
                    while (reader.Read())
                    {
                        name.Text = reader["name"].ToString();
                        reader.Close();
                    }
                }
                catch { }
                getprofileimage();
               
            }
        }
    }

    private void getprofileimage()
    {
        string str1 = ("select profilepic from [dbo].[userdata123] where username = '" + Session["username"] + "'");
        SqlCommand com1 = new SqlCommand(str1, con);
        try
        {
            con.Close();
            con.Open();
            object obj = com1.ExecuteScalar();
            if (obj != DBNull.Value)
            {
                byte[] bytes = (byte[])obj;
                string logo = Convert.ToBase64String(bytes);
                profilepic.ImageUrl = "data:Image/png;base64," + logo;
            }
            else
            {
               profilepic.ImageUrl = "~/images/user.png";

            }

            con.Close();
        }
        catch
        { }
    }


    protected void home_Click(object sender, EventArgs e)
    {
        if (Session["usertype"].ToString() == "user")
        {
            Response.Redirect("~/user.aspx");
        }
        else
        {
            Response.Redirect("~/Company-page.aspx");
        }
    }

    protected void logout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("index.aspx");
    }

    protected void givefeedback_Click(object sender, EventArgs e)
    {
        SqlCommand cmd = new SqlCommand("insert into userfeedback (feedbackby,feedback) values ('"+ Session["username"] +"','" + feedback.Text.Replace("\r\n",Environment.NewLine).Trim() +"')", con);
        try
        {
            con.Close();
            con.Open();
            cmd.ExecuteNonQuery();
            feedback.Text = "";
            success.Visible = true;
         }
        catch
        {
            feedback.Text = "";
            success.Visible = true;
        }
        con.Close();
    }

    protected void privacy_Click(object sender, EventArgs e)
    {
       Response.Redirect("~/privacy-settings.aspx");
    }
    protected void general_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/general-settings.aspx");
    }

  
}