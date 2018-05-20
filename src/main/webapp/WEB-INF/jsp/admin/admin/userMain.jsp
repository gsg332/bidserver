<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사용자관리</title>
<%@ include file="/include/session.jsp" %>
	
<script>
$(document).ready(function() {
	setGrid();
});

var jsonData=[{role_cd:'',role_nm:'선택'},{role_cd:1,role_nm:'담당자'},{role_cd:2,role_nm:'팀장'},{role_cd:3,role_nm:'총괄책임자'}];


function setGrid() {
	//tab1
	selectUserList();
}

//tab1 조회
function selectUserList(){
	$("#dg").datagrid({
		method : "GET",
		url : "<c:url value='/user/selectUserList.do'/>",
		queryParams : {
		},
		onDblClickRow : function(index, row){
			getData(row);
		}
	});
}

function clearUser(){
	$("#user_id").textbox("setValue","");
	$("#user_nm").textbox("setValue","");
	$("#pwd").textbox("setValue","");
	$("#team").textbox("setValue","");
	$("#email").textbox("setValue","");
	$("#email_pw").textbox("setValue","");
	$("#email_host").textbox("setValue","smart.whoismail.net");
	$("#email_port").textbox("setValue","587");
	$('#role_cd').combobox('setValue',"");
	$("#tel").textbox("setValue","");
	$("#mobile").textbox("setValue","");
	$("#fax").textbox("setValue","");
	$("#position").textbox("setValue","");
	
	$('#user_id').textbox('textbox').attr('maxlength', '100');
	$('#user_nm').textbox('textbox').attr('maxlength', '100');
	$('#pwd').textbox('textbox').attr('maxlength', '100');
	$('#team').textbox('textbox').attr('maxlength', '100');
	$('#email').textbox('textbox').attr('maxlength', '100');
	$('#email_pw').textbox('textbox').attr('maxlength', '100');
	$('#email_host').textbox('textbox').attr('maxlength', '100');
	$('#email_port').textbox('textbox').attr('maxlength', '100');
	$('#tel').textbox('textbox').attr('maxlength', '100');
	$('#mobile').textbox('textbox').attr('maxlength', '100');
	$('#fax').textbox('textbox').attr('maxlength', '100');
	$('#position').textbox('textbox').attr('maxlength', '100');
	
	$("#type").val("I");
	$("#user_id").textbox({disabled:false});
	$("#userIdBtn").linkbutton("enable");
	
	$('#userDlg').dialog('open');
}

function getData(row){

	clearUser();
	$("#user_id").textbox("setValue",row.user_id);
	$("#user_nm").textbox("setValue",row.user_nm);
	$("#team").textbox("setValue",row.team);
	$("#email").textbox("setValue",row.email);
	$("#email_pw").textbox("setValue",row.email_pw);
	$("#email_host").textbox("setValue",row.email_host);
	$("#email_port").textbox("setValue",row.email_port);
	$("#role_cd").combobox("setValue",row.role_cd);
	$("#tel").textbox("setValue",row.tel);
	$("#mobile").textbox("setValue",row.mobile);
	$("#fax").textbox("setValue",row.fax);
	$("#position").textbox("setValue",row.position);

	$("#type").val("U");
	$("#chkId").val("Y");
	
	$("#user_id").textbox({disabled:true});
	$("#userIdBtn").linkbutton("disable");
	
	
}

</script>	
 </head>
<body>

	<div id="header" class="group wrap header">
		<div class="content">
		<%@ include file="/include/top.jsp" %>
		</div>
	</div>
	<div id="mainwrap">
		<div id="content">
			<div style="margin: 1px 0; vertical-align: top"></div>
			<div class="easyui-layout" style="width:100%;height:800px;">
				<div data-options="region:'center'">
					<div class="easyui-tabs" data-options="fit:true,border:false,plain:true">
				 	<div title="사용자목록" style="padding:5px">
				        <table style="width: 100%;">
							<tr>
								<td width="20%" align="right">
