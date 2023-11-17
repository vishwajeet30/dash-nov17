<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>Advanced Passenger Information System</title>
<!-- Tell the browser to be responsive to screen width -->
<meta http-equiv="refresh" content="3600"> <!-- auto refresh the page after 300 seconds -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
<!-- Bootstrap 3.3.7 -->

<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.7 -->
  <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="bower_components/font-awesome/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="bower_components/Ionicons/css/ionicons.min.css">
  <!-- Morris charts -->
  <link rel="stylesheet" href="bower_components/morris.js/morris.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="dist/css/skins/_all-skins.min.css">
<link rel="stylesheet" href="assets/css/dashboard_font.css">
<!--select count(1) from IM_APIS_PAX where FLIGHT_SCH_ARR_DATE >= to_date('01/01/2023','dd/MM/yyyy') and FLIGHT_SCH_ARR_DATE <= to_date('15/08/2023','dd/MM/yyyy');

select count(1) from IM_APIS_PAX_DEP where FLIGHT_SCH_ARR_DATE >= to_date('01/01/2023','dd/MM/yyyy') and FLIGHT_SCH_ARR_DATE <= to_date('15/08/2023','dd/MM/yyyy');


select count(1) as apis_flight from (select DISTINCT FLIGHT_SCH_ARR_DATE, pax_flight_no from im_apis_pax where FLIGHT_SCH_ARR_DATE >= to_date('01/01/2023','dd/MM/yyyy') and FLIGHT_SCH_ARR_DATE <= to_date('15/08/2023','dd/MM/yyyy'))

select count(1) as apis_flight_dep from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE >= to_date('01/01/2023','dd/MM/yyyy') and FLIGHT_SCH_ARR_DATE <= to_date('15/08/2023','dd/MM/yyyy'))-->
<script src="js/Charts.js"></script>
<script src="bar.js" type="text/javascript"></script>

<style>

.button {
	border: none;
	padding: 8px 8px;
	margin: 4px 2px;
	display: inline;
}

.button2 {
	background-color: #00a65a;
} /* Blue */
.button4 {
	background-color: #f56954;
	color: black;
} /* Gray */
.button1 {
	background-color: #3c8dbc;
} /* Blue */
.button3 {
	background-color: #a0d0e0;
	color: black;
} /* Gray */
</style>
<style>
* {
	box-sizing: border-box;
}

body {
	font-family: Verdana, sans-serif;
}

.mySlides {
	display: none;
}

img {
	vertical-align: middle;
}

/* Slideshow container */
.slideshow-container {
	max-width: 800px;
	position: relative;
	margin: auto;
	max-height: 500px;
}

/* Caption text */
.text {
	color: #f2f2f2;
	font-size: 15px;
	padding: 8px 12px;
	position: absolute;
	bottom: 8px;
	width: 60%;
	text-align: center;
}

/* Number text (1/3 etc) */
.numbertext {
	color: #f2f2f2;
	font-size: 12px;
	padding: 8px 12px;
	position: absolute;
	top: 0;
}

/* The dots/bullets/indicators */
.dot {
	height: 15px;
	width: 15px;
	margin: 0 2px;
	background-color: #bbb;
	border-radius: 50%;
	display: inline-block;
	transition: background-color 0.6s ease;
}

.active {
	background-color: #717171;
}

/* Fading animation */
.fade {
	animation-name: fade;
	animation-duration: 1.5s;
}

@
keyframes fade {
	from {opacity: .4
}

to {
	opacity: 1
}

}

/* On smaller screens, decrease text size */
@media only screen and (max-width: 300px) {
	.text {
		font-size: 11px
	}
}
</style>
<%@page import="java.sql.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%!
/* public String getIndianFormat(long num)
{
	String convertNumber = "";
	int digitCount = 1;
	do{
		long currentDigit = num%10;
		num = num /10;
		if(digitCount%2 == 0 && digitCount != 2)
			convertNumber = currentDigit+ "," + convertNumber;
		else
			convertNumber = currentDigit+convertNumber;
		digitCount++;
		}while(num>0);
	return convertNumber;
}
 */
%>

<%

long arr_apis = 0;
long arr_apis_flight = 0;
long dep_apis = 0;
long dep_apis_flight = 0;

long yes_arr_apis_pax = 0;
long yes_dep_apis_pax = 0;
long yes_apis_flight = 0;
long yes_apis_flight_dep = 0;

long arr_apis_pax = 0;
long dep_apis_pax = 0;
long arr_apis_pax_str = 0;
long dep_apis_pax_str = 0;
long total_apis_pax_str = 0;
long apis_flight = 0;
long apis_flight_dep = 0;

