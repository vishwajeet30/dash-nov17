<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>
<%
Connection con = null;
try {

Class.forName("oracle.jdbc.driver.OracleDriver");
con = DriverManager.getConnection("jdbc:oracle:thin:@10.248.168.201:1521:ICSSP", "imigration", "nicsi123");

/*Server Time for Reverse Timer*/
java.util.Date current_Server_Time2 = new java.util.Date();
DateFormat vDateFormat21 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
String vServerTime = vDateFormat21.format(current_Server_Time2);
PreparedStatement psMain = null;
PreparedStatement psTemp = null;
Statement st_icp = con.createStatement();
ResultSet rs_icp = null;
ResultSet rsMain = null;
ResultSet rsTemp = null;
String dashQuery = "";
String depQuery = "";
int today_Arrival_Count = 0;
int total_Arrival_Flights = 0;
int dep_Passenger_Flights = 0;
int daily_Dep_Count = 0;
int total_Dep_Flights = 0;
int total_Arrival_Count = 0;
int yesterday_Arrival_Count = 0;
int total_Dep_Count = 0;
int arr_Flight_Count = 0;
int yest_Flight_Count = 0;
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
int displayHours = 12;
int t_Total = 0;
int t_Total_Arr = 0;

String dash = "";
////////////////////	Arrival/Departure PAX Count	Tabs	/////////////////////////

// DateFormat vDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
DateFormat vDateFormatYes = new SimpleDateFormat("dd MMM");
java.util.Date current_Server_Time = new java.util.Date();
String today_date = vDateFormatYes.format(current_Server_Time);	
java.util.Date yesterday_date_in_millis = new java.util.Date(System.currentTimeMillis()-1*24*60*60*1000);
String yesterday_date = vDateFormatYes.format(yesterday_date_in_millis);

String filter_icp = request.getParameter("icp") == null ? "004" : request.getParameter("icp");
String default_hrs = request.getParameter("default_hrs") == null ? "8" : request.getParameter("default_hrs");
displayHours = Integer.parseInt(default_hrs);
//out.println("kuhkihfayfdjhj" + filter_icp);
if(filter_icp.equals("")) filter_icp = "" + filter_icp + "";


	rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397') order by ICP_DESC");
	
	while(rsTemp.next())
	{
%>
		<!--<option value="<%=rsTemp.getString("ICP_SRNO")%>" <%if(filter_icp.equals(rsTemp.getString("ICP_SRNO"))){%> selected<%}%>><%=rsTemp.getString("ICP_DESC")%></option>--><%
		if(filter_icp.equals(rsTemp.getString("ICP_SRNO")))
		{
				dash = rsTemp.getString("ICP_DESC");
				
		}
	}
	 rsTemp.close();  
	 int div_hgt = 200; 
	 if(filter_icp.equals("All")) {
		 div_hgt = 600;
	 }


%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="refresh" content="600"> <!-- auto refresh the page after 3600 seconds -->
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">   

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
	height: 385px; 
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

</style>

</style>
<style>
body{font-family:Arial, Helvetica, sans-serif;}

.wrapper1{margin:0 auto; width:60%;}
.outer_table td{vertical-align:bottom;}
.main_table {
 border-spacing: 0;
 border-collapse: separate;
 border-radius: 10px 10px 0 0;
 width:100%;
 color:#333;
}
.main_table th:not(:last-child),
.main_table td:not(:last-child) {
 border-right: 1px solid #fff;
}
.main_table>tbody>tr:not(:last-child)>th,
.main_table>tbody>tr:not(:last-child)>td,
.main_table>tr:not(:last-child)>td,
.main_table>tr:not(:last-child)>th,
.main_table>tbody:not(:last-child) {
 border-bottom: 1px solid #fff;
}
.main_table th{padding:3px; color:#fff;}
.main_table td{text-align:center; padding:3px;}
.red_table{background: linear-gradient(#ffd2d4, #fff3f4); border: 2px solid #e11a25;}
.red_table th{background: linear-gradient(to left, #ee515a, #e11a25);}
.green_table{background: linear-gradient(#bdf1f4, #e6f9fa); border: 2px solid #317a83;}
.green_table th{background:linear-gradient(to left, #52bac7, #317a83);}
.purple_table{background: linear-gradient(#ebccf9, #f2e7f7); border: 2px solid #7f3f9f;}
.purple_table th{background:linear-gradient(to left, #bf83dd, #7f3f9f);}
.blue_table{background: linear-gradient(#d6d6d6, #ffffff); border: 2px solid #555e61;}
.blue_table th{background:linear-gradient(to left, #b8c3c7, #606263);}

.gold_table {
    background: linear-gradient(#fbd363, #def3fb);
    border: 2px solid #e2a909;
}

.green_table tr{font-size:11px;}
.red_table tr{font-size:11px;}
.purple_table tr{font-size:11px;}
.blue_table tr{font-size:11px;}
</style>


<%!
		// Function to Print numbers in Indian Format
		// Class for ICP
		class ICP
		{
			String ip;
			String db_link;
			String icp_no;
			public ICP(String icp_no,  String db_link, String ip) {
				this.ip = ip;
				this.db_link = db_link;
				this.icp_no = icp_no;
			}
			public String get_db_link() {
				return db_link;
			}
			public String get_ip() {
				return ip;
			}
			public String get_icp_no() {
				return icp_no;
			}
		}
		// Function to covert AM and PM
		public String convertToAmPm(String timeStr)
		{
			try
			{
				SimpleDateFormat inputFormat = new SimpleDateFormat("HH");
				SimpleDateFormat outputFormat = new SimpleDateFormat("hh a");
				
				java.util.Date date = inputFormat.parse(timeStr);
				String amPmTime = outputFormat.format(date);

				return amPmTime;
			}
			catch(ParseException e)
			{
				e.printStackTrace();
				return null;
			}
		}
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
				document.entryfrm.action="im_icp_dashboard_00.jsp?&icp="+document.entryfrm.compare_icp.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;
		}

		function compare_hrs()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
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
				/*document.entryfrm.target = "_self";
				document.entryfrm.action = "im_icp_epassport_dashboard_vishwa.jsp";
				document.entryfrm.submit();*/
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
	var digclock = "<a href='#' onclick='compare_report();'><font size='1' face='Verdana' color='darkgreen'>" + "<font size='1'>&nbsp;Date : </font>" +  dayarray[DigitalClock.getDay()] + ", " + montharray[DigitalClock.getMonth()] + " " + date + ", " + y1 + "<BR>" + "<font size='1'>&nbsp;Time : </font>" + hours + ":" + minutes + ":" + seconds + " " + dn +  "<BR><font size='1' color='red'>&nbsp;(auto refresh in " + document.entryfrm.ReverseCounterID.value + " seconds)</font></font></a>";
	Clock.innerHTML = digclock;
	setTimeout("DigitalTime()",1000);
 }
</script>
<!-- End :  Reverse Timer Functions -->
<%//////////////////////// New Table ////////////////////////////////%>
<style>
			 #loading {
				 position: fixed;
				 display: block;
				 width: 100%;
				 height: 100%;
				 }
				  /*  Required for date selector */
	div.ui-datepicker {
				font-size:10px;
			}
	/*  Required for date selector */
		</style>
<script>
/////////////// Below are the list of the Function requred to enable the loading division and the timer/////////////////////////////////////////////////

	function enableTimer()
	{
			document.getElementById("loading").style.display='none';
			document.clkfrm.stop_timer.value = "0";
			SetCursor();
	}
			
	var TotalSeconds;
	function CreateTimer(Time) 
	{
		TotalSeconds = Time;
		UpdateTimer();
		window.setTimeout("Tick()", 1000);
	}

	function Tick() 
	{
		if(document.clkfrm.stop_timer.value == "0") return;
		TotalSeconds += 1;
		UpdateTimer();
		window.setTimeout("Tick()", 1000);
	}

	function LeadingZero(Time) 
	{
		return (Time < 10) ? "0" + Time : + Time;
	}

	function UpdateTimer() 
	{
		var Seconds = TotalSeconds;
		var Days = Math.floor(Seconds / 86400);
		Seconds -= Days * 86400;

		var Hours = Math.floor(Seconds / 3600);
		Seconds -= Hours * (3600);

		var Minutes = Math.floor(Seconds / 60);
		Seconds -= Minutes * (60);

		var TimeStr = ((Days > 0) ? Days + " days " : "") + LeadingZero(Hours) + ":" + LeadingZero(Minutes) + ":" + LeadingZero(Seconds)

		digclock = "<font face='Verdana' size='2' color='#FF0000'><b>Timer :- " + TimeStr + "</b></font>";
			
		if (document.layers)
		{
				
			document.layers.Clock.document.write(digclock);
			document.layers.Clock.document.close();
		}
		else if (document.all) {
				
			Clock.innerHTML = digclock;
		}
	}
///////////////////////////////////////////////////////////////////////////////////////////////////
</script>
<%@ page language = "java" import = "java.sql.*, java.io.*, java.awt.*, java.util.*, java.text.*, javax.naming.*, javax.sql.*"%>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%
	DateFormat vDateFormat_N = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vDate = new SimpleDateFormat("dd/MM/yyyy");
	DateFormat vHours = new SimpleDateFormat("HH");
	DateFormat vMinut = new SimpleDateFormat("mm");
	DateFormat vDay = new SimpleDateFormat("dd");
	//java.util.Date current_Server_Time = new java.util.Date();
    String vFileName = vDateFormat_N.format(current_Server_Time);
	String sch_time = "";
	String repstring = "";
	int calTime = 0;
	if(Integer.parseInt(vHours.format(current_Server_Time)) > 1)
	{
		sch_time = Integer.parseInt(vHours.format(current_Server_Time))-1+""+vMinut.format(current_Server_Time);
		if(sch_time.length() == 3) sch_time = "0"+sch_time;
	}
	String filter_time = request.getParameter("filter_time") == null ? "1" : request.getParameter("filter_time"); 
	String filter_date = request.getParameter("filter_date") == null ? vDate.format(current_Server_Time) : request.getParameter("filter_date");
	String select_time = filter_time;
	if(filter_time.trim().length() > 0)
	{

		calTime = Integer.parseInt(vHours.format(current_Server_Time)) - Integer.parseInt(filter_time);

		if(calTime > 0)
		{
			
			filter_time = calTime+""+vMinut.format(current_Server_Time);
			if(filter_time.length() == 3) filter_time = "0"+filter_time;
		}
		else
		{
			
			int repint = Integer.parseInt(vDate.format(current_Server_Time).substring(0,2))-1;
			if(repint < 10) repstring = "0"+repint;
			else repstring = ""+repint;
			filter_date = vDate.format(current_Server_Time).replace(vDate.format(current_Server_Time).substring(0,2),repstring);

			filter_time = 24+calTime+""+vMinut.format(current_Server_Time);
			
			if(filter_time.length() == 3) filter_time = "0"+filter_time;

		}
			
	}
	else
	{
		filter_time = sch_time;
		if(filter_date.trim().length() == 0)
			filter_date = vDate.format(current_Server_Time);
	}
	
	//String filter_icp = request.getParameter("filter_icp") == null ? "" : request.getParameter("filter_icp");

%>
<%!
public String getRecTime(String file_name,String boarding_date,Connection con)
{
	String rectime = "";
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		ps = con.prepareStatement("select to_char(APIS_FILE_REC_TIME,'dd/mm/yyyy hh24:mi:ss') as APIS_FILE_REC_TIME from im_apis_flight@ICSSP_TO_DMRC66 where FLIGHT_SCH_ARR_DATE = to_date('"+boarding_date+"','dd/mm/yyyy') and APIS_FILENAME = '"+file_name+"'");
		rs = ps.executeQuery();
		if(rs.next())
			rectime = rs.getString("APIS_FILE_REC_TIME");
		rs.close();
		ps.close();
		

	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	
	return rectime;
}
public String getDiffTime(String str_sch_arr_time,String str_apis_rec_time)
{
	long hours_new = 0;
	long minuets_new = 0;
	String color = "";
	String str_time_difference_new = "";
	try
	{
		
		if(!str_sch_arr_time.equals("") && !str_apis_rec_time.equals(""))
		{
			long time_diff_new = (new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str_sch_arr_time).getTime() - new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str_apis_rec_time).getTime())/1000;
			hours_new = time_diff_new/3600;
			minuets_new = (time_diff_new%3600)/60;
			if(hours_new == 0)
				str_time_difference_new = minuets_new+" Minutes";
			else
				str_time_difference_new = hours_new+" Hour "+minuets_new+" Minutes";

			if((hours_new == 0 && minuets_new < 1) || (hours_new < 0))
			 color = "R";
			else if((hours_new == 0 && minuets_new > 1) || (hours_new == 0 && minuets_new == 0))
			  color = "G";
			else if(hours_new >= 1)
			  color = "Y";
			else
			 color = "G";
			
		}
		else
			str_time_difference_new = "";
		}
	catch(Exception e)
	{
	  e.printStackTrace();
	}
	return color+""+str_time_difference_new;
}

%>
</head>
<%//////////////////////// New Table //////////////////////////enableTimer()//////%>
<body onload="DigitalTime(); StartTimer();" style="background-color: #ffffff;">
	<div class="wrapper">
	<div class="flag-strip"></div>
	<header class="bg-white py-1">
		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-4">
					<a href="#Home"><h1><span>IVFRT (I)</span><br/>National Informatics Centre</h1></a>
				</div>
				<div class="col-sm-4">
			  <img src="Immigration_Logo.png" width="100%" height="90%" alt="Immigration Dashboard" align="center;">
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
	  <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#collapsibleNavbar"> <span class="navbar-toggler-icon"></span> </button>
	  <div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav">
		  <li class="nav-item"><a href="#Home" class="scrollLink nav-link">Home</a></li>
		  <li class="nav-item dropdown"><a href="#Home" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Immigration Clearance</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#ICS_1">Arrival and Departure Immigration Clearance in last 7 days</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_2">Arrival and Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_4">Hourly Clearance of Arrival and Departure Flights in last <%=displayHours%> hours</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_Gender">Gender Based Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_Indian_Foreigner">Indian/Foreigner Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Flight_Running_Status">Currently Running Flight Status in last 30 minutes</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Agewise">Age-wise Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#Arr_Sch_Flts">Arrival, Departure and Expected Flights</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_PAX">Arrival : Hourly Flight Clearance and Expected Flights</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Dep_PAX">Departure : Hourly Flight Clearance and Expected Flights</a></ul></li>


		  <li class="nav-item dropdown"><a href="#biometric_1" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Biometrics</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#biometric_1">Arrival : Biometric Enrollment/Verification/Exemption Statistics</a></ul></li>

		  <li class="nav-item dropdown"><a href="#visa_1" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Visa</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#visa_1">Arrival : Visa Clearance in last 7 days</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="#visa_2">Arrival : Visa Clearance in last <%=displayHours%> hours</a></ul></li>

		  <li class="nav-item dropdown"><a href="#ucf_Indian" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">UCF</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#ucf_Indian">Indian UCF Matched/Not Matched Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ucf_Foreigner">Foreigner UCF Matched/Not Matched Statistics in last 7 days</a></ul></li>
		  

		  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Other Dashboards</a>
		   <ul class="dropdown-menu">
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_evisa_dashboard.jsp" target="_blank" class="scrollLink nav-link">e-Visa</a></li>
			<li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_voa_dashboard.jsp" target="_blank" class="scrollLink nav-link">Visa-on-Arrival</a></li>
			<li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_epassport_dashboard.jsp" target="_blank" class="scrollLink nav-link">e-Passport</a></li>
		  <li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_images_dashboard.jsp" target="_blank" class="scrollLink nav-link">Images</a></li>
		  <li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_cruise_dashboard.jsp" target="_blank" class="scrollLink nav-link">Cruise Clearance (e-LC)</a></ul></li>

		  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Centralised Dashboard</a>
		   <ul class="dropdown-menu">
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_pax.jsp" target="_blank">Immigration Control System</a> </li>
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_apis.jsp" target="_blank">Advanced Passenger Information System</a> </li>
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_epassport.jsp" target="_blank">e-Passport Statistics</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_evisa.jsp" target="_blank">e-Visa Statistics</a></ul></li>
	   </ul>			   
	  </div>			  
	</div>
	<span class="airport_name"><font style="background-color:white; color:#0842af; font-weight: bold; font-size: 35px;">&nbsp;<%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%>&nbsp;</font></span>
  </nav>

</div>

<form name="entryfrm" method="post">
  <input class="input" type="hidden" name="ReverseCounterID" size="55" maxlength="55" value="600">
	<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
		<tr bgcolor="#D0DDEA">
			<td style="text-align: center;">
			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;ICP&nbsp;&nbsp;</b>

			<input height="40" type="text" style="color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="10" name="source_port1" onkeyup="filtery(this.value,this.form.compare_icp)" onchange="filtery(this.value,this.form.compare_icp)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')">
			<!--filtery function-->
			<!--letternumber function-->
			<select class="form-select-sm" name="compare_icp" onKeyDown="if(event.keyCode==13) event.keyCode=9;">

			<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICPs</option>
<%
			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397') order by ICP_DESC");
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
			</select>&nbsp;&nbsp;
			<!--&nbsp;&nbsp;<input type="button" class="Button" value="Generate" onclick=" compare_report();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>-->
			&nbsp;&nbsp;<button class="btn btn-primary btn-sm" type="button" onClick="compare_report();"> Generate </button>



			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;Select Hours&nbsp;&nbsp;</b>
			<select class="form-select-sm"  name="default_hrs">
			<option value="6" <%if(default_hrs.equals("6")){%> selected<%}%>>6</option>
			<option value="7" <%if(default_hrs.equals("7")){%> selected<%}%>>7</option>
			<option value="8" <%if(default_hrs.equals("8")){%> selected<%}%>>8</option>
			<option value="9" <%if(default_hrs.equals("9")){%> selected<%}%>>9</option>
			<option value="10" <%if(default_hrs.equals("10")){%> selected<%}%>>10</option>
			<option value="11" <%if(default_hrs.equals("11")){%> selected<%}%>>11</option>
			<option value="12" <%if(default_hrs.equals("12")){%> selected<%}%>>12</option>
			</select>&nbsp;&nbsp;
			<!--&nbsp;&nbsp;<input type="button" class="Button" value="Go" onclick=" compare_hrs();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>-->
			&nbsp;&nbsp;<button class="btn btn-primary btn-sm" type="button" onClick="compare_hrs();"> Go </button>
			</td>
		</tr>
	</table>
</form>
<br>
	</div>
		<!--   ************************START HOME DIV*******************HOME DIV*****************START HOME DIV****************START HOME DIV********  -->
		<div class="aboutsection">
		<section id="Home">
		<div class="pt-4" id="Home">
		<table id = "auto-index" class="table table-sm table-striped">
		   <thead>
			<tr id='head1'>
					<th colspan=9 bgcolor="green">HOME</th>
				</tr>
				<tr id='head' name='home'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th colspan=6>Description</th>
				</tr>
			</thead>
</table><br>
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
%>

<%!
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
<%//////////////////////////	Arrival PAX Count	Tabs	//////////////////////////////////
	try {
		dashQuery = "select distinct GRAND_TOTAL_PAX_ARR as arr_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

	total_Arrival_Count = rsTemp.getInt("arr_Passenger_Count");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_ARRIVAL_PAX_COUNT as arr_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate-1)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

	yesterday_Arrival_Count = rsTemp.getInt("arr_Passenger_Count");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}
	try {
		dashQuery = "select distinct DAILY_ARRIVAL_PAX_COUNT as arr_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

	today_Arrival_Count = rsTemp.getInt("arr_Passenger_Count");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	//String test_no = getIndianFormat(total_Arrival_Count);
%>
<%/////////////////////////////////	Departure PAX Count	Tabs	///////////////////////////////////////////////////
int today_Dep_Count = 0;
int yest_Dep_Count = 0;
int total_PAX_Count = 0;
int total_Yest_Count = 0;
int total_Today_PAX_Count = 0;;

try {
	dashQuery = "select distinct GRAND_TOTAL_PAX_DEP as dep_Passenger from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		total_Dep_Count = rsTemp.getInt("dep_Passenger");

		total_PAX_Count = total_Arrival_Count + total_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}

try {
	dashQuery = "select distinct DAILY_DEPARTURE_PAX_COUNT as dep_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate - 1)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		yest_Dep_Count = rsTemp.getInt("dep_Passenger_Count");

		total_Yest_Count = yest_Dep_Count + yesterday_Arrival_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}

try {
	dashQuery = "select distinct DAILY_DEPARTURE_PAX_COUNT as dep_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		today_Dep_Count = rsTemp.getInt("dep_Passenger_Count");

		total_Today_PAX_Count = today_Arrival_Count + today_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}



////////////////////	Arrival Flights Count	Tabs	/////////////////////////


try {
		dashQuery = "select distinct GRAND_TOTAL_CNT_FLT_ARR as total_Arrival_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			total_Arrival_Flights = rsTemp.getInt("total_Arrival_Flights");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_ARRIVAL_FLIGHT_COUNT as arr_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			arr_Flight_Count = rsTemp.getInt("arr_Flights");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_ARRIVAL_FLIGHT_COUNT as arr_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate-1)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			yest_Flight_Count = rsTemp.getInt("arr_Flights");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	/////////////////////////////////////////	Departure Flights Count	Tabs	////////////////////////////////////////////////////

	int yest_Dep_Flights = 0;
	int today_Dep_Flights = 0;
	int total_Flights_Count = 0;
	int total_Flights_Count_Yest = 0;
	int total_Flights_Count_Today = 0;
	
	try {
		dashQuery = "select distinct GRAND_TOTAL_CNT_FLT_DEP as total_Dep_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			total_Dep_Flights = rsTemp.getInt("total_Dep_Flights");
			total_Flights_Count =  total_Dep_Flights + total_Arrival_Flights;

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_DEPARTURE_FLIGHT_COUNT as dep_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate - 1)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			yest_Dep_Flights = rsTemp.getInt("dep_Flights");
			total_Flights_Count_Yest = yest_Flight_Count + yest_Dep_Flights;
			
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_DEPARTURE_FLIGHT_COUNT as dep_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			today_Dep_Flights = rsTemp.getInt("dep_Flights");
			total_Flights_Count_Today = arr_Flight_Count + today_Dep_Flights;
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}
	%>

</section>



<%////////////////	Arrival PAX Count Tabs - Start	///////////////////////%>
<br><br><br><br><br><br><br>
<div class="container">
<div class="row">
<div class="col-sm-4" style="flex:3;">
		<table class="tableDesign">
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;">Arrival</th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #004076;"><%=getIndianFormat(today_Arrival_Count)%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #004076;">&nbsp;Today's&nbsp;Footfall</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td  style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color :#0072d3"><%=getIndianFormat(yesterday_Arrival_Count)%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color :#0072d3">&nbsp;Yesterday's&nbsp;Footfall</td>
		</tr>		
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="countArr" style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #44a9ff;"></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #44a9ff;">&nbsp;Overall&nbsp;Footfall</td>
		</tr>
	</table>
</div>
<%////////////////	Arrival Flights Count Tabs - Start	///////////////////////%>

<div class="col-sm-2" style="flex:2;"><br><br><br><br><br>
<table class="tableDesign">	
			<tr style="font-size: 20px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
				<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;text-align: center;">Arrival&nbsp;Flights</th>
			</tr>
			<tr style="font-size: 15px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color: #004076;font-size: 20px;"><%=getIndianFormat(arr_Flight_Count)%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color: #004076;font-size: 12px;">&nbsp;Today&nbsp;Flights</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td  style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color :#0072d3;font-size: 20px;"><%=getIndianFormat(yest_Flight_Count)%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color :#0072d3;font-size: 12px;">&nbsp;Yesterday&nbsp;Flights</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td id="countArrFlt" style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color: #44a9ff;font-size: 20px;"></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color: #44a9ff;font-size: 12px;">&nbsp;Overall&nbsp;Flights</td>
			</tr>
		</table>
	</div>
<%////////////////	Departure PAX Count Tabs - Start	///////////////////////%>


	<div class="col-sm-4" style="flex:3;">
	<table class="tableDesign">		
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #6929c4;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0;width:40%; text-align: center;">Departure</th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #5521a0;"><%=getIndianFormat(today_Dep_Count)%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #5521a0;">&nbsp;Today's&nbsp;Footfall</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">		
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color: #864cd9;"><%=getIndianFormat(yest_Dep_Count)%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #864cd9;">&nbsp;Yesterday's&nbsp;Footfall</td>
		</tr>		
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">		
			<td id="count_total_Dep_Count" style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #a376e2;"></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #a376e2;">&nbsp;Overall&nbsp;Footfall</td>
		</tr>
	</table>
</div>
<%////////////////	Departure Flights Count Tabs - Start	///////////////////////%>

<div class="col-sm-2" style="flex:2;"><br><br><br><br><br>
<table class="tableDesign">
		<tr style="font-size: 20px;  text-align: right; color:white; border-color: #6929c4;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0; text-align: center;">Departure&nbsp;Flights</th>
		</tr>
		<tr style="font-size: 15px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">				
			<td style="background-color:#e8daff;border-color: #e8daff;width:40%; font-weight: bold; text-align: right;color: #5521a0;font-size: 20px;"><%=today_Dep_Flights%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:60%; font-weight: bold; text-align: left;color: #5521a0;font-size: 12px;">&nbsp;Today&nbsp;Flights</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:40%; font-weight: bold; text-align: right;color: #864cd9;font-size: 20px;"><%=yest_Dep_Flights%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:60%; font-weight: bold; text-align: left;color: #864cd9;font-size: 12px;">&nbsp;Yesterday&nbsp;Flights</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">			
			<td id="count_total_Dep_Flights" style="background-color:#e8daff;border-color: #e8daff;width:40%; font-weight: bold; text-align: right;color: #a376e2;font-size: 20px;"></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:60%; font-weight: bold; text-align: left;color: #a376e2;font-size: 12px;">&nbsp;Overall&nbsp;Flights</td>
		</tr>
	</table>
</div>
</div>
</div>
<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>


<section id="ICS_1"><br><br><br><br><br><br><br>	
<div class="pt-4" id="ICS_1">
	<table id = "auto-index1" class="table table-sm table-striped" >
		<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival and Departure Immigration Clearance in last 7 days</th>
			</tr>				
		</thead>
	</table><br>
</section>
<%////////////////////////	Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////

StringBuilder weekDays = new StringBuilder();
StringBuilder weekArrPax = new StringBuilder();
StringBuilder weekDepPax = new StringBuilder();

boolean flagPaxCount = false;
try {
	WeeklyPAXQuery = "select distinct  to_char(pax_boarding_date,'Mon-dd') as show_date,pax_boarding_date,icp_description,DAILY_ARRIVAL_PAX_COUNT,DAILY_DEPARTURE_PAX_COUNT from IM_DASHBOARD_COMBINED  where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate) order by pax_boarding_date";
	psTemp = con.prepareStatement(WeeklyPAXQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

		weekly_XAxis = rsTemp.getString("show_date");
		//out.println(weekly_XAxis);
		weekelyArrPaxCount = rsTemp.getInt("DAILY_ARRIVAL_PAX_COUNT");
		weekelyDepPaxCount = rsTemp.getInt("DAILY_DEPARTURE_PAX_COUNT");
		//out.println(weekelyArrPaxCount+weekelyDepPaxCount);

		if (flagPaxCount == true) {
	weekDays.append(",");
	weekArrPax.append(",");
	weekDepPax.append(",");
		} else
	flagPaxCount = true;

		weekDays.append("\"");
		weekDays.append(weekly_XAxis);
		weekDays.append("\"");
		weekArrPax.append(weekelyArrPaxCount);
		weekDepPax.append(weekelyDepPaxCount);
	}
	rsTemp.close();
	psTemp.close();

} catch (Exception e) {
	out.println("Arr/Dep PAX Count  Exception");
}

//String str1 = str_Hours.toString();
//String str2 = str_Hours_Flight_Count.toString();
String strWeekDays = weekDays.toString();
String strweekArrPax = weekArrPax.toString();
String strweekDepPax = weekDepPax.toString();
//out.println(strWeekDays);
%>

<%////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////%>
<br><br>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign">
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #6929c4;height:20px;">
					<th style="text-align: center;background-color:#7a3ad6;border-color: #6528bd;width:33.33%;">&nbsp;</th>
					<th colspan = "3" style="text-align: center;background-color:#7a3ad6;border-color: #6528bd;width:66.66%; text-align: center;">Total Footfall</th>
				</tr>
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #6528bd;height:20px; ">
				<th style="background-color:#8e58dc;border-color: #6528bd;width:25%;text-align: center;">Date</th>
				<th style="background-color:#8e58dc;border-color: #6528bd;width:33.33%; text-align: right;">Arr&nbsp;</th>
				<th style="background-color:#8e58dc;border-color: #6528bd;width:33.33%; text-align: right;">Dep&nbsp;</th>
				<th style="background-color:#8e58dc;border-color: #6528bd;width:33.33%; text-align: right;">Total&nbsp;</th>
			</tr>
		<% 
			String[] weekListPAX = strWeekDays.toString().replace("\"", "").split(",");
			String[] weeklyArrPAX = strweekArrPax.split(",");
			String[] weeklyDepPAX = strweekDepPax.split(",");
			for (int i = 0; i < weekListPAX.length; i++) {
				t_Total = 0;
				t_Total = Integer.parseInt(weeklyArrPAX[i]) + Integer.parseInt(weeklyDepPAX[i]);
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#c7aeee;border-color: #6929c4;width:33.33%; font-weight: bold;text-align: center;"><%=weekListPAX[i].replace("-","&#8209;")%></td>
				<td style="background-color:#d9c8f3;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;"><%=weeklyArrPAX[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyArrPAX[i]))%>&nbsp;</td>
				<td style="background-color:#e8def8;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;"><%=weeklyDepPAX[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyDepPAX[i]))%>&nbsp;</td>
				<td style="background-color:#f7f4f8;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;color:#6929c4;"><%=t_Total == 0 ? "&nbsp;" : getIndianFormat(t_Total)%>&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>

<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #7a3ad6; border-radius: 20px; height:300px;">
<div class="card-body"style="height:300px;">
<canvas id="canvasPAX" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #e6daf7 100%); border-radius:20px; height:300px;"></canvas>
</div>
</div>
</div>
<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDays%>],
			datasets: [{ 
				  label: "Arrival Footfall",
			      backgroundColor: "#7a3ad6",
			      borderColor: "#7a3ad6",
			      borderWidth: 1,
			      data: [<%=strweekArrPax%>]
			}, { 
				  label: "Departure Footfall",
			      backgroundColor: "#00dcb0",
			      borderColor: "#00dcb0",
			      borderWidth: 1,
			      data: [<%=strweekDepPax%>]
			}]
		};
		 	

		// Options to display value on top of bars

		var myoptions = {
			responsive:true,
		maintainAspectRatio:false,
				 scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: false,display: false
		}],
		xAxes: [{
		stacked: false,display: true
		}]
	},
		 title: {
				display: true,
					text:'Arrival and Departure Immigration Clearance in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#303030";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 7px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y-2);
							//Add .toLocaleString('en-IN') for Indian Format in JavaScript							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasPAX').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%///////////////////////////	  Arrival and Departure Immigration Clearance in last 7 days - End	///////////////////////////////%>

<%//////////////////////////////////	Arrival and Departure Flights in last 7 days - Start	////////////////////////////////////

	StringBuilder weekDaysFlights = new StringBuilder();
	StringBuilder weekArrFlights = new StringBuilder();
	StringBuilder weekDepFlights = new StringBuilder();

	boolean flagFlightCount = false;
	try {
		WeeklyFlightsQuery = "select distinct  to_char(pax_boarding_date,'Mon-dd') as show_date,pax_boarding_date,icp_description,DAILY_ARRIVAL_FLIGHT_COUNT,DAILY_DEPARTURE_FLIGHT_COUNT from im_dashboard_combined where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate) order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyFlightsQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyFlightXAxis = rsTemp.getString("show_date");
			//out.println(weeklyFlightXAxis);
			weekelyArrFlightCount = rsTemp.getInt("DAILY_ARRIVAL_FLIGHT_COUNT");
			weekelyDepFlightCount = rsTemp.getInt("DAILY_DEPARTURE_FLIGHT_COUNT");
			//out.println(weekelyArrFlightCount+weekelyDepFlightCount);

			if (flagFlightCount == true) {
		weekDaysFlights.append(",");
		weekArrFlights.append(",");
		weekDepFlights.append(",");
			} else
		flagFlightCount = true;

			weekDaysFlights.append("\"");
			weekDaysFlights.append(weeklyFlightXAxis);
			weekDaysFlights.append("\"");
			weekArrFlights.append(weekelyArrFlightCount);
			weekDepFlights.append(weekelyDepFlightCount);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Arr/Dep Flight Count  Exception");
	}

	String strWeekDaysFlights = weekDaysFlights.toString();
	String strweekArrFlights = weekArrFlights.toString();
	String strweekDepFlights = weekDepFlights.toString();
	%>
<%////////////////	Table -  Arrival and Departure Flights in last 7 days - Start	///////////////////////%>
<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Flights in last 7 days</caption>-->
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #ed3e12;height:20px;">
				<th style="text-align: center;background-color:#ed3e12;border-color: #bf320f;width:33.33%;">&nbsp;</th>
				<th colspan = "3" style="text-align: center;background-color:#ed3e12;border-color: #bf320f;width:66.66%; text-align: center;">Total Flights</th>
			</tr>
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #ed3e12;height:20px;">
				<th style="background-color:#f16744;border-color: #bf320f;width:25%;text-align:center">Date</th>
				<th style="background-color:#f16744;border-color: #bf320f;width:25%; text-align: right;">Arr&nbsp;</th>
				<th style="background-color:#f16744;border-color: #bf320f;width:25%; text-align: right;">Dep&nbsp;</th>
				<th style="background-color:#f16744;border-color: #bf320f;width:25%; text-align: right;">Total&nbsp;</th>
			</tr>
		<% 
			String[] weekListFlights = strWeekDaysFlights.toString().replace("\"", "").split(",");
			String[] weeklyArrFlights = strweekArrFlights.split(",");
			String[] weeklyDepFlights = strweekDepFlights.split(",");
			for (int i = 0; i < weekListFlights.length; i++) {
				t_Total = 0;
				t_Total = Integer.parseInt(weeklyArrFlights[i]) + Integer.parseInt(weeklyDepFlights[i]);
		%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center;height:18px;border-color: #ed3e12">
				<td style="background-color:#f7ab97;border-color: #ed3e12;width:25%; font-weight: bold;text-align: center;"><%=weekListFlights[i].equals("0") ? "&nbsp;" : weekListFlights[i]%></td>
				<td style="background-color:#f9c3b5;border-color: #ed3e12;width:25%;font-weight: bold;  text-align: right;"><%=weeklyArrFlights[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyArrFlights[i]))%>&nbsp;</td>
				<td style="background-color:#fcdbd2;border-color: #ed3e12;width:25%; font-weight: bold; text-align: right;"><%=weeklyDepFlights[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyDepFlights[i]))%>&nbsp;</td>
				<td style="background-color:#fef3f0;border-color: #ed3e12;width:25%; font-weight: bold; text-align: right;color:#ed3e12;"><%=t_Total == 0 ? "&nbsp;" : getIndianFormat(t_Total)%>&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Flights in last 7 days - End	////////////////////////%>

	<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #ef5731; border-radius: 20px; height:300px;">
<div class="card-body" style="height:300px;">
  <canvas id="canvasFlights" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #fcd3d1 100%);border-radius: 20px; height:300px;"></canvas>
</div>
</div>
</div>

	<script>

		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysFlights%>],
			datasets: [{ 
				  label: "Arrival Flights",
			      backgroundColor: "#F6635C",
			      borderColor: "#F6635C",
			      borderWidth: 1,
			      data: [<%=strweekArrFlights%>]
			}, { 
				  label: "Departure Flights",
			      backgroundColor: "#ffa600",
			      borderColor: "#ffa600",
			      borderWidth: 1,
			      data: [<%=strweekDepFlights%>]
			}]
		};

		// Options to display value on top of bars

var myoptions = {
		responsive:true,
			maintainAspectRatio: false,

				 scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: false,display: false
		}],
		xAxes: [{
		stacked: false,display: true
		}]
	},
		 title: {
				display: true,
					text:'Arrival and Departure Flights Cleared in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#303030";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 8px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y-2);
							//Add .toLocaleString('en-IN') for Indian Format in JavaScript							
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasFlights').getContext('2d');
		var myChart = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
</div>
</div>
<br>
</div>

<%///////////////////////////////	Arrival and Departure Flights in last 7 days - End	/////////////////////////////////////////%>




<section id="ICS_2" ><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_2">
<table id = "auto-index2" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival and Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</th>
		</tr>
	</thead>
</table>
</section>
	<%////////////////////	Arrival : PAX Clearance, Active Flights and Active Counters in last 8 hours - Start	////////////////////////

StringBuilder hourlyTime = new StringBuilder();
StringBuilder hourlyPax = new StringBuilder();
StringBuilder hourlyFlight = new StringBuilder();
StringBuilder hourlyActiveCounter = new StringBuilder();

	String hourSet_Arrpfa = "";
	java.util.Date v_hourSet_Arrpfa = null;
	//DateFormat vArrDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vArrDateFormat = new SimpleDateFormat("MMM-dd HH");

 flagPaxCount = false;
try {
	arrHourlyQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count  from im_dashboard_combined where pax_boarding_date = trunc(sysdate) and table_type = 'IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<= "+displayHours;
	psTemp = con.prepareStatement(arrHourlyQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {
			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyXAxis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyXAxis = rsTemp.getString("hours").substring(0,2) +" PM" ;			

		hourlyArrFlightCount = rsTemp.getInt("hourly_flight_count");
		hourlyArrPaxCount = rsTemp.getInt("hourly_pax_count");
		hourlyArrActiveCounter = rsTemp.getInt("active_counter_count");
		//out.println(hourlyArrActiveCounter);

		if (flagPaxCount == true) 
			{
			hourlyTime.append(",");
			hourlyPax.append(",");
			hourlyFlight.append(",");
			hourlyActiveCounter.append(",");
		} else
		flagPaxCount = true;

		hourlyTime.append("\"");
		hourlyTime.append(hourlyXAxis);
		hourlyTime.append("\"");
		hourlyPax.append(hourlyArrPaxCount);
		hourlyFlight.append(hourlyArrFlightCount);
		hourlyActiveCounter.append(hourlyArrActiveCounter);
	}
	rsTemp.close();
	psTemp.close();

} catch (Exception e) {
	out.println("Arr PAX, Flight and Active Count  Exception");
}
String strHourlyTime = hourlyTime.toString();
String strHourlyArrPax = hourlyPax.toString();
String strHourlyArrFlight = hourlyFlight.toString();
String strHourlyArrActiveCounter = hourlyActiveCounter.toString();
%>

<%////////////////	Table - Arrival Clearance in last 7 hours - Start	///////////////////////%>

<div class="container-fluid">
<div class="row">
	<div class="col-sm-3"  style="flex:1;">
	<table class="tableDesign">
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:50px;">
				<th colspan="4" style="text-align: center; width:25%; background-color:#B93160;border-color: #B93160;width:25%; text-align: center;">Arrival</th>
			</tr>
			<tr style="font-size: 13px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
				<th style="text-align: center; width:25%; background-color:#ca3669;border-color: #91264b;width:25%; text-align: center;">Time</th>
				<th style="text-align: center; width:25%; background-color:#ca3669;border-color: #91264b;width:25%; text-align: center;">PAX<br>Clearance</th>
				<th style="text-align: center; width:25%; background-color:#ca3669;border-color: #91264b;width:25%; text-align: right;">Active&nbsp;<br>Flights&nbsp;</th>
				<th style="text-align: center; width:25%; background-color:#ca3669;border-color: #91264b;width:25%; text-align: right;">Active&nbsp;<br>Counters&nbsp;</th>
			</tr>
		<% 
			String[] weekList = strHourlyTime.toString().replace("\"", "").split(",");
			String[] arrPax = strHourlyArrPax.split(",");
			String[] arrFlight = strHourlyArrFlight.split(",");
			String[] arrCounter = strHourlyArrActiveCounter.split(",");
			String v_date_Format  = "";
			for (int i = weekList.length - 1; i >= 0 ; i--) {
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; height:20px;">
				<td style="background-color:#e8a7bd; width:25%; border-color: #91264b;width:25%; font-weight: bold; text-align: center;"><%=weekList[i].equals("0") ? "&nbsp;" : weekList[i].replace(" ","&nbsp;")%></td>

				<td style="background-color:#eec0d0; width:25%; border-color: #91264b;width:25%; font-weight: bold; text-align: right;"><%=arrPax[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(arrPax[i]))%>&nbsp;&nbsp;&nbsp;</td>

				<td style="background-color:#f5d9e3; width:25%; border-color: #91264b;width:25%; font-weight: bold; text-align: right;"><%=arrFlight[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(arrFlight[i]))%>&nbsp;&nbsp;&nbsp;</td>

				<td style="background-color:#fcf2f6; width:25%; border-color: #91264b;width:25%; font-weight: bold; text-align: right;"><%=arrCounter[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(arrCounter[i]))%>&nbsp;&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Arrival : PAX, Flight and Active Counters for last 7 hours - End	////////////////////////%>



<div class="col-sm-3"  style="flex:2;">
<div class="card" style="border: solid 3px #B93160; border-radius: 20px; height:360px;">
<div class="card-body" style=" height:360px;">
		<canvas id="canvasArrPAXFltActCount" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f0c9d6 100%); border-radius: 20px;height:360px;"></canvas>
</div>
</div>
</div>


	<br>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyTime)%>],
			datasets: [{ 
				  label: "Arrival Footfall",
			      backgroundColor: "#B93160",
			      borderColor: "#B93160",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyArrPax)%>]
			}, { 
				  label: "Arrival Flights",
			      backgroundColor: "#FF5C8D",
			      borderColor: "#B93160",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyArrFlight)%>]
			},
			{ 
				  label: "Arrival Active Counters",
			      backgroundColor: "#FFCCCC",
			      borderColor: "#B93160 ",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyArrActiveCounter)%>]
			}]
		};
		 	
		// Options to display value on top of bars

		var myoptions = {
			maintainAspectRatio:false,
				responsive:true,
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            },
							gridLines:{
								display:false,
							}
				        }],
						xAxes: [{
						gridLines: {
						color:"#FF5C8D",
						}
						}]
				    },
		 title: {
				display: true,
					text:'Arrival : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours',
				fontSize: 12,		
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 9px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasArrPAXFltActCount').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>


	<%////////////////////	Arrival : PAX Clearance, Active Flights and Active Counters in last 8 hours - End	////////////////////////%>


	<%//////////////////	Departure : PAX, Flight and Active Counters for last 7 hours - Start	///////////////////////

	StringBuilder hourlyDepTime = new StringBuilder();
	StringBuilder hourlyDepPax = new StringBuilder();
	StringBuilder hourlyDepFlight = new StringBuilder();
	StringBuilder hourlyDepDepActiveCounter = new StringBuilder();


	String hourSet_Deppfa = "";
	java.util.Date v_hourSet_Deppfa = null;
	//DateFormat vDepDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vDepDateFormat = new SimpleDateFormat("MMM-dd HH");

	flagPaxCount = false;
	try {
		depHourlyQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count  from im_dashboard_combined where pax_boarding_date = trunc(sysdate) and table_type = 'IM_TRANS_DEP_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<="+displayHours;
		psTemp = con.prepareStatement(depHourlyQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyDepXAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyDepXAxis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyDepXAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyDepXAxis = rsTemp.getString("hours").substring(0,2) +" PM" ;		

			hourlyDepFlightCount = rsTemp.getInt("hourly_flight_count");
			hourlyDepPaxCount = rsTemp.getInt("hourly_pax_count");
			hourlyDepActiveCounter = rsTemp.getInt("active_counter_count");

			if (flagPaxCount == true) {
		hourlyDepTime.append(",");
		hourlyDepPax.append(",");
		hourlyDepFlight.append(",");
		hourlyDepDepActiveCounter.append(",");
			} else
		flagPaxCount = true;

			hourlyDepTime.append("\"");
			hourlyDepTime.append(hourlyDepXAxis);
			hourlyDepTime.append("\"");
			hourlyDepPax.append(hourlyDepPaxCount);
			hourlyDepFlight.append(hourlyDepFlightCount);
			hourlyDepDepActiveCounter.append(hourlyDepActiveCounter);
		}

		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Dep PAX, Flight and Active Count Exception");
	}

	strHourlyTime = "";
	strHourlyTime = hourlyDepTime.toString();
	String strHourlyDepPax = hourlyDepPax.toString();
	String strHourlyDepFlight = hourlyDepFlight.toString();
	String strHourlyDepActiveCounter = hourlyDepDepActiveCounter.toString();
	%>

<%////////////////////	Table - Departure : PAX, Flight and Active Counters for last 7 hours - Start	/////////////////////////%>

		<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Departure Clearance in last 7 hours</caption>-->
			<!-- #005d5d -->
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:50px;">
					<th colspan="4" style="text-align: center; width:25%; background-color:#007c7c;border-color: #007c7c;width:25%; text-align: center;">Departure</th>
				</tr>

				<tr style="font-size: 13px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
					<th style="text-align: center;background-color:#009494;border-color: #005b5b;width:25%; font-weight: bold; text-align: center;">Time</th>
					<th style="text-align: center;background-color:#009494;border-color: #005b5b;width:25%; font-weight: bold; text-align: center;">PAX<br>Clearance</th>
					<th style="text-align: center;background-color:#009494;border-color: #005b5b;width:25%; font-weight: bold; text-align: right;">Active&nbsp;&nbsp;<br>Flights&nbsp;</th>
					<th style="text-align: center;background-color:#009494;border-color: #005b5b;width:25%; font-weight: bold; text-align: right;">Active&nbsp;<br>Counters&nbsp;</th>
				</tr>
			<%
			//strHourlyTime = hourlyDepTime.toString();
			//String strHourlyDepPax = hourlyDepPax.toString();
			//String strHourlyDepFlight = hourlyDepFlight.toString();
			//String strHourlyDepActiveCounter = hourlyDepDepActiveCounter.toString();
			//out.println(hourlyTime.toString().replace("\"",""));

			String[] depWeekList = strHourlyTime.toString().replace("\"", "").split(",");
			String[] depPax = strHourlyDepPax.split(",");
			String[] depFlight = strHourlyDepFlight.split(",");
			String[] depCounter = strHourlyDepActiveCounter.split(",");

			for (int i = depWeekList.length - 1; i >= 0 ; i--) {
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#8fffff;border-color: #005d5d;width:25%; font-weight: bold;text-align: center;"><%=depWeekList[i].equals("0") ? "&nbsp;" : depWeekList[i].replace(" ","&nbsp;")%></td>
				<td style="background-color:#afffff;border-color: #005d5d;width:25%; font-weight: bold; text-align: right;"><%=depPax[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(depPax[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#cfffff;border-color: #005d5d;width:25%; font-weight: bold; text-align: right;"><%=depFlight[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(depFlight[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#efffff;border-color: #005d5d;width:25%; font-weight: bold; text-align: right;"><%=depCounter[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(depCounter[i]))%>&nbsp;&nbsp;</td>
			</tr>

			<%
			}
			%>
		</table>
</div>	
<% /////////////////	Table - Departure : PAX, Flight and Active Counters for last 7 hours - End	/////////////////////%>

<div class="col-sm-3" style="flex:2;">
	<div class="card" style="border: solid 3px #006778; border-radius: 20px;height:360px;">
	<div class="card-body" style=" height:360px;">

		<canvas id="canvasDepPAXFltActCount" class="chart" style="max-width: 100%; background: linear-gradient(to bottom, #ffffff 35%, #75ebff 100%);border-radius: 20px;height:360px;"></canvas>
	</div>
</div>
</div>
</div>
</div>
</div>

<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyTime)%>],
			datasets: [{ 
				  label: "Departure Footfall",
			      backgroundColor: "#006778",
			      borderColor: "#045D5D",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyDepPax)%>]
			}, { 
				  label: "Departure Flights",
			      backgroundColor: "#39AEA9",
			      borderColor: "#006778",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyDepFlight)%>]
			},
			{ 
				  label: "Departure Active Counters",
			      backgroundColor: "#CCF3EE",
			      borderColor: "#006778",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyDepActiveCounter)%>]
			}]
		};
		 	

		// Options to display value on top of bars

		var myoptions = {
			maintainAspectRatio:false,
				responsive:true,
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            },
							gridLines: {
							display:false,
							}
				        }],
					xAxes: [{
						   gridLines: {
							color:"#08bdba",
						   }
						}]
				    },
		 title: {
				display: true,
					text:'Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours',
				fontSize: 12,		
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 9px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasDepPAXFltActCount').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>



<%
/////////////////////////	Departure : PAX, Flight and Active Counters for last 7 hours - End	////////////////////////////
%>
<%///////////////HOURLY////////////////%>




		</div>
		</section>

		<section id="ICS_4"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_4"> 
		<table id = "auto-index4" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Hourly Clearance of Arrival and Departure Flights in last <%=displayHours%> hours</th>
				</tr>
				<!--<tr id='head' name='apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>
		<%////////////////////////////////////////////	Hourly Clearance of Arrival Flights - Start	////////////////////////////////////////////////////

	String hours_Axis = "";
	String hourly_flight_count_Axis = "";

	StringBuilder hourlyArrAxis = new StringBuilder();
	StringBuilder hourlyArrFlt = new StringBuilder();

	//String hourSet = "";

	boolean zero_entry_Arr = false;
	try {
		dashQuery = "select * from (select to_date(hours,'HH24mi') as date_time, icp_description, hours,hourly_flight_count,active_counter_count,hourly_pax_count from im_dashboard_combined where table_type = 'IM_TRANS_ARR_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) order by HOURS desc ) where rownum <= "+displayHours;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {


			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hours_Axis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hours_Axis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hours_Axis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hours_Axis = rsTemp.getString("hours").substring(0,2) +" PM" ;

			hourly_flight_count_Axis = rsTemp.getString("hourly_flight_count");

			if (zero_entry_Arr == true) {
				hourlyArrAxis.append(",");
				hourlyArrFlt.append(",");
			} else
		zero_entry_Arr = true;
			hourlyArrAxis.append("\"");
			hourlyArrAxis.append(hours_Axis);
			hourlyArrAxis.append("\"");
			hourlyArrFlt.append(hourly_flight_count_Axis);
		}

		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Hourly Count of Arrival Flights Exception");
	}

	String strhours_Axis = hourlyArrAxis.toString();
	String strhourly_flight_count_Axis = hourlyArrFlt.toString();
	//out.println(str1);
	%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-2" style="flex:1;">
	<%////////////////	Table - Hourly Clearance of Arrival Flights - Start	///////////////////////%>
<table class="tableDesign">
		<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:5%;">
				<th style="text-align: center;background-color:#da1e28;border-color: #ab181f;width:50%; text-align: center;">Time</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #ab181f;width:50%; text-align: right;">Arrival&nbsp;Flights&nbsp;&nbsp;</th>
			</tr>									
		<% 
			/*String strhours_Axis = hourlyArrAxis.toString();
				String strhourly_flight_count_Axis = hourlyArrFlt.toString();*/
			String[] hourListArrFlt = strhours_Axis.toString().replace("\"", "").split(",");
			String[] hourListArrFltCount = strhourly_flight_count_Axis.split(",");
			

			for (int i = hourListArrFlt.length-1; i >= 0; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:5%;">
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: center;"><%=hourListArrFlt[i].equals("0") ? "&nbsp;" : hourListArrFlt[i]%></td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=hourListArrFltCount[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(hourListArrFltCount[i]))%>&nbsp;&nbsp;</td>


			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Hourly Clearance of Arrival Flights - End	////////////////////////%>


	<div class="col-sm-4"  style="flex:2;">
	<div class="card" style="border: solid 3px #da1e28; border-radius: 20px; height:314px;">
	<div class="card-body" style="height:314px;">
<!-- 		<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Arrival Flights</h1>
 -->		<canvas id="myPlot1" class="chart" style="background: linear-gradient(to bottom, #ffffff 35%, #ffd8d8 100%); border-radius: 20px; height:314px;"></canvas>
		</div>
		</div>
		</div>
		<script>
		// Data define for bar chart

		var myDataaaaaa = {
			labels: [<%=reverseOnComma(strhours_Axis)%>],
			datasets: [{ 
				  label: "Arrival Flights",
			      backgroundColor: "#FF6363",
			      borderColor: "red",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strhourly_flight_count_Axis)%>]
			}]
		};
		 	
		// Options to display value on top of bars

		var myoptionsssssss = {
			maintainAspectRatio:false,
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            },
							gridLines:{
								display:false,
							}
				        }]
				    },

		 title: {
				display: true,
					text:'Hourly Clearance of Arrival Flights',
				fontSize: 15,		
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metasssssss = chartInstances.controller.getDatasetMeta(i);
						metasssssss.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x , bar._model.y );
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('myPlot1').getContext('2d');
		var myChartsssssss = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myDataaaaaa,    	// Chart data
			options: myoptionsssssss 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

	<%	////////////////////////////////////////////	Hourly Clearance of Arrival Flights - End	////////////////////////////////////////////////////%>




	
	<%////////////////////////////////////////////	Hourly Clearance of Departure Flights - Start	////////////////////////////////////////////////////

	String hours_Axis_Dep = "";
	String hourly_flight_count_Axis_Dep = "";

	StringBuilder hourlyDepAxis = new StringBuilder();
	StringBuilder hourlyDepFlt = new StringBuilder();

	String hourSet_Dep = "";
	java.util.Date v_hourSet_Dep = null;
	//DateFormat vDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vDateFormat = new SimpleDateFormat("MMM-dd HH");

	boolean zero_entry2 = false;
	try {
		depQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24miss') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count from im_dashboard_combined where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) order by HOURS desc ) where rownum <= "+displayHours;
		psTemp = con.prepareStatement(depQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {
			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hours_Axis_Dep =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hours_Axis_Dep = rsTemp.getString("hours").substring(0,2) +" PM" ;			

			hourly_flight_count_Axis_Dep = rsTemp.getString("hourly_flight_count");

			if (zero_entry2 == true) {
				hourlyDepAxis.append(",");
				hourlyDepFlt.append(",");
			} else
		zero_entry2 = true;
			hourlyDepAxis.append("\"");
			hourlyDepAxis.append(hours_Axis_Dep);
			hourlyDepAxis.append("\"");
			hourlyDepFlt.append(hourly_flight_count_Axis_Dep);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		e.printStackTrace();
	}

	String strhours_Axis_Dep = hourlyDepAxis.toString();
	String strhourly_flight_count_Axis_Dep = hourlyDepFlt.toString();
	//out.println(str1);
	%>

<%////////////////	Table - Hourly Clearance of Departure Flights - Start	///////////////////////%>

	<div class="col-sm-2" style="flex:1;">
		<table class="tableDesign" >
			<tr style="font-size: 14px; color:white; border-color: #006778;height:40%;">
					<th style="text-align: center;background-color:#006778;border-color: #004753;width:50%;text-align: center;">Time</th>
					<th style="text-align: center;background-color:#006778;border-color: #004753;width:50%; text-align: right;">Departure&nbsp;Flights&nbsp;&nbsp;</th>
				</tr>
		<% 
			/*String strhours_Axis_Dep = hourlyDepAxis.toString();
			String strhourly_flight_count_Axis_Dep = hourlyDepFlt.toString();*/
			String[] hourListDepFlt = strhours_Axis_Dep.toString().replace("\"", "").split(",");
			String[] hourListDepFltCount = strhourly_flight_count_Axis_Dep.split(",");
			for (int i = hourListDepFlt.length - 1; i >= 0 ; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#b3f4ff;border-color: #006778;width:50%; font-weight: bold;text-align: center;"><%=hourListDepFlt[i].equals("0") ? "&nbsp;" : hourListDepFlt[i]%></td>
				<td style="background-color:#e5fbff;border-color: #006778;width:50%; font-weight: bold; text-align: right;"><%=hourListDepFltCount[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(hourListDepFltCount[i]))%>&nbsp;&nbsp;</td>

			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Hourly Clearance of Departure Flights - End	////////////////////////%>

	<div class="col-sm-4" style="flex:2;">
	<div class="card"style="border: solid 3px #006778; border-radius: 20px; height: 314px;">
	<div class="card-body" style="height:314px;">
<!-- 		<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Departure Flights</h1>
 -->
		<canvas id="myPlot2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #c4f2fa 100%);border-radius: 20px; height:314px;"></canvas>
		</div>
			</div>
		</div>
		</div>
		</div>
		<script>
		// Data define for bar chart

		var myDataaaaa = {
			labels: [<%=reverseOnComma(strhours_Axis_Dep)%>],
			datasets: [{ 
				  label: "Departure Flights",
			      backgroundColor: "#79E0EE",
			      borderColor: "#3AA6B9",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strhourly_flight_count_Axis_Dep)%>]
			}]
		};
		 	
		// Options to display value on top of bars

		var myoptionssssss = {
			responsive: true,
			maintainAspectRatio: false,
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            },
							gridLines:{
								display:false,
							}
				        }]
				    },
		 title: {
				display: true,
					text:'Hourly Clearance of Departure Flights',
				fontSize: 15,		
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metassssss = chartInstances.controller.getDatasetMeta(i);
						metassssss.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x + 2 , bar._model.y );
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('myPlot2').getContext('2d');
		var myChartssssss = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myDataaaaa,    	// Chart data
			options: myoptionssssss 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
