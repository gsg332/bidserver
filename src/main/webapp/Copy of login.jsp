<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <%
 String loginId=(String)session.getAttribute("loginid");
 String loginok=(String)session.getAttribute("loginOK");
  
  %>
 

<title>팁스밸리</title>

<link rel="stylesheet" href='<c:url value="/css/basic.css"/>' type="text/css">
<link rel="stylesheet" href='<c:url value="/css/jquery.jqplot.min.css"/>' type="text/css">

<script type="text/javascript" src='<c:url value="/js/basic.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/packed.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/script.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/jquery-1.4.2.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/slotmachine.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/jquery-1.6.1.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/jquery.model.js"/>'></script>

<script type="text/javascript" src='<c:url value="/js/excanvas.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/jquery-1.8.3.js"/>'></script>

<script type="text/javascript" src='<c:url value="/lib/js/jqPlot/jquery.jqplot.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/lib/js/jqPlot/plugins/jqplot.json2.min.js"/>'></script>
<link rel="stylesheet" href='<c:url value="/lib/js/jqPlot/jquery.jqplot.min.css"/>' type="text/css">
<script type="text/javascript" src='<c:url value="/lib/js/jqPlot/plugins/jqplot.highlighter.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/lib/js/jqPlot/plugins/jqplot.pointLabels.min.js"/>'></script>



  
   <script type="text/javascript" src="<c:url value='/jquery/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/jquery/jquery.easyui.min.js'/>"></script>
		<script src='<c:url value='/jquery/jquery.form.js'/>' type="text/javascript"></script>
<script src='<c:url value='/jquery/./jquery.json-2.3.min.js'/>' type="text/javascript"></script>
 
 
<script>
var typelogin = '<%=loginok%>';

$(document).ready(function(){
	getMCO();
// 	getChange();
	getNotice();
	
	var ajaxDataRenderer = function(url, plot, option){
		var ret = null;
		$.ajax({
			async:false,
			url:url,
		 	dataType:'json',
		 	success: function(result){
		 		
		 		ret=result;
		 		
		 	}
		});
		return ret;
	};

	var line = "boardList.do?method=jqplot&query=board.getChartData";
	
	var plot = $.jqplot('chart1',line,{
				title: '목표대비 실적그래프',
				dataRenderer: ajaxDataRenderer,
				highlighter: {
					show: true,
					edgeTolerance: 5
				},
				axes: {
					 xaxis:{
						 label: 'month',
						 min: 1,
						 max: 12,
						 tickInterval: 1,
						 tickOptions: {formatString: '%d'}
					 },
					 yaxis:{
						 label: '%'
					 }
					 
				},
				series:[
					{label:'목표'},
					{label:'실적'}
				],
				legend: {
					show:true,
					placement: 'outsideGrid'
				}
				
// 				 dataRendererOptions: {
// 		 		      unusedOptionalUrl: line
// 		 		    }
	});


});


function getMCO(){
/* 
	$.ajax({
		 type: "POST",
		   url: "<c:url value='/designMCO.do'/>",
		   //폼 데이터
		   data: {"method":"getMCOMain"
			  	  , "query":"designMCO.getMCOMain"
		    },
		   dataType:"json",
		   success: function(result) 
		   {
			   for(var i=0; i<result.length; i++){
				   $("#mco"+i).text(result[i].CHANGECONTS);
				   $("#mco"+i).attr('onclick',"clickMCO('"+result[i].PUBLICID+"')");
			   }
			   
			  }
		    ,error:function(request,status,error){
       			alert("code:"+request.status+"\n" +"message:" +request.responseText+"\n" +"error:" +error);
			 } 
	}); */
}

function getChange(){
/* 	$.ajax({
		 type: "POST",
		 
		   url: "<c:url value='/designChangeMgt.do'/>",
		   //폼 데이터
		   data: {"method":"getChangeMain"
			  	  , "query":"designChange.getChangeMain"
		    },
		   dataType:"json",
		   success: function(result) 
		   {
			   for(var i=0; i<result.length; i++){
				   $("#change"+i).text(result[i].TITLE);
				   $("#change"+i).attr('onclick',"clickChange('"+result[i].CHANGEID+"')");
			   }
			  }
		    ,error:function(request,status,error){
      			alert("code:"+request.status+"\n" +"message:" +request.responseText+"\n" +"error:" +error);
			 } 
	}); */
}