Connection con =null;
Connection con1 =null;
PreparedStatement psTemp = null;
PreparedStatement psTemp1 = null;
ResultSet rsTemp = null;
ResultSet rsTemp1 = null;
PreparedStatement stmt = null;
ResultSet rs = null;
PreparedStatement stmt1 = null;
ResultSet rs1 = null;
String yesterday_date = "";
String graph_date = "";
String graph_pax = "";
String graph_pax_dep = "";
String last_update_date = "";
StringBuilder arr_date = new StringBuilder();
StringBuilder pax_arr = new StringBuilder();
StringBuilder pax_dep = new StringBuilder();
SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy"); 
SimpleDateFormat formatter1 = new SimpleDateFormat("MMM-dd"); 
SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd"); 
try{
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con=DriverManager.getConnection(  
			"jdbc:oracle:thin:@10.248.168.201:1521:ICSSP","imigration","nicsi123");
	con1=DriverManager.getConnection(  
			"jdbc:oracle:thin:@10.248.168.219:1521:CFB1","imigration","nicsi123");

	stmt=con.prepareStatement("select ARR_APIS,ARR_APIS_FLIGHTS,DEP_APIS,DEP_APIS_FLIGHTS,LAST_UPDATE from IM_DASHBOARD_APIS_STATS");  
	rs=stmt.executeQuery();  
	while(rs.next())
	{ 
		if(rs.getString("LAST_UPDATE") != null)
			last_update_date = formatter.format(rs.getDate("LAST_UPDATE"));
		if(rs.getString("ARR_APIS") != null)
			arr_apis = arr_apis+rs.getInt("ARR_APIS");
		
		if(rs.getString("ARR_APIS_FLIGHTS") != null)
			arr_apis_flight = arr_apis_flight+rs.getInt("ARR_APIS_FLIGHTS");
		
		if(rs.getString("DEP_APIS") != null)
			dep_apis = dep_apis+rs.getInt("DEP_APIS");
		
		if(rs.getString("DEP_APIS_FLIGHTS") != null)
			dep_apis_flight = dep_apis_flight+rs.getInt("DEP_APIS_FLIGHTS");
		
	
	}
	rs.close();
	stmt.close();
	////////////////////////////////////////////////////////22/08/2023
	stmt1=con1.prepareStatement("select count(1) as apis_pax from im_apis_pax where FLIGHT_SCH_ARR_DATE > TO_DATE('"+last_update_date+"','dd/MM/yyyy')");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			arr_apis = arr_apis+rs1.getInt("apis_pax");
			
		}
		rs1.close();
		stmt1.close();

		stmt1=con1.prepareStatement("select count(1) as apis_pax_dep from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE > TO_DATE('"+last_update_date+"','dd/MM/yyyy')");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			dep_apis = dep_apis+rs1.getInt("apis_pax_dep");
			
		}
		rs1.close();
		stmt1.close();

		stmt1=con1.prepareStatement("select count(1) as apis_flight from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax where FLIGHT_SCH_ARR_DATE > TO_DATE('"+last_update_date+"','dd/MM/yyyy'))");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			arr_apis_flight = arr_apis_flight+rs1.getInt("apis_flight");
			
		}
		rs1.close();
		stmt1.close();
		stmt1=con1.prepareStatement("select count(1) as apis_flight_dep from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE > TO_DATE('"+last_update_date+"','dd/MM/yyyy'))");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			dep_apis_flight = dep_apis_flight+rs1.getInt("apis_flight_dep");
			
		}
		rs1.close();
		stmt1.close();
	////////////////////////////////////////////////////////22/08/2023
	
	stmt=con.prepareStatement("select sysdate-1 from dual");  
	rs=stmt.executeQuery();  
	if(rs.next())
	{ 
		yesterday_date = formatter.format(rs.getDate("sysdate-1"));

		stmt1=con1.prepareStatement("select count(1) as apis_pax from im_apis_pax where FLIGHT_SCH_ARR_DATE = TO_DATE('"+yesterday_date+"','dd/MM/yyyy')");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			yes_arr_apis_pax = rs1.getInt("apis_pax");
			
		}
		rs1.close();
		stmt1.close();
		stmt1=con1.prepareStatement("select count(1) as apis_pax_dep from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+yesterday_date+"','dd/MM/yyyy')");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			yes_dep_apis_pax = rs1.getInt("apis_pax_dep");
			
		}
		rs1.close();
		stmt1.close();

		stmt1=con1.prepareStatement("select count(1) as apis_flight from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax where FLIGHT_SCH_ARR_DATE = TO_DATE('"+yesterday_date+"','dd/MM/yyyy'))");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			yes_apis_flight = rs1.getInt("apis_flight");
			
		}
		rs1.close();
		stmt1.close();

		stmt1=con1.prepareStatement("select count(1) as apis_flight_dep from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+yesterday_date+"','dd/MM/yyyy'))");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			yes_apis_flight_dep = rs1.getInt("apis_flight_dep");
			
		}
		rs1.close();
		stmt1.close();

		/////////////////////////////////////////
		stmt1=con1.prepareStatement("select count(1) as apis_pax from im_apis_pax where FLIGHT_SCH_ARR_DATE = trunc(sysdate)");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			arr_apis_pax = rs1.getInt("apis_pax");
			if(arr_apis_pax > 2000) arr_apis_pax_str = arr_apis_pax-1000;
			
		}
		rs1.close();
		stmt1.close();
		stmt1=con1.prepareStatement("select count(1) as apis_pax_dep from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = trunc(sysdate)");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			dep_apis_pax = rs1.getInt("apis_pax_dep");
			if(dep_apis_pax > 2000) dep_apis_pax_str = dep_apis_pax-1000;
			
		}
		rs1.close();
		stmt1.close();
        if(arr_apis_pax+dep_apis_pax > 3000) total_apis_pax_str = (arr_apis_pax+dep_apis_pax)-2000;


		stmt1=con1.prepareStatement("select count(1) as apis_flight from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax where FLIGHT_SCH_ARR_DATE = trunc(sysdate))");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			apis_flight = rs1.getInt("apis_flight");
			
		}
		rs1.close();
		stmt1.close();

		stmt1=con1.prepareStatement("select count(1) as apis_flight_dep from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = trunc(sysdate))");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			apis_flight_dep = rs1.getInt("apis_flight_dep");
			
		}
		rs1.close();
		stmt1.close();
		
	}
	rs.close();
	stmt.close();
	
	/*stmt1=con1.prepareStatement("select FLIGHT_SCH_ARR_DATE,count(1) as apis_pax from im_apis_pax where FLIGHT_SCH_ARR_DATE >= trunc(sysdate-7) group by FLIGHT_SCH_ARR_DATE");
		rs1=stmt1.executeQuery();  
		while(rs1.next())
		{ 
			arr_date.append("'"+formatter.format(rs1.getDate("FLIGHT_SCH_ARR_DATE"))+"',");
			pax_arr.append(rs1.getString("apis_pax")+",");

			stmt=con1.prepareStatement("select count(1) as apis_pax_dep from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+formatter.format(rs1.getDate("FLIGHT_SCH_ARR_DATE"))+"','dd/MM/yyyy')");
			//out.println("select count(1) as apis_pax_dep from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+rs1.getDate("FLIGHT_SCH_ARR_DATE")+"','dd/MM/yyyy')");
			rs=stmt.executeQuery();  
			if(rs.next())
			{ 
				pax_dep.append(rs.getString("apis_pax_dep")+",");
				
			}
			rs.close();
			stmt.close();
		}
		rs1.close();
		stmt1.close();
		//out.println(arr_date.toString().length());
		//out.println(pax_arr.toString().length());
	graph_date = (arr_date.toString()).substring(0,arr_date.toString().length()-1);
    graph_pax = (pax_arr.toString()).substring(0,pax_arr.toString().length()-1);
	graph_pax_dep = (pax_dep.toString()).substring(0,pax_dep.toString().length()-1);
*/
   
