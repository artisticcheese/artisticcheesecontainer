<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:freb="http://schemas.microsoft.com/win/2006/06/iis/freb" xmlns:ev="http://schemas.microsoft.com/win/2004/08/events/event" xmlns="http://www.w3.org/1999/xhtml" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jsext="urn:schemas-microsoft-com:jsext" > 
<xsl:output method="html" media-type="text/html" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
<!-- saved from url=(0014)about:internet -->


<msxsl:script language="javascript" implements-prefix="jsext" >
    <![CDATA[
    
    function datediff(s, e)
    {
        var startDate = convertXMLDate(s);
        
        var endDate = convertXMLDate(e);
        return endDate - startDate;
    }
    
    function convertXMLDate(d)
    {
        
        var dateObj = new Date();
        
        var datepat = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}).(\d{3})Z$/;
        
        var match = datepat.exec(d);
        
        if ( match != null && match.length > 0 )
        {
            dateObj.setFullYear(match[1]);
            dateObj.setMonth(match[2]);
            dateObj.setDate(match[3]);
            dateObj.setHours(match[4]);
            dateObj.setMinutes(match[5]);
            dateObj.setSeconds(match[6]);
            dateObj.setMilliseconds(match[7]);
        }    
        
        return dateObj.getTime();
    }
    
    function formatDate(d)
    {
        
        var date = new Date(convertXMLDate(d));
        
        var strDate = new String();
        strDate = date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate();
        strDate = strDate + ", " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() + ":" + date.getMilliseconds();
        return strDate;
    }
        
]]>
</msxsl:script>
    
          
    <xsl:template name="Severity">
        <xsl:param name="Duration"/>
        <xsl:param name="DisplayInformational" select="0"/>
        <xsl:choose>
            <xsl:when test="./ev:System/ev:Level = 3"><div class="severity-warning"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Warning'"/></xsl:call-template></div></xsl:when>
            <xsl:when test="./ev:System/ev:Level = 2"><div class="severity-error"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Error'"/></xsl:call-template></div></xsl:when>
            <xsl:when test="./ev:System/ev:Level = 1"><div class="severity-critical"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CriticalError'"/></xsl:call-template></div></xsl:when>
            <xsl:when test="./ev:System/ev:Level = 5 and $DisplayInformational=1"><div class="severity-verbose"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Verbose'"/></xsl:call-template></div></xsl:when>
            <xsl:when test="./ev:System/ev:Level = 4 and $DisplayInformational=1"><div class="severity-informational"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Informational'"/></xsl:call-template></div></xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/">
    <html>
        <head>
            <xsl:text disable-output-escaping="yes">
                <![CDATA[<!-- saved from url=(0014)about:internet -->]]>
            </xsl:text>
            <title><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'RequestDiagnostics'"/></xsl:call-template><xsl:value-of select="./failedRequest/@url"/>, STATUS_CODE <xsl:value-of select="./failedRequest/@statusCode"/>, <xsl:value-of select="./failedRequest/@timeTaken"/> ms, <xsl:value-of select="./failedRequest/@verb"/> </title>

            <style type="text/css">            
               <xsl:text disable-output-escaping="yes"><![CDATA[
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    HTML TAGS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
body.iistraceinfo { 
    margin:0;
    padding:0;
    font-size:.7em;
    font-family:Verdana, Arial, Helvetica, sans-serif;
    background-color:white;
    }

fieldset {
    padding:2 0px 1px 1px;
    margin:8px;
    position:relative;
    }

.summary-container fieldset {
    padding-bottom:5px;
    margin-top:4px;
    }
    
fieldset fieldset {
    padding:2px 0px 1px 10px;
    margin:10px 0;
    }

.no-border {
    border: none;
    }


legend {
    color:#333333;
    padding:10px 20px 10px 9.5em;
    margin:0 0 5px 0;
    }

legend.no-expand-all {
    padding:2px 15px 4px 10px;
    margin:0 0 0 -12px;
    }

.summary-container legend {
    -moz-border-radius: 5px;
    border-radius: 5px;
    color:#333333;
    padding:4px 15px 4px 10px;
    margin:4px 0 0 12px;
    _margin-top:0px; /* IE 6 will read this only */
    border-top:1px solid #EDEDED;
    border-left:1px solid #EDEDED;
    border-right:1px solid #969696;
    border-bottom:1px solid #969696;
    background:#E7ECF0;
    font-weight:bold;
    font-size:1em;
    }

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    HEADINGS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
h1 { 
    font-size:1.2em;
    margin:0;
    word-wrap:break-word;
    text-align:left;
    }
    
h2 { 
    font-size:1.1em;
    margin:0 0 0 0;
    display:inline;
    }

.summary-container h2 {
    margin-bottom:-17px;
    }

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    LINKS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
a:link, a:visited { 
    color:#007EFF;
    font-weight:bold;
    text-decoration:none;
    }
    
a:hover { 
    text-decoration:underline; 
    }
    
a .expand-collapse {
    text-decoration:none;
    }


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    HEADER
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#header { 
    width:95%;
    margin:0 0 0 0;
    padding:6px 2% 6px 3%;
    font-family:"trebuchet MS", Verdana, sans-serif;
    color:#FFF;
    background-color:#5C87B2;
    text-align:right;
    }

#header p {
    margin:1px 0 1px 0;
    padding:0;
    font-size:1.2em;
    font-weight:bold;
    }

#header a {
    color:#F1F7FC;
    }

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    MENU
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#menu_container,
#sub_menu_container { 
    width:98%;
    _height:44px;
    min-height:44px;
    margin:0 0 5px 0;
    padding:8px 0 0 2%;
    color:#FFFFFF;
    background-color:#5C87B2;
    /*background-color:#5A7FA5;*/
    border-bottom:1px dotted #C1CFDD;
    border-top:1px dotted #4A6C8E;
/*    progid:DXImageTransform.Microsoft.Gradient(gradientType=0,startColorStr=#AABDD0,endColorStr=#125295);
*/    position:relative;    
    }
    
#menu_container ul,
#sub_menu_container ul {
    margin:0;
    }
    
#menu_container li,
#sub_menu_container li {
    list-style:none;
    float:left;
    position:relative;
    text-align:center;
    }

#menu_container a:link,
#menu_container a:visited,
#sub_menu_container a:link,
#sub_menu_container a:visited {
    color:#fff;
    display:block;
    _height:24px;
    min-height:24px;
    padding:5px 10px 4px 10px;
    float:left;
    text-align:center;
    font-weight:bold;
    font-size:.9em;
    text-decoration:none;
    border:1px dotted #224870;
    }
    
#menu_container a.active:link,
#menu_container a.active:visited,
#sub_menu_container a.active:link,
#sub_menu_container a.active:visited,
#sub_menu_container a.parent-tab-highlight:link,
#sub_menu_container a.parent-tab-highlight:visited {
    color:#000;
    border-top:1px solid #224870;
    background:#B3CAD9;
    padding-bottom:3px;
    _height:35px;
    min-height:35px;
    }

#menu_container a#viewErrors:link,
#menu_container a#viewErrors:visited,
#sub_menu_container a#viewDetails:link,
#sub_menu_container a#viewDetails:visited {
    border-left:1px solid #224870;
    }

#menu_container a:hover,
#sub_menu_container a:hover {
    text-decoration:underline;
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    SUB MENU SPECIFIC STYLES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#sub_menu_container { 
    margin:-10px 0 5px 0;
    border-top:none;
    background-color:#B3CAD9;
    }

#sub_menu_container a.active:link,
#sub_menu_container a.active:visited {
    background-color:white;
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    TABLES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
td,
th { 
    vertical-align:top;
    padding:1px; 
    text-align:left;
    }

thead th {
    background-color:#5C81A7;
    }

table {
    margin:8px 0 4px 0;
    }

table.request-summary {
    margin:0px 0 5px 0;
    }

table.column-1 {
    width:55%;
    }

table.column-2 {
    float:right;
    width:43%;
    }
        
.request-summary th {
    width:28%;
    text-align:left;
    white-space:nowrap;
    }
    
table.column-2 th {
    width:48%;
    }

/* REQUEST SUMMARY TABLE */

.request-summary td,
.request-summary th {
    padding:3px 6px;
    font-weight:normal; 
    }

.request-summary th {
    color:#808080;
    font-weight:bold; 
    text-align:right;
    }

.request-summary tr.alt td, 
.request-summary tr.alt th { 
    background-color:#F8F8F8; 
    }
    
table tr.alt td, 
table tr.alt th { 
    background-color:#F8F8F8;
    }
     
fieldset fieldset table tr.alt td, 
fieldset fieldset table tr.alt th { 
    background-color:transparent;
}     
     
/* columns */

td.col-number,
th.col-number {
    width:35px;
    }

td.col-actions,
th.col-actions {
    width:65px;
    }

td.col-view,
th.col-view {
    width:65px;
    }

td.col-severity,
th.col-severity {
    width:70px;
    }
    
td.col-event,
th.col-event {
    }

td.col-notification,
th.col-notification {
    }
    
td.col-name,
th.col-name {
    width:35%;
    }

td.col-filter-module,
th.col-filter-module {
    width:35%;
    }

td.col-duration,
th.col-duration {
    width:65px;
    text-align:center;
    font-weight:bold;
    }

td.event-data {
    word-wrap:break-word;
    word-break:break-all;
    white-space:pre-wrap;
    }
td.event-name {
    word-wrap:break-word;
    word-break:break-all;
    }
