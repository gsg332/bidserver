<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	
	<div>
		<div id="navbar" class="navbar navbar-left">
			<a href="<c:url value='/'/>"><img src="<c:url value='/images/CI_colorsys_02.png'/>" style="width:60%"></a>
		</div>
		<div id="navbar-1" class="navbar navbar-right">
			<ul>
				<!-- 추가개발 -->
				<li><a href="<c:url value='/admin/distribution/main.do'/>">입찰관리</a></li>
				<li><a href="<c:url value='/admin/opening/main.do'/>">개찰관리</a></li>
				<li><a href="<c:url value='/admin/enterprise/main.do'/>">업체관리</a></li>
				<li><a href="<c:url value='/admin/project/main.do'/>">프로젝트관리</a></li>
				<li><a href="<c:url value='/admin/admin/codeMain.do'/>">코드관리</a></li>
				<li><a href="<c:url value='/admin/notice/main.do'/>">공지관리</a></li>
				<li><a href="<c:url value='/admin/analysis/main.do'/>">현황분석</a></li>
				<%-- <li><a href="<c:url value='/admin/apply/main.do'/>">입찰보고서</a></li> --%>
				<!-- // -->
			
				<%-- <li><a href="<c:url value='/admin/bidnotice/main.do'/>">입찰관리</a></li> --%>
				<%-- <li><a href="<c:url value='/admin/manufacture/main.do'/>">제조사관리</a></li> --%>
				<%-- <li><a href="<c:url value='/admin/business/main.do'/>">투찰사관리</a></li> --%>
				<%-- <li><a href="<c:url value='/admin/apply/main.do'/>">요청된공고</a></li> --%>		
				<%-- <li><a href="<c:url value='/admin/admin/userMain.do'/>">사용자관리</a></li> --%>								
				
				<li><%@ include file="/include/menu.jsp" %></li>
			</ul>
		</div>
	</div>
	
	
 
	<div style="clear:both"></div>
	