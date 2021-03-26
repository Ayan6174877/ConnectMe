<%@ WebHandler Language="C#"  Class="shareimagepost" %>

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


public class shareimagepost : IHttpHandler, System.Web.SessionState.IRequiresSessionState {

    public void ProcessRequest(HttpContext context)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        //try
        //{

        //Check if Request is to Upload the File.
        if (context.Request.Files.Count > 0)
        {
            userposts data = new userposts();
            ////Fetch the Uploaded File.

            HttpPostedFile postedFile = context.Request.Files["imagefile"];
            string taggedusername =  context.Request.Form["tag"].ToString();
            string postdescription = context.Request.Form["activitypostdata"].Replace("\n/g" , "<br />").ToString();
            string postprivacy = context.Request.Form["privacytype"].ToString();

            Stream stream = postedFile.InputStream;
            BinaryReader binaryreader = new BinaryReader(stream);
            byte[] bytes = binaryreader.ReadBytes((int)stream.Length);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd1 = new SqlCommand("sharepost", con);
                cmd1.CommandType = CommandType.StoredProcedure;

                SqlParameter category1 = new SqlParameter()
                {
                    ParameterName = "@category",
                    Value = HttpContext.Current.Session["usertype"]

                };
                cmd1.Parameters.Add(category1);

                SqlParameter Cusername = new SqlParameter()
                {
                    ParameterName = "@username",
                    Value = HttpContext.Current.Session["username"]
                };
                cmd1.Parameters.Add(Cusername);

                SqlParameter postdata = new SqlParameter()
                {
                    ParameterName = "@postdescription",
                    Value =  postdescription
                };
                cmd1.Parameters.Add(postdata);

                SqlParameter images = new SqlParameter()
                {
                    ParameterName = "@postimage",
                    Value = bytes

                };
                cmd1.Parameters.Add(images);

                SqlParameter type = new SqlParameter()
                {
                    ParameterName = "@type",
                    Value = postprivacy
                };
                cmd1.Parameters.Add(type);

                cmd1.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output;

                con.Open();
                cmd1.ExecuteNonQuery();

                // getting the current inserted post id  and sharing with the people with whom the post has been shared
                string id = cmd1.Parameters["@id"].Value.ToString();

                // inserting the value into the activity table for the newsfeed
                SqlCommand insertactivity = new SqlCommand("insert into newsfeedactivity (activityby,sourceid,activitytype) values ('" + HttpContext.Current.Session["username"] + "','" + Convert.ToInt32(id) + "', 'post')", con);
                insertactivity.ExecuteNonQuery();


                if (taggedusername != "")
                {
                    string tagpeopleusername1 = taggedusername.Replace(" ", string.Empty);
                    string[] arryval = tagpeopleusername1.Split(',');//split values with ‘,’  
                    int j = arryval.Length - 1;
                    int i = 0;
                    for (i = 0; i < j; i++)
                    {
                        SqlCommand cmd = new SqlCommand("insert into sharedposts (postid,sharedby,sharedstatus) values ('" + id + "','" + arryval[i] + "', 'shared')", con);
                        cmd.ExecuteNonQuery();

                        SqlCommand insernoti = new SqlCommand("insert into [dbo].[notifications](notificationby,notificationfor,postid,type) values ('" + HttpContext.Current.Session["username"] + "','" + arryval[i] + "','" + id + "', '" + "mentioned" + "')", con);
                        insernoti.ExecuteNonQuery();
                    }
                }
                else
                {

                }
            }
        }
        // }
        //catch
        //{

        //}
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}