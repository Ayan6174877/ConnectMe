<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="signup" %>

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
public class signup : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public bool IsSessionActive()
    {
        bool SessionActive = false;

        if (Session["username"] == null)
        {
            SessionActive = false;
        }
        else
        {
            SessionActive = true;
        }

        return SessionActive;
    }


    // loading and binding notification counts and working at locations for the company page
    [WebMethod(EnableSession = true)]
    public bool register_user_credentials(string name, string email,string username, string password)
    {
        bool IsUserExist = true;
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            if (username.Contains(" "))
            {
                username = username.Replace(" ", string.Empty);
            }

            SqlCommand cmd1 = new SqlCommand("insertuserdata", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter username1 = new SqlParameter()
            {
                ParameterName = "@username",
                Value = username.Replace(" ", "")
            };
            cmd1.Parameters.Add(username1);

            SqlParameter userfirstname = new SqlParameter()
            {
                ParameterName = "@name",
                Value = name

            };
            cmd1.Parameters.Add(userfirstname);

            SqlParameter useremail1 = new SqlParameter()
            {
                ParameterName = "@email",
                Value = email
            };
            cmd1.Parameters.Add(useremail1);

            SqlParameter userpassword1 = new SqlParameter()
            {
                ParameterName = "@password",
                Value = password

            };
            cmd1.Parameters.Add(userpassword1);

            string usertype1 = "user";
            SqlParameter usertype = new SqlParameter()
            {
                ParameterName = "@usertype",
                Value = usertype1

            };
            cmd1.Parameters.Add(usertype);

            cmd1.Parameters.Add("@ERROR", SqlDbType.VarChar, 100);
            cmd1.Parameters["@ERROR"].Direction = ParameterDirection.Output;
            con.Open();
            cmd1.ExecuteNonQuery();

            if (cmd1.Parameters["@ERROR"].Value == DBNull.Value)
            {
                // insertting the privacies of the user
                string str = ("insert into [dbo].[privacy] (username,profile,posts,friends,activities,messages) values ('" + username + "','" + "public" + "','" + "public" + "','" + "public" + "','" + "public" + "','" + "public" + "')");
                SqlCommand cm = new SqlCommand(str, con);
                cm.ExecuteNonQuery();


                //inserting the other details
                string str2 = ("insert into [dbo].[userdata] (username) values ('" + username + "')");
                SqlCommand cm2 = new SqlCommand(str2, con);
                cm2.ExecuteNonQuery();

                // sending a greeting email to the user after sucessfull registration
                //string email = useremail.Text;
                //string name = firstname.Text;
                //string subject = "Welcome To jobeneur";
                //string body = Populateuserbody(name);
                //SendEmail(email, subject, body);

                //redirecting the user to other page
                Session["usertype"] = "user";
                Session["username"] = username;
                Application["name"] = name;
                IsUserExist = false;
            }
            else
            {
                IsUserExist = true;
            }
            con.Close();
        }
        return IsUserExist;
    }

    [WebMethod(EnableSession = true)]
    public void updatedob(string dob)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str2 = ("update [dbo].[userdata] set dob = '" + dob + "' where username = '"+ Session["username"] + "' ");
            SqlCommand cm2 = new SqlCommand(str2, con);
            con.Open();
            cm2.ExecuteNonQuery();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public void updatelocation(string get_location)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str2 = ("update [dbo].[userdata] set location = '" + get_location + "'  where username = '"+ Session["username"] + "' ");
            SqlCommand cm2 = new SqlCommand(str2, con);
            con.Open();
            cm2.ExecuteNonQuery();
            con.Close();
        }
    }

    // inser tvalue for company demo
    [WebMethod(EnableSession = true)]
    public void company_demo(string username, string companyname, string email, string mobile)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {
            string str2 = ("insert into [dbo].[company_demo_registration] (name,companyname,email,mobile) values ('" + username + "','" + companyname + "','" + email + "','" + mobile + "')");
            SqlCommand cm2 = new SqlCommand(str2, con);
            con.Open();
            cm2.ExecuteNonQuery();
            con.Close();
        }
    }

}

