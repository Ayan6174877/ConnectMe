<%@ WebService Language="C#" CodeBehind="~/App_Code/userposts.cs" Class="userloadingnotifications" %>

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
public class userloadingnotifications : System.Web.Services.WebService
{
    // getting the top news for the stories feed
    [WebMethod(enableSession:true)]
    public void loadnotification()
    {
        List<notification> rendernotification = new List<notification>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select notifications.postid,notifications.type,MAX(notifications.id) as id from notifications where ( notifications.notificationfor = '" + Session["username"] + "' and notifications.notificationby != '" + Session["username"] + "' ) group by notifications.Postid,notifications.type order by id desc ");
            SqlCommand cmd = new SqlCommand(str1, con);
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.HasRows)
            {
                while (rdr.Read())
                {
                    notification data = new notification();
                    data.postid = rdr["postid"].ToString();
                    data.notitype = rdr["type"].ToString();
                    data.notiid = rdr["id"].ToString();

                    // if notification type is a like
                    if (data.notitype == "like")
                    {
                        // loading the postid to the link so that the user can be redirected once click on the notification
                        data.notificationnavigateurl = "/post.aspx?Id=" + data.postid;

                        // counting how many likes the user has got on this post
                        SqlCommand countlikes = new SqlCommand("select count(id) as total from [dbo].[notifications] where ( notifications.notificationfor = '" + Session["username"] + "' and postid = " + data.postid + " and type = 'like' ) ", con);
                        data.count = countlikes.ExecuteScalar().ToString();

                        // checking how much like has a user has got and then loading the other data on the basis of that
                        // checking how much like has a user has got and then loading the other data on the basis of that
                        if (data.count != "0")
                        {
                            String str = ("select  distinct top 4 postlikes.likeid,userdata123.name from [dbo].[postlikes] INNER JOIN [dbo].[userdata123] ON userdata123.username = postlikes.likedby where ( postlikes.postid = '" + data.postid + "' and  postlikes.likedby != '" + Session["username"] + "' )  order by postlikes.likeid desc ");
                            SqlCommand com = new SqlCommand(str, con);
                            SqlDataReader reader = com.ExecuteReader();
                            if (reader.HasRows)
                            {
                                while (reader.Read())
                                {
                                    data.name += "<span class=nameuser>" + reader["name"].ToString() + "</span> ";
                                }
                            }
                        }
                        else
                        {

                        }

                        // getting the notification id and flag and notification time

                        String strnotification = ("select top 1 notificationtime,flag from [dbo].[notifications] where ( id = '" + data.notiid + "' ) ");
                        SqlCommand notismc = new SqlCommand(strnotification, con);
                        SqlDataReader notireader = notismc.ExecuteReader();
                        if (notireader.HasRows)
                        {
                            while (notireader.Read())
                            {
                                data.time = notireader["notificationtime"].ToString();
                                data.flag = notireader["flag"].ToString();
                            }
                        }
                        else
                        {
                            //
                        }


                    }
                    // end of like if
                    // if notification type is a comment
                    else if (data.notitype == "comment")
                    {
                        // loading the postid to the link so that the user can be redirected once click on the notification
                        data.notificationnavigateurl = "/post.aspx?Id=" + data.postid;

                        // counting how many likes the user has got on this post
                        SqlCommand countcomments = new SqlCommand("select distinct count(commentedby) as total from [dbo].[postcomments] where ( postcomments.commentedby != '" + Session["username"] + "' and postid = " + data.postid + " ) ", con);
                        data.count = countcomments.ExecuteScalar().ToString();

                        // checking how much like has a user has got and then loading the other data on the basis of that
                        // checking how much like has a user has got and then loading the other data on the basis of that
                        if (data.count != "0")
                        {
                            String str = ("select distinct top 4 postcomments.commentid,userdata123.name from [dbo].[postcomments] INNER JOIN [dbo].[userdata123] ON userdata123.username = postcomments.commentedby where ( postcomments.postid = '" + data.postid + "' and  postcomments.commentedby != '" + Session["username"] + "' ) order by postcomments.commentid desc  ");
                            SqlCommand com = new SqlCommand(str, con);
                            SqlDataReader reader = com.ExecuteReader();
                            if (reader.HasRows)
                            {
                                while (reader.Read())
                                {
                                    data.name += "<span class=nameuser>" + reader["name"].ToString() + "</span> ";
                                }
                            }
                        }
                        else
                        {

                        }

                        // getting the notification id and flag and notification time


                        String strnotification = ("select notificationtime,flag from [dbo].[notifications] where ( id = '" + data.notiid + "' ) ");
                        SqlCommand notismc = new SqlCommand(strnotification, con);
                        SqlDataReader notireader = notismc.ExecuteReader();
                        if (notireader.HasRows)
                        {
                            while (notireader.Read())
                            {
                                data.time = notireader["notificationtime"].ToString();
                                data.flag = notireader["flag"].ToString();
                            }
                        }
                        else
                        {
                            //
                        }

                    }

                    else if (data.notitype == "mentioned")
                    {
                        data.notificationnavigateurl = "/post.aspx?Id=" + data.postid;

                        String str = ("select userdata123.name from [dbo].[notifications] INNER JOIN [dbo].[userdata123] ON userdata123.username = notifications.notificationby where ( notifications.postid = '" + data.postid + "'  )  ");
                        SqlCommand com = new SqlCommand(str, con);
                        SqlDataReader reader = com.ExecuteReader();
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                data.name += "<b>" + reader["name"].ToString() + " mentioned </b>  you in a post";
                            }
                        }

                        else
                        {

                        }


                        String strnotification = ("select notificationtime,flag from [dbo].[notifications] where ( id = '" + data.notiid + "' ) ");
                        SqlCommand notismc = new SqlCommand(strnotification, con);
                        SqlDataReader notireader = notismc.ExecuteReader();
                        if (notireader.HasRows)
                        {
                            while (notireader.Read())
                            {
                                data.time = notireader["notificationtime"].ToString();
                                data.flag = notireader["flag"].ToString();
                            }
                        }
                        else
                        {
                            //
                        }

                    }

