<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>
	<%
	Connection con = null;
try {
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection("jdbc:oracle:thin:@10.248.168.222:1521:CICSSP", "imigration", "nicsi123");

	/*Context ctx = null;
	Connection con = null;
	ctx = new InitialContext();
	Context envCtx = (Context)ctx.lookup("java:comp/env");
	DataSource ds = (DataSource)envCtx.lookup("jdbc/im_pax_ds");
	con = ds.getConnection();
	
	CREATE TABLE "IMIGRATION"."IM_DASHBOARD_IMG_YAER_WISE_COUNT" 
   (	"YEAR" NUMBER(4,0) NOT NULL ENABLE, 
	"ICP" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"CAMERA_IMAGE" NUMBER, 
	"PASSPORT_IMAGE" NUMBER, 
	"DECARD_IMAGE" NUMBER, 
	"VISA_IMAGE" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  
  
  CREATE TABLE "IMIGRATION"."IM_DASHBOARD_IMG_MONTH_WISE_COUNT" 
   (	"MONTH_DATE" NUMBER NOT NULL ENABLE, 
	"ICP" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"CAMERA_IMAGE" NUMBER, 
	"PASSPORT_IMAGE" NUMBER, 
	"DECARD_IMAGE" NUMBER, 
	"VISA_IMAGE" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;


  CREATE TABLE "IMIGRATION"."IM_DASHBOARD_IMG_MONTH_WISE_COUNT" 
   (	"MONTH_DATE" NUMBER NOT NULL ENABLE, 
	"ICP" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"CAMERA_IMAGE" NUMBER, 
	"PASSPORT_IMAGE" NUMBER, 
	"DECARD_IMAGE" NUMBER, 
	"VISA_IMAGE" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

*/


	DateFormat formetter = new SimpleDateFormat("dd/MM/yyyy");
	DateFormat vDateFormatYes = new SimpleDateFormat("dd MMM");
	java.util.Date current_Server_Time = new java.util.Date();
	String today_date = vDateFormatYes.format(current_Server_Time);

	DateFormat vDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	String vServerTime = vDateFormat.format(current_Server_Time);

	PreparedStatement psMain = null;
	PreparedStatement psTemp = null;
	Statement st_icp = con.createStatement();
	ResultSet rs_icp = null;
	ResultSet rsMain = null;
	ResultSet rsTemp = null;

	String depQuery = "";
	int today_Camera_Count = 0;
	int daily_Dep_Count = 0;
	int total_Camera_Count = 0;
	int yesterday_Camera_Count = 0;
	int total_Passport_Count = 0;

	//////////////////////////////// Start : ICP_SRNO , DESC HB ////////////////////////////////////////////////////////

	ResultSet rs5 = null;
	Statement stmt5 = con.createStatement();

	String strSql5 = "SELECT ICP_SRNO, ICP_DESC FROM IM_ICP_LIST where icp_srno in (select icp from IM_DASHBOARD_IMG_YAER_WISE_COUNT) order by ICP_DESC";
	try
	{
		rs5 = stmt5.executeQuery(strSql5);
	}
	catch(SQLException e)
	{
		out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + strSql5 + "<BR><BR></b></font>");
	}

	HashMap<String, String> icpValue = new HashMap<String,String>(); // For storing Serial No. and ICP Name.
	if(rs5.next()){
		do{			
			
			String icpName = rs5.getString("ICP_DESC") == null ? "" : rs5.getString("ICP_DESC"); 
			icpName = icpName.replace("AIRPORT",""); 
			icpName = icpName.replace("INTERNATIONAL",""); 
			icpName = icpName.replace("RAIL",""); 
			icpName = icpName.replace("LAND CHECKPOST","");
			String icpSoNo = rs5.getString("ICP_SRNO") == null ? "" : rs5.getString("ICP_SRNO");
					
			icpValue.put( icpSoNo , icpName);		
		}while(rs5.next());

		if(rs5!=null)
		{
			rs5.close();
			stmt5.close();
		}
	}

	///////////////////// Months - For displaying Mon-Year Format /////////////////////////

	HashMap<String, String> monthValue = new HashMap<String,String>(); // For displaying Mon-Year Format
		monthValue.put( "01" , "Jan");		
		monthValue.put( "02" , "Feb");		
		monthValue.put( "03" , "Mar");		
		monthValue.put( "04" , "Apr");		
		monthValue.put( "05" , "May");		
		monthValue.put( "06" , "Jun");		
		monthValue.put( "07" , "Jul");		
		monthValue.put( "08" , "Aug");		
		monthValue.put( "09" , "Sep");		
		monthValue.put( "10" , "Oct");		
		monthValue.put( "11" , "Nov");		
		monthValue.put( "12" , "Dec");	
		
	///////////////////// Months /////////////////////////


	//////////////////////////////// End : ICP_SRNO , DESC HB ////////////////////////////////////////////////////////
	
String WeeklyPAXQuery = "";
String weekly_XAxis = "";
int weekelyArrPaxCount = 0;
int weekelyDepPaxCount = 0;
String WeeklyFlightsQuery = "";
String weeklyFlightXAxis = "";
int weekelyArrFlightCount = 0;
int weekelyDepFlightCount = 0;
String arrHourlyQuery = "";
String hourlyXAxis = "";
int hourlyArrFlightCount = 0;
int hourlyArrPaxCount = 0;
int hourlyArrActiveCounter = 0;
String depHourlyQuery = "";
String hourlyDepXAxis = "";
int hourlyDepFlightCount = 0;
int hourlyDepPaxCount = 0;
int hourlyDepActiveCounter = 0;
int displayHours = 8;
String dash = "";
String dashQuery = "";

////////////////////	Arrival/Departure PAX Count	Tabs	/////////////////////////

	 java.util.Date yesterday_date_in_millis = new java.util.Date(System.currentTimeMillis()-1*24*60*60*1000);
	 String yesterday_date = vDateFormatYes.format(yesterday_date_in_millis);

	 String filter_icp = request.getParameter("icp") == null ? "All" : request.getParameter("icp"); 
	 String default_hrs = request.getParameter("default_hrs") == null ? "8" : request.getParameter("default_hrs");
	 displayHours = Integer.parseInt(default_hrs);

	 //out.println("kuhkihfayfdjhj" + filter_icp);
	 if(filter_icp.equals("")) filter_icp = "" + filter_icp + "";

	 String vishwaFilter = " where ICP = '" + filter_icp + "'";
	 if(filter_icp.equals("All")) vishwaFilter = "";
	 else vishwaFilter = " where ICP = '" + filter_icp + "'";
	 //out.println(vishwaFilter);

//*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=
		int div_hgt = 200; 
		if(filter_icp.equals("All")) {dash = "All ICPs";  div_hgt = 600;}
		else
		{
			rsTemp = st_icp.executeQuery("select ICP_SRNO, ICP_DESC from IM_ICP_LIST WHERE ICP_SRNO IN (SELECT ICP FROM IM_DASHBOARD_IMG_YAER_WISE_COUNT)");
			while(rsTemp.next())
			{
				if(filter_icp.equals(rsTemp.getString("ICP_SRNO")))
				{
						dash = rsTemp.getString("ICP_DESC");
				}
			}
			rsTemp.close();  
			div_hgt = 200; 
		}
//*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=
%>

<%!
//Capitalising first Charcter of each word in a string,
		public static String capitalizeFirstChar(String IcpNamePrev)	
		{	
			String icpName = IcpNamePrev.toLowerCase();
			String[] arr = icpName.split(" ");
			StringBuffer sb = new StringBuffer();
			for(int j=0 ; j< arr.length ;j++){
				sb.append(Character.toUpperCase(arr[j].charAt(0))).append(arr[j].substring(1)).append(" ");
			}
			return sb.toString().trim();
		}	

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>IndexForm</title>
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="css/style1.css" rel="stylesheet" type="text/css">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/all.min.css" media="all">
<link rel="stylesheet" href="css/style.css" media="all">
<script src="bar.js" type="text/javascript"></script>
<script src="js/Charts.js"></script>

<style> 
	.fixTableHead { 
	overflow-y: auto; 
	overflow-x: auto; 
	height: 460px; 
	width:900px;
	margin: auto;

	} 
	.fixTableHead thead th {
	position: sticky; 
	top: 0; 
	} 
	.fixTableHead thead tr {
	position: sticky; 
	top: 0; 
	} 

.tableDesign_month {
	border-collapse: separate;
	border-spacing: 0;
	
}
.tableDesign_month tr th, .tableDesign_month tr td {
	border-right: 1px solid #bbb;
	border-bottom: 1px solid #bbb;
	padding: 5px;
}

.tableDesign_month tr th:first-child, .tableDesign_month tr td:first-child {
	border-left: 1px solid #bbb;
}

.tableDesign_month tr th {
	background: #eee;
	border-top: 1px solid #bbb;
	text-align: left;
}



.right{
	text-align :right;
	}