.pre-event-data {
    font-family:Verdana, Arial, Helvetica, sans-serif;
    font-size:1em;
    margin-bottom:0px;
    white-space:pre;
    word-wrap:break-word;
    }
td.col-uri,
th.col-uri {
    width:30%;
    }

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    NESTED TABLES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/* NESTED TABLE CELLS */
table table tr td,
table table tr th,
table table tr.alt td,
table table tr.alt th { 
    background-color:#FFF;
    }

/* NESTED TABLE CELLS in ALT PARENT ROWS */
table tr.alt table tr td,
table tr.alt table tr th,
table tr.alt table tr.alt td,
table tr.alt table tr.alt th { 
    background-color:white; /*just changed*/
    }
    
/* NESTED TABLE TH HEADERS */
table table th,
fieldset fieldset table th{  
    font-weight:normal;
    width:40%;
    text-align:right;
    color:#808080;
    padding-right:8px;
    }
    
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    SORTABLE TABLES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
table.sortable a.sortheader { 
    display:block; 
    color:#FFF;
    }
    
table.sortable span.sortarrow { 
    color:#FFF; 
    text-decoration:none; 
    font-size:1.2em;
    }   

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    SEVERITY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
.severity-critical,
.severity-error,
.severity-warning,
.severity-failed,
.severity-informational,
.severity-verbose {
    font-family:"Courier New", Courier, monospace;
    color:#990000;
    font-weight:bold;
    padding:0 10px;
    font-size:1.2em;
    line-height:1.1em;
    }
    
.severity-critical {
    background:#990000;
    border:3px solid #990000;
    text-transform:uppercase;
    color:#FFF;
    }

.severity-error {
    background:#FFE4CC;
    border:3px solid #990000;
    text-transform:uppercase;
    }

.severity-warning {
    background:#FFFFCC;
    border:1px solid #CD8282;
    }

.severity-failed {
    background:#E4FAC8;
    font-style:italic;
    color:#BB7700;
    }
    
.severity-informational {
    color:#B0B0B0;
    }

.severity-verbose {
    color:#919191;
    }

/* STYLES WHEN INSIDE A TABLE COLUMN */
td .severity-critical,
td .severity-error,
td .severity-warning,
td .severity-failed,
td .severity-informational,
td .severity-verbose {
    display:block;
    width:6em;
    text-align:center;
    padding:4px 2px;
    margin-left:0;
    font-size:1.1em;
    float:left;
    }

/* STYLES WHEN INSIDE THE COMPLETE TRACE*/
fieldset div.severity-critical,
fieldset div.severity-error,
fieldset div.severity-warning,
fieldset div.severity-failed,
fieldset div.severity-informational,
fieldset div.severity-verbose  {
    float:right;
    width:11em;
    text-align:left;
    padding:1px 2px;
    font-size:1.1em;
    }

/* SOME HAVE THICK BORDERS SO WE RE-STYLE THEM */
fieldset div.severity-critical,
fieldset div.severity-error {
    top:1px;
    text-align:center;
    }

fieldset div.severity-warning {
    top:2px;
    text-align:center;
    }

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
    MISC STYLES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
.summary-container,
.content-container {
    background:#FFF;
    width:98%;
    margin:8px 0 0 1%;
    padding:0 0 1px 0;
    position:relative;
    }

div.outer { 
    width:90%; 
    margin:15px;
    }
    
div.buffer {
    padding-top:7px; 
    padding-bottom:17px; 
    }
    
.small { 
    font-size:.9em; 
    }
    
div.hidden { 
    display:none 
    }
    
.highlight {
    background-color:Yellow;
    }

.tinylink {
    font-size:.9em;
    }

.no-data {
    background:#B3CAD9;
    font-family:Verdana, Arial, Helvetica, sans-serif;
	color:black;
    font-weight:bold;
    padding:5px;
    text-align:center;
    font-style:italic;
    }
    
.expand-collapse {
    font-family:"Courier New", Courier, monospace;
    font-weight:bold;
    padding:0 6px 0 0;
    font-size:1.2em;
    text-decoration:none;
    }

.expand-collapse-all {
    font-size:1em;
    color:#333333;
    padding:3px 12px 3px 10px;
    border-top:1px solid #EDEDED;
    border-left:1px solid #EDEDED;
    border-right:1px solid #969696;
    border-bottom:1px solid #969696;
    background:#E7ECF0;
    font-weight:bold;
    font-size:1.1em;
    position:absolute;
    top:5px;
    left:20px;
    z-index:100;
    text-decoration:none;
    }

.duration {
    float:right;
    width:6em;
    text-align:right;
    padding:1px 5px 0 0;
    margin-left:25px;
    }

.duration-value {
    font-size:.9em;
    }

span.iistraceinfo { background-color:white; color:black;font-size:1em; word-wrap: break-word; }
span.iistraceinfo table { font-size:1em; cellspacing:0; cellpadding:0; margin-bottom:25; width:95%;}
span.iistraceinfo tr.subhead { background-color:cccccc;}
span.iistraceinfo th { padding:0,3,0,3 }
span.iistraceinfo td { padding:0,30,0,3;white-space:pre;word-wrap: break-word;white-space: pre-wrap;}
span.iistraceinfo tr.alt { background-color:F8F8F8; color:black }
span.iistraceinfo a:hover { color:darkblue;text-decoration:none; }
span.iistraceinfo table td { padding-right:20 }
]]></xsl:text>
</style>