                    else if (data.notitype == "visitors")
                    {
                        data.notificationnavigateurl = "/profileviews.aspx";

                        SqlCommand countcomments = new SqlCommand("select distinct count(id) as total from [dbo].[profileviews] where ( profile = '" + Session["username"] + "' ) ", con);
                        data.count = countcomments.ExecuteScalar().ToString();

                        // checking how much like has a user has got and then loading the other data on the basis of that
                        // checking how much like has a user has got and then loading the other data on the basis of that
                        if (data.count != "0")
                        {
                            String str = ("select distinct top 4 profileviews.id,userdata123.name from [dbo].[profileviews] full outer JOIN [dbo].[userdata123] ON userdata123.username = profileviews.viewedby where (  profileviews.profile  = '" + Session["username"] + "' ) order by profileviews.id desc  ");
                            SqlCommand com = new SqlCommand(str, con);
                            SqlDataReader reader = com.ExecuteReader();
                            if (reader.HasRows)
                            {
                                while (reader.Read())
                                {
                                    data.name += "<span class=nameuser>" + reader["name"].ToString() + "</span> ";
                                }
                            }
                        }
                        else
                        {

                        }


                        String strnotification = ("select notificationtime,flag from [dbo].[notifications] where ( id = '" + data.notiid + "' ) ");
                        SqlCommand notismc = new SqlCommand(strnotification, con);
                        SqlDataReader notireader = notismc.ExecuteReader();
                        if (notireader.HasRows)
                        {
                            while (notireader.Read())
                            {
                                data.time = notireader["notificationtime"].ToString();
                                data.flag = notireader["flag"].ToString();
                            }
                        }
                        else
                        {
                            //
                        }

                    }

