<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>
	<%
	Connection con = null;
try {
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection("jdbc:oracle:thin:@172.16.1.51:1521:cics1", "imigration", "nicsi123");
	//con = DriverManager.getConnection("jdbc:oracle:thin:@10.248.168.201:1521:ICSSP", "imigration", "nicsi123");

	/*Context ctx = null;
	Connection con = null;
	ctx = new InitialContext();
	Context envCtx = (Context)ctx.lookup("java:comp/env");
	DataSource ds = (DataSource)envCtx.lookup("jdbc/im_pax_ds");
	con = ds.getConnection();*/


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

	String dashQuery = "";
	String depQuery = "";
	int today_Arrival_Count = 0;
	int daily_Dep_Count = 0;
	int total_Arrival_Count = 0;
	int yesterday_Arrival_Count = 0;
	int total_Dep_Count = 0;

	//////////////////////////////// Start : ICP_SRNO , DESC HB ////////////////////////////////////////////////////////

	ResultSet rs5 = null;
	Statement stmt5 = con.createStatement();

	String strSql5 = "SELECT ICP_SRNO, ICP_DESC FROM IM_ICP_LIST  order by ICP_DESC";
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
	
	//////////////////////////////// End : ICP_SRNO , DESC HB ////////////////////////////////////////////////////////

	//////////////////////////////// Start : ICP_SRNO , DESC HB ////////////////////////////////////////////////////////

	rs5 = null;
	stmt5 = con.createStatement();

	strSql5 = "SELECT NALTY_CODE, NALTY_DESC FROM IM_COUNTRY  order by NALTY_CODE";
	try
	{
		rs5 = stmt5.executeQuery(strSql5);
	}
	catch(SQLException e)
	{
		out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + strSql5 + "<BR><BR></b></font>");
	}

	HashMap<String, String> naltyValue = new HashMap<String,String>(); // For storing Serial No. and ICP Name.
	if(rs5.next()){
		do{			
			
			String naltyName = rs5.getString("NALTY_DESC") == null ? "" : rs5.getString("NALTY_DESC"); 
		/*	icpName = icpName.replace("AIRPORT",""); 
			icpName = icpName.replace("INTERNATIONAL",""); 
			icpName = icpName.replace("RAIL",""); 
			icpName = icpName.replace("LAND CHECKPOST","");*/
			String naltySoNo = rs5.getString("NALTY_CODE") == null ? "" : rs5.getString("NALTY_CODE");
					
			naltyValue.put( naltySoNo , naltyName);		
		}while(rs5.next());

		if(rs5!=null)
		{
			rs5.close();
			stmt5.close();
		}
	}
	
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

////////////////////	Arrival/Departure PAX Count	Tabs	/////////////////////////

	 java.util.Date yesterday_date_in_millis = new java.util.Date(System.currentTimeMillis()-1*24*60*60*1000);
	 String yesterday_date = vDateFormatYes.format(yesterday_date_in_millis);

	 String filter_icp = request.getParameter("icp") == null ? "All" : request.getParameter("icp");
	 String default_hrs = request.getParameter("default_hrs") == null ? "8" : request.getParameter("default_hrs");
	 displayHours = Integer.parseInt(default_hrs);

	 //out.println("kuhkihfayfdjhj" + filter_icp);
	 if(filter_icp.equals("")) filter_icp = "" + filter_icp + "";

	 String vishwaFilter = " where ICP_SRNO = '" + filter_icp + "'";
	 if(filter_icp.equals("All")) vishwaFilter = "";
	 else vishwaFilter = " where ICP_SRNO = '" + filter_icp + "'";
	 //out.println(vishwaFilter);