</style> 
<style>
div.scroll-container 
{
	overflow:auto;
	white-space: nowrap;
	padding: 10px;
}
div.scroll-container-vertical 
{
	overflow-y: auto;
	height:500px;
	width:900px;
	margin: auto;

}


canvas {
   
    background: linear-gradient(to bottom, #ffffff 40%, #fff9b0 100%);
}


.canvasArrPAXFltActCount 
{
    background: linear-gradient(to bottom, #ffffff 40%, #99ccff 100%);
	
}

.tableDesign {
	border-collapse: separate;
	border-spacing: 0;
	
}
.tableDesign tr th, .tableDesign tr td {
	border-right: 1px solid #bbb;
	border-bottom: 1px solid #bbb;
	padding: 5px;
}

.tableDesign tr th:first-child, .tableDesign tr td:first-child {
	border-left: 1px solid #bbb;
}

.tableDesign tr th {
	background: #eee;
	border-top: 1px solid #bbb;
	text-align: left;
}

/* top-left border-radius */
.tableDesign tr:first-child th:first-child {
	border-top-left-radius: 10px;
}

/* top-right border-radius */
.tableDesign tr:first-child th:last-child {
	border-top-right-radius: 10px;
}

/* bottom-left border-radius */
.tableDesign tr:last-child td:first-child {
	border-bottom-left-radius: 10px;
}

/* bottom-right border-radius */
.tableDesign tr:last-child td:last-child {
	border-bottom-right-radius: 10px;
}

.right{
	text-align :right;
	}


/*end*/


</style>

<script>

function letternumber(e, str)
	{
		var key;
		var keychar;
		if (window.event)
		   key = window.event.keyCode;
		else if (e)
		   key = e.which;
		else
		   return true;
		keychar = String.fromCharCode(key);
		keychar = keychar.toLowerCase();
		// control keys
		if ((key==null) || (key==0) || (key==8) || 
			(key==9) || (key==13) || (key==27) )
		   return true;
		// alphas and numbers
		else if ((str.indexOf(keychar) > -1))
		   return true;
		else
		   return false;
	}

	function filtery(pattern, list){
	 
	  /*

	  if the dropdown list passed in hasn't

	  already been backed up, we'll do that now

	  */

	  if (!list.bak){

		/*

		We're going to attach an array to the select object

		where we'll keep a backup of the original dropdown list

		*/

		list.bak = new Array();

		for (n=0;n<list.length;n++){

		  list.bak[list.bak.length] = new Array(list[n].value, list[n].text);

		}

	  }

	  /*

	  We're going to iterate through the backed up dropdown

	  list. If an item matches, it is added to the list of

	  matches. If not, then it is added to the list of non matches.

	  */

	  match = new Array();

	  nomatch = new Array();

	  for (n=0;n<list.bak.length;n++){

		if(list.bak[n][1].toLowerCase().indexOf(pattern.toLowerCase())!=-1){

		  match[match.length] = new Array(list.bak[n][0], list.bak[n][1]);//value found

		}else{

		  nomatch[nomatch.length] = new Array(list.bak[n][0], list.bak[n][1]);

		}

	  }

	  /*

	  Now we completely rewrite the dropdown list.

	  First we write in the matches, then we write

	  in the non matches

	  */

	  for (n=0;n<match.length;n++){

		list[n].value = match[n][0];

		list[n].text = match[n][1];

	  }

	  for (n=0;n<nomatch.length;n++){

		list[n+match.length].value = nomatch[n][0];

		list[n+match.length].text = nomatch[n][1];

	  }

	  /*

	  Finally, we make the 1st item selected - this

	  makes sure that the matching options are

	  immediately apparent

	  */

	  list.selectedIndex=0;
	}


function compare_report()
{
	document.entryfrm.target="_self";
	document.entryfrm.action="im_images_dashboard.jsp?icp="+document.entryfrm.compare_icp.value;
	document.entryfrm.submit();
	return true;

}
</script>

<!--  Reverse Timer Functions -->
<form name="FormServerTime">
	<input type="hidden" name="ServerTime" value='<%=vServerTime%>'>
</form>

<SCRIPT language="JavaScript" type="text/javascript">
	var CounterTimerID = 0;
	var tStartTimer  = null;
	function UpdateTimer() 
	{
		if(CounterTimerID) 
		{
			clearTimeout(CounterTimerID);
			CounterTimerID  = 0;
		}
		tStartTimer = tStartTimer - 1;
	
		document.entryfrm.ReverseCounterID.value = tStartTimer;
		CounterTimerID = setTimeout("UpdateTimer()", 1000);

		if(tStartTimer == 0) 
		{
			if(CounterTimerID) 
			{
				clearTimeout(CounterTimerID);
				CounterTimerID  = 0;
			}
			tStartTimer = null;
			
			compare_report();
			    return true;
		}
	}
	function StartTimer() 
	{
		tStartTimer = 600;   //10 minutes delay
		CounterTimerID = setTimeout("UpdateTimer()", 1000);
	}
	</script>

<script LANGUAGE="JAVASCRIPT">
	//var dayarray=new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
	var dayarray=new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat")
	//var montharray=new Array("January","February","March","April","May","June","July","August","September","October","November","December")
	var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")

	var timevar = document.FormServerTime.ServerTime.value;
	var y1=timevar.substring(0,4);
	var m1t=timevar.substring(5,7);
	var m2t=Number(m1t)-1;
	var m1=m2t;
	if (m1==-1){ m1=11; y1=Number(y1)-1 }
	var d1=timevar.substring(8,10);
	var h1=timevar.substring(11,13);
	var mm1=timevar.substring(14,16);
	var s1=timevar.substring(17,19);
	var serverdate=new Date(y1,m1,d1,h1,mm1,s1);
	var serverdate1 = serverdate.getTime();
	var time_counter = 1;

function DigitalTime()
{
	//if (!document.layers && !document.all)	return;
	var DigitalClock = new Date(serverdate1 + (1000 * time_counter++) ); 
	//var DigitalClock = new Date();
	var date = DigitalClock.getDate();
	var month = DigitalClock.getMonth() + 1;
	var hours = DigitalClock.getHours();
	var minutes = DigitalClock.getMinutes();
	var seconds = DigitalClock.getSeconds();
	var dn = "AM";
	if (date < 10)
		date = "0" + date;
	if (month < 10)
		month = "0" + month;

	if (hours >= 12)
	{
		dn = "PM";
		hours = hours - 12;
	}
	if (hours == 0)
		hours = 12;

	if (minutes <= 9)
		minutes = "0" + minutes;
	if (seconds <= 9)
		seconds = "0" + seconds;

	//var digclock = "<font size='1' face='Verdana' color='darkgreen'>" + "<font size='1'>&nbsp;Date : </font>" +  dayarray[DigitalClock.getDay()] + ", " + montharray[DigitalClock.getMonth()] + " " + date + ", " + DigitalClock.getYear()  + "<BR>" + "<font size='1'>&nbsp;Time : </font>" + hours + ":" + minutes + ":" + seconds + " " + dn +  "<BR><font size='1' color='red'>&nbsp;(auto refresh in " + document.entryfrm.ReverseCounterID.value + " seconds)</font></font>";
	//var digclock = "<a href='#' onclick='compare_report();'><font size='1' face='Verdana' color='darkgreen'>" + "<font size='1'>&nbsp;Date : </font>" +  dayarray[DigitalClock.getDay()] + ", " + montharray[DigitalClock.getMonth()] + " " + date + ", " + y1 + "<BR>" + "<font size='1'>&nbsp;Time : </font>" + hours + ":" + minutes + ":" + seconds + " " + dn +  "<BR><font size='1' color='red'>&nbsp;(auto refresh in " + document.entryfrm.ReverseCounterID.value + " seconds)</font></font></a>";
	var digclock = "<a href='#' onclick='compare_report();'><font size='1' face='Verdana' color='darkgreen'>" + "<font size='1'>&nbsp;Date : </font>" +  dayarray[DigitalClock.getDay()] + ", " + montharray[DigitalClock.getMonth()] + " " + date + ", " + y1 + "<BR>" + "<font size='1'>&nbsp;Time : </font>" + hours + ":" + minutes + ":" + seconds + " " + dn +  "<BR><font size='1' color='red'>&nbsp;(auto refresh in " + document.entryfrm.ReverseCounterID.value + " seconds)</font></font></a>";
	Clock.innerHTML = digclock;
	setTimeout("DigitalTime()",1000);
 }
</script>
<!-- End :  Reverse Timer Functions -->
</head>

<body onload="DigitalTime(); StartTimer();">
	<div class="wrapper">
	<div class="flag-strip"></div>
	<header class="bg-white py-1">
		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-4">
					<a href="#Home"><h1><span>IVFRT (I)</span><br/>National Informatics Centre</h1></a>
				</div>
				<div class="col-sm-4">
					<img src="Images_Dashboard.png" width="100%" height="90%" alt="Images Dashboard" align="center;">
				</div>
				<div class="col-sm-4 text-end">
					<p id="Clock"></p>
				</div>
			</div> 
		</div>
</header>
	<div class="menu">
	  <nav class="navbar navbar-expand-sm">
		<div class="container"> 
		  <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#collapsibleNavbar"><span class="navbar-toggler-icon"></span> </button>
		  <div class="collapse navbar-collapse" id="collapsibleNavbar">
			<ul class="navbar-nav">
			  <li class="nav-item"><a href="#Home" class="scrollLink nav-link">Home</a></li>
			  <li class="nav-item dropdown"><a href="#Home" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Images</a>
			  <ul class="dropdown-menu">
			  <li> <a class="scrollLink dropdown-item" href="#ICP_images_yearwise">Year-wise : Camera, Passport, D/E Card and Visa Image Statistics</a></li>
			  <li> <a class="scrollLink dropdown-item" href="#ICP_images_daywise">Day-wise : Camera, Passport, D/E Card and Visa Image Statistics</a></li>
			  <li> <a class="scrollLink dropdown-item" href="#ICP_images_monthwise">Month-wise : Camera, Passport, D/E Card and Visa Image Statistics</a></li>
			  <li> <a class="scrollLink dropdown-item" href="#ICP_images_icp-wise">ICP-wise Camera, Passport, D/E Card and Visa Image Statistics</a></ul></li>
			  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Centralised Dashboard</a>
			   <ul class="dropdown-menu">
				<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/" target="_blank">Immigration Control System</a> </li>
				<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_apis.jsp" target="_blank">Advanced Passenger Information System</a> </li>
				<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_epassport.jsp" target="_blank">e-Passport Statistics</a> </li>
			  <li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_evisa.jsp" target="_blank">e-Visa Statistics</a></ul></li>
		   </ul>
		  </div>
		</div>
			<%if(filter_icp.equals("All")) {	%>	
				 <span class="airport_name"><font style="background-color:white; color:#0842af; font-weight: bold; font-size: 35px;">&nbsp;All ICPs&nbsp;</font></span>
			<%} else {%>
				 <span class="airport_name"><font style="background-color:white; color:#0842af; font-weight: bold; font-size: 35px;">&nbsp;<%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%>&nbsp;</font></span>
			<%} %>
	  </nav>
	 </div>

<form name="entryfrm" method="post">
	<input class="input" type="hidden" name="ReverseCounterID" size="55" maxlength="55" value="600">
	<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
		<tr bgcolor="#D0DDEA" align="center">
			<td style="text-align: center;">

			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;Select&nbsp;ICP&nbsp;&nbsp;</b>

			<input height="40" type="text" style="color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="10" name="source_port1" onkeyup="filtery(this.value,this.form.compare_icp)" onchange="filtery(this.value,this.form.compare_icp)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')">			

			<!--filtery function-->
			<!--letternumber function-->
			<select class="form-select-sm" name="compare_icp" onKeyDown="if(event.keyCode==13) event.keyCode=9;">

			<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICP's</option>

			<!--<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICPs</option>-->
<%
			/*rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397','004') order by ICP_DESC");*/
			rsTemp = st_icp.executeQuery("select ICP_SRNO, ICP_DESC from IM_ICP_LIST where icp_srno in (select icp from IM_DASHBOARD_IMG_YAER_WISE_COUNT) order by ICP_DESC ");
			while(rsTemp.next())
			{
%>
				<option value="<%=rsTemp.getString("ICP_SRNO")%>" <%if(filter_icp.equals(rsTemp.getString("ICP_SRNO"))){%> selected<%}%>><%=rsTemp.getString("ICP_DESC")%></option>
<%
			}
			 rsTemp.close();  
			  div_hgt = 200; 
			 if(filter_icp.equals("All")) {
				 div_hgt = 600;
			 }
%> 
			</select>
			&nbsp;
			
			
			&nbsp;&nbsp;<!--<input type="button" class="Button" value="Generate" onclick=" compare_report();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>-->
			<button class="btn btn-primary btn-sm" type="button" onClick="compare_report();"> Generate </button>
			</td>
		</tr>
	</table>
</form>
</div>


	<!--   ************************START HOME DIV*******************HOME DIV*****************START HOME DIV****************START HOME DIV********  -->
	<div class="aboutsection">
	<section id="Home">
	<div class="pt-4" id="home">
	<table id = "auto-index" class="table table-sm table-striped">
	   <thead>
		<tr id='head1'>
				<th colspan="9" >HOME</th>
			</tr>
			<tr id='head' name='home'>
				<th>S.No.</th>
				<th>Date</th>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<th colspan=6>Description</th>
			</tr>
		</thead>
</table><br>
</section>
		<%!
		// Function to Print numbers in Indian Format

		public String getIndianFormat(int num){

			String convertedNumber = "";
			int digitCount = 1;
			
			do{
				int currentDigit = num%10;
				num = num /10;
				if( digitCount%2 ==0 && digitCount!=2)
					convertedNumber = currentDigit + "," + convertedNumber;
				else
					convertedNumber = currentDigit + convertedNumber;
				digitCount++;
			}while(num>0);
			return convertedNumber;
		}


		// Function to reverse time attributes in graph

		    public static String reverseOnComma(String input){

			String parts[] = input.split(",");
			StringBuilder reversed = new StringBuilder();

			for(int i = parts.length - 1; i >= 0; i--){
			reversed.append(parts[i]);
			if(i>0){
				reversed.append(",");
			}
		}
		return reversed.toString();
	}
%>



<%//====================Camera Tabs	============================%

	try 
	{
		dashQuery = "select SUM(CAMERA_IMAGE) as Camera_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT" + vishwaFilter; //out.println("<BR><BR><BR><BR><BR><BR><BR><BR>"+dashQuery);
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if(rsTemp.next()) 
		{
			total_Camera_Count = rsTemp.getInt("Camera_Count");
		}
		rsTemp.close();
		psTemp.close();
	} 
	catch (Exception e) {out.println("total_Camera_Count Exception");}
/*
	try
	{
		dashQuery = "select count(1) as Camera_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			yesterday_Camera_Count = rsTemp.getInt("Camera_Count");
		}
		rsTemp.close();
		psTemp.close();
	} 
	catch (Exception e) {out.println("yesterday_Camera_Count Exception");}

	try 
	{
		dashQuery = "select count(1) as Camera_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			today_Camera_Count = rsTemp.getInt("Camera_Count");
		}
		rsTemp.close();
		psTemp.close();
	} 
	catch (Exception e) {out.println("today_Camera_Count Exception");}
*/
%>
<br><br><br><br><br>

<div class="container-fluid">
<div class="row">
<div class="col-sm-3">
	<table class="tableDesign" width="50px">
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;font-size: 35px;">Camera&nbsp;Images</th>
		</tr>
		<!-- <tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #004076;"><%=today_Camera_Count%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #004076;">&nbsp;Today's&nbsp;e&#8209;Passports</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td  style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color :#0072d3"><%=yesterday_Camera_Count%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color :#0072d3">&nbsp;Yesterday's&nbsp;e&#8209;Passports</td>
		</tr> -->
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="count_total_Camera_Count" colspan="2" style="background-color:#bae6ff;border-color: #bae6ff;width:50%;height:50px; font-weight: bold; text-align: center;font-size: 30px;color: #004076;"></td>
<!-- 			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #44a9ff;">&nbsp;Total&nbsp;Camera&nbsp;Images</td>
 -->		</tr>
	</table>
</div>
<%
/////////////////////////////////////////////////////////////


///////////////////////////  Passport Tab /////////////////////////////////////////
int today_Passport_Count = 0;
int yesterday_Passport_Count = 0;
int total_PAX_Count = 0;
int total_Yest_Count = 0;
int total_Today_PAX_Count = 0;

	try 
	{
		dashQuery = "select SUM(PASSPORT_IMAGE) as Passport_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT" + vishwaFilter; 
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			total_Passport_Count = total_Passport_Count+rsTemp.getInt("Passport_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("total_Passport_Count Exception");}
/*
	try 
	{
		dashQuery = "select count(1) as Passport_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			yesterday_Passport_Count = rsTemp.getInt("Passport_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("yesterday_Passport_Count Exception");}

	try 
	{
		dashQuery = "select count(1) as Passport_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			today_Passport_Count = rsTemp.getInt("Passport_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {	out.println("today_Passport_Count Exception");}
*/
%>
<div class="col-sm-3">
	<table class="tableDesign">		
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #6929c4;height:20px;">
			<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0;width:40%; text-align: center;font-size: 35px;">Passport&nbsp;Images</th>
		</tr>
		<!-- <tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #5521a0;"><%=today_Passport_Count%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #5521a0;" >&nbsp;Today's&nbsp;e&#8209;Passports</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color: #864cd9;"><%=yesterday_Passport_Count%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #864cd9;">&nbsp;Yesterday's&nbsp;e&#8209;Passports</td>
		</tr> -->
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="count_total_Passport_Count" colspan="2" style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: center;font-size: 30px;color: #5521a0;"></td>
<!-- 			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #a376e2;">&nbsp;Total&nbsp;Passport&nbsp;Images</td>
 -->		</tr>
	</table>
</div>

</section>

<%//=========================	DE Card tabs	=======================%>
<%

String dashQuery_DEcard = "";
int today_DECard_Count = 0;
int yesterday_DECard_Count = 0;
int total_PAX_Count_DEcard = 0;
int total_Yest_Count_DEcard = 0;
int total_Today_PAX_Count_DEcard = 0;
int total_DECard_Count  = 0;

	try 
	{
		dashQuery = "select SUM(DECARD_IMAGE) as DECard_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT" + vishwaFilter;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			total_DECard_Count = rsTemp.getInt("DECard_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("total_DECard_Count Exception");}
/*
	try 
	{
		dashQuery = "select count(1) as DECard_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			yesterday_DECard_Count = rsTemp.getInt("DECard_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("yesterday_DECard_Count Exception");}

	try 
	{
		dashQuery = "select count(1) as DECard_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			today_DECard_Count = rsTemp.getInt("DECard_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("today_DECard_Count Exception");}
*/
%>

<div class="col-sm-3">
	<table class="tableDesign" width="50px">
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#005d5d;border-color: #005d5d;width:40%;text-align: center;font-size: 35px;">D/E&nbsp;Card&nbsp;Images</th>
		</tr>
		<!-- <tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #004076;" ><%=today_DECard_Count%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #004076;">&nbsp;Today's&nbsp;D/E&nbsp;Card&nbsp;Images</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td  style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color :#0072d3"><%=yesterday_DECard_Count%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color :#0072d3">&nbsp;Yesterday's&nbsp;D/E&nbsp;Card&nbsp;Images</td>
		</tr> -->
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="total_DECard_Count_ID" colspan="2" style="background-color:#9ef0f0;border-color: #9ef0f0;width:50%; font-weight: bold; text-align: center;font-size: 30px;color: #004144;"></td>
<!-- 			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #44a9ff;">&nbsp;Total&nbsp;D/E&nbsp;Card&nbsp;Images</td>
 -->		</tr>
	</table>
</div>


<%//=========================	Visa tabs	=======================
int today_Visa_Count = 0;
int yesterday_Visa_Count = 0;

int total_Visa_Count  = 0;

	try 
	{
		dashQuery = "select SUM(VISA_IMAGE) as Visa_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT" + vishwaFilter;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			total_Visa_Count = rsTemp.getInt("Visa_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("total_Visa_Count Exception");}
/*
	try 
	{
		dashQuery = "select count(1) as Visa_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			yesterday_Visa_Count = rsTemp.getInt("Visa_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("yesterday_Visa_Count Exception");}

	try 
	{
		dashQuery = "select count(1) as Visa_Count from IM_DASHBOARD_IMG_YAER_WISE_COUNT where 1=2 " + vishwaFilter ;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) 
		{
			today_Visa_Count = rsTemp.getInt("Visa_Count");
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {out.println("today_Visa_Count Exception");}
*/
%>
<div class="col-sm-3">
	<table class="tableDesign">		
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #6929c4;height:20px;">
			<th colspan="2" style="text-align: center;background-color:#a2191f;border-color: #a2191f;width:40%; text-align: center;font-size: 35px;">Visa&nbsp;Images</th>
		</tr>
		<!-- <tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #5521a0;"><%=today_Visa_Count%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #5521a0;" >&nbsp;Today's&nbsp;e&#8209;Visa</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color: #864cd9;"><%=yesterday_Visa_Count%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #864cd9;">&nbsp;Yesterday's&nbsp;e&#8209;Visa</td>
		</tr> -->
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="total_Visa_Count_ID" colspan="2" style="background-color:#ffd7d9;border-color: #ffd7d9;width:50%; font-weight: bold; text-align: center;font-size: 30px;color: #750e13;"></td>
<!-- 			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #a376e2;">&nbsp;Total&nbsp;Visa&nbsp;Images</td>
 -->		</tr>
	</table>
</div>
</div>
</div>
<%////////////////////////	Total of All Four TABS	///////////////////////%>
<br>

<div class="container-fluid">
<div class="row">
<div class="col-sm-3" style="margin:auto;">
	<table class="tableDesign" width="50px">
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:10px; ">
			<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;font-size: 60px;"><%=getIndianFormat((total_Camera_Count + total_Passport_Count + total_DECard_Count + total_Visa_Count))%></th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:10px;">
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: center;font-size: 35px;color: #004076;" >Total&nbsp;Images</td>
		</tr>
	</table>
</div>
</div>
</div>
<%///////////////////////////////////////////

String SQLQUERY = "";
StringBuilder WeekDays = new StringBuilder();
StringBuilder weekArrPax = new StringBuilder();
StringBuilder weekDepPax = new StringBuilder();

StringBuilder YearDays = new StringBuilder();
StringBuilder YearArrPax = new StringBuilder();
StringBuilder YearDepPax = new StringBuilder();

StringBuilder TotalDays = new StringBuilder();
StringBuilder TotalCamera = new StringBuilder();
StringBuilder TotalPassport = new StringBuilder();
StringBuilder TotalEDCard = new StringBuilder();
StringBuilder TotalVisa = new StringBuilder();

String strWeekDays = "";
String strweekArrPax = "";
String strweekDepPax = "";

String strYearDays = "";
String strYearArrPax = "";
String strYearDepPax = "";

String strTotalDays = "";
String strTotalCamera = "";
String strTotalPassport = "";
String strTotalEDCard = "";
String strTotalVisa = "";



StringBuilder NaltyPax = new StringBuilder();
StringBuilder ArrNaltyPax = new StringBuilder();
StringBuilder DepNaltyPax = new StringBuilder();
String strNaltyPax = "";
String strArrNalty = "";
String strDepNalty = "";

StringBuilder NaltyPax_Week = new StringBuilder();
StringBuilder ArrNaltyPax_Week = new StringBuilder();
StringBuilder DepNaltyPax_Week = new StringBuilder();
String strNaltyPax_Week = "";
String strArrNalty_Week = "";
String strDepNalty_Week = "";

%>

	<%////////////////////////////////////////////// All ICPs Arrival and Departure e-Passport Statistics /////////////////////////////////////////%>
		<section id="ICP_images_yearwise">
		<div class="pt-4" id="ICP_1"><br><br><br><br><br><br><br>
	<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>

				<tr id='head1'>
				<%if(filter_icp.equals("All")) {%>	
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">Year-wise : All ICPs Camera, Passport, D/E Card and Visa Image Statistics</th>
				<%} else {%>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">Year-wise : <%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Camera, Passport, D/E Card and Visa Image Statistics</th>
				<%} %>
				</tr>
				
			</thead>
			
		</table>
		</section>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-5">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #009688;height:12px;">
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%;">Year</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Camera&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Passport&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">D/E&nbsp;Card&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Visa&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Total&nbsp;</th>
			</tr>
<%
	int all_ICP_Camera_Total = 0 ;
	int all_ICP_Passport_Total = 0 ;
	int all_ICP_DECard_Total = 0 ;
	int all_ICP_Visa_Total = 0 ;
	int all_ICP_Total = 0 ;
	int Rest_Camera_Total = 0;
	int Rest_Passport_Total = 0;
	int Rest_DECard_Total = 0;
	int Rest_Visa_Total = 0;
try
	{
	SQLQUERY = "";
	SQLQUERY = "select year as arr_year,sum(CAMERA_IMAGE) as camera_count,sum(PASSPORT_IMAGE) as passport_count,sum(DECARD_IMAGE) as decard_count,sum(VISA_IMAGE) as visa_count from IM_DASHBOARD_IMG_YAER_WISE_COUNT "+ vishwaFilter +" group by year order by 1 desc";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
		/*	if(rsTemp.getInt("arr_year") < 2005 ) 
		{
				Rest_Camera_Total = Rest_Camera_Total + rsTemp.getInt("camera_count");
				Rest_Passport_Total = Rest_Passport_Total + rsTemp.getInt("passport_count");
				Rest_DECard_Total = Rest_DECard_Total + rsTemp.getInt("decard_count");
				Rest_Visa_Total = Rest_Visa_Total + rsTemp.getInt("visa_count");
				continue;
		}*/
			if(rsTemp.getInt("arr_year") >= 2010 ) 
			{
			TotalDays.append("\"");
			TotalDays.append(rsTemp.getString("arr_year"));
			TotalDays.append("\"");
			TotalDays.append(",");
			TotalCamera.append(rsTemp.getInt("camera_count")+",");
			TotalPassport.append(rsTemp.getInt("passport_count")+",");
			TotalEDCard.append(rsTemp.getInt("decard_count")+",");
			TotalVisa.append(rsTemp.getInt("visa_count")+",");

			}
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold;text-align: center;"><%=rsTemp.getString("arr_year")%></td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("camera_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("camera_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("passport_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("passport_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("decard_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("decard_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("visa_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("visa_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;color: #005653;font-size:15px;"><%=getIndianFormat((rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count")))%>&nbsp;</td>
			</tr>
<%
			all_ICP_Camera_Total = all_ICP_Camera_Total + rsTemp.getInt("camera_count");
			all_ICP_Passport_Total = all_ICP_Passport_Total + rsTemp.getInt("passport_count");
			all_ICP_DECard_Total = all_ICP_DECard_Total + rsTemp.getInt("decard_count");
			all_ICP_Visa_Total = all_ICP_Visa_Total + rsTemp.getInt("visa_count");
			all_ICP_Total = all_ICP_Total + rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count");
		}
%>			<tr style="font-size: 16px;  text-align: right; color:#005653; border-color: #009688;height:12px;">
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold;text-align: center;">Total</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Camera_Total)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Passport_Total)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_DECard_Total)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Visa_Total)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;font-size:15px;"><%=getIndianFormat(all_ICP_Total)%>&nbsp;</td>
			</tr>
			<%
			rsTemp.close();
			psTemp.close();

			strTotalDays = TotalDays.toString();
			strTotalDays = strTotalDays.substring(0,strTotalDays.length()-1);
			strTotalCamera = TotalCamera.toString();

			strTotalCamera = strTotalCamera.substring(0,strTotalCamera.length()-1);

			strTotalPassport = TotalPassport.toString();
			strTotalPassport = strTotalPassport.substring(0,strTotalPassport.length()-1);
			strTotalEDCard = TotalEDCard.toString();
			strTotalEDCard = strTotalEDCard.substring(0,strTotalEDCard.length()-1);
			strTotalVisa = TotalVisa.toString();
			strTotalVisa = strTotalVisa.substring(0,strTotalVisa.length()-1);
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>	<!-- getIndianFormat( -->
<div class="col-sm-7">
<div class="card"style="border: solid 3px #007d79; border-radius: 20px;" >
<div class="card-body" style="height:1700px;">
 <canvas id="canvasAll_Icp" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #cdf7f7 100%);border-radius: 20px;height:1700px;"></canvas>
</div>
</div>
</div>
</div>
</div>
 <script>
	
	// Data define for bar chart

	var myData_total = {
		labels: [<%=strTotalDays%>],
		datasets: [{ 
			  label: "Camera",
			  backgroundColor: "#007d79",
			  borderColor: "#005555",
			  borderWidth: 1,
			  data: [<%=strTotalCamera%>]
		}, { 
			  label: "Passport",
			  backgroundColor: "#FFBB5C",
			  borderColor: "#FFBB5C",
			  borderWidth: 2,
			  data: [<%=strTotalPassport%>]
		}, { 
			  label: "D/E Card",
			  backgroundColor: "slateblue",
			  borderColor: "slateblue",
			  borderWidth: 2,
			  data: [<%=strTotalEDCard%>]
		}, { 
			  label: "Visa",
			  backgroundColor: "red",
			  borderColor: "red",
			  borderWidth: 2,
			  data: [<%=strTotalVisa%>]
		}]
	};

// Options to display value on top of bars

	var myoptions = {
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: false, //removes y axis values in  bar graph 
							},
					gridLines: { 
								display:false,
								}
					}],
					yAxes: [{
					gridLines: { 
								color: "#007d79"
								}

					}]
				},
				 title: {
						display: true,
							text:'Year-wise : Camera, Passport, D/E Card and Visa Image Statistics',
						fontSize: 25,		
					  },
		tooltips: {
			enabled: true
		},
		hover: {
			animationDuration: 2
		},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#0F292F";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							if(i == 0) ctx.fillText(data.toLocaleString('en-IN') + " [CAM]", bar._model.x+60, bar._model.y+5 );
							else if(i == 1) ctx.fillText(data.toLocaleString('en-IN') + " [MRZ]", bar._model.x+60, bar._model.y+5 );
							else if(i == 2) ctx.fillText(data.toLocaleString('en-IN') + " [D/E Card]", bar._model.x+70, bar._model.y+5 );
							else  ctx.fillText(data.toLocaleString('en-IN') + " [VISA]", bar._model.x+60, bar._model.y+5 );
							
							//Add .toLocaleString('en-IN') for Indian Format in JavaScript
						});
					});
				}
			},
			
		};

		//Code to draw Chart
	var ctx = document.getElementById('canvasAll_Icp').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'horizontalBar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>

	










<%////////////////////////	Start - Daywise	///////////////////////////////%>
<%///////////////////////////////////////////

//String SQLQUERY = "";
StringBuilder TotalDays_daywise = new StringBuilder();
StringBuilder TotalCamera_daywise = new StringBuilder();
StringBuilder TotalPassport_daywise = new StringBuilder();
StringBuilder TotalEDCard_daywise = new StringBuilder();
StringBuilder TotalVisa_daywise = new StringBuilder();
String strTotalDays_daywise = "";
String strTotalCamera_daywise = "";
String strTotalPassport_daywise = "";
String strTotalEDCard_daywise = "";
String strTotalVisa_daywise = "";
%>

<%////////////////////////////////////////////// Day-wise  /////////////////////////////////////////%>
<section id="ICP_images_daywise">
<div class="pt-4" id="ICP_1"><br><br><br><br><br><br><br>
<table id = "auto-index1" class="table table-sm table-striped" >
	<thead>

		<tr id='head1'>
		<%if(filter_icp.equals("All")) {%>	
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">Day-wise : All ICPs Camera, Passport, D/E Card and Visa Image Statistics</th>
		<%} else {%>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">Day-wise : <%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Camera, Passport, D/E Card and Visa Image Statistics</th>
		<%} %>
		</tr>
	</thead>
</table>
</section>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-5">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #009688;height:12px;">
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%;">Date</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Camera&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Passport&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">D/E&nbsp;Card&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Visa&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Total&nbsp;</th>
			</tr>
<%
	int all_ICP_Camera_Total_daywise = 0 ;
	int all_ICP_Passport_Total_daywise = 0 ;
	int all_ICP_DECard_Total_daywise = 0 ;
	int all_ICP_Visa_Total_daywise = 0 ;
	int all_ICP_Total_daywise = 0 ;
	int Rest_Camera_Total_daywise = 0;
	int Rest_Passport_Total_daywise = 0;
	int Rest_DECard_Total_daywise = 0;
	int Rest_Visa_Total_daywise = 0;
try
	{
	SQLQUERY = "";
	SQLQUERY = "select to_char(schedule_date,'dd/mm/yyyy') as schedule_date ,sum(CAMERA_IMAGE) as camera_count,sum(PASSPORT_IMAGE) as passport_count,sum(DECARD_IMAGE) as decard_count,sum(VISA_IMAGE) as visa_count from IM_DASHBOARD_IMG_DAY_WISE_COUNT where schedule_date >= trunc(sysdate-7) and schedule_date <= trunc(sysdate) "+ vishwaFilter.replace("where","and") +" group by schedule_date order by 1 desc";
	//out.println(SQLQUERY);
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){

		/*	if(rsTemp.getInt("arr_year") < 2005 ) 
		{
				Rest_Camera_Total_daywise = Rest_Camera_Total_daywise + rsTemp.getInt("camera_count");
				Rest_Passport_Total_daywise = Rest_Passport_Total_daywise + rsTemp.getInt("passport_count");
				Rest_DECard_Total_daywise = Rest_DECard_Total_daywise + rsTemp.getInt("decard_count");
				Rest_Visa_Total_daywise = Rest_Visa_Total_daywise + rsTemp.getInt("visa_count");
				continue;
		}*/
			//if(rsTemp.getString("schedule_date") >= 2010 ) 
			{
			TotalDays_daywise.append("\"");
			TotalDays_daywise.append(rsTemp.getString("schedule_date"));
			TotalDays_daywise.append("\"");
			TotalDays_daywise.append(",");

			TotalCamera_daywise.append(rsTemp.getInt("camera_count")+",");
			TotalPassport_daywise.append(rsTemp.getInt("passport_count")+",");
			TotalEDCard_daywise.append(rsTemp.getInt("decard_count")+",");
			TotalVisa_daywise.append(rsTemp.getInt("visa_count")+",");
			}
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold;text-align: center;"><%=rsTemp.getString("schedule_date")%></td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("camera_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("camera_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("passport_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("passport_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("decard_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("decard_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("visa_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("visa_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;color: #005653;font-size:15px;"><%=getIndianFormat((rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count")))%>&nbsp;</td>
			</tr>
<%
			all_ICP_Camera_Total_daywise = all_ICP_Camera_Total_daywise + rsTemp.getInt("camera_count");
			all_ICP_Passport_Total_daywise = all_ICP_Passport_Total_daywise + rsTemp.getInt("passport_count");
			all_ICP_DECard_Total_daywise = all_ICP_DECard_Total_daywise + rsTemp.getInt("decard_count");
			all_ICP_Visa_Total_daywise = all_ICP_Visa_Total_daywise + rsTemp.getInt("visa_count");
			all_ICP_Total_daywise = all_ICP_Total_daywise + rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count");
		}
%>			<tr style="font-size: 16px;  text-align: right; color:#005653; border-color: #009688;height:12px;">
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold;text-align: center;">Total</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Camera_Total_daywise)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Passport_Total_daywise)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_DECard_Total_daywise)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Visa_Total_daywise)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;font-size:15px;"><%=getIndianFormat(all_ICP_Total_daywise)%>&nbsp;</td>
			</tr>
			<%
			rsTemp.close();
			psTemp.close();

			strTotalDays_daywise = TotalDays_daywise.toString();
			strTotalDays_daywise = strTotalDays_daywise.substring(0,strTotalDays_daywise.length()-1);
			strTotalCamera_daywise = TotalCamera_daywise.toString();
			strTotalCamera_daywise = strTotalCamera_daywise.substring(0,strTotalCamera_daywise.length()-1);
			strTotalPassport_daywise = TotalPassport_daywise.toString();
			strTotalPassport_daywise = strTotalPassport_daywise.substring(0,strTotalPassport_daywise.length()-1);
			strTotalEDCard_daywise = TotalEDCard_daywise.toString();
			strTotalEDCard_daywise = strTotalEDCard_daywise.substring(0,strTotalEDCard_daywise.length()-1);
			strTotalVisa_daywise = TotalVisa_daywise.toString();
			strTotalVisa_daywise = strTotalVisa_daywise.substring(0,strTotalVisa_daywise.length()-1);
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Day-wise - End	////////////////////////%>
<div class="col-sm-7">
<div class="card"style="border: solid 3px #007d79; border-radius: 20px; height:700px;" >
<div class="card-body" style="height:700px;">
<canvas id="canvasAll_Icp_daywise" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #cdf7f7 100%);border-radius: 20px;height:700px;"></canvas>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strTotalDays_daywise%>],
		datasets: [{ 
			  label: "Camera",
			  backgroundColor: "#007d79",
			  borderColor: "#005555",
			  borderWidth: 1,
			  data: [<%=strTotalCamera_daywise%>]
		}, { 
			  label: "Passport",
			  backgroundColor: "#FFBB5C",
			  borderColor: "#FFBB5C",
			  borderWidth: 2,
			  data: [<%=strTotalPassport_daywise%>]
		}, { 
			  label: "D/E Card",
			  backgroundColor: "slateblue",
			  borderColor: "slateblue",
			  borderWidth: 2,
			  data: [<%=strTotalEDCard_daywise%>]
		}, { 
			  label: "Visa",
			  backgroundColor: "red",
			  borderColor: "red",
			  borderWidth: 2,
			  data: [<%=strTotalVisa_daywise%>]
		}]
	};

// Options to display value on top of bars

	var myoptions = {
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: false, //removes y axis values in  bar graph 
							},
					gridLines: { 
								display:false,
								}
					}],
					yAxes: [{
					gridLines: { 
								color: "#007d79"
								}

					}]
				},
				 title: {
						display: true,
							text:'Day-wise : Camera, Passport, D/E Card and Visa Image Statistics',
						fontSize: 25,		
					  },
		tooltips: {
			enabled: true
		},
		hover: {
			animationDuration: 2
		},
		animation: {
		duration: 1,
		onComplete: function () {
			var chartInstances = this.chart,
				ctx = chartInstances.ctx;
				ctx.textAlign = 'center';
				ctx.fillStyle = "#0F292F";
				ctx.textBaseline = 'bottom';
				ctx.font = "bold 10px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
							if(i == 0) ctx.fillText(data.toLocaleString('en-IN') + " [CAM]", bar._model.x+45, bar._model.y+5 );
							else if(i == 1) ctx.fillText(data.toLocaleString('en-IN') + " [MRZ]", bar._model.x+45, bar._model.y+5 );
							else if(i == 2) ctx.fillText(data.toLocaleString('en-IN') + " [D/E Card]", bar._model.x+65, bar._model.y+5 );
							else  ctx.fillText(data.toLocaleString('en-IN') + " [VISA]", bar._model.x+50, bar._model.y+5 );					});

							//Add .toLocaleString('en-IN') for Indian Format in JavaScript
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasAll_Icp_daywise').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'horizontalBar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>

<%		 /*if (start for ICP = All)*/

//if(filter_icp.equals("Alll"))
	{	
%>
	</div>
	</div>
<%////////////////////////	End - Day-wise	///////////////////////////////%>


<%////////////////////////	Start - Month-wise	///////////////////////////////%>
<section id="ICP_images_monthwise">
<div class="pt-4" id="ICP_images_monthwise"><br><br><br><br><br><br><br>
<table id = "auto-index1" class="table table-sm table-striped" >
	<thead>
	<tr id='head1'>
	<%if(filter_icp.equals("All")) {%>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">Month-wise : All ICPs Camera, Passport, D/E Card and Visa Image Statistics</th>
	<%} else {%>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">Month-wise : <%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Camera, Passport, D/E Card and Visa Image Statistics</th>
	<%} %>
	</tr>
	</thead>
</table>
</section>



<div class="row">
<div class="col-sm-12">
		<table class="tableDesign" style="height: 500px; width:900px;	margin: auto;">
		<thead>
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #009688;height:12px;	position: sticky; top: 0; ">
	<%if(filter_icp.equals("All")) {%>	
				<th colspan="6" style="text-align: center;background-color:#007d79;border-color: #007d79;width:16.66%;	position: sticky; top: 0; ">Month-wise : All ICPs Camera, Passport, D/E Card and Visa Image Statistics</th>
	<%} else {%>
				<th colspan="6" style="text-align: center;background-color:#007d79;border-color: #007d79;width:16.66%;	position: sticky; top: 0; ">Month-wise : <%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Camera, Passport, D/E Card and Visa Image Statistics</th>
	<%} %>
			</tr>
		</thead>
		</table>
<div class="fixTableHead">
<table class="tableDesign_month">
		<thead>
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #009688;height:12px; ">
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:16.66%;text-align: left;">&nbsp;&nbsp;&nbsp;Month-Year</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:16.66%; text-align: right;">Camera&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:16.66%; text-align: right;">Passport&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:16.66%; text-align: right;">D/E&nbsp;Card&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:16.66%; text-align: right;">Visa&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:16.66%; text-align: right;">Total&nbsp;</th>
			</tr>
		</thead>
<%
int all_ICP_Camera_Total_monthwise = 0 ;
int all_ICP_Passport_Total_monthwise = 0 ;
int all_ICP_DECard_Total_monthwise = 0 ;
int all_ICP_Visa_Total_monthwise = 0 ;
int all_ICP_Total_monthwise = 0 ;
int Rest_Camera_Total_monthwise = 0;
int Rest_Passport_Total_monthwise = 0;
int Rest_DECard_Total_monthwise = 0;
int Rest_Visa_Total_monthwise = 0;

StringBuilder TotalDays_monthwise = new StringBuilder();
StringBuilder TotalCamera_monthwise = new StringBuilder();
StringBuilder TotalPassport_monthwise = new StringBuilder();
StringBuilder TotalEDCard_monthwise = new StringBuilder();
StringBuilder TotalVisa_monthwise = new StringBuilder();
String strTotalDays_monthwise = "";
String strTotalCamera_monthwise = "";
String strTotalPassport_monthwise = "";
String strTotalEDCard_monthwise = "";
String strTotalVisa_monthwise = "";

try
	{
	SQLQUERY = "";
	SQLQUERY = "select MONTH_DATE as month_date ,sum(CAMERA_IMAGE) as camera_count,sum(PASSPORT_IMAGE) as passport_count,sum(DECARD_IMAGE) as decard_count,sum(VISA_IMAGE) as visa_count from IM_DASHBOARD_IMG_MONTH_WISE_COUNT  "+ vishwaFilter +" group by month_date order by 1 desc";
	//out.println(SQLQUERY);
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){

		/*	if(rsTemp.getInt("arr_year") < 2005 ) 
		{
				Rest_Camera_Total_monthwise = Rest_Camera_Total_monthwise + rsTemp.getInt("camera_count");
				Rest_Passport_Total_monthwise = Rest_Passport_Total_monthwise + rsTemp.getInt("passport_count");
				Rest_DECard_Total_monthwise = Rest_DECard_Total_monthwise + rsTemp.getInt("decard_count");
				Rest_Visa_Total_monthwise = Rest_Visa_Total_monthwise + rsTemp.getInt("visa_count");
				continue;
		}*/
			//if(rsTemp.getString("schedule_date") >= 2010 ) 
			{
			TotalDays_monthwise.append("\"");
			TotalDays_monthwise.append(rsTemp.getString("month_date"));
			TotalDays_monthwise.append("\"");
			TotalDays_monthwise.append(",");

			TotalCamera_monthwise.append(rsTemp.getInt("camera_count")+",");
			TotalPassport_monthwise.append(rsTemp.getInt("passport_count")+",");
			TotalEDCard_monthwise.append(rsTemp.getInt("decard_count")+",");
			TotalVisa_monthwise.append(rsTemp.getInt("visa_count")+",");
			}
			%>

			<tr style="font-size: 14px; font-family: 'Arial', serif; height:18px;">
				<td style="background-color:#eefdfd;border-color:#005555;width:16.66%; font-weight: bold;text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;<%=monthValue.get(rsTemp.getString("month_date").substring(4,6)) + "-" +rsTemp.getString("month_date").substring(0,4)%></td>
				<td style="background-color:#eefdfd;border-color:#005555;width:16.66%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("camera_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("camera_count"))%>&nbsp;</td>
				<td style="background-color:#eefdfd;border-color:#005555;width:16.66%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("passport_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("passport_count"))%>&nbsp;</td>
				<td style="background-color:#eefdfd;border-color:#005555;width:16.66%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("decard_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("decard_count"))%>&nbsp;</td>
				<td style="background-color:#eefdfd;border-color:#005555;width:16.66%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("visa_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("visa_count"))%>&nbsp;</td>
				<td style="background-color:#eefdfd;border-color:#005555;width:16.66%; font-weight: bold; text-align: right;color: #005653;font-size:15px;"><%=getIndianFormat((rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count")))%>&nbsp;</td>
			</tr>
<%
			all_ICP_Camera_Total_monthwise = all_ICP_Camera_Total_monthwise + rsTemp.getInt("camera_count");
			all_ICP_Passport_Total_monthwise = all_ICP_Passport_Total_monthwise + rsTemp.getInt("passport_count");
			all_ICP_DECard_Total_monthwise = all_ICP_DECard_Total_monthwise + rsTemp.getInt("decard_count");
			all_ICP_Visa_Total_monthwise = all_ICP_Visa_Total_monthwise + rsTemp.getInt("visa_count");
			all_ICP_Total_monthwise = all_ICP_Total_monthwise + rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count");
		}
%>			<tr style="font-size: 16px;  text-align: right; color:#005653; border-color: #009688;height:12px;">
				<td style="background-color:#bdf7f7;border-color:#005555;width:33.33%; font-weight: bold;text-align: center;">Total</td>
				<td style="background-color:#bdf7f7;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Camera_Total_monthwise)%>&nbsp;</td>
				<td style="background-color:#bdf7f7;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Passport_Total_monthwise)%>&nbsp;</td>
				<td style="background-color:#bdf7f7;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_DECard_Total_monthwise)%>&nbsp;</td>
				<td style="background-color:#bdf7f7;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Visa_Total_monthwise)%>&nbsp;</td>
				<td style="background-color:#bdf7f7;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;font-size:15px;"><%=getIndianFormat(all_ICP_Total_monthwise)%>&nbsp;</td>
			</tr>
			<%
			rsTemp.close();
			psTemp.close();

			/*strTotalDays_monthwise = TotalDays_monthwise.toString();
			strTotalDays_monthwise = strTotalDays_monthwise.substring(0,strTotalDays_monthwise.length()-1);
			strTotalCamera_monthwise = TotalCamera_monthwise.toString();
			strTotalCamera_monthwise = strTotalCamera_monthwise.substring(0,strTotalCamera_monthwise.length()-1);
			strTotalPassport_monthwise = TotalPassport_monthwise.toString();
			strTotalPassport_monthwise = strTotalPassport_monthwise.substring(0,strTotalPassport_monthwise.length()-1);
			strTotalEDCard_monthwise = TotalEDCard_monthwise.toString();
			strTotalEDCard_monthwise = strTotalEDCard_monthwise.substring(0,strTotalEDCard_monthwise.length()-1);
			strTotalVisa_monthwise = TotalVisa_monthwise.toString();
			strTotalVisa_monthwise = strTotalVisa_monthwise.substring(0,strTotalVisa_monthwise.length()-1);
			*/
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>
		</div>
		</div>

<%///////////////////////	Table -  Month-wise - End	////////////////////////%>

<%////////////////////////	End - Month-wise	///////////////////////////////%>


	<%//////////////////////////	ICP-wise Arrival and Departure e-Passport Statistics	//////////////////////////////////////////%>

<section id="ICP_images_icp-wise">
<div class="pt-4" id="ICP_images_icp-wise"><br><br><br><br><br>
<br><br><table id = "auto-index1" class="table table-sm table-striped">
	<thead>
		<tr id='head1'>
			<th colspan="4" style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">ICP-wise Camera, Passport, D/E Card and Visa Image Statistics</th>
		</tr>
	</thead>
</table><br>

<div class="scroll-container">
	<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
		<table>
<%	
int srno = 0;
SQLQUERY = "";
int img_Camera_Total = 0 ;
int img_Passport_Total = 0 ;
int img_DECard_Total = 0 ;
int img_Visa_Total = 0 ;
int img_Total = 0 ;
int Rest_ICP_Camera_Total = 0;
int Rest_ICP_Passport_Total = 0;
int Rest_ICP_DECard_Total = 0;
int Rest_ICP_Visa_Total = 0;
StringBuilder IcpPax = new StringBuilder();
StringBuilder ICP_Camera = new StringBuilder();
StringBuilder ICP_Passport = new StringBuilder();
StringBuilder ICP_DECard = new StringBuilder();
StringBuilder ICP_Visa = new StringBuilder();

String strIcpPax = "";
String strICP_Camera = "";
String strICP_Passport = "";
String strICP_DECard = "";
String strICP_Visa = "";

try
	{
	SQLQUERY = " select ICP,sum(CAMERA_IMAGE) as camera_count,sum(PASSPORT_IMAGE) as passport_count, sum(DECARD_IMAGE) as decard_count,sum(VISA_IMAGE) as visa_count from IM_DASHBOARD_IMG_YAER_WISE_COUNT "+ vishwaFilter +" group by ICP order by 2 desc";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {
			/*if(rsTemp.getInt("arr_year") < 2005 ) 
		{
				Rest_ICP_Camera_Total = Rest_ICP_Camera_Total + rsTemp.getInt("camera_count");
				Rest_ICP_Passport_Total = Rest_ICP_Passport_Total + rsTemp.getInt("passport_count");
				Rest_ICP_DECard_Total = Rest_ICP_DECard_Total + rsTemp.getInt("decard_count");
				Rest_ICP_Visa_Total = Rest_ICP_Visa_Total + rsTemp.getInt("visa_count");
				continue;
		}*/

			if(srno < 20)
			{
			IcpPax.append("\"");
			IcpPax.append(icpValue.get(rsTemp.getString("ICP")) == null ? rsTemp.getString("ICP") : icpValue.get(rsTemp.getString("ICP")));
			IcpPax.append("\"");
			IcpPax.append(",");
			ICP_Camera.append(rsTemp.getInt("camera_count")+",");
			ICP_Passport.append(rsTemp.getInt("passport_count")+",");
			ICP_DECard.append(rsTemp.getInt("decard_count")+",");
			ICP_Visa.append(rsTemp.getInt("visa_count")+",");
			}
			if(srno%14 == 0)
			{
				if(srno!=0)
				{%>
					</td>
					</table>
					</div><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<%}
				%>
				<td>
					<div class="col-sm-4" style="width:750px;">
						<table class="tableDesign">
						
						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
							<th style="background-color:#ed459d;border-color: #ce217b;text-align: center; width:10%;">S.No.</th>
							<th style="background-color:#ed459d;border-color: #ce217b;text-align: left;width:20%;">ICP</th>
							<th style="background-color:#ed459d;border-color: #ce217b; text-align: right;width:22%;">Camera&nbsp;</th>
							<th style="background-color:#ed459d;border-color: #ce217b; text-align: right;width:23%;">Passport&nbsp;</th>
							<th style="background-color:#ed459d;border-color: #ce217b; text-align: right;width:23%;">D/E&nbsp;Card&nbsp;</th>
							<th style="background-color:#ed459d;border-color: #ce217b; text-align: right;width:23%;">Visa&nbsp;</th>
							<th style="background-color:#ed459d;border-color: #ce217b; text-align: right;width:25%;">Total&nbsp;</th>
						</tr>
<% 
					}
					if((rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count")) > 0)
					{
%>						<tr style="font-size: 14px;color:black; font-family: 'Arial', serif; border-color: #ed459d;height:18px;">
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold;text-align: center;width:10%;"><%=++srno%></td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold;text-align: left;width:20%;"><%=icpValue.get(rsTemp.getString("ICP")) == null ? rsTemp.getString("ICP") : icpValue.get(rsTemp.getString("ICP")).replace(" ", "&nbsp;").replace("-", "&#8209;")%></td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;width:22%;"><%=rsTemp.getInt("camera_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("camera_count"))%>&nbsp;</td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;width:23%;"><%=rsTemp.getInt("passport_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("passport_count"))%>&nbsp;</td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;width:23%;"><%=rsTemp.getInt("decard_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("decard_count"))%>&nbsp;</td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;width:23%;"><%=rsTemp.getInt("visa_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("visa_count"))%>&nbsp;</td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;color:#e81784;font-size: 15px;width:25%;"><%=getIndianFormat((rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count")))%>&nbsp;</td>
					</tr>
<%					}
					img_Camera_Total = img_Camera_Total + rsTemp.getInt("camera_count");
					img_Passport_Total = img_Passport_Total + rsTemp.getInt("passport_count");
					img_DECard_Total = img_DECard_Total + rsTemp.getInt("decard_count");
					img_Visa_Total = img_Visa_Total + rsTemp.getInt("visa_count");
					img_Total = img_Total + rsTemp.getInt("camera_count") + rsTemp.getInt("passport_count") + rsTemp.getInt("decard_count") + rsTemp.getInt("visa_count");
	}
				int whileCounter = 0;
				while(srno%14!=0)
				{
					whileCounter++;
					if(whileCounter == 1)
					{
%>						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
						<td colspan="2" style="background-color:#ed459d;border-color:#ce217b; font-weight: bold;text-align: left;width:20%;text-align: center;">Total&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#ce217b; font-weight: bold; text-align: right;width:22%;"><%=getIndianFormat(img_Camera_Total)%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#ce217b; font-weight: bold; text-align: right;width:23%;"><%=getIndianFormat(img_Passport_Total)%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#ce217b; font-weight: bold; text-align: right;width:23%;"><%=getIndianFormat(img_DECard_Total)%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#ce217b; font-weight: bold; text-align: right;width:23%;"><%=getIndianFormat(img_Visa_Total)%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#ce217b; font-weight: bold; text-align: right;color:white;font-size: 15px;width:25%;"><%=getIndianFormat(img_Total)%>&nbsp;</td>
					</tr>
<%					} 
					else 
					{ 
%>
					<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
						<td colspan="7" style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold;text-align: left;width:20%;text-align: center;">&nbsp;</td>
					</tr>
<%
					}
					srno++; 
				}
%>

</table>
</div><%
			rsTemp.close();
			psTemp.close();

			strIcpPax = IcpPax.toString();
			strIcpPax = strIcpPax.substring(0,strIcpPax.length()-1);

			strICP_Camera = ICP_Camera.toString();
			//out.println(strICP_Camera);
			//strICP_Camera = strICP_Camera.concat("Camera");
			//strICP_Camera =  ICP_Camera.append(strICP_Camera + "Camera" );

			//strICP_Camera = strICP_Camera.substring(0,strICP_Camera.length()-1);

			strICP_Passport = ICP_Passport.toString();
			//strICP_Passport = strICP_Passport.substring(0,strICP_Passport.length()-1);
			strICP_DECard = ICP_DECard.toString();
			//strICP_DECard = strICP_DECard.substring(0,strICP_DECard.length()-1);
			strICP_Visa = ICP_Visa.toString();
			//strICP_Visa = strICP_Visa.substring(0,strICP_Visa.length()-1);
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>
		</div>
		</div>
<br><br>	
<div class="container">
<div class="row">
<div class="col-sm-12">
<div class="card"style="border: solid 3px #e81784; border-radius: 20px;">
<div class="card-body" style="height:2000px;">		
<canvas id="canvasPAX_icp" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #ffe6ef 100%);border-radius: 20px;"></canvas><br>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<script>
	var myData_ICP = {
			labels: [<%=strIcpPax%>],
			datasets: [{ 
				  label: "Camera",
			      backgroundColor: "#FF2171",
			      borderColor: "#FF2171",
			      borderWidth: 1,
			      data: [<%=strICP_Camera%>]
			},
					  { 
				  label: "Passport",
			      backgroundColor: "#687EFE",
			      borderColor: "#687EFE",
			      borderWidth: 1,
			      data: [<%=strICP_Passport%>]
			},
					  { 
				  label: "D/E Card",
			      backgroundColor: "gold",
			      borderColor: "gold",
			      borderWidth: 1,
			      data: [<%=strICP_DECard%>]
			},
					  { 
				  label: "Visa",
			      backgroundColor: "green",
			      borderColor: "green",
			      borderWidth: 1,
			      data: [<%=strICP_Visa%>]
			}]
		};


// Options to display value on top of bars

		var myoptionsp = {
			maintainAspectRatio: false,
				 scales: {
				        xAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            },
					gridLines: { 
								display:false,
								}

				        }],
				yAxes: [{
					gridLines: { 
								color: "#FF2171"
								}

					}]

				    },
					  title: {
							display: true,
								text: 'Top 20 : ICP-wise Camera, Passport, D/E Card and Visa Image Statistics',
							fontSize: 25,

							},
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#0F292F";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x+37, bar._model.y+6);
							//Add .toLocaleString('en-IN') for Indian Format in JavaScript							
						});
					});
				}
			},
			
		};
		
		//Code to draw Chart


		var ctx = document.getElementById('canvasPAX_icp').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type  horizontalBar
			data: myData_ICP,    	// Chart data
			options: myoptionsp 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
