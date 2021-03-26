<%@ WebService Language="C#" CodeBehind="~/App_Code/userposts.cs" Class="loadnewsfeed" %>

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
public class loadnewsfeed : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public void loadnewsfeeddata(int pageNumber,int pageSize, string companyusername)
    {
        List<userposts> postdata = new List<userposts>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("storyfeeddata", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@Pagenumber",
                Value = pageNumber
            });

            cmd.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@Pagesize",
                Value = pageSize
            });

            cmd.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]
            });

            cmd.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@companyusername ",
                Value = companyusername
            });

            con.Open();
            SqlDataReader rdractivity = cmd.ExecuteReader();

            if (rdractivity.HasRows)
            {
                while (rdractivity.Read())
                {
                    userposts data = new userposts();
                    data.activitytype = rdractivity["activitytype"].ToString();
                    data.sourceid = Convert.ToInt32(rdractivity["sourceid"]);
                    data.activityby = rdractivity["activityby"].ToString();

                    // now getting the complete data from the database a sper the data 
                    // received from the activity feed

                    // if the activitytype is a post then get the value from the database
                    if (data.activitytype == "post")
                    {
                        // calling a procedure and get the data from the database
                        SqlCommand cmdpost = new SqlCommand("getpostdata", con);
                        cmdpost.CommandType = System.Data.CommandType.StoredProcedure;

                        cmdpost.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@postid",
                            Value = data.sourceid
                        });

                        SqlDataReader rdrpost = cmdpost.ExecuteReader();
                        while (rdrpost.Read())
                        {
                            data.postid = Convert.ToInt32(rdrpost["postid"]);
                            object obj = rdrpost["profilepic"];
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
                            data.name = rdrpost["name"].ToString();
                            data.username = rdrpost["username"].ToString();
                            data.usertype = rdrpost["usertype"].ToString();
                            data.postdescription = rdrpost["postdescription"].ToString().Replace("\r\n", "<br/>");
                            object obj1 = rdrpost["postimage"];
                            if (obj1 != DBNull.Value)
                            {
                                byte[] bytes = (byte[])obj1;
                                string logo = Convert.ToBase64String(bytes);
                                data.postimage = logo;
                            }
                            else
                            {
                                data.postimage = null;
                            }
                            data.postedtime = rdrpost["postedtime"].ToString();
                            // if the user is a company that means post is of a company
                            if (data.usertype == "company")
                            {
                                string str2 = ("select count(id) from follow  where following ='" + data.username + "' ");
                                SqlCommand cm1 = new SqlCommand(str2, con);
                                data.companydetails = cm1.ExecuteScalar().ToString() + " Followers";
                            }
                            else
                            {
                                string str = ("select experience.companyname,experience.posttitle,experience.verified from [dbo].[experience]  where (experience.username ='" + data.username + "' and enddate = '" + "currently working" + "' )  ");
                                SqlCommand cm = new SqlCommand(str, con);
                                SqlDataReader rd = cm.ExecuteReader();
                                if (rd.HasRows)
                                {
                                    while (rd.Read())
                                    {
                                        data.companydetails = rd["posttitle"].ToString() + " at " + rd["companyname"].ToString();
                                        if (rd["verified"].ToString() == "verified")
                                        {
                                            data.verified = true;
                                        }
                                        else
                                        {
                                            data.verified = false;
                                        }
                                    }
                                    rd.Close();
                                }

                                // if there is  no rows
                                else
                                {

                                }
                            }
                            // loading the post data counts and like sunlik data from the database
                            string str1 = ("select count(distinct postlikes.likeid) as likes  from  postlikes  where  postlikes.postid = '" + data.postid + "' ");
                            str1 += "SELECT count(postcomments.commentedby) as comments  from  postcomments  where  postcomments.postid = '" + data.postid + "' ";
                            // str1 += "SELECT count(distinct sharedposts.sharedby) as shared  from  sharedposts  where sharedposts.postid = '" + data.postid + "' ";

                            using (SqlCommand cmd2 = new SqlCommand(str1))
                            {
                                using (SqlDataAdapter sda1 = new SqlDataAdapter())
                                {
                                    cmd2.Connection = con;
                                    sda1.SelectCommand = cmd2;
                                    using (DataSet ds = new DataSet())
                                    {
                                        sda1.Fill(ds);
                                        data.likescounts = ds.Tables[0].Rows[0]["likes"].ToString();
                                        data.commentcounts = ds.Tables[1].Rows[0]["comments"].ToString();
                                        //  data.sharecounts = ds.Tables[2].Rows[0]["shared"].ToString();

                                    }

                                }
                            }

                            // CHECKING WHETHER THE USER HAS LIKES THE POST OR NOT
                            SqlCommand cmd5 = new SqlCommand("SELECT * from postlikes  where postid = '" + data.postid + "' and likedby = '" + Session["username"] + "'  ", con);
                            SqlDataAdapter sda = new SqlDataAdapter(cmd5);
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            // if the user has liked the post already        
                            if (dt.Rows.Count != 0)
                            {
                                data.likeunlike = true;

                                if(data.likescounts == "1")
                                {
                                    data.customtextdata = "You like this";
                                }
                                else
                                {
                                    data.customtextdata = "You  and " + ( (Convert.ToInt32(data.likescounts))  - 1 ) + " more like this";
                                }
                            }
                            else
                            {
                                data.likeunlike = false;

                                if(data.likescounts == "0")
                                {
                                    data.customtextdata = "";
                                }
                                else
                                {
                                    data.customtextdata =  data.likescounts + " people like this";
                                }
                            }

                            postdata.Add(data);
                        }

                        // end of if for post
                    }




                    // if the activity type is a company news
                    else if (data.activitytype == "news")
                    {
                        SqlCommand cmdnews = new SqlCommand("Select userdata123.username,userdata123.profilepic,userdata123.name,highlights.id,highlights.highlightitle,highlights.highlightimage,highlights.navigateurl,highlights.postedtime from [dbo].[highlights] INNER JOIN userdata123 ON highlights.username = userdata123.username where ( highlights.username = '" + data.activityby + "' and highlights.id = '" + data.sourceid + "' ) ", con);
                        SqlDataReader rdrnews = cmdnews.ExecuteReader();
                        while (rdrnews.Read())
                        {
                            data.newsid = Convert.ToInt32(rdrnews["id"]);
                            //object obj1 = rdrnews["profilepic"];
                            //if (obj1 != DBNull.Value)
                            //{
                            //    byte[] bytes = (byte[])obj1;
                            //    string logo = Convert.ToBase64String(bytes);
                            //    data.profilepic = logo;
                            //}
                            //else
                            //{
                            //    data.profilepic = null;
                            //}
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
                            data.name = rdrnews["name"].ToString();
                            data.username = rdrnews["username"].ToString();
                            data.link = rdrnews["navigateurl"].ToString();
                            data.newstitle = rdrnews["highlightitle"].ToString();
                            data.postedtime = rdrnews["postedtime"].ToString();
                        }

                        postdata.Add(data);
                    }





                    // if the activity type is a company story
                    else if (data.activitytype == "story")
                    {

                        SqlCommand cmdstory = new SqlCommand("Select userdata123.username,userdata123.profilepic,userdata123.name,stories.id,stories.storytitle,stories.storypic,stories.updatetime from [dbo].[stories] INNER JOIN userdata123 ON stories.storyby = userdata123.username where ( stories.storyby = '" + data.activityby + "' and stories.id = '" + data.sourceid + "' ) ", con);
                        SqlDataReader rdrstory = cmdstory .ExecuteReader();
                        while (rdrstory.Read())
                        {
                            data.storyid = Convert.ToInt32(rdrstory["id"]);
                            object obj1 = rdrstory["profilepic"];
                            if (obj1 != DBNull.Value)
                            {
                                byte[] bytes = (byte[])obj1;
                                string logo = Convert.ToBase64String(bytes);
                                data.profilepic = logo;
                            }
                            else
                            {
                                data.profilepic = null;
                            }
                            // getting the story image
                            object obj = rdrstory["storypic"];
                            if (obj != DBNull.Value)
                            {
                                byte[] bytes = (byte[])obj;
                                string logo = Convert.ToBase64String(bytes);
                                data.storypic = logo;
                            }
                            else
                            {
                                data.storypic = null;
                            }

                            data.name = rdrstory["name"].ToString();
                            data.username = rdrstory["username"].ToString();
                            data.storytitle = rdrstory["storytitle"].ToString();
                            data.postedtime = rdrstory["updatetime"].ToString();
                        }

                        postdata.Add(data);
                    }

                    // end of the first while loop
                }


            }


            // activity has no rows
            else
            {

            }
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = int.MaxValue;
        Context.Response.Write(js.Serialize(postdata));
    }

    // loading the user images who has liked the page
    [WebMethod(EnableSession = true)]
    public void loadlikeuserimage(string postid)
    {
        List<userposts> postdata = new List<userposts>();

        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmdstory = new SqlCommand("Select distinct top 5 userdata123.profilepic,userdata123.username from [dbo].[userdata123] INNER JOIN postlikes ON postlikes.likedby = userdata123.username where ( postlikes.postid = '" + postid + "' ) ", con);
            con.Open();
            SqlDataReader rdrstory = cmdstory .ExecuteReader();
            while (rdrstory.Read())
            {
                userposts data = new userposts();
                data.username = rdrstory["username"].ToString();
                object obj1 = rdrstory["profilepic"];
                if (obj1 != DBNull.Value)
                {
                    byte[] bytes = (byte[])obj1;
                    string logo = Convert.ToBase64String(bytes);
                    data.profilepic = logo;
                }
                else
                {
                    data.profilepic = null;
                }

                postdata.Add(data);
            }
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = int.MaxValue;
        Context.Response.Write(js.Serialize(postdata));
    }


    // liking the post
    [WebMethod(EnableSession = true)]
    public string likes_Click(string likepostid, string username)
    {
        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();

        using (SqlConnection con = new SqlConnection(connStr))
        {

            con.Open();
            SqlCommand cmd = new SqlCommand("insert into [dbo].[postlikes](postid,likedby) values ('" + likepostid + "','" + Session["username"] + "')", con);
            cmd.ExecuteNonQuery();

            if (username != Session["username"].ToString())
            {
                // inserting the value into the activity table for the newsfeed
                SqlCommand insertactivity = new SqlCommand("insert into newsfeedactivity (activityby,sourceid,activitytype) values ('" + Session["username"] + "','" + Convert.ToInt32(likepostid) + "', 'like')", con);
                insertactivity.ExecuteNonQuery();

                SqlCommand cmd1 = new SqlCommand("insert into [dbo].[notifications](notificationby,notificationfor,postid,type) values ('" + Session["username"] + "','" + username + "','" + likepostid + "', '" + "like" + "')", con);
                cmd1.ExecuteNonQuery();
            }


            // getting the total likes of the user
            SqlCommand cmdlike = new SqlCommand("select count(likeid) as totallikes from [dbo].[postlikes] where postid = '"+ likepostid +"' ", con);
            string totallikes = cmdlike.ExecuteScalar().ToString();
            return totallikes;
        }

    }

    // disliking the post
    [WebMethod(EnableSession = true)]
    public string unlikes_Click(string likepostid)
    {
        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand delete = new SqlCommand("delete from [dbo].[postlikes] where postid = '" + likepostid + "' and likedby = '" + Session["username"] + "' ", con);
            con.Open();
            delete.ExecuteNonQuery();

            // removing evreything from the activity table related to this post (likes,comments and post)
            string str2 = ("Delete from [dbo].[newsfeedactivity] where ( sourceid = '" + Convert.ToInt32(likepostid) + "' and activitytype = '" + "like" + "' )  ");
            SqlCommand cm2 = new SqlCommand(str2, con);
            cm2.ExecuteNonQuery();

            SqlCommand deletenotify = new SqlCommand("delete from [dbo].[notifications] where postid = '" + likepostid + "' and notificationby = '" + Session["username"] + "' ", con);
            deletenotify.ExecuteNonQuery();


            SqlCommand cmdlike = new SqlCommand("select count(likeid) as totallikes from [dbo].[postlikes] where postid = '"+ likepostid +"' ", con);
            string totallikes = cmdlike.ExecuteScalar().ToString();
            return totallikes;
        }
    }

    // deleting the post
    [WebMethod(EnableSession = true)]
    public void deletepost(string postid)
    {
        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();

        using (SqlConnection con = new SqlConnection(connStr))
        {
            string str1 = ("Delete from [dbo].[posts] where postid = '" + postid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();

            // removing evreything from the activity table related to this post (likes,comments and post)
            string str2 = ("Delete from [dbo].[newsfeedactivity] where ( sourceid = '" + Convert.ToInt32(postid) + "' and activitytype = '" + "post" + "' ) or ( sourceid = '" + Convert.ToInt32(postid) + "' and activitytype = '" + "like" + "' ) or ( sourceid = '" + Convert.ToInt32(postid) + "' and activitytype = '" + "comment" + "' ) ");
            SqlCommand cm2 = new SqlCommand(str2, con);
            cm2.ExecuteNonQuery();
            con.Close();
        }
    }

    // hiding the post from the newsfeed
    [WebMethod(EnableSession = true)]
    public void hidepost(string postid)
    {
        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();

        using (SqlConnection con = new SqlConnection(connStr))
        {
            string str1 = ("insert into [dbo].[hidepost] (postid,hideby) values  ( '" + postid + "','" +  Session["username"] + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // report a post
    [WebMethod(EnableSession = true)]
    public void reportingpost(string postid, string message)
    {
        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();

        using (SqlConnection con = new SqlConnection(connStr))
        {
            string str1 = ("insert into [dbo].[reportpost] (postid,reportby,reportmessage) values  ( '" + postid + "','" + Session["username"] + "','" + message + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // getting who has liked the post
    [WebMethod(EnableSession = true)]
    public void Getlikeuser(string postid)
    {
        List<userdetails> users = new List<userdetails>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(" Select Distinct Postlikes.likeid,userdata123.profilepic,userdata123.coverpic,userdata123.username,userdata123.name,userdata123.usertype,userdata.profiletitle,companypersonal_info.industry,companypersonal_info.tagline from [dbo].[postlikes] full outer join [dbo].[userdata123] ON userdata123.username = Postlikes.likedby full outer join [dbo].[posts] ON Postlikes.PostId = posts.PostId full outer JOIN userdata on userdata123.username = userdata.username  full outer join companypersonal_info on userdata123.username = companypersonal_info.username  WHERE  postlikes.PostId = '" + postid + "'   ORDER BY Postlikes.likeid asc ", con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
                        user.usertype = sdr["usertype"].ToString();
                        user.industry = sdr["industry"].ToString();
                        user.tagline = sdr["tagline"].ToString();
                        string title = sdr["profiletitle"].ToString();

                        object obj = sdr["profilepic"];
                        if (obj != DBNull.Value)
                        {
                            byte[] bytes = (byte[])obj;
                            string logo = Convert.ToBase64String(bytes);
                            user.profilepic = logo;
                        }
                        else
                        {
                            user.profilepic = null;
                        }

                        object objcover = sdr["coverpic"];
                        if (objcover != DBNull.Value)
                        {
                            byte[] bytes = (byte[])objcover;
                            string logo = Convert.ToBase64String(bytes);
                            user.coverpic = logo;
                        }
                        else
                        {
                            user.coverpic = null;
                        }

                        // if user is a company
                        if (user.usertype == "company")
                        {
                            SqlCommand cmdcountfollowers = new SqlCommand("select count(id) from follow where (follow.following = '" +  user.username + "' ) ", con);
                            user.totalcount = cmdcountfollowers.ExecuteScalar().ToString() + " Followers" ;
                        }

                        else
                        {
                            if (title.Length >= 80)
                            {
                                user.profiletitle = title.Substring(0, 79) + "...";
                            }
                            else
                            {
                                user.profiletitle = title;
                            }

                            string str = ("select experience.companyname,experience.posttitle,experience.verified from [dbo].[experience]  where (experience.username ='" + user.username + "' and enddate = '" + "currently working" + "' )  ");
                            SqlCommand cm = new SqlCommand(str, con);
                            SqlDataReader rd = cm.ExecuteReader();
                            if (rd.HasRows)
                            {
                                while (rd.Read())
                                {
                                    string details = rd["posttitle"].ToString() + " at " + rd["companyname"].ToString();

                                    if (details.Length >= 60)
                                    {
                                        user.companydeatils = details.Substring(0, 59) + "...";
                                    }
                                    else
                                    {
                                        user.companydeatils = details;
                                    }
                                }
                                rd.Close();
                            }
                            else
                            {
                                user.companydeatils = "";
                            }
                        }
                        users.Add(user);
                    }

                    JavaScriptSerializer js = new JavaScriptSerializer();
                    js.MaxJsonLength = int.MaxValue;
                    Context.Response.Write(js.Serialize(users));
                }

                else
                {
                    //
                }
                sdr.Close();
                con.Close();
            }


        }

        catch { }

    }
    // load few comments when users enters a comment directly into the newsfeed post
    [WebMethod(EnableSession = true)]
    public void loadcommentssome(string postid)
    {
        List<comments> comment = new List<comments>();

        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();
        SqlConnection con = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("SELECT distinct top 3 posts.username,posts.postid,PostComments.commentid,PostComments.commenttime,userdata123.name,userdata123.usertype,userdata123.profilepic,userdata123.username,PostComments.Comment,PostComments.Commentedby from [dbo].[PostComments]  inner join [dbo].[userdata123] ON userdata123.username = PostComments.Commentedby inner join [dbo].[posts] ON PostComments.PostId = posts.PostId  WHERE  postcomments.PostId = '" + postid + "'  order by PostComments.commentid desc ", con);
        con.Open();
        SqlDataReader rdr = cmd.ExecuteReader();

        while (rdr.Read())
        {
            comments commentdata = new comments();
            commentdata.name = rdr["name"].ToString();
            commentdata.username = rdr["username"].ToString();
            commentdata.usertype = rdr["usertype"].ToString();
            commentdata.commentid = Convert.ToInt32(rdr["commentid"]);
            commentdata.postid = rdr["postid"].ToString();
            commentdata.commentmessage = rdr["comment"].ToString();
            commentdata.commenttime = rdr["commenttime"].ToString();
            commentdata.commentedby = rdr["commentedby"].ToString();
            object obj = rdr["profilepic"];
            if (obj != DBNull.Value)
            {
                byte[] bytes = (byte[])obj;
                string logo = Convert.ToBase64String(bytes);
                commentdata.profilepic = logo;
            }
            else
            {
                commentdata.profilepic = null;
            }

            if (commentdata.usertype == "user")
            {
                string str = ("select experience.companyname,experience.posttitle,experience.verified from [dbo].[experience]  where (experience.username ='" + commentdata.commentedby + "' and enddate = '" + "currently working" + "' )  ");
                SqlCommand cm = new SqlCommand(str, con);
                SqlDataReader rd = cm.ExecuteReader();
                if (rd.HasRows)
                {
                    while (rd.Read())
                    {
                        commentdata.companyname = rd["posttitle"].ToString() + " at " + rd["companyname"].ToString();
                        if(rd["verified"].ToString() == "verified")
                        {
                            commentdata.verified = true;
                        }
                        else
                        {
                            commentdata.verified = false;
                        }
                    }
                    rd.Close();
                }
                else
                {

                    commentdata.companyname = "";
                }

            }

            else
            {
                string str1 = ("select count (id) as total from [dbo].[follow] where (following = '"+ commentdata.commentedby +"' )  ");
                SqlCommand cm1 = new SqlCommand(str1, con);
                commentdata.companyname =  cm1.ExecuteScalar().ToString() + " Followers";
            }
            comment.Add(commentdata);
        }

        con.Close();

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = int.MaxValue;
        Context.Response.Write(js.Serialize(comment));
    }

    // loading the comments from the database
    [WebMethod(EnableSession = true)]
    public void loadcomments(string postid)
    {
        List<comments> comment = new List<comments>();

        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();
        SqlConnection con = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("SELECT posts.username,posts.postid,PostComments.commentid,PostComments.commenttime,userdata123.name,userdata123.usertype,userdata123.profilepic,userdata123.username,PostComments.Comment,PostComments.Commentedby from [dbo].[PostComments]  inner join [dbo].[userdata123] ON userdata123.username = PostComments.Commentedby inner join [dbo].[posts] ON PostComments.PostId = posts.PostId  WHERE  postcomments.PostId = '" + postid + "'  order by PostComments.commentid asc ", con);
        con.Open();
        SqlDataReader rdr = cmd.ExecuteReader();

        while (rdr.Read())
        {
            comments commentdata = new comments();
            commentdata.name = rdr["name"].ToString();
            commentdata.username = rdr["username"].ToString();
            commentdata.usertype = rdr["usertype"].ToString();
            commentdata.commentid = Convert.ToInt32(rdr["commentid"]);
            commentdata.postid = rdr["postid"].ToString();
            commentdata.commentmessage = rdr["comment"].ToString();
            commentdata.commenttime = rdr["commenttime"].ToString();
            commentdata.commentedby = rdr["commentedby"].ToString();
            object obj = rdr["profilepic"];
            if (obj != DBNull.Value)
            {
                byte[] bytes = (byte[])obj;
                string logo = Convert.ToBase64String(bytes);
                commentdata.profilepic = logo;
            }
            else
            {
                commentdata.profilepic = null;
            }

            if (commentdata.usertype == "user")
            {
                string str = ("select experience.companyname,experience.posttitle,experience.verified from [dbo].[experience]  where (experience.username ='" + commentdata.commentedby + "' and enddate = '" + "currently working" + "' )  ");
                SqlCommand cm = new SqlCommand(str, con);
                SqlDataReader rd = cm.ExecuteReader();
                if (rd.HasRows)
                {
                    while (rd.Read())
                    {
                        commentdata.companyname = rd["posttitle"].ToString() + " at " + rd["companyname"].ToString();
                        if(rd["verified"].ToString() == "verified")
                        {
                            commentdata.verified = true;
                        }
                        else
                        {
                            commentdata.verified = false;
                        }
                    }
                    rd.Close();
                }
                else
                {

                    commentdata.companyname = "";
                }

            }

            else
            {
                string str1 = ("select count (id) as total from [dbo].[follow] where (following = '"+ commentdata.commentedby +"' )  ");
                SqlCommand cm1 = new SqlCommand(str1, con);
                commentdata.companyname =  cm1.ExecuteScalar().ToString() + " Followers";
            }
            comment.Add(commentdata);
        }

        con.Close();

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = int.MaxValue;
        Context.Response.Write(js.Serialize(comment));
    }

    // posting comments
    [WebMethod(EnableSession = true)]
    public void Postcomment(string postid, string comment, string username)
    {
        string connStr = ConfigurationManager.ConnectionStrings["connection"].ToString();

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd1 = new SqlCommand("insertcomment", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter postsid = new SqlParameter()
            {
                ParameterName = "@postid",
                Value = postid

            };
            cmd1.Parameters.Add(postsid);

            SqlParameter commentedby = new SqlParameter()
            {
                ParameterName = "@Commentedby",
                Value = Session["username"].ToString()

            };
            cmd1.Parameters.Add(commentedby);

            SqlParameter commentdata = new SqlParameter()
            {
                ParameterName = "@Comment",
                Value = comment

            };
            cmd1.Parameters.Add(commentdata);

            cmd1.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output;

            con.Open();
            cmd1.ExecuteNonQuery();
            string commentid = cmd1.Parameters["@id"].Value.ToString();

            if (username != Session["username"].ToString())
            {

                // inserting the value into the activity table for the newsfeed
                SqlCommand insertactivity = new SqlCommand("insert into newsfeedactivity (activityby,sourceid,activitytype) values ('" + Session["username"] + "','" + Convert.ToInt32(postid) + "', 'comment')", con);
                insertactivity.ExecuteNonQuery();

                // comments
                SqlCommand cmd2 = new SqlCommand("insert into [dbo].[notifications](notificationby,notificationfor,postid,type) values ('" + Session["username"] + "','" + username + "','" + postid + "', '" + "comment" + "')", con);
                cmd2.ExecuteNonQuery();

            }

            string str = ("select distinct commentedby from [dbo].[postcomments] where ( postid = '"+ postid +"' )  and commentedby != '" + Session["username"] + "' and commentedby != '" + username + "'   ");
            SqlCommand getusers = new SqlCommand(str, con);
            SqlDataAdapter sd = new SqlDataAdapter(getusers);
            DataTable dt = new DataTable();
            sd.Fill(dt);
            if (dt.Rows.Count == 0)
            {
                // do nothing
            }
            else
            {
                foreach (DataRow dr in dt.Rows)
                {
                    SqlCommand cmd2 = new SqlCommand("insert into [dbo].[notifications](notificationby,notificationfor,postid,type) values ('" + Session["username"] + "','" + dr["commentedby"].ToString() + "','" + postid + "', '" + "comment" + "')", con);
                    cmd2.ExecuteNonQuery();
                }
            }

            con.Close();
            // return commentid;

        }
    }

    [WebMethod]
    public string showfullcomment(string commentid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select comment from [dbo].[PostComments] where commentid = '" + commentid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }

    // loading the full div content
    [WebMethod]
    public string showcompletepost(string postid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select postdescription from [dbo].[posts] where postid = '" + postid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }

    // deleting the comments
    [WebMethod(EnableSession = true)]
    public void deletecomments(string commentid, string postid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();
            string str1 = ("Delete from [dbo].[postcomments] where commentid = '" + commentid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.ExecuteNonQuery();

            // removing evreything from the activity table related to this post (likes,comments and post)
            string str2 = ("Delete from [dbo].[newsfeedactivity] where ( sourceid = '" + postid + "' and activitytype = '" + "comment" + "' )  ");
            SqlCommand cm2 = new SqlCommand(str2, con);
            cm2.ExecuteNonQuery();

            SqlCommand deletenotify = new SqlCommand("delete from [dbo].[notifications] where ( postid = '" + postid + "' and notificationby = '" + Session["username"] + "' and type = 'comment' ) " , con);
            deletenotify.ExecuteNonQuery();

            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void insertpoststext( string activitypostdata, string tag, string privacytype)
    {
        // converting the object image to byte array so that it can be stored
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        //try
        //{
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("shareposttext", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter category1 = new SqlParameter()
            {
                ParameterName = "@category",
                Value = Session["usertype"].ToString()

            };
            cmd1.Parameters.Add(category1);

            SqlParameter Cusername = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"].ToString()
            };
            cmd1.Parameters.Add(Cusername);

            SqlParameter postdata = new SqlParameter()
            {
                ParameterName = "@postdescription",
                Value = activitypostdata.Replace("\r\n", Environment.NewLine)

            };
            cmd1.Parameters.Add(postdata);

            SqlParameter type = new SqlParameter()
            {
                ParameterName = "@type",
                Value = privacytype
            };
            cmd1.Parameters.Add(type);

            cmd1.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output;

            con.Open();
            cmd1.ExecuteNonQuery();

            // getting the current inserted post id  and sharing with the people with whom the post has been shared
            string id = cmd1.Parameters["@id"].Value.ToString();

            // inserting the value into the activity table for the newsfeed
            SqlCommand insertactivity = new SqlCommand("insert into newsfeedactivity (activityby,sourceid,activitytype) values ('" + Session["username"] + "','" + Convert.ToInt32(id) + "', 'post')", con);
            insertactivity.ExecuteNonQuery();


            string tagpeopleusername1 = tag.Replace(" ", string.Empty);
            string[] arryval = tagpeopleusername1.Split(',');//split values with ‘,’  
            int j = arryval.Length - 1;
            int i = 0;
            for (i = 0; i < j; i++)
            {
                SqlCommand cmd = new SqlCommand("insert into sharedposts (postid,sharedby,sharedstatus) values ('" + id + "','" + arryval[i] + "', 'shared')", con);
                cmd.ExecuteNonQuery();

                SqlCommand insernoti = new SqlCommand("insert into [dbo].[notifications](notificationby,notificationfor,postid,type) values ('" + Session["username"] + "','" + arryval[i] + "','" + id + "', '" + "mentioned" + "')", con);
                insernoti.ExecuteNonQuery();
            }

        }
        //}

        //    catch { }

    }


    // loading posts on demand by the user

    [WebMethod(EnableSession = true)]
    public void loadpostdata(string postid)
    {
        List<userposts> postdata = new List<userposts>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select posts.postid,posts.postdescription,posts.postimage,posts.postedtime,posts.username from posts where posts.postid = '"+ postid +"'", con);

            con.Open();
            SqlDataReader rdractivity = cmd.ExecuteReader();

            if (rdractivity.HasRows)
            {
                while (rdractivity.Read())
                {
                    userposts data = new userposts();
                    //  data.activitytype = rdractivity["username"].ToString();
                    data.sourceid = Convert.ToInt32(rdractivity["postid"]);
                    data.activityby = rdractivity["username"].ToString();

                    // now getting the complete data from the database a sper the data 
                    // received from the activity feed

                    // if the activitytype is a post then get the value from the database

                    // calling a procedure and get the data from the database
                    SqlCommand cmdpost = new SqlCommand("getpostdata", con);
                    cmdpost.CommandType = System.Data.CommandType.StoredProcedure;

                    cmdpost.Parameters.Add(new SqlParameter()
                    {
                        ParameterName = "@postid",
                        Value = data.sourceid
                    });

                    SqlDataReader rdrpost = cmdpost.ExecuteReader();
                    while (rdrpost.Read())
                    {
                        data.postid = Convert.ToInt32(rdrpost["postid"]);
                        object obj = rdrpost["profilepic"];
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
                        data.name = rdrpost["name"].ToString();
                        data.username = rdrpost["username"].ToString();
                        data.usertype = rdrpost["usertype"].ToString();
                        data.profiletitle = rdrpost["profiletitle"].ToString();
                        data.postdescription = rdrpost["postdescription"].ToString().Replace("\r\n", "<br/>");
                        object obj1 = rdrpost["postimage"];
                        if (obj1 != DBNull.Value)
                        {
                            byte[] bytes = (byte[])obj1;
                            string logo = Convert.ToBase64String(bytes);
                            data.postimage = logo;
                        }
                        else
                        {
                            data.postimage = null;
                        }
                        data.postedtime = rdrpost["postedtime"].ToString();
                        // if the user is a company that means post is of a company
                        if (data.usertype == "company")
                        {
                            string str2 = ("select count(id) from follow  where following ='" + data.username + "' ");
                            SqlCommand cm1 = new SqlCommand(str2, con);
                            data.companydetails = cm1.ExecuteScalar().ToString() + " Followers";
                        }
                        else
                        {
                            string str = ("select experience.companyname,experience.posttitle,experience.verified from [dbo].[experience]  where (experience.username ='" + data.username + "' and enddate = '" + "currently working" + "' )  ");
                            SqlCommand cm = new SqlCommand(str, con);
                            SqlDataReader rd = cm.ExecuteReader();
                            if (rd.HasRows)
                            {
                                while (rd.Read())
                                {
                                    data.companydetails = rd["posttitle"].ToString() + " at " + rd["companyname"].ToString();
                                    if (rd["verified"].ToString() == "verified")
                                    {
                                        data.verified = true;
                                    }
                                    else
                                    {
                                        data.verified = false;
                                    }
                                }
                                rd.Close();
                            }

                            // if there is  no rows
                            else
                            {

                            }
                        }
                        // loading the post data counts and like sunlik data from the database
                        string str1 = ("select count(distinct postlikes.likeid) as likes  from  postlikes  where  postlikes.postid = '" + data.postid + "' ");
                        str1 += "SELECT count(postcomments.commentedby) as comments  from  postcomments  where  postcomments.postid = '" + data.postid + "' ";
                        // str1 += "SELECT count(distinct sharedposts.sharedby) as shared  from  sharedposts  where sharedposts.postid = '" + data.postid + "' ";

                        using (SqlCommand cmd2 = new SqlCommand(str1))
                        {
                            using (SqlDataAdapter sda1 = new SqlDataAdapter())
                            {
                                cmd2.Connection = con;
                                sda1.SelectCommand = cmd2;
                                using (DataSet ds = new DataSet())
                                {
                                    sda1.Fill(ds);
                                    data.likescounts = ds.Tables[0].Rows[0]["likes"].ToString();
                                    data.commentcounts = ds.Tables[1].Rows[0]["comments"].ToString();
                                    //  data.sharecounts = ds.Tables[2].Rows[0]["shared"].ToString();

                                }

                            }
                        }

                        // CHECKING WHETHER THE USER HAS LIKES THE POST OR NOT
                        SqlCommand cmd5 = new SqlCommand("SELECT * from postlikes  where postid = '" + data.postid + "' and likedby = '" + Session["username"] + "'  ", con);
                        SqlDataAdapter sda = new SqlDataAdapter(cmd5);
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        // if the user has liked the post already        
                        if (dt.Rows.Count != 0)
                        {
                            data.likeunlike = true;

                            if (data.likescounts == "1")
                            {
                                data.customtextdata = "You like this";
                            }
                            else
                            {
                                data.customtextdata = "You  and " + ((Convert.ToInt32(data.likescounts)) - 1) + " more like this";
                            }
                        }
                        else
                        {
                            data.likeunlike = false;

                            if (data.likescounts == "0")
                            {
                                data.customtextdata = "";
                            }
                            else
                            {
                                data.customtextdata = data.likescounts + " people like this";
                            }
                        }

                        postdata.Add(data);
                    }

                    // end of if for post
                }

                // end of the first while loop
            }


            // activity has no rows
            else
            {

            }
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = int.MaxValue;
        Context.Response.Write(js.Serialize(postdata));
    }






}
