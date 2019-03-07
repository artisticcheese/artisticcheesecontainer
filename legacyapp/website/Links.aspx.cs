using System;
using System.Collections;
using System.Text;
using System.Threading;

public partial class Links : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            lstLinks.DataSource = LinkList.GetAllLinks();
            lstLinks.DataBind();
        }
    }
    
}
public class Link
{
    public StringBuilder url = new StringBuilder(10000);
    public string name;

	public Link()
	{

	}

    public Link(string name, string url)
    {
        this.name = name;
        this.url.Append(url);
    }

    ~Link()
    {
        //some long running operation when cleaning up the data
        Thread.Sleep(5000);
    }
}
    public class LinkList{
    public LinkList()
    {
    }
    public static Hashtable GetAllLinks()
    {
        Hashtable links = new Hashtable();
        Link l = new Link("Debugging tools", "http://www.microsoft.com/whdc/devtools/debugging/default.mspx");
        links.Add(l.name, l.url);
        l = new Link("If broken it is, fix it you should", "http://blogs.msdn.com/Tess");
        links.Add(l.name, l.url);
        l = new Link("Speaking of which...", "http://blogs.msdn.com/johan");
        links.Add(l.name, l.url);
        l = new Link("A developers stayings", "http://blogs.msdn.com/carloc");
        links.Add(l.name, l.url);
        l = new Link("Notes from a dark corner", "http://blogs.msdn.com/dougste");
        links.Add(l.name, l.url);
        l = new Link("Cheshire's blog", "http://blogs.msdn.com/jamesche");
        links.Add(l.name, l.url);
        l = new Link("ASP.NET debugging", "http://blogs.msdn.com/tom");
        links.Add(l.name, l.url);
        l = new Link("Nico's weblog", "http://blogs.msdn.com/nicd");
        links.Add(l.name, l.url);
        l = new Link("Todd Carter's weblog", "http://blogs.msdn.com/toddca");
        links.Add(l.name, l.url);
        return links;
    }
}