</script>

		<%} /*if (closed for ICP = All*/%>


<script>
/////////////////// Total Camera /////////////////////
let counts_arr_total_pax = setInterval(updated_arr_total_pax);
        let upto_arr_total_pax = <%=(total_Camera_Count)-400%>;
        function updated_arr_total_pax() {
            upto_arr_total_pax = ++upto_arr_total_pax;
            document.getElementById('count_total_Camera_Count').innerHTML = upto_arr_total_pax.toLocaleString('en-IN');
            if (upto_arr_total_pax === <%=total_Camera_Count%>) {
                clearInterval(counts_arr_total_pax);
            }
        }


///////////////////////////////// Total Passport ///////////////////////////////////////


let counts_dep_pax = setInterval(updated_dep_pax);
        let upto_dep_pax = <%=(total_Passport_Count)-400%>;
        function updated_dep_pax() {
            upto_dep_pax = ++upto_dep_pax;
            document.getElementById('count_total_Passport_Count').innerHTML = upto_dep_pax.toLocaleString('en-IN');
            if (upto_dep_pax === <%=total_Passport_Count%>) {
                clearInterval(counts_dep_pax);
            }
        }


//////////////////////////////	 Total DE Card 	////////////////////////////


let counts_total_DECard_Count_ID = setInterval(updated_total_DECard_Count_ID);
        let upto_total_DECard_Count_ID = <%=(total_DECard_Count)-400%>;
        function updated_total_DECard_Count_ID() {
            upto_total_DECard_Count_ID = ++upto_total_DECard_Count_ID;
            document.getElementById('total_DECard_Count_ID').innerHTML = upto_total_DECard_Count_ID.toLocaleString('en-IN');
            if (upto_total_DECard_Count_ID === <%=total_DECard_Count%>) {
                clearInterval(counts_total_DECard_Count_ID);
            }
        }

