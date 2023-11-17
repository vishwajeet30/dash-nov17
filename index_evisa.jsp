<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>e-Visa Clearance Statistics</title>
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
<!--select count(1) from IM_APIS_PAX where PAX_BOARDING_DATE >= to_date('01/01/2023','dd/MM/yyyy') and PAX_BOARDING_DATE <= to_date('15/08/2023','dd/MM/yyyy');

select count(1) from IM_APIS_PAX_DEP where PAX_BOARDING_DATE >= to_date('01/01/2023','dd/MM/yyyy') and PAX_BOARDING_DATE <= to_date('15/08/2023','dd/MM/yyyy');


select count(1) as pax_flight from (select DISTINCT PAX_BOARDING_DATE, pax_flight_no from im_pax_pax where PAX_BOARDING_DATE >= to_date('01/01/2023','dd/MM/yyyy') and PAX_BOARDING_DATE <= to_date('15/08/2023','dd/MM/yyyy'))

select count(1) as pax_flight_dep from (select DISTINCT PAX_BOARDING_DATE,pax_flight_no from im_pax_pax_dep where PAX_BOARDING_DATE >= to_date('01/01/2023','dd/MM/yyyy') and PAX_BOARDING_DATE <= to_date('15/08/2023','dd/MM/yyyy'))-->
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


long arr_epassport = 0;
long dep_epassport = 0;


long yes_arr_epassport = 0;
long yes_dep_epassport = 0;

long To_arr_epassport = 0;
long To_dep_epassport = 0;

long arr_pax_pax_str = 0;
long dep_pax_pax_str = 0;

long total_pax_pax_str = 0;


