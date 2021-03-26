<%@ WebService Language="C#" CodeBehind="~/App_Code/manage-profile-class.cs" Class="manage" %>

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.ComponentModel;
using System.Web;
using System.IO;


[WebService(Namespace = "https://www.jobeneur.com")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class manage : System.Web.Services.WebService
{

    // checking the theme
    [WebMethod(enableSession: true)]
    public string checktheme()
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select bodycolor from [dbo].[userdata] where username = '" + Session["username"] + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string color = cm.ExecuteScalar().ToString();
            con.Close();
            return color;

        }
    }

    // updating the profile theme of the user
    [WebMethod(enableSession: true)]
    public void updatetheme(string bodycolor, string headercolor, string textcolor)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[userdata] set bodycolor = @bodycolor, headercolor = @headercolor, textcolor = @textcolor  where username = '" + Session["username"] + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@bodycolor", bodycolor);
            cm.Parameters.AddWithValue("@headercolor", headercolor);
            cm.Parameters.AddWithValue("@textcolor", textcolor);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

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

    // updating the profiletitle
    [WebMethod(enableSession: true)]
    public void updatetitle(string title)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[userdata] set profiletitle = @title where username = '" + Session["username"] + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@title", title);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // getting update part
    [WebMethod(enableSession: true)]
    public string getabout()
    {
        string text = "";
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select about from [dbo].[about] where username = '" + Session["username"] + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            text = (string)cm.ExecuteScalar();
            con.Close();
            return text;
        }
    }

    // if about me is not inserted before then upload it later
    [WebMethod(enableSession: true)]
    public void insertabout(string aboutme)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("insertabout", con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter username = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]
            };
            cmd.Parameters.Add(username);


            SqlParameter abou = new SqlParameter()
            {
                ParameterName = "@about",
                Value = aboutme
            };
            cmd.Parameters.Add(abou);

            con.Open();
            cmd.ExecuteNonQuery();

            con.Close();
        }
    }



    // updating the about part
    [WebMethod(enableSession: true)]
    public void updateabout(string aboutme)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("updateabout", con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter username = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]
            };
            cmd.Parameters.Add(username);

            SqlParameter abou = new SqlParameter()
            {
                ParameterName = "@about",
                Value = aboutme
            };
            cmd.Parameters.Add(abou);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }

    // getting the cover video url
    // getting the profiletitle
    [WebMethod(enableSession: true)]
    public string getvideourl()
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select covervideourl from [dbo].[userdata] where username = '" + Session["username"] + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            string url = cm.ExecuteScalar().ToString();
            con.Close();
            return url;
        }
    }

    // updating the video url
    [WebMethod(enableSession: true)]
    public void updatevideourl(string videourl)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[userdata] set covervideourl = @url where username = '" + Session["username"] + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@url", videourl);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // removing the cover letter
    [WebMethod(enableSession: true)]
    public void deletevideourl()
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[userdata] set covervideourl = '' where username = '" + Session["username"] + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }

    // experience section
  
    // lpading the experience on demand
    [WebMethod(enableSession: true)]
    public void loadexpbyid(string expid)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,companyname,posttitle,startdate,enddate,verified,industry,worklocation,jobprofilesummary from experience where ( username  = '" + Session["username"] + "' and id = '"+ expid +"'  )", con);
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
                    data.description = exprdr["jobprofilesummary"].ToString().Replace("\r\n","<br/>");
                    data.verified = exprdr["verified"].ToString();
                    profiledata.Add(data);
                }
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    // updating the partial experience
    [WebMethod(enableSession: true)]
    public void updateexppartial(string expid, string description)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[experience] set jobprofilesummary = @description where id = '" + expid + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@description", description);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // updating the complete experience
    [WebMethod(enableSession: true)]
    public void updateexperience(string expid, string company, string jobrole, string startdate, string enddate, string location, string industry ,string description)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[experience] set  companyname = @company, posttitle = @jobrole, startdate = @start, enddate = @end, worklocation = @location, industry = @industry,  jobprofilesummary = @description where id = '" + expid + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@company", company);
            cm.Parameters.AddWithValue("@jobrole", jobrole);
            cm.Parameters.AddWithValue("@start", startdate);
            cm.Parameters.AddWithValue("@end", enddate);
            cm.Parameters.AddWithValue("@location", location);
            cm.Parameters.AddWithValue("@industry", industry);
            cm.Parameters.AddWithValue("@description", description);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // inserting the experience to the database
    [WebMethod(enableSession: true)]
    public void insertexperience(string company, string jobrole, string startdate, string enddate, string location, string industry, string description)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("insertexp", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter username = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]

            };
            cmd1.Parameters.Add(username);


            SqlParameter companyname = new SqlParameter()
            {
                ParameterName = "@companyname",
                Value = company

            };
            cmd1.Parameters.Add(companyname);

            SqlParameter post = new SqlParameter()
            {
                ParameterName = "@posttitle",
                Value = jobrole

            };
            cmd1.Parameters.Add(post);

            SqlParameter jobprofilesummary = new SqlParameter()
            {
                ParameterName = "@jobprofilesummary",
                Value = description

            };
            cmd1.Parameters.Add(jobprofilesummary);

            SqlParameter industries = new SqlParameter()
            {
                ParameterName = "@industry",
                Value =  industry

            };
            cmd1.Parameters.Add(industries);

            SqlParameter start = new SqlParameter()
            {
                ParameterName = "@startdate",
                Value = startdate

            };
            cmd1.Parameters.Add(start);


            SqlParameter end = new SqlParameter()
            {
                ParameterName = "@enddate",
                Value = enddate

            };
            cmd1.Parameters.Add(end);

            SqlParameter worklocation = new SqlParameter()
            {
                ParameterName = "@worklocation",
                Value = location
            };
            cmd1.Parameters.Add(worklocation);

            SqlParameter verified = new SqlParameter()
            {
                ParameterName = "@verified",
                Value = "not verified"

            };
            cmd1.Parameters.Add(verified);
            con.Open();
            cmd1.ExecuteNonQuery();

            // inserting the community name to the community table if not exists
            SqlCommand cmd2 = new SqlCommand("insert_community", con);
            cmd2.CommandType = CommandType.StoredProcedure;

            SqlParameter community = new SqlParameter()
            {
                ParameterName = "@community",
                Value = jobrole
            };
            cmd2.Parameters.Add(community);
            cmd2.ExecuteNonQuery();

            // insert to the following table
            SqlCommand cmd3 = new SqlCommand("insert_community_follow", con);
            cmd3.CommandType = CommandType.StoredProcedure;

             SqlParameter username_community = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]
            };
            cmd3.Parameters.Add(username_community);

            SqlParameter community_follow = new SqlParameter()
            {
                ParameterName = "@community",
                Value = jobrole
            };
            cmd3.Parameters.Add(community_follow);
            cmd3.ExecuteNonQuery();
                
            con.Close();

        }
    }

    // deleting ther experience
    [WebMethod(enableSession: true)]
    public void deleteexperience(string expid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[experience] where ( id = '" + expid + "' and username = '"+ Session["username"] +"') ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // education part 
  
    // lpading the experience on demand
    [WebMethod(enableSession: true)]
    public void loadedubyid(string eduid)
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,qualification,institute,startdate,enddate,degreetype,specialization,grade,educationdetails from education where ( id = '"+ eduid +"' and username  = '" + Session["username"] + "'  ) order by enddate desc", con);
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
                    data.degreetype = edurdr["degreetype"].ToString();
                    data.specialization = edurdr["specialization"].ToString();
                    data.grade = edurdr["grade"].ToString();
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

    // updating the education
    [WebMethod(enableSession: true)]
    public void updateeducation(string eduid, string degreetype, string qualification, string institute, string startdate, string enddate, string specialization, string grade ,string description)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("update [dbo].[education] set  degreetype = @degree, qualification = @qualification, institute = @institute, startdate = @start, enddate = @end, specialization = @specialization, grade = @grade,  educationdetails = @description where id = '" + eduid + "'  ");
            SqlCommand cm = new SqlCommand(str1, con);
            cm.Parameters.AddWithValue("@degree", degreetype);
            cm.Parameters.AddWithValue("@qualification", qualification);
            cm.Parameters.AddWithValue("@institute", institute);
            cm.Parameters.AddWithValue("@start", startdate);
            cm.Parameters.AddWithValue("@end", enddate);
            cm.Parameters.AddWithValue("@specialization",specialization);
            cm.Parameters.AddWithValue("@grade", grade);
            cm.Parameters.AddWithValue("@description", description);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // insert education
    [WebMethod(enableSession: true)]
    public void inserteducation( string degreetype, string qualification, string institute, string startdate, string enddate, string specialization, string grade, string description)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("inserteducation", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter username = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]

            };
            cmd1.Parameters.Add(username);

            SqlParameter edudegree = new SqlParameter()
            {
                ParameterName = "@degreetype",
                Value = degreetype
            };
            cmd1.Parameters.Add(edudegree);

            SqlParameter eduqualification = new SqlParameter()
            {
                ParameterName = "@qualification",
                Value = qualification

            };
            cmd1.Parameters.Add(eduqualification);

            SqlParameter eduinstitute = new SqlParameter()
            {
                ParameterName = "@institute",
                Value = institute

            };
            cmd1.Parameters.Add(eduinstitute);

            SqlParameter eduspecialize = new SqlParameter()
            {
                ParameterName = "@specialization",
                Value = specialization

            };
            cmd1.Parameters.Add(eduspecialize);

            SqlParameter edudetails1 = new SqlParameter()
            {
                ParameterName = "@educationdetails",
                Value = description

            };
            cmd1.Parameters.Add(edudetails1);

            SqlParameter edugrade = new SqlParameter()
            {
                ParameterName = "@grade",
                Value = grade

            };
            cmd1.Parameters.Add(edugrade);

            SqlParameter edustart = new SqlParameter()
            {
                ParameterName = "@startdate",
                Value = startdate

            };
            cmd1.Parameters.Add(edustart);

            SqlParameter eduend = new SqlParameter()
            {
                ParameterName = "@enddate",
                Value = enddate
            };
            cmd1.Parameters.Add(eduend);

            con.Open();
            cmd1.ExecuteNonQuery();

            // inserting the community name to the community table if not exists
            SqlCommand cmd2 = new SqlCommand("insert_community", con);
            cmd2.CommandType = CommandType.StoredProcedure;

            SqlParameter community = new SqlParameter()
            {
                ParameterName = "@community",
                Value = qualification
            };
            cmd2.Parameters.Add(community);
            cmd2.ExecuteNonQuery();
            con.Close();

        }
    }

    // deleting ther education
    [WebMethod(enableSession: true)]
    public void deleteeducation(string eduid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("delete from [dbo].[education] where ( id = '" + eduid + "' and username = '"+ Session["username"] +"') ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // project section
    [WebMethod(enableSession: true)]
    public void loadallproject()
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select id,projectname,projecttype,startdate,enddate from project where ( username  = '" + Session["username"] + "'  ) order by enddate desc", con);
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
                    profiledata.Add(data);
                }
            }

            con.Close();

        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    // inserting the project
    [WebMethod(enableSession: true)]
    public void insertproject( string projectname, string projecttype,  string startdate, string enddate, string link, string description)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("insertproject", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter username = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]

            };
            cmd1.Parameters.Add(username);


            SqlParameter projectprojectname = new SqlParameter()
            {
                ParameterName = "@projectname",
                Value = projectname

            };
            cmd1.Parameters.Add(projectprojectname);

            SqlParameter type = new SqlParameter()
            {
                ParameterName = "@projecttype",
                Value = projecttype

            };
            cmd1.Parameters.Add(type);

            SqlParameter summary = new SqlParameter()
            {
                ParameterName = "@summary",
                Value = description

            };
            cmd1.Parameters.Add(summary);

            SqlParameter links = new SqlParameter()
            {
                ParameterName = "@link",
                Value = link

            };
            cmd1.Parameters.Add(links);

            SqlParameter projectstart = new SqlParameter()
            {
                ParameterName = "@startdate",
                Value = startdate

            };
            cmd1.Parameters.Add(projectstart);


            SqlParameter projectend = new SqlParameter()
            {
                ParameterName = "@enddate",
                Value = enddate

            };
            cmd1.Parameters.Add(projectend);

            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();

        }
    }

    // deleting the project
    [WebMethod(enableSession: true)]
    public void deleteproject(string projectid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("Delete from [dbo].[project] where id = '" + projectid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    [WebMethod(enableSession: true)]
    public void loadskills()
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("SELECT DISTINCT * from skill where username = '" + Session["username"] + "' ORDER BY id desc", con);
            con.Open();
            SqlDataReader skillrdr = cmd.ExecuteReader();
            if (skillrdr.HasRows)
            {
                while (skillrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = skillrdr["id"].ToString();
                    data.skillname = skillrdr["skillname"].ToString();
                    profiledata.Add(data);
                }
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    // adding skills
    [WebMethod(enableSession: true)]
    public void insertskills(string skillname)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("insertskill", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter username = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]

            };
            cmd1.Parameters.Add(username);


            SqlParameter skillnames = new SqlParameter()
            {
                ParameterName = "@skillname",
                Value = skillname

            };
            cmd1.Parameters.Add(skillnames);

            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    // deleting the skill
    [WebMethod(enableSession: true)]
    public void deleteskill(string id)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("Delete from [dbo].[skill] where id = '" + id + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    // interests starts here
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


    // loading interests
    [WebMethod(enableSession: true)]
    public void getlink()
    {
        List<manage_profile_class> profiledata = new List<manage_profile_class>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("SELECT id,link from links where username = '" + Session["username"] + "' ORDER BY id desc", con);
            con.Open();
            SqlDataReader linkrdr = cmd.ExecuteReader();
            if (linkrdr.HasRows)
            {
                while (linkrdr.Read())
                {
                    manage_profile_class data = new manage_profile_class();
                    data.id = linkrdr["id"].ToString();
                    data.link = linkrdr["link"].ToString();
                    profiledata.Add(data);
                }
            }
            con.Close();
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        js.MaxJsonLength = Int32.MaxValue;
        Context.Response.Write(js.Serialize(profiledata));
    }

    // delete the links
    // deleting the skill
    [WebMethod(enableSession: true)]
    public void deletelink(string linkid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("Delete from [dbo].[links] where id = '" + linkid + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }

    }

    [WebMethod(enableSession: true)]
    public void insertlinks(string link, string linkurl )
    {

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("insertlink", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter username = new SqlParameter()
            {
                ParameterName = "@username",
                Value = Session["username"]

            };
            cmd1.Parameters.Add(username);


            SqlParameter linkname = new SqlParameter()
            {
                ParameterName = "@website",
                Value = link

            };
            cmd1.Parameters.Add(linkname);

            SqlParameter url = new SqlParameter()
            {
                ParameterName = "@link",
                Value = linkurl

            };
            cmd1.Parameters.Add(url);

            con.Open();
            cmd1.ExecuteNonQuery();
        }
    }


}