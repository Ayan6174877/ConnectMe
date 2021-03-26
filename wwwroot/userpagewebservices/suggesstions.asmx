<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="suggesstions" %>

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
public class suggesstions : System.Web.Services.WebService
{
    // loading and binding the suggestions
    [WebMethod(EnableSession = true)]
    public void showusersuggesstions()
    {
        List<userdetails> users = new List<userdetails>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select top 5 userdata123.profilepic,userdata123.name,userdata123.username,userdata.profiletitle from [dbo].[userdata123] full outer join userdata ON userdata123.username = userdata.username where userdata.username NOT IN  ( select userdata123.username from [dbo].[userdata123] full outer join userdata ON userdata123.username = userdata.username left outer join friends f on userdata123.username = f.requestedby left outer join friends h on userdata123.username = h.requestedto where (( h.requestedby = '" + Session["username"] + "' and h.status ='requested') or (h.requestedby = '" + Session["username"] + "' and h.status ='friends') or (f.requestedto = '" + Session["username"] + "'  and f.status ='friends') or (f.requestedto = '" + Session["username"] + "'  and f.status ='requested'))) and (userdata123.username != '" + Session["username"] + "') and usertype = 'user' order by newid() ", con);

                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        userdetails user = new userdetails();
                        string name = sdr["name"].ToString();
                        user.username = sdr["username"].ToString();
                        string title = sdr["profiletitle"].ToString();
                        if(name.Length > 22)
                        {
                            user.name = name.Substring(0, 21) + "...";
                        }
                        else
                        {
                            user.name = name;
                        }

                        if (title.Length > 80)
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
