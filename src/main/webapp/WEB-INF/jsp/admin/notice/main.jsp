<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공지관리</title>
<%@ include file="/include/session.jsp" %>
	
<script>
$(document).ready(function() {
	eventInit();
	init();	
	setGrid();
	
	var ctrlDown = false;
	var ctrlKey = 17, qKey = 81;
	$(document)
	.keyup(function(e) { 
		if (e.keyCode == ctrlKey)
			ctrlDown = false; 
	})
	.keydown(function(e) {
		if (e.keyCode == ctrlKey){ 
			ctrlDown = true; 
		}
		if (ctrlDown && e.keyCode == qKey){
			$('ul.tabs li').each(function(i, e){
				if($(this).hasClass('tabs-selected')){
					$('.btnSearch').focus(); //input에서 벗어나야지 easy-ui에 의해 입력한 값이 유지되는 것 같음.
					setTimeout(function(){ //ie의 경우 focus후 값이 들어가는 시간이 긴 것 같기 때문에 딜레이를 주도록 함.
						switch (i) {
						case 0:
							break;
						case 1:
							selectBidList();								
							break;
						}
					},300);
				}
			});
		}
		//return false;
	});
});


function setGrid() {
	//tab1
	selectNoticeList();
	selectBidList();
}

//tab1 조회
function selectNoticeList(){
	$("#dg").datagrid({
		method : "GET",
		url : "<c:url value='/notice/selectNoticeList.do'/>",
		queryParams : {
		},
		onDblClickRow : function(index, row){
			getData(row);
		}
	});
}
//tab 조회
function selectBidList(){
	$("#dg2").datagrid({
		method : "GET",
		url : "<c:url value='/notice/selectSendMsgList.do'/>",
		queryParams : {
			bidStartDt : $('#bidStartDt').datebox('getValue'),
			bidEndDt : $('#bidEndDt').datebox('getValue'),
			bidNoticeNo : $('#searchBidType').combobox('getValue')=="1"?$('#bidNoticeNo').val():"",
			bidNoticeNm : $('#searchBidType').combobox('getValue')=="2"?$('#bidNoticeNo').val():"",
			companyNm : $('#searchBidType').combobox('getValue')=="3"?$('#bidNoticeNo').val():""
		},
		onLoadSuccess : function(row, param) {
			if(row.rows.length==0){
				$('#sendMsg').textbox('setValue',"");
			}else{
				$('#dg2').datagrid('selectRow', 0);
				$('#dg2').datagrid('fixColumnSize');
			}
		},
		onSelect : function(index, row){
			$('#sendMsg').textbox('setValue',row.message);
		}
	});
}
function clearNotice(){
	$("#notice_id").val("");
	$("#title").textbox("setValue","");
	$("#context").textbox("setValue","");
	$("#notice_type").combobox("setValue","1");
	$("#open_yn").switchbutton({checked:false});
	
	$('#title').textbox('textbox').attr('maxlength', '1000');
	$('#context').textbox('textbox').attr('maxlength', '4000');
	

	$("#file_id1").filebox("setValue","");
	$("#file_id2").filebox("setValue","");
	
	$('#file_link1').bind('click', function(){
	});
	$('#file_link2').bind('click', function(){
	});
	
	$("#type").val("I");
	
	$('#noticeDlg').dialog('open');
}