//=================================================
		int div_hgt = 200; 
		if(filter_icp.equals("All")) {dash = "All ICPs";  div_hgt = 600;}
		else{
			rsTemp = st_icp.executeQuery("SELECT ICP_SRNO, ICP_DESC FROM IM_ICP_LIST  order by ICP_DESC");
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
div.scroll-container /* To scroll the table */
{
	overflow:auto;
	white-space: nowrap;
	padding: 10px;
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
	document.entryfrm.action="im_cruise_dashboard.jsp?&icp="+document.entryfrm.compare_icp.value;
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
				document.entryfrm.action = "im_epassport_dashboard.jsp";
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
					<img src="Cruise_Clearance_Logo.png" width="100%" height="90%" alt="Cruise Clearance (e-LC) Dashboard" align="center;">
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
		  <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#collapsibleNavbar"><span class="navbar-toggler-icon"></span></button>
		  <div class="collapse navbar-collapse" id="collapsibleNavbar">
			<ul class="navbar-nav">
			  <li class="nav-item"><a href="#Home" class="scrollLink nav-link">Home</a></li>
			  <li class="nav-item dropdown"><a href="#Home" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Cruise Clearance (e-LC)</a>
			  <ul class="dropdown-menu">
			  <li> <a class="scrollLink dropdown-item" href="#ICP_1">All Seaports Cruise Footfall Statistics</a></li>
			  <li> <a class="scrollLink dropdown-item" href="#ICP_2">Yearly Seaport-wise Cruise Arrival Statistics</a></ul></li>
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

<%
			rsTemp = st_icp.executeQuery("SELECT ICP_SRNO, ICP_DESC FROM IM_ICP_LIST where ICP_SRNO in ('208', '224', '201', '283', '293') order by ICP_DESC");
			//rsTemp = st_icp.executeQuery("SELECT ICP_SRNO, ICP_DESC FROM IM_ICP_LIST order by ICP_DESC");
			while(rsTemp.next())
			{
%>
				<option value="<%=rsTemp.getString("ICP_SRNO")%>" <%if(filter_icp.equals(rsTemp.getString("ICP_SRNO"))){%> selected<%}%>><%=rsTemp.getString("ICP_DESC") + " " + rsTemp.getString("ICP_SRNO")%></option>
<%
			}
			 rsTemp.close();  
			  div_hgt = 200; 
			 if(filter_icp.equals("All")) {
				 div_hgt = 600;
			 }
%> 
			</select>
			&nbsp;&nbsp;&nbsp;
			<button class="btn btn-primary btn-sm" type="button" onClick="alert('!!! Functionality under Development !!!');"> Generate </button>
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


<%////////////////////////////////////////////////////////////////////////////////////
//=========================	 Cruise Clearance  tabs	=======================

int today_Dep_Count = 0;
int yest_Dep_Count = 0;
int total_PAX_Count = 0;
int total_Yest_Count = 0;
int total_Today_PAX_Count = 0;;

try {
	dashQuery = "select count(distinct SPECIAL_CRUISE_NAME||GRAND_TOTAL_RECORDS||extract(year from arrival_date)) as  cruise_count from im_dash_elc_stats";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

		total_Dep_Count = total_Dep_Count+rsTemp.getInt("cruise_count");

		//total_PAX_Count = total_Arrival_Count + total_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Cruise Count Exception");
}


%>
<br><br><br><br>
<br><br><br><br>

<div class="container-fluid">
<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-3">
	<table class="tableDesign">
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #6929c4;height:20px;">
			<th  style="text-align: center;background-color:#5521a0;border-color: #5521a0;width:40%; text-align: center;font-size: 35px;">&nbsp;Cruise&nbsp;Arrived&nbsp;</th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="count_total_Dep_Count" style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: center;font-size: 30px;color: #5521a0;"><%=total_Dep_Count%></td>
		</tr>
	</table>
</div>

</section>

<%//=========================	End - Cruise Clearance  tabs	=======================

//====================	Cruise Footfall Tabs	============================


	try {
		dashQuery = "select sum(TOTAL_RECORDS) as total_records from IM_DASH_ELC_STATS";
			//	out.println(dashQuery);

		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		while(rsTemp.next()) {

	     total_Arrival_Count = total_Arrival_Count+rsTemp.getInt("total_records");

		}
		//out.println(total_Arrival_Count);
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Cruise PAX Exception");
	}
		//out.println(total_Arrival_Count);

//=========================	End - Cruise Footfall  tabs	=======================%>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-3">
	<table class="tableDesign" width="50px">
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px;">
			<th  style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;font-size: 35px;">Cruise&nbsp;Footfall</th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="countArr" style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: center;font-size: 30px;color: #004076;"><%=total_Arrival_Count%></td>
		</tr>
	</table>
</div>
</div>
</div>
<%/////////////////////////////////////////////////////////////%>



<%
String SQLQUERY = "";
StringBuilder WeekDays = new StringBuilder();
StringBuilder weekArrPax = new StringBuilder();
StringBuilder weekDepPax = new StringBuilder();

StringBuilder YearDays = new StringBuilder();
StringBuilder YearArrPax = new StringBuilder();
StringBuilder YearDepPax = new StringBuilder();

StringBuilder TotalDays = new StringBuilder();
StringBuilder TotalArrPax = new StringBuilder();
StringBuilder TotalDepPax = new StringBuilder();

String strWeekDays = "";
String strweekArrPax = "";
String strweekDepPax = "";

String strYearDays = "";
String strYearArrPax = "";
String strYearDepPax = "";

String strTotalDays = "";
String strTotalArrPax = "";
String strTotalDepPax = "";

StringBuilder IcpPax = new StringBuilder();
StringBuilder ArrIcpPax = new StringBuilder();
StringBuilder DepIcpPax = new StringBuilder();
String strIcpPax = "";
String strArricp = "";
String strDepicp = "";

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

<%////////////////////////	Seaports Cruise Footfall Statistics - Start	///////////////////////%>
		<section id="ICP_1">
		<div class="pt-4" id="ICP_1"><br><br><br><br><br><br><br>
	<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>

				<tr id='head1'>
				<%if(filter_icp.equals("All")) {%>	
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">All Seaports Cruise Footfall Statistics</th>
				<%} else {%>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Cruise Footfall Statistics</th>
				<%} %>
				</tr>
				
			</thead>
			
		</table>
		</section>
<br>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-2">
		<table class="tableDesign" >
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #009688;height:12px;">
				<th style="text-align: center;background-color:#e81784;border-color: #ba126a;width:40%;">Year</th>
				<th style="text-align: center;background-color:#e81784;border-color: #ba126a;width:60%; text-align: right;">Cruise&nbsp;Footfall&nbsp;</th>
			</tr>
<%
	int all_ICP_Arr_Total = 0 ;
	int all_ICP_Dep_Total = 0 ;
	int all_ICP_Total = 0 ;
try
	{
	SQLQUERY = "";
	SQLQUERY = "select year,sum(GRAND_TOTAL_RECORDS) as total_pax_count from ( select distinct SPECIAL_CRUISE_NAME, GRAND_TOTAL_RECORDS, extract(year from arrival_date) as year from IM_DASH_ELC_STATS group by SPECIAL_CRUISE_NAME, GRAND_TOTAL_RECORDS ,extract(year from arrival_date) ) group by year order by 1 desc";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
			TotalDays.append("\"");
			TotalDays.append(rsTemp.getString("year"));
			TotalDays.append("\"");
			TotalDays.append(",");
			TotalArrPax.append(rsTemp.getInt("total_pax_count")+",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#fdecf5;border-color:#ba126a;width:40%; font-weight: bold;text-align: center;"><%=rsTemp.getString("year")%></td>
				<td style="background-color:#fdecf5;border-color:#ba126a;width:60%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("total_pax_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("total_pax_count"))%>&nbsp;</td>
			</tr>
<%
			all_ICP_Arr_Total = all_ICP_Arr_Total + rsTemp.getInt("total_pax_count");
		}
%>			<tr style="font-size: 16px;  text-align: right; color:#ba126a; border-color: #009688;height:12px;">
				<td style="background-color:#facee5;border-color:#ba126a;width:40%; font-weight: bold;text-align: center;">Total</td>
				<td style="background-color:#facee5;border-color:#ba126a;width:60%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Arr_Total)%>&nbsp;</td>
			</tr>
			<%
			rsTemp.close();
			psTemp.close();

			strTotalDays = TotalDays.toString();
			strTotalDays = strTotalDays.substring(0,strTotalDays.length()-1);
			strTotalArrPax = TotalArrPax.toString();
			strTotalArrPax = strTotalArrPax.substring(0,strTotalArrPax.length()-1);

	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Seaports Cruise Footfall Statistics - End	////////////////////////%>

<div class="col-sm-4">
<div class="card"style="border: solid 3px #e81784; border-radius: 20px;width:500px;height:300px;">
<div class="card-body" style="width:500px;height:300px;">
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->
	<canvas id="canvasPAX_Total" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #ffe6ef 100%);border-radius: 20px;height:300px;width:500px"></canvas>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strTotalDays%>],
		datasets: [{ 
			  label: "Footfall",
			  backgroundColor: "#e81784",
			  borderColor: "#e81784",
			  borderWidth: 1,
			  data: [<%=strTotalArrPax%>]
		}]
	};

// Options to display value on top of bars

	var myoptions = {
				
		responsive:true,
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph
						},
							gridLines: { 
								display:true,
								color: "#e81784",
								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph
						},
					gridLines: { 
							display:false,
							color: "#e81784"
								}

					}]
				},
				 title: {
						display: true,
							text:'Cruise Footfall Statistics',
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
						ctx.fillText(data, bar._model.x, bar._model.y-2);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasPAX_Total').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>

	<%///////////////////////////	 Seaports Cruise Footfall Statistics- End	///////////////////////////////%>







<%////////////////////////	Seaports Cruise Clearance Statistics - Start	///////////////////////%>

	<div class="col-sm-2">
		<table class="tableDesign" >
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #009688;height:12px;">
				<th style="text-align: center;background-color:#6e61b5;border-color: #4f4383;width:40%;">Year</th>
				<th style="text-align: center;background-color:#6e61b5;border-color: #4f4383;width:60%; text-align: right;">Cruise&nbsp;Arrived&nbsp;</th>
			</tr>
<%
	int cruise_Total = 0 ;
StringBuilder cruise_Year = new StringBuilder();
StringBuilder totalCruiseCount = new StringBuilder();

String strcruise_Year = "";
String strtotalCruiseCount = "";

try
	{
	SQLQUERY = "";
	SQLQUERY = "select year,count(GRAND_TOTAL_RECORDS) as total_cruise_count from ( select distinct SPECIAL_CRUISE_NAME, GRAND_TOTAL_RECORDS, extract(year from arrival_date) as year from IM_DASH_ELC_STATS group by SPECIAL_CRUISE_NAME, GRAND_TOTAL_RECORDS ,extract(year from arrival_date) ) group by year order by 1 desc";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
			cruise_Year.append("\"");
			cruise_Year.append(rsTemp.getString("year"));
			cruise_Year.append("\"");
			cruise_Year.append(",");
			totalCruiseCount.append(rsTemp.getInt("total_cruise_count")+",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#ebeaf5;border-color:#4f4383;width:40%; font-weight: bold;text-align: center;"><%=rsTemp.getString("year")%></td>
				<td style="background-color:#ebeaf5;border-color:#4f4383;width:60%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("total_cruise_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("total_cruise_count"))%>&nbsp;</td>
			</tr>
<%
			cruise_Total = cruise_Total + rsTemp.getInt("total_cruise_count");
		}
%>			<tr style="font-size: 16px;  text-align: right; color:#4f4383; border-color: #009688;height:12px;">
				<td style="background-color:#c9c4e3;border-color:#4f4383;width:40%; font-weight: bold;text-align: center;">Total</td>
				<td style="background-color:#c9c4e3;border-color:#4f4383;width:60%; font-weight: bold; text-align: right;"><%=getIndianFormat(cruise_Total)%>&nbsp;</td>
			</tr>
			<%
			rsTemp.close();
			psTemp.close();

			strcruise_Year = cruise_Year.toString();
			strcruise_Year = strcruise_Year.substring(0,strcruise_Year.length()-1);
			strtotalCruiseCount = totalCruiseCount.toString();
			strtotalCruiseCount = strtotalCruiseCount.substring(0,strtotalCruiseCount.length()-1);

	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Seaports Cruise Clearance Statistics - End	////////////////////////%>


<div class="col-sm-3">
<div class="card"style="border: solid 3px #776ab9; border-radius: 20px;width:500px;height:300px;">
<div class="card-body" style="width:500px;height:300px;">
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->
	<canvas id="canvasCruiseCount" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #e5e2f2 100%);border-radius: 20px;height:300px;width:500px"></canvas>
</div>
</div>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strcruise_Year%>],
		datasets: [{ 
			  label: "Cruise Arrived",
			  backgroundColor: "#776ab9",
			  borderColor: "#776ab9",
			  borderWidth: 1,
			  data: [<%=strtotalCruiseCount%>]
		}]
	};