<%
///////////////////////////////////////	Hourly Clearance of Departure Flights - End	/////////////////////////////////////////////%>

		</div>
		</section>

<%///////////////HOURLY////////////////%>

		<section id="visa_1"><br><br><br><br><br><br><br>
		<div class="pt-4" id="visa_1">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Visa Clearance in last 7 days</th>
				</tr>

			</thead>
		</table>

		<%//////////////////////////////////////////////	Arrival : Visa Clearance in last 7 days - Start	////////////////////////////////////////////////////
	String WeeklyVisaQuery = "";
	String weeklyVisaXAxis = "";
	int weekelyEVisaCount = 0;
	int weekelyVOACount = 0;
	int weeklyRegularCount = 0;
	int weeklyOCICount = 0;
	int weeklyEx = 0;
	int weeklyExCount = 0; 

	StringBuilder weekDaysVisa = new StringBuilder();
	StringBuilder weekEVisa = new StringBuilder();
	StringBuilder weekVOA = new StringBuilder();
	StringBuilder weekRegular = new StringBuilder();
	StringBuilder weekOCI = new StringBuilder();
	StringBuilder weekEx = new StringBuilder();

	  flagFlightCount = false;
	try {
		WeeklyVisaQuery = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count) as sum_hourly_visa_exempted_count,sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from  IM_DASHBOARD_COMBINED where ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyVisaQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyVisaXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weekelyEVisaCount = rsTemp.getInt("sum_evisa_count");
			weekelyVOACount = rsTemp.getInt("sum_hourly_voa_count");
			weeklyRegularCount = rsTemp.getInt("hourly_regular_visa_count");
			weeklyOCICount = rsTemp.getInt("sum_hourly_oci_count");
			weeklyExCount = rsTemp.getInt("sum_hourly_visa_exempted_count");
			//out.println(weeklyOCICount);

			if (flagFlightCount == true) {
				weekDaysVisa.append(",");
				weekEVisa.append(",");
				weekVOA.append(",");
				weekRegular.append(",");
				weekOCI.append(",");
				weekEx.append(",");
				} 
			else
			flagFlightCount = true;

			weekDaysVisa.append("\"");
			weekDaysVisa.append(weeklyVisaXAxis);
			weekDaysVisa.append("\"");
			
			weekEVisa.append(weekelyEVisaCount);
			weekVOA.append(weekelyVOACount);
			weekRegular.append(weeklyRegularCount);
			weekOCI.append(weeklyOCICount);
			weekEx.append(weeklyExCount);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Visa Exception");
	}

	String strWeekDaysVisa = weekDaysVisa.toString();
	String strweekEVisa = weekEVisa.toString();
	String strweekVOA = weekVOA.toString();
	String strweekRegular = weekRegular.toString();
	String strweekOCI = weekOCI.toString();
	String strweekEx = weekEx.toString();
	//out.println(strweekOCI);
	
	%>
