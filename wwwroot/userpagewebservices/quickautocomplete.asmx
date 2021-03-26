<%@ WebService Language="C#" CodeBehind="../../App_Code/userdetails.cs" Class="quickautocomplete" %>

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
public class quickautocomplete : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public void people(string searchkeyword)
    {
        List<userdetails> users = new List<userdetails>();

        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        //try
        //{
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("select DISTINCT top 10 userdata123.profilepic,userdata123.username,userdata123.name,userdata.profiletitle from [dbo].[userdata123] full outer join userdata on userdata123.username = userdata.username where userdata123.name like '" + searchkeyword + "%'  ", con);
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
                    if (name.Length > 22)
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

             JavaScriptSerializer js = new JavaScriptSerializer();
             js.MaxJsonLength = int.MaxValue;
             Context.Response.Write(js.Serialize(users));
    }

}