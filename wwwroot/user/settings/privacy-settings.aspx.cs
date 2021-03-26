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

public partial class privacy_settings : System.Web.UI.Page
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
                if (Session["usertype"].ToString() == "company")
                {
                    Response.Redirect("~/pagenotfound.aspx");
                }
			  string str = ("select userdata123.name,posts,friends,activities,messages,profile from [dbo].[privacy] full outer JOIN [dbo].[userdata123] on userdata123.username = privacy.username  where userdata123.username ='" + Session["username"].ToString() + "'");
                SqlCommand com = new SqlCommand(str, con);
                try
                {
                    con.Open();
                    SqlDataReader reader = com.ExecuteReader();
                    while (reader.Read())
                    {
                        name.Text = reader["name"].ToString();
                        //profile.SelectedValue = reader["profile"].ToString();
                        //profiletype.Text = reader["profile"].ToString();
                        posts.SelectedValue = reader["posts"].ToString();
                        friends.SelectedValue = reader["friends"].ToString();
                        message.SelectedValue = reader["messages"].ToString();
                        activities.SelectedValue = reader["activities"].ToString();
                        profiles.SelectedValue = reader["profile"].ToString();
                    }
                    reader.Close();
                }
                catch { }
            }
        }
    }
   
    
    protected void logout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("index.aspx");
    }

  

  
}

