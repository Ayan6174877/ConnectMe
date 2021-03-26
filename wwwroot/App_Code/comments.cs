using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for comments
/// </summary>
public class comments
{
    public int commentid { get; set; }

    public string postid { get; set; }
    public string name { get; set; }
    public string username { get; set; }
    public string commentedby { get; set; }
    public string usertype { get; set; }
    public string profilepic { get; set; }
    public string coverpic { get; set; }
    public string companyname { get; set; }
    public string commenttime { get; set; }
    public string commentmessage { get; set; }
    public bool verified { get; set; }
}