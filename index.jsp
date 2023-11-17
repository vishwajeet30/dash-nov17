<%@ page language="java" import="java.text.*"%>
<%
String include_tag="<jsp:include page=";

%>
<!DOCTYPE html>
<html>
<head>
    <title>ICS Dashboard</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">

    <style>
        .page-container {
            display: flex;
            justify-content: center;
			background-color: #357da9;
			height: 24px;
			padding-left: 1220px;
		}

        .page {
            margin: 0px;
            cursor: pointer;
            padding: 4px;
			font-weight: bold;
		    font-size: 11px;
			border-radius: 5px;
			color: white;
        }

        .current-page {
            background-color: #a91515;
        }
		.button-container {
        z-index: 9999;
		}
		.button-container {
			position: fixed;
			top: 0;
			left: 5%;

		}
		.button-container button {
			background-color: #007BFF;
			color: #FFFFFF;
		}
		iframe{
			border: none;
			margin-top: 24px;
			width: 100%;
			height: 100%;
			overflow: hidden;
			overflow-y: hidden;
			top: 0;
			left: 0;
			bottom: 0;
			right: 0;
			position: absolute;
		}
    </style>
	 
 
    <script>
        var pages = ["index_pax.jsp", "index_evisa.jsp", "index_apis.jsp", "index_epassport.jsp"];
        var durations = [300000, 300000, 180000, 180000]; // Durations in milliseconds for each page, 300000 = 5 Minutes, 180000 = 3 Minutes
        var timer;
		var currentIndex = 0;

         

        /*function rotatePages() {
            currentIndex = (currentIndex + 1) % pages.length;
            showPage(currentIndex);
        }*/
		 function setTimerForNextPage() {
            clearTimeout(timer);
            timer = setTimeout(function () {
                currentIndex = (currentIndex + 1) % pages.length;
                showPage(currentIndex);
            }, durations[currentIndex]);
        }

        function highlightCurrentPage() {
            var pageDivs = document.querySelectorAll(".page");
            for (var i = 0; i < pageDivs.length; i++) {
                if (i === currentIndex) {
                    pageDivs[i].classList.add("current-page");
                } else {
                    pageDivs[i].classList.remove("current-page");
                }
            }
        }

		 
		 function showPage(index) {
			
            var iframe = document.getElementById("pageFrame");
            iframe.src = pages[index];
            currentIndex = index;
            highlightCurrentPage();
            setTimerForNextPage();
        }
		showPage(currentIndex);
        //setInterval(rotatePages, 10000); // Rotate every 60 seconds (1 minute)
		// Start the rotation with the first page
        setTimerForNextPage();
    </script>
</head>
<body onload="showPage(0)" class="hold-transition skin-blue sidebar-mini" style="background-color: skin-blue;overflow-y: -webkit-paged-x;overflow: hidden;">
    <div class="page-container" style="background-color: skin-blue;">
        <div class="page" onclick="showPage(0)">Immigration</div>&nbsp;&nbsp;&nbsp;
        <div class="page" onclick="showPage(1)">e-Visa</div>&nbsp;&nbsp;&nbsp;
        <div class="page" onclick="showPage(2)">APIS</div>&nbsp;&nbsp;&nbsp;
        <div class="page" onclick="showPage(3)">e-Passport</div>
    </div>
    <div style="height:100%; ">
        <iframe id="pageFrame" src="index_pax.jsp" height='200'></iframe>
    </div>
	<!--<div>
        <div id="pageContent"></div>
    </div>-->
</body>
</html>