////////////////////////////////////	Total Visa	/////////////////////////////////////////////

let counts_total_Visa_Count_ID = setInterval(updated_total_Visa_Count_ID);
        let upto_total_Visa_Count_ID = <%=(total_Visa_Count)-400%>;
        function updated_total_Visa_Count_ID() {
            upto_total_Visa_Count_ID = ++upto_total_Visa_Count_ID;
            document.getElementById('total_Visa_Count_ID').innerHTML = upto_total_Visa_Count_ID.toLocaleString('en-IN');
            if (upto_total_Visa_Count_ID === <%=total_Visa_Count%>) {
                clearInterval(counts_total_Visa_Count_ID);
            }
        }
//////////////////////////////////////////////////////////////////////////////////////////////

const counterAnim = (qSelector, start = 0, end, duration = 1000) => {
 const target = document.querySelector(qSelector);
 let startTimestamp = null;
 const step = (timestamp) => {
  if (!startTimestamp) startTimestamp = timestamp;
  const progress = Math.min((timestamp - startTimestamp) / duration, 1);
  target.innerText = Math.floor(progress * (end - start) + start);
  if (progress < 1) {
   window.requestAnimationFrame(step);
  }
 };
 window.requestAnimationFrame(step);
};

document.addEventListener("DOMContentLoaded", () => {		


counterAnim("#count_total_Camera_Count", 50, <%=getIndianFormat(total_Camera_Count)%>, 2200);

counterAnim("#count_total_Passport_Count", 50, <%=getIndianFormat(total_Passport_Count)%>, 2200);

counterAnim("#total_DECard_Count_ID", 50, <%=getIndianFormat(total_DECard_Count)%>, 2200);   

counterAnim("#total_Visa_Count_ID", 50, <%=getIndianFormat(total_Visa_Count)%>, 2200);  

});
</script>

<%
} catch (Exception e) {
e.printStackTrace();
} finally {
if (con != null)
	con.close();

}

%>

		</body>
		</html>