function getData(row){

	clearNotice();
	$("#notice_id").val(row.notice_id);
	$("#title").textbox("setValue",row.title);
	$("#context").textbox("setValue",row.context);
	$("#open_yn").switchbutton({checked:row.open_yn=='Y'?true:false});
	$("#notice_type").combobox("setValue",row.notice_type);
	$("#file_id1").textbox("setValue",row.file_nm1);
	$("#file_id2").textbox("setValue",row.file_nm2);
	
	$('#file_link1').unbind('click',null);
	$('#file_link2').unbind('click',null);
	$('#file_remove1').unbind('click',null);
	$('#file_remove2').unbind('click',null);
	$("#type").val("U");
	
	$('#file_link1').bind('click', function(){
		if($("#file_id1").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id1+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#file_link2').bind('click', function(){
		if($("#file_id2").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id2+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	
	$('#file_remove1').bind('click', function(){
		if($("#file_id1").textbox("getText").length>0){
			$("#file_id1").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#file_remove2').bind('click', function(){
		if($("#file_id2").textbox("getText").length>0){
			$("#file_id2").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	
}
function init(){
	var dts = new Date();
	var bidStartDt = new Date();
	var bidEndDt = new Date();
    var dayOfMonth = dts.getDate();
    bidStartDt.setDate(dayOfMonth-7);
    bidEndDt.setDate(dayOfMonth+30);
    bidStartDt = bidStartDt.getFullYear()+"-"+((bidStartDt.getMonth() + 1)<9?"0"+(bidStartDt.getMonth() + 1):(bidStartDt.getMonth() + 1))+"-"+bidStartDt.getDate();
    bidEndDt = bidEndDt.getFullYear()+"-"+((bidEndDt.getMonth() + 1)<9?"0"+(bidEndDt.getMonth() + 1):(bidEndDt.getMonth() + 1))+"-"+bidEndDt.getDate();
    
    $('#bidStartDt').datebox('setValue',bidStartDt);
    $('#bidEndDt').datebox('setValue',bidEndDt);
       
}
function eventInit(){
	var t = $('#bidNoticeNo');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectBidList();
	   }
	});	
	
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
				 	<div title="공지관리" style="padding:5px">
				        <table style="width: 100%;">
							<tr>
								<td width="20%" align="right">
					            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append()">추가</a>
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="save()">삭제</a>
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
								  pageSize:100,
								  pageList:[100,50,200,500],
								  method:'get',
								  striped:true,
								  nowrap:false">
			                <thead>
			                    <tr>
			                        <th data-options="field:'notice_id',align:'right',halign:'center'" width="80">공지번호</th>
			                        <th data-options="field:'notice_type',align:'center',halign:'center'" width="80" formatter="formatNoticeType">유형</th>
			                        <th data-options="field:'title',align:'left',halign:'center'" width="500">제목</th>
			                        <th data-options="field:'open_yn',align:'center',halign:'center',width:70">공개여부</th>
			                        <th data-options="field:'user_nm',align:'center',halign:'center',width:70">등록자</th>
			                        <th data-options="field:'create_dt',align:'center',halign:'center'" width="200">등록일시</th>
			                    </tr>
			                </thead>
			            </table>
			            <script>
			            	function formatNoticeType(val,row){
								if(val=="1"){
									return "공지사항";
								}else if(val=="2"){
									return "언론소개";
								}else if(val=="3"){
									return "자료실";
								}else{
									return "";
								}
			            	}
			            
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
								clearNotice();
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
											effectRow["notice_id"] = $dg.datagrid('getSelected').notice_id;
						    				$.post("<c:url value='/notice/deleteNoticeList.do'/>", effectRow, function(rsp) {
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
						    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
							        if (r){

						    			var form = new FormData(document.getElementById('uploadForm'));										    				
					    				form.append("notice_id", encodeURIComponent($("#notice_id").val()));
						    			form.append("type", encodeURIComponent($("#type").val()));
					    				form.append("title", encodeURIComponent($("#title").textbox("getValue")));
					    				form.append("context", encodeURIComponent($("#context").textbox("getValue")));
					    				form.append("notice_type", encodeURIComponent($("#notice_type").combobox("getValue")));
					    				form.append("open_yn", encodeURIComponent($("#open_yn").switchbutton("options").checked?'Y':'N'));
					    				form.append("file_id1", encodeURIComponent($("#file_id1").filebox("getText")));
					    				form.append("file_id2", encodeURIComponent($("#file_id2").filebox("getText")));
					    				
					    				    $.ajax({
					    				      url: "<c:url value='/notice/updateNoticeList.do'/>",
					    				      data: form,
					    				      dataType: 'text',
					    				      processData: false,
					    				      contentType: false,
					    				      type: 'POST',
					    				      success: function (rsp) {
						    				    	  $.messager.alert("알림", "저장하였습니다.");
						 	    						 $("#dg").datagrid('reload');
						 	    						$('#noticeDlg').dialog('close');
							    						
					    				      },
					    				      error: function (jqXHR) {
					    				        console.log('error');
					    				      }
					    				    });
							        }
						    	});
							}
							
			            </script>
					</div>
					<div title="발신메세지" style="padding: 5px">
							<div class="easyui-layout" style="width:100%;height:750px;">
							    <div data-options="region:'north',border:false">
							    	<table style="width: 100%;">
										<tr>
											<td class="bc">공고</td>
											<td>
												<select class="easyui-combobox" id="searchBidType" data-options="panelHeight:'auto'"  style="width:100px;">
												        <option value="1">공고번호</option>
												        <option value="2">공고명</option>
												        <option value="3">업체명</option>
												</select>
												<input type="text" class="easyui-textbox" id="bidNoticeNo" style="width: 120px;">
											</td>
											<td class="bc">발신일</td>
											<td>
											<input class="easyui-datebox" id="bidStartDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
											~ <input class="easyui-datebox" id="bidEndDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
											</td>
											<td width="200px">
												<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectBidList()">조회</a> 
											</td>
										</tr>
									</table>
							    </div>
							    <div data-options="region:'center',border:false">
							    	<table id="dg2" class="easyui-datagrid"
										style="width: 100%; height: 100%"
										data-options="rownumbers:true,
													  singleSelect:true,
													  pagination:true,
													  pageSize:100,
													  sortName:'send_time',
													  sortOrder:'desc',
													  method:'get',
													  striped:true,
													  pageList:[100,50,200,500],
													  nowrap:false">
										<thead>
											<tr>
												<th data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true"	formatter="formatNoticeNo">공고번호</th>
												<th data-options="field:'business_no',align:'left',width:60,halign:'center',sortable:true">업체번호</th>
												<th data-options="field:'company_nm',align:'left',width:200,halign:'center',sortable:true">업체명</th>
												<th data-options="field:'catagory',align:'center',width:100,halign:'center',sortable:true"	formatter="formatCatagory">카테고리</th>
												<th data-options="field:'message_type',align:'center',width:50,halign:'center',sortable:true">유형</th>
												<th data-options="field:'subject',align:'left',width:150,halign:'center'">제목</th>
												<th data-options="field:'receiver',align:'center',width:150,halign:'center'">수신자정보</th>
												<th data-options="field:'send_nm',align:'center',width:80,halign:'center'">발신자</th>
												<th data-options="field:'send_time',align:'center',width:150,halign:'center',sortable:true">발신일</th>
											</tr>
										</thead>
									</table>
									<script>
										function formatCatagory(val,row){
											if(val=="sendBusiness"){
												return "투찰사";
											}else if(val=="sendManufacture"){
												return "제조사";
											}else{
												return "";
											}
										}
									</script>
							    </div>
							    <div data-options="region:'east',collapsible:false" title="메세지 정보" style="width: 30%;">
							    	<input id="sendMsg" name="sendMsg" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 100%;" />
							    </div>
							</div>
					</div>
					</div>
				</div>
			</div>
		</div>
		</div>
		
		<div id="noticeDlg" class="easyui-dialog" title="공지사항"
			data-options="iconCls:'icon-save',modal:true,closed:true"
			style="width: 45%; height: 550px;">
			<div class="easyui-layout" style="width:100%;height:100%; border:0">
				<div data-options="region:'center'">
					<table style="width:100%;">
				        <tr>
				            <td width="60%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save2()">저장</a>
				            </td>
				        </tr>
				    </table>
				    <input type="hidden" id="notice_id" > 
				    <input type="hidden" id="type" > 
				 	<div class="easyui-panel" style="width:100%;padding:10px;border: 0">
				 		<table style="width: 100%">
								<tr>
									<td class="bc" width="150px">제목</td>
									<td> <input class="easyui-textbox" style="width:100%;height:26px" id="title"></td>
								</tr>
								<tr>
									<td class="bc" width="150px">내용</td>
									<td>
										<input  id="context" class="easyui-textbox" data-options="multiline:true" value="This TextBox will allow the user to enter multiple lines of text." style="width:100%;height:300px">
				        			</td>
								</tr>
								<tr>
									<td class="bc" width="150px">공개여부</td>
									<td>
										<input class="easyui-switchbutton" id="open_yn" data-options="onText:'Y',offText:'N'">
				        			</td>
								</tr>
								<tr>
									<td class="bc" width="150px">공지유형</td>
									<td>
										<select class="easyui-combobox" id="notice_type" data-options="panelHeight:'auto'"  style="width:100px;">
										        <option value="1">공지사항</option>
										        <option value="2">언론소개</option>
										        <option value="3">자료실</option>
										</select>
				        			</td>
								</tr>
								<tr>
									<td class="bc" width="150px">첨부파일</td>
									<td>
										<form id="uploadForm" enctype="multipart/form-data">
											<div style="width:100%;">
											     <input id="file_id1" class="easyui-filebox" name="file1" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:350px;height:24px;">
												 <a id="file_link1" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
												 <a id="file_remove1" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
											</div>
											<div style="width:100%;">
											     <input id="file_id2" class="easyui-filebox" name="file2" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:350px;height:24px;">
												 <a id="file_link2" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
												 <a id="file_remove2" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
											</div>
										</form>
				        			</td>
								</tr>
						</table>
								
				    </div>

				</div>
			</div>
		</div>
   <%@ include file="/include/popup.jsp" %>
</body>
</html>