<script type="text/javascript">
<xsl:text disable-output-escaping="yes"><![CDATA[
                //addEvent(window, "unload", backCheck);
                var lastSectionName = null;
                var lastTabName = null;
                var currentSectionName = null;
                var currentTabName = null;
                /*function backCheck(e)
                {
                    if ( lastSectionName != null )
                    {
                        alert("loc: " + window.location);
                        window.location.replace(window.location + "?sectionName=" + lastSectionName + "&tabName=" + lastTabName);
                    }
                }*/
                var styles = new Object();

                function toggleDiv(divId, expand)
                {
                    var d = window.document.getElementById(divId + '_details');
                    var i = window.document.getElementById(divId + '_button');
              
                    if( expand == null || typeof(expand) == 'undefined' )
                        expand = (d.style.display == 'block'?false:true);
              
                    if ( expand )
                    {
                        d.style.display = 'block';
                        i.innerHTML = "-";
                    }
                    else
                    {
                        d.style.display = 'none';
                        i.innerHTML = "+";
                    }
                }
            
                function toggleAll(expandAllText, collapseAllText, sectionId)
                {
                    var currentState = null;
                    var expand = true;

  
                    // Determine the current state.
                    eval("currentState = window." + sectionId + "_expand;");
                    if ( currentState == null )
                        expand = false; // default state is now expand
                    else if ( currentState == false )
                        expand = true;
                    else
                        expand = false;
    
                    expandAll(expandAllText, collapseAllText, sectionId, expand);
                    
                    eval("window." + sectionId + "_expand = " + expand + ";");
                }
            
                function expandAll(expandAllText, collapseAllText, sectionId, expand)
                {

                    var expandButton = window.document.getElementById(sectionId + "_button");
                    var indexElements = null;
                    
                    if ( sectionId == "section_detail" )
                        indexElements = window.document.getElementsByTagName("fieldset");
                    else
                        indexElements = window.document.getElementsByTagName("tr");

                    
                    for ( var i = 0; i < indexElements.length; i++)
                    {
                        if ( indexElements[i].id && indexElements[i].id.indexOf(sectionId) >= 0 )
                            toggleDiv(indexElements[i].id, expand);
                    }
                    
                    if ( expandButton && expandButton.innerHTML)
                        if ( expand == true )
                            expandButton.innerHTML = "<span class='expand-collapse'>-</span>" + collapseAllText;
                        else
                            expandButton.innerHTML = "<span class='expand-collapse'>+</span>" + expandAllText;
                }
            
                function findInDetail(indexNumber)
                {
                    // Change the report to "All Events"
                    setView('section_detail', 'viewDetails');
                    
                    // Navigate to the indexNumber anchor.
                    
                    window.location.replace("#detail_" + indexNumber);
                    
                    //Fat.fade_element(id, fps, duration, from, to)                                                         
                    Fat.fade_element('section_detail_' + indexNumber, null, null, '#ffff66', '#ffffff' );
                }

                var currentView = null;
                var currentTabId = null;
                function setView(divId, tabId)
                {
                    
                    lastSectionName = currentSectionName;
                    lastTabName = currentTabName;
                    currentSectionName = divId;
                    currentTabName = tabId;
                    // Get the value of the radioReportOptions radio.
                    //var rg = window.document.getElementsByName("radioView");
                    var currentViewElement = null;
                    var currentTabElement = null;
                    var selectedViewElement = null;
                    var selectedTabElement = null;
                    var requestDetailsElement = window.document.getElementById('sub_menu_container');
                    var requestDetailsTab = window.document.getElementById('requestDetails');
                    var requestSummary = window.document.getElementById('section_generalinformation');
                    
                    switch( divId )
                    {
                    case "section_errors":
                    case "section_compact":
                        if ( requestDetailsElement )
                            requestDetailsElement.style.display = 'none';
                        if ( requestDetailsTab )
                            requestDetailsTab.className = "";
                        break;
                    case "section_detail":
                        if ( requestDetailsElement )
                            requestDetailsElement.style.display = 'block';
                        if ( requestDetailsTab )
                            requestDetailsTab.className = "active";
                        break;
                    }
              
                    // Hide the current view.
                    if ( currentView != null && currentTabId != null )
                    {
                        currentViewElement = window.document.getElementById(currentView);
                        currentTabElement = window.document.getElementById(currentTabId);
                        if ( currentViewElement )
                            currentViewElement.style.display = 'none';
                        if ( currentTabElement )
                            currentTabElement.className = "";
                    }
                    
                    // Show the selected view.
                    selectedViewElement = window.document.getElementById(divId);
                    selectedTabElement = window.document.getElementById(tabId);
                    
                    if ( selectedViewElement )
                        selectedViewElement.style.display = 'block';
              
                    selectedTabElement.className = "active";
              
                    switch( divId )
                    {
                    case "section_errors":
                        if ( requestSummary )
                            requestSummary.style.display = 'block';
                        //toggleDiv("section_generalinformation", true);
                        break;
                    case "section_compact":
                    case "section_detail":
                        if ( requestSummary )
                            requestSummary.style.display = 'none';
                        //toggleDiv("section_generalinformation", false);
                        break;
                    }
              
                    currentView = divId;
                    currentTabId = tabId;
                }
            
                function load()
                {   
                    // If there is a section that needs to be viewed, show it.
                    /*alert("search: " + window.location.search);
                    if ( window.location.search.indexOf("sectionName", 0) >= 0 )
                    {
                        var nv = window.location.search.split('&');
                        var sn = nv[0].split('=')[1];
                        var tn = nv[1].split('=')[1];
                        alert("sn: " + sn + ", tn: " + tn);
                        setView(sn, tn);
                        return;
                    }
                    alert("test2");*/
                    setView('section_errors','viewErrors');
                }
            
                // Sort Table
                addEvent(window, "load", sortables_init);

                var SORT_COLUMN_INDEX;

                function sortables_init() {
                        // Find all tables with class sortable and make them sortable
                        if (!document.getElementsByTagName) return;
                        tbls = document.getElementsByTagName("table");
                        for (ti=0;ti<tbls.length;ti++) {
                                thisTbl = tbls[ti];
                                if (((' '+thisTbl.className+' ').indexOf("sortable") != -1) && (thisTbl.id)) {
                                        //initTable(thisTbl.id);
                                        ts_makeSortable(thisTbl);
                                }
                        }
                
                        //alert("boo: " + window.document.getElementById('defaultsortme'));
                        //ts_resortTable(window.document.getElementById('defaultsortme'), '0'), 
                }

                function ts_makeSortable(table) {
                        var defaultCell = null
                        var defaultIndex = null;
                        
                        if (table.rows && table.rows.length > 0) {
                                var firstRow = table.rows[0];
                        }
                        if (!firstRow) return;
                
                        // We have a first row: assume it's the header, and make its contents clickable links
                        for (var i=0;i<firstRow.cells.length;i++) {
                                var cell = firstRow.cells[i];
                                var txt = ts_getInnerText(cell);
                                /*cell.innerHTML = '<a href="#" class="sortheader" '+ 
                                'onclick="ts_resortTable(this, '+i+');return false;" alt="Sort By This Column">' + 
                                txt+'<span class="sortarrow">&nbsp;</span></a>';*/
                                
                                // BDG: Added default sort direction: desc class for descending.
                                if ( (' '+cell.className+' ').indexOf("desc") != -1 )
                                {
                                    cell.innerHTML = '<a href="#" class="sortheader" '+ 
                                    'onclick="ts_resortTable(this, '+i+');return false;" alt="Sort By This Column">' + 
                                    txt+'<span class="sortarrow" sortdir="down">&nbsp;</span></a>';
                                }
                                else
                                {
                                    cell.innerHTML = '<a href="#" class="sortheader" '+ 
                                    'onclick="ts_resortTable(this, '+i+');return false;" alt="Sort By This Column">' + 
                                    txt+'<span class="sortarrow">&nbsp;</span></a>';
                                }
                                
                                if ( (' '+cell.className+' ').indexOf("defaultsort") != -1 )
                                {
                                    defaultCell = cell;
                                    defaultIndex = i;
                                    var span;
                                    // Mark default sorted column in table with down arrow symbol
                                    for (var ci=0;ci<defaultCell.firstChild.childNodes.length;ci++) 
                                    {
                                        if (defaultCell.firstChild.childNodes[ci].tagName && defaultCell.firstChild.childNodes[ci].tagName.toLowerCase() == 'span') 
                                        {
                                            span = defaultCell.firstChild.childNodes[ci];
                                            span.setAttribute('sortdir','down');
                                            span.innerHTML = '&darr;';
                                        }
                                    }

                                }
                        }
                
                        // ts_makeSortable gets called on page load, so don't sort tables here.
                        // If sorting happens here, page load time goes up.
                        //if ( defaultCell)
                        //    ts_resortTable(defaultCell.firstChild, defaultIndex);
                }

                function ts_getInnerText(el) {
                    if (typeof el == "string") return el;
                    if (typeof el == "undefined") { return el };
                    if (el.innerText) return el.innerText;    //Not needed but it is faster
                    var str = "";
                
                    var cs = el.childNodes;
                    var l = cs.length;
                    for (var i = 0; i < l; i++) {
                        switch (cs[i].nodeType) {
                            case 1: //ELEMENT_NODE
                                str += ts_getInnerText(cs[i]);
                                break;
                            case 3:    //TEXT_NODE
                                str += cs[i].nodeValue;
                                break;
                        }
                    }
                    return str;
                }

                function ts_resortTable(lnk,clid) {
                        // get the span
                        var span;
                        for (var ci=0;ci<lnk.childNodes.length;ci++) {
                                if (lnk.childNodes[ci].tagName && lnk.childNodes[ci].tagName.toLowerCase() == 'span') span = lnk.childNodes[ci];
                        }
                        var spantext = ts_getInnerText(span);
                        var td = lnk.parentNode;
                        var column = clid || td.cellIndex;
                        var table = getParent(td,'TABLE');
                
                        // Work out a type for the column
                        if (table.rows.length <= 1) return;
                        var itm = ts_getInnerText(table.rows[1].cells[column]);
                        sortfn = ts_sort_caseinsensitive;
                        if (table.className.indexOf("col-number") != -1) {
                        	sortfn =ts_sort_numeric;
                      	}
                        else if (itm.match(/^\d\d[\/-]\d\d[\/-]\d\d\d\d$/)) {
                            sortfn = ts_sort_date;
                        }
                        else if (itm.match(/^\d\d[\/-]\d\d[\/-]\d\d$/)) {
                            sortfn = ts_sort_date;
                        }
                        else if  (itm.match(/^[\d\.]+$/) || itm == "<!--EmptyNumber-->" ) {
                            sortfn = ts_sort_numeric;
                        }
                        
                        SORT_COLUMN_INDEX = column;
                        var firstRow = new Array();
                        var newRows = new Array();
                        for (i=0;i<table.rows[0].length;i++) { firstRow[i] = table.rows[0][i]; }
                        for (j=1;j<table.rows.length;j++) { newRows[j-1] = table.rows[j]; }

                        newRows.sort(sortfn);

                        if (span.getAttribute("sortdir") == 'down') {
                                ARROW = '&uarr;';
                                newRows.reverse();
                                span.setAttribute('sortdir','up');
                        } else {
                                ARROW = '&darr;';
                                span.setAttribute('sortdir','down');
                        }
                        
                        // BDG: Set the 'alt' class.
                        for ( i = 0; i < newRows.length; i++ )
                        {
                            if ( i % 2 == 0 )
                                newRows[i].className = "alt";
                            else
                                newRows[i].className = ""
                        }
                
                        // We appendChild rows that already exist to the tbody, so it moves them rather than creating new ones
                        // don't do sortbottom rows
                        for (i=0;i<newRows.length;i++) { if (!newRows[i].className || (newRows[i].className && (newRows[i].className.indexOf('sortbottom') == -1))) table.tBodies[0].appendChild(newRows[i]);}
                        // do sortbottom rows only
                        for (i=0;i<newRows.length;i++) { if (newRows[i].className && (newRows[i].className.indexOf('sortbottom') != -1)) table.tBodies[0].appendChild(newRows[i]);}
                
                        // Delete any other arrows there may be showing
                        var allspans = document.getElementsByTagName("span");
                        for (var ci=0;ci<allspans.length;ci++) {
                                if (allspans[ci].className == 'sortarrow') {
                                        if (getParent(allspans[ci],"table") == getParent(lnk,"table")) { // in the same table as us?
                                                allspans[ci].innerHTML = '&nbsp;&nbsp;&nbsp;';
                                        }
                                }
                        }
                    
                        span.innerHTML = ARROW;
                }

                function getParent(el, pTagName) {
                    if (el == null) return null;
                    else if (el.nodeType == 1 && el.tagName.toLowerCase() == pTagName.toLowerCase())    // Gecko bug, supposed to be uppercase
                        return el;
                    else
                        return getParent(el.parentNode, pTagName);
                }
                function ts_sort_date(a,b) {
                        // y2k notes: two digit years less than 50 are treated as 20XX, greater than 50 are treated as 19XX
                        aa = ts_getInnerText(a.cells[SORT_COLUMN_INDEX]);
                        bb = ts_getInnerText(b.cells[SORT_COLUMN_INDEX]);
                        if (aa.length == 10) {
                                dt1 = aa.substr(6,4)+aa.substr(3,2)+aa.substr(0,2);
                        } else {
                                yr = aa.substr(6,2);
                                if (parseInt(yr) < 50) { yr = '20'+yr; } else { yr = '19'+yr; }
                                dt1 = yr+aa.substr(3,2)+aa.substr(0,2);
                        }
                        if (bb.length == 10) {
                                dt2 = bb.substr(6,4)+bb.substr(3,2)+bb.substr(0,2);
                        } else {
                                yr = bb.substr(6,2);
                                if (parseInt(yr) < 50) { yr = '20'+yr; } else { yr = '19'+yr; }
                                dt2 = yr+bb.substr(3,2)+bb.substr(0,2);
                        }
                        if (dt1==dt2) return 0;
                        if (dt1<dt2) return -1;
                        return 1;
                }

                function ts_sort_numeric(a,b) { 
                        aa = parseFloat(ts_getInnerText(a.cells[SORT_COLUMN_INDEX]));
                        //if (isNaN(aa)) aa = 0;
                        if (isNaN(aa))
                            return 1;
                        bb = parseFloat(ts_getInnerText(b.cells[SORT_COLUMN_INDEX])); 
                        //if (isNaN(bb)) bb = -1;
                        if (isNaN(bb))
                            return -1;
                        return aa-bb;
                }

                function ts_sort_caseinsensitive(a,b) {
                        aa = ts_getInnerText(a.cells[SORT_COLUMN_INDEX]).toLowerCase();
                        bb = ts_getInnerText(b.cells[SORT_COLUMN_INDEX]).toLowerCase();
                        if (aa==bb) return 0;
                        if (aa<bb) return -1;
                        return 1;
                }

                function ts_sort_default(a,b) {
                        aa = ts_getInnerText(a.cells[SORT_COLUMN_INDEX]);
                        bb = ts_getInnerText(b.cells[SORT_COLUMN_INDEX]);
                        if (aa==bb) return 0;
                        if (aa<bb) return -1;
                        return 1;
                }


                function addEvent(elm, evType, fn, useCapture)
                // addEvent and removeEvent
                // cross-browser event handling for IE5+,  NS6 and Mozilla
                // By Scott Andrew
                {
                    if (elm.addEventListener){
                        elm.addEventListener(evType, fn, useCapture);
                        return true;
                    } else if (elm.attachEvent){
                        var r = elm.attachEvent("on"+evType, fn);
                        return r;
                    } else {
                        alert("Handler could not be removed");
                    }
                } 
                
                /*  FADE METHODS */
                var Fat = {
                    make_hex : function (r,g,b) 
                    {
                        r = r.toString(16); if (r.length == 1) r = '0' + r;
                        g = g.toString(16); if (g.length == 1) g = '0' + g;
                        b = b.toString(16); if (b.length == 1) b = '0' + b;
                        return "#" + r + g + b;
                    },
                    fade_all : function ()
                    {
                        var a = document.getElementsByTagName("*");
                        for (var i = 0; i < a.length; i++) 
                        {
                            var o = a[i];
                            var r = /fade-?(\w{3,6})?/.exec(o.className);
                            if (r)
                            {
                                if (!r[1]) r[1] = "";
                                if (o.id) Fat.fade_element(o.id,null,null,"#"+r[1]);
                            }
                        }
                    },
                    fade_element : function (id, fps, duration, from, to) 
                    {
                        if (!fps) fps = 30;
                        if (!duration) duration = 3000;
                        if (!from || from=="#") from = "#FFFF33";
                        if (!to) to = this.get_bgcolor(id);
                        
                        var frames = Math.round(fps * (duration / 1000));
                        var interval = duration / frames;
                        var delay = interval;
                        var frame = 0;
                        
                        if (from.length < 7) from += from.substr(1,3);
                        if (to.length < 7) to += to.substr(1,3);
                        
                        var rf = parseInt(from.substr(1,2),16);
                        var gf = parseInt(from.substr(3,2),16);
                        var bf = parseInt(from.substr(5,2),16);
                        var rt = parseInt(to.substr(1,2),16);
                        var gt = parseInt(to.substr(3,2),16);
                        var bt = parseInt(to.substr(5,2),16);
                        
                        var r,g,b,h;
                        while (frame < frames)
                        {
                            r = Math.floor(rf * ((frames-frame)/frames) + rt * (frame/frames));
                            g = Math.floor(gf * ((frames-frame)/frames) + gt * (frame/frames));
                            b = Math.floor(bf * ((frames-frame)/frames) + bt * (frame/frames));
                            h = this.make_hex(r,g,b);
                        
                            setTimeout("Fat.set_bgcolor('"+id+"','"+h+"')", delay);

                            frame++;
                            delay = interval * frame; 
                        }
                        setTimeout("Fat.set_bgcolor('"+id+"','"+to+"')", delay);
                    },
                    set_bgcolor : function (id, c)
                    {
                        var o = document.getElementById(id);
                        o.style.backgroundColor = c;
                    },
                    get_bgcolor : function (id)
                    {
                        var o = document.getElementById(id);
                        while(o)
                        {
                            var c;
                            if (window.getComputedStyle) c = window.getComputedStyle(o,null).getPropertyValue("background-color");
                            if (o.currentStyle) c = o.currentStyle.backgroundColor;
                            if ((c != "" && c != "transparent") || o.tagName == "BODY") { break; }
                            o = o.parentNode;
                        }
                        if (c == undefined || c == "" || c == "transparent") c = "#FFFFFF";
                        var rgb = c.match(/rgb\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)/);
                        if (rgb) c = this.make_hex(parseInt(rgb[1]),parseInt(rgb[2]),parseInt(rgb[3]));
                        return c;
                    }
                }
            
            ]]>
 </xsl:text>
 </script>
    
        </head>
        <body class="iistraceinfo" onload="load();">
            <div id="header">
                <h1>Request Diagnostics for <xsl:value-of select="./failedRequest/@verb"/> <xsl:text xml:space="preserve"> </xsl:text>
                  <a><xsl:attribute name="href">
                  <xsl:value-of select="./failedRequest/@url"/></xsl:attribute><xsl:value-of select="./failedRequest/@url"/></a></h1>
              <!--p> STATUS_CODE <xsl:value-of select="./failedRequest/@statusCode"/>, <xsl:value-of select="./failedRequest/@timeTaken"/> ms, <xsl:value-of select="./failedRequest/@verb"/> (<xsl:value-of select="jsext:formatDate(string(./failedRequest/ev:Event/ev:System/ev:TimeCreated[1]/@SystemTime))"/>)</p-->
            </div>
            <xsl:choose>
               <xsl:when test="function-available('jsext:datediff')">
			     <!-- jsext:datediff presence is s trigger for complex tracing report -->
                 <div id="menu_container">
                     <ul>
                         <li><a href="javascript:setView('section_errors', 'viewErrors');" id="viewErrors" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'RequestSummary'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_detail', 'viewDetails');" id="requestDetails" class="parent-tab-highlight"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'RequestDetails'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_compact', 'viewCompact');" id="viewCompact" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CompactView'"/></xsl:call-template></a></li>
                     </ul>
                 </div>
                 <div id="sub_menu_container" >
                     <ul>
                         <li><a href="javascript:setView('section_detail', 'viewDetails');" id="viewDetails" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CompleteRequestTrace'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_filters', 'viewModules');" id="viewModules" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'FilterNotifications'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_notifications', 'viewNotifications');" id="viewNotifications" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ModuleNotifications'"/></xsl:call-template><br />
                             </a></li>
                         <li><a href="javascript:setView('section_perf', 'viewPerf');" id="viewPerf" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'PerformanceView'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_auth', 'viewAuth');" id="viewAuth" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'AuthenticationAuthorization'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_aspx', 'viewAsp');" id="viewAsp" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ASPPageTrace'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_modtrace', 'viewModTrace');" id="viewModTrace" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CustomModuleTrace'"/></xsl:call-template></a></li>
                         <li><a href="javascript:setView('section_fastcgi', 'viewfastcgi');" id="viewfastcgi" ><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'fastcgi'"/></xsl:call-template></a></li>
                     </ul>
                 </div>
                 <xsl:call-template name="GeneralInformation"/>
                 
                 <div class="content-container">
                     <xsl:call-template name="ErrorsAndWarnings"/>
                     <xsl:call-template name="CompactViewTemplate"/>
                     <xsl:call-template name="Performance" />
                     <xsl:call-template name="CompleteRequestTrace"/>
                     <xsl:call-template name="Notifications"/>
                     <xsl:call-template name="Filters"/>
                     <xsl:call-template name="Authentication"/>
                     <xsl:call-template name="ASPX"/>
                     <xsl:call-template name="ManagedModules"/>
                     <xsl:call-template name="fastcgi"/>
                 </div>
              </xsl:when>
			  <xsl:otherwise>
			     <xsl:call-template name="GeneralInformation"/>
			     <xsl:call-template name="ErrorsAndWarnings"/>
			     <div class="content-container">
	   			     <!--provide simple report - the compact view which doesn't need any scripts -->
				     <xsl:call-template name="CompactViewTemplate">
				          <!--setting ClassMode to block will make it visible by default-->
				          <xsl:with-param name="IdName" select="section_compact_minimal_mode"/>
				          <xsl:with-param name="DisplayMode" select="block"/>
				     </xsl:call-template>
                 </div>
			  </xsl:otherwise>
			</xsl:choose>

        </body>
    </html>
