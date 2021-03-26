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

public partial class blocking : System.Web.UI.Page
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
              
            }
        }
    }
   
  
    protected void logout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("index.aspx");
    }

}
