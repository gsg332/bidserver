 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
 <%@ include file="/include/auth.jsp"%>	
  <script>
  $(document).ready(function() {
	  if(localStorage.getItem("epno")!=null){
		  
		  $("input[name=epno]").val(localStorage.getItem("epno"));
		  $("input[name=eppw]").val(localStorage.getItem("eppw"));
		  
		  $("#ckidsave").attr("checked",true);
		   
	  }
	   
	   
	  
  $("#eppw").keydown(function(key){
    	if(key.keyCode == 13){
    		login(); 
    	}
    });
  
  
	<%if(!"true".equals(loginOK)){ %>
	
	$("a[login=ok]").attr("href","#");
	$("a[login=ok]").click(loginmessage);
	
	 
	
	<% } %>

   
  });

  
  
  function loginmessage() {
	  
	  alert('로그인 되지 않았습니다 로그인 바랍니다.');
	  
  }
  function login(){
	  
	  if($("input[name=epno]").val().length==0){
		  alert('아이디를 입력하세요.');
		  return;
	  }
	  if($("input[name=eppw]").val().length==0){
		  alert('비밀번호를 입력하세요.');
		  return;
	  }
	  
	 // alert($("input[name=epno]").val());
	  $.ajax({
		   type: "POST",
		   url: "<c:url value='/user/login.do'/>",
		   //폼 데이터
		   data: {"method":"checkLogin"
			  	  ,"query":"bomManagement.list" 
			  	  ,"epno":$("input[name=epno]").val()
			  	  ,"eppw":$("input[name=eppw]").val()
			  		 
		    },
		   //응답 데이터 포맷
		   dataType:"json",
		   //성공시
		   success: function(obj) 
		   {
		   	   	if(obj.loginOK=='true'){
		   	   		fncheckidsave();
		   			window.location.href="<c:url value='/admin/distribution/main.do'/>";
		   		} else {
		   			alert("잘못된 비밀번호 입니다.");
		   		}
		 	  }
		    ,error:function(request,status,error){
	            alert("code:"+request.status+"\n" +"message:" +request.responseText+"\n" +"error:" +error);
	      }  

		});   
	  
  }
  

  function logout(){
	  $.ajax({
		   type: "POST",
		   url: "<c:url value='/user/logout.do'/>",
		   //폼 데이터
		   data: {"method":"logout"
			  	  ,"query":"bomManagement.list" 
		    },
		   //응답 데이터 포맷
		   dataType:"json",
		   //성공시
		   success: function(obj) 
		   {
		    			window.location.href="<c:url value='/login.jsp'/>";
		 	}
		    ,error:function(request,status,error){
	            alert("code:"+request.status+"\n" +"message:" +request.responseText+"\n" +"error:" +error);
	      	}  
		});   
	  
  }
  	
//   	function goChangeMgt(){
<%--   		var check = '<%=loginOK%>'; --%>
//     	  if(check == 'true'){
//     		  location.href="<c:url value='/designChangeMgt.do?method=list'/>";
//     	  }else{
//     		  alert("로그인 후 이용해 주세요.");
//       		  return;
//     	  }
//   	}
  	
//   	function menuCheck(){
<%--   		var id = '<%=loginid%>'; --%>
//   		 $.ajax({
// 			   type: "POST",
// 			   url: "<c:url value='/bopManagementController.do'/>",
// 			   data: {"method":"menucheck"
// 				  	  ,"query":"bomManagement.menucheck" 
// 				  	  ,"loginid": id
// 				  	  ,"menuid": "PM00016"
// 			    },
// 			   dataType:"json",
// 			   //성공시
// 			   success: function(obj) 
// 			   {
// 				   console.log(obj);
				   
// 				  	location.href="<c:url value='/boardList.do?method=list&type=notice'/>";
				   
// 			 	  }
// 			    ,error:function(request,status,error){
// 		            alert("code:"+request.status+"\n" +"message:" +request.responseText+"\n" +"error:" +error);
// 		      }  
// 			});  
//   	}
   </script>
   <script type='text/javascript'>
//<![CDATA[


function fncSetValue()
{
       localStorage.setItem("epno",$("input[name=epno]").val());
       localStorage.setItem("eppw",$("input[name=eppw]").val());
}


function fncGetValue()
{
    var val = localStorage.getItem("epno");
    alert(val);
}


function fncClear()
{
    localStorage.clear();
}


function fncheckidsave(){
	if($("#ckidsave").is(":checked")){
		fncSetValue();
	}else {
		fncClear();
	}
}

//]]>
</script>
<div class="util">
	<ul>
		<%if("true".equals(loginOK)){ %>
			<li>로그인명 : <%=(String)session.getAttribute("loginidNM")%></li>
			<li><a href="javascript:logout()" style="line-height:0"><img src='<c:url value="/images/btn_logout.png"/>' alt="로그아웃" title="로그아웃" /></a></li>
		<%} else { %> 
			<li class="tt"><img src='<c:url value="/images/util_ID.png"/>' alt="ID" title="ID" /></li>
			<li><input type="text" name="epno" value=""/></li>
			<li class="tt"><img src='<c:url value="/images/util_PW.png"/>' alt="PW" title="PW" /></li>
			<li><input type="password" id="eppw" name="eppw" value=""   /></li>
			<li><a href="javascript:login()"><img src='<c:url value="/images/btn_login.png"/>' alt="로그인" title="로그인" /></a>
		 	 </li>	
		 	 
		 	 <li> 저장:</li><li><input type='checkbox' id="ckidsave" onclick='javascript:fncheckidsave();' style="width:20px" name="ckidsave" value='Y' /> 
			</li>
		<% } %>							
	 </ul>
</div>
<div class="clear"></div>
