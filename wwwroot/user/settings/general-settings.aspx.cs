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

public partial class privacy_settings : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();
    SqlConnection con = new SqlConnection(connStr);
    public string password;
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
               con.Open();
            
                    string str = ("select userdata123.username,userdata123.name,userdata123.password,userdata123.email,userdata.location,userdata.mobile from [dbo].[userdata123] full outer JOIN [dbo].[userdata]  on userdata123.username = userdata.username full outer join about ON about.username = userdata123.username where userdata123.username='" + Session["username"].ToString() + "'");
                    SqlCommand com = new SqlCommand(str, con);
                    SqlDataReader reader = com.ExecuteReader();
                    while (reader.Read())
                        {
                    
                            change_username.Text = reader["username"].ToString();
                            change_name.Text = reader["name"].ToString();
                            change_email.Text = reader["email"].ToString();
                            change_location.Text = reader["location"].ToString();
                            change_mobile.Text =  reader["mobile"].ToString();
                          //  pass.Value = reader["password"].ToString();
                        }
                        reader.Close();
                
                con.Close();

            }
        }
    }
   
  
    protected void logout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("index.aspx");
    }

}