// Options to display value on top of bars

	var myoptions = {
				
		responsive:true,
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#776ab9",
								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
							display:false,
							color: "#776ab9"
								}

					}]
				},
				 title: {
						display: true,
							text:'Cruise Arrived Statistics',
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
						ctx.fillText(data, bar._model.x, bar._model.y-2);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasCruiseCount').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>





<%////////////////////////	 Seaports Location-wise Cruise Clearance Statistics - Start	///////////////////////%>
		<section id="ICP_1">
		<div class="pt-4" id="ICP_2"><br><br><br><br><br><br><br>
	<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>

				<tr id='head1'>
				<%if(filter_icp.equals("All")) {%>	
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">Yearly Seaport-wise Cruise Arrival Statistics</th>
				<%} else {%>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Location-wise Cruise Clearance Statistics</th>
				<%} %>
				</tr>
				
			</thead>
			
		</table>
		</section>
<div class="grid-container">
<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-3">
		<table class="tableDesign" style="height:100px;">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			<tr style="font-size: 14px;  text-align: right; color:white; border-color: #009688;height:1px;">
				<th style="text-align: center;background-color:#B93160;border-color: #91264b;width:40%;">Year</th>
				<th style="text-align: center;background-color:#B93160;border-color: #91264b;width:60%; text-align: right;">Chennai&nbsp;</th>
				<th style="text-align: center;background-color:#B93160;border-color: #91264b;width:60%; text-align: right;">Mumbai&nbsp;</th>
				<th style="text-align: center;background-color:#B93160;border-color: #91264b;width:60%; text-align: right;">Goa&nbsp;</th>
				<th style="text-align: center;background-color:#B93160;border-color: #91264b;width:60%; text-align: right;">Cochin&nbsp;</th>
				<th style="text-align: center;background-color:#B93160;border-color: #91264b;width:60%; text-align: right;">Mangalore&nbsp;</th>
				<th style="text-align: center;background-color:#B93160;border-color: #91264b;width:60%; text-align: right;">Total&nbsp;</th>
			</tr>
<%
int cruise_Location_Total = 0 ;
int cruise_Location_Grand_Total = 0 ;
int chennai_Location_Total = 0 ;
int mumbai_Location_Total = 0 ;
int goa_Location_Total = 0 ;
int cochin_Location_Total = 0 ;
int mangalore_Location_Total = 0 ;
StringBuilder cruise_Location_Year = new StringBuilder();
StringBuilder chennaiCount = new StringBuilder();
StringBuilder mumbaiCount = new StringBuilder();
StringBuilder goaCount = new StringBuilder();
StringBuilder cochinCount = new StringBuilder();
StringBuilder mangaloreCount = new StringBuilder();

String strcruise_Location_Year = "";
String strchennaiCount = "";
String strmumbaiCount = "";
String strgoaCount = "";
String strcochinCount = "";
String strmangaloreCount = "";

try
	{
	SQLQUERY = "";
	SQLQUERY = "SELECT extract(year from arrival_date) as year, SUM( CASE WHEN SOURCE_SEAPORT = 'CHENNAI' or HOP_1_SEAPORT = 'CHENNAI' or HOP_2_SEAPORT = 'CHENNAI' or HOP_3_SEAPORT = 'CHENNAI' or DEPARTURE_SEAPORT = 'CHENNAI' THEN 1 ELSE 0 END ) Chennai, SUM( CASE WHEN SOURCE_SEAPORT = 'MUMBAI' or HOP_1_SEAPORT = 'MUMBAI' or HOP_2_SEAPORT = 'MUMBAI' or HOP_3_SEAPORT = 'MUMBAI' or DEPARTURE_SEAPORT = 'MUMBAI' THEN 1 ELSE 0 END ) Mumbai, SUM( CASE WHEN SOURCE_SEAPORT = 'GOA' or HOP_1_SEAPORT = 'GOA' or HOP_2_SEAPORT = 'GOA' or HOP_3_SEAPORT = 'GOA' or DEPARTURE_SEAPORT = 'GOA' THEN 1 ELSE 0 END ) Goa, SUM( CASE WHEN SOURCE_SEAPORT = 'COCHIN' or HOP_1_SEAPORT = 'COCHIN' or HOP_2_SEAPORT = 'COCHIN' or HOP_3_SEAPORT = 'COCHIN' or DEPARTURE_SEAPORT = 'COCHIN' THEN 1 ELSE 0 END ) Cochin, SUM( CASE WHEN SOURCE_SEAPORT = 'MANGALORE' or HOP_1_SEAPORT = 'MANGALORE' or HOP_2_SEAPORT = 'MANGALORE' or HOP_3_SEAPORT = 'MANGALORE' or DEPARTURE_SEAPORT = 'MANGALORE' THEN 1 ELSE 0 END ) Mangalore FROM (select distinct ARRIVAL_DATE,SPECIAL_CRUISE_NAME,SOURCE_SEAPORT,HOP_1_SEAPORT,HOP_2_SEAPORT,HOP_3_SEAPORT,DEPARTURE_SEAPORT from IM_DASH_ELC_STATS) GROUP BY extract(year from arrival_date) ORDER BY 1 DESC";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
			cruise_Location_Year.append("\"");
			cruise_Location_Year.append(rsTemp.getString("year"));
			cruise_Location_Year.append("\"");
			cruise_Location_Year.append(",");
			chennaiCount.append(rsTemp.getInt("Chennai")+",");
			mumbaiCount.append(rsTemp.getInt("Mumbai")+",");
			goaCount.append(rsTemp.getInt("Goa")+",");
			cochinCount.append(rsTemp.getInt("Cochin")+",");
			mangaloreCount.append(rsTemp.getInt("Mangalore")+",");

			chennai_Location_Total = chennai_Location_Total + rsTemp.getInt("Chennai");
			mumbai_Location_Total = mumbai_Location_Total + rsTemp.getInt("Mumbai");
			goa_Location_Total = goa_Location_Total + rsTemp.getInt("Goa");
			cochin_Location_Total = cochin_Location_Total + rsTemp.getInt("Cochin");
			mangalore_Location_Total = mangalore_Location_Total + rsTemp.getInt("Mangalore");

			cruise_Location_Total =  rsTemp.getInt("Chennai") + rsTemp.getInt("Mumbai") + rsTemp.getInt("Goa") + rsTemp.getInt("Cochin") + rsTemp.getInt("Mangalore");
			cruise_Location_Grand_Total =  cruise_Location_Grand_Total + rsTemp.getInt("Chennai") + rsTemp.getInt("Mumbai") + rsTemp.getInt("Goa") + rsTemp.getInt("Cochin") + rsTemp.getInt("Mangalore");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#f4d7e1;border-color:#91264b;width:10%; font-weight: bold;text-align: center;"><%=rsTemp.getString("year")%></td>
				<td style="background-color:#fdf6f8;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("Chennai") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("Chennai"))%>&nbsp;</td>
				<td style="background-color:#fdf6f8;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("Mumbai") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("Mumbai"))%>&nbsp;</td>
				<td style="background-color:#fdf6f8;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("Goa") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("Goa"))%>&nbsp;</td>
				<td style="background-color:#fdf6f8;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("Cochin") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("Cochin"))%>&nbsp;</td>
				<td style="background-color:#fdf6f8;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("Mangalore") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("Mangalore"))%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#91264b;width:10%; font-weight: bold; text-align: right;color:#B93160;font-size:14px;"><%=cruise_Location_Total == 0 ? "&nbsp;": getIndianFormat(cruise_Location_Total)%>&nbsp;</td>
			</tr>
<%

		}
%>			<tr style="font-size: 14px;  text-align: right; color:#B93160; border-color: #009688;height:12px;">
				<td style="background-color:#f4d7e1;border-color:#91264b;width:10%; font-weight: bold;text-align: center;">Total</td>
				<td style="background-color:#f4d7e1;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=getIndianFormat(chennai_Location_Total)%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=getIndianFormat(mumbai_Location_Total)%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=getIndianFormat(goa_Location_Total)%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=getIndianFormat(cochin_Location_Total)%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#91264b;width:16%; font-weight: bold; text-align: right;"><%=getIndianFormat(mangalore_Location_Total)%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#91264b;width:10%; font-weight: bold; text-align: right;"><%=getIndianFormat(cruise_Location_Grand_Total)%>&nbsp;</td>
			</tr>
			<%
			rsTemp.close();
			psTemp.close();

			strcruise_Location_Year = cruise_Location_Year.toString();
			strcruise_Location_Year = strcruise_Location_Year.substring(0,strcruise_Location_Year.length()-1);

			strchennaiCount = chennaiCount.toString();
			strchennaiCount = strchennaiCount.substring(0,strchennaiCount.length()-1);

			strmumbaiCount = mumbaiCount.toString();
			strmumbaiCount = strmumbaiCount.substring(0,strmumbaiCount.length()-1);

			strgoaCount = goaCount.toString();
			strgoaCount = strgoaCount.substring(0,strgoaCount.length()-1);

			strcochinCount = cochinCount.toString();
			strcochinCount = strcochinCount.substring(0,strcochinCount.length()-1);

			strmangaloreCount = mangaloreCount.toString();
			strmangaloreCount = strmangaloreCount.substring(0,strmangaloreCount.length()-1);

	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>

<%///////////////////////	Table -  Seaports Location-wise Cruise Clearance Statistics - End	////////////////////////%>

	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<%/////////////////////Start - Chennai /////////////////////////////////%>

<div class="col-sm-2">
<div class="card"style="border: solid 3px #B93160; border-radius: 20px;width:300px;height:200px;">
<div class="card-body" style="width:300px;height:200px;">
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->
	<canvas id="canvasCruiseLocationCount" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #f0c9d6 100%);border-radius: 20px;height:200px;width:300px"></canvas>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strcruise_Location_Year%>],
		datasets: [{ 
			  label: "Chennai",
			  backgroundColor: "#B93160",
			  borderColor: "#B93160",
			  borderWidth: 1,
			  data: [<%=strchennaiCount%>]
		}		  ]
	};

