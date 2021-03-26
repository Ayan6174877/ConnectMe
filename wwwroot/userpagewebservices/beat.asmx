<%@ WebService Language="C#" CodeBehind="~/App_Code/userposts.cs" Class="beat" %>

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.ComponentModel;

[WebService(Namespace = "https://www.jobeneur.com")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class beat : System.Web.Services.WebService
{

    // getting the top news for the stories feed on the user side
    [WebMethod(enableSession:true)]
    public void loadslidernews()
    {
        List<userposts> postdata = new List<userposts>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            //  SqlCommand cmd = new SqlCommand("select top 5 id,highlightimage,highlightitle,description,navigateurl,count,postedtime from highlights  where username = '"+ Session["username"] +"' order by newid() ", con);
            SqlCommand cmd = new SqlCommand("select top 5 highlights.id,highlights.highlightimage,highlights.highlightitle,highlights.description,highlights.navigateurl,highlights.count,highlights.postedtime,userdata123.profilepic from highlights INNER JOIN userdata123 ON userdata123.username = highlights.username left outer join follow ON userdata123.username = follow.following where ( follow.followedby  = '"+ Session["username"] +"'  )order by newid() ", con);
            con.Open();
            SqlDataReader rdrnews = cmd.ExecuteReader();
            if (rdrnews.HasRows)
            {
                while (rdrnews.Read())
                {
                    userposts data = new userposts();
                    object profilepicture = rdrnews["profilepic"];
                    if (profilepicture != DBNull.Value)
                    {
                        byte[] bytes = (byte[])profilepicture;
                        string logo = Convert.ToBase64String(bytes);
                        data.profilepic = logo;
                    }
                    else
                    {
                       data.profilepic = null;
                    }
                    data.postid = Convert.ToInt32(rdrnews["id"]);
                    data.newstitle = rdrnews["highlightitle"].ToString();
                    data.newslink = rdrnews["navigateurl"].ToString();
                    data.postdescription = rdrnews["description"].ToString().Replace("\r\n", "<br>");;
                    data.count = rdrnews["count"].ToString() + " views";
                    object obj = rdrnews["highlightimage"];
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        data.newsimage = logo;
                    }
                    else
                    {
                        data.newsimage = null;
                    }

                    postdata.Add(data);
                }

            }

        }
        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(postdata));
    }


    // getting the top news for the stories feed
    [WebMethod(enableSession:true)]
    public void loadmorenews()
    {
        List<userposts> postdata = new List<userposts>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select distinct highlights.id,highlights.highlightimage,highlights.highlightitle,highlights.description,highlights.navigateurl,highlights.count,highlights.postedtime,userdata123.profilepic from highlights INNER JOIN userdata123 ON userdata123.username = highlights.username left outer join follow ON userdata123.username = follow.following where ( follow.followedby  = '"+ Session["username"] +"'  ) order by highlights.postedtime desc ", con);
            con.Open();
            SqlDataReader rdrnews = cmd.ExecuteReader();
            if (rdrnews.HasRows)
            {
                while (rdrnews.Read())
                {
                    userposts data = new userposts();
                    object profilepicture = rdrnews["profilepic"];
                    if (profilepicture != DBNull.Value)
                    {
                        byte[] bytes = (byte[])profilepicture;
                        string logo = Convert.ToBase64String(bytes);
                        data.profilepic = logo;
                    }
                    else
                    {
                       data.profilepic = null;
                    }
                    data.newstitle = rdrnews["highlightitle"].ToString();
                    data.newslink = rdrnews["navigateurl"].ToString();
                    data.postdescription = rdrnews["description"].ToString().Replace("\r\n", "<br>");
                    data.count = rdrnews["count"].ToString() + " views";
                    data.postid = Convert.ToInt32(rdrnews["id"]);
                    object obj = rdrnews["highlightimage"];
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        data.newsimage = logo;
                    }
                    else
                    {
                        data.newsimage = null;
                    }

                    postdata.Add(data);
                }

            }

        }
        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(postdata));
    }

    // deleting the company highlights
    [WebMethod(enableSession:true)]
    public void updatviewcount(string id)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[highlights] set count = count + 1 where id = '" + id + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
     
    }
}
