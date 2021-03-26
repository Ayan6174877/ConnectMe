<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="network" %>

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
public class network : System.Web.Services.WebService
{
    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public string countnetwork()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from friends where (requestedto = '" + Session["username"] + "' and status = 'friends' ) or (requestedby = '" + Session["username"] + "' and status = 'friends' )  ", con);
            con.Open();

            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }

    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public void loadnetwork()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.username,userdata123.name,userdata123.usertype,userdata.profiletitle,friends.date from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username left outer join friends ON ( userdata123.username = friends.requestedby OR userdata123.username = friends.requestedto ) where ((friends.requestedby = '" + Session["username"] + "' and  friends.status ='friends'  ) or (friends.requestedto = '" + Session["username"] + "' and  friends.status ='friends' )) and ( userdata123.username != '" + Session["username"] + "' ) order by friends.date DESC", con);

                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
                        string title = sdr["profiletitle"].ToString();
                        if (title.Length >= 80)
                        {
                            user.profiletitle = title.Substring(0, 79) + "...";
                        }
                        else
                        {
                            user.profiletitle = title;
                        }

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

    // deleting the connections from the network list
    [WebMethod(EnableSession = true)]
    public void deleteconnections(string username)
    {
        // deleting the database value from the verifyexp table
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[friends]  where ( requestedto = '" + Session["username"] + "' and requestedby = '" + username + "' and status = 'friends' ) OR ( requestedto ='" + username + "' and requestedby = '" +  Session["username"] + "' and status = 'friends' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Close();
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }


    // counting the following of the user
    [WebMethod(EnableSession = true)]
    public string countfollowing()
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from follow where ( followedby = '" + Session["username"] + "' ) ", con);
            con.Open();
            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }


    // loading to whom the user is following

    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public void loadfollowing()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        //try
        //{
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.coverpic,userdata123.username,userdata123.name,userdata123.usertype,userdata.profiletitle,companypersonal_info.industry,companypersonal_info.tagline from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username full outer join companypersonal_info ON  companypersonal_info.username = userdata123.username full outer join follow ON userdata123.username = follow.following where (followedby = '" + Session["username"] + "' and userdata123.usertype = 'user' ) and userdata123.username != '" + Session["username"] + "' order by userdata123.name ", con);
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


        //}

        //    catch { }

    }

    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public string countfollowers()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from follow where (following = '" +  Session["username"] + "' ) ", con);
            con.Open();

            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }


    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public void loadfollowers()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.username,userdata123.name,userdata.profiletitle,userdata123.usertype from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username  left outer join follow  ON userdata123.username = follow.followedby where (follow.following = '" + Session["username"] + "' ) ", con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
                        string title = sdr["profiletitle"].ToString();
                        if (title.Length >= 80)
                        {
                            user.profiletitle = title.Substring(0, 79) + "...";
                        }
                        else
                        {
                            user.profiletitle = title;
                        }

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

    //  unfollowthe connections from the network list
    [WebMethod(EnableSession = true)]
    public void unfollowconnection(string username)
    {
        // deleting the database value from the verifyexp table
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[follow]  where ( followedby = '" + Session["username"] + "' and following = '" + username + "' ) ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Close();
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public string countnetworkrequest()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from friends  where ( requestedto = '" +  Session["username"] + "' and  status = 'requested' ) ", con);
            con.Open();
            string total = cmd.ExecuteScalar().ToString();
            return total;
        }

    }

    // loading the network request 
    [WebMethod(EnableSession = true)]
    public void loadnetworkrequests()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.username,userdata123.name,userdata123.usertype,userdata.profiletitle from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username left outer join friends ON userdata123.username = friends.requestedby  where  (friends.requestedto = '" + Session["username"] + "' and friends.status = 'requested' )  order by userdata123.name ", con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
                        string title = sdr["profiletitle"].ToString();
                        if (title.Length >= 80)
                        {
                            user.profiletitle = title.Substring(0, 79) + "...";
                        }
                        else
                        {
                            user.profiletitle = title;
                        }

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

    // accepting and deleting the friend request
    [WebMethod(EnableSession = true)]
    public void acceptrequest(string username)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[friends] set  date = @datetime, status = 'friends'  where  ( requestedto = '" + Session["username"] + "' and requestedby ='" + username + "' ) ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@datetime", DateTime.Now);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // removinf the pending request
    [WebMethod(EnableSession = true)]
    public void removerequest(string username)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[friends]  where requestedto = '" + Session["username"] + "' and requestedby ='" + username + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // loading the shared profiles of the user by another gust user
    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public void loadsharedprofile()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {

                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.username,userdata123.name,userdata123.usertype,userdata.profiletitle,sharedprofile.id,sharedprofile.sharedtime from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username inner JOIN [dbo].[sharedprofile] ON userdata123.username = sharedprofile.shareby where ( sharedprofile.sharedto = '" + Session["username"] + "' ) order by sharedprofile.sharedtime desc ", con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
                        user.id = sdr["id"].ToString();
                        string title = sdr["profiletitle"].ToString();
                        user.time = sdr["sharedtime"].ToString();
                        if (title.Length >= 80)
                        {
                            user.profiletitle = title.Substring(0, 79) + "...";
                        }
                        else
                        {
                            user.profiletitle = title;
                        }

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

    [WebMethod(EnableSession = true)]
    public string getfullmessage(string id)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select sharednote from [dbo].[sharedprofile] where id = '" + id + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }

    }


}