</xsl:template>
    
<xsl:template name="GeneralInformation">
    <div id="section_generalinformation" class="summary-container">
        <fieldset>
        <h2>
            <legend> <a href="javascript:toggleDiv('section_generalinformation');"><span id="section_generalinformation_button" class="expand-collapse">-</span>Request Summary</a></legend>
        </h2>
        <div id="section_generalinformation_details">
            <table class="request-summary column-2" border="0" cellpadding="0" cellspacing="0">
                <tr class="alt">
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Site'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@siteId" /></td>
                </tr>
                <tr>
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Process'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@processId" /></td>
                </tr>
                <tr class="alt">
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'FailureReason'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@failureReason" /></td>
                </tr>
                <tr>
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'TriggerStatus'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@triggerStatusCode" /></td>
                </tr>
                <tr class="alt">
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'FinalStatus'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@statusCode" /></td>
                </tr>
                <tr>
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'TimeTaken'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@timeTaken" /> msec</td>
                </tr>
            </table>
            <table class="request-summary column-1" cellspacing="0" cellpadding="0" border="0">
                <tr class="alt">
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Url'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@url" /></td>
                </tr>
                <tr>
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'App Pool'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@appPoolId" /></td>
                </tr>
                <tr class="alt">
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Authentication'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@authenticationType" /></td>
                </tr>
                <tr>
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'User from token'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@tokenUserName" /></td>
                </tr>
                <tr class="alt">
                    <th><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Activity ID'"/></xsl:call-template></th>
                    <td><xsl:value-of select="./failedRequest/@activityId" /></td>
                </tr>
            </table>
        </div>
        </fieldset>
    </div>