<%////////////////	Table - Arrival : Visa Clearance in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-4">
	<table class="tableDesign">
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%;">Date</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">e-Visa&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">OCI&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">Regular&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">VOA&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">Exempted&nbsp;&nbsp;</th>
			</tr>
		<% 
			String[] weekListWeekly = strWeekDaysVisa.toString().replace("\"", "").split(",");
			String[] eVisaWeekly = strweekEVisa.split(",");
			String[] OCIWeekly = strweekOCI.split(",");
			String[] RegularWeekly = strweekRegular.split(",");
			String[] VOAWeekly = strweekVOA.split(",");
			String[] ExWeekly = strweekEx.split(",");
			//String v_date_Format  = "";
			for (int i = 0; i < weekListWeekly.length; i++) {
							
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#f69a83;border-color: #ed3e12;width:20%; font-weight: bold;text-align: center;"><%=weekListWeekly[i].equals("0") ? "&nbsp;" : weekListWeekly[i]%></td>
				<td style="background-color:#f7ac99;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=eVisaWeekly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(eVisaWeekly[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#f9bfb0;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=OCIWeekly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(OCIWeekly[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#fbd1c7;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=RegularWeekly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(RegularWeekly[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#fce3dd;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=VOAWeekly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(VOAWeekly[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#fef6f4;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=ExWeekly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(ExWeekly[i]))%>&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>	
		</div>
	<%///////////////////////	Table - Types of Visa in last 7 days - End	////////////////////////%>

<div class="col-sm-8">
<div class="card" style="border: solid 3px #FF5733; border-radius: 20px; height:500px;">
<div class="card-body" style="height:500px;">
<canvas id="canvasWeeklyVisa" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #fbc7dc 100%);border-radius: 20px; height:500px;"></canvas>
</div>
</div>
</div>
</div>
</div>
<script>
// Data define for bar chart

var myData = {
	labels: [<%=strWeekDaysVisa%>],
	datasets: [{ 
		  label: "e-Visa",
		  backgroundColor: "#FF5733",
		  borderColor: "red",
		  borderWidth: 0,
		 
		  data: [<%=strweekEVisa%>]
	},{ 
		  label: "OCI",
		  backgroundColor: "teal",
		  borderColor: "teal",
		  borderWidth: 1,
		 
		  data: [<%=strweekOCI%>]
	},{ 
		  label: "Regular",
		  backgroundColor: "#ffa600",
		  borderColor: "orange",
		  borderWidth: 1,
		 
		  data: [<%=strweekRegular%>]
	}, { 
		  label: "VOA",
		  backgroundColor: "cornflowerblue",
		  borderColor: "cornflowerblue",
		  borderWidth: 1,
		  data: [<%=strweekVOA%>]
	}, { 
		  label: "Exempted",
		  backgroundColor: "#900C3F",
		  borderColor: "#900C3F",
		  borderWidth: 1,
		  data: [<%=strweekEx%>]
	}]};
	

// Options to display value on top of bars

var myoptions = {
	maintainAspectRatio:false,
		responsive:true,
		 title: {
				display :true,
				fontSize: 14,	
					text:'Arrival : Visa Clearance in last 7 days',
			  },
			 scales: {
					yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
						gridLines: false,
					}],
					xAxes: [{
						gridLines:{
							color:"#f16d4c",
						}
					}]
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
			ctx.fillStyle = "rgba(0, 0, 0, 1)";
			ctx.textBaseline = 'bottom';
			ctx.font = "bold 9px Verdana";

			this.data.datasets.forEach(function (dataset, i) {
				var metas = chartInstances.controller.getDatasetMeta(i);
				metas.data.forEach(function (bar, index) {
					var data = dataset.data[index];
					ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y - 1);
					
				});
			});
		}
	}
};

//Code to drow Chart

var ctx = document.getElementById('canvasWeeklyVisa').getContext('2d');
var myCharts = new Chart(ctx, {
	type: 'bar',    	// Define chart type
	data: myData,    	// Chart data
	options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
});
</script>

<%//////////////////////////////////////	Types of Visa in last 7 days - End	/////////////////////////////////%>

</section>
	
<section id="visa_2"><br><br><br><br><br><br><br>
<div class="pt-4" id="visa_2">    
<table id = "auto-index7" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Visa Clearance in last <%=displayHours%> hours</th>
		</tr>
		<!--<tr id='head' name='ucf'>
			<th>S.No.</th>
			<th>Date</th>
			<td>&nbsp;&nbsp;&nbsp;</td>
			<th>Description</th>
		</tr>-->
	</thead>
</table>
</section>
		<%	//////////////////////////////////////////////	Types of Visa in last 7 hours - Start	////////////////////////////////////////////////////
	String hourlyVisaQuery = "";
	String hourlyVisaXAxis = "";
	int hourlyEVisaCount = 0;
	int hourlyVOACount = 0;
	int hourlyRegularCount = 0;
	int hourlyOCICount = 0;
	

	StringBuilder hourlyVisa = new StringBuilder();
	StringBuilder hourlyEVisa = new StringBuilder();
	StringBuilder hourlyVOA = new StringBuilder();
	StringBuilder hourlyRegular = new StringBuilder();
	StringBuilder hourlyOCI = new StringBuilder();

	String hourSet_hourlyVisa = "";
	java.util.Date v_hourSet_hourlyVisa = null;
	//DateFormat vVisaDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vVisaDateFormat = new SimpleDateFormat("MMM-dd HH");


	 flagFlightCount = false;
	try {
		hourlyVisaQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_evisa_count,hourly_voa_count,hourly_regular_visa_count,hourly_visa_exempted_count,hourly_oci_count,hourly_foreigner_count, table_type from im_dashboard_combined where pax_boarding_date =trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<="+displayHours;
		psTemp = con.prepareStatement(hourlyVisaQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {



			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyVisaXAxis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyVisaXAxis = rsTemp.getString("hours").substring(0,2) +" PM" ;

			hourlyEVisaCount = rsTemp.getInt("hourly_evisa_count");
			hourlyVOACount = rsTemp.getInt("hourly_voa_count");
			hourlyRegularCount = rsTemp.getInt("hourly_regular_visa_count");
			hourlyOCICount = rsTemp.getInt("hourly_oci_count");
			//out.println(hourlyOCICount);

			if (flagFlightCount == true) {
				hourlyVisa.append(",");
				hourlyEVisa.append(",");
				hourlyVOA.append(",");
				hourlyRegular.append(",");
				hourlyOCI.append(",");
				} 
			else
			flagFlightCount = true;

			hourlyVisa.append("\"");
			hourlyVisa.append(hourlyVisaXAxis);
			hourlyVisa.append("\"");
			
			hourlyEVisa.append(hourlyEVisaCount);
			hourlyVOA.append(hourlyVOACount);
			hourlyRegular.append(hourlyRegularCount);
			hourlyOCI.append(hourlyOCICount);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Hourly Visa Exception");
	}

	String strHourlyVisa = hourlyVisa.toString();
	String strHourlyEVisa = hourlyEVisa.toString();
	String strHourlyVOA = hourlyVOA.toString();
	String strHourlyRegular = hourlyRegular.toString();
	String strHourlyOCI = hourlyOCI.toString();
	//out.println(strHourlyOCI);
	
	%>
<%////////////////////	Table - Types of Visa in last 7 hours - Start	/////////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-4">
		<table class="tableDesign">
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%;">Time</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">e-Visa&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">OCI&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">Regular&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #b8300e;width:20%; text-align: right;">VOA&nbsp;&nbsp;</th>
			</tr>
			<%

			
			/*String strHourlyVisa = hourlyVisa.toString();
			String strHourlyEVisa = hourlyEVisa.toString();
			String strHourlyVOA = hourlyVOA.toString();
			String strHourlyRegular = hourlyRegular.toString();
			String strHourlyOCI = hourlyOCI.toString();*/


			String[] WeekListVisaHourly = strHourlyVisa.toString().replace("\"", "").split(",");
			String[] eVisa = strHourlyEVisa.split(",");
			String[] OCIVisaHourly = strHourlyOCI.split(",");
			String[] RegularVisaHourly = strHourlyRegular.split(",");
			String[] VOAVisaHourly = strHourlyVOA.split(",");

			//String d_date_Format  = "";

			for (int i = WeekListVisaHourly.length - 1; i >= 0 ; i--) {


			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color: #f7ac99;border-color: #ed3e12;width:20%; font-weight: bold;text-align: center;"><%=WeekListVisaHourly[i].equals("0") ? "&nbsp;" : WeekListVisaHourly[i]%></td>
				<td style="background-color:#f9bfb0;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=eVisa[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(eVisa[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#fbd1c7;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=OCIVisaHourly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(OCIVisaHourly[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#fce3dd;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=RegularVisaHourly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(RegularVisaHourly[i]))%>&nbsp;&nbsp;</td>
				<td style="background-color:#fef6f4;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=VOAVisaHourly[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(VOAVisaHourly[i]))%>&nbsp;&nbsp;</td>
			</tr>

			<%
			}
			%>
		</table>
		</div>
<% /////////////////	Table - Types of Visa in last 7 hours - End	/////////////////////%>
<div class="col-sm-8">
<div class="card" style="border: solid 3px #FF5733; border-radius: 20px; height:500px;">
<div class="card-body" style="height:500px;">

	<canvas id="canvasHourlyVisa" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #ffa5bf 100%);border-radius: 20px; height:500px;"></canvas>
</div>
</div>
</div>
</div>
</div>
<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyVisa)%>],
			datasets: [{ 
				  label: "e-Visa",
			      backgroundColor: " #FF5733",
			      borderColor: "#FF5733",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyEVisa)%>]
			},{ 
				  label: "OCI",
			      backgroundColor: "teal",
			      borderColor: "teal",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyOCI)%>]
			},{ 
				  label: "Regular",
			      backgroundColor: "#ffa600",
			      borderColor: "#FF5733",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyRegular)%>]
			}, { 
				  label: "VOA",
			      backgroundColor: "#a3c4f6",
			      borderColor: "slateblue",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyVOA)%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
			responsive:true,
			maintainAspectRatio:false,
				 title: {
						display:true,
				        fontSize: 12,
						text:'Arrival : Visa Clearance in last <%=displayHours%> hours',	
				      },
					 scales: {
					        yAxes: [{
					            ticks: {
					                display: false //removes y axis values in  bar graph
					            },
								gridLines: {
									display: false,
								}
					        }],
							xAxes: [{
								gridLines:{
								color:"#f16d4c",
								}
							}]
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y+1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasHourlyVisa').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
<%//////////////////////////////////////	Types of Visa in last 7 hours - End	/////////////////////////////////%>


<section class="aboutsection" id="biometric_1"><br><br><br><br><br><br><br>
	<div class="pt-4" id="biometric_1">    
	<table id = "auto-index8" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Biometric Enrollment/Verification/Exemption Statistics</th>
			</tr>
		</thead>
	</table>
</section>	
<%//////////////////////	Arrival : Biometric Enrollment/Verification/Exemption Statistics in last 7 days - Start	/////////////////////////////////
 boolean flagFlightCountb = false;

//String WeeklyNationality_Arr = "";
String weeklyBioXAxis_Arr = "";
int weekelyEnroll_Arr = 0;
int weekelyVerified_Arr = 0;
int weekelyExempted_Arr = 0;
String SQLQUERY_B_Arr = "";


StringBuilder weekDaysBio_Arr = new StringBuilder();
StringBuilder weekEnroll_Arr = new StringBuilder();
StringBuilder weekVerified_Arr = new StringBuilder();
StringBuilder weekExempted_Arr = new StringBuilder();

StringBuilder B_Enroll_Arr = new StringBuilder();
StringBuilder B_Verified_Arr = new StringBuilder();
StringBuilder B_Exempted_Arr = new StringBuilder();

String strweekDaysBio_Arr = "";
String strweekEnroll_Arr = "";
String strweekVerified_Arr = "";
String strweekExempted_Arr  = "";

double Enroll_Precent_Arr = 0;
double Verified_Precent_Arr = 0;
double Exempted_Precent_Arr = 0;

int Bio_Total_sum_number_Arr = 0;
int Enroll_sum_hunder_Arr = 0;
int Verified_sum_hunder_Arr = 0;
int Exempted_sum_hunder_Arr = 0;

	%>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign" >
			<tr style="font-size: 15px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th colspan="4" style="text-align: center;background-color:#007d79;border-color: #007d79;width:20%; text-align: center;">Arrival : Biometric Enrollment/Verification/Exemption Statistics in last 7 days</th>
			</tr>
			<tr style="font-size: 15px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#007d79;border-color: #004a48;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#007d79;border-color: #004a48;width:20%; text-align: right;">Enrollment&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #004a48;width:20%; text-align: right;">Verification&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #004a48;width:20%; text-align: right;">Exempted&nbsp;&nbsp;</th>
			</tr>
<%

try
	{
	SQLQUERY_B_Arr = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_3, pax_boarding_date,ICP_SRNO,sum(HOURLY_BIO_ENROLLED) as sum_HOURLY_BIO_ENROLLED, sum(HOURLY_BIO_VERIFIED) as sum_HOURLY_BIO_VERIFIED, sum(HOURLY_BIO_EXEMPTED) as sum_HOURLY_BIO_EXEMPTED, table_type from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
	psTemp = con.prepareStatement(SQLQUERY_B_Arr);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
		Enroll_Precent_Arr = 0;
		Verified_Precent_Arr = 0;
			weeklyBioXAxis_Arr = rsTemp.getString("pax_boarding_date_3");
			weekelyEnroll_Arr = rsTemp.getInt("sum_HOURLY_BIO_ENROLLED"); 
			weekelyVerified_Arr = rsTemp.getInt("sum_HOURLY_BIO_VERIFIED"); 
			weekelyExempted_Arr = rsTemp.getInt("sum_HOURLY_BIO_EXEMPTED"); 

			weekDaysBio_Arr.append("\"");
			weekDaysBio_Arr.append(weeklyBioXAxis_Arr);
			weekDaysBio_Arr.append("\"");
			weekDaysBio_Arr.append(",");
			weekEnroll_Arr.append(weekelyEnroll_Arr + ",");
			weekVerified_Arr.append(weekelyVerified_Arr +",");
			weekExempted_Arr.append(weekelyExempted_Arr +",");

			Enroll_sum_hunder_Arr = weekelyEnroll_Arr * 100;
			Verified_sum_hunder_Arr = weekelyVerified_Arr * 100;
			Exempted_sum_hunder_Arr = weekelyExempted_Arr * 100;
			Bio_Total_sum_number_Arr = weekelyEnroll_Arr + weekelyVerified_Arr + weekelyExempted_Arr;

			Enroll_Precent_Arr = (double) Enroll_sum_hunder_Arr / Bio_Total_sum_number_Arr;
			Verified_Precent_Arr = (double) Verified_sum_hunder_Arr / Bio_Total_sum_number_Arr;
			Exempted_Precent_Arr = (double) Exempted_sum_hunder_Arr / Bio_Total_sum_number_Arr;

			B_Enroll_Arr.append( Math.round(Enroll_Precent_Arr)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));

			B_Verified_Arr.append( Math.round(Verified_Precent_Arr) + ",");

			B_Exempted_Arr.append( Math.round(Exempted_Precent_Arr) + ",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#f0ffff;border-color:#007977;width:33.33%; font-weight: bold;text-align: center;"><%=rsTemp.getString("pax_boarding_date_3").replace("-","&#8209;")%></td>
				<td style="background-color:#f0ffff;border-color:#007977;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_HOURLY_BIO_ENROLLED") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_HOURLY_BIO_ENROLLED"))%>&nbsp;</td>
				<td style="background-color:#f0ffff;border-color:#007977;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_HOURLY_BIO_VERIFIED") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_HOURLY_BIO_VERIFIED"))%>&nbsp;</td>
				<td style="background-color:#f0ffff;border-color:#007977;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_HOURLY_BIO_EXEMPTED") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_HOURLY_BIO_EXEMPTED"))%>&nbsp;</td>
			</tr>
			<%
	}
			rsTemp.close();
			psTemp.close();

			strweekDaysBio_Arr = weekDaysBio_Arr.toString();
			strweekDaysBio_Arr = strweekDaysBio_Arr.substring(0,strweekDaysBio_Arr.length()-1);

			strweekEnroll_Arr = B_Enroll_Arr.toString();
			strweekEnroll_Arr = strweekEnroll_Arr.substring(0,strweekEnroll_Arr.length()-1);

			strweekVerified_Arr = B_Verified_Arr.toString();
			strweekVerified_Arr = strweekVerified_Arr.substring(0,strweekVerified_Arr.length()-1);

			strweekExempted_Arr = B_Exempted_Arr.toString();
			strweekExempted_Arr = strweekExempted_Arr.substring(0,strweekExempted_Arr.length()-1);
	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("Dep");
	}
			%>
		</table>
		</div>

<%///////////////////////	Table - End -  Arrival : Biometric Enrollment/Verification/Exemption Statistics in last 7 days	////////////////////////%>

	<%////////////////	graph -  Start - Arrival : Biometric Enrollment/Verification/Exemption Statistics in last 7 days	///////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #007d79; border-radius: 20px;height:400px;">
