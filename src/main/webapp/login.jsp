<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <%
	 String loginId=(String)session.getAttribute("loginid");
	 String loginok=(String)session.getAttribute("loginOK");
  %>
<title>조달관리 시스템</title>

<link rel="stylesheet" href='<c:url value="/css/basic.css"/>' type="text/css">
<script type="text/javascript" src="<c:url value='/jquery/jquery.min.js'/>"></script>
<script>
var typelogin = '<%=loginok%>';

$(document).ready(function(){
	
	if(typelogin == 'true'){
		location.href="<c:url value='/admin/distribution/main.do'/>";
	}
	if('${param.isNotLogin}'){
		alert('로그인 정보가 존재하지 않습니다. 다시 로그인 해 주시기 바랍니다.');		
	}
});

</script>

<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta http-equiv="X-UA-Compatible" content="IE=7">
	<meta http-equiv="X-UA-Compatible" content="IE=8">
	<meta http-equiv="X-UA-Compatible" content="IE=9">

</head>
<body>
	<div id="wrap" class="main">
		<div class="center">
		<div id="top">
			<div class="logo"><a href="<c:url value='/'/>"><img src='<c:url value="/images/INCON logo_Small.png"/>' style="width: 100%"/></a></div>
			<div class="t_right">
			<%@ include file="/include/menu.jsp" %> 
			</div>
		</div>
		<div id="contents">
			<div class="main_left">
				<div class="main_slogan"><img src='<c:url value="/images/main_slogan.png"/>' alt="Digital Solution Network" title="Digital Solution Network" /></div>
			</div>
			<div class="clear"></div>
			<div class="main_schedule">
					<div id="chart1" style="margin-left:45px;width:550px; height:270px;"></div>
			</div>			
		</div>
		
		<hr size="1" color="#e4e4e4"/>
		</div>
	</div>
</body>
</html>