// Options to display value on top of bars

	var myoptions = {
				
		responsive:true,
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#f0c9d6",
								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
							display:false,
							color: "#f0c9d6"
								}

					}]
				},
				 title: {
						display: true,
							text:'Chennai Seaport Cruise Clearance',
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
				ctx.fillStyle = "#0F292F";
				ctx.textBaseline = 'bottom';
				ctx.font = "bold 10px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
						ctx.fillText(data, bar._model.x, bar._model.y-2);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasCruiseLocationCount').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>
<%/////////////////////End - Chennai /////////////////////////////////%>


<%/////////////////////Start - Mumbai /////////////////////////////////%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<div class="col-sm-2">
<div class="card"style="border: solid 3px #776ab9; border-radius: 20px;width:300px;height:200px;">
<div class="card-body" style="width:300px;height:200px;">
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->
	<canvas id="canvasCruiseMumbaiCount" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #e5e2f2 100%);border-radius: 20px;height:200px;width:300px"></canvas>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strcruise_Location_Year%>],
		datasets: [{ 
			  label: "Mumbai",
			  backgroundColor: "#776ab9",
			  borderColor: "#776ab9",
			  borderWidth: 1,
			  data: [<%=strmumbaiCount%>]
		}		  ]
	};

// Options to display value on top of bars

	var myoptions = {
				
		responsive:true,
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#e5e2f2",
								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
							display:false,
							color: "#e5e2f2"
								}

					}]
				},
				 title: {
						display: true,
							text:'Mumbai Seaport Cruise Clearance',
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
				ctx.fillStyle = "#0F292F";
				ctx.textBaseline = 'bottom';
				ctx.font = "bold 10px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
						ctx.fillText(data, bar._model.x, bar._model.y-2);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasCruiseMumbaiCount').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>


<%///////////////////// End - Mumbai /////////////////////////////////%>




<%/////////////////////Start - Goa /////////////////////////////////%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-2">
<div class="card"style="border: solid 3px #014F86; border-radius: 20px;width:300px;height:200px;">
<div class="card-body" style="width:300px;height:200px;">
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->
	<canvas id="canvasCruiseGoaCount" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #bae6ff 100%);border-radius: 20px;height:200px;width:300px"></canvas>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strcruise_Location_Year%>],
		datasets: [{ 
			  label: "Goa",
			  backgroundColor: "#014F86",
			  borderColor: "#014F86",
			  borderWidth: 1,
			  data: [<%=strgoaCount%>]
		}		  ]
	};