%>
 <script>
        let counts = setInterval(updated);
        let upto = <%=arr_apis-400%>;
      
        function updated() {
            upto = ++upto;
            document.getElementById('arr_apis').innerHTML = upto.toLocaleString('en-IN');
            if (upto === <%=arr_apis%>) {
            	
                clearInterval(counts);
            }
        }
        
        
        let counts1 = setInterval(updated1);
        let upto1 = <%=arr_apis_flight-400%>;
        function updated1() {
            upto1 = ++upto1;
            document.getElementById('arr_apis_flight').innerHTML = upto1.toLocaleString('en-IN');
            if (upto1 === <%=arr_apis_flight%>) {
                clearInterval(counts1);
            }
        }
        let counts2 = setInterval(updated2);
        let upto2 = <%=dep_apis-400%>;
        function updated2() {
            upto2 = ++upto2;
            document.getElementById('dep_apis').innerHTML = upto2.toLocaleString('en-IN');
            if (upto2 === <%=dep_apis%>) {
                clearInterval(counts2);
            }
        }
        let counts3 = setInterval(updated3);
        let upto3 = <%=dep_apis_flight-400%>;
        function updated3() {
            upto3 = ++upto3;
            document.getElementById('dep_apis_flight').innerHTML = upto3.toLocaleString('en-IN');
            if (upto3 === <%=dep_apis_flight%>) {
                clearInterval(counts3);
            }
        }
        let counts4 = setInterval(updated4);
        let upto4 = <%=(arr_apis+dep_apis)-400%>;
        function updated4() {
            upto4 = ++upto4;
            document.getElementById('apistotal').innerHTML = upto4.toLocaleString('en-IN');
            if (upto4 === <%=arr_apis+dep_apis%>) {
                clearInterval(counts4);
            }
        }
        let counts5 = setInterval(updated5);
        let upto5 = <%=(dep_apis_flight+arr_apis_flight)-400%>;
        function updated5() {
            upto5 = ++upto5;
            document.getElementById('apisflighttotal').innerHTML = upto5.toLocaleString('en-IN');
            if (upto5 === <%=dep_apis_flight+arr_apis_flight%>) {
                clearInterval(counts5);
            }
        }
		let arr_pax = setInterval(arr_paxupdated);
        let uptoarr_pax = <%=(yes_arr_apis_pax)%>;
        function arr_paxupdated() {
           // uptoarr_pax = ++uptoarr_pax;
            document.getElementById('yes_arr_apis_pax').innerHTML = uptoarr_pax.toLocaleString('en-IN');
            if (uptoarr_pax === <%=yes_arr_apis_pax%>) {
                clearInterval(arr_pax);
            }
        }
		let dep_pax = setInterval(dep_paxupdated);
        let uptodep_pax = <%=(yes_dep_apis_pax)%>;
        function dep_paxupdated() {
            //uptodep_pax = ++uptodep_pax;
            document.getElementById('yes_dep_apis_pax').innerHTML = uptodep_pax.toLocaleString('en-IN');
            if (uptodep_pax === <%=yes_dep_apis_pax%>) {
                clearInterval(dep_pax);
            }
        }

		let pax_total = setInterval(total_paxupdated);
        let uptototal_pax = <%=(yes_arr_apis_pax+yes_dep_apis_pax)%>;
        function total_paxupdated() {
           // uptototal_pax = ++uptototal_pax;
            document.getElementById('yes_apis_pax_total').innerHTML = uptototal_pax.toLocaleString('en-IN');
            if (uptototal_pax === <%=yes_arr_apis_pax+yes_dep_apis_pax%>) {
                clearInterval(pax_total);
            }
        }

		let apis_flight = setInterval(flight_paxupdated);
        let uptoflight = <%=yes_apis_flight%>;
        function flight_paxupdated() {
           // uptoflight = ++uptoflight;
            document.getElementById('yes_apis_flight').innerHTML = uptoflight.toLocaleString('en-IN');
            if (uptoflight === <%=yes_apis_flight%>) {
                clearInterval(apis_flight);
            }
        }

		let apis_flight_dep = setInterval(flight_dep_paxupdated);
        let uptoflight_dep = <%=yes_apis_flight_dep%>;
        function flight_dep_paxupdated() {
            //uptoflight_dep = ++uptoflight_dep;
            document.getElementById('yes_apis_flight_dep').innerHTML = uptoflight_dep.toLocaleString('en-IN');
            if (uptoflight_dep === <%=yes_apis_flight_dep%>) {
                clearInterval(apis_flight_dep);
            }
        }
        
		let total_flight = setInterval(total_flightupdated);
        let uptototal_flight = <%=(yes_apis_flight+yes_apis_flight_dep)%>;
        function total_flightupdated() {
            //uptototal_flight = ++uptototal_flight;
            document.getElementById('yes_apis_flight_total').innerHTML = uptototal_flight.toLocaleString('en-IN');
            if (uptototal_flight === <%=(yes_apis_flight+yes_apis_flight_dep)%>) {
                clearInterval(total_flight);
            }
        }
		////////////////////////////////////////////////////////
		let arr_paxt = setInterval(arr_paxtupdated);
        let uptoarr_paxt = <%=arr_apis_pax_str%>;
        function arr_paxtupdated() {
           // uptoarr_paxt = ++uptoarr_paxt;
            document.getElementById('arr_apis_pax').innerHTML = uptoarr_paxt.toLocaleString('en-IN');
            if (uptoarr_paxt === <%=arr_apis_pax%>) {
                clearInterval(arr_paxt);
            }
        }
		let dep_paxt = setInterval(dep_paxtupdated);
        let uptodep_paxt = <%=dep_apis_pax_str%>;
        function dep_paxtupdated() {
            //uptodep_paxt = ++uptodep_paxt;
            document.getElementById('dep_apis_pax').innerHTML = uptodep_paxt.toLocaleString('en-IN');
            if (uptodep_paxt === <%=dep_apis_pax%>) {
                clearInterval(dep_paxt);
            }
        }

		let pax_totalt = setInterval(total_paxtupdated);
        let uptototal_paxt = <%=total_apis_pax_str%>;
        function total_paxtupdated() {
          //  uptototal_paxt = ++uptototal_paxt;
            document.getElementById('apis_pax_total').innerHTML = uptototal_paxt.toLocaleString('en-IN');
            if (uptototal_paxt === <%=arr_apis_pax+dep_apis_pax%>) {
                clearInterval(pax_totalt);
            }
        }

		let apis_flightt = setInterval(flight_paxupdatedt);
        let uptoflightt = <%=apis_flight%>;
        function flight_paxupdatedt() {
            //uptoflightt = ++uptoflightt;
            document.getElementById('apis_flight').innerHTML = uptoflightt.toLocaleString('en-IN');
            if (uptoflightt === <%=apis_flight%>) {
                clearInterval(apis_flightt);
            }
        }

		let apis_flight_dept = setInterval(flight_dep_paxupdatedt);
        let uptoflight_dept = <%=apis_flight_dep%>;
        function flight_dep_paxupdatedt() {
            //uptoflight_dept = ++uptoflight_dept;
            document.getElementById('apis_flight_dep').innerHTML = uptoflight_dept.toLocaleString('en-IN');
            if (uptoflight_dept === <%=apis_flight_dep%>) {
                clearInterval(apis_flight_dept);
            }
        }
        
		let total_flightt = setInterval(total_flightupdatedt);
        let uptototal_flightt = <%=apis_flight+apis_flight_dep%>;
        function total_flightupdatedt() {
            //uptototal_flightt = ++uptototal_flightt;
            document.getElementById('apis_flight_total').innerHTML = uptototal_flightt.toLocaleString('en-IN');
            if (uptototal_flightt === <%=apis_flight+apis_flight_dep%>) {
                clearInterval(total_flightt);
            }
        }

		
    </script>