Connection con =null;
Connection con1 =null;
PreparedStatement stmt = null;
ResultSet rs = null;
PreparedStatement stmt1 = null;
ResultSet rs1 = null;
PreparedStatement psTemp = null;
PreparedStatement psTemp1 = null;
ResultSet rsTemp = null;
ResultSet rsTemp1 = null;
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
	//con1=DriverManager.getConnection(  
			//"jdbc:oracle:thin:@10.248.168.219:1521:CFB1","imigration","nicsi123");

	stmt=con.prepareStatement("select ARR_EVISA,DEP_EVISA,LAST_UPDATE from IM_DASHBOARD_APIS_STATS");  
	rs=stmt.executeQuery();  
	while(rs.next())
	{ 
		if(rs.getString("LAST_UPDATE") != null)
			last_update_date = formatter.format(rs.getDate("LAST_UPDATE"));
		
		if(rs.getString("ARR_EVISA") != null)
			arr_epassport = arr_epassport+rs.getInt("ARR_EVISA");
		
		
		
		if(rs.getString("DEP_EVISA") != null)
			dep_epassport = dep_epassport+rs.getInt("DEP_EVISA");
		
	
	}
	rs.close();
	stmt.close();
	////////////////////////////////////////////////////////22/08/2023
	stmt1=con.prepareStatement("select count(1) as arr_epassport from IM_TRANS_ARR_TOTAL where PAX_BOARDING_DATE > TO_DATE('"+last_update_date+"','dd/MM/yyyy') and VISA_NO like '9%'");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			arr_epassport = arr_epassport+rs1.getInt("arr_epassport");
			
		}
		rs1.close();
		stmt1.close();

		stmt1=con.prepareStatement("select count(1) as dep_epassport from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE > TO_DATE('"+last_update_date+"','dd/MM/yyyy') and VISA_NO like '9%'");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			dep_epassport = dep_epassport+rs1.getInt("dep_epassport");
			
		}
		rs1.close();
		stmt1.close();

		
	////////////////////////////////////////////////////////22/08/2023
	
	stmt=con.prepareStatement("select sysdate-1 from dual");  
	rs=stmt.executeQuery();  
	if(rs.next())
	{ 
		yesterday_date = formatter.format(rs.getDate("sysdate-1"));

		stmt1=con.prepareStatement("select count(1) as yes_arr_epassport from IM_TRANS_ARR_TOTAL where PAX_BOARDING_DATE = TO_DATE('"+yesterday_date+"','dd/MM/yyyy') and VISA_NO like '9%'");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			yes_arr_epassport = rs1.getInt("yes_arr_epassport");
			
		}
		rs1.close();
		stmt1.close();
		stmt1=con.prepareStatement("select count(1) as yes_dep_epassport from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE = TO_DATE('"+yesterday_date+"','dd/MM/yyyy') and VISA_NO like '9%'");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			yes_dep_epassport = rs1.getInt("yes_dep_epassport");
			
		}
		rs1.close();
		stmt1.close();

		
		
		
	}
	rs.close();
	stmt.close();

	/////////////////////////////////////////Today
		stmt1=con.prepareStatement("select count(1) as pax_pax from IM_TRANS_ARR_TOTAL where PAX_BOARDING_DATE = trunc(sysdate) and VISA_NO like '9%'");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			To_arr_epassport = rs1.getInt("pax_pax");
			if(To_arr_epassport > 2000) arr_pax_pax_str = To_arr_epassport-1000;
			
		}
		rs1.close();
		stmt1.close();
		stmt1=con.prepareStatement("select count(1) as pax_pax_dep from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE = trunc(sysdate) and VISA_NO like '9%'");
		rs1=stmt1.executeQuery();  
		if(rs1.next())
		{ 
			To_dep_epassport = rs1.getInt("pax_pax_dep");
			if(To_dep_epassport > 2000) dep_pax_pax_str = To_dep_epassport-1000;
			
		}
		rs1.close();
		stmt1.close();

        if(To_arr_epassport+To_dep_epassport > 3000) total_pax_pax_str = (To_arr_epassport+To_dep_epassport)-2000;


		
	
  /*	stmt1=con.prepareStatement("select PAX_BOARDING_DATE,count(1) as pax_pax from IM_TRANS_ARR_TOTAL where PAX_BOARDING_DATE >= trunc(sysdate-7) group by PAX_BOARDING_DATE");
		rs1=stmt1.executeQuery();  
		while(rs1.next())
		{ 
			arr_date.append("'"+formatter.format(rs1.getDate("PAX_BOARDING_DATE"))+"',");
			pax_arr.append(rs1.getString("pax_pax")+",");

			stmt=con.prepareStatement("select count(1) as pax_pax_dep from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE = TO_DATE('"+formatter.format(rs1.getDate("PAX_BOARDING_DATE"))+"','dd/MM/yyyy')");
			//out.println("select count(1) as pax_pax_dep from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE = TO_DATE('"+rs1.getDate("PAX_BOARDING_DATE")+"','dd/MM/yyyy')");
			rs=stmt.executeQuery();  
			if(rs.next())
			{ 
				pax_dep.append(rs.getString("pax_pax_dep")+",");
				
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
        let upto = <%=arr_epassport-1250%>;
      
        function updated() {
            upto = ++upto;
            document.getElementById('arr_epassport').innerHTML = upto.toLocaleString('en-IN');
            if (upto === <%=arr_epassport%>) {
            	
                clearInterval(counts);
            }
        }

		let counts1 = setInterval(updated1);
        let upto1 = <%=dep_epassport-1250%>;
      
        function updated1() {
            upto1 = ++upto1;
            document.getElementById('dep_epassport').innerHTML = upto1.toLocaleString('en-IN');
            if (upto1 === <%=dep_epassport%>) {
            	
                clearInterval(counts1);
            }
        }

		let counts2 = setInterval(updated2);
        let upto2 = <%=(dep_epassport+arr_epassport)-1250%>;
      
        function updated2() {
            upto2 = ++upto2;
            document.getElementById('epassporttotal').innerHTML = upto2.toLocaleString('en-IN');
            if (upto2 === <%=dep_epassport+arr_epassport%>) {
            	
                clearInterval(counts2);
            }
        }
/////////////////
		let counts3 = setInterval(updated3);
        let upto3 = <%=yes_arr_epassport%>;
      
        function updated3() {
            //upto3 = ++upto3;
            document.getElementById('yes_arr_epassport').innerHTML = upto3.toLocaleString('en-IN');
            if (upto3 === <%=yes_arr_epassport%>) {
            	
                clearInterval(counts3);
            }
        }

		let counts4 = setInterval(updated4);
        let upto4 = <%=yes_dep_epassport%>;
      
        function updated4() {
            //upto4 = ++upto4;
            document.getElementById('yes_dep_epassport').innerHTML = upto4.toLocaleString('en-IN');
            if (upto4 === <%=yes_dep_epassport%>) {
            	
                clearInterval(counts4);
            }
        }
        let counts5 = setInterval(updated5);
        let upto5 = <%=yes_arr_epassport+yes_dep_epassport%>;
      
        function updated5() {
            //upto5 = ++upto5;
            document.getElementById('yes_pax_pax_total').innerHTML = upto5.toLocaleString('en-IN');
            if (upto5 === <%=yes_arr_epassport+yes_dep_epassport%>) {
            	
                clearInterval(counts5);
            }
        }

		/////////////////
		let counts6 = setInterval(updated6);
        let upto6 = <%=To_arr_epassport%>;
      
        function updated6() {
            //upto6 = ++upto6;
            document.getElementById('To_arr_epassport').innerHTML = upto6.toLocaleString('en-IN');
            if (upto6 === <%=To_arr_epassport%>) {
            	
                clearInterval(counts6);
            }
        }

		let counts7 = setInterval(updated7);
        let upto7 = <%=To_dep_epassport%>;
      
        function updated7() {
            //upto7 = ++upto7;
            document.getElementById('To_dep_epassport').innerHTML = upto7.toLocaleString('en-IN');
            if (upto7 === <%=To_dep_epassport%>) {
            	
                clearInterval(counts7);
            }
        }
        let counts8 = setInterval(updated8);
        let upto8 = <%=To_arr_epassport+To_dep_epassport%>;
      
        function updated8() {
            //upto8 = ++upto8;
            document.getElementById('pax_pax_total').innerHTML = upto8.toLocaleString('en-IN');
            if (upto8 === <%=To_arr_epassport+To_dep_epassport%>) {
            	
                clearInterval(counts8);
            }
        }
      
    </script>
</head>
<body class="hold-transition skin-blue sidebar-mini">

	<!-- Content Wrapper. Contains page content -->
	<%@include file="header_evisa.html"%>
	<div>
		<!-- Content Header (Page header) -->
		<!--   <section class="content-header">
      <h1>
        Dashboard
        <small>Control panel</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Dashboard</li>
      </ol>
    </section> -->


		<!-- Main content -->
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
	SQLQUERY = "select PAX_BOARDING_DATE,count(1) as arr_epassport from IM_TRANS_ARR_TOTAL where PAX_BOARDING_DATE >= trunc(sysdate-6) and VISA_NO like '9%' group by PAX_BOARDING_DATE order by PAX_BOARDING_DATE";
	
	psTemp1 = con.prepareStatement(SQLQUERY);
	rsTemp1 = psTemp1.executeQuery();
	while (rsTemp1.next())
		{
			if(rsTemp1.getString("PAX_BOARDING_DATE") != null)
			{
				psTemp=con.prepareStatement("select count(1) as dep_epassport from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE = TO_DATE('"+formatter.format(rsTemp1.getDate("PAX_BOARDING_DATE"))+"','dd/MM/yyyy') and VISA_NO like '9%' order by PAX_BOARDING_DATE");
				rsTemp=psTemp.executeQuery();  
			if(rsTemp.next())
			{	
			TotalDays.append("\"");
			TotalDays.append(formatter1.format(rsTemp1.getDate("PAX_BOARDING_DATE")));
			TotalDays.append("\"");
			TotalDays.append(",");
             //out.println(TotalDays.toString()+"<BR>");
			TotalArrPax.append(rsTemp1.getInt("arr_epassport")+",");
			TotalDepPax.append(rsTemp.getInt("dep_epassport")+",");

			//out.println(TotalArrPax.toString()+"<BR>");
				//out.println(TotalDepPax.toString()+"<BR>");
			
			}
			rsTemp.close();
			psTemp.close();
		 }
		
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

<BR>
<div class="col-md-6">
<div class="card"style="border: solid 3px #3c8dbc; border-radius: 20px;">
<div class="card-body">

	<canvas id="canvasPAX_Total" class="chart" style="background: linear-gradient(to bottom, #ffffff 20%, #cdf7f7 100%);border-radius: 20px;height:400px;"></canvas>
</div>
</div>
</div>

<%////////////////////////////////////////%>
				<!-- /.col (LEFT) -->
				<div class="col-md-6">
					<div id="myCarousel" class="carousel slide" data-ride="carousel">
						<!-- Indicators -->
						<ol class="carousel-indicators">
							<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
							<li data-target="#myCarousel" data-slide-to="1"></li>
							
						</ol>

						<!-- Wrapper for slides -->
						<div class="carousel-inner">
							<div class="item active">
							<img src="slider_image/Year-wise_Arrival_e-Visa_Clearance.png" width="100%"  style="height:420px;"/>
							</div>
							<div class="item">
							<img src="slider_image/Year-wise_Departure_e-Visa_Clearance.png" width="100%"  style="height:420px;"/>
							</div>
							
							
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
	<section class="content" style="padding: 7px;margin-top: -8px;margin-right: 20px;margin-left: 20px;margin-bottom: 16px;">
		<div class="row">
			<div class="col-md-4 col-sm-3 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-purple"><i
						class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Arrival e-Visa</span> <span
							class="info-box-number" id="To_arr_epassport"></span>
							<span class="Today">Today</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			
			<!-- /.col -->
			<div class="col-md-4 col-sm-3 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-light-blue"><i
						class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Departure e-Visa</span> <span
							class="info-box-number" id="To_dep_epassport"></span>
							<span class="Today">Today</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
		
			<div class="col-md-4 col-sm-3 col-xs-12">
				<div class="info-box">
					<span class="info-box-icon bg-red"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Total e-Visa (Arr/Dep)</span> <span
							class="info-box-number" id="pax_pax_total"></span>
							<span class="Today">Today</span>
					</div>
					<!-- /.info-box-content -->
				</div>
				<!-- /.info-box -->
			</div>
			
			<!-- /.col -->
		</div>
		<div class="row">
			<div class="col-md-4 col-sm-3 col-xs-12">
				<div class="info-box bg-purple">
					<span class="info-box-icon"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Arrival e-Visa</span> <span
							class="info-box-number" id="yes_arr_epassport"></span>

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
			<div class="col-md-4 col-sm-3 col-xs-12">
				<div class="info-box bg-light-blue">
					<span class="info-box-icon"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Departure e-Visa</span> <span
							class="info-box-number" id="yes_dep_epassport"></span>

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
			
			<div class="col-md-4 col-sm-3 col-xs-12">
				<div class="info-box bg-red">
					<span class="info-box-icon"><i class="fa fa-users"></i></span>

					<div class="info-box-content">
						<span class="Today">Total e-Visa (Arr/Dep)</span> <span
							class="info-box-number" id="yes_pax_pax_total"></span>

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
			
			
		</div>
		<!-- Small boxes (Stat box) -->
		<div class="row">
			<div class="col-lg-4 col-xs-6">
				<!-- small box -->
				<div class="small-box bg-purple">
					<div class="inner" style="padding: 5px;">
						<h3 id="arr_epassport"></h3>
						
						<p style="font-weight: bold;">Total Arrival e-Visa</p>
					</div>
					<div class="icon">
						<i class="fa fa-users"></i>
					</div>
					<p class="small-box-footer" style="text-align: left;margin-top: -5px;">Data Since 2014</p>
				</div>
			</div>
			
			<div class="col-lg-4 col-xs-6">
				<!-- small box -->
				<div class="small-box bg-light-blue">
					<div class="inner" style="padding: 5px;">
						<h3 id="dep_epassport"></h3>

						<p style="font-weight: bold;">Total Departure e-Visa</p>
					</div>
					<div class="icon">
						<i class="fa fa-users"></i>
					</div>
					<p class="small-box-footer" style="text-align: left;margin-top: -5px;">Data Since 2014</p>
				</div>
			</div>
			
			
			<!-- ./col -->
			<div class="col-lg-4 col-xs-6">
				<!-- small box -->
				<div class="small-box bg-red">
					<div class="inner" style="padding: 5px;">
						<h3 id="epassporttotal"></h3>

						<p style="font-weight: bold;">Total e-Visa (Arr/Dep)</p>
					</div>
					<div class="icon">
						<i class="fa fa-users"></i>
					</div>
					<p class="small-box-footer" style="text-align: left;margin-top: -5px;">&nbsp;</p>
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
 -->	<!-- /.content-wrapper -->

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
			  label: "Arrival",
			  backgroundColor: "#dd4b39",
			  borderColor: "#dd4b39",
			  borderWidth: 1,
			  data: [<%=strTotalArrPax%>]
		}, { 
			  label: "Departure",
			  backgroundColor: "#3c8dbc",
			  borderColor: "#3c8dbc",
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
								color: "#54b6ef"

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
							text:'e-Visa Clearance in last 7 days',
						fontSize: 22,		
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
						ctx.fillText(data.toLocaleString('en-IN'), bar._model.x, bar._model.y-1);
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
<script>
  $(function () {
    "use strict";

    // AREA CHART
    var area = new Morris.Area({
      element: 'revenue-chart',
      resize: true,
      data: [
        
         <%
		  
		  stmt1=con.prepareStatement("select PAX_BOARDING_DATE,count(1) as arr_epassport from IM_TRANS_ARR_TOTAL where PAX_BOARDING_DATE >= trunc(sysdate-6)  and VISA_NO like '9%' group by PAX_BOARDING_DATE order by PAX_BOARDING_DATE");
		rs1=stmt1.executeQuery();  
		while(rs1.next())
		{
			if(rs1.getString("PAX_BOARDING_DATE") != null)
			{
			stmt=con.prepareStatement("select count(1) as dep_epassport from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE = TO_DATE('"+formatter.format(rs1.getDate("PAX_BOARDING_DATE"))+"','dd/MM/yyyy') and VISA_NO like '9%' order by PAX_BOARDING_DATE");
			rs=stmt.executeQuery();  
			if(rs.next())
			{	
		 %>
         {y: '<%=formatter2.format(rs1.getDate("PAX_BOARDING_DATE"))%>', Departure: <%=rs.getInt("dep_epassport")%>, Arrival: <%=rs1.getInt("arr_epassport")%>},
       
        
		<%
			}
			rs.close();
			stmt.close();
			}
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
		  stmt1=con.prepareStatement("select PAX_BOARDING_DATE,count(1) as arr_epassport from IM_TRANS_ARR_TOTAL where PAX_BOARDING_DATE >= trunc(sysdate-6) and VISA_NO like '9%' group by PAX_BOARDING_DATE order by PAX_BOARDING_DATE");
		rs1=stmt1.executeQuery();  
		while(rs1.next())
		{
			if(rs1.getString("PAX_BOARDING_DATE") != null)
			{
			stmt=con.prepareStatement("select count(1) as dep_epassport from IM_TRANS_DEP_TOTAL where PAX_BOARDING_DATE = TO_DATE('"+formatter.format(rs1.getDate("PAX_BOARDING_DATE"))+"','dd/MM/yyyy') and VISA_NO like '9%' order by PAX_BOARDING_DATE");
			rs=stmt.executeQuery();  
			if(rs.next())
			{	
		 %>
         
        {y: '<%=formatter1.format(rs1.getDate("PAX_BOARDING_DATE"))%>', a: <%=rs1.getInt("arr_epassport")%>, b: <%=rs.getInt("dep_epassport")%>},
        
		<%
			}
			rs.close();
			stmt.close();
			}
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
	
}
%>
</body>
</html>
