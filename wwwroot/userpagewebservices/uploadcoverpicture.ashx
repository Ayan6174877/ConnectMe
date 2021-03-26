<%@ WebHandler Language="C#" Class="uploadcoverpicture" %>

using System;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
  using System.Configuration;
 using System.Web.SessionState;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Web.Services;


public class uploadcoverpicture : IHttpHandler, System.Web.SessionState.IRequiresSessionState {
    
   public void ProcessRequest(HttpContext context)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        
        //Check if Request is to Upload the File.
        if (context.Request.Files.Count > 0)
        {
            //Fetch the Uploaded File.
              HttpPostedFile postedFile = context.Request.Files[0];
           
              Stream stream = postedFile.InputStream;
              BinaryReader binaryreader = new BinaryReader(stream);
              byte[] bytes = binaryreader.ReadBytes((int)stream.Length);

              using (SqlConnection con = new SqlConnection(cs))
                {
                    string str1 = ("update [dbo].[userdata123] set coverpic = @coverpic  where username = '" +  context.Session["username"] + "'  ");
                    SqlCommand cm = new SqlCommand(str1, con);
                    cm.Parameters.AddWithValue("@coverpic", bytes );
                    con.Open();
                    cm.ExecuteNonQuery();
                    con.Close();
                }

        }
    }
 
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}