<div class="card-body" style=" height:400px;">
<canvas id="canvasWeeklyBio_Arr" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #9ef0f0 100%); border-radius: 20px;height:400px; "></canvas>
</div>
</div>	
</div>

	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysBio_Arr%>],
			datasets: [{ 
				  label: "Enrollment",
			      backgroundColor: "#007d79",
			      borderColor: "#007d79",
			      borderWidth: 0,
			     
			      data: [<%=strweekEnroll_Arr%>]
			},{ 
				  label: "Verification",
			      backgroundColor: "#FC7300",
			      borderColor: "#FC7300",
			      borderWidth: 1,
			     
			      data: [<%=strweekVerified_Arr%>]
			},
			{ 
				  label: "Exempted",
			      backgroundColor: "royalblue",
			      borderColor: "royalblue",
			      borderWidth: 1,
			     
			      data: [<%=strweekExempted_Arr%>]
			}]};
		 	

		// Options to display value on top of bars

			var myoptions = {
			   responsive: true,
				   maintainAspectRatio: false,
				
			scales: {
					yAxes: [{
					ticks: { beginAtZero: true },
					stacked: true,
						gridLines:{
						color:"grey",
					}
					}],
					xAxes: [{
					stacked: true,display: false
					}],

			},
		 title: {
				display: true,
					text:'Biometric Enrollment/Verification/Exemption in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data + "%", bar._model.x-25, bar._model.y+6 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart


		var ctx = document.getElementById('canvasWeeklyBio_Arr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%///////////////////	End - Arrival : Biometric Enrollment/Verification/Exemption Statistics in last 7 days	///////////////////%>


		<%////////////////////////////	Biometric Enrollment/Verification/Exemption in last 7 hours - Start	/////////////////%>

<%//////////////////////	Arrival : Biometric Enrollment/Verification/Exemption Statistics in last 7 days - Start	/////////////////////////////////


	// boolean flagFlightCountb = false;

	String weeklyBioXAxis_Arrh = "";
	int weekelyEnroll_Arrh = 0;
	int weekelyVerified_Arrh = 0;
	int weekelyExempted_Arrh = 0;
	String SQLQUERY_B_Arrh = "";


	StringBuilder weekDaysBio_Arrh = new StringBuilder();
	StringBuilder weekEnroll_Arrh = new StringBuilder();
	StringBuilder weekVerified_Arrh = new StringBuilder();
	StringBuilder weekExempted_Arrh = new StringBuilder();

	StringBuilder B_Enroll_Arrh = new StringBuilder();
	StringBuilder B_Verified_Arrh = new StringBuilder();
	StringBuilder B_Exempted_Arrh = new StringBuilder();

	String strweekDaysBio_Arrh = "";
	String strweekEnroll_Arrh = "";
	String strweekVerified_Arrh = "";
	String strweekExempted_Arrh  = "";

	double Enroll_Precent_Arrh = 0;
	double Verified_Precent_Arrh = 0;
	double Exempted_Precent_Arrh = 0;

	int Bio_Total_sum_number_Arrh = 0;
	int Enroll_sum_hunder_Arrh = 0;
	int Verified_sum_hunder_Arrh = 0;
	int Exempted_sum_hunder_Arrh = 0;

	%>
	<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign" >
			<tr style="font-size: 15px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th colspan="4" style="width:40%;text-align: center;background-color:#e93d6b;border-color: #e93d6b; text-align: center;">Arrival : Biometric Enrollment/Verification/Exemption Statistics in last <%=displayHours%> hours</th> 
			</tr>
			<tr style="font-size: 15px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="width:40%;text-align: center;background-color:#e93d6b;border-color: #c41645; text-align: center;">Time</th>
				<th style="width:20%;text-align: center;background-color:#e93d6b;border-color: #c41645; text-align: right;">Enrollment&nbsp;&nbsp;</th>
				<th style="width:20%;text-align: center;background-color:#e93d6b;border-color: #c41645; text-align: right;">Verification&nbsp;&nbsp;</th>
				<th style="width:20%;text-align: center;background-color:#e93d6b;border-color: #c41645; text-align: right;">Exempted&nbsp;&nbsp;</th>
			</tr>

<%

try
	{
	SQLQUERY_B_Arrh = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,HOURLY_BIO_ENROLLED,HOURLY_BIO_VERIFIED,HOURLY_BIO_EXEMPTED, table_type from im_dashboard_combined where pax_boarding_date >= trunc(sysdate-1) and table_type='IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date desc,HOURS desc ) where rownum<="+displayHours;
	
	psTemp = con.prepareStatement(SQLQUERY_B_Arrh);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//weeklyBioXAxis_Arrh = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				weeklyBioXAxis_Arrh =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//weeklyBioXAxis_Arrh = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				weeklyBioXAxis_Arrh = rsTemp.getString("hours").substring(0,2) +" PM" ;


		Enroll_Precent_Arrh = 0;
		Verified_Precent_Arr = 0;
		Exempted_Precent_Arr = 0;
			weekelyEnroll_Arrh = rsTemp.getInt("HOURLY_BIO_ENROLLED"); 
			weekelyVerified_Arrh = rsTemp.getInt("HOURLY_BIO_VERIFIED"); 
			weekelyExempted_Arrh = rsTemp.getInt("HOURLY_BIO_EXEMPTED"); 

			weekDaysBio_Arrh.append("\"");
			weekDaysBio_Arrh.append(weeklyBioXAxis_Arrh);
			weekDaysBio_Arrh.append("\"");
			weekDaysBio_Arrh.append(",");
			weekEnroll_Arrh.append(weekelyEnroll_Arrh + ",");
			weekVerified_Arrh.append(weekelyVerified_Arrh +",");
			weekExempted_Arrh.append(weekelyExempted_Arrh +",");

			Enroll_sum_hunder_Arrh = weekelyEnroll_Arrh * 100;
			Verified_sum_hunder_Arrh = weekelyVerified_Arrh * 100;
			Exempted_sum_hunder_Arrh = weekelyExempted_Arrh * 100;
			Bio_Total_sum_number_Arrh = weekelyEnroll_Arrh + weekelyVerified_Arrh + weekelyExempted_Arrh;

			Enroll_Precent_Arrh = (double) Enroll_sum_hunder_Arrh / Bio_Total_sum_number_Arrh;
			Verified_Precent_Arrh = (double) Verified_sum_hunder_Arrh / Bio_Total_sum_number_Arrh;
			Exempted_Precent_Arrh = (double) Exempted_sum_hunder_Arrh / Bio_Total_sum_number_Arrh;

			B_Enroll_Arrh.append( Math.round(Enroll_Precent_Arrh)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));

			B_Verified_Arrh.append( Math.round(Verified_Precent_Arrh) + ",");

			B_Exempted_Arrh.append( Math.round(Exempted_Precent_Arrh) + ",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#ffeeee;border-color:#c41645;width:40%; font-weight: bold;text-align: center;"><%=weeklyBioXAxis_Arrh.replace(" ","&nbsp;")%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#c41645;width:20%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("HOURLY_BIO_ENROLLED") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("HOURLY_BIO_ENROLLED"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#c41645;width:20%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("HOURLY_BIO_VERIFIED") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("HOURLY_BIO_VERIFIED"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#c41645;width:20%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("HOURLY_BIO_EXEMPTED") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("HOURLY_BIO_EXEMPTED"))%>&nbsp;</td>
			</tr>
			<%
	}
			rsTemp.close();
			psTemp.close();

			strweekDaysBio_Arrh = weekDaysBio_Arrh.toString();
			strweekDaysBio_Arrh = strweekDaysBio_Arrh.substring(0,strweekDaysBio_Arrh.length()-1);
	//out.println(strweekDaysBio_Arrh + "<br>");

			strweekEnroll_Arrh = B_Enroll_Arrh.toString();
			strweekEnroll_Arrh = strweekEnroll_Arrh.substring(0,strweekEnroll_Arrh.length()-1);

			strweekVerified_Arrh = B_Verified_Arrh.toString();
			strweekVerified_Arrh = strweekVerified_Arrh.substring(0,strweekVerified_Arrh.length()-1);

			strweekExempted_Arrh = B_Exempted_Arrh.toString();
			strweekExempted_Arrh = strweekExempted_Arrh.substring(0,strweekExempted_Arrh.length()-1);
	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("Dep");
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Arrival : Biometric Enrollment/Verification/Exemption hours - End	////////////////////////%>

	<%////////////////	graph -  Arrival : Biometric Enrollment/Verification/Exemption hours - Start	///////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #da1e28; border-radius: 20px;height:400px;">
<div class="card-body" style="height:400px;">
<canvas id="canvasWeeklyBio_Arrh" class="chart" style="max-width: 100%; background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%); border-radius: 20px;height:400px; "></canvas>
	</div>
	</div>	
	</div>
	</div>
	</div>	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysBio_Arrh%>],
			datasets: [{ 
				  label: "Enrollment",
			      backgroundColor: "#FF004D",
			      borderColor: "#FF004D",
			      borderWidth: 0,
			     
			      data: [<%=strweekEnroll_Arrh%>]
			},{ 
				  label: "Verification",
			      backgroundColor: "#FC7300",
			      borderColor: "#FC7300",
			      borderWidth: 1,
			     
			      data: [<%=strweekVerified_Arrh%>]
			},
			{ 
				  label: "Exempted",
			      backgroundColor: "royalblue",
			      borderColor: "royalblue",
			      borderWidth: 1,
			     
			      data: [<%=strweekExempted_Arrh%>]
			}]};
		 	

		// Options to display value on top of bars

			var myoptions = {
			   responsive: true,
				   maintainAspectRatio: false,
				
		scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

		},
		 title: {
				display: true,
					text:'Biometric Enrollment/Verification/Exemption in last <%=displayHours%> hours',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data + "%", bar._model.x-25, bar._model.y+6 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyBio_Arrh').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%//////////////////////////	Arrival : Biometric Enrollment/Verification/Exemption in last 7 hours - End	/////////////////////////////////%>


		<section class="aboutsection" id="ICS_Arr_Gender"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Arr_Gender">    
		<table id = "auto-index8" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Gender Based Statistics in last 7 days</th>
				</tr>
			</thead>
		</table>
	</section>
		


<%///////////////////	Arrival : Gender Based Statistics in last 7 days - Start	///////////////////

	String WeeklyGender_Arrg = "";
	String weeklyGenderXAxis_Arrg = "";
	int weeklyMaleCount_Arrg = 0;
	int weeklyFemaleCount_Arrg = 0;
	int weeklyOthersCount_Arrg = 0;
	

	StringBuilder weekDaysGender_Arrg = new StringBuilder();
	StringBuilder weekMale_Arrg = new StringBuilder();
	StringBuilder weekFemale_Arrg = new StringBuilder();
	StringBuilder weekOthers_Arrg = new StringBuilder();

	double male_count = 0;
	double female_count = 0;
	double others_count = 0;

	int Total_Gender = 0;
	int male_sum = 0;
	int female_sum = 0;
	int others_sum = 0;

	StringBuilder B_male = new StringBuilder();
	StringBuilder B_female = new StringBuilder();
	StringBuilder B_others = new StringBuilder();

	String strWeekDaysGender_Arrg = "";

	String strWeekMale_Arrg = "";
	String strWeekFemale_Arrg = "";
	String strWeekOthers_Arrg = "";

	////////////////	Table -  Arrival : Gender Based Statistics in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-3" style="flex:1;">

		<table class="tableDesign">

			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th colspan="5" style="text-align: center;background-color:#e72a5c;border-color: #e72a5c;width:20%; text-align: center;">Arrival</th>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Male&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Female&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Others&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
			</tr>
			<%
	try {
		WeeklyGender_Arrg = "select SUM(HOURLY_MALE_COUNT) as sum_hourly_male_count, SUM(HOURLY_FEMALE_COUNT) as sum_hourly_female_count, SUM(HOURLY_OTHERS_COUNT) as sum_hourly_others_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from IM_DASHBOARD_COMBINED_PAX_BOARDING_DATE where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyGender_Arrg);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyGenderXAxis_Arrg = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weeklyMaleCount_Arrg = rsTemp.getInt("sum_hourly_male_count");
			weeklyFemaleCount_Arrg = rsTemp.getInt("sum_hourly_female_count");
			//weeklyOthersCount_Arrg = rsTemp.getInt("sum_hourly_others_count");

			if(rsTemp.getInt("sum_hourly_others_count") == 0)
				weeklyOthersCount_Arrg = rsTemp.getInt("sum_hourly_others_count");
			else
				weeklyOthersCount_Arrg = rsTemp.getInt("sum_hourly_others_count") + (( weeklyMaleCount_Arrg + weeklyFemaleCount_Arrg )/100);


			weekDaysGender_Arrg.append("\"");
			weekDaysGender_Arrg.append(weeklyGenderXAxis_Arrg);
			weekDaysGender_Arrg.append("\"");
			weekDaysGender_Arrg.append(",");
			
			weekMale_Arrg.append(weeklyMaleCount_Arrg + ",");
			weekFemale_Arrg.append(weeklyFemaleCount_Arrg + ",");
			weekOthers_Arrg.append(weeklyOthersCount_Arrg + ",");


			male_sum = weeklyMaleCount_Arrg * 100;
			female_sum = weeklyFemaleCount_Arrg * 100;
			others_sum = weeklyOthersCount_Arrg * 100;
			Total_Gender = weeklyMaleCount_Arrg + weeklyFemaleCount_Arrg + weeklyOthersCount_Arrg;

			male_count = (double) male_sum / Total_Gender;
			female_count = (double) female_sum / Total_Gender;
			others_count = (double) others_sum / Total_Gender;

			B_male.append( Math.round(male_count)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));
			B_female.append( Math.round(female_count) + ",");
			B_others.append( Math.round(others_count) + ",");

			%>

			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center;"><%=weeklyGenderXAxis_Arrg.replace("-","&#8209;")%></td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_male_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_male_count"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_female_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_female_count"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_others_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_others_count"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right; font-size:15px; color:#e72a5c;"><%=rsTemp.getInt("sum_hourly_male_count") + rsTemp.getInt("sum_hourly_female_count") + rsTemp.getInt("sum_hourly_others_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_male_count") + rsTemp.getInt("sum_hourly_female_count") + rsTemp.getInt("sum_hourly_others_count"))%>&nbsp;</td>
			</tr>
			<%
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println(e);
	}
	%>		</table>
		</div>
<%

	strWeekDaysGender_Arrg = weekDaysGender_Arrg.toString();
	strWeekDaysGender_Arrg = strWeekDaysGender_Arrg.substring(0,strWeekDaysGender_Arrg.length()-1);
	//out.println(strWeekDaysGender_Arrg + "<br>");

	strWeekMale_Arrg = B_male.toString();
	strWeekMale_Arrg = strWeekMale_Arrg.substring(0,strWeekMale_Arrg.length()-1);
	//out.println(strWeekMale_Arrg + "<br>");

	strWeekFemale_Arrg = B_female.toString();
	strWeekFemale_Arrg = strWeekFemale_Arrg.substring(0,strWeekFemale_Arrg.length()-1);
	//out.println(strWeekFemale_Arrg + "<br>");

	strWeekOthers_Arrg = B_others.toString();
	strWeekOthers_Arrg = strWeekOthers_Arrg.substring(0,strWeekOthers_Arrg.length()-1);

	//out.println(strWeekOthers_Arrg);

	//String additionRequired

	String othersDatag = strWeekOthers_Arrg.replaceAll(",0",",");
	if(othersDatag.substring(0,1).equals("0"))
		othersDatag = othersDatag.substring(1,othersDatag.length());
	//out.println(othersDatag);



///////////////////////	Table - Arrival : Gender Based Statistics in last 7 days - End	////////////////////////%>


<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #c51748; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
  <canvas id="canvasWeeklyGender_Arrweek" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #faceda 100%);border-radius: 20px; height:400px;"></canvas>
	</div>
	</div>	
	</div>

	<script>
		// Data define for bar chart

		var myDataw = {
			labels: [<%=strWeekDaysGender_Arrg%>],
			datasets: [{ 
				  label: "Male",
			      backgroundColor: "#0273c4",
			      borderColor: "#0273c4",
			      borderWidth: 1,
			     
			      data: [<%=strWeekMale_Arrg%>]
			},{ 
				  label: "Female",
			      backgroundColor: "#e72a5c",
			      borderColor: "#e72a5c",
			      borderWidth: 1,
			     
			      data: [<%=strWeekFemale_Arrg%>]
			},{ 
				  label: "Others",
			      backgroundColor: "#00e0b2",
			      borderColor: "#00e0b2",
			      borderWidth: 1,
			     
			      data: [<%=othersDatag%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptionsw = {
			   responsive: true,
				   maintainAspectRatio: false,
				
			scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

			},
		 title: {
				display: true,
					text:'Arrival : Gender Based Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							if(i!= 2)
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+5 );
							else
							ctx.fillText("", bar._model.x-30, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyGender_Arrweek').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDataw,    	// Chart data
			options: myoptionsw	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%///////////////////	Arrival : Gender Based Statistics in last 7 days - End	///////////////////%>












<%//////////////////////	Departure : Gender Based Statistics in last 7 days - Start	/////////////////////////////////


	String WeeklyGender_Depg = "";
	String weeklyGenderXAxis_Depg = "";
	int weeklyMaleCount_Depg = 0;
	int weeklyFemaleCount_Depg = 0;
	int weeklyOthersCount_Depg = 0;
	

	StringBuilder weekDaysGender_Depg = new StringBuilder();
	StringBuilder weekMale_Depg = new StringBuilder();
	StringBuilder weekFemale_Depg = new StringBuilder();
	StringBuilder weekOthers_Depg = new StringBuilder();

	double male_count_Dep = 0;
	double female_count_Dep = 0;
	double others_count_Dep = 0;

	int Total_Gender_Dep = 0;
	int male_sum_Dep = 0;
	int female_sum_Dep = 0;
	int others_sum_Dep = 0;

	StringBuilder B_male_Dep = new StringBuilder();
	StringBuilder B_female_Dep = new StringBuilder();
	StringBuilder B_others_Dep = new StringBuilder();

	String strWeekDaysGender_Depg = "";

	String strWeekMale_Depg = "";
	String strWeekFemale_Depg = "";
	String strWeekOthers_Depg = "";
	

	////////////////	Table -  Departure : Gender Based Statistics in last 7 days - Start	///////////////////////%>
	<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign">
			 <tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th colspan="5" style="text-align: center;background-color:#0273c4;border-color: #0273c4;width:20%; text-align: center;">Departure</th>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Male&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Female&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Others&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
			</tr>
			<%
	try {
		WeeklyGender_Depg = "select SUM(HOURLY_MALE_COUNT) as sum_hourly_male_count, SUM(HOURLY_FEMALE_COUNT) as sum_hourly_female_count, SUM(HOURLY_OTHERS_COUNT) as sum_hourly_others_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from IM_DASHBOARD_COMBINED_PAX_BOARDING_DATE where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyGender_Depg);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyGenderXAxis_Depg = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weeklyMaleCount_Depg = rsTemp.getInt("sum_hourly_male_count");
			weeklyFemaleCount_Depg = rsTemp.getInt("sum_hourly_female_count");
			//weeklyOthersCount_Depg = rsTemp.getInt("sum_hourly_others_count");

			if(rsTemp.getInt("sum_hourly_others_count") == 0)
				weeklyOthersCount_Depg = rsTemp.getInt("sum_hourly_others_count");
			else
				weeklyOthersCount_Depg = rsTemp.getInt("sum_hourly_others_count") + (( weeklyMaleCount_Depg + weeklyFemaleCount_Depg )/100);


			weekDaysGender_Depg.append("\"");
			weekDaysGender_Depg.append(weeklyGenderXAxis_Depg);
			weekDaysGender_Depg.append("\"");
			weekDaysGender_Depg.append(",");
			
			weekMale_Depg.append(weeklyMaleCount_Depg + ",");
			weekFemale_Depg.append(weeklyFemaleCount_Depg + ",");
			weekOthers_Depg.append(weeklyOthersCount_Depg + ",");


			male_sum_Dep = weeklyMaleCount_Depg * 100;
			female_sum_Dep = weeklyFemaleCount_Depg * 100;
			others_sum_Dep = weeklyOthersCount_Depg * 100;
			Total_Gender_Dep = weeklyMaleCount_Depg + weeklyFemaleCount_Depg + weeklyOthersCount_Depg;

			male_count_Dep = (double) male_sum_Dep / Total_Gender_Dep;
			female_count_Dep = (double) female_sum_Dep / Total_Gender_Dep;
			others_count_Dep = (double) others_sum_Dep / Total_Gender_Dep;

			B_male_Dep.append( Math.round(male_count_Dep)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));
			B_female_Dep.append( Math.round(female_count_Dep) + ",");
			B_others_Dep.append( Math.round(others_count_Dep) + ",");
			%>

			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#f3faff;border-color:#014F86;width:20%; font-weight: bold;text-align: center;"><%=weeklyGenderXAxis_Depg.replace("-","&#8209;")%></td>
				<td style="background-color:#f3faff;border-color:#014F86;width:20%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_male_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_male_count"))%>&nbsp;</td>
				<td style="background-color:#f3faff;border-color:#014F86;width:20%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_female_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_female_count"))%>&nbsp;</td>
				<td style="background-color:#f3faff;border-color:#014F86;width:20%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_others_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_others_count"))%>&nbsp;</td>
				<td style="background-color:#f3faff;border-color:#014F86;width:20%; font-weight: bold; text-align: right; font-size:15px;color:#0273c4;"><%=rsTemp.getInt("sum_hourly_male_count") + rsTemp.getInt("sum_hourly_female_count") + rsTemp.getInt("sum_hourly_others_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_male_count") + rsTemp.getInt("sum_hourly_female_count") + rsTemp.getInt("sum_hourly_others_count"))%>&nbsp;</td>
			</tr>
			<%
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println(e);
	}
	%>		</table>
		</div>
<%

	strWeekDaysGender_Depg = weekDaysGender_Depg.toString();
	strWeekDaysGender_Depg = strWeekDaysGender_Depg.substring(0,strWeekDaysGender_Depg.length()-1);
	//out.println(strWeekDaysGender_Depg + "<br>");

	strWeekMale_Depg = B_male_Dep.toString();
	strWeekMale_Depg = strWeekMale_Depg.substring(0,strWeekMale_Depg.length()-1);
	//out.println(strWeekMale_Depg + "<br>");

	strWeekFemale_Depg = B_female_Dep.toString();
	strWeekFemale_Depg = strWeekFemale_Depg.substring(0,strWeekFemale_Depg.length()-1);
	//out.println(strWeekFemale_Depg + "<br>");

	strWeekOthers_Depg = B_others_Dep.toString();
	strWeekOthers_Depg = strWeekOthers_Depg.substring(0,strWeekOthers_Depg.length()-1);

	//out.println(strWeekOthers_Depg);

	//String additionRequired

	 othersDatag = strWeekOthers_Depg.replaceAll(",0",",");
	if(othersDatag.substring(0,1).equals("0"))
		othersDatag = othersDatag.substring(1,othersDatag.length());
	//out.println(othersDatag);



///////////////////////	Table - Departure : Gender Based Statistics in last 7 days - End	////////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #014F86; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
  <canvas id="canvasWeeklyGender_Depweek" class="chart" style="max-width: 100%; background: linear-gradient(to bottom, #ffffff 35%, #bae6ff 100%);border-radius: 20px;height:400px;"></canvas>
</div>
</div>	
</div>
</div>
</div>	
<script>
		// Data define for bar chart

		var myDataw = {
			labels: [<%=strWeekDaysGender_Depg%>],
			datasets: [{ 
				  label: "Male",
			      backgroundColor: "#0273c4",
			      borderColor: "#0273c4",
			      borderWidth: 1,
			     
			      data: [<%=strWeekMale_Depg%>]
			},{ 
				  label: "Female",
			      backgroundColor: "#e72a5c",
			      borderColor: "#e72a5c",
			      borderWidth: 1,
			     
			      data: [<%=strWeekFemale_Depg%>]
			},{ 
				  label: "Others",
			      backgroundColor: "#00e0b2",
			      borderColor: "#00e0b2",
			      borderWidth: 1,
			     
			      data: [<%=othersDatag%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptionsw = {
			maintainAspectRatio:false,
			   responsive: true,
				
			scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

			},
		 title: {
				display: true,
					text:'Departure : Gender Based Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							if(i!= 2)
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+5 );
							else
							ctx.fillText("", bar._model.x-30, bar._model.y+5 );
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyGender_Depweek').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDataw,    	// Chart data
			options: myoptionsw	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%///////////////////	Indian/Foreigner Statistics in last 7 days - End	///////////////////%>



<section class="aboutsection" id="ICS_Arr_Indian_Foreigner"><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_Arr_Indian_Foreigner">
<table id = "auto-index8" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Indian/Foreigner Statistics in last 7 days</th>
		</tr>
	</thead>
</table>
</section>
<%//////////////////////	Arrival : Indian/Foreigner Statistics in last 7 days - Start	/////////////////////////////////
	String WeeklyNationality_Arr = "";
	String weeklyNationalityXAxis_Arr = "";
	int weekelyIndianCount_Arr = 0;
	int weekelyForeignerCount_Arr = 0;
	String SQLQUERY_Arr = "";


	StringBuilder weekDaysNationality_Arr = new StringBuilder();
	StringBuilder weekIndian_Arr = new StringBuilder();
	StringBuilder weekForeigner_Arr = new StringBuilder();
	StringBuilder pIndian_Arr = new StringBuilder();
	StringBuilder pForeigner_Arr = new StringBuilder();

	String strweekDaysNationality_Arr = "";
	String strweekIndian_Arr = "";
	String strweekForeigner_Arr = "";

	double indian_Precent_Arr = 0;
	double foreign_Precent_Arr = 0;

	int indian_foreigner_sum_number_Arr = 0;
	int indian_sum_hunder_Arr = 0;
	int foreigner_sum_hunder_Arr = 0;

	%>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign" >
			<tr style="font-size: 17px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th colspan="4" style="text-align: center;background-color:#009d9a;border-color: #009d9a;width:20%; text-align: center;">Arrival</th>
			</tr>
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #009688;height:12px;">
				<th style="text-align: center;background-color:#00ada7;border-color: #007d79;width:33.33%;">Date</th>
				<th style="text-align: center;background-color:#00ada7;border-color: #007d79;width:33.33%; text-align: right;">Indian&nbsp;</th>
				<th style="text-align: center;background-color:#00ada7;border-color: #007d79;width:33.33%; text-align: right;">Foreingner&nbsp;</th>
				<th style="text-align: center;background-color:#00ada7;border-color: #007d79;width:33.33%; text-align: right;">Total&nbsp;</th>
			</tr>
<%
/*	int all_ICP_Arr_Total = 0 ;
	int all_ICP_Dep_Total = 0 ;
	int all_ICP_Total = 0 ;*/
try
	{
	SQLQUERY_Arr = "select SUM(HOURLY_INDIAN_COUNT) as sum_hourly_indian_count, SUM(HOURLY_FOREIGNER_COUNT) as sum_hourly_foreigner_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from  IM_DASHBOARD_COMBINED_PAX_BOARDING_DATE where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
	
	psTemp = con.prepareStatement(SQLQUERY_Arr);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
		indian_Precent_Arr = 0;
		foreign_Precent_Arr = 0;
			weeklyNationalityXAxis_Arr = rsTemp.getString("pax_boarding_date_2");
			weekelyIndianCount_Arr = rsTemp.getInt("sum_hourly_indian_count"); 
			weekelyForeignerCount_Arr = rsTemp.getInt("sum_hourly_foreigner_count"); 

			weekDaysNationality_Arr.append("\"");
			weekDaysNationality_Arr.append(weeklyNationalityXAxis_Arr);
			weekDaysNationality_Arr.append("\"");
			weekDaysNationality_Arr.append(",");
			weekIndian_Arr.append(weekelyIndianCount_Arr + ",");
			weekForeigner_Arr.append(weekelyForeignerCount_Arr +",");

			indian_sum_hunder_Arr = weekelyIndianCount_Arr * 100;
			foreigner_sum_hunder_Arr = weekelyForeignerCount_Arr * 100;
			indian_foreigner_sum_number_Arr = weekelyIndianCount_Arr + weekelyForeignerCount_Arr;

			indian_Precent_Arr = (double) indian_sum_hunder_Arr / indian_foreigner_sum_number_Arr;
			foreign_Precent_Arr = (double) foreigner_sum_hunder_Arr / indian_foreigner_sum_number_Arr;

			pIndian_Arr.append( Math.round(indian_Precent_Arr)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));

			pForeigner_Arr.append( Math.round(foreign_Precent_Arr) + ",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#f0ffff;border-color:#007d79;width:33.33%; font-weight: bold;text-align: center;"><%=rsTemp.getString("pax_boarding_date_2").replace("-","&#8209;")%></td>
				<td style="background-color:#f0ffff;border-color:#007d79;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_indian_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_indian_count"))%>&nbsp;</td>
				<td style="background-color:#f0ffff;border-color:#007d79;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_foreigner_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_foreigner_count"))%>&nbsp;</td>
				<td style="background-color:#f0ffff;border-color:#007d79;width:33.33%; font-weight: bold; text-align: right;color: #005653;font-size:15px;"><%=getIndianFormat((rsTemp.getInt("sum_hourly_indian_count") + rsTemp.getInt("sum_hourly_foreigner_count")))%>&nbsp;</td>
			</tr>
			<%
	}
			rsTemp.close();
			psTemp.close();

			strweekDaysNationality_Arr = weekDaysNationality_Arr.toString();
			strweekDaysNationality_Arr = strweekDaysNationality_Arr.substring(0,strweekDaysNationality_Arr.length()-1);

			strweekIndian_Arr = pIndian_Arr.toString();
			strweekIndian_Arr = strweekIndian_Arr.substring(0,strweekIndian_Arr.length()-1);

			strweekForeigner_Arr = pForeigner_Arr.toString();
			strweekForeigner_Arr = strweekForeigner_Arr.substring(0,strweekForeigner_Arr.length()-1);
	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("Dep");
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>

<%////////////////	graph -  Arrival : Indian/Foreigner Statistics in last 7 days - Start	///////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #007d79; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
<canvas id="canvasWeeklyNationality_Arr" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #9ef0f0 100%); border-radius: 20px; height:400px; "></canvas>
</div>
</div>	
</div>

