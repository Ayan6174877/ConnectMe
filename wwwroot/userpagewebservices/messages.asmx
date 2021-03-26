<%@ WebService Language="C#" Class="messages" %>

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.ComponentModel;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class messages  : System.Web.Services.WebService {

    // getting the chatlist or the user
    [WebMethod(EnableSession = true)]
    public void getchatlist()
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT distinct userdata123.profilepic,userdata123.name,userdata123.username,userdata123.usertype from [dbo].[userdata123] left outer join messages ON ( userdata123.username = messages.messageby or userdata123.username = messages.messageto ) where  (messages.messageby = '" + Session["username"] + "'  or messages.messageto = '" + Session["username"] + "') and ( userdata123.username != '" + Session["username"] + "' )  ", con);
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
                    string nam = rdr["name"].ToString();
                    if(nam.Length > 50)
                    {
                        country.name = nam.Substring(0, 49) + "..";
                    }
                    else
                    {
                        country.name = nam;
                    }

                    country.username = rdr["username"].ToString();
                    country.usertype = rdr["usertype"].ToString();

                    SqlCommand cmd2 = new SqlCommand("SELECT top 1 message,messagetime,status from messages where (messageby = '" + Session["username"] + "' and messageto = '" + country.username + "') or (messageto = '" + Session["username"] + "' and messageby = '" + country.username + "') order by messageid desc ", con);
                    SqlDataReader rdr1 = cmd2.ExecuteReader();
                    if (rdr1.HasRows)
                    {
                        while (rdr1.Read())
                        {
                            string messagetext = rdr1["message"].ToString().Replace( "<br/>", "");
                            if (messagetext.Length > 30)
                            {
                                country.chat =  messagetext.Substring(0, 30) + "...";
                            }
                            else
                            {
                                country.chat = messagetext;
                            }

                            country.messagetime = rdr1["messagetime"].ToString();
                            country.status = rdr1["status"].ToString();

                        }

                        SqlCommand cmd3 = new SqlCommand("SELECT count (messageid) as total from messages where (messageto = '" + Session["username"] + "' and messageby = '" + country.username + "' and status = '0')   ", con);
                        country.count = cmd3.ExecuteScalar().ToString();

                    }
                    countries.Add(country);
                }
            }

           // countries.Reverse();
            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = int.MaxValue;
            Context.Response.Write(js.Serialize(countries));
        }
        catch
        {

        }
    }

    [WebMethod(EnableSession = true)]
    public void getchat(string usernamedata)
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(" Select messageid,message,messageby,messageto,messagetime,status from [dbo].[messages] WHERE  ( messageby = '" + Session["username"] + "' and messageto = '"+ usernamedata +"' ) or  ( messageto = '" + Session["username"] + "' and messageby = '"+ usernamedata +"' )  ORDER BY messageid asc ", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                if (rdr.HasRows)
                {
                    while (rdr.Read())
                    {
                        country country = new country();
                        country.id = rdr["messageid"].ToString();
                        country.chat = rdr["message"].ToString().Replace("\r\n", "<br />");
                        country.messageby = rdr["messageby"].ToString();
                        country.messageto = rdr["messageto"].ToString();
                        country.messagetime = rdr["messagetime"].ToString();
                        country.messagestatus = rdr["status"].ToString();


                        SqlCommand cmds = new SqlCommand(" Select profiletitle from [dbo].[userdata] WHERE  username = '"+ usernamedata +"' ", con);
                        SqlDataReader rdr1 = cmds.ExecuteReader();
                        if (rdr1.HasRows)
                        {
                            while (rdr1.Read())
                            {
                                string title = rdr1["profiletitle"].ToString();

                                if(title.Length > 80)
                                {
                                    country.profiletitle = title.Substring(0, 80) + "...";
                                }
                                else
                                {
                                    country.profiletitle = title;
                                }
                            }
                        }
                        else
                        {
                            country.profiletitle = "";
                        }

                        countries.Add(country);
                    }
                }

                else
                {

                }

                SqlCommand cmd1 = new SqlCommand("update messages SET status = '1' where ( status <> '1' and messageto = '" + Session["username"] + "' and messageby = '" + usernamedata + "' ) ", con);
                cmd1.ExecuteNonQuery();
                con.Close();

            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = int.MaxValue;
            Context.Response.Write(js.Serialize(countries));

        }
        catch
        {

        }

    }

    [WebMethod(EnableSession = true)]
    public void getnewmessages(string usernamedata)
    {
        List<country> countries = new List<country>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {

            using (SqlConnection con = new SqlConnection(cs))
            {

                SqlCommand cmd = new SqlCommand(" Select messageid,message,messageby,messageto,messagetime,status from [dbo].[messages] WHERE   ( messageto = '" + Session["username"] + "' and messageby = '"+ usernamedata +"' and status = '0'  )  ORDER BY messageid asc ", con);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    country country = new country();
                    country.id = rdr["messageid"].ToString();
                    country.chat = rdr["message"].ToString().Replace("\r\n" , "<br />");
                    country.messageby = rdr["messageby"].ToString();
                    country.messageto = rdr["messageto"].ToString();
                    country.messagetime = rdr["messagetime"].ToString();
                    country.messagestatus = rdr["status"].ToString();
                    countries.Add(country);
                }


                SqlCommand cmd1 = new SqlCommand("update messages SET status = '1' where ( status <> '1' and messageto = '" + Session["username"] + "' and messageby = '" + usernamedata + "' ) ", con);
                cmd1.ExecuteNonQuery();
                con.Close();

            }


            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = int.MaxValue;
            Context.Response.Write(js.Serialize(countries));
        }
        catch
        {

        }


    }


    [WebMethod(EnableSession = true)]
    public void sendmessage(string textmessage, string sendto)
    {

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;


        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd1 = new SqlCommand("insertmessage", con);
            cmd1.CommandType = CommandType.StoredProcedure;

            SqlParameter messageby = new SqlParameter()
            {
                ParameterName = "@messageby",
                Value = Session["username"]

            };
            cmd1.Parameters.Add(messageby);

            SqlParameter messageto = new SqlParameter()
            {
                ParameterName = "@messageto",
                Value = sendto

            };
            cmd1.Parameters.Add(messageto);

            SqlParameter message = new SqlParameter()
            {
                ParameterName = "@message",
                Value = textmessage

            };
            cmd1.Parameters.Add(message);

            con.Open();
            cmd1.ExecuteNonQuery();
            con.Close();

        }


    }



}