function getNotice(){
	/* $.ajax({
		 type: "POST",
		   url: "<c:url value='/boardList.do'/>",
		   //폼 데이터
		   data: {"method":"getBoardMain"
			  	  , "query":"board.getBoardMain"
			  	  , "type":"notice"
		    },
		   dataType:"json",
		   success: function(result) 
		   {
			   for(var i=0; i<result.length; i++){
				   $("#board"+i).text(result[i].TITLE);
				   $("#board"+i).attr('onclick',"clickBoard('"+result[i].BOARDID+"')");
			   }
			   
			  }
		    ,error:function(request,status,error){
      			alert("code:"+request.status+"\n" +"message:" +request.responseText+"\n" +"error:" +error);
			 } 
	}); */
}

function clickChange(tag){
	if(typelogin != 'true'){
		alert("로그인 후 이용해 주세요.");
		return;
	}
	location.href="<c:url value='/designChangeMgt.do?method=updateView'/>&query=designChange.getChange&changeid="+tag;
}

function moveChangeList(){
	if(typelogin != 'true'){
		alert("로그인 후 이용해 주세요.");
		return;
	}
	location.href="<c:url value='/designChangeMgt.do?method=list'/>";
}

function clickMCO(tag){
	if(typelogin != 'true'){
		alert("로그인 후 이용해 주세요.");
		return;
	}
	location.href="<c:url value='/designMCO.do?method=write'/>&publicid="+tag;
}

function moveMCOList(){
	if(typelogin != 'true'){
		alert("로그인 후 이용해 주세요.");
		return;
	}
	location.href="<c:url value='/designMCO.do?method=list'/>";
}

function clickBoard(tag){
	location.href="<c:url value='/boardList.do?method=getWriteNoticeMain&query=board.getWriteMain'/>&boardid="+tag;
}


</script>
</head>

<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta http-equiv="X-UA-Compatible" content="IE=7">
	<meta http-equiv="X-UA-Compatible" content="IE=8">
	<meta http-equiv="X-UA-Compatible" content="IE=9">