<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysNationality_Arr%>],
			datasets: [{ 
				  label: "Indian",
			      backgroundColor: "#007d79",
			      borderColor: "#007d79",
			      borderWidth: 0,
			     
			      data: [<%=strweekIndian_Arr%>]
			},{ 
				  label: "Foreigner",
			      backgroundColor: "#FC7300",
			      borderColor: "#FC7300",
			      borderWidth: 1,
			     
			      data: [<%=strweekForeigner_Arr%>]
			}]};
		 	

		// Options to display value on top of bars

			var myoptions = {
			  maintainAspectRatio:false,	
			  responsive: true,
				
		scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

		},
		 title: {
				display: true,
					text:'Arrival : Indian/Foreigner Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyNationality_Arr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>


	<%////////////////	graph -  Indian/Foreigner Count in last 7 days - end	///////////////////////%>


<%///////////////////	Arrival : Indian/Foreigner Statistics in last 7 days - End	///////////////////%>







<%//////////////////////	Departure : Indian/Foreigner Statistics in last 7 days - Start	/////////////////////////////////
	String WeeklyNationality = "";
	String weeklyNationalityXAxis = "";
	int weekelyIndianCount = 0;
	int weekelyForeignerCount = 0;
		String SQLQUERY = "";


	StringBuilder weekDaysNationality = new StringBuilder();
	StringBuilder weekIndian = new StringBuilder();
	StringBuilder weekForeigner = new StringBuilder();
	StringBuilder pIndian = new StringBuilder();
	StringBuilder pForeigner = new StringBuilder();

	String strweekDaysNationality = "";
	String strweekIndian = "";
	String strweekForeigner = "";

	double indian_Precent = 0;
	double foreign_Precent = 0;

	int indian_foreigner_sum_number = 0;
	int indian_sum_hunder = 0;
	int foreigner_sum_hunder = 0;

	%>
	<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign" >
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #009688;height:40px;">
				<th colspan="4" style="text-align: center;background-color:#9b5eff;border-color: #9b5eff;width:33.33%;">Departure</th>
			</tr>
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #9b5eff;height:12px;">
				<th style="text-align: center;background-color:#a56eff;border-color: #863cff;width:33.33%;">Date</th>
				<th style="text-align: center;background-color:#a56eff;border-color: #863cff;width:33.33%; text-align: right;">Indian&nbsp;</th>
				<th style="text-align: center;background-color:#a56eff;border-color: #863cff;width:33.33%; text-align: right;">Foreingner&nbsp;</th>
				<th style="text-align: center;background-color:#a56eff;border-color: #863cff;width:33.33%; text-align: right;">Total&nbsp;</th>
			</tr>
<%
/*	int all_ICP_Arr_Total = 0 ;
	int all_ICP_Dep_Total = 0 ;
	int all_ICP_Total = 0 ;*/
try
	{
	SQLQUERY = "select SUM(HOURLY_INDIAN_COUNT) as sum_hourly_indian_count, SUM(HOURLY_FOREIGNER_COUNT) as sum_hourly_foreigner_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from  IM_DASHBOARD_COMBINED_PAX_BOARDING_DATE where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
		indian_Precent = 0;
		foreign_Precent = 0;
			weeklyNationalityXAxis = rsTemp.getString("pax_boarding_date_2");
			weekelyIndianCount = rsTemp.getInt("sum_hourly_indian_count");
			weekelyForeignerCount = rsTemp.getInt("sum_hourly_foreigner_count"); 

			weekDaysNationality.append("\"");
			weekDaysNationality.append(weeklyNationalityXAxis);
			weekDaysNationality.append("\"");
			weekDaysNationality.append(",");
			weekIndian.append(weekelyIndianCount+ ",");
			weekForeigner.append(weekelyForeignerCount+",");

			indian_sum_hunder = weekelyIndianCount * 100;
			foreigner_sum_hunder = weekelyForeignerCount * 100;
			indian_foreigner_sum_number = weekelyIndianCount + weekelyForeignerCount;

			indian_Precent = (double) indian_sum_hunder / indian_foreigner_sum_number;
			foreign_Precent = (double) foreigner_sum_hunder / indian_foreigner_sum_number;

			pIndian.append( Math.round(indian_Precent)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));

			pForeigner.append( Math.round(foreign_Precent) + ",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#f7f2ff;border-color:#9b5eff;width:33.33%; font-weight: bold;text-align: center;"><%=rsTemp.getString("pax_boarding_date_2").replace("-","&#8209;")%></td>
				<td style="background-color:#f7f2ff;border-color:#9b5eff;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_indian_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_indian_count"))%>&nbsp;</td>
				<td style="background-color:#f7f2ff;border-color:#9b5eff;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("sum_hourly_foreigner_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("sum_hourly_foreigner_count"))%>&nbsp;</td>
				<td style="background-color:#f7f2ff;border-color:#9b5eff;width:33.33%; font-weight: bold; text-align: right;color: #7f2dfc;font-size:15px;"><%=getIndianFormat((rsTemp.getInt("sum_hourly_indian_count") + rsTemp.getInt("sum_hourly_foreigner_count")))%>&nbsp;</td>
			</tr>
			<%
	}
			rsTemp.close();
			psTemp.close();

			strweekDaysNationality = weekDaysNationality.toString();
			strweekDaysNationality = strweekDaysNationality.substring(0,strweekDaysNationality.length()-1);

			strweekIndian = pIndian.toString();
			strweekIndian = strweekIndian.substring(0,strweekIndian.length()-1);

			strweekForeigner = pForeigner.toString();
			strweekForeigner = strweekForeigner.substring(0,strweekForeigner.length()-1);
	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("Dep");
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>

	<%////////////////	graph -  Indian/Foreigner Count in last 7 days - Start	///////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #9b5eff; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
<canvas id="canvasWeeklyNationality" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #d9c1fe 100%); border-radius: 20px; height:400px; "></canvas>
</div>
</div>	
</div>
</div>
</div>	
<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysNationality%>],
			datasets: [{ 
				  label: "Indian",
			      backgroundColor: "#9b5eff",
			      borderColor: "#9b5eff",
			      borderWidth: 0,
			     
			      data: [<%=strweekIndian%>]
			},{ 
				  label: "Foreigner",
			      backgroundColor: "#FC7300",
			      borderColor: "#FC7300",
			      borderWidth: 1,
			     
			      data: [<%=strweekForeigner%>]
			}]};
		 	

		// Options to display value on top of bars

			var myoptions = {
				maintainAspectRatio:false,
			    responsive: true,
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: true,
			gridLines:{
			color:"grey",
		}
		}],
		xAxes: [{
		stacked: true,display: false
		}],

},
		 title: {
				display: true,
					text:'Departure : Indian/Foreigner Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyNationality').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
	</section>

	<%////////////////	graph -  Indian/Foreigner Count in last 7 days - end	///////////////////////%>
<%/////////////////////////////////////////////////////////////////%>
		<section id="ucf_Indian"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ucf_Indian">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Indian UCF Matched/Not Matched Statistics in last 7 days</th>
				</tr>
			</thead>
		</table>
		</section>
		<%//////////////////////////////////////////////	Indian UCF Matched/Not Matched Statistics in last 7 days - Start	////////////////////////////////////////////////////


	String WeeklyUcf_Ind_Arr = "";
	String WeeklyUcf_Ind_Arr_Axis = "";
	int weeklyMatchedIndArr = 0;
	int weeklyNotMatchedIndArr = 0;
	

	StringBuilder weekIndianUcf = new StringBuilder();
	StringBuilder weekMatchedIndianUcf = new StringBuilder();
	StringBuilder weekNotMatchedIndianUcf = new StringBuilder();

	double matched_count_Ind_Arr = 0;
	double notmatched_count_Ind_Arr = 0;

	int Total_Ucf_Ind_Arr = 0;
	int Matched_Ucf_Ind_Arr = 0;
	int Not_Matched_Ucf_Ind_Arr = 0;

	StringBuilder B_matched_Ucf_Ind_Arr = new StringBuilder();
	StringBuilder B_not_matched_Ucf_Ind_Arr = new StringBuilder();

	String strweekIndianUcf = "";

	String strweekMatchedIndianUcf = "";
	String strweekNotMatchedIndianUcf = "";

	////////////////	Table -  Indian UCF Matched/Not Matched Statistics in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-3" style="flex:1;">
	<table class="tableDesign">
		<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
			<th colspan="5" style="text-align: center;background-color:#e72a5c;border-color: #e72a5c;width:20%; text-align: center;">Arrival</th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
			<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: center;">Date</th>
			<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Matched&nbsp;&nbsp;</th>
			<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Not&nbsp;Matched&nbsp;&nbsp;</th>
			<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
		</tr>
		<%
	try {
		WeeklyUcf_Ind_Arr = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_INDIAN) as SUM_UCF_EXISTS_INDIAN,SUM(UCF_NOT_EXISTS_INDIAN) as SUM_UCF_NOT_EXISTS_INDIAN from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyUcf_Ind_Arr);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			WeeklyUcf_Ind_Arr_Axis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weeklyMatchedIndArr = rsTemp.getInt("SUM_UCF_EXISTS_INDIAN");
			weeklyNotMatchedIndArr = rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN");

			/*if(rsTemp.getInt("sum_hourly_others_count") == 0)
				weeklyOthersCount_Arrg = rsTemp.getInt("sum_hourly_others_count");
			else
				weeklyOthersCount_Arrg = rsTemp.getInt("sum_hourly_others_count") + (( weeklyMatchedIndArr + weeklyNotMatchedIndArr )/100);
				*/


			weekIndianUcf.append("\"");
			weekIndianUcf.append(WeeklyUcf_Ind_Arr_Axis);
			weekIndianUcf.append("\"");
			weekIndianUcf.append(",");
			
			weekMatchedIndianUcf.append(weeklyMatchedIndArr + ",");
			weekNotMatchedIndianUcf.append(weeklyNotMatchedIndArr + ",");


			Matched_Ucf_Ind_Arr = weeklyMatchedIndArr * 100;
			Not_Matched_Ucf_Ind_Arr = weeklyNotMatchedIndArr * 100;
			Total_Ucf_Ind_Arr = weeklyMatchedIndArr + weeklyNotMatchedIndArr;

			matched_count_Ind_Arr = (double) Matched_Ucf_Ind_Arr / Total_Ucf_Ind_Arr;
			notmatched_count_Ind_Arr = (double) Not_Matched_Ucf_Ind_Arr / Total_Ucf_Ind_Arr;

			B_matched_Ucf_Ind_Arr.append( Math.round(matched_count_Ind_Arr)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));
			B_not_matched_Ucf_Ind_Arr.append( Math.round(notmatched_count_Ind_Arr) + ",");


			%>

			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center;"><%=WeeklyUcf_Ind_Arr_Axis.replace("-","&#8209;")%></td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_EXISTS_INDIAN") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_INDIAN"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;font-size:15px; color:#e72a5c;"><%=rsTemp.getInt("SUM_UCF_EXISTS_INDIAN") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN")  == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_INDIAN") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN"))%>&nbsp;</td>
			</tr>
			<%
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println(e);
	}
	%>		</table>
		</div>
<%

	strweekIndianUcf = weekIndianUcf.toString();
	strweekIndianUcf = strweekIndianUcf.substring(0,strweekIndianUcf.length()-1);
	//out.println(strweekIndianUcf + "<br>");

	strweekMatchedIndianUcf = B_matched_Ucf_Ind_Arr.toString();
	strweekMatchedIndianUcf = strweekMatchedIndianUcf.substring(0,strweekMatchedIndianUcf.length()-1);
	//out.println(strweekMatchedIndianUcf + "<br>");

	strweekNotMatchedIndianUcf = B_not_matched_Ucf_Ind_Arr.toString();
	strweekNotMatchedIndianUcf = strweekNotMatchedIndianUcf.substring(0,strweekNotMatchedIndianUcf.length()-1);
	//out.println(strweekNotMatchedIndianUcf + "<br>");

	//out.println(strWeekOthers_Arrg);

	//String additionRequired

	 othersDatag = strweekNotMatchedIndianUcf.replaceAll(",0",",");
	if(othersDatag.substring(0,1).equals("0"))
		othersDatag = othersDatag.substring(1,othersDatag.length());
	//out.println(othersDatag);



