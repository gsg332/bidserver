<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%
 String loginId=(String)session.getAttribute("loginid");
 String loginok=(String)session.getAttribute("loginOK");
  
  %>
<link rel="shortcut icon" href="<c:url value='/images/favicon.ico'/>" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/demo.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/sub.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/jquery/themes/default/easyui.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/icon.css'/>">
<script type="text/javascript" src="<c:url value='/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/jquery/jquery.easyui.min.js'/>"></script>
<script type="text/javascript" src='<c:url value='/jquery/jquery.form.js'/>' ></script>
<script type="text/javascript" src='<c:url value='/jquery/jquery.json-2.3.min.js'/>' ></script>
<script type="text/javascript" src='<c:url value='/jquery/formatter.js'/>' ></script>
<script>
var typelogin = '<%=loginok%>';
if(typelogin=='null' || typelogin=='false'){
	location.href="<c:url value='/login.jsp'/>";
}
</script>
<script>
// 	easyloader.css = false;
</script>
