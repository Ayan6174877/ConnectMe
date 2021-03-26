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

public partial class user_streams : System.Web.UI.Page
{
    public static string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();
    SqlConnection con = new SqlConnection(connStr);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null)
        {
            Response.Redirect("../jobeneur/index.html");
        }
        else if (Session["username"] != null)
        {
            usertype.Value = Session["usertype"].ToString();
            username.Value = Session["username"].ToString();
            postid.Value = Request.QueryString["id"];
            getcompanydetails();
            getprofileimage();
        }
    }

    private void getprofileimage()
    {
        string str1 = ("select profilepic from [dbo].[userdata123] where username = '" + Session["username"] + "'");
        SqlCommand com1 = new SqlCommand(str1, con);
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
            profilepic.ImageUrl = null;
        }

        con.Close();
    }



    private void getcompanydetails()
    {

        string str = ("select top 1 userdata123.username,userdata123.name,experience.posttitle from [dbo].[userdata123] inner join [dbo].[experience] ON userdata123.name = experience.companyname  where (experience.username ='" + Session["username"] + "' and experience.enddate = '" + "currently working" + "' and experience.verified = 'verified' )  ");
        SqlCommand com = new SqlCommand(str, con);
        con.Close();
        con.Open();
        SqlDataReader reader = com.ExecuteReader();
        if (!reader.HasRows)
        {
            companyusername.Value = "";
        }
        else
        {
            while (reader.Read())
            {
                companyusername.Value = reader["username"].ToString();
            }

        }
        con.Close();
    }
}