                    else if (data.notitype == "shared profile")
                    {
                        data.notificationnavigateurl = "/sharedprofiles.aspx";

                        SqlCommand countcomments = new SqlCommand("select distinct count(id) as total from [dbo].[sharedprofile] where ( sharedto = '" + Session["username"] + "' ) ", con);
                        data.count = countcomments.ExecuteScalar().ToString();

                        // checking how much like has a user has got and then loading the other data on the basis of that
                        // checking how much like has a user has got and then loading the other data on the basis of that
                        if (data.count != "0")
                        {
                            String str = ("select distinct top 4 userdata123.name from [dbo].[sharedprofile] full outer JOIN [dbo].[userdata123] ON userdata123.username = sharedprofile.shareby where ( sharedprofile.sharedto  = '" + Session["username"] + "' )   ");
                            SqlCommand com = new SqlCommand(str, con);
                            SqlDataReader reader = com.ExecuteReader();
                            if (reader.HasRows)
                            {
                                while (reader.Read())
                                {
                                    data.name += "<span class=nameuser>" + reader["name"].ToString() + "</span> ";
                                }
                            }
                        }
                        else
                        {

                        }


                        String strnotification = ("select notificationtime,flag from [dbo].[notifications] where ( id = '" + data.notiid + "' ) ");
                        SqlCommand notismc = new SqlCommand(strnotification, con);
                        SqlDataReader notireader = notismc.ExecuteReader();
                        if (notireader.HasRows)
                        {
                            while (notireader.Read())
                            {
                                data.time = notireader["notificationtime"].ToString();
                                data.flag = notireader["flag"].ToString();
                            }
                        }
                        else
                        {
                            //
                        }

                    }