</head>
<body class="hold-transition skin-blue sidebar-mini">

	<!-- Content Wrapper. Contains page content -->
	<%@include file="header_apis.html"%>


<section class="content" style="padding: 1px;">

<div class="container-fluid" style="padding: 1px;">

<%
String SQLQUERY = "";

StringBuilder TotalDays = new StringBuilder();
StringBuilder TotalArrPax = new StringBuilder();
StringBuilder TotalDepPax = new StringBuilder();

String strTotalDays = "";
String strTotalArrPax = "";
String strTotalDepPax = "";



%>

	<%//////////////////////////////////////////////////////////////////////////////////////////////////////////////%>



<%

try
	{
	SQLQUERY = "";
	SQLQUERY = "select count(1) as apis_pax,FLIGHT_SCH_ARR_DATE from im_apis_pax where FLIGHT_SCH_ARR_DATE > trunc(sysdate-8) group by FLIGHT_SCH_ARR_DATE";
	
	psTemp1 = con.prepareStatement(SQLQUERY);
	rsTemp1 = psTemp1.executeQuery();
	while (rsTemp1.next())
		{

				psTemp=con.prepareStatement("select count(1) as apis_pax_dep from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+formatter.format(rsTemp1.getDate("FLIGHT_SCH_ARR_DATE"))+"','dd/MM/yyyy')");
				rsTemp=psTemp.executeQuery();  
			if(rsTemp.next())
			{	
		TotalDays.append("\"");
			TotalDays.append(formatter1.format(rsTemp1.getDate("FLIGHT_SCH_ARR_DATE"))); 		
			//out.println(TotalDays.toString()+"<BR>");
			TotalDays.append("\"");
			TotalDays.append(",");
             //out.println(TotalDays.toString()+"<BR>");
			TotalArrPax.append(rsTemp1.getInt("apis_pax")+",");
			TotalDepPax.append(rsTemp.getInt("apis_pax_dep")+",");

			//out.println(TotalArrPax.toString()+"<BR>");
				//out.println(TotalDepPax.toString()+"<BR>");
			
			}
			rsTemp.close();
			psTemp.close();
		 
		
		}
		rsTemp1.close();
		psTemp1.close();
			strTotalDays = TotalDays.toString();
			//
			strTotalDays = strTotalDays.substring(0,strTotalDays.length()-1);
			strTotalArrPax = TotalArrPax.toString();
			strTotalArrPax = strTotalArrPax.substring(0,strTotalArrPax.length()-1);
			strTotalDepPax = TotalDepPax.toString();
			strTotalDepPax = strTotalDepPax.substring(0,strTotalDepPax.length()-1);

			
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
	

<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>



<%///////////////////////////////////////////////////////////////////////////////////////////%>
<%
String SQLQUERY_Flts = "";

StringBuilder TotalDaysFlts = new StringBuilder();
StringBuilder TotalArrFlts = new StringBuilder();
StringBuilder TotalDepFlts = new StringBuilder();

String strTotalDaysFlts = "";
String strTotalArrFlts = "";
String strTotalDepFlts = "";
%>
<%//////////////////////////////////////////////////////////////////////////////////////////////////////////////%>



<%

try
	{
	SQLQUERY_Flts = "";
	SQLQUERY_Flts = "select count(1) as apis_flight,FLIGHT_SCH_ARR_DATE from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax where FLIGHT_SCH_ARR_DATE > trunc(sysdate-8)) group by FLIGHT_SCH_ARR_DATE";
	
	psTemp1 = con.prepareStatement(SQLQUERY_Flts);
	rsTemp1 = psTemp1.executeQuery();
	while (rsTemp1.next())
		{

				psTemp=con.prepareStatement("select count(1) as apis_flight_dep from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+formatter.format(rsTemp1.getDate("FLIGHT_SCH_ARR_DATE"))+"','dd/MM/yyyy'))");
				rsTemp=psTemp.executeQuery();
			if(rsTemp.next())
			{	
		TotalDaysFlts.append("\"");
			TotalDaysFlts.append(formatter1.format(rsTemp1.getDate("FLIGHT_SCH_ARR_DATE")));
			//out.println(TotalDaysFlts.toString()+"<BR>");
			TotalDaysFlts.append("\"");
			TotalDaysFlts.append(",");
             //out.println(TotalDaysFlts.toString()+"<BR>");
			TotalArrFlts.append(rsTemp1.getInt("apis_flight")+",");
			TotalDepFlts.append(rsTemp.getInt("apis_flight_dep")+",");
            // out.println(TotalDepFlts.toString()+"<BR>");
			}
			rsTemp.close();
			psTemp.close();
		}
		rsTemp1.close();
		psTemp1.close();
			strTotalDaysFlts = TotalDaysFlts.toString();
             //out.println(strTotalDaysFlts.toString()+"<BR>");
			strTotalDaysFlts = strTotalDaysFlts.substring(0,strTotalDaysFlts.length()-1);
			strTotalArrFlts = TotalArrFlts.toString();
			strTotalArrFlts = strTotalArrFlts.substring(0,strTotalArrFlts.length()-1);
			strTotalDepFlts = TotalDepFlts.toString();
			strTotalDepFlts = strTotalDepFlts.substring(0,strTotalDepFlts.length()-1);

			
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
	

<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>

<BR>
<div class="col-md-6">
<div class="card"style="border: solid 3px #007d79; border-radius: 20px;">
<div class="card-body">

	<canvas id="canvas_Apis_Manifest" class="chart" style="background: linear-gradient(to bottom, #ffffff 20%, #cdf7f7 100%);border-radius: 20px;height:190px;"></canvas>
</div>
</div>
<BR>


<div class="card"style="border: solid 3px #0073b7; border-radius: 20px;">
<div class="card-body">

	<canvas id="canvas_Apis_Flights" class="chart" style="background: linear-gradient(to bottom, #ffffff 20%, #cdf7f7 100%);border-radius: 20px;height:190px;"></canvas>
</div>
</div>
</div>




<%///////////////////////////////////////////////////////////////////////////////////////////%>

				<!-- /.col (LEFT) -->
				<div class="col-md-6">
					<div id="myCarousel" class="carousel slide" data-ride="carousel">
						<!-- Indicators -->
						<ol class="carousel-indicators">
							<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
							<li data-target="#myCarousel" data-slide-to="1"></li>
							<li data-target="#myCarousel" data-slide-to="2"></li>
							<!--<li data-target="#myCarousel" data-slide-to="3"></li>
							<li data-target="#myCarousel" data-slide-to="4"></li>-->
							<li data-target="#myCarousel" data-slide-to="5"></li>
							<!--<li data-target="#myCarousel" data-slide-to="6"></li>
							<li data-target="#myCarousel" data-slide-to="7"></li>-->
						</ol>

						<!-- Wrapper for slides -->
						<div class="carousel-inner">
							<div class="item active">
							<img src="slider_image/Arrival_apis.JPG" width="100%"  style="height:420px;"/>
							</div>
							<div class="item">
							<img src="slider_image/Arrival_apis__count.JPG" width="100%"  style="height:420px;"/>
							</div>
							<div class="item">
							<img src="slider_image/Departure_apis.JPG" width="100%"  style="height:420px;"/>
							</div>
							<!--<div class="item">
							<img src="slider_image/Year-Wise Arrival Pax Count.JPG" width="100%" height="300"/>
							</div>
							<div class="item">
							<img src="slider_image/Year-wise Arrival PAX Flights Count.JPG" width="100%" height="300"/>
							</div>-->
							<div class="item">
							<img src="slider_image/Year-wise Departure APIS Flights Count.JPG" width="100%"  style="height:420px;"/>
							</div>
							<!--<div class="item">
							<img src="slider_image/Year-wise Departure PAX Count.JPG" width="100%" height="300"/>
							</div>
							<div class="item">
							<img src="slider_image/Year-wise Departure PAX Flights Count.JPG" width="100%" height="300"/>
							</div>-->
							
						</div>

						<!-- Left and right controls -->
						<a class="left carousel-control" href="#myCarousel"
							data-slide="prev"> <span
							class="glyphicon glyphicon-chevron-left"></span> <span
							class="sr-only">Previous</span>
						</a> <a class="right carousel-control" href="#myCarousel"
							data-slide="next"> <span
							class="glyphicon glyphicon-chevron-right"></span> <span
							class="sr-only">Next</span>
						</a>
					</div>
					<!-- /.box -->

				</div>
				<!-- /.col (RIGHT) -->
			</div>
			<!-- /.row -->

		</section>
<BR>
	<section class="content"><!--  style="padding: 0px; margin-right: 20px; margin-left: 20px;" -->
		<div class="row">
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-olive-active"><i
						class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Today ARR APIS</span> <span
							class="info-box-number" id="arr_apis_pax"></span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			
			<!-- /.col -->
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-teal"><i
						class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Today DEP APIS</span> <span
							class="info-box-number" id="dep_apis_pax"></span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<!-- /.col -->
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-olive-active"><i class="fa fa-plane"></i></span>

					<div class="info-box-content">
						<span class="Today">Today ARR APIS Flights</span> <span
							class="info-box-number" id="apis_flight"></span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<!-- /.col -->
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-teal"><i class="fa fa-plane"></i></span>

					<div class="info-box-content">
						<span class="Today">Today DEP APIS Flights</span> <span
							class="info-box-number" id="apis_flight_dep"></span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-blue"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Total APIS</span> <span
							class="info-box-number" id="apis_pax_total"></span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-blue"><i class="fa fa-plane"></i></span>

					<div class="info-box-content">
						<span class="Today">Total APIS Flights</span> <span
							class="info-box-number" id="apis_flight_total"></span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<!-- /.col -->
		</div>
		<div class="row">
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box bg-olive-active">
					<span class="info-box-icon"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Arrival APIS</span> <span
							class="info-box-number" id="yes_arr_apis_pax"></span>

						<div class="progress">
							<div class="progress-bar" style="width: 70%"></div>
						</div>
						<span class="progress-description"> <%=yesterday_date %>
						</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<!-- /.col -->
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box bg-teal">
					<span class="info-box-icon"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Departure APIS</span> <span
							class="info-box-number" id="yes_dep_apis_pax"></span>

						<div class="progress">
							<div class="progress-bar" style="width: 70%"></div>
						</div>
						<span class="progress-description"> <%=yesterday_date %>
						</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<!-- /.col -->
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box bg-olive-active">
					<span class="info-box-icon"><i class="fa fa-plane"></i></span>

					<div class="info-box-content">
						<span class="Today">Arr. APIS Flights</span> <span
							class="info-box-number" id="yes_apis_flight"></span>

						<div class="progress">
							<div class="progress-bar" style="width: 70%"></div>
						</div>
						<span class="progress-description"> <%=yesterday_date %>
						</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<!-- /.col -->
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box bg-teal">
					<span class="info-box-icon"><i class="fa fa-plane"></i></span>

					<div class="info-box-content">
						<span class="Today">Dep. APIS Flights</span> <span
							class="info-box-number" id="yes_apis_flight_dep"></span>

						<div class="progress">
							<div class="progress-bar" style="width: 70%"></div>
						</div>
						<span class="progress-description"> <%=yesterday_date %>
						</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box bg-blue">
					<span class="info-box-icon"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Total APIS</span> <span
							class="info-box-number" id="yes_apis_pax_total"></span>

						<div class="progress">
							<div class="progress-bar" style="width: 70%"></div>
						</div>
						<span class="progress-description"> <%=yesterday_date %>
						</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<div class="col-md-2 col-sm-6 col-xs-12">
				<div class="info-box bg-blue">
					<span class="info-box-icon"><i class="fa fa-plane"></i></span>

					<div class="info-box-content">
						<span class="Today">Total APIS Flights</span> <span
							class="info-box-number" id="yes_apis_flight_total"></span>

						<div class="progress">
							<div class="progress-bar" style="width: 70%"></div>
						</div>
						<span class="progress-description"> <%=yesterday_date %>
						</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			<!-- /.col -->
			
		</div>
		<!-- Small boxes (Stat box) -->
		<div class="row">
			<div class="col-lg-2 col-xs-4">
				<!-- small box -->
				<div class="small-box bg-olive-active">
					<div class="inner" style="padding: 5px;">
						<h3 id="arr_apis"></h3>
						
						<p style="font-weight: bold;">Total Arrival APIS</p>
					</div>
					<div class="icon">
						<i class="fa fa-users"></i>
					</div>
					<p class="small-box-footer" style="text-align: left">Data Since 2008</p>
				</div>
			</div>
			
			<div class="col-lg-2 col-xs-4">
				<!-- small box -->
				<div class="small-box bg-teal">
					<div class="inner" style="padding: 5px;">
						<h3 id="dep_apis"></h3>

						<p style="font-weight: bold;">Total Departure APIS</p>
					</div>
					<div class="icon">
						<i class="fa fa-users"></i>
					</div>
					<p class="small-box-footer" style="text-align: left">Data Since 2017</p>
				</div>
			</div>
			<div class="col-lg-2 col-xs-4">
				<!-- small box -->
				<div class="small-box bg-olive-active">
					<div class="inner" style="padding: 5px;">
						<h3 id="arr_apis_flight"></h3>

						<p style="font-weight: bold;">Total Arr. APIS Flights</p>
					</div>
					<div class="icon">
						<i class="fa fa-plane"></i>
					</div>
					<p class="small-box-footer" style="text-align: left">Data Since 2008</p>
				</div>
			</div>
			<!-- ./col -->
			<div class="col-lg-2 col-xs-4">
				<!-- small box -->
				<div class="small-box bg-teal">
					<div class="inner" style="padding: 5px;">
						<h3 id="dep_apis_flight"></h3>

						<p style="font-weight: bold;">Total Dep. APIS Flights</p>
					</div>
					<div class="icon">
						<i class="fa fa-plane"></i>
					</div>
					<p class="small-box-footer" style="text-align: left">Data Since 2017</p>
				</div>
			</div>
			<!-- ./col -->
			<div class="col-lg-2 col-xs-4">
				<!-- small box -->
				<div class="small-box bg-blue">
					<div class="inner" style="padding: 5px;">
						<h3 id="apistotal"></h3>

						<p style="font-weight: bold;">Total APIS</p>
					</div>
					<div class="icon">
						<i class="fa fa-users"></i>
					</div>
					<p class="small-box-footer" style="text-align: left">&nbsp;</p>
				</div>
			</div>
			<!-- ./col -->
			<div class="col-lg-2 col-xs-4">
				<!-- small box -->
				<div class="small-box bg-blue">
					<div class="inner" style="padding: 5px;">
				      <h3 id="apisflighttotal"></h3>
						<p style="font-weight: bold;">Total APIS Flights</p>
					</div>
					<div class="icon">
						<i class="fa fa-plane"></i>
					</div>
					<p class="small-box-footer" style="text-align: left">&nbsp;</p>
				</div>
			</div>
			<!-- ./col -->
		</div>
		<!-- /.row -->
		<!-- Main row -->
		<!-- Main content -->

		<!-- /.row (main row) -->

	</section>
<!-- 	<%@include file="footer.html"%>
	<!-- /.content-wrapper -->

	<!-- ./wrapper -->

	<!-- jQuery 3 -->
<!-- jQuery 3 -->
<script src="bower_components/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap 3.3.7 -->
<script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- Morris.js charts -->
<script src="bower_components/raphael/raphael.min.js"></script>
<script src="bower_components/morris.js/morris.min.js"></script>
<!-- FastClick -->
<script src="bower_components/fastclick/lib/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="dist/js/adminlte.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="dist/js/demo.js"></script>
<script>

	// Data define for bar chart

	var myData_total = {
		labels: [<%=strTotalDays%>],
		datasets: [{ 
			  label: "Arrival APIS",
			  backgroundColor: "#7743DB",
			  borderColor: "#7743DB",
			  borderWidth: 1,
			  data: [<%=strTotalArrPax%>]
		}, { 
			  label: "Departure APIS",
			  backgroundColor: "#D6D46D",
			  borderColor: "#D6D46D",
			  borderWidth: 2,
			  data: [<%=strTotalDepPax%>]
		}]
	};

// Options to display value on top of bars

	var myoptions = {
				maintainAspectRatio: false,
					responsive:true,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#007d79"

								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
								display:false,
								color: "#007d79"
								}

					}]
				},
				 title: {
						display: true,
							text:'APIS Manifest Received in last 7 days',
						fontSize: 18,		
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
				ctx.font = "bold 9px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
						ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y-1);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvas_Apis_Manifest').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_total,    	// Chart data
		options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>

<script>

	// Data define for bar chart

	var myData_Flts = {
		labels: [<%=strTotalDaysFlts%>],
		datasets: [{ 
			  label: "APIS Arrival Flights",
			  backgroundColor: "#FA7070",
			  borderColor: "#FA7070",
			  borderWidth: 1,
			  data: [<%=strTotalArrFlts%>]
		}, { 
			  label: "APIS Departure Flights",
			  backgroundColor: "#0073b7",
			  borderColor: "#0073b7",
			  borderWidth: 2,
			  data: [<%=strTotalDepFlts%>]
		}]
	};

// Options to display value on top of bars

	var myoptions_Flts = {
				maintainAspectRatio: false,
					responsive:true,
			 scales: {
					xAxes: [{
						ticks: {
							display: true //removes y axis values in  bar graph 
						},
							gridLines: { 
								display:true,
								color: "#007d79"

								}
					}],
				yAxes: [{
						ticks: {
							display: false //removes y axis values in  bar graph 
						},
					gridLines: { 
								display:false,
								color: "#007d79"
								}

					}]
				},
				 title: {
						display: true,
							text:'APIS Flights in last 7 days',
						fontSize: 18,		
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
				ctx.font = "bold 9px Verdana";

				this.data.datasets.forEach(function (dataset, i) {
					var metas = chartInstances.controller.getDatasetMeta(i);
					metas.data.forEach(function (bar, index) {
						var data = dataset.data[index];
						ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y-1);
					});
				});
			}
		},
		
	};
	
	//Code to draw Chart
	var ctx = document.getElementById('canvas_Apis_Flights').getContext('2d');
	var myCharts = new Chart(ctx, {
		type: 'bar',    	// Define chart type
		data: myData_Flts,    	// Chart data
		options: myoptions_Flts 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
	});
