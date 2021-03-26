<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="settings" %>

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
public class settings : System.Web.Services.WebService
{
    // loading and binding notification counts and working at locations for the company page

    [WebMethod(EnableSession = true)]
    public string getjoineddate()
    {

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cm = new SqlCommand ("select joineddate from userdata123 where ( username = '" + Session["username"] + "')  ", con);
            con.Open();
            string text = cm.ExecuteScalar().ToString();
            con.Close();
            String sDate = text;
            string[] Words = sDate.Split(new char[] { '-' });
            string month = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Convert.ToInt32(Words[1]));
            DateTime date = Convert.ToDateTime(text);
            string year = date.Year.ToString();
            foreach (string Word in Words)
            {
                text = "Joined on " + Words[0].ToString() + " " + month + " " + year ;
            }
            return text;
        }
    }

    [WebMethod(EnableSession = true)]
    public void updatename(string name)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update userdata123 SET name = '" + name + "' where name <> '" + name + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void updatelocation(string location)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update userdata SET location = '" + location + "' where location <> '" + location + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void updatemobile(string mobile)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update userdata SET mobile = '" + mobile + "' where mobile <> '" + mobile + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void updatepassword(string password)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update userdata123 SET password = '" + password + "' where password <> '" + password + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }


    // privacy settung page chnages

    // posts
    [WebMethod(EnableSession = true)]
    public void updatepostprivacy(string valuedata)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update privacy SET posts = '" + valuedata + "' where posts <> '" + valuedata + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void updatenetworkprivacy(string valuedata)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update privacy SET friends = '" + valuedata + "' where friends <> '" + valuedata + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void updatemessageprivacy(string valuedata)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update privacy SET messages = '" + valuedata + "' where messages <> '" + valuedata + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }


    [WebMethod(EnableSession = true)]
    public void updateactivityprivacy(string valuedata)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update privacy SET activities = '" + valuedata + "' where activities <> '" + valuedata + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }


    [WebMethod(EnableSession = true)]
    public void updateprofilerivacy(string valuedata)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("update privacy SET profile = '" + valuedata + "' where profile <> '" + valuedata + "' and username = '" + Session["username"] + "'", con);
            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();
        }
    }

    // block user page
    [WebMethod(EnableSession = true)]
    public void checkblock()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("select userdata123.profilepic,userdata123.name,userdata123.username,userdata.profiletitle from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username left outer join [dbo].[blockeduser] ON userdata123.username = blockeduser.blockuser where blockedby = '" + Session["username"] + "'");
            SqlCommand cmd = new SqlCommand(str1, con);
            con.Open();
            SqlDataReader sdr = cmd.ExecuteReader();

            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    userdetails user = new userdetails();
                    user.name = sdr["name"].ToString();
                    user.username = sdr["username"].ToString();
                    user.profiletitle = sdr["profiletitle"].ToString();

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
                sdr.Close();
                con.Close();
            }
            else
            {
                //
            }
        }

    }

    //// unblocking the user
   [WebMethod(EnableSession = true)]
    public void unblockuser(string username)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str1 = ("Delete from [dbo].[blockeduser] where blockedby = '" + Session["username"] + "' and blockuser = '" + username + "' ");
            SqlCommand cm = new SqlCommand(str1, con);
            con.Open();
            cm.ExecuteNonQuery();
            con.Close();
        }
    }


}