                    else if (data.notitype == "following")
                    {

                        String str = ("select userdata123.name,userdata123.username,userdata.profiletitle from [dbo].[notifications] INNER JOIN [dbo].[userdata123] ON userdata123.username = notifications.notificationby full outer join userdata ON userdata.username = userdata123.username where ( userdata123.username = '" + data.postid + "'  )  ");
                        SqlCommand com = new SqlCommand(str, con);
                        SqlDataReader reader = com.ExecuteReader();
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                if (reader["profiletitle"].ToString() != "")
                                {
                                    data.name = "<b>" + reader["name"].ToString() + " </b>  - " + reader["profiletitle"].ToString() + " Started <b> Following </b> you";
                                }
                                else
                                {
                                    data.name = "<b>" + reader["name"].ToString() + " </b> Started <b> Following </b> you";

                                }
                                data.username = reader["username"].ToString();
                                data.notificationnavigateurl = "/profile_guest.aspx?username=" + data.username;
                            }
                        }

                        else
                        {

                        }


                        String strnotification = ("select notificationtime,flag from [dbo].[notifications] where ( id = '" + data.notiid + "' ) ");
                        SqlCommand notismc = new SqlCommand(strnotification, con);
                        SqlDataReader notireader = notismc.ExecuteReader();
                        if (notireader.HasRows)
                        {
                            while (notireader.Read())
                            {
                                data.time = notireader["notificationtime"].ToString();
                                data.flag = notireader["flag"].ToString();
                            }
                        }
                        else
                        {
                            //
                        }

                    }


                    else if (data.notitype == "job status")
                    {
                        data.notificationnavigateurl = "/job-status.aspx";

                        // checking how much like has a user has got and then loading the other data on the basis of that
                        // checking how much like has a user has got and then loading the other data on the basis of that
                       
                            String str = ("select userdata123.name,jobs.jobtitle,jobs.joblocation,jobapplied.status  from [dbo].[jobs] INNER JOIN [dbo].[userdata123] ON userdata123.username = jobs.username INNER JOIN jobapplied ON jobapplied.jobid = jobs.id  where ( jobs.id  = '" + data.postid + "' and jobapplied.appliedby = '"+ Session["username"] +"'  ) ");
                            SqlCommand com = new SqlCommand(str, con);
                            SqlDataReader reader = com.ExecuteReader();
                            if (reader.HasRows)
                            {
                                while (reader.Read())
                                {
                                    data.customtext = "Your job application status at <b>" + reader["name"].ToString() + "</b> for the role <b>" + reader["jobtitle"].ToString() + "</b> for <b>" + reader["joblocation"].ToString()  + "</b> location is been chnaged to <b>" + reader["status"].ToString() + "</b>";
                                }
                            }
                       


                        String strnotification = ("select notificationtime,flag from [dbo].[notifications] where ( id = '" + data.notiid + "' ) ");
                        SqlCommand notismc = new SqlCommand(strnotification, con);
                        SqlDataReader notireader = notismc.ExecuteReader();
                        if (notireader.HasRows)
                        {
                            while (notireader.Read())
                            {
                                data.time = notireader["notificationtime"].ToString();
                                data.flag = notireader["flag"].ToString();
                            }
                        }
                        else
                        {
                            //
                        }

                    }


                    // enbd of comment if
                    rendernotification.Add(data);
                }

            }

            else
            {

            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = Int32.MaxValue;
            Context.Response.Write(js.Serialize(rendernotification));
        }

    }


    [WebMethod(enableSession: true)]
    public void loadnotificationposts(string postid)
    {
        List<notification> rendernotification = new List<notification>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            // getting the post content
            String strpost = ("select postimage, postdescription from [dbo].[posts] where ( postid = '" + postid + "' ) ");
            SqlCommand notipost = new SqlCommand(strpost, con);
            con.Open();
            SqlDataReader notipostrdr = notipost.ExecuteReader();


            if (notipostrdr.HasRows)
            {
                while (notipostrdr.Read())
                {
                    notification data = new notification();
                    data.postdescription = notipostrdr["postdescription"].ToString();

                    object objpostimage = notipostrdr["postimage"];
                    if (objpostimage != DBNull.Value)
                    {
                        byte[] bytes = (byte[])objpostimage;
                        string logo = Convert.ToBase64String(bytes);
                        data.postimage = logo;
                    }
                    else
                    {
                        data.postimage = null;
                    }

                    rendernotification.Add(data);
                }
            }
            else
            {
                notification data = new notification();
                data.post = "";

                rendernotification.Add(data);
            }


        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(rendernotification));
    }

    [WebMethod(enableSession: true)]
    public void loadnotificationimage(string postid)
    {
        List<notification> rendernotification = new List<notification>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            String str = ("select top 9 userdata123.profilepic from [dbo].[postlikes] full outer JOIN [dbo].[userdata123] ON userdata123.username = postlikes.likedby where ( postlikes.postid = '" + postid + "' and  userdata123.username != '" + Session["username"] + "' )  ");
            SqlCommand com = new SqlCommand(str, con);
            con.Open();
            SqlDataReader reader = com.ExecuteReader();

            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    notification data = new notification();
                    object obj = reader["profilepic"];
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        data.profilepic = logo;
                    }
                    else
                    {
                        data.profilepic = null;
                    }

                    rendernotification.Add(data);
                }


            }
            else
            {

            }

            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(rendernotification));
    }

    [WebMethod(enableSession: true)]
    public void loadnotificationimagecomments(string postid)
    {
        List<notification> rendernotification = new List<notification>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            String str = ("select top 9 userdata123.profilepic from [dbo].[postcomments] INNER JOIN [dbo].[userdata123] ON userdata123.username = postcomments.commentedby where ( postcomments.postid = '" + postid + "' and  postcomments.commentedby  != '" + Session["username"] + "' )  ");
            SqlCommand com = new SqlCommand(str, con);
            con.Open();
            SqlDataReader reader = com.ExecuteReader();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    notification data = new notification();
                    object obj = reader["profilepic"];
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        //  data.profilepic += "<span class=images>" + logo + "</span>";
                        data.profilepic = logo;
                    }
                    else
                    {
                        //  data.profilepic += "<span class=images>" + null + "</span>";
                        data.profilepic = null;
                    }

                    rendernotification.Add(data);
                }
            }
            else
            {

            }

            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(rendernotification));
    }


    [WebMethod(enableSession: true)]
    public void loadnotificationprofilevisitors()
    {
        List<notification> rendernotification = new List<notification>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            String str = ("select top 9 profileviews.id,userdata123.profilepic from [dbo].[profileviews] full outer JOIN [dbo].[userdata123] ON userdata123.username = profileviews.viewedby  where (  profileviews.profile  = '" + Session["username"] + "' ) order by profileviews.id desc  ");
            SqlCommand com = new SqlCommand(str, con);
            con.Open();
            SqlDataReader reader = com.ExecuteReader();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    notification data = new notification();
                    object obj = reader["profilepic"];
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        //  data.profilepic += "<span class=images>" + logo + "</span>";
                        data.profilepic = logo;
                    }
                    else
                    {
                        //  data.profilepic += "<span class=images>" + null + "</span>";
                        data.profilepic = null;
                    }

                    rendernotification.Add(data);
                }
            }
            else
            {

            }

            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(rendernotification));
    }


}