// Options to display value on top of bars

	var myoptions = {
				
		responsive:true,
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#bae6ff",
								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
							display:false,
							color: "#bae6ff"
								}
					}]
				},
				 title: {
						display: true,
							text:'Goa Seaport Cruise Clearance',
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
				ctx.fillStyle = "#0F292F";
				ctx.textBaseline = 'bottom';
				ctx.font = "bold 10px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
						ctx.fillText(data, bar._model.x, bar._model.y-2);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasCruiseGoaCount').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>


<%///////////////////// End - Goa /////////////////////////////////%>



<%/////////////////////Start - Cochin  /////////////////////////////////%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;


<div class="col-sm-2">
<div class="card"style="border: solid 3px #e81784; border-radius: 20px;width:300px;height:200px;">
<div class="card-body" style="width:300px;height:200px;">
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->
	<canvas id="canvasCruiseCochinCount" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #ffe6ef 100%);border-radius: 20px;height:200px;width:300px"></canvas>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strcruise_Location_Year%>],
		datasets: [{ 
			  label: "Cochin",
			  backgroundColor: "#e81784",
			  borderColor: "#e81784",
			  borderWidth: 1,
			  data: [<%=strcochinCount%>]
		}		  ]
	};

// Options to display value on top of bars

	var myoptions = {
				
		responsive:true,
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#ffe6ef",
								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
							display:false,
							color: "#ffe6ef"
								}
					}]
				},
				 title: {
						display: true,
							text:'Cochin Seaport Cruise Clearance',
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
				ctx.fillStyle = "#0F292F";
				ctx.textBaseline = 'bottom';
				ctx.font = "bold 10px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
						ctx.fillText(data, bar._model.x, bar._model.y-2);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasCruiseCochinCount').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>


<%///////////////////// End - Cochin  /////////////////////////////////%>

<%/////////////////////Start - Mangalore  /////////////////////////////////%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;



<div class="col-sm-2">
<div class="card"style="border: solid 3px #007d79; border-radius: 20px;width:300px;height:200px;">
<div class="card-body" style="width:300px;height:200px;">
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->
	<canvas id="canvasCruiseMangaloreCount" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #cdf7f7 100%);border-radius: 20px;height:200px;width:300px"></canvas>
</div>
</div>
</div>
</div>
</div>
 <script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strcruise_Location_Year%>],
		datasets: [{ 
			  label: "Mangalore",
			  backgroundColor: "#007d79",
			  borderColor: "#007d79",
			  borderWidth: 1,
			  data: [<%=strmangaloreCount%>]
		}		  ]
	};

