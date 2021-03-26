<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="notificationload" %>

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
public class notificationload : System.Web.Services.WebService
{

    // getting update part
    [WebMethod(enableSession: true)]
    public string returnSession()
    {
        string text = Session["username"].ToString();
        return text;
    }

    [WebMethod(enableSession: true)]
    public void logout()
    {
        Session.Abandon();
    }

    // loading and binding notification counts and working at locations for the company page
    [WebMethod(EnableSession = true)]
    public void bindnotificationscount()
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try

        {

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cm = new SqlCommand ("select count (id) as noticount from notifications where ( notificationfor = '" + Session["username"] + "' and  flag = '0' )  ", con);
                con.Open();
                country country = new country();
                SqlDataReader rdr = cm.ExecuteReader();
                while (rdr.Read())
                {
                    country.notificationcount = rdr["noticount"].ToString();

                }

                countries.Add(country);
                // sending the back to the ajax request 
                JavaScriptSerializer js = new JavaScriptSerializer();
                js.MaxJsonLength = int.MaxValue;
                Context.Response.Write(js.Serialize(countries));

                con.Close();
            }
        }

        catch { }


    }


    [WebMethod(EnableSession = true)]
    public void bindverificationcount()
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try

        {

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cm = new SqlCommand ("select count(id) as veficationcount from friends where  ( requestedto = '" + Session["username"] + "' and status = 'requested' ) ", con);
                con.Open();
                country country = new country();
                SqlDataReader rdr = cm.ExecuteReader();
                while (rdr.Read())
                {
                    country.networkcount = rdr["veficationcount"].ToString();

                }

                countries.Add(country);
                // sending the back to the ajax request 
                JavaScriptSerializer js = new JavaScriptSerializer();
                js.MaxJsonLength = int.MaxValue;
                Context.Response.Write(js.Serialize(countries));

                con.Close();
            }
        }

        catch { }


    }



    [WebMethod(EnableSession = true)]
    public void countmessages()
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try

        {

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cm = new SqlCommand ("select count(messageid) as messagecount from messages where  ( messageto = '" + Session["username"] + "' and status = '0' ) ", con);
                con.Open();
                country country = new country();
                SqlDataReader rdr = cm.ExecuteReader();
                while (rdr.Read())
                {
                    country.messagecount = rdr["messagecount"].ToString();

                }

                countries.Add(country);
                // sending the back to the ajax request 
                JavaScriptSerializer js = new JavaScriptSerializer();
                js.MaxJsonLength = int.MaxValue;
                Context.Response.Write(js.Serialize(countries));

                con.Close();
            }
        }

        catch { }


    }


    //  getting profile pic and name for the navbar controls
    [WebMethod(EnableSession = true)]
    public void getprofileimage()
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        //try

        //{

        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cm = new SqlCommand ("select profilepic,name,profiletitle,coverpic from [dbo].[userdata123] full outer join [dbo].[userdata] on userdata123.username = userdata.username where userdata123.username = '" + Session["username"] + "' " , con);
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
        //}

        //    catch { }


    }

}
