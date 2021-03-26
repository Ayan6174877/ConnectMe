<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="logging" %>

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
public class logging : System.Web.Services.WebService
{
    // loading and binding notification counts and working at locations for the company page

    [WebMethod(EnableSession = true)]
    public bool checkcredentials(string username , string password)
    {
        bool Isvalidcredential = false;
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {

            SqlCommand cmd1 = new SqlCommand("select username,password,usertype from [dbo].[userdata123] where ( username = '" + username.Trim() + "' COLLATE sql_latin1_general_cp1_cs_as or email = '" + username.Trim() + "' COLLATE sql_latin1_general_cp1_cs_as ) and Password= '" + password.Trim() + "' COLLATE sql_latin1_general_cp1_cs_as  ", con);
            con.Open();
            SqlDataReader rdr = cmd1.ExecuteReader();
            if (!rdr.HasRows)
            {
                Isvalidcredential = false;
            }
            else if (rdr.HasRows)
            {
                while (rdr.Read())
                {
                    Session["username"] = rdr["username"].ToString();
                    Session["usertype"] = rdr["usertype"].ToString();
                }

                rdr.Close();
                Isvalidcredential = true;
            }
            con.Close();
        }

        return Isvalidcredential;
    }

}