// Options to display value on top of bars

	var myoptions = {
				
		responsive:true,
			maintainAspectRatio: false,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#cdf7f7",
								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
							display:false,
							color: "#cdf7f7"
								}
					}]
				},
				 title: {
						display: true,
							text:'Mangalore Seaport Cruise Clearance',
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
				ctx.fillStyle = "#0F292F";
				ctx.textBaseline = 'bottom';
				ctx.font = "bold 10px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
						ctx.fillText(data, bar._model.x, bar._model.y-2);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvasCruiseMangaloreCount').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>


<%///////////////////// End - Mangalore   /////////////////////////////////%>

<%////////////////////////////////////////////////////////////////%>

		<section id="ICP_1">
		<div class="pt-4" id="ICP_1"><br><br><br><br><br><br><br>
	<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>

				<tr id='head1'>
				<%if(filter_icp.equals("All")) {%>	
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">&nbsp;</th>
				<%} else {%>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> &nbsp;</th>
				<%} %>
				</tr>
				
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
            if (upto_arr_total_pax === <%=total_Arrival_Count%>) {
                clearInterval(counts_arr_total_pax);
            }
        }

let counts_dep_pax = setInterval(updated_dep_pax);
        let upto_dep_pax = <%=(total_Dep_Count)-400%>;
        function updated_dep_pax() {
            upto_dep_pax = ++upto_dep_pax;
            document.getElementById('count_total_Dep_Count').innerHTML = upto_dep_pax.toLocaleString('en-IN');
            if (upto_dep_pax === <%=total_Dep_Count%>) {
                clearInterval(counts_dep_pax);
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


counterAnim("#countArr", 50, <%=getIndianFormat(total_Arrival_Count)%>, 2200);
counterAnim("#count_total_Dep_Count", 50, <%=getIndianFormat(total_Dep_Count)%>, 2200);

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
