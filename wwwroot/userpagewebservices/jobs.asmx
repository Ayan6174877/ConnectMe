<%@ WebService Language="C#" CodeBehind="~/App_Code/country.cs" Class="jobs" %>

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
public class jobs : System.Web.Services.WebService
{
    // loading the jobs

    [WebMethod(EnableSession = true)]
    public void loadjobs()
    {
        List<Jobs> jobsdata = new List<Jobs>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {

                SqlCommand cmd = new SqlCommand("select userdata123.profilepic,userdata123.name,userdata123.username,jobs.joblocation,jobs.date,jobs.jobtitle,jobs.id,jobs.jobtype from [dbo].[userdata123] INNER JOIN [dbo].[jobs] ON userdata123.username = jobs.username  order by jobs.id desc ", con);

                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        Jobs data = new Jobs();
                        data.jobid = sdr["id"].ToString();
                        data.companyname = sdr["name"].ToString();
                        data.jobtitle = sdr["jobtitle"].ToString();
                        data.joblocation = sdr["joblocation"].ToString();
                        data.jobtype = sdr["jobtype"].ToString();
                        data.date = sdr["date"].ToString();
                        object obj = sdr["profilepic"];
                        if (obj != DBNull.Value)
                        {
                            byte[] bytes = (byte[])obj;
                            string logo = Convert.ToBase64String(bytes);
                            data.profilepic = logo;
                        }
                        else
                        {
                            data.profilepic = null;
                        }

                        // checking if the user has already saved the job or not
                        SqlCommand cmdcheck = new SqlCommand("select id from [dbo].[savedjobs] where ( jobid = '"+ data.jobid +"' and savedby = '"+ Session["username"] +"' ) ", con);
                        SqlDataReader checkrdr = cmdcheck.ExecuteReader();
                        if (checkrdr.HasRows)
                        {
                            data.jobsaved = true;
                        }
                        else
                        {
                            data.jobsaved = false;
                        }

                        jobsdata.Add(data);
                    }

                    JavaScriptSerializer js = new JavaScriptSerializer();
                    js.MaxJsonLength = int.MaxValue;
                    Context.Response.Write(js.Serialize(jobsdata));
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

    [WebMethod(EnableSession = true)]
    public string savedjobcounts()
    {
        string text;
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {

            SqlCommand cmd = new SqlCommand("select count (id) from [dbo].[savedjobs] where (savedby = '" + Session["username"] + "' ) ", con);
            con.Open();
            text = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return text;
    }

    [WebMethod(EnableSession = true)]
    public string appliedjobcounts()
    {
        string text;
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(cs))
        {

            SqlCommand cmd = new SqlCommand("select count (id) from [dbo].[jobapplied] where (appliedby = '" + Session["username"] + "' ) ", con);
            con.Open();
            text = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return text;
    }
    // loading the savced jobs

    [WebMethod(EnableSession = true)]
    public void loadsavedjobs()
    {
        List<Jobs> jobsdata = new List<Jobs>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {

                SqlCommand cmd = new SqlCommand("select userdata123.profilepic,userdata123.name,userdata123.username,jobs.joblocation,jobs.date,jobs.jobtitle,jobs.id,jobs.jobtype from [dbo].[userdata123] INNER JOIN [dbo].[jobs] ON userdata123.username = jobs.username inner join [dbo].[savedjobs] ON savedjobs.jobid = jobs.id where (savedjobs.savedby = '" + Session["username"] + "' ) order by jobs.id desc ", con);

                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        Jobs data = new Jobs();
                        data.jobid = sdr["id"].ToString();
                        data.companyname = sdr["name"].ToString();
                        data.jobtitle = sdr["jobtitle"].ToString();
                        data.joblocation = sdr["joblocation"].ToString();
                        data.jobtype = sdr["jobtype"].ToString();
                        data.date = sdr["date"].ToString();
                        object obj = sdr["profilepic"];
                        if (obj != DBNull.Value)
                        {
                            byte[] bytes = (byte[])obj;
                            string logo = Convert.ToBase64String(bytes);
                            data.profilepic = logo;
                        }
                        else
                        {
                            data.profilepic = null;
                        }



                        jobsdata.Add(data);
                    }

                    JavaScriptSerializer js = new JavaScriptSerializer();
                    js.MaxJsonLength = int.MaxValue;
                    Context.Response.Write(js.Serialize(jobsdata));
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


    [WebMethod(EnableSession = true)]
    public void loadjobstatus()
    {
        List<Jobs> jobsdata = new List<Jobs>();
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {

                SqlCommand cmd = new SqlCommand("select userdata123.profilepic,userdata123.name,userdata123.username,jobs.joblocation,jobs.jobtitle,jobs.id,jobapplied.status,jobapplied.apllieddate from [dbo].[userdata123] full outer join [dbo].[jobapplied]  ON jobapplied.companyname = userdata123.username INNER JOIN [dbo].[jobs] ON userdata123.username = jobs.username inner join [dbo].[savedjobs] ON savedjobs.jobid = jobs.id where (jobapplied.appliedby = '" + Session["username"] + "' ) order by jobs.id desc ", con);

                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        Jobs data = new Jobs();
                        data.jobid = sdr["id"].ToString();
                        data.companyname = sdr["name"].ToString();
                        data.jobtitle = sdr["jobtitle"].ToString();
                        data.joblocation = sdr["joblocation"].ToString();
                        data.date = sdr["apllieddate"].ToString();
                        data.applicationstatus = sdr["status"].ToString();
                        object obj = sdr["profilepic"];
                        if (obj != DBNull.Value)
                        {
                            byte[] bytes = (byte[])obj;
                            string logo = Convert.ToBase64String(bytes);
                            data.profilepic = logo;
                        }
                        else
                        {
                            data.profilepic = null;
                        }



                        jobsdata.Add(data);
                    }

                    JavaScriptSerializer js = new JavaScriptSerializer();
                    js.MaxJsonLength = int.MaxValue;
                    Context.Response.Write(js.Serialize(jobsdata));
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

   [WebMethod(EnableSession = true)]
    public void savejob(string jobid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {

            SqlCommand cmd = new SqlCommand("insert into [dbo].[savedjobs](savedby,jobid) values ('" +  Session["username"] + "', '" + jobid + "' )", con);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }

   [WebMethod(EnableSession = true)]
    public void unsavejob(string jobid)
    {
        string cs = ConfigurationManager.ConnectionStrings["connection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("delete from [dbo].[savedjobs] where savedby = '" + Session["username"] + "' and jobid = '" + jobid + "' ", con);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }



    ////applying for the job
    //[System.Web.Services.WebMethod]
    //public static void applyjob(string jobid, string companyname)
    //{
    //    SqlConnection con = new SqlConnection(connStr);
    //    string status = "applied";
    //    SqlCommand cmd = new SqlCommand("insert into [dbo].[jobapplied](appliedby,companyname,jobid,status) values ('" + HttpContext.Current.Session["username"] + "','" + companyname + "' , '" + jobid + "' ,'" + status + "' )", con);
    //    con.Open();
    //    cmd.ExecuteNonQuery();

    //    con.Close();

    //}
    ////cancelling the job request
    //[System.Web.Services.WebMethod]
    //public static void canceljob(string jobid)
    //{
    //    SqlConnection con = new SqlConnection(connStr);
    //    SqlCommand cmd = new SqlCommand("delete from [dbo].[jobapplied] where jobid = '"+ jobid +"' and appliedby = '"+ HttpContext.Current.Session["username"] +"' ", con);
    //    con.Open();
    //    cmd.ExecuteNonQuery();

    //    con.Close();


    //}


}
