<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="visitors" %>

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
public class visitors : System.Web.Services.WebService
{
    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public string countvisitors()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from profileviews where (profile = '" + Session["username"] + "' ) ", con);
            con.Open();

            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }
   
    // counting recent visitors in last 30 days
     // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public string countrecentvisitor()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count(id) from profileviews where (profile = '" + Session["username"] + "' and ( timing >= DATEADD(day,-30, getdate()) and timing <= getdate() ) ) ", con);
            con.Open();

            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }
  
        
    // recent visitors who are working
    [WebMethod(EnableSession = true)]
    public string countrecentworking()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select distinct max (experience.posttitle) from profileviews INNER JOIN experience ON profileviews.viewedby = experience.username where experience.enddate = 'currently working' and profileviews.profile = '"+ Session["username"] +"' and  ( timing >= DATEADD(day,-30, getdate()) and timing <= getdate() ) ", con);
            con.Open();
            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }

    [WebMethod(EnableSession = true)]
    public string countrecentworkingnumber(string jobtitle)
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select count (experience.id) from profileviews INNER JOIN experience ON profileviews.viewedby = experience.username where profileviews.profile = '"+ Session["username"] +"' and experience.posttitle = '"+ jobtitle +"'  and  ( timing >= DATEADD(day,-30, getdate()) and timing <= getdate())", con);
            con.Open();
            string total = cmd.ExecuteScalar().ToString();
            return total;
        }
    }



    // loading the shared profiles of the user by another gust user
    // loading and binding the followers lists
    [WebMethod(EnableSession = true)]
    public void loadprofilevisitors()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {

                SqlCommand cmd = new SqlCommand("select DISTINCT userdata123.profilepic,userdata123.username,userdata123.name,userdata123.usertype,userdata.profiletitle,profileviews.timing from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username Inner Join [dbo].[profileviews] ON userdata123.username = profileviews.viewedby where  ( profileviews.profile = '" + Session["username"] + "') order by profileviews.timing desc ", con);
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
                        user.time = sdr["timing"].ToString();
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


}