<body>
	<div id="wrap" class="main">
		<div class="center">
		<div id="top">
			<div class="logo"><a href="#"><img src='<c:url value="/images/logo.gif"/>' alt="대동공업" title="대동공업" /></a></div>
			<div class="t_right">
			<%@ include file="/include/menu.jsp" %> 
			</div>
		</div>
		<div id="contents">
			<div class="main_left">
				<div class="main_slogan"><img src='<c:url value="/images/main_slogan.png"/>' alt="Digital Solution Network" title="Digital Solution Network" /></div>
				<div class="main_notice">
					<div class="title">
						<img src='<c:url value="/images/main_title_notice.png"/>' alt="공지사항" title="공지사항" />
						<img src='<c:url value="/images/main_more2.png"/>' alt="더보기" title="더보기" /></span>
					</div>
					<div class="list">
						<ul>
							<li><a id="board0" href="#"></a></li>
							<li><a id="board1" href="#"></a></li>
							<li><a id="board2" href="#"></a></li>
							<li><a id="board3" href="#"></a></li>
							<li><a id="board4" href="#"></a></li>
						</ul>
					</div>
				</div>
				<div class="main_quick">
					<ul>
						<li><a href="<c:url value='/bop/bopDesign.jsp'/>"><img src='<c:url value="/images/main_icon01.png"/>' alt="BOP설계" title="BOP설계" /></a></li>
						<li><a href="<c:url value='/bop/bopLogistics.jsp'/>"><img src='<c:url value="/images/main_icon02.png"/>' alt="BOP물류" title="BOP물류" /></a></li>
						<li><a href="<c:url value='/bop/bopTools.jsp'/>"><img src='<c:url value="/images/main_icon03.png"/>' alt="치공구" title="치공구" /></a></li>
						<li><a href="<c:url value='/bop/bopMultiProcess.jsp'/>"><img src='<c:url value="/images/main_icon04.png"/>' alt="멀티공정" title="멀티공정" /></a></li>
					</ul>
				</div>
			</div>
			<div class="main_visual">
				<div>
					<!-- <div class="sliderbutton"><img src="./syproject/common/images/left.gif" width="32" height="38" alt="Previous" onclick="slideshow.move(-1)" /></div> -->
					<div id="slider">
						<ul>
							<li><%-- <img src='<c:url value="/images/main_prod01.png"/>' width="435" height="405" alt="콤파인" title="콤파인"/> --%></li>
							<li><img src='<c:url value="/images/main_prod02.png"/>' width="435" height="405" alt="트랙터" title="트랙터"/></li>
							<li><img src='<c:url value="/images/main_prod03.png"/>' width="435" height="405" alt="경운기" title="경운기"/></li>
						</ul>
					</div>
					<!-- <div class="sliderbutton"><img src="./syproject/common/images/right.gif" width="32" height="38" alt="Next" onclick="slideshow.move(1)" /></div> -->
				</div>
				<div class="mainlayout"><img src='<c:url value="/images/visual_layout.png"/>' width="435" height="405" alt="" title=""/></div>
				<ul id="pagination" class="pagination">
					<li onclick="slideshow.pos(0)">&nbsp;</li>
					<li onclick="slideshow.pos(1)">&nbsp;</li>
					<li onclick="slideshow.pos(2)">&nbsp;</li>
				</ul>
			</div>
			<div class="clear"></div>
			<div class="main_news">
				<div id="slot-machine-tabs">
					<ul class="tabs">
						<li><a href="#one" onclick="return false;">MCO발행</a></li>
						<li><a href="#two" onclick="return false;">MCR발행</a></li>
						<li><a href="#three" onclick="return false;">변경초도품관리</a></li>
					</ul>        	
					<div class="box-wrapper">        	    	
						<div id="one" class="content-box">
							<div class="col-one col">
								<ul class="news_list">
									<li><a id="mco0" href="#"></a></li>
									<li><a id="mco1" href="#"></a></li>
									<li><a id="mco2" href="#"></a></li>
									<li><a id="mco3" href="#"></a></li>
									<li><a id="mco4" href="#"></a></li>
									<li><a id="mco5" href="#"></a></li>
									<li><a id="mco6" href="#"></a></li>
									<li><a id="mco7" href="#"></a></li>
									<li><a id="mco8" href="#"></a></li>
								</ul>
							</div>
						</div>
						<div id="two" class="content-box">
							<div class="col-one col">
								<ul class="news_list">
									<li><a id="mcr0" href="#">222</a></li>
									<li><a id="mcr1" href="#"></a></li>
									<li><a id="mcr2" href="#"></a></li>
									<li><a id="mcr3" href="#"></a></li>
									<li><a id="mcr4" href="#"></a></li>
									<li><a id="mcr5" href="#"></a></li>
									<li><a id="mcr6" href="#"></a></li>
									<li><a id="mcr7" href="#"></a></li>
									<li><a id="mcr8" href="#"></a></li>
								</ul>

							</div>
						</div>
						<div id="three" class="content-box">
							<div class="col-one col">								
								<ul class="news_list">
									<li><a id="change0" href="#">333</a></li>
									<li><a id="change1" href="#"></a></li>
									<li><a id="change2" href="#"></a></li>
									<li><a id="change3" href="#"></a></li>
									<li><a id="change4" href="#"></a></li>
									<li><a id="change5" href="#"></a></li>
									<li><a id="change6" href="#"></a></li>
									<li><a id="change7" href="#"></a></li>
									<li><a id="change8" href="#"></a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="main_schedule">
<%-- 				<img src='<c:url value="/images/main_schedule.gif"/>' alt="스케줄모듈" title="스케줄모듈"/> --%>
<!-- 				<div class="easyui-calendar" style="width:350px;height:255px;"></div> -->
					<div id="chart1" style="margin-left:45px;width:550px; height:270px;"></div>
			</div>			
		</div>
		
		<hr size="1" color="#e4e4e4"/>
		<div id="footer">
			<div class="f_logo"><img src='<c:url value="/images/f_logo.gif"/>' alt="대동공업" title="대동공업"/></div>
			<div class="f_txt">
				<img src='<c:url value="/images/f_copy.gif"/>' alt="대동공업" title="대동공업"/>
			</div>
		</div>
		</div>
	</div>

<script type="text/javascript">
var slideshow=new TINY.slider.slide('slideshow',{
	id:'slider',
	auto:3,
	resume:true,
	vertical:false,
	navid:'pagination',
	activeclass:'current',
	position:0
});
</script>
<div>
	<div><a href="#dialog1" name="modal">click</a></div>
	<div id="boxes">
		<div id="dialog1" class="window">
			<div class="closeicon"><a href="#"class="close"/><img src='<c:url value="/images/close_t.png" />' alt="Close"></a></div>
			<div class="img"><img src='<c:url value="/images/demo.png" />' alt="demo"></div>
		</div>				
		<div id="mask"></div>
	</div>
</div>
</body>
</html>