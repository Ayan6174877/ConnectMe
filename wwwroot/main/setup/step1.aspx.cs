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
using System.Net.Mail;
using System.Web.Services;

public partial class step1 : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();
    SqlConnection con = new SqlConnection(connStr);

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //if (Session["username"] == null || Request.QueryString["user"] == null)
            //{
            //    Response.Redirect("index.aspx");
            //}
            //else if (Session["username"] != null)
            //{
            //    username.Text = "Welcome " + Application["name"].ToString() + "!";
            //}
        }
        catch
        {
            //
        }
    }

    // checking the mobile number is userd befor or not

}