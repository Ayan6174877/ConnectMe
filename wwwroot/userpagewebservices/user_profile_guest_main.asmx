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

    // checking the theme
    [WebMethod(enableSession: true)]
    public void checktheme(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select bodycolor,headercolor,textcolor from [dbo].[userdata] where username = '" + username + "' ");
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


    // getting the profiletitle
    [WebMethod(enableSession: true)]
    public string getprofiletitle()
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select profiletitle from [dbo].[userdata] where username = '" + Session["username"] + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            return text;
        }
    }


    // getting update part
    [WebMethod(enableSession: true)]
    public string getabout(string username)
    {
        string text = "";
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select about from [dbo].[about] where username = '" + username + "' ");
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
    // getting the profiletitle
    [WebMethod(enableSession: true)]
    public string getvideourl(string username)
    {
        string url = "";
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select covervideourl from [dbo].[userdata] where username = '" + username + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            url = cm.ExecuteScalar().ToString();
            con.Close();
            return url;
        }
    }

    // lpading the experience on demand
    [WebMethod(enableSession: true)]
    public void loadexperience(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,companyname,posttitle,startdate,enddate,verified,industry,worklocation,jobprofilesummary from experience where ( username  = '" + username + "' )", con);
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
                    data.description = exprdr["jobprofilesummary"].ToString();
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
                        string str2 = ("SELECT distinct userdata123.profilepic,userdata123.name,verifyexp.verificationby,userdata123.usertype from [dbo].[userdata123] inner join verifyexp ON userdata123.username = verifyexp.verificationby where (verifyexp.verificationfor = '" + username + "' and verifyexp.expid = '" + data.id + "' ) ");
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
    // lpading the experience on demand
    [WebMethod(enableSession: true)]
    public void loadeducation(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,qualification,institute,startdate,enddate,degreetype,specialization,grade,educationdetails from education where ( username  = '" + username + "'  ) order by enddate desc", con);
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

                    data.description = edurdr["educationdetails"].ToString();

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
    public void loadproject(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,projectname,projecttype,startdate,enddate,summary,link from project where ( username  = '" + username + "'  ) order by enddate desc", con);
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

    [WebMethod(enableSession: true)]
    public void loadingskills(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("SELECT DISTINCT * from skill where username = '" + username + "' ORDER BY id desc", con);
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
                    string str2 = ("SELECT count (id) as total from endorsedskills where skillname = '" + data.skillname + "' and skillof = '" +  username + "' ");
                    SqlCommand cm3 = new SqlCommand(str2, con);
                    data.skillendorsement = cm3.ExecuteScalar().ToString();

                    if (data.skillendorsement == "0")
                    {
                        data.skillendorsement = "0";
                        data.skillrating = "0";
                    }
                    else
                    {
                        data.skillendorsement = data.skillendorsement + " Endorsements";
                        string str1 = ("SELECT Avg(Cast(rating as float)) As average FROM  endorsedskills where skillname = '" + data.skillname + "' and skillof = '" + username + "' ");
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
                                    data.skillrating = string.Format("{0:0.0}", rd["average"]);

                                }
                            }
                        }
                        else
                        {
                            data.skillrating = "0";
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
    public void endorsedpeople(string skillname, string username)
    {
        List<country> countries = new List<country>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand(" Select Distinct userdata123.profilepic FROM  endorsedskills full outer join userdata123 on userdata123.username = endorsedskills.endorsedby full outer join userdata ON userdata123.username = userdata.username WHERE  endorsedskills.skillname = '" + skillname + "' and userdata123.username != '"+ username +"'  ", con);
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
    public void loadinterests(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("SELECT DISTINCT * from interestedin where username = '" + username + "' ORDER BY id desc", con);
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
    public void bindweblinks(string username)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("SELECT DISTINCT id,website,link from links where username = '" + username + "' ORDER BY id asc ");
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

    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public string countnetwork(string username)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from friends where (requestedto = '" + username + "' and status = 'friends' ) or (requestedby = '" + username + "' and status = 'friends' )  ", con);
            con.Open();

            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }


    // checking endorsed
    [WebMethod(enableSession: true)]
    public string CheckEndorse(string username,string skillname)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        string text = "";
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select rating from [dbo].[endorsedskills] where  (  skillname = '" + skillname + "' and endorsedby = '" + Session["username"].ToString() + "' and skillof = '"+ username +"' ) ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            //text = cm.ExecuteScalar().ToString();
            SqlDataReader rd = cm.ExecuteReader();
            if (rd.HasRows)
            {
                while (rd.Read())
                {
                    return text = rd["rating"].ToString();
                }
            }
            else
            {
                return text = "";
            }
        }

        return text;

    }

    [WebMethod(enableSession: true)]
    public void updateskillendorse(string username, string skill, string rate)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update endorsedskills SET rating = '" + rate + "' where ( skillname  = '" + skill + "' and skillof = '" + username + "' and endorsedby = '" + Session["username"] + "' ) ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }


    // inserting the endorsements for skills
    [WebMethod(enableSession: true)]
    public void insertskillendorse(string username, string skill, string rate)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("insert into endorsedskills (endorsedby,skillof,skillname,rating) values ( '" + Session["username"] + "','" + username + "','" + skill + "','" + rate + "' ) ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
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

    // checking endorsed
    [WebMethod(enableSession: true)]
    public bool checkprofileshare(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        bool text = false;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select id from [dbo].[sharedprofile] where  (  shareby = '" + Session["username"].ToString() + "' and sharedto = '"+ username +"'  and ( sharedtime >= DATEADD(day,-30, getdate()) and sharedtime <= getdate() ) ) ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            //text = cm.ExecuteScalar().ToString();
            SqlDataReader rd = cm.ExecuteReader();
            if (rd.HasRows)
            {
                while (rd.Read())
                {
                    return text = true;
                }
            }
            else
            {
                return text = false;
            }
        }

        return text;

    }

    [WebMethod(enableSession: true)]
    public void Insertprofileshare(string username, string message)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("insert into [dbo].[sharedprofile](shareby,sharedto,sharednote) values ('" + Session["username"] + "','" + username + "', @message ) ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@message", message);
            con.Open();
            cm.ExecuteNonQuery();


            string str2 = ("insert into [dbo].[notifications](notificationby,notificationfor,type) values ('" + Session["username"] + "','" + username + "', '" + "shared profile" + "' ) ");
            SqlCommand cm2 = new SqlCommand(str2, con);
            cm2.ExecuteNonQuery();
            con.Close();


        }
    }

}