</xsl:template>
    
<xsl:template name="EventDetail">
    <xsl:param name="SectionName"/>
    <xsl:param name="Position" select="position()"/>
    <xsl:param name="DisplayMode" select="hidden"/>
    <div>
        <xsl:attribute name="class"><xsl:value-of select="$DisplayMode"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="$SectionName"/>_<xsl:value-of select="$Position"/>_details</xsl:attribute>
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
            <tbody>
                <xsl:for-each select="./ev:EventData/ev:Data">
                  <xsl:variable name="EntryName" select="./@Name"/>
                  <xsl:variable name="EntryValue" select="."/>
                  <xsl:variable name="EntryFriendlyValue" select="../../ev:RenderingInfo/freb:Description[@Data=$EntryName]" />
                  <xsl:choose>
                        <!--display the value from the EventData/Data only if theer is no freb:Description available (that would be a friendlier rendering of information)-->
                        <xsl:when test="$EntryName != 'ContextId'">
                            <tr>
                                <xsl:if test="position() mod 2 = 1">
                                    <xsl:attribute name="class">alt</xsl:attribute>
                                </xsl:if>
                                <th>
                                    <xsl:value-of select="$EntryName"/>
                                </th>
                                 <td class="event-data">
                                   <xsl:if test="not($EntryFriendlyValue)">
                                     <xsl:value-of select="$EntryValue"/>
                                   </xsl:if>
                                   <xsl:if test="$EntryFriendlyValue" >
                                     <xsl:value-of select="$EntryFriendlyValue"/>
                                   </xsl:if>

                                 </td>

                               </tr>
                        </xsl:when>
                      
                    </xsl:choose>
                </xsl:for-each>
            </tbody>
        </table>
    </div>
</xsl:template>
    
<xsl:template name="EventName" match="ev:Event" mode="EventName">
    <xsl:param name="Duration">NO_DURATION</xsl:param>
    <xsl:param name="SectionName"/>
    <xsl:param name="Position" select="position()"/>
    <xsl:param name="DisplaySeverity" select="1"/>
    <xsl:param name="DisplayInformation" select="0"/>
    <xsl:param name="DetailsDisplayMode" select="block"/>
    <a>
        <xsl:attribute name="href">javascript:toggleDiv('<xsl:value-of select="$SectionName"/>_<xsl:value-of select="$Position"/>');</xsl:attribute>
        <span class="expand-collapse"><xsl:attribute name="id"><xsl:value-of select="$SectionName"/>_<xsl:value-of select="$Position"/>_button</xsl:attribute>-</span>
        <xsl:value-of select="./ev:RenderingInfo/ev:Opcode"/>
    </a><!--xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text-->
    <xsl:if test="$DisplaySeverity=1">
        <xsl:call-template name="Severity"><xsl:with-param name="Duration" select="$Duration"/></xsl:call-template>
    </xsl:if>
    <xsl:call-template name="EventDetail">
        <xsl:with-param name="SectionName" select="$SectionName"/>
        <xsl:with-param name="Position" select="$Position"/>
        <xsl:with-param name="DisplayMode" select="$DetailsDisplayMode"/>
    </xsl:call-template>
</xsl:template>
    
<xsl:template name="CompactViewTemplate">
   <xsl:param name="IdName" select="section_compact"/>
   <xsl:param name="DisplayMode" select="hidden"/>
   <div> 
     <xsl:choose>
       <xsl:when test="function-available('jsext:datediff')">
         <xsl:attribute name="id">section_compact</xsl:attribute>
         <xsl:attribute name="class">hidden</xsl:attribute>
      </xsl:when>
	  <xsl:otherwise>
         <xsl:attribute name="id"><xsl:value-of select="section_compact_minimal_view"/></xsl:attribute>
         <xsl:attribute name="class"><xsl:value-of select="block"/></xsl:attribute>
	   </xsl:otherwise>
	 </xsl:choose>
         
     <span class="iistraceinfo">

       <table cellspacing="0" cellpadding="0" border="1" style="width:100%;border-collapse:collapse;table-layout:fixed;">
    
        <tr class="subhead" align="Left"><th width="32px">No.</th><th width="250px">EventName</th><th>Details</th><th width="100px" title="Timestamp in GMT (low resolution timer)">Time</th></tr>       
        <xsl:for-each select="/failedRequest/ev:Event">
          <xsl:call-template name="ProcessEvent">
            <xsl:with-param name="Event" select="."/>
            <xsl:with-param name="Position" select="position()"/>
          </xsl:call-template>
        </xsl:for-each>
    
       </table>    
     </span>
   </div>
</xsl:template>

<xsl:template  name="ErrorsAndWarnings">
        
    <div id="section_errors" class="summary-container hidden">
    <fieldset>
    <h2>
       <legend> <a href="javascript:toggleDiv('section_errors');"><span id="section_errors_button" class="expand-collapse">-</span>Errors &amp; Warnings</a></legend>
    </h2>
    <div id="section_errors_details">
    <table id="section_errors_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
      <thead>
        <tr>
          <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
          <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
                    <th class="col-severity"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Severity'"/></xsl:call-template></th>
          <th class="col-event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
          <th class="col-name"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Module Name'"/></xsl:call-template></th>
        </tr>
      </thead>
            <tbody>
              <xsl:choose>
	              <xsl:when test="count(./failedRequest/ev:Event/ev:System[ev:Level='1' or ev:Level='2' or ev:Level='3'])=0">
	                <tr>
	                  <td colspan="4"><span><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No Errors or Warnings'"/></xsl:call-template></span></td>
                    </tr>
	              </xsl:when>
	              <xsl:otherwise>
		            <xsl:for-each select="./failedRequest/ev:Event">
		                <xsl:variable name="Duration"><xsl:apply-templates select="." mode="CalculateDuration"/></xsl:variable>
		                
		                <xsl:if test="ev:System/ev:Level='1' or ev:System/ev:Level='2' or ev:System/ev:Level='3'">
		                    <tr>
		                        <xsl:attribute name="id">section_errors_<xsl:value-of select="position()"/></xsl:attribute>
		                        <td><xsl:value-of select="position()"/>.</td>
		                        <td><a><xsl:attribute name="href">javascript:findInDetail('<xsl:value-of select="position()"/>');</xsl:attribute> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'view trace'"/></xsl:call-template></a></td>
		                        <td>
		                            <xsl:choose>
		                                <xsl:when test="./ev:System/ev:Level = 3"><span class="severity-warning"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Warning'"/></xsl:call-template></span></xsl:when>
		                                <xsl:when test="./ev:System/ev:Level = 2"><span class="severity-error"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Error'"/></xsl:call-template></span></xsl:when>
		                                <xsl:when test="./ev:System/ev:Level = 1"><span class="severity-critical"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CriticalError'"/></xsl:call-template></span></xsl:when>
		                            </xsl:choose>
		                        </td>
		                        <td>
		                            <xsl:call-template name="EventName">
		                                <xsl:with-param name="SectionName" select="'section_errors'"/>
		                                <xsl:with-param name="DisplaySeverity" select="'0'"/>
		                                <xsl:with-param name="Duration" select="$Duration"/>
		                            </xsl:call-template>
		                        </td>
		                        <td>
		                            <xsl:value-of select="./ev:EventData/ev:Data[@Name='ModuleName']"/>
		                        </td>
		                    </tr>
		                </xsl:if>
		            </xsl:for-each>
		          </xsl:otherwise>
	          </xsl:choose>
              <tr>
                <td colspan="4"><span><a href="javascript:setView('section_detail', 'viewDetails');" id="requestDetails" class="parent-tab-highlight"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'SeeAllRequestDetails'"/></xsl:call-template></a></span></td>
              </tr>

            </tbody>
    </table>
    </div>
    </fieldset>
    </div>
</xsl:template>
    