///////////////////////	Table - Indian UCF Matched/Not Matched Statistics in last 7 days - End	////////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #c51748; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
<canvas id="canvasUcf_Ind_Arr" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #faceda 100%);border-radius: 20px; height:400px;"></canvas>
</div>
</div>	
</div>
<script>
		// Data define for bar chart

		var myDataw = {
			labels: [<%=strweekIndianUcf%>],
			datasets: [{ 
				  label: "Matched",
			      backgroundColor: "#e72a5c",
			      borderColor: "#e72a5c",
			      borderWidth: 1,
			     
			      data: [<%=strweekMatchedIndianUcf%>]
			},{ 
				  label: "Not Matched",
			      backgroundColor: "#0273c4",
			      borderColor: "#0273c4",
			      borderWidth: 1,
			     
			      data: [<%=strweekNotMatchedIndianUcf%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptionsw = {
			   responsive: true,
				   maintainAspectRatio: false,
				
			scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

			},
		 title: {
				display: true,
					text:'Arrival : Indian UCF Matched/Not Matched Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							if(i!= 1)
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+5 );
							else
							ctx.fillText("", bar._model.x-30, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasUcf_Ind_Arr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDataw,    	// Chart data
			options: myoptionsw	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%///////////////////	Arrival : UCF in last 7 days - End	///////////////////%>
		<%//////////////////////////////////////////////	Indian UCF Matched/Not Matched Statistics in last 7 days - Start	////////////////////////////////////////////////////


	String WeeklyUcf_Ind_Dep = "";
	String WeeklyUcf_Ind_Dep_Axis = "";
	int weeklyMatchedIndDep = 0;
	int weeklyNotMatchedIndDep = 0;
	

	StringBuilder weekIndianUcf_Dep = new StringBuilder();
	StringBuilder weekMatchedIndianUcf_Dep = new StringBuilder();
	StringBuilder weekNotMatchedIndianUcf_Dep = new StringBuilder();

	double matched_count_Ind_Dep = 0;
	double notmatched_count_Ind_Dep = 0;

	int Total_Ucf_Ind_Dep = 0;
	int Matched_Ucf_Ind_Dep = 0;
	int Not_Matched_Ucf_Ind_Arr_Dep = 0;

	StringBuilder B_matched_Ucf_Ind_Dep = new StringBuilder();
	StringBuilder B_not_matched_Ucf_Ind_Dep = new StringBuilder();

	String strweekIndianUcf_Dep = "";

	String strweekMatchedIndianUcf_Dep = "";
	String strweekNotMatchedIndianUcf_Dep = "";

	////////////////	Table -  Indian UCF Matched/Not Matched Statistics in last 7 days - Start	///////////////////////%>
<div class="col-sm-3" style="flex:1;">
<table class="tableDesign">
	<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
		<th colspan="5" style="text-align: center;background-color:#0273c4;border-color: #0273c4;width:20%; text-align: center;">Departure</th>
	</tr>
	<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: center;">Date</th>
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Matched&nbsp;&nbsp;</th>
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Not&nbsp;Matched&nbsp;&nbsp;</th>
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
	</tr>
			<%
	try {
		WeeklyUcf_Ind_Arr = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_INDIAN) as SUM_UCF_EXISTS_INDIAN,SUM(UCF_NOT_EXISTS_INDIAN) as SUM_UCF_NOT_EXISTS_INDIAN from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyUcf_Ind_Arr);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			WeeklyUcf_Ind_Arr_Axis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weeklyMatchedIndArr = rsTemp.getInt("SUM_UCF_EXISTS_INDIAN");
			weeklyNotMatchedIndArr = rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN");

			/*if(rsTemp.getInt("sum_hourly_others_count") == 0)
				weeklyOthersCount_Arrg = rsTemp.getInt("sum_hourly_others_count");
			else
				weeklyOthersCount_Arrg = rsTemp.getInt("sum_hourly_others_count") + (( weeklyMatchedIndArr + weeklyNotMatchedIndArr )/100);
				*/


			weekIndianUcf_Dep.append("\"");
			weekIndianUcf_Dep.append(WeeklyUcf_Ind_Arr_Axis);
			weekIndianUcf_Dep.append("\"");
			weekIndianUcf_Dep.append(",");
			
			weekMatchedIndianUcf_Dep.append(weeklyMatchedIndArr + ",");
			weekNotMatchedIndianUcf_Dep.append(weeklyNotMatchedIndArr + ",");


			Matched_Ucf_Ind_Dep = weeklyMatchedIndArr * 100;
			Not_Matched_Ucf_Ind_Arr = weeklyNotMatchedIndArr * 100;
			Total_Ucf_Ind_Dep = weeklyMatchedIndArr + weeklyNotMatchedIndArr;

			matched_count_Ind_Dep = (double) Matched_Ucf_Ind_Dep / Total_Ucf_Ind_Dep;
			notmatched_count_Ind_Dep = (double) Not_Matched_Ucf_Ind_Arr / Total_Ucf_Ind_Dep;

			B_matched_Ucf_Ind_Dep.append( Math.round(matched_count_Ind_Dep)  + ",");
			//out.println("<BR>indian_Precent : " + Math.round(indian_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));
			B_not_matched_Ucf_Ind_Dep.append( Math.round(notmatched_count_Ind_Dep) + ",");
			%>

			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold;text-align: center;"><%=WeeklyUcf_Ind_Arr_Axis.replace("-","&#8209;")%></td>
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_EXISTS_INDIAN") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_INDIAN"))%>&nbsp;</td>
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN"))%>&nbsp;</td>
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold; text-align: right;font-size:15px; color:#0283df;"><%=rsTemp.getInt("SUM_UCF_EXISTS_INDIAN") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN")  == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_INDIAN") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN"))%>&nbsp;</td>
			</tr>
			<%
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println(e);
	}
	%>		</table>
		</div>
<%

	strweekIndianUcf_Dep = weekIndianUcf_Dep.toString();
	strweekIndianUcf_Dep = strweekIndianUcf_Dep.substring(0,strweekIndianUcf_Dep.length()-1);
	//out.println(strweekIndianUcf_Dep + "<br>");

	strweekMatchedIndianUcf_Dep = B_matched_Ucf_Ind_Dep.toString();
	strweekMatchedIndianUcf_Dep = strweekMatchedIndianUcf_Dep.substring(0,strweekMatchedIndianUcf_Dep.length()-1);
	//out.println(strweekMatchedIndianUcf_Dep + "<br>");

	strweekNotMatchedIndianUcf_Dep = B_not_matched_Ucf_Ind_Dep.toString();
	strweekNotMatchedIndianUcf_Dep = strweekNotMatchedIndianUcf_Dep.substring(0,strweekNotMatchedIndianUcf_Dep.length()-1);
	//out.println(strweekNotMatchedIndianUcf_Dep + "<br>");

	//out.println(strWeekOthers_Arrg);

	//String additionRequired

	 othersDatag = strweekNotMatchedIndianUcf_Dep.replaceAll(",0",",");
	if(othersDatag.substring(0,1).equals("0"))
		othersDatag = othersDatag.substring(1,othersDatag.length());
	//out.println(othersDatag);



///////////////////////	Table - Indian UCF Matched/Not Matched Statistics in last 7 days - End	////////////////////////%>


<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #014F86; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
<canvas id="canvasUcf_Ind_Dep" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #bae6ff 100%);border-radius: 20px; height:400px;"></canvas>
</div>
</div>	
</div>
</div>
</div>

	<script>
		// Data define for bar chart

		var myDataw = {
			labels: [<%=strweekIndianUcf_Dep%>],
			datasets: [{ 
				  label: "Matched",
			      backgroundColor: "#0273c4",
			      borderColor: "#0273c4",
			      borderWidth: 1,
			     
			      data: [<%=strweekMatchedIndianUcf_Dep%>]
			},{ 
				  label: "Not Matched",
			      backgroundColor: "#e72a5c",
			      borderColor: "#e72a5c",
			      borderWidth: 1,
			     
			      data: [<%=strweekNotMatchedIndianUcf_Dep%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptionsw = {
			   responsive: true,
				   maintainAspectRatio: false,
				
			scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

			},
		 title: {
				display: true,
					text:'Departure : Indian UCF Matched/Not Matched Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							if(i!= 1)
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+5 );
							else
							ctx.fillText("", bar._model.x-30, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasUcf_Ind_Dep').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDataw,    	// Chart data
			options: myoptionsw	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%//////////////////////////////////////	Types of Indain UCF in last 7 days - End	/////////////////////////////////%>


<%/////////////////////////////////////////////////////////////////%>
<section id="ucf_Foreigner"><br><br><br><br><br><br><br>
<div class="pt-4" id="ucf_Foreigner">    
<table id = "auto-index5" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Foreigner UCF Matched/Not Matched Statistics in last 7 days</th>
	</tr>
	</thead>
</table>
</section>
<%//////////////////////////////////////////////	Types of Foreigner UCF in last 7 days - Start	////////////////////////////////////////////////////



	String WeeklyUcf_Fgnr_Arr = "";
	String WeeklyUcf_Fgnr_Arr_Axis = "";
	int weeklyMatchedFgnrArr = 0;
	int weeklyNotMatchedFgnrArr = 0;
	

	StringBuilder weekFgnrUcf = new StringBuilder();
	StringBuilder weekMatchedFgnrUcf = new StringBuilder();
	StringBuilder weekNotMatchedFgnrUcf = new StringBuilder();

	double matched_count_Fgnr_Arr = 0;
	double notmatched_count_Fgnr_Arr = 0;

	int Total_Ucf_Fgnr_Arr = 0;
	int Matched_Ucf_Fgnr_Arr = 0;
	int Not_Matched_Ucf_Fgnr_Arr = 0;

	StringBuilder B_matched_Ucf_Fgnr_Arr = new StringBuilder();
	StringBuilder B_not_matched_Ucf_Fgnr_Arr = new StringBuilder();

	String strweekFgnrUcf = "";

	String strweekMatchedFgnrUcf = "";
	String strweekNotMatchedFgnrUcf = "";

	////////////////	Table -  Indian UCF Matched/Not Matched Statistics in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-3" style="flex:1;">
		<table class="tableDesign">
			<tr style="font-size: 17px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th colspan="5" style="text-align: center;background-color:#e72a5c;border-color: #e72a5c;width:20%; text-align: center;">Arrival</th>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Matched&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Not&nbsp;Matched&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
			</tr>
			<%
	try {
		WeeklyUcf_Fgnr_Arr = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_FOREIGNER) as SUM_UCF_EXISTS_FOREIGNER,SUM(UCF_NOT_EXISTS_FOREIGNER) as SUM_UCF_NOT_EXISTS_FOREIGNER from im_dashboard_combined where ICP_SRNO = '004' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyUcf_Fgnr_Arr);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			WeeklyUcf_Fgnr_Arr_Axis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weeklyMatchedFgnrArr = rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER");
			weeklyNotMatchedFgnrArr = rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER");

			weekFgnrUcf.append("\"");
			weekFgnrUcf.append(WeeklyUcf_Fgnr_Arr_Axis);
			weekFgnrUcf.append("\"");
			weekFgnrUcf.append(",");
			
			weekMatchedFgnrUcf.append(weeklyMatchedFgnrArr + ",");
			weekNotMatchedFgnrUcf.append(weeklyNotMatchedFgnrArr + ",");


			Matched_Ucf_Fgnr_Arr = weeklyMatchedFgnrArr * 100;
			Not_Matched_Ucf_Fgnr_Arr = weeklyNotMatchedFgnrArr * 100;
			Total_Ucf_Fgnr_Arr = weeklyMatchedFgnrArr + weeklyNotMatchedFgnrArr;

			matched_count_Fgnr_Arr = (double) Matched_Ucf_Fgnr_Arr / Total_Ucf_Fgnr_Arr;
			notmatched_count_Fgnr_Arr = (double) Not_Matched_Ucf_Fgnr_Arr / Total_Ucf_Fgnr_Arr;

			B_matched_Ucf_Fgnr_Arr.append( Math.round(matched_count_Fgnr_Arr)  + ",");
			//out.println("<BR>Fgnr_Precent : " + Math.round(Fgnr_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));
			B_not_matched_Ucf_Fgnr_Arr.append( Math.round(notmatched_count_Fgnr_Arr) + ",");
			%>

			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center;"><%=WeeklyUcf_Fgnr_Arr_Axis.replace("-","&#8209;")%></td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER"))%>&nbsp;</td>
				<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;font-size:15px; color:#e72a5c;"><%=rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER")  == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER"))%>&nbsp;</td>
			</tr>
			<%
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println(e);
	}
	%>		</table>
		</div>
<%

	strweekFgnrUcf = weekFgnrUcf.toString();
	strweekFgnrUcf = strweekFgnrUcf.substring(0,strweekFgnrUcf.length()-1);
	//out.println(strweekFgnrUcf + "<br>");

	strweekMatchedFgnrUcf = B_matched_Ucf_Fgnr_Arr.toString();
	strweekMatchedFgnrUcf = strweekMatchedFgnrUcf.substring(0,strweekMatchedFgnrUcf.length()-1);
	//out.println(strweekMatchedFgnrUcf + "<br>");

	strweekNotMatchedFgnrUcf = B_not_matched_Ucf_Fgnr_Arr.toString();
	strweekNotMatchedFgnrUcf = strweekNotMatchedFgnrUcf.substring(0,strweekNotMatchedFgnrUcf.length()-1);
	//out.println(strweekNotMatchedFgnrUcf + "<br>");

///////////////////////	Table - Fgnr UCF Matched/Not Matched Statistics in last 7 days - End	////////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #c51748; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
<canvas id="canvasUcf_Fgnr_Arr" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #faceda 100%);border-radius: 20px; height:400px;"></canvas>
</div>
</div>	
</div>
<script>
		// Data define for bar chart

		var myDataw = {
			labels: [<%=strweekFgnrUcf%>],
			datasets: [{ 
				  label: "Matched",
			      backgroundColor: "#e72a5c",
			      borderColor: "#e72a5c",
			      borderWidth: 1,
			     
			      data: [<%=strweekMatchedFgnrUcf%>]
			},{ 
				  label: "Not Matched",
			      backgroundColor: "#0273c4",
			      borderColor: "#0273c4",
			      borderWidth: 1,
			     
			      data: [<%=strweekNotMatchedFgnrUcf%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptionsw = {
			   responsive: true,
				   maintainAspectRatio: false,
				
			scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

			},
		 title: {
				display: true,
					text:'Arrival : Foreigner UCF Matched/Not Matched Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							if(i!= 1)
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+6 );
							else
							ctx.fillText(data + "%", bar._model.x-20, bar._model.y+6 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasUcf_Fgnr_Arr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDataw,    	// Chart data
			options: myoptionsw	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>




<%//////////////////////////////////////////////	Departure : Foreigner UCF Matched/Not Matched Statistics in last 7 days - Start	////////////////////////////////////////////////////



	String WeeklyUcf_Fgnr_Dep = "";
	String WeeklyUcf_Fgnr_Dep_Axis = "";
	int weeklyMatchedFgnrDep = 0;
	int weeklyNotMatchedFgnrDep = 0;
	

	StringBuilder weekFgnrUcf_Dep = new StringBuilder();
	StringBuilder weekMatchedFgnrUcf_Dep = new StringBuilder();
	StringBuilder weekNotMatchedFgnrUcf_Dep = new StringBuilder();

	double matched_count_Fgnr_Dep = 0;
	double notmatched_count_Fgnr_Dep = 0;

	int Total_Ucf_Fgnr_Dep = 0;
	int Matched_Ucf_Fgnr_Dep = 0;
	int Not_Matched_Ucf_Fgnr_Dep = 0;

	StringBuilder B_matched_Ucf_Fgnr_Dep = new StringBuilder();
	StringBuilder B_not_matched_Ucf_Fgnr_Dep = new StringBuilder();

	String strweekFgnrUcf_Dep = "";

	String strweekMatchedFgnrUcf_Dep = "";
	String strweekNotMatchedFgnrUcf_Dep = "";

	////////////////	Table -  Departure : Foreigner UCF Matched/Not Matched Statistics in last 7 days - Start	///////////////////////%>
<div class="col-sm-3" style="flex:1;">
<table class="tableDesign">
	<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
		<th colspan="5" style="text-align: center;background-color:#0273c4;border-color: #0273c4;width:20%; text-align: center;">Departure</th>
	</tr>
	<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: center;">Date</th>
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Matched&nbsp;&nbsp;</th>
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Not&nbsp;Matched&nbsp;&nbsp;</th>
		<th style="text-align: center;background-color:#0283df;border-color: #014F86;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
	</tr>
			<%
	try {
		WeeklyUcf_Fgnr_Dep = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_FOREIGNER) as SUM_UCF_EXISTS_FOREIGNER_DEP, SUM(UCF_NOT_EXISTS_FOREIGNER) as SUM_UCF_NOT_EXISTS_FOREIGNER_DEP from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyUcf_Fgnr_Dep);
		rsTemp = psTemp.executeQuery();
		//out.println(WeeklyUcf_Fgnr_Dep);

		while (rsTemp.next()) {

			WeeklyUcf_Fgnr_Dep_Axis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weeklyMatchedFgnrDep = rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER_DEP");
			//out.println(weeklyMatchedFgnrDep);

			weeklyNotMatchedFgnrDep = rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER_DEP");
			//out.println(weeklyNotMatchedFgnrDep);

			weekFgnrUcf_Dep.append("\"");
			weekFgnrUcf_Dep.append(WeeklyUcf_Fgnr_Dep_Axis);
			weekFgnrUcf_Dep.append("\"");
			weekFgnrUcf_Dep.append(",");
			
			weekMatchedFgnrUcf_Dep.append(weeklyMatchedFgnrDep + ",");
			weekNotMatchedFgnrUcf_Dep.append(weeklyNotMatchedFgnrDep + ",");


			Matched_Ucf_Fgnr_Dep = weeklyMatchedFgnrDep * 100;
			Not_Matched_Ucf_Fgnr_Dep = weeklyNotMatchedFgnrDep * 100;
			Total_Ucf_Fgnr_Dep = weeklyMatchedFgnrDep + weeklyNotMatchedFgnrDep;

			matched_count_Fgnr_Dep = (double) Matched_Ucf_Fgnr_Dep / Total_Ucf_Fgnr_Dep;
			notmatched_count_Fgnr_Dep = (double) Not_Matched_Ucf_Fgnr_Dep / Total_Ucf_Fgnr_Dep;

			B_matched_Ucf_Fgnr_Dep.append( Math.round(matched_count_Fgnr_Dep)  + ",");
			//out.println("<BR>Fgnr_Precent : " + Math.round(Fgnr_Precent) + "  --  foreign_Precent: " + Math.round(foreign_Precent));
			B_not_matched_Ucf_Fgnr_Dep.append( Math.round(notmatched_count_Fgnr_Dep) + ",");
%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold;text-align: center;"><%=WeeklyUcf_Fgnr_Dep_Axis.replace("-","&#8209;")%></td>
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER_DEP") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER_DEP"))%>&nbsp;</td>
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold; text-align: right;"><%=rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER_DEP") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER_DEP"))%>&nbsp;</td>
				<td style="background-color:#f3faff;border-color:#014F86; font-weight: bold; text-align: right;font-size:15px; color:#0273c4;"><%=rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER_DEP") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER_DEP")  == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("SUM_UCF_EXISTS_FOREIGNER_DEP") + rsTemp.getInt("SUM_UCF_NOT_EXISTS_FOREIGNER_DEP"))%>&nbsp;</td>
			</tr>
			<%
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println(e);
	}
	%>		</table>
		</div>
<%

	strweekFgnrUcf_Dep = weekFgnrUcf_Dep.toString();
	strweekFgnrUcf_Dep = strweekFgnrUcf_Dep.substring(0,strweekFgnrUcf_Dep.length()-1);
	//out.println(strweekFgnrUcf_Dep + "<br>");

	strweekMatchedFgnrUcf_Dep = B_matched_Ucf_Fgnr_Dep.toString();
	strweekMatchedFgnrUcf_Dep = strweekMatchedFgnrUcf_Dep.substring(0,strweekMatchedFgnrUcf_Dep.length()-1);
	//out.println(strweekMatchedFgnrUcf_Dep + "<br>");

	strweekNotMatchedFgnrUcf_Dep = B_not_matched_Ucf_Fgnr_Dep.toString();
	strweekNotMatchedFgnrUcf_Dep = strweekNotMatchedFgnrUcf_Dep.substring(0,strweekNotMatchedFgnrUcf_Dep.length()-1);
	//out.println(strweekNotMatchedFgnrUcf_Dep + "<br>");
///////////////////////	Table - Departure : Foreigner UCF Matched/Not Matched Statistics in last 7 days - End	////////////////////////%>
<div class="col-sm-3" style="flex:2;">
<div class="card" style="border: solid 3px #014F86; border-radius: 20px; height:400px;">
<div class="card-body" style=" height:400px;">
<canvas id="canvasUcf_Fgnr_Dep" class="chart" style="max-width: 100%; background: linear-gradient(to bottom, #ffffff 35%, #bae6ff 100%);border-radius: 20px; height:400px;"></canvas>
	</div>
	</div>	
	</div>
	</div>
	</div>

	<script>
		// Data define for bar chart

		var myDatawd = {
			labels: [<%=strweekFgnrUcf_Dep%>],
			datasets: [{ 
				  label: "Matched",
			      backgroundColor: "#0273c4",
			      borderColor: "#0273c4",
			      borderWidth: 1,
			     
			      data: [<%=strweekMatchedFgnrUcf_Dep%>]
			},{ 
				  label: "Not Matched",
			      backgroundColor: "#e72a5c",
			      borderColor: "#e72a5c",
			      borderWidth: 1,
			     
			      data: [<%=strweekNotMatchedFgnrUcf_Dep%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptionswd = {
			   responsive: true,
				   maintainAspectRatio: false,
				
			scales: {
				yAxes: [{
				ticks: { beginAtZero: true },
				stacked: true,
					gridLines:{
					color:"grey",
				}
				}],
				xAxes: [{
				stacked: true,display: false
				}],

			},
		 title: {
				display: true,
					text:'Departure : Foreigner UCF Matched/Not Matched Statistics in last 7 days',
				fontSize: 15,		
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
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							if(i!= 1)
							ctx.fillText(data + "%", bar._model.x-30, bar._model.y+6 );
							else
							ctx.fillText(data + "%", bar._model.x-20, bar._model.y+6 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasUcf_Fgnr_Dep').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDatawd,    	// Chart data
			options: myoptionswd	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>


<%//////////////////////////////////////	Departure : Foreigner UCF Matched/Not Matched Statistics in last 7 days - End	/////////////////////////////////%>

<%/////////////////////////////////////////////////////////////////%>

</div>
		</section>

		<section id="ICS_Flight_Running_Status" ><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Flight_Running_Status">
		<table id = "auto-index2" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Currently Running Flight Status in last 30 minutes</th>
				</tr>
			</thead>
		</table><br>
	<%////////////////////	Arr - Currently Running Flight Status - Start	////////////////////////
String srNo = "";
String paxBoardingDate = "";
String paxBoardingTime = "";
String flightNo = "";
String flightDescription = "";
String firstPaxCheckTime = "";
String latestPaxCheckTime = "";
String totalPaxChecked = "";

			////////////////	Table - Arrival Clearance in last 7 hours - Start	//////////////////////


// flagPaxCount = false;
try {
	arrHourlyQuery = "select ICP_SRNO, ICP_DESCRIPTION, TABLE_TYPE, to_char(PAX_BOARDING_DATE, 'dd/mm/yyyy') || ' ' || substr(PAX_BOARDING_TIME,0,2) || ':' ||  substr(PAX_BOARDING_TIME,3,2) as PAX_BOARDING_DATE, FLIGHT_NO, FIRST_PAX_CHECK_TIME, LATEST_PAX_CHECK_TIME, TOTAL_PAX_CHECK, FLIGHT_DESC from IM_CURRENT_RUNNING_FLIGHT_STATUS where icp_srno = '"+ filter_icp +"' and table_type = 'IM_TRANS_ARR_TOTAL' order by  LATEST_PAX_CHECK_TIME DESC";
	psTemp = con.prepareStatement(arrHourlyQuery);
	rsTemp = psTemp.executeQuery();
%>
	<div class="container-fluid">
	<div class="row">
	<div class="col-sm-6">
	<table class="tableDesign">
		<tr style="font-size: 20px;  text-align: right; color:white; border-color: #003a6d;">
			<th colspan="6" style="text-align: center; width:25%; background-color:#028fff;border-color: #028fff;width:12.5%; text-align: center;">Arrival : Currently Running Flight Status</th>
		</tr>
	</table>

<div class="fixTableHead">
	<table class="tableDesign">
<thead>
		<tr style="font-size: 15px;  text-align: right; color:white; border-color: #028fff;">
			<th style="text-align: center; background-color:#25a5ff;border-color: #028fff;width:12.5%;border-top-left-radius: 0px;">S.No.</th>
			<th style="text-align: center;  background-color:#25a5ff;border-color: #028fff;width:12.5%; text-align: center;">Scheduled&nbsp;Date</th>
			<th style="text-align: center;  background-color:#25a5ff;border-color: #028fff;width:12.5%; text-align: left;">Flight&nbsp;No.</th>
			<!--<th style="text-align: center; width:25%; background-color:#B93160;border-color: #e497b2;width:12.5%; text-align: right;">Flight&nbsp;Description&nbsp;&nbsp;&nbsp;</th>-->
			<th style="text-align: center;  background-color:#25a5ff;border-color: #028fff;width:12.5%; text-align: center;">First&nbsp;PAX&nbsp;Check&nbsp;Time</th>
			<th style="text-align: center;  background-color:#25a5ff;border-color: #028fff;width:12.5%; text-align: center;">Latest&nbsp;PAX&nbsp;Check&nbsp;Time</th>
			<th style="text-align: center;  background-color:#25a5ff;border-color: #028fff;width:12.5%; text-align: right;border-top-right-radius: 0px;">PAX&nbsp;Checked&nbsp;&nbsp;</th>
		</tr>
</thead>
		<% 
					int counter = 0;

	while (rsTemp.next()) {	
		//srNo = rsTemp.getString("ICP_SRNO");
		paxBoardingDate = rsTemp.getString("PAX_BOARDING_DATE");
		flightNo = rsTemp.getString("FLIGHT_NO");
		flightDescription = rsTemp.getString("FLIGHT_DESC");
		firstPaxCheckTime = rsTemp.getString("FIRST_PAX_CHECK_TIME");
		latestPaxCheckTime = rsTemp.getString("LATEST_PAX_CHECK_TIME");
		totalPaxChecked = rsTemp.getString("TOTAL_PAX_CHECK");
		//out.println(hourlyArrActiveCounter);
		%>
		<tr style="font-size: 12px; font-family: 'Arial', serif; height:20px;">
			<td style="background-color:#74caff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=++counter%></td>
			<td style="background-color:#8dd3ff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=paxBoardingDate.replace(" ","&nbsp;")%></td>
			<td style="background-color:#a0daff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: left;"><%=flightNo%></td>
			<!--<td style="background-color:#f4d7e1; width:25%; border-color: #B93160;width:12.5%; font-weight: bold; text-align: center;"><%=flightDescription%>&nbsp;&nbsp;&nbsp;</td>-->
			<td style="background-color:#bae6ff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=firstPaxCheckTime%></td>
			<td style="background-color:#d3eeff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=latestPaxCheckTime%></td>
			<td style="background-color:#e5f6ff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: right; font-size:16px;"><%=getIndianFormat(Integer.parseInt(totalPaxChecked))%>&nbsp;&nbsp;</td>
		</tr>
<%
	}
	rsTemp.close();
	psTemp.close();
	if(counter == 0)
		{
			%>
		<tr style="font-size: 25px; font-family: 'Arial', serif; height:20px;background-color:white;">
			<td colspan="6" style="background-color:#f6f2ff; border-color: #004144; font-weight: bold; text-align: center; align:center;color:red;"><br><br>!!! No Records Found !!!<br><br><br></td>
		</tr>
		
		<%
		}
		%>
	</table>
		</div>
		</div>

		<%

} catch (Exception e) {
	out.println("Currently Running Flight Status");
}

%>
<%/////////////////		Arr - Currently Running Flight Status - End		///////////////////%>



	<%////////////////////	Dep - Currently Running Flight Status - Start	////////////////////////
String paxBoardingDate_Dep = "";
String paxBoardingTime_Dep = "";
String flightNo_Dep = "";
String flightDescription_Dep = "";
String firstPaxCheckTime_Dep = "";
String latestPaxCheckTime_Dep = "";
String totalPaxChecked_Dep = "";

			////////////////	Table - Arrival Clearance in last 7 hours - Start	//////////////////////

try {
	arrHourlyQuery = "select ICP_SRNO, ICP_DESCRIPTION, TABLE_TYPE, to_char(PAX_BOARDING_DATE, 'dd/mm/yyyy') || ' ' || substr(PAX_BOARDING_TIME,0,2) || ':' ||  substr(PAX_BOARDING_TIME,3,2) as PAX_BOARDING_DATE, FLIGHT_NO, FIRST_PAX_CHECK_TIME, LATEST_PAX_CHECK_TIME, TOTAL_PAX_CHECK, FLIGHT_DESC from IM_CURRENT_RUNNING_FLIGHT_STATUS where icp_srno = '"+ filter_icp +"' and table_type = 'IM_TRANS_DEP_TOTAL' order by  LATEST_PAX_CHECK_TIME DESC";
	psTemp = con.prepareStatement(arrHourlyQuery);
	rsTemp = psTemp.executeQuery();
%>
	<div class="col-sm-6">
	<table class="tableDesign">
				<tr style="font-size: 20px;  text-align: right; color:white; border-color: #003a6d;">
					<th colspan="6" style="text-align: center; width:25%; background-color:#007a8d;border-color: #007d79;width:12.5%; text-align: center;">Departure : Currently Running Flight Status</th>
				</tr>
	</table>

<div class="fixTableHead">
	<table class="tableDesign">
				<thead>
				<tr style="font-size: 15px;  text-align: right; color:white; border-color: #007d79;">					
					<th style="text-align: center;  background-color:#0094ab;border-color: #007d79; text-align: center;border-top-left-radius: 0px;">S.No.</th>
					<th style="text-align: center;  background-color:#0094ab;border-color: #007d79; text-align: center;">Scheduled&nbsp;Date</th>
					<th style="text-align: center;  background-color:#0094ab;border-color: #007d79; text-align: left;">Flight&nbsp;No.</th>
					<!--<th style="text-align: center;  background-color:#B93160;border-color: #e497b2;width:12.5%; text-align: right;">Flight&nbsp;Description&nbsp;&nbsp;&nbsp;</th>-->
					<th style="text-align: center;  background-color:#0094ab;border-color: #007d79;text-align: center;">First&nbsp;PAX&nbsp;Check&nbsp;Time</th>
					<th style="text-align: center;  background-color:#0094ab;border-color: #007d79; text-align: center;">Latest&nbsp;PAX&nbsp;Check&nbsp;Time</th>
					<th style="text-align: center;  background-color:#0094ab;border-color: #007d79; text-align: right;border-top-right-radius: 0px;">PAX&nbsp;Checked&nbsp;&nbsp;</th>
				</tr>
				</thead>
		<% 
					int counter = 0;

	while (rsTemp.next()) {	
		//srNo = rsTemp.getString("ICP_SRNO");
		paxBoardingDate_Dep = rsTemp.getString("PAX_BOARDING_DATE");
		flightNo_Dep = rsTemp.getString("FLIGHT_NO");
		flightDescription_Dep = rsTemp.getString("FLIGHT_DESC");
		firstPaxCheckTime_Dep = rsTemp.getString("FIRST_PAX_CHECK_TIME");
		latestPaxCheckTime_Dep = rsTemp.getString("LATEST_PAX_CHECK_TIME");
		totalPaxChecked_Dep = rsTemp.getString("TOTAL_PAX_CHECK");
		//out.println(hourlyArrActiveCounter);
		%>
		<tr style="font-size: 12px; font-family: 'Arial', serif; height:20px;">
			<td style="background-color:#3ddbd9;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=++counter%></td>
			<td style="background-color:#69e3e2;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=paxBoardingDate_Dep.replace(" ","&nbsp;")%></td>
			<td style="background-color:#84e8e7;  border-color: #005d5d; font-weight: bold; text-align: left;"><%=flightNo_Dep%></td>
			<!--<td style="background-color:#f4d7e1;  border-color: #B93160; font-weight: bold; text-align: center;"><%=flightDescription_Dep%>&nbsp;&nbsp;&nbsp;</td>-->
			<td style="background-color:#9ef0f0;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=firstPaxCheckTime_Dep%></td>
			<td style="background-color:#b8f4f4;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=latestPaxCheckTime_Dep%></td>
			<td style="background-color:#d9fbfb;  border-color: #005d5d; font-weight: bold; text-align: right;font-size:16px;"><%=getIndianFormat(Integer.parseInt(totalPaxChecked_Dep))%>&nbsp;&nbsp;</td>
		</tr>
<%
	}
	rsTemp.close();
	psTemp.close();
	
		if(counter == 0)
		{
			%>
		<tr style="font-size: 25px; font-family: 'Arial', serif; height:20px;background-color:white;">
			<td colspan="6" style="background-color:#f6f2ff; border-color: #004144; font-weight: bold; text-align: center; align:center;color:red;"><br><br>!!! No Records Found !!!<br><br><br></td>
		</tr>
		
		<%
		}
		%>
		</table>
		</div>
		</div>
		</div>
		</div>
		<%

} catch (Exception e) {
	out.println("Currently Running Flight Status");
}

%>
</div>
</section>

<section id="ICS_Agewise" ><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_Agewise">
<table id = "auto-index2" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Age-wise Statistics in last 7 days</th>
		</tr>
	</thead>
</table><br>
</section>
<%//////////////////////	Agewise Statistics in last 7 days - Start	/////////////////////////////////

	String WeeklyArrAgewise = "";
	String WeeklyArrAgewiseXAxis = "";
	int M0_M6_Arr = 0;
	int M6_Y1_Arr = 0;
	int Y1_Y5_Arr = 0;
	int Y5_Y10_Arr = 0;
	int Y10_Y20_Arr = 0;
	int Y20_Y30_Arr = 0;
	int Y30_Y40_Arr = 0;
	int Y40_Y50_Arr = 0;
	int Y50_Y60_Arr = 0;
	int Y60_Y70_Arr = 0;
	int Y70_Y80_Arr = 0;
	int Y80_Y90_Arr = 0;
	int Y90_Y100_Arr = 0;
	int Y100_Arr = 0;
	

	StringBuilder weekDaysAgewise = new StringBuilder();
	StringBuilder weekM0_M6_Arr = new StringBuilder();
	StringBuilder weekM6_Y1_Arr = new StringBuilder();
	StringBuilder weekY1_Y5_Arr = new StringBuilder();
	StringBuilder weekY5_Y10_Arr = new StringBuilder();
	StringBuilder weekY10_Y20_Arr = new StringBuilder();
	StringBuilder weekY20_Y30_Arr = new StringBuilder();
	StringBuilder weekY30_Y40_Arr = new StringBuilder();
	StringBuilder weekY40_Y50_Arr = new StringBuilder();
	StringBuilder weekY50_Y60_Arr = new StringBuilder();
	StringBuilder weekY60_Y70_Arr = new StringBuilder();
	StringBuilder weekY70_Y80_Arr = new StringBuilder();
	StringBuilder weekY80_Y90_Arr = new StringBuilder();
	StringBuilder weekY90_Y100_Arr = new StringBuilder();
	StringBuilder weekY100_Arr = new StringBuilder();

	 flagFlightCountb = false;
	try {
		WeeklyArrAgewise = "select SUM(M0_M6) as M0_M6, SUM(M6_Y1) as M6_Y1,SUM(Y1_Y5) as Y1_Y5,SUM(Y5_Y10) as Y5_Y10,SUM(Y10_Y20) as Y10_Y20,SUM(Y20_Y30) as Y20_Y30,SUM(Y30_Y40) as Y30_Y40,SUM(Y40_Y50) as Y40_Y50,SUM(Y50_Y60) as Y50_Y60,SUM(Y60_Y70) as Y60_Y70,SUM(Y70_Y80) as Y70_Y80,  SUM(Y80_Y90) as Y80_Y90,  SUM(Y90_Y100) as Y90_Y100,  SUM(Y100) as Y100, icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyArrAgewise);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			WeeklyArrAgewiseXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			M0_M6_Arr = rsTemp.getInt("M0_M6");
			M6_Y1_Arr = rsTemp.getInt("M6_Y1");
			Y1_Y5_Arr = rsTemp.getInt("Y1_Y5");
			Y5_Y10_Arr = rsTemp.getInt("Y5_Y10");
			Y10_Y20_Arr = rsTemp.getInt("Y10_Y20");
			Y20_Y30_Arr = rsTemp.getInt("Y20_Y30");
			Y30_Y40_Arr = rsTemp.getInt("Y30_Y40");
			Y40_Y50_Arr = rsTemp.getInt("Y40_Y50");
			Y50_Y60_Arr = rsTemp.getInt("Y50_Y60");
			Y60_Y70_Arr = rsTemp.getInt("Y60_Y70");
			Y70_Y80_Arr = rsTemp.getInt("Y70_Y80");
			Y80_Y90_Arr = rsTemp.getInt("Y80_Y90");
			Y90_Y100_Arr = rsTemp.getInt("Y90_Y100");
			Y100_Arr = rsTemp.getInt("Y100");
			//out.println(weeklyOCICount);

			if (flagFlightCountb == true) {
			  weekDaysAgewise.append(",");
			  weekM0_M6_Arr.append(",");
			  weekM6_Y1_Arr.append(",");
			  weekY1_Y5_Arr.append(",");
			  weekY5_Y10_Arr.append(",");
			  weekY10_Y20_Arr.append(",");
			  weekY20_Y30_Arr.append(",");
			  weekY30_Y40_Arr.append(",");
			  weekY40_Y50_Arr.append(",");
			  weekY50_Y60_Arr.append(",");
			  weekY60_Y70_Arr.append(",");
			  weekY70_Y80_Arr.append(",");
			  weekY80_Y90_Arr.append(",");
			  weekY90_Y100_Arr.append(",");
			  weekY100_Arr.append(",");

				} 
			else
				flagFlightCountb = true;

			weekDaysAgewise.append("\"");
			weekDaysAgewise.append(WeeklyArrAgewiseXAxis);
			weekDaysAgewise.append("\"");
			
			weekM0_M6_Arr.append(M0_M6_Arr);
			weekM6_Y1_Arr.append(M6_Y1_Arr);
			weekY1_Y5_Arr.append(Y1_Y5_Arr);
			  weekY5_Y10_Arr.append(Y5_Y10_Arr);
			  weekY10_Y20_Arr.append(Y10_Y20_Arr);
			  weekY20_Y30_Arr.append(Y20_Y30_Arr);
			  weekY30_Y40_Arr.append(Y30_Y40_Arr);
			  weekY40_Y50_Arr.append(Y40_Y50_Arr);
			  weekY50_Y60_Arr.append(Y50_Y60_Arr);
			  weekY60_Y70_Arr.append(Y60_Y70_Arr);
			  weekY70_Y80_Arr.append(Y70_Y80_Arr);
			  weekY80_Y90_Arr.append(Y80_Y90_Arr);
			  weekY90_Y100_Arr.append(Y90_Y100_Arr);
			  weekY100_Arr.append(Y100_Arr);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Gender Exception");
	}

	String strWeekDaysAgewise = weekDaysAgewise.toString();
	String strweekM0_M6_Arr = weekM0_M6_Arr.toString();
	String strweekM6_Y1_Arr = weekM6_Y1_Arr.toString();
	String strweekY1_Y5_Arr = weekY1_Y5_Arr.toString();
	String strweekY5_Y10_Arr = weekY5_Y10_Arr.toString();
	String  strweekY10_Y20_Arr = weekY10_Y20_Arr.toString();
	String  strweekY20_Y30_Arr = weekY20_Y30_Arr.toString();
	 String strweekY30_Y40_Arr = weekY30_Y40_Arr.toString();
	 String strweekY40_Y50_Arr = weekY40_Y50_Arr.toString();
	String  strweekY50_Y60_Arr = weekY50_Y60_Arr.toString();
	 String strweekY60_Y70_Arr = weekY60_Y70_Arr.toString();
	 String strweekY70_Y80_Arr = weekY70_Y80_Arr.toString();
	 String strweekY80_Y90_Arr = weekY80_Y90_Arr.toString();
	 String strweekY90_Y100_Arr = weekY90_Y100_Arr.toString();
	 String strweekY100_Arr = weekY100_Arr.toString();
	
	
	//out.println(strHourlyOCI);
	
	////////////////	Table -  Indian/Foreigner Count in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-12">

		<table class="tableDesign" height="100">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">Below&nbsp;06&nbsp;Months&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">06&nbsp;Months&nbsp;to&nbsp;01&nbsp;Yr&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">01&nbsp;to&nbsp;05&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">05&nbsp;to&nbsp;10&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">10&nbsp;to&nbsp;20&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">20&nbsp;to&nbsp;30&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">30&nbsp;to&nbsp;40&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">40&nbsp;to&nbsp;50&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">50&nbsp;to&nbsp;60&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">60&nbsp;to&nbsp;70&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">70&nbsp;to&nbsp;80&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">80&nbsp;to&nbsp;90&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">90&nbsp;to&nbsp;100&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">Above&nbsp;100&nbsp;Yrs&nbsp;&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDaysBio = weekDaysNationality.toString();
			String strWeekBioEnrolled = weekIndian.toString();
			String strWeekBioVerified = weekForeigner.toString();
			String strWeekBioExempted = weekOthers.toString();*/
			

			String[] weeklyDaysAgewise = strWeekDaysAgewise.toString().replace("\"", "").split(",");
			String[] weeklyM0_M6_Arr = strweekM0_M6_Arr.split(",");
			String[] weeklyM6_Y1_Arr = strweekM6_Y1_Arr.split(",");
			String[] weeklyY1_Y5_Arr = strweekY1_Y5_Arr.split(",");
			String[] weeklyY5_Y10_Arr = strweekY5_Y10_Arr.split(",");
			String[] weeklyY10_Y20_Arr = strweekY10_Y20_Arr.split(",");
			String[] weeklyY20_Y30_Arr = strweekY20_Y30_Arr.split(",");
			String[] weeklyY30_Y40_Arr = strweekY30_Y40_Arr.split(",");
			String[] weeklyY40_Y50_Arr = strweekY40_Y50_Arr.split(",");
			String[] weeklyY50_Y60_Arr = strweekY50_Y60_Arr.split(",");
			String[] weeklyY60_Y70_Arr = strweekY60_Y70_Arr.split(",");
			String[] weeklyY70_Y80_Arr = strweekY70_Y80_Arr.split(",");
			String[] weeklyY80_Y90_Arr = strweekY80_Y90_Arr.split(",");
			String[] weeklyY90_Y100_Arr = strweekY90_Y100_Arr.split(",");
			String[] weeklyY100_Arr = strweekY100_Arr.split(",");

			for (int i = 0; i < weeklyDaysAgewise.length; i++) {
			%>
	<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center;height:20px; hover">
		<td style="background-color:#ffc4c8;border-color: #da1e28;width:25%; font-weight: bold;text-align: center;"><%=weeklyDaysAgewise[i].replace("-","&#8209;")%></td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyM0_M6_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyM0_M6_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyM6_Y1_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyM6_Y1_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY1_Y5_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY1_Y5_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY5_Y10_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY5_Y10_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY10_Y20_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY10_Y20_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY20_Y30_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY20_Y30_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY30_Y40_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY30_Y40_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY40_Y50_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY40_Y50_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY50_Y60_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY50_Y60_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY60_Y70_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY60_Y70_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY70_Y80_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY70_Y80_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY80_Y90_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY80_Y90_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY90_Y100_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY90_Y100_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY100_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY100_Arr[i]))%>&nbsp;&nbsp;</td>
	</tr>
<%
			}
			%>
		</table>
		</div>
		</div>
	</div>
	<%///////////////////////	Table - Indian/Foreigner Count in last 7 days - End	////////////////////////%>

<br><br>
<br><br>
<div class="container-fluid">
<div class="row">
<div class="col-sm-12">

<div class="card" style="border: solid 3px #da1e28; border-radius: 20px; height:550px;">

<div class="card-body" style=" height:550px; ">

<canvas id="canvasWeeklyAgewise2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #fbcadd 100%);border-radius: 20px;height:550px; "></canvas>
	</div>
	</div>	
	</div>
	</div>
	
	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysAgewise%>],
			datasets: [{ 
				  label: "6 Months",
			      backgroundColor: "#377ff3",
			      borderColor: "#377ff3",
			      borderWidth: 1,
			     
			      data: [<%=strweekM0_M6_Arr%>]
			},{ 
				  label: "6 Months to 1 Year",
			      backgroundColor: "#FF4B91",
			      borderColor: "#FF4B91",
			      borderWidth: 1,
			     
			      data: [<%=strweekM6_Y1_Arr%>]
			},{ 
				  label: "1-5 Years",
			      backgroundColor: "brown",
			      borderColor: "brown",
			      borderWidth: 1,
			     
			      data: [<%=strweekY1_Y5_Arr%>]
			},{ 
				  label: "5-10 Years",
			      backgroundColor: "cadetblue",
			      borderColor: "cadetblue",
			      borderWidth: 1,
			     
			      data: [<%=strweekY5_Y10_Arr%>]
			},{ 
				  label: "10-20 Years",
			      backgroundColor: "chartreuse",
			      borderColor: "chartreuse",
			      borderWidth: 1,
			     
			      data: [<%=strweekY10_Y20_Arr%>]
			},{ 
				  label: "20-30 Years",
			      backgroundColor: "coral",
			      borderColor: "coral",
			      borderWidth: 1,
			     
			      data: [<%=strweekY20_Y30_Arr%>]
			},{ 
				  label: "30-40 Years",
			      backgroundColor: "cornflowerBlue",
			      borderColor: "cornflowerBlue",
			      borderWidth: 1,
			     
			      data: [<%=strweekY30_Y40_Arr%>]
			},{ 
				  label: "40-50 Years",
			      backgroundColor: "darkCyan",
			      borderColor: "darkCyan",
			      borderWidth: 1,
			     
			      data: [<%=strweekY40_Y50_Arr%>]
			},{ 
				  label: "50-60 Years",
			      backgroundColor: "red",
			      borderColor: "levender",
			      borderWidth: 1,
			     
			      data: [<%=strweekY50_Y60_Arr%>]
			},{ 
				  label: "60-70 Years",
			      backgroundColor: "goldenrod",
			      borderColor: "goldenrod",
			      borderWidth: 1,
			     
			      data: [<%=strweekY60_Y70_Arr%>]
			},{ 
				  label: "70-80 Years",
			      backgroundColor: "fuchsia",
			      borderColor: "fuchsia",
			      borderWidth: 1,
			     
			      data: [<%=strweekY70_Y80_Arr%>]
			},{ 
				  label: "80-90 Years",
			      backgroundColor: "gold",
			      borderColor: "gold",
			      borderWidth: 1,
			     
			      data: [<%=strweekY80_Y90_Arr%>]
			},{ 
				  label: "90-100 Years",
			      backgroundColor: "grey",
			      borderColor: "grey",
			      borderWidth: 1,
			     
			      data: [<%=strweekY90_Y100_Arr%>]
			},{ 
				  label: "100 Years",
			      backgroundColor: "khaki",
			      borderColor: "khaki",
			      borderWidth: 1,
			     
			      data: [<%=strweekY100_Arr%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
		responsive:true,
		maintainAspectRatio: false,				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		//stacked: true
		display: false,
		}],
		xAxes: [{
		//stacked: true,
		gridLines: {
			color:"grey",
		}
		
		}]
		},
		 title: {
				display: true,
					text:'Age-wise Statistics in last 7 days',
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
					ctx.fillStyle = "#303030";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 8px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x-1, bar._model.y );

							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyAgewise2').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%///////////////////////////	Start - Arrived, Departed and Expected Flights	/////////////////////////////%>
<section id="Arr_Sch_Flts"><br><br><br><br><br><br><br>
<div class="pt-4" id="Arr_Sch_Flts">
<table id = "auto-index5" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
			<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival, Departure and Expected Flights</th>
		</tr>
	</thead>
</table>
<%
out.flush(); //20/09/2022 use for loader
java.util.Date currentDatetime = new java.util.Date(System.currentTimeMillis());
DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM);
sdf = new SimpleDateFormat("dd/MM/yyyy");
String current_year = sdf.format(currentDatetime);

PreparedStatement ps = null;
PreparedStatement ps1 = null;
PreparedStatement ps2 = null;
ResultSet rs = null;
ResultSet rs1 = null;
String sql_qry = "";
String sql_qry_Dep = "";
int distinct_evisa_total = 0;
int distinct_voa_total = 0;
%>
<%////////////////// Start - Arrived and Expected Flights /////////////////%>
<div class="container-fluid">
<div class="row">
<%/////////////////////////////////Start - ARR////////////////////////////////%>
<div class="col-sm-6">
<%
try
  {
%>
<form action="im_icp_dashboard_00_test.jsp#Arr_Sch_Flts" method="post" >
<input type="hidden" name="filter_date" value="<%=vDate.format(current_Server_Time)%>"/>
<table class="tableDesign">
		<tr style="background-color:#a56eff;font-weight:bold;font-size: 22px;height: 40px;">
			<th style="text-align:center;background-color:#915be8; border-color: #915be8; color: white;" colspan="9"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Arrived and Expected Flights</th>
		</tr>
		<tr style="background-color:#a56eff;font-weight:bold;font-size: 12px;height: 30px;">
			<th style="text-align:left;background-color:#a56eff; border-color: #a56eff; color: white;font-weight:normal;" colspan="5">List of flights in last <select type="text" name="filter_time" style="border-radius: 3px;">
		
			<%for(int i=1; i <= 24; i++){%>
			<option <%if(Integer.parseInt(select_time) == i){%>selected<%}%> value="<%=i%>"><%=i%></option>
			<%}%>
			</select>
			 hours &nbsp;<input type="submit" name="submit" style="background-color: #1780c4; border-color: #1780c4; color: white; border-radius: 4px;" value="Go"> since <%=filter_date %>&nbsp;<%=filter_time.substring(0,2)+":"+ filter_time.substring(2,4)%></th>
			<th style="text-align:right;background-color:#a56eff; border-color: #a56eff; color: white; font-weight:normal;" colspan="4">Current Server Time : <%=vFileName%></th>
		</tr>
</table>
</form>

<div class="fixTableHead">
<table class="tableDesign">
		<thead>
			<tr style="background-color:#be95ff;font-weight:bold; color: white;font-size: 14px;height: 35px;border-top-right-radius: 0px;">
				<th style="text-align:center;border-color: #a56eff;background-color:#be95ff;border-top-left-radius: 0px;">&nbsp;S.No.&nbsp;</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff;">&nbsp;Flight&nbsp;No.&nbsp;</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff;">&nbsp;Schedule&nbsp;Time</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff;">&nbsp;Arrived&nbsp;<BR>From</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;PAX&nbsp;</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;APIS&nbsp;</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;eVisa&nbsp;</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;Biometric&nbsp;<BR>Enrollment&nbsp;</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff; border-radius: 0px;">&nbsp;Clearance&nbsp;<BR>Time&nbsp;</th>
			</tr>
		</thead>
			<%
		String str_filter_icp  = "";
		if(filter_icp.trim().length() > 0) str_filter_icp = " and icp_srno = '"+filter_icp+"'";

	        if(calTime > 0)
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '"+filter_time+"' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");
			else
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '0000' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");

			rs = ps.executeQuery();
			int counter = 1;
			while(rs.next())
			 {	
				 if(calTime > 0)
					sql_qry = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_DATE <= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";
				else
					sql_qry = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where (SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_TIME <= '2359') OR SCHEDULE_DATE >= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";
					String bgcolor = "";
					ps1 = con.prepareStatement(sql_qry);
					rs1 = ps1.executeQuery();
					
					if(rs1.next())
					{
						bgcolor = "";
						
						if(rs1.getString("STATUS_COLOR") != null )
						{
							if(rs1.getString("STATUS_COLOR").equals("G")) bgcolor = "#98FB98";
							if(rs1.getString("STATUS_COLOR").equals("R")) bgcolor = "#F7A9A8";
							if(rs1.getString("STATUS_COLOR").equals("Y")) bgcolor = "";
							
						}else
							bgcolor = "#E3D26F";
						%>
						<tr style="font-size: 13px;"> 
							<td style="text-align:center;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=counter%></td>
							<td style="text-align:left;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=rs1.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							<td style="text-align:center;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=rs1.getString("APIS_FILENAME") == null ? "" : rs1.getString("APIS_FILENAME").substring(7,10)%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=rs1.getInt("EVISA_COUNT") == 0 ? "" : rs1.getInt("EVISA_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=rs1.getInt("BIOMETRIC_COUNT") == 0 ? "" : rs1.getInt("BIOMETRIC_COUNT")%></td>
							<td style="text-align:left;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>
						<%
						rs1.close();
						ps1.close();
					}
					else
						{
						rs1.close();
						ps1.close();
						ps1 = con.prepareStatement("select * from IM_DASHBOARD_SCH_FLIGHTS_ARR where ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE desc");
						rs1 = ps1.executeQuery();
						if(rs1.next())
						{
							%>
						<tr style="background-color:#f6f2ff;">
							<td style="text-align:center;border-color: #a56eff;font-size: 13px;"><%=counter%></td>
							<td style="text-align:left;border-color: #a56eff;font-size: 13px;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;color:#449cf5;border-color: #a56eff;font-size: 13px;"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<font color='black'><%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></font></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 13px;">&nbsp;</td>
							<td style="text-align:right;border-color: #a56eff;font-size: 13px;color:#449cf5"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 13px;color:#449cf5"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 13px;color:#449cf5"><%=rs1.getInt("EVISA_COUNT") == 0 ? "" : rs1.getInt("EVISA_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 13px;color:#449cf5"><%=rs1.getInt("BIOMETRIC_COUNT") == 0 ? "" : rs1.getInt("BIOMETRIC_COUNT")%></td>
							<td style="text-align:left;border-color: #a56eff;font-size: 13px;color:#449cf5"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>
						<%					
						}
						else
							{
							%>
						<tr> 
							<td style="text-align:center;"><%=counter%></td>
							<td style="text-align:left;border-color: #a56eff;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #a56eff;"><%=rs.getString("SCHEDULE_TIME")%></td>
							<td style="text-align:left;border-color: #a56eff;" colspan="6">&nbsp;</td>
						</tr>
						<%
							}
						rs1.close();
						ps1.close();

						}
						rs1.close();
						ps1.close();
					counter++;
					}
			rs.close();
			ps.close();

			%>
			</table>
			</div>
			</div>
<%	
	}
	catch(Exception e)
	{
		out.println(e);
		e.printStackTrace();
	}

%>
<%///////////////////////////////End - ARR//////////////////////////////////%>
<%////////////////// End - Arrived and Expected Flights /////////////////%>

<%////////////////// Start - Departed and Expected Flights /////////////////%>

<div class="col-sm-6">

<!-- <form action="im_icp_dashboard_00_test.jsp#Arr_Sch_Flts" method="post">
<input type="hidden" name="filter_date" value="<%=vDate.format(current_Server_Time)%>"/>
<table align="center" width="40%" cellspacing="0"  cellpadding="0" border="0">
		<tr style="font-family: Verdana; font-size: 8pt; color:#43CD80;font-weight: bold;text-align:center;color: #347FAA;">
			<td>Hours : <select type="text" name="filter_time">
			<%for(int i=1; i <= 24; i++){%>
			<option <%if(Integer.parseInt(select_time) == i){%>selected<%}%> value="<%=i%>"><%=i%></option>
			<%}%>
			</select>
			</td>
			<td><input type="submit" name="submit" value="submit"></td>
		</tr>
</table>
</form> -->

<form action="im_icp_dashboard_00_test.jsp#Arr_Sch_Flts" method="post">
<input type="hidden" name="filter_date" value="<%=vDate.format(current_Server_Time)%>"/>
<table class="tableDesign">
		<tr style="background-color:#a56eff;font-weight:bold;font-size: 22px;height: 40px;">
			<th style="text-align:center;background-color:#d53c71; border-color: #d53c71; color: white;" colspan="6"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Departed and Expected Flights</th>
		</tr>
		<tr style="font-weight:bold;font-size: 12px;height: 30px;">
			<th style="text-align:left;background-color:#db5a87; border-color: #db5a87; color: white; font-weight:normal;" colspan="3">List of flights in last <select type="text" name="filter_time" style="border-radius: 3px;">
			<%for(int i=1; i <= 24; i++){%>
			<option <%if(Integer.parseInt(select_time) == i){%>selected<%}%> value="<%=i%>"><%=i%></option>
			<%}%>
			</select> hours <input type="submit" name="submit" style="background-color: #1780c4; border-color: #1780c4; color: white; border-radius: 4px;" value="Go"> since <%=filter_date %>&nbsp;<%=filter_time.substring(0,2)+":"+ filter_time.substring(2,4)%></th>
			<th style="text-align:right;background-color:#db5a87; border-color: #db5a87; color: white; font-weight:normal;" colspan="3">Current Server Time : <%=vFileName%></th>
		</tr>

</table>
</form>

<div class="fixTableHead">
<table class="tableDesign">
	<thead>
			<tr style="background-color:#be95ff;font-weight:bold; color: white;font-size: 14px;height: 35px;border-top-right-radius: 0px;">
				<th style="text-align:center;border-color: #d53c71;background-color:#e88cac;border-top-left-radius: 0px;">&nbsp;S.No.&nbsp;</th>
				<th style="text-align:left;border-color: #d53c71;background-color:#e88cac;">&nbsp;Flight&nbsp;No.&nbsp;</th>
				<th style="text-align:left;border-color: #d53c71;background-color:#e88cac;">&nbsp;Schedule&nbsp;Time</th>
				<th style="text-align:right;border-color: #d53c71;background-color:#e88cac;">&nbsp;PAX&nbsp;</th>
				<th style="text-align:right;border-color: #d53c71;background-color:#e88cac;">&nbsp;APIS&nbsp;</th>
				<th style="text-align:left;border-color: #d53c71;background-color:#e88cac; border-radius: 0px;">&nbsp;Clearance&nbsp;<BR>Time&nbsp;</th>
			</tr>
	</thead>
			<%
		try
		{ 	
		String str_filter_icp  = "";
		if(filter_icp.trim().length() > 0) str_filter_icp = " and icp_srno = '"+filter_icp+"'";


	        if(calTime > 0)
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '"+filter_time+"' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");
			else
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '0000' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");

			rs = ps.executeQuery();
			int counter = 1;
			while(rs.next())
			{
						
				 if(calTime > 0)
					sql_qry_Dep = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_DATE <= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";

				else
					sql_qry_Dep = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where (SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_TIME <= '2359') OR SCHEDULE_DATE >= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";
			   //out.println(sql_qry_Dep);
					String bgcolor = "";
					ps1 = con.prepareStatement(sql_qry_Dep);
					rs1 = ps1.executeQuery();
					
					if(rs1.next())
					{
						bgcolor = "";
						
						if(rs1.getString("STATUS_COLOR") != null )
						{
							if(rs1.getString("STATUS_COLOR").equals("G")) bgcolor = "#98FB98";
							if(rs1.getString("STATUS_COLOR").equals("R")) bgcolor = "#F7A9A8";
							if(rs1.getString("STATUS_COLOR").equals("Y")) bgcolor = "";
							
						}else
							bgcolor = "#E3D26F";
						%>
						<tr> 
							<td style="text-align:center;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"><%=counter%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"><%=rs1.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>
						<%
						
					rs1.close();
					ps1.close();
					}
					else
						{
						rs1.close();
						ps1.close();
						ps1 = con.prepareStatement("select * from IM_DASHBOARD_SCH_FLIGHTS_DEP where ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE desc");
						rs1 = ps1.executeQuery();
						if(rs1.next())
						{
							%>
						<tr> 
							<td style="text-align:center;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;""><%=counter%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;""><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"color:#9DCEFF"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"color:#9DCEFF"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"color:#9DCEFF"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<!-- <td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"color:#9DCEFF"><%=rs1.getInt("EVISA_COUNT") == 0 ? "" : rs1.getInt("EVISA_COUNT")%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"color:#9DCEFF"><%=rs1.getInt("BIOMETRIC_COUNT") == 0 ? "" : rs1.getInt("BIOMETRIC_COUNT")%></td> -->
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 13px;"color:#9DCEFF"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>

						<%
						rs1.close();
						ps1.close();
						}
						else
							{
							%>
						<tr> 
							<td style="text-align:center;"><%=counter%></td>
							<td style="text-align:left;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;"><%=rs.getString("SCHEDULE_TIME")%></td>
							<td style="text-align:left;" colspan="3">&nbsp;</td>
						</tr>
						<%
							}
						}
					counter++;
					}
			rs.close();
			ps.close();

			%>
			</table>
			</div>
			</div>
<%		
	}
	catch(Exception e)
	{
		out.println(e);
		e.printStackTrace();
	}
////////////////// End - Departed and Expected Flights /////////////////%>


</section>

</div>
</div>
</div>

<%///////////////////////////	End - Arrived, Departed and Expected Flights	/////////////////////////////%>







<!--   ************************Arrival : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)********************  -->

		<section id="ICS_Arr_PAX"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Arr_PAX">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Hourly Flight Clearance and Expected Flights</th>
				</tr>
			</thead>
		</table>

		<%

//------------------------------------- List for Map --------------------------------------------//
	Map<String, ICP> icp_srno_dba_link = new LinkedHashMap<String,ICP>(); // For storing ICP_SRNO and DBA_LINKS.
	if(filter_icp.equals("All"))
	{
		icp_srno_dba_link.put("022",new ICP("022","DBL_IVFRT022","10.52.131.131"));    // AMD2
		icp_srno_dba_link.put("010",new ICP("010","DBL_IVFRT010","10.52.141.3"));	// CAL2
		icp_srno_dba_link.put("162",new ICP("162","DBL_IVFRT162","10.52.143.3"));	// HAR2
		icp_srno_dba_link.put("006",new ICP("006","DBL_IVFRT006","10.52.134.3"));	// JAI2
		icp_srno_dba_link.put("033",new ICP("033","DBL_IVFRT033","10.52.138.3"));	// GOA2
		icp_srno_dba_link.put("023",new ICP("023","DBL_IVFRT023","10.52.129.3"));	// TVM2
		icp_srno_dba_link.put("007",new ICP("007","DBL_IVFRT007","10.52.142.195"));	// VAR2
		icp_srno_dba_link.put("094",new ICP("094","DBL_IVFRT094","10.52.145.131"));	// CBE2
		icp_srno_dba_link.put("012",new ICP("012","DBL_IVFRT012","10.52.134.67"));	// GAY2
		icp_srno_dba_link.put("019",new ICP("019","DBL_IVFRT019","10.52.134.131"));	// GUW2
		icp_srno_dba_link.put("021",new ICP("021","DBL_IVFRT021","10.52.142.131"));  // LUC2 
		icp_srno_dba_link.put("092",new ICP("092","DBL_IVFRT092","10.52.146.3"));  // MNG2 
		icp_srno_dba_link.put("026",new ICP("026","DBL_IVFRT026","10.52.132.3"));  // PNE2 
		icp_srno_dba_link.put("003",new ICP("003","DBL_IVFRT003","10.52.145.67"));  // TRY2 
		icp_srno_dba_link.put("016",new ICP("016","DBL_IVFRT016","10.52.131.195"));  // NAG2 
		icp_srno_dba_link.put("364",new ICP("364","DBL_IVFRT164","10.52.147.3"));  // GED2 
		icp_srno_dba_link.put("032",new ICP("032","DBL_IVFRT032","10.52.140.66"));  // AMR2 
		icp_srno_dba_link.put("002",new ICP("002","DBL_IVFRT002","10.52.139.3"));  // KOL2 
		icp_srno_dba_link.put("309",new ICP("309","DBL_IVFRT309","10.52.145.3"));  // MUN2 
		icp_srno_dba_link.put("305",new ICP("305","DBL_IVFRT305","10.52.140.130"));  // ATT2 
		icp_srno_dba_link.put("105",new ICP("105","DBL_IVFRT105","10.52.142.3")) ;// WAG2
		icp_srno_dba_link.put("008",new ICP("008","DBL_IVFRT008","10.52.135.3")) ;// CHN2
		icp_srno_dba_link.put("004",new ICP("004","DBL_IVFRT004","10.52.144.3")) ;// IGI2
		icp_srno_dba_link.put("001",new ICP("001","DBL_IVFRT001","10.52.137.3")) ;// BOM2
		icp_srno_dba_link.put("041",new ICP("041","DBL_IVFRT041","10.52.148.3")) ;// NHYD
		icp_srno_dba_link.put("085",new ICP("085","DBL_IVFRT085","10.52.130.3")) ;// BNG2
		icp_srno_dba_link.put("024",new ICP("024","DBL_IVFRT024","10.52.136.3")) ;// COH2
		icp_srno_dba_link.put("077",new ICP("077","DBL_IVFRT077","10.52.141.131")) ;// AND2
		icp_srno_dba_link.put("095",new ICP("095","DBL_IVFRT095","10.52.128.3")) ;// SRI2
		icp_srno_dba_link.put("025",new ICP("025","DBL_IVFRT025","10.52.129.67")) ;// VTZ2
		icp_srno_dba_link.put("015",new ICP("015","DBL_IVFRT015","10.52.132.131")) ;// MDU2
		icp_srno_dba_link.put("096",new ICP("096","DBL_IVFRT096","10.52.149.3")) ;// BAG2
		icp_srno_dba_link.put("084",new ICP("084","DBL_IVFRT084","10.52.149.66")) ;// BHU2
		icp_srno_dba_link.put("005",new ICP("005","DBL_IVFRT005","10.52.133.212")) ;// CHA2
		icp_srno_dba_link.put("030",new ICP("030","DBL_IVFRT030","10.52.161.131")) ;// KAN2
		icp_srno_dba_link.put("029",new ICP("029","DBL_IVFRT029","10.52.146.131")) ;// SUR2
		icp_srno_dba_link.put("397",new ICP("397","DBL_IVFRT397","10.52.161.197")) ;// CHIT
		icp_srno_dba_link.put("107",new ICP("107","DBL_IVFRT107","10.52.147.132")) ;// KAR2
		icp_srno_dba_link.put("017",new ICP("017","DBL_IVFRT017","10.52.132.66")) ;// IDR2
		icp_srno_dba_link.put("224",new ICP("224","DBL_IVFRT224","10.52.136.8")) ;// COHSEAPORT
		icp_srno_dba_link.put("888",new ICP("888","DBL_IVFRT888","172.16.1.51")) ;// CICS  
	}
	else if(filter_icp.equals("022"))
		icp_srno_dba_link.put("022",new ICP("022","DBL_IVFRT022","10.52.131.131"));    // AMD2
	else if(filter_icp.equals("010"))
		icp_srno_dba_link.put("010",new ICP("010","DBL_IVFRT010","10.52.141.3"));	// CAL2
	else if(filter_icp.equals("162"))
		icp_srno_dba_link.put("162",new ICP("162","DBL_IVFRT162","10.52.143.3"));	// HAR2
	else if(filter_icp.equals("006"))
		icp_srno_dba_link.put("006",new ICP("006","DBL_IVFRT006","10.52.134.3"));	// JAI2
	else if(filter_icp.equals("033"))
		icp_srno_dba_link.put("033",new ICP("033","DBL_IVFRT033","10.52.138.3"));	// GOA2
	else if(filter_icp.equals("023"))
		icp_srno_dba_link.put("023",new ICP("023","DBL_IVFRT023","10.52.129.3"));	// TVM2
	else if(filter_icp.equals("007"))
		icp_srno_dba_link.put("007",new ICP("007","DBL_IVFRT007","10.52.142.195"));	// VAR2
	else if(filter_icp.equals("094"))
		icp_srno_dba_link.put("094",new ICP("094","DBL_IVFRT094","10.52.145.131"));	// CBE2
	else if(filter_icp.equals("012"))
		icp_srno_dba_link.put("012",new ICP("012","DBL_IVFRT012","10.52.134.67"));	// GAY2
	else if(filter_icp.equals("019"))
		icp_srno_dba_link.put("019",new ICP("019","DBL_IVFRT019","10.52.134.131"));	// GUW2
	else if(filter_icp.equals("364"))
		icp_srno_dba_link.put("364",new ICP("364","DBL_IVFRT164","10.52.147.3"));  // GED2 
	else if(filter_icp.equals("021"))
		icp_srno_dba_link.put("021",new ICP("021","DBL_IVFRT021","10.52.142.131"));  // LUC2 
	else if(filter_icp.equals("092"))
		icp_srno_dba_link.put("092",new ICP("092","DBL_IVFRT092","10.52.146.3"));  // MNG2 
	else if(filter_icp.equals("026"))
		icp_srno_dba_link.put("026",new ICP("026","DBL_IVFRT026","10.52.132.3"));  // PNE2 
	else if(filter_icp.equals("003"))
		icp_srno_dba_link.put("003",new ICP("003","DBL_IVFRT003","10.52.145.67"));  // TRY2 
	else if(filter_icp.equals("016"))
		icp_srno_dba_link.put("016",new ICP("016","DBL_IVFRT016","10.52.131.195"));  // NAG2 
	else if(filter_icp.equals("032"))
		icp_srno_dba_link.put("032",new ICP("032","DBL_IVFRT032","10.52.140.66"));  // AMR2 
	else if(filter_icp.equals("002"))
		icp_srno_dba_link.put("002",new ICP("002","DBL_IVFRT002","10.52.139.3"));  // KOL2 
	else if(filter_icp.equals("309"))
		icp_srno_dba_link.put("309",new ICP("309","DBL_IVFRT309","10.52.145.3"));  // MUN2 
	else if(filter_icp.equals("305"))
		icp_srno_dba_link.put("305",new ICP("305","DBL_IVFRT305","10.52.140.130"));  // ATT2 
	else if(filter_icp.equals("105"))
		icp_srno_dba_link.put("105",new ICP("105","DBL_IVFRT105","10.52.142.3")) ;// WAG2
	else if(filter_icp.equals("008"))
		icp_srno_dba_link.put("008",new ICP("008","DBL_IVFRT008","10.52.135.3")) ;// CHN2
	else if(filter_icp.equals("004"))
		icp_srno_dba_link.put("004",new ICP("004","DBL_IVFRT004","10.52.144.3")) ;// IGI2
	else if(filter_icp.equals("001"))
		icp_srno_dba_link.put("001",new ICP("001","DBL_IVFRT001","10.52.137.3")) ;// BOM2
	else if(filter_icp.equals("041"))
		icp_srno_dba_link.put("041",new ICP("041","DBL_IVFRT041","10.52.148.3")) ;// NHYD
	else if(filter_icp.equals("085"))
		icp_srno_dba_link.put("085",new ICP("085","DBL_IVFRT085","10.52.130.3")) ;// BNG2
	else if(filter_icp.equals("024"))
		icp_srno_dba_link.put("024",new ICP("024","DBL_IVFRT024","10.52.136.3")) ;// COH2
	else if(filter_icp.equals("077"))
		icp_srno_dba_link.put("077",new ICP("077","DBL_IVFRT077","10.52.141.131")) ;// AND2
	else if(filter_icp.equals("095"))
		icp_srno_dba_link.put("095",new ICP("095","DBL_IVFRT095","10.52.128.3")) ;// SRI2
	else if(filter_icp.equals("025"))
		icp_srno_dba_link.put("025",new ICP("025","DBL_IVFRT025","10.52.129.67")) ;// VTZ2
	else if(filter_icp.equals("015"))
		icp_srno_dba_link.put("015",new ICP("015","DBL_IVFRT015","10.52.132.131")) ;// MDU2
	else if(filter_icp.equals("096"))
		icp_srno_dba_link.put("096",new ICP("096","DBL_IVFRT096","10.52.149.3")) ;// BAG2
	else if(filter_icp.equals("084"))
		icp_srno_dba_link.put("084",new ICP("084","DBL_IVFRT084","10.52.149.66")) ;// BHU2
	else if(filter_icp.equals("005"))
		icp_srno_dba_link.put("005",new ICP("005","DBL_IVFRT005","10.52.133.212")) ;// CHA2
	else if(filter_icp.equals("030"))
		icp_srno_dba_link.put("030",new ICP("030","DBL_IVFRT030","10.52.161.131")) ;// KAN2
	else if(filter_icp.equals("029"))
		icp_srno_dba_link.put("029",new ICP("029","DBL_IVFRT029","10.52.146.131")) ;// SUR2
	else if(filter_icp.equals("397"))
		icp_srno_dba_link.put("397",new ICP("397","DBL_IVFRT397","10.52.161.197")) ;// CHIT
	else if(filter_icp.equals("107"))
		icp_srno_dba_link.put("107",new ICP("107","DBL_IVFRT107","10.52.147.132")) ;// KAR2
	else if(filter_icp.equals("017"))
		icp_srno_dba_link.put("017",new ICP("017","DBL_IVFRT017","10.52.132.66")) ;// IDR2
	else if(filter_icp.equals("224"))
		icp_srno_dba_link.put("224",new ICP("224","DBL_IVFRT224","10.52.136.8")) ;// COHSEAPORT
	else if(filter_icp.equals("888"))
		icp_srno_dba_link.put("888",new ICP("888","DBL_IVFRT888","172.16.1.51")) ;// CICS  
	//----------------------------------  List for Map -------------------------------------//
	
	

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	


			DateFormat flightDateFormat = new SimpleDateFormat("dd MMM");

	DateFormat vDateFormat2 = new SimpleDateFormat("HH");
		//java.util.Date current_Server_Time = new java.util.Date();
		String current_hour = vDateFormat2.format(current_Server_Time);
		//out.println(current_hour);

	////////////////////////////////////////////////////////////// Start : Combined APIS and ARRIVAL Statistics ////////////////////////////////////////////////////////////////////////

	{
		String icp_sr_no = filter_icp;

		String strSqlFlightDetails = "( select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) <= " + current_hour  +  " and fl.flight_type = 'A' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 " + " union " + "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  im_apis_pax@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = apis_table.pax_flight_no and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) > " + current_hour  +  " and fl.flight_type = 'A' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( apis_table.pax_name) > 0 ) order by 1,3,passenger_count desc";

		//String strSqlFlightDetails = "select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 1 ,3 ,passenger_count desc ";

		//out.println(strSqlFlightDetails);

		Statement stFlightDetails = con.createStatement();
		ResultSet rsFlightDetails = null;
		
		LinkedHashMap<String, String> borDateHoursFlightnameCountPair = new LinkedHashMap<String,String>();
		
		try
		{
			rsFlightDetails = stFlightDetails.executeQuery(strSqlFlightDetails);
			
			if(rsFlightDetails.next()){
				do{			
					
					String boarding_date = rsFlightDetails.getDate("boarding_date") == null ? "" : flightDateFormat.format(rsFlightDetails.getDate("boarding_date")); 
					String boarding_time = rsFlightDetails.getString("boarding_time") == null ? "" : rsFlightDetails.getString("boarding_time"); 
					String hours = rsFlightDetails.getString("hours") == null ? "" : rsFlightDetails.getString("hours"); 
					String flight_no = rsFlightDetails.getString("flight_no") == null ? "" : rsFlightDetails.getString("flight_no"); 
					
					String passenger_count = rsFlightDetails.getInt("passenger_count") == 0 ? "0" : rsFlightDetails.getString("passenger_count"); 

					if( borDateHoursFlightnameCountPair.get(boarding_date + "#####" + hours) == null)
						borDateHoursFlightnameCountPair.put(boarding_date + "#####" + hours, flight_no + "##" + passenger_count);
					else
						borDateHoursFlightnameCountPair.put(boarding_date + "#####" + hours, borDateHoursFlightnameCountPair.get(boarding_date + "#####" + hours) + "####" + flight_no + "##" + passenger_count);
					
					
						
				}while(rsFlightDetails.next());
			}

			if(rsFlightDetails!=null)
			{
				rsFlightDetails.close();
				stFlightDetails.close();
			}

		}
		catch(SQLException e)
		{
			out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + strSqlFlightDetails + "<BR><BR></b></font>");
		}

				
		
				int serial_no = 0;
				int maxFlightInHour = - 1;

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{
					if(borDateHoursFlightnameCountPair.get(keyValue).split("####").length > maxFlightInHour)
						maxFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					serial_no++;		
				}

		/////////////////////////////////////////////////////////// Strat : New Table for Flight Count ////////////////////////////////////////////////////////////////////////////////////
				
				%>			
							<BR><BR>

							<table  class="outer_table" width="100%"> 
							
								
								<tr>
				<%

				serial_no = 0;
				boolean future_flag = false;	
				boolean future_past_divison = false;
				int current_hour_in_int = Integer.parseInt(current_hour);

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{

					serial_no++;
					int currentFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					int differenceInFlightInHour = maxFlightInHour - currentFlightInHour;
					
					int current_row_hour_in_int = Integer.parseInt(keyValue.split("#####")[1]);

					//////////////////////////////////////////// Start : Curent Hour Sum Calculation //////////////////////////////////////////

					int current_hour_pax_sum = 0;

					for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
					{
						current_hour_pax_sum = current_hour_pax_sum + Integer.parseInt((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);

						//out.println((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);
					}

					//////////////////////////////////////////// End : Curent Hour Sum Calculation //////////////////////////////////////////
					
					if(current_row_hour_in_int > current_hour_in_int)
						future_flag = true;

					if(current_row_hour_in_int > current_hour_in_int)
					{
						future_flag = true;
						
						if(future_past_divison==false)
						{
							%><td style="vertical-align:bottom">
												<table  style="border-collapse: collapse;background-color:black;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" border=0;  width="0%" cellpadding="0" cellspacing="0" >
													<%	
														while(maxFlightInHour > 0)
														{
															%>
																<tr>
																	<td colspan = "1">&nbsp;</td>
																</tr>
															<%
															maxFlightInHour--;
														}
													
													%>	
														
														</table></td><%
						}
						future_past_divison = true;
					}

					%>
										
								
											<td style="vertical-align:bottom">
												<table  style="padding:1px 1px;border-collapse: collapse;background-color:#FFFFFF;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" border=0;  width="100%" cellpadding="0" cellspacing="0" >
													<%	
														while(differenceInFlightInHour > 0)
														{
															%>
																<tr>
																	<td colspan = "2">&nbsp;</td>
																</tr>
															<%
															differenceInFlightInHour--;
														}
													
													%>	
														<tr>
															<td colspan = "2" style="font-weight: bold;text-align: center;"><%=current_hour_pax_sum%></td>
														</tr>
														</table>
														
														<%if( future_flag == false && serial_no%2==0){%>
															<table class="main_table red_table" width="100%">
														<%}else if( future_flag == false && serial_no%2!=0) {%>
															<table class="main_table green_table" width="100%">
														<%}
														else if( future_flag != false && serial_no%2==0){%>
															<table class="main_table blue_table" width="100%">
														<%}else if( future_flag != false && serial_no%2!=0) {%>
															<table class="main_table blue_table" width="100%">
														<%}
													
														for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
														{
															if(future_flag == false)
															{
																if(serial_no%2==0)
																{%>
																	<tr  >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style="font-weight: bold; text-align: right;" ><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
															else
															{
																if(serial_no%2==0)
																{%>
																	<tr >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style=" font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style=" font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
														}
													%>
													<tr>
														<th style="font-weight: bold;text-align: center; font-size:15px" colspan="2"><%=convertToAmPm(keyValue.split("#####")[1])%></th>
													</tr>
												</table>
											</td>
					<%		
				}
				%>				</tr>

								
					</table><BR><BR> <%

	}

	////////////////////////////////////////////////////////////// End : Combined APIS and ARRIVAL Statistics ////////////////////////////////////////////////////////////////////////
	%></section>







<!--   ************************Departure : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)********************  -->
		<section id="ICS_Dep_PAX"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Dep_PAX">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Departure : Hourly Flight Clearance and Expected Flights</th>
				</tr>
				<!--<tr id='head' name='custom-apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>

	
	<%////////////////////////////////////////////////////////////// Start : Combined APIS and DEPARTURE Statistics ////////////////////////////////////////////////////////////////////////

	{
		String icp_sr_no = filter_icp;

		String strSqlFlightDetails = "( select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_dep_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) <= " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 " + " union " + "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  im_apis_pax_dep@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = apis_table.pax_flight_no and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) > " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( apis_table.pax_name) > 0 ) order by 1,3,passenger_count desc";

		//out.println(strSqlFlightDetails);

		//String strSqlFlightDetails = "select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 1 ,3 ,passenger_count desc ";

		//out.println(strSqlFlightDetails);

		Statement stFlightDetails = con.createStatement();
		ResultSet rsFlightDetails = null;
		
		LinkedHashMap<String, String> borDateHoursFlightnameCountPair = new LinkedHashMap<String,String>();
		
		try
		{
			rsFlightDetails = stFlightDetails.executeQuery(strSqlFlightDetails);
			
			if(rsFlightDetails.next()){
				do{			
					
					String boarding_date = rsFlightDetails.getDate("boarding_date") == null ? "" : flightDateFormat.format(rsFlightDetails.getDate("boarding_date")); 
					String boarding_time = rsFlightDetails.getString("boarding_time") == null ? "" : rsFlightDetails.getString("boarding_time"); 
					String hours = rsFlightDetails.getString("hours") == null ? "" : rsFlightDetails.getString("hours"); 
					String flight_no = rsFlightDetails.getString("flight_no") == null ? "" : rsFlightDetails.getString("flight_no"); 
					
					String passenger_count = rsFlightDetails.getInt("passenger_count") == 0 ? "0" : rsFlightDetails.getString("passenger_count"); 

					if( borDateHoursFlightnameCountPair.get(boarding_date + "#####" + hours) == null)
						borDateHoursFlightnameCountPair.put(boarding_date + "#####" + hours, flight_no + "##" + passenger_count);
					else
						borDateHoursFlightnameCountPair.put(boarding_date + "#####" + hours, borDateHoursFlightnameCountPair.get(boarding_date + "#####" + hours) + "####" + flight_no + "##" + passenger_count);
					
					
						
				}while(rsFlightDetails.next());
			}

			if(rsFlightDetails!=null)
			{
				rsFlightDetails.close();
				stFlightDetails.close();
			}

		}
		catch(SQLException e)
		{
			out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + strSqlFlightDetails + "<BR><BR></b></font>");
		}

				
		
				int serial_no = 0;
				int maxFlightInHour = - 1;

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{
					if(borDateHoursFlightnameCountPair.get(keyValue).split("####").length > maxFlightInHour)
						maxFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					serial_no++;		
				}

		/////////////////////////////////////////////////////////// Strat : New Table for Flight Count ////////////////////////////////////////////////////////////////////////////////////
				
				%>			
							<BR><BR>
							<table class="outer_table" width="100%"> 
							
								
								<tr>
				<%

				serial_no = 0;
				boolean future_flag = false;			
				boolean future_past_divison = false;
				int current_hour_in_int = Integer.parseInt(current_hour);

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{

					serial_no++;
					int currentFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					int differenceInFlightInHour = maxFlightInHour - currentFlightInHour;
					
					int current_row_hour_in_int = Integer.parseInt(keyValue.split("#####")[1]);
					
					if(current_row_hour_in_int > current_hour_in_int)
						future_flag = true;

					if(current_row_hour_in_int > current_hour_in_int)
					{
						future_flag = true;
						
						if(future_past_divison==false)
						{
							%><td style="vertical-align:bottom">
												<table  style="border-collapse: collapse;background-color:black;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" border=0;  width="0%" cellpadding="0" cellspacing="0" >
													<%	
														while(maxFlightInHour > 0)
														{
															%>
																<tr>
																	<td colspan = "1">&nbsp;</td>
																</tr>
															<%
															maxFlightInHour--;
														}
													
													%>	
														
														</table></td><%
						}
						future_past_divison = true;
					}

					//////////////////////////////////////////// Start : Curent Hour Sum Calculation //////////////////////////////////////////

					int current_hour_pax_sum = 0;

					for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
					{
						current_hour_pax_sum = current_hour_pax_sum + Integer.parseInt((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);

						//out.println((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);
					}

					//////////////////////////////////////////// End : Curent Hour Sum Calculation //////////////////////////////////////////

					%>
										
								
											<td style="vertical-align:bottom">
												<table  style="padding:1px 1px;border-collapse: collapse;background-color:#FFFFFF;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" border=0;  width="100%" cellpadding="0" cellspacing="0">
													<%	
														while(differenceInFlightInHour > 0)
														{
															%>
																<tr>
																	<td colspan = "2">&nbsp;</td>
																</tr>
															<%
															differenceInFlightInHour--;
														}
													
													%>
														<tr>
															<td colspan = "2" style="font-weight: bold;text-align: center;"><%=current_hour_pax_sum%></td>
														</tr>
														</table>
														<%if( future_flag == false && serial_no%2==0){%>
															<table class="main_table red_table" width="100%">
														<%}else if( future_flag == false && serial_no%2!=0) {%>
															<table class="main_table green_table" width="100%">
														<%}
														else if( future_flag != false && serial_no%2==0){%>
															<table class="main_table blue_table" width="100%">
														<%}else if( future_flag != false && serial_no%2!=0) {%>
															<table class="main_table blue_table" width="100%">
														<%}
													
													
														for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
														{
															if(future_flag == false)
															{
																if(serial_no%2==0)
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
															else
															{
																if(serial_no%2==0)
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
														}
													%>
													<tr>
														<th style="font-weight: bold;text-align: center; font-size:15px" colspan="2"><%=convertToAmPm(keyValue.split("#####")[1])%>&nbsp;</th>
													</tr>
												</table>
											</td>
					<%		
				}
				%>				</tr>

							
					</table><BR><BR><%

	}

	////////////////////////////////////////////////////////////// End : Combined APIS and DEP Statistics ////////////////////////////////////////////////////////////////////////	%>	


<!--   ************************END TSC DIV************************END  TSC DIV****************END  TSC DIV********  -->
		<!--   ************************START BIOMETRIC DIV*******************START BIOMETRIC DIV*****************START BIOMETRIC DIV****************START BIOMETRIC DIV********  -->
		<section id="biometric_2">
		<div class="pt-4" id="biometric_2">
		<table id = "auto-index9" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: red; color: white; font-size: 22px;text-align: center;"></th>
				</tr>
				<!--<tr id='head' name='biometric'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>	
		</table>
	</section>






<script>
/////////////////// Total Arrival Footfall /////////////////////
let counts_arr_total_pax = setInterval(updated_arr_total_pax);
        let upto_arr_total_pax = <%=(total_Arrival_Count)-400%>;
        function updated_arr_total_pax() {
            upto_arr_total_pax = ++upto_arr_total_pax;
            document.getElementById('countArr').innerHTML = upto_arr_total_pax.toLocaleString('en-IN');
            if (upto_arr_total_pax == <%=total_Arrival_Count%>) {
                clearInterval(counts_arr_total_pax);
            }
        }

let counts_yest_arr_pax = setInterval(updated_yest_arr_pax);
        let upto_yest_arr_pax = <%=(yesterday_Arrival_Count)-2000%>;
        function updated_yest_arr_pax() {
            upto_yest_arr_pax = ++upto_yest_arr_pax;
            document.getElementById('countArrY').innerHTML = upto_yest_arr_pax.toLocaleString('en-IN');
            if (upto_yest_arr_pax === <%=yesterday_Arrival_Count%>) {
                clearInterval(counts_yest_arr_pax);
            }
        }

let counts_today_arr_pax = setInterval(updated_today_arr_pax);
        let upto_today_arr_pax = <%=(today_Arrival_Count)-2000%>;
        function updated_today_arr_pax() {
            upto_today_arr_pax = ++upto_today_arr_pax;
            document.getElementById('countArrT').innerHTML = upto_today_arr_pax.toLocaleString('en-IN');
            if (upto_today_arr_pax === <%=today_Arrival_Count%>) {
                clearInterval(counts_today_arr_pax);
            }
        }
/////////////////////////////////Total Departure Footfall ///////////////////////////////////////


let counts_dep_pax = setInterval(updated_dep_pax);
        let upto_dep_pax = <%=(total_Dep_Count)-400%>;
        function updated_dep_pax() {
            upto_dep_pax = ++upto_dep_pax;
            document.getElementById('count_total_Dep_Count').innerHTML = upto_dep_pax.toLocaleString('en-IN');
            if (upto_dep_pax === <%=total_Dep_Count%>) {
                clearInterval(counts_dep_pax);
            }
        }

let counts_yest_dep_pax = setInterval(updated_yest_dep_pax);
        let upto_yest_dep_pax = <%=(yest_Dep_Count)-2000%>;
        function updated_yest_dep_pax() {
            upto_yest_dep_pax = ++upto_yest_dep_pax;
            document.getElementById('count_total_Dep_CountY').innerHTML = upto_yest_dep_pax.toLocaleString('en-IN');
            if (upto_yest_dep_pax === <%=yest_Dep_Count%>) {
                clearInterval(counts_yest_dep_pax);
            }
        }

let counts_today_dep_pax = setInterval(updated_today_dep_pax);
        let upto_today_dep_pax = <%=(today_Dep_Count)-2000%>;
        function updated_today_dep_pax() {
            upto_today_dep_pax = ++upto_today_dep_pax;
            document.getElementById('count_total_Dep_CountT').innerHTML = upto_today_dep_pax.toLocaleString('en-IN');
            if (upto_today_dep_pax === <%=today_Dep_Count%>) {
                clearInterval(counts_today_dep_pax);
            }
        }
///////////////////////////// Total Footfall ///////////////////////////////////

///////////////////////////// Total Arrival Flights //////////////////////////////////////

let counts_arr_flights = setInterval(updated_arr_flights);
        let upto_arr_flights = <%=(total_Arrival_Flights)-400%>;
        function updated_arr_flights() {
            upto_arr_flights = ++upto_arr_flights;
            document.getElementById('countArrFlt').innerHTML = upto_arr_flights.toLocaleString('en-IN');
            if (upto_arr_flights === <%=total_Arrival_Flights%>) {
                clearInterval(counts_arr_flights);
            }
        }

let counts_yest_flights = setInterval(updated_yest_flights);
        let upto_yest_flights = 10;
        function updated_yest_flights() {
            upto_yest_flights = ++upto_yest_flights;
            document.getElementById('countArrFltY').innerHTML = upto_yest_flights.toLocaleString('en-IN');
            if (upto_yest_flights === <%=yest_Flight_Count%>) {
                clearInterval(counts_yest_flights);
            }
        }

let counts_today_flights = setInterval(updated_today_flights);
        let upto_today_flights = 10;
        function updated_today_flights() {
            upto_today_flights = ++upto_today_flights;
            document.getElementById('countArrFltT').innerHTML = upto_today_flights.toLocaleString('en-IN');
            if (upto_today_flights === <%=arr_Flight_Count%>) {
                clearInterval(counts_today_flights);
            }
        }
//////////////////////////////////////// Total Departure Flights ////////////////////////////////////////


let counts_dep_flights = setInterval(updated_dep_flights);
        let upto_dep_flights = <%=(total_Dep_Flights)-400%>;
        function updated_dep_flights() {
            upto_dep_flights = ++upto_dep_flights;
            document.getElementById('count_total_Dep_Flights').innerHTML = upto_dep_flights.toLocaleString('en-IN');
            if (upto_dep_flights === <%=total_Dep_Flights%>) {
                clearInterval(counts_dep_flights);
            }
        }
let counts_yest_dep_flights = setInterval(updated_yest_dep_flights);	
        let upto_yest_dep_flights = 10;
        function updated_yest_dep_flights() {
            upto_yest_dep_flights = ++upto_yest_dep_flights;
            document.getElementById('count_total_Dep_FlightsY').innerHTML = upto_yest_dep_flights.toLocaleString('en-IN');
            if (upto_yest_dep_flights === <%=yest_Dep_Flights%>) {
                clearInterval(counts_yest_dep_flights);
            }
        }

let counts_today_dep_flights = setInterval(updated_today_dep_flights);
        let upto_today_dep_flights = 10;
        function updated_today_dep_flights() {
            upto_today_dep_flights = ++upto_today_dep_flights;
            document.getElementById('count_total_Dep_FlightsT').innerHTML = upto_today_dep_flights.toLocaleString('en-IN');
            if (upto_today_dep_flights === <%=today_Dep_Flights%>) {
                clearInterval(counts_today_dep_flights);
            }
        }
/////////////////////////////////////// Total Flights //////////////////////////////////////////////////////////////////

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
 counterAnim("#count1", 10, 3500, 200);
 counterAnim("#count2", 1000, 54646, 2200);
 counterAnim("#count3", 5000, 9898, 2200);
 counterAnim("#count4", 500, 342329, 2200);
 counterAnim("#count5", 10, 5454, 2200);
 counterAnim("#count6", 50, 224, 2200);

counterAnim("#countArr", 50, <%=getIndianFormat(total_Arrival_Count)%>, 2200);
counterAnim("#countArrY", 50, <%=yesterday_Arrival_Count%>, 2200);
counterAnim("#countArrT", 50, <%=today_Arrival_Count%>, 2200);

counterAnim("#count_total_Dep_Count", 50, <%=getIndianFormat(total_Dep_Count)%>, 2200);
counterAnim("#count_total_Dep_CountY", 50, <%=yest_Dep_Count%>, 2200);
counterAnim("#count_total_Dep_CountT", 50, <%=today_Dep_Count%>, 2200);

counterAnim("#total_PAX", 50, <%=total_PAX_Count%>, 2200);
counterAnim("#total_PAX_Y", 50, <%=total_Yest_Count%>, 2200);
counterAnim("#total_PAX_T", 50, <%=total_Today_PAX_Count%>, 2200);

counterAnim("#countArrFlt", 50, <%=getIndianFormat(total_Arrival_Flights)%>, 2200);
counterAnim("#countArrFltY", 50, <%=yest_Flight_Count%>, 2200);
counterAnim("#countArrFltT", 50, <%=arr_Flight_Count%>, 2200);

counterAnim("#count_total_Dep_Flights", 50, <%=getIndianFormat(total_Dep_Flights)%>, 2200);
counterAnim("#count_total_Dep_FlightsY", 50, <%=yest_Dep_Flights%>, 2200);
counterAnim("#count_total_Dep_FlightsT", 50, <%=today_Dep_Flights%>, 2200);

counterAnim("#total_Flights", 50, <%=total_Flights_Count%>, 2200);
counterAnim("#total_Flights_Y", 50, <%=total_Flights_Count_Yest%>, 2200);
counterAnim("#total_Flights_T", 50, <%=total_Flights_Count_Today%>, 2200);
});
</script>
<%
} catch (Exception e) {
e.printStackTrace();
} 

finally 
	{
		try
		{
			if (con != null)
					{
					con.close();
					}
			/*if (ctx != null)
					{
					ctx.close();
					}*/
		}
	catch(Exception e)
	{
		//out.println(e.getMessage());
	}
}
%>
		</body>
		</html>
