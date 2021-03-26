<%@ WebService Language="C#" CodeBehind="~/App_Code/manage-profile-class.cs" Class="user_profile_main" %>

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
public class user_profile_main : System.Web.Services.WebService
{

    // checking the theme for requested user
    [WebMethod(enableSession: true)]
    public void checktheme(string requestuserdetails)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select bodycolor,headercolor,textcolor from [dbo].[userdata] where username = '" + requestuserdetails + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            SqlDataReader themerdr = cm.ExecuteReader();
            if (themerdr.HasRows)
            {
                while (themerdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.bodycolor = themerdr["bodycolor"].ToString();
                    data.headercolor = themerdr["headercolor"].ToString();
                    data.textcolor = themerdr["textcolor"].ToString();
                    profiledata.Add(data);
                }
            }

            con.Close();

        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }


    //  getting profile pic and name for the navbar controls
    [WebMethod(EnableSession = true)]
    public void getUserDetails(string requestuserdetails)
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try

        {

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cm = new SqlCommand ("select profilepic,name,profiletitle,coverpic from [dbo].[userdata123] full outer join [dbo].[userdata] on userdata123.username = userdata.username where userdata123.username = '" + requestuserdetails + "' " , con);
                con.Open();
                country country = new country();
                SqlDataReader rdr = cm.ExecuteReader();
                while (rdr.Read())
                {
                    country.name = rdr["name"].ToString();
                    country.profiletitle = rdr["profiletitle"].ToString();
                    object obj = rdr["profilepic"];
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])rdr["profilepic"];
                        string logo = Convert.ToBase64String(bytes);
                        country.profilepic = "data:Image/png;base64," + logo;
                    }
                    else
                    {
                        country.profilepic = null;
                    }

                    object obj1 = rdr["coverpic"];
                    if (obj1 != DBNull.Value)
                    {
                        byte[] bytes = (byte[])rdr["coverpic"];
                        string logo = Convert.ToBase64String(bytes);
                        country.coverpic = "data:Image/png;base64," + logo;
                    }
                    else
                    {
                        country.coverpic = null;
                    }

                    countries.Add(country);
                }


                // sending the back to the ajax request 
                JavaScriptSerializer js = new JavaScriptSerializer();
                js.MaxJsonLength = int.MaxValue;
                Context.Response.Write(js.Serialize(countries));

                con.Close();
            }
        }

        catch { }

    }

   
    // getting update part
    [WebMethod(enableSession: true)]
    public string getabout(string requestuserdetails)
    {
        string text = "";
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select about from [dbo].[about] where username = '" + requestuserdetails + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            text = (string)cm.ExecuteScalar();
            if(text != null)
            {
                text = text.Replace("\r\n", "<br/>");
            }
            con.Close();
            return text;
        }
    }


    // getting the cover video url
    [WebMethod(enableSession: true)]
    public string getvideourl(string requestuserdetails)
    {
        string url = "";
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select covervideourl from [dbo].[userdata] where username = '" + requestuserdetails + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            url = cm.ExecuteScalar().ToString();
            con.Close();
            return url;
        }
    }


    // lpading the experience with limited data
    [WebMethod(enableSession: true)]
    public void loadexperience(string requestuserdetails)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,companyname,posttitle,startdate,enddate,verified,industry,worklocation from experience where ( username  = '" + requestuserdetails + "') order by startdate desc", con);
            con.Open();
            SqlDataReader exprdr = cmd.ExecuteReader();
            if (exprdr.HasRows)
            {
                while (exprdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = exprdr["id"].ToString();
                    data.companyname = exprdr["companyname"].ToString();
                    data.jobrole = exprdr["posttitle"].ToString();
                    data.startdate = exprdr["startdate"].ToString();
                    data.enddate = exprdr["enddate"].ToString();
                    data.location = exprdr["worklocation"].ToString();
                    data.industry = exprdr["industry"].ToString();
                    data.verified = exprdr["verified"].ToString();
                    profiledata.Add(data);


                    // matching up the dates and checking complete years or month
                    string enddates;
                    // convert text value of enddate if its string 
                    if (data.enddate == "currently working" || data.enddate == "Present" || data.enddate == "present")
                    {
                        enddates = DateTime.Now.ToString();
                    }
                    else
                    {
                        enddates = data.enddate;
                    }

                    DateTime Toyear = Convert.ToDateTime(enddates);
                    DateTime Fromyear = Convert.ToDateTime(data.startdate);
                    int years;
                    int month;
                    int totalmonths = 0;
                    years = Toyear.Year - Fromyear.Year;
                    month = Toyear.Month - Fromyear.Month;
                    //if (month > 0)
                    //    {
                    //        month = 12 + month;
                    //    }

                    totalmonths = totalmonths + (years * 12) + month;

                    string totaltime;
                    totaltime = " ( " +  totalmonths.ToString() + " months of experience )";


                    string[] start = data.startdate.Split(new char[] { '-' });
                    string months = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Convert.ToInt32(start[1]));
                    string startworkingdate = months + " " + start[0].ToString();

                    if (data.enddate.Contains("-"))
                    {
                        string[] end = data.enddate.Split(new char[] { '-' });
                        string endmonth = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Convert.ToInt32(end[1]));
                        string endworkingdate = " to " + endmonth + " " + end[0].ToString();
                        string total = startworkingdate + endworkingdate + totaltime;
                        data.dates = total;
                    }
                    else
                    {
                        string endworkingdate = " to" + " Present";
                        data.dates = startworkingdate + endworkingdate + totaltime;
                    }


                    // getting the username and profilepic of the company
                    string str1 = ("SELECT profilepic,username from [dbo].[userdata123] where name = '" +  data.companyname + "' and usertype = 'company'  ");
                    SqlCommand com = new SqlCommand(str1, con);
                    SqlDataReader reader = com.ExecuteReader();
                    if (reader.HasRows)
                    {
                        data.companypresent = true;
                        while (reader.Read())
                        {
                            data.companyusername = reader["username"].ToString();
                            object obj = reader["profilepic"];
                            if (obj != DBNull.Value)
                            {
                                byte[] bytes = (byte[])obj;
                                string logo = Convert.ToBase64String(bytes);
                                data.companylogo = logo;
                            }
                            else
                            {
                                data.companylogo = null;
                            }
                        }
                    }
                    // there is no company present
                    else
                    {
                        data.companypresent = false;
                    }

                    // checking who has verified the user work experience if onky it is verified
                    if (data.verified == "verified")
                    {
                        string str2 = ("SELECT distinct userdata123.profilepic,userdata123.name,verifyexp.verificationby,userdata123.usertype from [dbo].[userdata123] inner join verifyexp ON userdata123.username = verifyexp.verificationby where (verifyexp.verificationfor = '" + Session["username"] + "' and verifyexp.expid = '" + data.id + "' ) ");
                        SqlCommand com1 = new SqlCommand(str2, con);
                        SqlDataReader reader1 = com1.ExecuteReader();
                        if (!reader1.HasRows)
                        {
                            //
                        }
                        else
                        {
                            while (reader1.Read())
                            {
                                string verifyusername = reader1["verificationby"].ToString();
                                data.usertype = reader1["usertype"].ToString();

                                if (data.usertype == "company")
                                {
                                    data.verifyuserlink = "companies.aspx?username=" + verifyusername;
                                }
                                else
                                {
                                    data.verifyuserlink = "profile_guest.aspx?username=" + verifyusername;
                                }

                                // getting the verify user image
                                object obj = (object)(reader1["profilepic"]);
                                data.name = "Experience verified by " + reader1["name"].ToString();
                                if (obj != DBNull.Value)
                                {
                                    byte[] bytes = (byte[])obj;
                                    string logo = Convert.ToBase64String(bytes);
                                    data.verifyuserimage = logo;
                                }
                                else
                                {
                                    data.verifyuserimage = null;
                                }
                            }
                        }

                    }
                }
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    // lpading the experience on demand with limited data
    [WebMethod(enableSession: true)]
    public void loadOnDemandExperience(string expid)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,jobprofilesummary from experience where ( id  = '" + expid + "' )", con);
            con.Open();
            SqlDataReader exprdr = cmd.ExecuteReader();
            if (exprdr.HasRows)
            {
                while (exprdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = exprdr["id"].ToString();
                    data.description = exprdr["jobprofilesummary"].ToString();
                    profiledata.Add(data);
                }
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }


    [WebMethod(enableSession: true)]
    public string loadexpcontents(string expid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select jobprofilesummary from [dbo].[experience] where id = '" + expid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }


    // loading the teams
    [WebMethod(enableSession: true)]
    public void loadingteams(string expid)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string team = ("SELECT distinct companyteams.id,companyteams.teamname,companyteams.coverimage,companyteams.teampagetitle  from companyteams inner join productteams on productteams.productid = companyteams.id  where productteams.teamexpid = '" + expid  + "' ORDER BY id desc ");
            SqlCommand cm = new SqlCommand(team, con);

            con.Open();
            SqlDataReader teamrdr = cm.ExecuteReader();


            if (teamrdr.HasRows)
            {

                while (teamrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.teamid = teamrdr["id"].ToString();
                    data.name = teamrdr["teamname"].ToString();
                    data.teampagetitle = teamrdr["teampagetitle"].ToString();

                    object obj = (object)(teamrdr["coverimage"]);
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        data.teamcoverimage = logo;
                    }
                    else
                    {
                        data.teamcoverimage = null;
                    }

                    profiledata.Add(data);
                }
            }
            else
            {
                manage_profile_class data = new manage_profile_class();
                data.noteams = false;
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));

    }

    // loading the teams
    [WebMethod(enableSession: true)]
    public void loadingallteams(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string team = ("SELECT distinct companyteams.id,companyteams.teamname,companyteams.coverimage,companyteams.teampagetitle  from companyteams where createdby = '"+ username +"' order by id desc ");
            SqlCommand cm = new SqlCommand(team, con);

            con.Open();
            SqlDataReader teamrdr = cm.ExecuteReader();


            if (teamrdr.HasRows)
            {

                while (teamrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.teamid = teamrdr["id"].ToString();
                    data.name = teamrdr["teamname"].ToString();
                    data.teampagetitle = teamrdr["teampagetitle"].ToString();

                    object obj = (object)(teamrdr["coverimage"]);
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        data.teamcoverimage = logo;
                    }
                    else
                    {
                        data.teamcoverimage = null;
                    }

                    profiledata.Add(data);
                }
            }
            else
            {
                manage_profile_class data = new manage_profile_class();
                data.noteams = false;
                profiledata.Add(data);
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));

    }

    // adding teams for a specific user
    [WebMethod(EnableSession = true)]
    public void addingteams(string teamid, string expid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();
            string str1 = ("insert into productteams (productid,teamexpid,teamusername) values ('" + teamid + "', '" + expid + "', '" + Session["username"] + "') ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // deleting the teams from the database
    [WebMethod(enableSession: true)]
    public void deleteuserteam(string teamid, string expid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from productteams where productid = '" + teamid + "' and teamexpid = '" + expid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // loading the verified user who can verify others and cure=rent work at the same company
    [WebMethod(EnableSession = true)]
    public void loadverifyuser(string username, string companyname)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        //try
        //{
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand(" SELECT distinct userdata123.name,userdata123.profilepic,userdata123.username,userdata123.usertype,userdata.profiletitle,companypersonal_info.industry,companypersonal_info.tagline,userdata123.coverpic from [dbo].[userdata123] full outer join [dbo].[experience]  ON userdata123.username = experience.username full outer join companypersonal_info on companypersonal_info.username = userdata123.username full outer join userdata ON userdata.username = userdata123.username WHERE  ( experience.companyname = '" + companyname + "' and experience.verified = '" + "verified" + "' and experience.enddate = 'currently working'  ) or ( userdata123.username = '" + username  +"')   and userdata123.username != '" + Session["username"] + "'  ", con);
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


    // lpading the experience on demand
    [WebMethod(enableSession: true)]
    public void loadeducation(string requestuserdetails)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,qualification,institute,startdate,enddate,degreetype,specialization,grade from education where ( username  = '" + requestuserdetails + "'  ) order by enddate desc", con);
            con.Open();
            SqlDataReader edurdr = cmd.ExecuteReader();
            if (edurdr.HasRows)
            {
                while (edurdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = edurdr["id"].ToString();
                    data.qualification = edurdr["qualification"].ToString();
                    data.institute = edurdr["institute"].ToString();
                    data.startdate = edurdr["startdate"].ToString();
                    data.enddate = edurdr["enddate"].ToString();
                    data.dates = data.startdate + " - " + data.enddate;
                    data.degreetype = edurdr["degreetype"].ToString();

                    // data.specialization = edurdr["specialization"].ToString();
                    string grades = edurdr["grade"].ToString();

                    if(grades != "")
                    {
                        data.specialization = edurdr["specialization"].ToString() + " | " + grades;
                    }
                    else
                    {
                        data.specialization = edurdr["specialization"].ToString();
                    }


                    // getting the username and profilepic of the company
                    string str1 = ("SELECT profilepic,username from [dbo].[userdata123] where name = '" +  data.companyname + "' and usertype = 'company'  ");
                    SqlCommand com = new SqlCommand(str1, con);
                    SqlDataReader reader = com.ExecuteReader();
                    if (reader.HasRows)
                    {
                        data.companypresent = true;
                        while (reader.Read())
                        {
                            data.companyusername = reader["username"].ToString();
                            object obj = reader["profilepic"];
                            if (obj != DBNull.Value)
                            {
                                byte[] bytes = (byte[])obj;
                                string logo = Convert.ToBase64String(bytes);
                                data.companylogo = logo;
                            }
                            else
                            {
                                data.companylogo = null;
                            }
                        }
                    }
                    // there is no company present
                    else
                    {
                        data.companypresent = false;
                    }


                    profiledata.Add(data);
                }
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }


    // loading education on demand
      [WebMethod(enableSession: true)]
    public void loadOnDemandEducation(string eduid)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,educationdetails from education where ( id  = '" + eduid + "'  ) ", con);
            con.Open();
            SqlDataReader edurdr = cmd.ExecuteReader();
            if (edurdr.HasRows)
            {
                while (edurdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = edurdr["id"].ToString();
                    // data.specialization = edurdr["specialization"].ToString();
                    data.description = edurdr["educationdetails"].ToString();
                    profiledata.Add(data);
                }
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    [WebMethod(enableSession: true)]
    public string loadeducontents(string eduid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select educationdetails from [dbo].[education] where id = '" + eduid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }



    // project section
    [WebMethod(enableSession: true)]
    public void loadproject(string requestuserdetails)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,projectname,projecttype,startdate,enddate,summary,link from project where ( username  = '" + requestuserdetails + "'  ) order by enddate desc", con);
            con.Open();
            SqlDataReader projectrdr = cmd.ExecuteReader();
            if (projectrdr.HasRows)
            {
                while (projectrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = projectrdr["id"].ToString();
                    data.projectname = projectrdr["projectname"].ToString();
                    data.projecttype = projectrdr["projecttype"].ToString();
                    data.startdate = projectrdr["startdate"].ToString();
                    data.enddate = projectrdr["enddate"].ToString();
                    data.dates = data.startdate + " - " + data.enddate;
                    data.projectlink = projectrdr["link"].ToString();
                    data.description = projectrdr["summary"].ToString();
                    profiledata.Add(data);
                }
            }

            con.Close();

        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    [WebMethod(enableSession: true)]
    public string loadprojectcontents(string projectid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select summary from [dbo].[project] where id = '" + projectid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }

    [WebMethod(enableSession: true)]
    public void loadingprojectteams(string projectid)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("SELECT userdata123.profilepic,userdata123.username,projectmembers.id from userdata123 inner join projectmembers ON userdata123.username = projectmembers.memberusername where projectmembers.projectid = '" + projectid +"' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            SqlDataReader teamrdr = cm.ExecuteReader();
            if (teamrdr.HasRows)
            {
                while (teamrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = teamrdr["id"].ToString();
                    data.username = teamrdr["username"].ToString();
                    object obj = teamrdr["profilepic"];
                    if (obj != DBNull.Value)
                    {
                        byte[] bytes = (byte[])obj;
                        string logo = Convert.ToBase64String(bytes);
                        data.profileimage = logo;
                    }
                    else
                    {
                        data.profileimage = null;
                    }

                    profiledata.Add(data);
                }
            }
            con.Close();

        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    // remove project team members
    [WebMethod(enableSession: true)]
    public void insertprojectteammember( string projectid, string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("insert into [dbo].[projectmembers] (projectid, memberusername) values ('"+ projectid +"', '"+ username +"') ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // remove project team members
    [WebMethod(enableSession: true)]
    public void deleteprojectteam(string teammemberid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("Delete from [dbo].[projectmembers] where id = '" + teammemberid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }


    [WebMethod(enableSession: true)]
    public void loadingskills(string requestuserdetails)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("SELECT DISTINCT * from skill where username = '" + requestuserdetails + "' ORDER BY id desc", con);
            con.Open();
            SqlDataReader skillrdr = cmd.ExecuteReader();
            if (skillrdr.HasRows)
            {
                while (skillrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = skillrdr["id"].ToString();
                    data.skillname = skillrdr["skillname"].ToString();


                    // checking the rating of the users
                    string str2 = ("SELECT count (id) as total from endorsedskills where skillname = '" + data.skillname + "' and skillof = '" +  requestuserdetails + "' ");
                    SqlCommand cm3 = new SqlCommand(str2, con);
                    data.skillendorsement = cm3.ExecuteScalar().ToString();

                    if (data.skillendorsement == "0")
                    {
                        data.skillendorsement = "0 Endorsements";
                        data.skillrating = "0";
                    }
                    else
                    {
                        data.skillendorsement = data.skillendorsement + " Endorsements";
                        string str1 = ("SELECT Avg(Cast(rating as float)) As average FROM  endorsedskills where skillname = '" + data.skillname + "' and skillof = '" + requestuserdetails + "' ");
                        SqlCommand cm = new SqlCommand(str1, con);
                        SqlDataReader rd = cm.ExecuteReader();
                        if (rd.HasRows)
                        {
                            while (rd.Read())
                            {
                                // no endorsements leads to no rating
                                if (rd["average"].ToString() == DBNull.Value.ToString())
                                {
                                    data.skillrating = "0";
                                }
                                else
                                {
                                    data.skillrating = string.Format("{0:0.0}", rd["average"]) ;

                                }
                            }
                        }
                        else
                        {
                            //
                        }
                    }

                    profiledata.Add(data);

                }
                con.Close();
            }
        }
        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    [WebMethod(enableSession: true)]
    public void endorsedpeople(string skillname)
    {
        List<country> countries = new List<country>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand(" Select Distinct userdata123.profilepic FROM  endorsedskills full outer join userdata123 on userdata123.username = endorsedskills.endorsedby full outer join userdata ON userdata123.username = userdata.username WHERE  endorsedskills.skillname = '" + skillname + "' and userdata123.username != '"+ Session["username"] +"'  ", con);
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                country country = new country();
                object obj = rdr["profilepic"];
                if (obj != DBNull.Value)
                {
                    byte[] bytes = (byte[])obj;
                    string logo = Convert.ToBase64String(bytes);
                    country.profilepic = logo;
                }
                else
                {
                    country.profilepic = null;
                }

                countries.Add(country);
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = int.MaxValue;
            Context.Response.Write(js.Serialize(countries));
        }
    }

    // loading interests
    [WebMethod(enableSession: true)]
    public void loadinterests()
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("SELECT DISTINCT * from interestedin where username = '" + Session["username"] + "' ORDER BY id desc", con);
            con.Open();
            SqlDataReader skillrdr = cmd.ExecuteReader();
            if (skillrdr.HasRows)
            {
                while (skillrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = skillrdr["id"].ToString();
                    data.interests = skillrdr["interests"].ToString();
                    profiledata.Add(data);
                }
            }
            con.Close();
        }


        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    // send verification request to other users
    [WebMethod(enableSession: true)]
    public void sendverificationrequest(string expid, string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            // inserting the values into the database frverification
            SqlCommand cmd = new SqlCommand("insert into verifyexp (verificationfor,verificationby,expid) values ('" + Session["username"] + "','" + username + "','" + expid + "')", con);
            con.Open();
            cmd.ExecuteNonQuery();

            // updating the data into the experience database
            SqlCommand cmd1 = new SqlCommand("update experience set verified = 'request sent' where id = '" + expid + "'", con);
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(enableSession: true)]
    public void bindweblinks(string requestuserdetails)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("SELECT DISTINCT id,website,link from links where username = '" + requestuserdetails + "' ORDER BY id asc ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();

            SqlDataReader rda = cm.ExecuteReader();
            if (rda.HasRows)
            {
                while (rda.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.website = rda["website"].ToString();
                    data.link = rda["link"].ToString();
                    profiledata.Add(data);
                }
            }
            else
            {
                //
            }
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    [WebMethod(enableSession: true)]
    public string CountPostEngagement(string requestuserdetails)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select distinct COUNT(postid) from newsfeedactivity INNER JOIN posts ON posts.postid = newsfeedactivity.sourceid where ( activityby =  '"+ requestuserdetails +"' and activitytype = 'like' and posts.username != '"+ requestuserdetails +"' ) or ( activityby = '"+  requestuserdetails +"' and activitytype = 'comment' and posts.username !=  '"+ requestuserdetails +"' )  ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }

    [WebMethod(enableSession: true)]
    public string TotalJobapply(string requestuserdetails)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select COUNT(id) from jobapplied where appliedby =  '"+ requestuserdetails +"' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }

    [WebMethod(enableSession: true)]
    public string TCountprofileviews(string requestuserdetails)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select distinct COUNT(viewedby) from profileviews where profile =  '"+ requestuserdetails +"' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }

    [WebMethod(EnableSession = true)]
    public string countfollowers(string requestuserdetails)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from follow where (following = '" +  requestuserdetails + "' ) ", con);
            con.Open();
            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }

  [WebMethod(EnableSession = true)]
    public string countnetwork(string requestuserdetails)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from friends where (requestedto = '" + requestuserdetails + "' and status = 'friends' ) or (requestedby = '" + requestuserdetails + "' and status = 'friends' )  ", con);
            con.Open();
            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }

    // In last 30 days

    // followers
    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public void loadRecentFollowers(string requestuserdetails)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.name,userdata123.username  from [dbo].[userdata123]  left outer join follow  ON userdata123.username = follow.followedby where (follow.following = '" + Session["username"] + "'  and ( date >= DATEADD(day,-30, getdate()) and date <= getdate() )) ", con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
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


    // loading and binding the fvisitors
    [WebMethod(EnableSession = true)]
    public void loadRecentVisitors()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.username  from [dbo].[userdata123] Inner JOin profileviews ON userdata123.username = profileviews.viewedby full outer join userdata ON profileviews.viewedby = userdata.username  where (profileviews.profile = '" + Session["username"] + "'  and ( timing >= DATEADD(day,-7, getdate()) and timing <= getdate() )) ", con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.username = sdr["username"].ToString();
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


    // loading and binding the fvisitors
    [WebMethod(EnableSession = true)]
    public void loadRecentConnection()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.username,userdata123.name,friends.date from [dbo].[userdata123] left outer join friends ON ( userdata123.username = friends.requestedby OR userdata123.username = friends.requestedto ) where ((friends.requestedby = '" + Session["username"] + "' and  friends.status ='friends' and  date >= DATEADD(day,-30, getdate()) and date <= getdate() ) or (friends.requestedto = '" + Session["username"] + "' and  friends.status ='friends' and  date >= DATEADD(day,-30, getdate()) and date <= getdate() )) and ( userdata123.username != '" + Session["username"] + "' ) order by friends.date DESC", con);

                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        user.name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
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

    // block user
    [WebMethod(enableSession: true)]
    public void BlockUser(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand delete = new SqlCommand("delete from [dbo].[friends] where (requestedby = '" + Session["username"] + "' and requestedto = '" + username + "' ) or (requestedto = '" + Session["username"] + "' and requestedby = '" + username + "' )", con);
            con.Open();
            delete.ExecuteNonQuery();

            SqlCommand delete1 = new SqlCommand("delete from [dbo].[follow] where (followedby = '" + Session["username"] + "' and following = '" + username + "' ) or (following = '" + Session["username"] + "' and followedby = '" + username + "' )", con);
            delete1.ExecuteNonQuery();

            string str1 = ("insert into [dbo].[blockeduser](blockedby,blockuser) values ('" + Session["username"] + "','" + username + "') ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.ExecuteNonQuery();
            con.Close();

        }
    }

    
    // checking friend status of the user
    [WebMethod(EnableSession = true)]
    public void checkfriendstatus(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str3 = ("select requestedto,requestedby,status from [dbo].[friends] where (requestedby ='" + Session["username"] + "' and requestedto ='" + username + "' ) or (requestedto ='" + Session["username"] + "' and requestedby ='" + username + "') ");
            SqlCommand com3 = new SqlCommand(str3, con);
            con.Open();
            SqlDataAdapter sda = new SqlDataAdapter(com3);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            manage_profile_class data = new manage_profile_class();

            // no request or data found in database
            if (dt.Rows.Count == 0)
            {
                data.requeststatus = false;
            }
            else
            {
                data.requeststatus = true;
                data.requestedby = dt.Rows[0]["requestedby"].ToString();
                data.requestedto = dt.Rows[0]["requestedto"].ToString();
                data.friendshipstatus = dt.Rows[0]["status"].ToString();
            }
            profiledata.Add(data);
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    [WebMethod(EnableSession = true)]
    public bool checkfollow(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str3 = ("select id from [dbo].[follow] where (followedby ='" + Session["username"] + "' and following ='" + username + "' ) ");
            SqlCommand com3 = new SqlCommand(str3, con);
            con.Open();
            SqlDataAdapter sda = new SqlDataAdapter(com3);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            // not following
            if(dt.Rows.Count == 0)
            {
                return false;
            }
            // the user is following the other user
            else
            {
                return true;
            }
        }
    }

    // sending connection / friend request to the user

    [WebMethod(EnableSession = true)]
    public void Sendrequest(string username, string Followstatus)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string status = "requested";
            string str1 = ("insert into [dbo].[friends] (requestedto,requestedby,status) values ('" + username + "','" + Session["username"] + "','" + status + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
            if(Followstatus == "false")
            {
                followuser(username);
            }
            else
            {

            }

        }
    }

    // automatically follow the user once the friend request is been generated
    [WebMethod(EnableSession = true)]
    public void followuser(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("insert into [dbo].[follow] (following,followedby) values ('" + username + "','" + Session["username"] + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();

            SqlCommand cmd1 = new SqlCommand("insert into [dbo].[notifications](notificationby,notificationfor,postid,type) values ('" + Session["username"] + "','" + username + "','" + Session["username"] + "', '" + "following" + "')", con);
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    // automatically follow the user once the friend request is been generated
    [WebMethod(EnableSession = true)]
    public void deleteconnection(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[friends] where ( requestedby = '" + Session["username"] + "' and requestedto ='" + username + "' ) or ( requestedto = '" + Session["username"] + "' and requestedby ='" + username + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // automatically follow the user once the friend request is been generated
    [WebMethod(EnableSession = true)]
    public void Cancelrequest(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[friends] where ( requestedby = '" + Session["username"] + "' and requestedto ='" + username + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void Acceptrequest(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[friends] set status = 'friends' where ( requestedto = '" + Session["username"] + "' and requestedby ='" + username + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void Declinerequest(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[friends] where ( requestedto = '" + Session["username"] + "' and requestedby ='" + username + "' )");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // following the user
    [WebMethod(EnableSession = true)]
    public void StartFollowing(string username, string Followstatus)
    {
        // if the user is already following then do nothing
        if (Followstatus == "True")
        {
            //
        }
        // if the user is not following
        else
        {
            string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string str1 = ("insert into [dbo].[follow] (following,followedby) values ('" + username + "','" + Session["username"] + "' )");
                SqlCommand cm = new SqlCommand(str1, con);
                con.Open();
                cm.ExecuteNonQuery();

                SqlCommand cmd1 = new SqlCommand("insert into [dbo].[notifications](notificationby,notificationfor,postid,type) values ('" + Session["username"] + "','" + username + "','" + Session["username"] + "', '" + "following" + "')", con);
                cmd1.ExecuteNonQuery();
                con.Close();
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public void StopFollowing(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[follow] where followedby = '"+ Session["username"] +"' and following = '"+ username +"' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();

            SqlCommand deletenotify = new SqlCommand("delete from [dbo].[notifications] where ( postid = '" + Session["username"] + "' and notificationby = '" + Session["username"] + "'  and notificationfor = '" + username + "'  and type = '" + "following" +"' )", con);
            deletenotify.ExecuteNonQuery();

            con.Close();
        }
     }


}