</script>
<script>
  $(function () {
    "use strict";

    // AREA CHART
    var area = new Morris.Area({
      element: 'revenue-chart',
      resize: true,
      data: [
        
         <%
		  //select count(1) as apis_flight from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax where FLIGHT_SCH_ARR_DATE = trunc(sysdate))
		  stmt1=con1.prepareStatement("select count(1) as apis_flight,FLIGHT_SCH_ARR_DATE from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax where FLIGHT_SCH_ARR_DATE > trunc(sysdate-6)) group by FLIGHT_SCH_ARR_DATE");
		rs1=stmt1.executeQuery();  
		while(rs1.next())
		{
			stmt=con1.prepareStatement("select count(1) as apis_flight_dep from (select DISTINCT FLIGHT_SCH_ARR_DATE,pax_flight_no from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+formatter.format(rs1.getDate("FLIGHT_SCH_ARR_DATE"))+"','dd/MM/yyyy'))");
			rs=stmt.executeQuery();  
			if(rs.next())
			{	
		 %>
         {y: '<%=formatter2.format(rs1.getDate("FLIGHT_SCH_ARR_DATE"))%>', Departure: <%=rs.getInt("apis_flight_dep")%>, Arrival: <%=rs1.getInt("apis_flight")%>},
       
        
		<%
			}
			rs.close();
			stmt.close();
		}
		rs1.close();
		stmt1.close();
		%>
      ],
      xkey: 'y',
      ykeys: ['Departure', 'Arrival'],
      labels: ['Departure', 'Arrival'],
      lineColors: ['#a0d0e0', '#3c8dbc'],
      hideHover: 'auto'
    });

    // LINE CHART
   /* var line = new Morris.Line({
      element: 'line-chart',
      resize: true,
      data: [
        {y: '2011 Q1', item1: 2666},
        {y: '2011 Q2', item1: 2778},
        {y: '2011 Q3', item1: 4912},
        {y: '2011 Q4', item1: 3767},
        {y: '2012 Q1', item1: 6810},
        {y: '2012 Q2', item1: 5670},
        {y: '2012 Q3', item1: 4820},
        {y: '2012 Q4', item1: 15073},
        {y: '2013 Q1', item1: 10687},
        {y: '2013 Q2', item1: 8432}
      ],
      xkey: 'y',
      ykeys: ['item1'],
      labels: ['Item 1'],
      lineColors: ['#3c8dbc'],
      hideHover: 'auto'
    });

    //DONUT CHART
    var donut = new Morris.Donut({
      element: 'sales-chart',
      resize: true,
      colors: ["#3c8dbc", "#f56954", "#00a65a"],
      data: [
        {label: "Download Sales", value: 12},
        {label: "In-Store Sales", value: 30},
        {label: "Mail-Order Sales", value: 20}
      ],
      hideHover: 'auto'
    });*/
    //BAR CHART
    var bar = new Morris.Bar({
      element: 'bar-chart',
      resize: true,
      data: [
		  <%
		  stmt1=con1.prepareStatement("select count(1) as apis_pax,FLIGHT_SCH_ARR_DATE from im_apis_pax where FLIGHT_SCH_ARR_DATE > trunc(sysdate-6) group by FLIGHT_SCH_ARR_DATE");
		rs1=stmt1.executeQuery();  
		while(rs1.next())
		{
			stmt=con1.prepareStatement("select count(1) as apis_pax_dep from im_apis_pax_dep where FLIGHT_SCH_ARR_DATE = TO_DATE('"+formatter.format(rs1.getDate("FLIGHT_SCH_ARR_DATE"))+"','dd/MM/yyyy')");
			rs=stmt.executeQuery();  
			if(rs.next())
			{	
		 %>
         
        {y: '<%=formatter1.format(rs1.getDate("FLIGHT_SCH_ARR_DATE"))%>', a: <%=rs1.getInt("apis_pax")%>, b: <%=rs.getInt("apis_pax_dep")%>},
        
		<%
			}
			rs.close();
			stmt.close();
		}
		rs1.close();
		stmt1.close();
		%>
      ],
      barColors: ['#00a65a', '#f56954'],
      xkey: 'y',
      ykeys: ['a', 'b'],
      labels: ['Arrival', 'Depature'],
      hideHover: 'auto'
    });
  });
</script>
<%
}
catch(Exception e)
{
	e.printStackTrace();
}
finally
{
	con.close();
	con1.close();
	
}
%>
</body>
</html>