<!-- 									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a> -->
					            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append()">추가</a>
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="save()">삭제</a>
<!-- 												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a> -->
					            </td>
							</tr>
						</table>
						<div style="display: none;">
							<table class="easyui-datagrid"
									style="width:0px;height:0px;border: 0" 
									>
							</table>
						</div>
			            <table id="dg" class="easyui-datagrid"
					           style="width:100%;height:90%;" 
			                   data-options=" method:'get',
			                   	  rownumbers:true,
			                   	  singleSelect:true,
								  pagination:true,
								  pageSize:30,
								  method:'get',
								  striped:true,
								  nowrap:false">
			                <thead>
			                    <tr>
			                        <th rowspan="2" data-options="field:'user_id',align:'left',halign:'center'" width="150">사용자 ID</th>
			                        <th rowspan="2" data-options="field:'user_nm',align:'left',halign:'center'" width="100">사용자명</th>
			                        <th rowspan="2" data-options="field:'team',align:'left',halign:'center'" width="80">팀명</th>
			                        <th rowspan="2" data-options="field:'role_nm',halign:'center',width:70">권한</th>
			                        <th rowspan="2" data-options="field:'position',align:'left',halign:'center'" width="60">직급</th>
			                        <th rowspan="2" data-options="field:'email',halign:'center'" width="200">이메일주소</th>
			                        <th rowspan="2" data-options="field:'tel',align:'left',halign:'center'" width="120">연락처</th>
			                        <th rowspan="2" data-options="field:'mobile',align:'left',halign:'center'" width="120">휴대폰</th>
			                        <th rowspan="2" data-options="field:'fax',align:'left',halign:'center'" width="120">팩스</th>
			                        <th	colspan="2">메일계정정보</th>
			                        <th rowspan="2" data-options="field:'last_login',halign:'center'" width="150">최종로그인</th>
			                    </tr>
			                    <tr>
			                        <th data-options="field:'email_host',align:'left',halign:'center'" width="150">SMTP</th>
			                        <th data-options="field:'email_port',align:'left',halign:'center'" width="50">PORT</th>
								</tr>
			                </thead>
			            </table>
			            <script>
				            var editIndex = undefined;
							function endEditing(){
								if (editIndex == undefined){return true}
								if ($('#dg').datagrid('validateRow', editIndex)){
							 		$('#dg').datagrid('endEdit', editIndex);
									editIndex = undefined;
									return true;
								} else {
									return false;
								}
							}
							function append(){
								clearUser();
							}
							
							function pwd(){
								$('#pwdDlg').dialog('open');
							}
							
							function save(){
						    	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
							        if (r){
							        	if (endEditing()){
							    			var $dg = $("#dg");

						    				var effectRow = new Object();
											effectRow["user_id"] = $dg.datagrid('getSelected').user_id;
						    				$.post("<c:url value='/user/deleteUserList.do'/>", effectRow, function(rsp) {
						    					if(rsp.status){
						    						$.messager.alert("알림", "삭제하였습니다.");
						    						setGrid();
						    					}
						    				}, "JSON").error(function() {
						    					$.messager.alert("알림", "저장에러！");
						    				});
							    		}
							        }
						    	});
							}
							function save2(){
								
								if($("#user_id").textbox("getValue").length==0 || $("#pwd").textbox("getValue").length==0){
									$.messager.alert("알림", "사용자ID 및 PW를 입력해주세요.");
									return;
								}
								if($("#team").textbox("getValue").length==0){
									$.messager.alert("알림", "팀명을 입력해주세요.");
									return;
								}
								if($("#role_cd").combogrid("getValue").length==0){
									$.messager.alert("알림", "권한을 입력해주세요.");
									return;
								}
								if($("#email").textbox("getValue").length==0 || $("#email_pw").textbox("getValue").length==0 ||
								   $("#email_host").textbox("getValue").length==0 || $("#email_port").textbox("getValue").length==0 ){
									$.messager.alert("알림", "메일정보를 입력해주세요.");
									return;
								}
								
								if($("#tel").textbox("getValue").length==0 || $("#mobile").textbox("getValue").length==0 || $("#fax").textbox("getValue").length==0){
									$.messager.alert("알림", "전화번호 및 팩스를 입력해주세요.");
									return;
								}
								
								if($("#chkId").val()!="Y"){
									$.messager.alert("알림", "아이디를 확인해주세요.");
									return;
								}
								
						    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
							        if (r){
						    			var effectRow = new Object();
						    			effectRow["type"] = $("#type").val();
						    			effectRow["user_id"] = $("#user_id").textbox("getValue");
						    			effectRow["user_nm"] = $("#user_nm").textbox("getValue");
					    				effectRow["pwd"] = $("#pwd").textbox("getValue");
					    				effectRow["team"] = $("#team").textbox("getValue");
					    				effectRow["role_cd"] = $("#role_cd").combogrid("getValue");
					    				effectRow["tel"] = $("#tel").textbox("getValue");
					    				effectRow["mobile"] = $("#mobile").textbox("getValue");
					    				effectRow["fax"] = $("#fax").textbox("getValue");
					    				effectRow["position"] = $("#position").textbox("getValue");
					    				effectRow["email"] = $("#email").textbox("getValue");
					    				effectRow["email_pw"] = $("#email_pw").textbox("getValue");
					    				effectRow["email_host"] = $("#email_host").textbox("getValue");
					    				effectRow["email_port"] = $("#email_port").textbox("getValue");
					    				
					    				$.post("<c:url value='/user/updateUserList.do'/>", effectRow, function(rsp) {
					    					if(rsp.status=="200"){
					    						$.messager.alert("알림", "저장하였습니다.");
					    						 $("#dg").datagrid('reload');
					    						$('#userDlg').dialog('close');
					    					}else if(rsp.status=="100"){
					    						$.messager.alert("알림", "비밀번호가 일치하지 않습니다.");
					    					}else if(rsp.status=="101"){
					    						$.messager.alert("알림", "동일 권한 사용자가 존재합니다.");
					    					}
					    				}, "JSON").error(function() {
					    					$.messager.alert("알림", "저장에러！");
					    				});
							        }
						    	});
							}
							
							function chgId( newValue,oldValue ){
								if(oldValue!=newValue){
									$("#chkId").val("");
								}
							}
							
							function chkUserId(){
								if($("#user_id").textbox("getValue").length==0){
									$.messager.alert("알림", "아이디를 입력해주세요.");
									return;
								}
								
				    			var effectRow = new Object();
				    			
				    			effectRow["user_id"] = $("#user_id").textbox("getValue");
			    				
			    				$.post("<c:url value='/user/chkUserId.do'/>", effectRow, function(rsp) {
			    					if(rsp.status=="100"){
			    						$.messager.alert("알림", "사용하는 ID입니다.");
			    					}else if(rsp.status=="200"){
			    						$.messager.alert("알림", "사용가능합니다.");
			    						$("#chkId").val("Y");
			    					}
			    				}, "JSON").error(function() {
			    					$.messager.alert("알림", "저장에러！");
			    				});
							}
							
							function chgUserPwd(){
								if($("#oldPwd").textbox("getValue").length==0){
									$.messager.alert("알림", "이전 PW를 입력해주세요.");
									return;
								}
								if($("#newPwd").textbox("getValue").length==0){
									$.messager.alert("알림", "새로운 PW를 입력해주세요.");
									return;
								}
								if($("#rePwd").textbox("getValue").length==0){
									$.messager.alert("알림", "PW 확인을 입력해주세요.");
									return;
								}
								if($("#newPwd").textbox("getValue") != $("#rePwd").textbox("getValue")){
									$.messager.alert("알림", "재입력한 PW가 새로운 PW와 일치 하지 않습니다.");
									return;
								}
								
						    	$.messager.confirm('알림', '변경하시겠습니까?', function(r){
							        if (r){
						    			var effectRow = new Object();
						    			
						    			effectRow["oldPwd"] = $("#oldPwd").textbox("getValue");
					    				effectRow["newPwd"] = $("#newPwd").textbox("getValue");
					    				effectRow["rePwd"] = $("#rePwd").textbox("getValue");
					    				effectRow["user_id"] = $("#user_id").textbox("getValue");
					    				
					    				$.post("<c:url value='/user/chgUserPwd.do'/>", effectRow, function(rsp) {
					    					if(rsp.status=="100"){
					    						$.messager.alert("알림", "비밀번호가 일치 하지 않습니다.");
					    					}else if(rsp.status=="200"){
					    						$.messager.alert("알림", "변경하였습니다.");
					    						$('#pwdDlg').dialog('close');
					    					}
					    				}, "JSON").error(function() {
					    					$.messager.alert("알림", "저장에러！");
					    				});
							        }
						    	});
							}
			            </script>
					</div>
				</div>
			</div>
		</div>
	</div>
		</div>
		
		<div id="userDlg" class="easyui-dialog" title="사용자 정보"
			data-options="iconCls:'icon-save',modal:true,closed:true"
			style="width: 35%; height: 300px;">
			<div class="easyui-layout" style="width:100%;height:100%; border:0">
				<div data-options="region:'center'">
					<table style="width:100%;">
				        <tr>
				            <td width="60%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save2()">저장</a>
				            </td>
				        </tr>
				    </table>
				    <input type="hidden" id="type" style="width:100px"> 
				    <input type="hidden" id="chkId" style="width:100px" >
				 	<table style="width: 100%">
						<tr>
							<td class="bc" width="100px">사용자 ID</td>
							<td><input type="text" class="easyui-textbox" id="user_id" style="width:150px" data-options="onChange:chgId"/> <a id="userIdBtn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onClick="chkUserId()">확인</a></td>
							<td class="bc" width="100px">사용자명</td>
							<td><input type="text" class="easyui-textbox" id="user_nm" style="width:150px"/></td>
						</tr>
						<tr>
							<td class="bc" width="100px">사용자 PW</td>
							<td colspan="3"><input type="password" class="easyui-textbox" id="pwd" style="width:150px"> <a id="pwdBtn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="pwd()">변경</a></td>
						</tr>
						<tr>
							<td class="bc">팀명</td>
							<td><input type="text" class="easyui-textbox" id="team" style="width:150px"  ></td>
							<td class="bc">권한</td>
							<td>
								<input id="role_cd" class="easyui-combobox"
											data-options="
											method:'get',
									        valueField: 'role_cd',
									        textField: 'role_nm',
									        width:150,
									        panelHeight:'auto',
									        data:jsonData"/>
							</td>
						</tr>
						<tr>
							<td class="bc">전화번호</td>
							<td><input type="text" class="easyui-textbox" id="tel" style="width:150px"></td>
							<td class="bc">휴대폰번호</td>
							<td><input type="text" class="easyui-textbox" id="mobile" style="width:150px"></td>
						</tr>
						<tr>
							<td class="bc">팩스</td>
							<td><input type="text" class="easyui-textbox" id="fax" style="width:150px"></td>
							<td class="bc">직급</td>
							<td><input type="text" class="easyui-textbox" id="position" style="width:150px" ></td>
						</tr>
						<tr>
							<td class="bc">메일주소</td>
							<td><input type="text" class="easyui-textbox" id="email" style="width:150px"></td>
							<td class="bc">메일계정PW</td>
							<td><input type="password" class="easyui-textbox" id="email_pw" style="width:150px"></td>
						</tr>
						<tr>
							<td class="bc">메일계정서버</td>
							<td><input type="text" class="easyui-textbox" id="email_host" style="width:150px" disabled="disabled" ></td>
							<td class="bc">메일계정PORT</td>
							<td><input type="text" class="easyui-textbox" id="email_port" style="width:150px" disabled="disabled"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div id="pwdDlg" class="easyui-dialog" title="비밀번호 변경"
			data-options="iconCls:'icon-save',modal:true,closed:true"
			style="width: 15%; height: 180px;">
			<div class="easyui-layout" style="width:100%;height:100%; border:0">
				<div data-options="region:'center'">
				    <table style="width: 100%">
						<tr>
							<td class="bc" width="100px">이전 PW</td>
							<td><input type="text" class="easyui-textbox" id="oldPwd"></td>
						</tr>
						<tr>
							<td class="bc">새로운 PW</td>
							<td><input type="password" class="easyui-textbox" id="newPwd"></td>
						</tr>
						<tr>
							<td class="bc">재입력 PW</td>
							<td><input type="password" class="easyui-textbox" id="rePwd"></td>
						</tr>
					</table>
					<table style="width:100%;">
				        <tr>
				            <td width="100%" align="center">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="chgUserPwd()">변경</a>
				            </td>
				        </tr>
				    </table>
				</div>
			</div>
		</div>
   <%@ include file="/include/popup.jsp" %>
</body>
</html>