<xsl:template name="Authentication">
    <div id="section_auth" class="hidden">
      <div class="expand-collapse-all">
        <a>
          <xsl:attribute name="href">
            javascript:toggleAll('<xsl:call-template name="Text">
                                     <xsl:with-param name="TextValue" select="'ExpandAll'"/>
                                    </xsl:call-template>', '
                                    <xsl:call-template name="Text">
                                      <xsl:with-param name="TextValue" select="'CollapseAll'"/>
                                    </xsl:call-template>', 'section_auth');
          </xsl:attribute>
          <span id="section_auth_button">
            <span class="expand-collapse">-</span>
            <xsl:call-template name="Text">
            <xsl:with-param name="TextValue" select="'CollapseAll'"/>
            </xsl:call-template>
          </span>
        </a>
      </div>
    <fieldset>
    <h2>
      <legend>
        <xsl:call-template name="Text">
          <xsl:with-param name="TextValue" select="'AuthenticationandAuthorization'"/>
        </xsl:call-template>
      </legend>
    </h2>
    
    <table id="section_auth_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
      <thead>
        <tr>
          <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
          <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
          <th class="col-event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
        </tr>
      </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="count(./failedRequest/ev:Event/ev:RenderingInfo[starts-with(ev:Opcode, 'AUTH_')=1 or starts-with(ev:Opcode, 'SECURITY_')=1 or starts-with(ev:Opcode, 'FILTER_AUTHENTICATION_')=1 or starts-with(ev:Opcode, 'FILTER_AUTH_')=1 or starts-with(ev:Opcode, 'FILTER_ACCESS_DENIED_')=1 or starts-with(ev:Opcode, 'RoleManager')=1 ]) = 0">
                        <tr><td colspan="4"><span class="no-data"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No Data Exists'"/></xsl:call-template></span></td></tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="./failedRequest/ev:Event">
                            <xsl:if test="starts-with(./ev:RenderingInfo/ev:Opcode, 'AUTH_')=1 or starts-with(./ev:RenderingInfo/ev:Opcode, 'SECURITY_')=1 or starts-with(./ev:RenderingInfo/ev:Opcode, 'FILTER_AUTHENTICATION_')=1 or starts-with(./ev:RenderingInfo/ev:Opcode, 'FILTER_AUTH_')=1 or starts-with(./ev:RenderingInfo/ev:Opcode, 'FILTER_ACCESS_DENIED_')=1 or starts-with(./ev:RenderingInfo/ev:Opcode, 'RoleManager')=1">
                                <xsl:variable name="Duration"><xsl:apply-templates select="." mode="CalculateDuration"/></xsl:variable>
                                <tr>
                                    <xsl:attribute name="id">section_auth_<xsl:value-of select="position()"/></xsl:attribute>
                                    <td><xsl:value-of select="position()"/>.</td>
                                    <td><a><xsl:attribute name="href">javascript:findInDetail('<xsl:value-of select="position()"/>');</xsl:attribute> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'view trace'"/></xsl:call-template></a></td>
                                    <td>
                                        <xsl:call-template name="EventName">
                                            <xsl:with-param name="SectionName" select="'section_auth'"/>
                                            <xsl:with-param name="Duration" select="$Duration"/>
                                        </xsl:call-template>
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                
            </tbody>
    </table>
    </fieldset>
  </div>
</xsl:template>

<xsl:template name="ManagedModules">
    <div id="section_modtrace" class="hidden">
        <div class="expand-collapse-all"> <a ><xsl:attribute name="href">javascript:toggleAll('<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ExpandAll'"/></xsl:call-template>', '<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template>', 'section_modtrace');</xsl:attribute><span id="section_modtrace_button"><span class="expand-collapse">-</span><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template></span></a></div>
        <fieldset>
            <h2>
                <legend> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CustomModuleTracesHeading'"/></xsl:call-template> </legend>
            </h2>
            
            <table id="section_modtrace_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
                <thead>
                    <tr>
                        <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
                        <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
                        <th class="col-event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
                        <th class="col-uri"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Uri'"/></xsl:call-template></th>
                    </tr>
                </thead>
                <tbody>
                        <xsl:choose>
                            <xsl:when test="count(./failedRequest/ev:Event/ev:RenderingInfo[starts-with(ev:Opcode, 'AspNetModuleDiag')=1]) = 0">
                                <tr><td colspan="4" align="center"><span class="no-data">No Data Exists For The Requested Report</span></td></tr>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="./failedRequest/ev:Event">
                                    <xsl:if test="starts-with(./ev:RenderingInfo/ev:Opcode, 'AspNetModuleDiag')=1">
                                        <xsl:variable name="Duration"><xsl:apply-templates select="." mode="CalculateDuration"/></xsl:variable>
                                        <tr>
                                            <xsl:attribute name="id">section_modtrace_<xsl:value-of select="position()"/></xsl:attribute>
                                            <td><xsl:value-of select="position()"/>.</td>
                                            <td><a><xsl:attribute name="href">javascript:findInDetail('<xsl:value-of select="position()"/>');</xsl:attribute> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'view trace'"/></xsl:call-template></a></td>
                                            <td>
                                                <xsl:call-template name="EventName">
                                                    <xsl:with-param name="SectionName" select="'section_modtrace'"/>
                                                    <xsl:with-param name="Duration" select="$Duration"/>
                                                </xsl:call-template>
                                            </td>
                                            <td>
                                                <xsl:value-of select="./ev:EventData/ev:Data[@Name='Uri']"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </tbody>
            </table>
        </fieldset>
    </div>
</xsl:template>
    
<xsl:template name="ASPX">
    <div id="section_aspx" class="hidden">
        <div class="expand-collapse-all"> <a ><xsl:attribute name="href">javascript:toggleAll('<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ExpandAll'"/></xsl:call-template>', '<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template>', 'section_aspx');</xsl:attribute><span id="section_aspx_button"><span class="expand-collapse">-</span><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template></span></a></div>
    <fieldset>
            <h2>
                <legend> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ASPPageTraceHeading'"/></xsl:call-template> </legend>
            </h2>
            
            <table id="section_aspx_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
                <thead>
                    <tr>
                        <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
                        <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
                        <th class="col-event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
                        <th class="col-uri"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Uri'"/></xsl:call-template></th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:choose>
                        <xsl:when test="count(./failedRequest/ev:Event/ev:RenderingInfo[ev:Opcode='AspNetPageTraceWarnEvent' or ev:Opcode='AspNetPageTraceWriteEvent']) = 0">
                            <tr><td colspan="4" align="center"><span class="no-data"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No Data Exists'"/></xsl:call-template></span></td></tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="./failedRequest/ev:Event">
                                <xsl:if test="./ev:RenderingInfo/ev:Opcode = 'AspNetPageTraceWarnEvent' or ./ev:RenderingInfo/ev:Opcode = 'AspNetPageTraceWriteEvent'">
                                    <xsl:variable name="Duration"><xsl:apply-templates select="." mode="CalculateDuration"/></xsl:variable>
                                    <tr>
                                        <xsl:attribute name="id">section_aspx_<xsl:value-of select="position()"/></xsl:attribute>
                                        <td><xsl:value-of select="position()"/>.</td>
                                        <td><a><xsl:attribute name="href">javascript:findInDetail('<xsl:value-of select="position()"/>');</xsl:attribute> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'view trace'"/></xsl:call-template></a></td>
                                        <td>
                                            <xsl:call-template name="EventName">
                                                <xsl:with-param name="SectionName" select="'section_aspx'"/>
                                                <xsl:with-param name="Duration" select="$Duration"/>
                                            </xsl:call-template>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./ev:EventData/ev:Data[@Name='Uri']"/>
                                        </td>
                                    </tr>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </tbody>
            </table>
        </fieldset>
    </div>
</xsl:template>

<xsl:template name="Notifications">
    <div id="section_notifications" class="hidden">
        <div class="expand-collapse-all"><a><xsl:attribute name="href">javascript:toggleAll('<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ExpandAll'"/></xsl:call-template>', '<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template>', 'section_notifications');</xsl:attribute><span id="section_notifications_button"><span class="expand-collapse">-</span><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template></span></a></div>
        <fieldset>
            <h2>
                <legend> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ModuleNotificationsHeading'"/></xsl:call-template> </legend>
            </h2>
            <table id="section_notifications_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
                <thead>
                    <tr>
                        <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
                        <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
                        <th class="col-notification"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
                        <th class="col-filter-module"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Module'"/></xsl:call-template></th>
                        <th class="col-filter-notification"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Notification'"/></xsl:call-template></th>
                        <th class="col-duration" title="Time elapsed from the previous event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Duration'"/></xsl:call-template> (ms)</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="./failedRequest/ev:Event">
                        <xsl:if test="count(./ev:EventData/ev:Data[@Name='ModuleName'])=1 and contains(./ev:RenderingInfo/ev:Opcode, '_START')=1">
                            <xsl:variable name="Duration"><xsl:apply-templates select="." mode="CalculateDuration"/></xsl:variable>
                            <tr>
                                <xsl:attribute name="id">section_notifications_<xsl:value-of select="position()"/></xsl:attribute>
                                <td><xsl:value-of select="position()"/>.</td>
                                <td><a><xsl:attribute name="href">javascript:findInDetail('<xsl:value-of select="position()"/>');</xsl:attribute> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'view trace'"/></xsl:call-template></a></td>
                                <td>
                                    <xsl:call-template name="EventName">
                                        <xsl:with-param name="SectionName" select="'section_notifications'"/>
                                        <xsl:with-param name="Duration" select="$Duration"/>
                                        <xsl:with-param name="DetailsDisplayMode" select="hidden"/>
                                    </xsl:call-template>
                                </td>
                                <td>
                                    <xsl:value-of select="./ev:EventData/ev:Data[@Name='ModuleName']"/>
                                </td>
                                <td>
                                    <!--<xsl:value-of select="./ev:EventData/ev:Data[@Name='Notification']/@Description"/>-->
                                    <xsl:value-of select="./ev:RenderingInfo/freb:Description[@Data='Notification']"/>
                                </td>
                                <td class="col-duration">
                                    <xsl:value-of select="$Duration"/>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </tbody>
            </table>
        </fieldset>
    </div>
</xsl:template>
<xsl:template name="Filters">
    <div id="section_filters" class="hidden">
        <div class="expand-collapse-all">
                <a>
                    <xsl:attribute name="href">javascript:toggleAll('<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ExpandAll'"/></xsl:call-template>', '<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template>', 'section_filters');</xsl:attribute>
                    <span id="section_filters_button"><span class="expand-collapse">-</span><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template></span>
                </a>
            </div>
        <fieldset>
            <h2>
                <legend> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Filters'"/></xsl:call-template> </legend>
            </h2>
            <table id="section_filters_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
                <thead>
                    <tr>
                        <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
                        <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
                        <th class="col-event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
                        <th class="col-filter-module"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Filter Name'"/></xsl:call-template></th>
                        <th class="col-duration" title="Time elapsed from the previous event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Duration'"/></xsl:call-template> (ms)</th>
                    </tr>
                </thead>
                <tbody>
                 <xsl:choose>
                  <xsl:when test="count(./ev:EventData/ev:Data[@Name='FilterName']) = 0">
                     <tr><td colspan="4"><span class="no-data"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No Data Exists'"/></xsl:call-template></span></td></tr>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="./failedRequest/ev:Event">
                        <xsl:if test="count(./ev:EventData/ev:Data[@Name='FilterName']) &gt; 0 and ./following-sibling::*[1]/ev:System/ev:Level = 4 ">
                            <xsl:variable name="Duration"><xsl:apply-templates select="." mode="CalculateDuration"/></xsl:variable>
                            <tr>
                                <xsl:attribute name="id">section_filters_<xsl:value-of select="position()"/></xsl:attribute>
                                <td><xsl:value-of select="position()"/>.</td>
                                <td><a><xsl:attribute name="href">javascript:findInDetail('<xsl:value-of select="position()"/>');</xsl:attribute> <xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'view trace'"/></xsl:call-template></a></td>
                                <td>
                                    <xsl:apply-templates select="./following-sibling::*[1]" mode="EventName">
                                        <xsl:with-param name="SectionName" select="'section_filters'"/>
                                        <xsl:with-param name="Position" select="position()"/>
                                    </xsl:apply-templates>
                                </td>
                                <td>
                                    <xsl:value-of select="./ev:EventData/ev:Data[@Name='FilterName']"/>
                                </td>
                                <td class="col-duration">
                                    <xsl:value-of select="$Duration"/>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                   </xsl:otherwise>
                 </xsl:choose>
                </tbody>
            </table>
        </fieldset>
    </div>
</xsl:template>    

    
<xsl:template name="Performance">
    <div id="section_perf" class="hidden">
    <fieldset>
    <h2>
      <legend class="no-expand-all"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'PerformanceViewHeading'"/></xsl:call-template></legend>
    </h2>
    <table id="section_perf_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
      <thead>
        <tr>
          <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
          <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
          <th class="col-event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
          <th class="col-duration" title="Time elapsed from the previous event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Duration'"/></xsl:call-template> (ms)</th>
        </tr>
      </thead>
      <xsl:for-each select="./failedRequest/ev:Event">
        <!-- Filter for events containing _START -->
        <xsl:variable name="Duration">
          <xsl:apply-templates select="." mode="CalculateDuration"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$Duration != 'NO_DURATION' and $Duration != 'NO_END'">
            <tr>
              <xsl:attribute name="id">
                section_perf_<xsl:value-of select="position()"/>
              </xsl:attribute>
              <td><xsl:value-of select="position()"/>.</td>
              <td>
                <a>
                  <xsl:attribute name="href">
                    javascript:findInDetail('<xsl:value-of select="position()"/>');
                  </xsl:attribute>
                  <xsl:call-template name="Text">
                    <xsl:with-param name="TextValue" select="'view trace'"/>
                  </xsl:call-template>
                </a>
              </td>
              <td>
                <xsl:call-template name="Severity">
                  <xsl:with-param name="Duration" select="$Duration"/>
                </xsl:call-template>
                <xsl:value-of select="./ev:RenderingInfo/ev:Opcode"/>
                <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
              </td>
              <td class="col-duration">
                <xsl:choose>
                  <xsl:when test="$Duration != 'NO_DURATION' and $Duration != 'NO_END'">
                    <xsl:value-of select="$Duration"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text disable-output-escaping="yes"><![CDATA[<!--EmptyNumber-->]]></xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
  
              </td>
            </tr>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </table>
    </fieldset>
  </div>
    
</xsl:template>

<xsl:template name="fastcgi">
  <div id="section_fastcgi" class="hidden">
    <div class="expand-collapse-all"> <a ><xsl:attribute name="href">javascript:toggleAll('<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ExpandAll'"/></xsl:call-template>', '<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template>', 'section_fastcgi');</xsl:attribute><span id="section_fastcgi_button"><span class="expand-collapse">-</span><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template></span></a></div>
    <fieldset>
      <h2>
        <legend><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'fastcgiHeading'"/></xsl:call-template></legend>
      </h2>

      <table id="section_fastcgi_table" class="sortable" cellspacing="0" cellpadding="0" border="0" width="100%">
        <thead>
          <tr>
            <th class="defaultsort col-number"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No'"/></xsl:call-template></th>
            <th class="col-actions"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
            <th class="col-event"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'Event'"/></xsl:call-template></th>
          </tr>
        </thead>
        <tbody>
          <xsl:choose>
            <xsl:when test="count(./failedRequest/ev:Event/ev:RenderingInfo[starts-with(ev:Opcode, 'FASTCGI_')=1 ]) = 0">
              <tr><td colspan="4"><span class="no-data"><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'No Data Exists'"/></xsl:call-template></span></td></tr>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="./failedRequest/ev:Event">
                <xsl:if test="starts-with(./ev:RenderingInfo/ev:Opcode, 'FASTCGI_')=1 ">
                  <xsl:variable name="Duration"><xsl:apply-templates select="." mode="CalculateDuration"/></xsl:variable>
                  <tr>
                    <xsl:attribute name="id">section_fastcgi_<xsl:value-of select="position()"/></xsl:attribute>
                    <td><xsl:value-of select="position()"/>.</td>
                    <td><a><xsl:attribute name="href">javascript:findInDetail('<xsl:value-of select="position()"/>');</xsl:attribute><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'view trace'"/></xsl:call-template></a></td>
                    <td>
                      <xsl:call-template name="EventName">
                        <xsl:with-param name="SectionName" select="'section_fastcgi'"/>
                        <xsl:with-param name="Duration" select="$Duration"/>
                      </xsl:call-template>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>

        </tbody>
      </table>
    </fieldset>
  </div>
</xsl:template>

<xsl:template name="CompleteRequestTrace">
    <div id="section_detail" class="hidden">
        <div class="expand-collapse-all"><a><xsl:attribute name="href">javascript:toggleAll('<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'ExpandAll'"/></xsl:call-template>', '<xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template>', 'section_detail');</xsl:attribute><span id="section_detail_button"><span class="expand-collapse">-</span><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CollapseAll'"/></xsl:call-template></span></a></div>

    <fieldset>
    <h2>
      <legend><xsl:call-template name="Text"><xsl:with-param name="TextValue" select="'CompleteRequestTraceHeading'"/></xsl:call-template></legend>
    </h2>
        <xsl:for-each select="./failedRequest/ev:Event">
            <xsl:variable name="Duration">
               <xsl:apply-templates select="." mode="CalculateDuration"/>
            </xsl:variable>

            <xsl:if test="substring(./ev:RenderingInfo/ev:Opcode,string-length(./ev:RenderingInfo/ev:Opcode)- string-length('_END')+1) = '_END'">
            </xsl:if>
            <xsl:if test="substring(./ev:RenderingInfo/ev:Opcode,string-length(./ev:RenderingInfo/ev:Opcode)- string-length('_START')+1) = '_START' and $Duration != 'NO_END' and $Duration != 'NO_DURATION'">
                <xsl:text disable-output-escaping="yes">&lt;fieldset&gt;</xsl:text>
            </xsl:if>
            <fieldset class="no-border">
                <xsl:attribute name="id">section_detail_<xsl:value-of select="position()"/></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$Duration != 'NO_END' and $Duration != 'NO_DURATION'">
                        <div class="duration"><span class="duration-value"><xsl:value-of select="$Duration"/><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>ms</span></div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="duration" ><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="Severity"><xsl:with-param name="DisplayInformational" select="1"/><xsl:with-param name="Duration" select="$Duration"/></xsl:call-template>
                <a>
                    <xsl:attribute name="name">detail_<xsl:value-of select="position()"/></xsl:attribute>
                    <xsl:value-of select="position()"/>.
                </a>
                <xsl:call-template name="EventName">
                    <xsl:with-param name="DisplaySeverity" select="0"/>
                    <xsl:with-param name="SectionName" select="'section_detail'"/>
                    <xsl:with-param name="Duration" select="$Duration"/>
                    <xsl:with-param name="DisplayInformation" select="1"/>
                </xsl:call-template>
            </fieldset>
            <xsl:if test="substring(./ev:RenderingInfo/ev:Opcode,string-length(./ev:RenderingInfo/ev:Opcode)- string-length('_END')+1) = '_END'">
                <xsl:text disable-output-escaping="yes">&lt;/fieldset&gt;</xsl:text>
            </xsl:if>

        </xsl:for-each>
        </fieldset>
  </div>
</xsl:template>

<!--In: A node list starting with the start tag.-->
<!-- If this is not a *_START node, return NO_DURATION    
            If this is a *_START node and has no corresponding *_END node, return NO_END
            Otherwise, return the time difference between the previous and current event's timestamp in miliseconds.-->
<xsl:template match="ev:Event" mode="CalculateDuration">
    <!-- Get the start time from the start event (this event) -->
    <xsl:variable name="startTime" select="./ev:System/ev:TimeCreated/@SystemTime"/>

    <xsl:choose>
       <xsl:when test="function-available('jsext:datediff')">
        <xsl:choose>
  	      <xsl:when test="string(preceding-sibling::ev:Event[1]/ev:System/ev:TimeCreated/@SystemTime) = ''">
	    	<xsl:text>0</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="jsext:datediff(string(preceding-sibling::ev:Event[1]/ev:System/ev:TimeCreated/@SystemTime),string($startTime))"/>    
	      </xsl:otherwise>
	    </xsl:choose>
	   </xsl:when>
       <xsl:otherwise>
         <!--if not able to calculate the difference because of missing jsext:datediff, then simply return empty string -->
	     <xsl:text></xsl:text>    
	   </xsl:otherwise>
    </xsl:choose>
</xsl:template>
    

<xsl:variable name="language" select="'1033'"/>
<xsl:template name="Text">
    <xsl:param name="TextValue"/>
        
    <xsl:choose>
        <xsl:when test="$language = '1033'">
            <xsl:choose>
                <xsl:when test="$TextValue='CompleteRequestTrace'">Complete<br />Request Trace</xsl:when>
                <xsl:when test="$TextValue='Warning'">Warning</xsl:when>
                <xsl:when test="$TextValue='Error'">Error</xsl:when>
                <xsl:when test="$TextValue='CriticalError'">Critical Error</xsl:when>
                <xsl:when test="$TextValue='FailedToComplete'">Failed To Complete</xsl:when>
                <xsl:when test="$TextValue='Verbose'">Verbose</xsl:when>
                <xsl:when test="$TextValue='Informational'">Informational</xsl:when>
                <xsl:when test="$TextValue='RequestSummary'">Request<br />Summary</xsl:when>
                <xsl:when test="$TextValue='CompactView'">Compact<br />View</xsl:when>
                <xsl:when test="$TextValue='RequestDetails'">Request<br />Details</xsl:when>
                <xsl:when test="$TextValue='SeeAllRequestDetails'"> See all events for the request</xsl:when>
                <xsl:when test="$TextValue='FilterNotifications'">Filter <br />Notifications</xsl:when>
                <xsl:when test="$TextValue='ModuleNotifications'">Module<br />Notifications</xsl:when>
                <xsl:when test="$TextValue='PerformanceView'">Performance<br />View</xsl:when>
                <xsl:when test="$TextValue='AuthenticationAuthorization'">Authentication<br />Authorization</xsl:when>
                <xsl:when test="$TextValue='ASPPageTrace'">ASP.Net<br />Page Traces</xsl:when>
                <xsl:when test="$TextValue='CustomModuleTrace'">Custom<br />Module Traces</xsl:when>
                <xsl:when test="$TextValue='fastcgi'">FastCGI<br />Module</xsl:when>
                <xsl:when test="$TextValue='ExpandAll'">Expand</xsl:when>
                <xsl:when test="$TextValue='CollapseAll'">Collapse</xsl:when>
                <xsl:when test="$TextValue='RequestSummary'">Request Summary</xsl:when>
                <xsl:when test="$TextValue='Site'">Site</xsl:when>
                <xsl:when test="$TextValue='Process'">Process</xsl:when>
                <xsl:when test="$TextValue='FailureReason'">Failure Reason</xsl:when>
                <xsl:when test="$TextValue='TriggerStatus'">Trigger Status</xsl:when>
                <xsl:when test="$TextValue='FinalStatus'">Final Status</xsl:when>
                <xsl:when test="$TextValue='TimeTaken'">Time Taken</xsl:when>
                <xsl:when test="$TextValue='Url'">Url</xsl:when>
                <xsl:when test="$TextValue='App Pool'">App Pool</xsl:when>
                <xsl:when test="$TextValue='Authentication'">Authentication</xsl:when>
                <xsl:when test="$TextValue='User from token'">User from token</xsl:when>
                <xsl:when test="$TextValue='Activity ID'">Activity ID</xsl:when>
                <!-- Errors and Warnings -->
                <xsl:when test="$TextValue='ErrorsandWarnings'">Errors &amp; Warnings</xsl:when>
                <xsl:when test="$TextValue='No'">No.</xsl:when>
                <xsl:when test="$TextValue='Severity'">Severity</xsl:when>
                <xsl:when test="$TextValue='Event'">Event</xsl:when>
                <xsl:when test="$TextValue='Module Name'">Module Name</xsl:when>
                <xsl:when test="$TextValue='view trace'">view trace</xsl:when>
                <!-- Authentication -->
                <xsl:when test="$TextValue='AuthenticationandAuthorization'">Authentication &amp; Authorization</xsl:when>
                <xsl:when test="$TextValue='No Data Exists'">No Data Exists For The Requested Report</xsl:when>
                <xsl:when test="$TextValue='No Errors or Warnings'">No Errors or Warnings were found</xsl:when>
                <!-- Custom Module Traces-->
                <xsl:when test="$TextValue='CustomModuleTracesHeading'">Custom Module Traces</xsl:when>
                <xsl:when test="$TextValue='ErrorsandWarnings'">Errors &amp; Warnings</xsl:when>
                <xsl:when test="$TextValue='Uri'">Uri</xsl:when>
                <!-- ASP Page Traces-->
                <xsl:when test="$TextValue='ASPPageTraceHeading'">ASP.Net Page Traces</xsl:when>
                <!-- Notifications-->
                <xsl:when test="$TextValue='ModuleNotificationsHeading'">Module Notifications</xsl:when>
                <xsl:when test="$TextValue='Module'">Module</xsl:when>
                <xsl:when test="$TextValue='Notification'">Notification</xsl:when>
                <xsl:when test="$TextValue='Duration'">Duration</xsl:when>
                <!-- Filters -->
                <xsl:when test="$TextValue='Filters'">Filters</xsl:when>
                <xsl:when test="$TextValue='Filter Name'">Filter Name</xsl:when>
                <!-- Performance -->
                <xsl:when test="$TextValue='PerformanceViewHeading'">Performance View</xsl:when>
                <!-- FastCGI Module -->
                <xsl:when test="$TextValue='fastcgiHeading'">FastCGI Module</xsl:when>
                <xsl:when test="$TextValue='No Data Exists'">No Data Exists For The Requested Report</xsl:when>
                <!-- Complete Request Trace -->
                <xsl:when test="$TextValue='CompleteRequestTraceHeading'">Complete Request Trace</xsl:when>
            </xsl:choose>
        </xsl:when>
        
    </xsl:choose>
    
</xsl:template>

<xsl:template name="ProcessEvent">
 <xsl:param name="Event"/>
 <xsl:param name="Position"/>
 <tr>
  <xsl:choose> 
   <xsl:when test="position() mod 2 = 1">
    <xsl:attribute name="class">alt</xsl:attribute> 
   </xsl:when>
   <xsl:otherwise/>
  </xsl:choose>
  
  <td>
    <xsl:number value="position()" format="1."/>
  </td>

  <td>
     <xsl:choose>
     <xsl:when test="./ev:System/ev:Level = 3">
        <xsl:value-of select="$Event/ev:RenderingInfo/ev:Opcode"/> 
        <br/>
          <span class="severity-warning">
            <xsl:call-template name="Text">
              <xsl:with-param name="TextValue" select="'Warning'"/>
            </xsl:call-template>
          </span>
        </xsl:when>
        <xsl:when test="./ev:System/ev:Level = 2">
          <xsl:value-of select="$Event/ev:RenderingInfo/ev:Opcode"/>
          <br/>
          <span class="severity-error">
            <xsl:call-template name="Text">
              <xsl:with-param name="TextValue" select="'Error'"/>
            </xsl:call-template>
          </span>
        </xsl:when>
        <xsl:when test="./ev:System/ev:Level = 1">
          <xsl:value-of select="$Event/ev:RenderingInfo/ev:Opcode"/>
          <br/>
          <span class="severity-critical">
            <xsl:call-template name="Text">
              <xsl:with-param name="TextValue" select="'CriticalError'"/>
            </xsl:call-template>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$Event/ev:RenderingInfo/ev:Opcode"/>
        </xsl:otherwise>
      </xsl:choose>

  </td>
   <td><xsl:apply-templates select="$Event/ev:EventData/ev:Data"/></td>
  <td><xsl:value-of select="substring($Event/ev:System/ev:TimeCreated/@SystemTime,12,12)"/></td>

 </tr>
</xsl:template>

<xsl:template match="ev:Data">
 <xsl:param name="name">
     <xsl:value-of select="@Name"/>
 </xsl:param>
 <xsl:param name="friendly">
    <xsl:value-of select="parent::*/parent::*/ev:RenderingInfo/freb:Description[@Data=$name]"/>
 </xsl:param>
 <xsl:if test="not($name='ContextId') and not($name='ConnID') and not($name='Context ID')">
     <xsl:value-of select="@Name"/>="<xsl:if test="string-length($friendly)=0"><xsl:value-of select="."/></xsl:if>
     <xsl:if test="not(string-length($friendly)=0)">
        <xsl:value-of select="$friendly"/>
     </xsl:if>"<xsl:if test="not(position()=last())">, </xsl:if>
 </xsl:if>
</xsl:template>

</xsl:stylesheet>
