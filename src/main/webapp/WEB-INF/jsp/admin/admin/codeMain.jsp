<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>코드관리</title>
<%@ include file="/include/session.jsp" %>
	<script type="text/javascript">
	
	$(document).ready(function() {
		
		keydownEvent();
		
		$('#tt').tree({
			onSelect : function (node){
				 if (node){
		                var parent = $('#tt').tree('getParent', node.target);
		                
		                $("#dg3").datagrid({
		        			method : "POST",
		        			url : "<c:url value='/code/selectEvalList.do'/>",
		        			queryParams : {
		        				eval_group :parent.text,
		        				eval_type :node.text
		        			},
		        			onLoadSuccess : function(row, param) {
		        			}
		        		});

		           }
			}
			
		});
		           
		setGrid();
		getGoodsList();
		getBizTypeGrp();
		
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
								setGrid();
								break;
							case 1:
								getGoodsList();								
								break;
							case 2:
								break;
							}
						},300);
					}
				});
			}
			//return false;
		});
	});
	
	function keydownEvent(){
		
		var t = $('#search_goods_txt2');
		t.textbox('textbox').bind('keydown', function(e){
		   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
			   getGoodsList();
		   }
		});	

		t = $('#search_goods_txt3');
		t.textbox('textbox').bind('keydown', function(e){
		   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
			   getGoodsList();
		   }
		});	

	}

	var jsonData = [{
		'id':1,
		'text':'평가항목',
		'children':[{
			'id':11,
			'text':'신용평가',
			'children':[{
				'id':111,
				'text':'신용평가'
			},{
				'id':112,
				'text':'기업규모'
			},{
				'id':113,
				'text':'창업기간'
			},{
				'id':114,
				'text':'실적'
			}]
		},{
			'id':12,
			'text':'신인도',
			'children':[{
				'id':121,
				'text':'기업규모'
			},{
				'id':122,
				'text':'창업초기기업'
			},{
				'id':123,
				'text':'특허'
			},{
				'id':124,
				'text':'net/nep'
			},{
				'id':125,
				'text':'GD/GS인증'
			},{
				'id':126,
				'text':'기간'
			},{
				'id':127,
				'text':'혁신형중소기업'
			}]
		},{
			'id':13,
			'text':'가격점수',
			'children':[{
				'id':131,
				'text':'가격점수'
			}]
		},{
			'id':14,
			'text':'적격통과점수',
			'children':[{
				'id':141,
				'text':'적격통과점수'
			}]
		}]
	}];

	function setGrid() {
		//tab1
		selectCodeList();
	}

	//tab1 조회
	function selectCodeList(){
		$("#dg").datagrid({
			method : "GET",
			url : "<c:url value='/code/selectCodeList.do'/>",
			queryParams : {
			},
			onLoadSuccess : function(row, param) {
				if(row.rows.length==0){
					selectCodeSubList(row);
				}else{
					$('#dg').datagrid('selectRow', 0);
					selectCodeSubList(row.rows[0]);
				}
			},
			onSelect : function(index, row){
				selectCodeSubList(row);
			},
			onDblClickRow : function(index, row){
				getData1(row);
			}
		});
	}
	
	function selectCodeSubList(row){
		
		$("#cd_group_id").textbox("setValue",row.cd_group_id);
		
		$("#dg2").datagrid({
			method : "GET",
			url : "<c:url value='/code/selectCodeSubList.do'/>",
			queryParams : {
				cd_group_id : row.cd_group_id
			},
			onLoadSuccess : function(row, param) {
				if(row.rows.length==0){
				}else{
					$("#cd_id").textbox("setValue",row.cd_id);
				}
			},
			onSelect : function(index, row){
				$("#cd_id").textbox("setValue",row.cd_id);
			},
			
			onDblClickRow : function(index, row){
				getData2(row);
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
				 	<div title="공통코드목록" style="padding:5px">
			            <div style="margin: 5px 0; vertical-align: top"></div>
							<div class="easyui-layout" style="width: 100%; height: 100%;">
								<div data-options="region:'west',collapsible:false"
									title="그룹코드정보" style="width: 40%;">
									<table style="width: 100%;">
										<tr>
											<td width="20%" align="right">
												<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a>
								            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append1()">추가</a>
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="save1('D')">삭제</a>
			<!-- 												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a> -->
								            </td>
										</tr>
									</table>
									<div style="display: none;">
										<table class="easyui-datagrid" style="width:0px;height:0px;border: 0" 
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
						                        <th data-options="field:'cd_group_id',align:'center',halign:'center'" width="50">ID</th>
						                        <th data-options="field:'cd_group_cd',halign:'center'" width="150">코드그룹 코드</th>
						                        <th data-options="field:'cd_group_nm',halign:'center'" width="150">코드그룹명</th>
						                        <th data-options="field:'del_yn',align:'center',halign:'center'" width="60">삭제여부</th>
						                        <th data-options="field:'f_create_dt',align:'center',halign:'center'" width="90">등록일</th>
						                        <th data-options="field:'create_nm',align:'center',halign:'center'" width="80">등록자</th>
						                        <th data-options="field:'f_modify_dt',align:'center',halign:'center'" width="90">수정일</th>
						                        <th data-options="field:'modify_nm',align:'center',halign:'center'" width="80">수정자</th>
						                    </tr>
						                </thead>
						            </table>
								
								</div>
								<div data-options="region:'east',collapsible:false"
									title="상세코드정보" style="width: 60%;">
									<table style="width: 100%;">
										<tr>
											<td width="20%" align="right">
								            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append2()">추가</a>
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="save2('D')">삭제</a>
<!-- 															<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a> -->
								            </td>
										</tr>
									</table>
									<table id="dg2" class="easyui-datagrid"
							           style="width:100%;height:90%;" 
					                   data-options=" method:'get',
					                   	  rownumbers:true,
					                   	  singleSelect:true,
										  method:'get',
										  striped:true,
										  nowrap:false">
					                <thead>
					                    <tr>
					                        <th data-options="field:'cd_id',align:'center',halign:'center'" width="50">ID</th>
					                        <th data-options="field:'cd',halign:'center'" width="80">코드</th>
					                        <th data-options="field:'cd_nm',halign:'center'" width="200">코드명</th>
					                        <th data-options="field:'parent_cd',halign:'center'" width="100">상위코드</th>
					                        <th data-options="field:'depth',halign:'center'" width="60">depth</th>
					                        <th data-options="field:'cd_seq',align:'right',halign:'center'" width="60">정렬순서</th>
					                        <th data-options="field:'del_yn',align:'center',halign:'center'" width="60">삭제여부</th>
<!-- 					                        <th data-options="field:'cd_group_id',halign:'center'" width="50">그룹ID</th> -->
					                        <th data-options="field:'bigo',halign:'center'" width="200">비고</th>
					                        <th data-options="field:'f_create_dt',align:'center',halign:'center'" width="90">등록일</th>
					                        <th data-options="field:'create_nm',align:'center',halign:'center'" width="80">등록자</th>
					                        <th data-options="field:'f_modify_dt',align:'center',halign:'center'" width="90">수정일</th>
					                        <th data-options="field:'modify_nm',align:'center',halign:'center'" width="80">수정자</th>
					                    </tr>
					                </thead>
					            	</table>
								</div>
							</div>
					</div>
					<!-- <div title="적격심사정보" style="padding:5px">
						<div class="easyui-layout" style="width:100%;height:750px;">
							<div data-options="region:'west'" title="평가항목" style="width:10%;">
						         <ul id="tt" class="easyui-tree" data-options="data:jsonData,method:'get',animate:true">
						         </ul>    
							</div>
							<div data-options="region:'center'" title="평가점수"  style="width:80%;">
								<table style="width: 100%;">
									<tr>
										<td width="20%" align="right">
							            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append()">추가</a>
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="save()">삭제</a>
															<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save3()">저장</a>
							            </td>
									</tr>
								</table>
								
								<table id="dg3" class="easyui-datagrid"
							           style="width:100%;height:95%;" 
					                   data-options=" method:'get',
					                   	  rownumbers:true,
					                   	  singleSelect:true,
										  method:'get',
										  striped:true,
										  onClickCell:onClickCell,
										  onEndEdit:onEndEdit,
										  nowrap:false">
					                <thead>
					                    <tr>
					                        <th data-options="field:'eval_group',halign:'center'" width="150">그룹명</th>
					                        <th data-options="field:'eval_gubun',halign:'center'" width="150">기관명</th>
					                        <th data-options="field:'eval_cd',halign:'center'" width="80">코드</th>
					                        <th data-options="field:'eval_nm',halign:'center'" width="100">평가명</th>
					                        <th data-options="field:'val',align:'right',halign:'center',editor:'textbox'" width="120">점수</th>
					                        <th data-options="field:'eval_start_dt',halign:'center'" width="120">시작일</th>
					                        <th data-options="field:'eval_end_dt',halign:'center'" width="120">종료일</th>
					                    </tr>
					                </thead>
					            </table>
					            <script>
					            
					            var editIndex = undefined;
								function endEditing() {
									if (editIndex == undefined) {
										return true
									}
									if ($('#dg3').datagrid('validateRow',editIndex)) {
										$('#dg3').datagrid('endEdit', editIndex);
										editIndex = undefined;
										return true;
									} else {
										return false;
									}
								}
								function onClickCell(index, field) {
									if (editIndex != index){
										if (endEditing()) {
											$('#dg3').datagrid('selectRow', index)
													.datagrid('beginEdit', index);
											var ed = $('#dg3').datagrid('getEditor',{index : index,field : field});
											if (ed) {
												($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
											}
											editIndex = index;
										} else {
											setTimeout(function() {
												$('#dg3').datagrid('selectRow',editIndex);
											}, 0);
										}
									}
								}
								function onEndEdit(index, row) {
								}


								function save3() {
									$.messager.confirm('알림','저장하시겠습니까?',
										function(r) {
											if (r) {
												if (endEditing()) {
													var $dg = $("#dg3");

													if ($dg.datagrid('getChanges').length) {
														var updated = $dg.datagrid('getChanges',"updated");

														var effectRow = new Object();
														if (updated.length) {
															effectRow["updated"] = JSON.stringify(updated);
														}
														$.post("<c:url value='/code/updateEvalList.do'/>",
																	effectRow,
																	function(rsp) {
																		if (rsp.status) {
																			$.messager.alert("알림","저장하였습니다.");
																		}
																	},"JSON")
															.error(
																	function() {
																		$.messager.alert("알림","저장에러！");
																	});
													}
												}
											}
										});
								}
					            </script>
							</div>
						</div>
					
					</div> -->
					<div title="물품분류정보" style="padding:5px">
						<div class="easyui-layout" style="width:100%;height:750px;">
								<table style="width: 100%;">
									<tr>
							        	<td class="bc">세부품명</td>
							            <td>
							            	<input type="text" class="easyui-textbox"  id="search_goods_txt2"  style="width:150px;" value=""  >
							            </td>
							        	<td class="bc">세부품명번호</td>
							            <td>
							            	<input type="text" class="easyui-textbox"  id="search_goods_txt3"  style="width:150px;" value=""  >
							            	<input type="hidden" id="business_no" name="business_no"   style="width:150px;" value=""  >
							            </td>
							            <td align="right">
							                <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="getGoodsList()" >조회</a>
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload'" onclick="getGoodsApi()">물품정보 갱신</a>
							            </td>
							        </tr>
								</table>
								<table id="dg4" class="easyui-datagrid"
							           style="width:100%;height:95%;" 
					                   data-options=" method:'get',
					                   	  rownumbers:true,
					                   	  singleSelect:true,
										  method:'get',
										  striped:true,
										  pagination:true,
										  pageSize:30,
										  nowrap:false">
					                <thead>
					                    <tr>
					                        <th data-options="field:'goods_no',halign:'center'" width="150">물품번호</th>
					                        <th data-options="field:'goods_nm',halign:'center'" width="300">물품명</th>
					                    </tr>
					                </thead>
					            </table>
						</div>
					
					</div>
					<div title="업종정보" style="padding:5px">
						<div style="margin: 5px 0; vertical-align: top"></div>
							<div class="easyui-layout" style="width: 100%; height: 100%;">
								<div data-options="region:'west',collapsible:false"
									title="업종정보" style="width: 50%;">
									<div style="display: none;">
										<table class="easyui-datagrid" style="width:0px;height:0px;border: 0" 
												>
										</table>
									</div>
						            <table id="dg5" class="easyui-datagrid"
							           style="width:100%;height:90%;" 
					                   data-options=" method:'get',
					                   	  rownumbers:true,
					                   	  singleSelect:true,
										  method:'get',
										  striped:true,
										  nowrap:false">
					                <thead>
					                    <tr>
<!-- 					                        <th data-options="field:'cd_id',align:'center',halign:'center'" width="50">ID</th> -->
					                        <th data-options="field:'cd',halign:'center'" width="80">코드</th>
					                        <th data-options="field:'cd_nm',halign:'center'" width="200">코드명</th>
<!-- 					                        <th data-options="field:'parent_cd',halign:'center'" width="100">상위코드</th> -->
<!-- 					                        <th data-options="field:'depth',halign:'center'" width="60">depth</th> -->
					                        <th data-options="field:'cd_seq',align:'right',halign:'center'" width="60">정렬순서</th>
<!-- 					                        <th data-options="field:'del_yn',align:'center',halign:'center'" width="60">삭제여부</th> -->
					                        <th data-options="field:'bigo',halign:'center'" width="200">비고</th>
					                        <th data-options="field:'f_create_dt',align:'center',halign:'center'" width="90">등록일</th>
<!-- 					                        <th data-options="field:'create_nm',align:'center',halign:'center'" width="80">등록자</th> -->
					                        <th data-options="field:'f_modify_dt',align:'center',halign:'center'" width="90">수정일</th>
<!-- 					                        <th data-options="field:'modify_nm',align:'center',halign:'center'" width="80">수정자</th> -->
					                    </tr>
					                </thead>
					            	</table>
								
								</div>
								<div data-options="region:'east',collapsible:false"
									title="상세업종정보" style="width: 50%;">
									<table id="dg6" class="easyui-datagrid"
							           style="width:100%;height:90%;" 
					                   data-options=" method:'get',
					                   	  rownumbers:true,
					                   	  singleSelect:true,
										  method:'get',
										  striped:true,
										  nowrap:false">
					                <thead>
					                    <tr>
<!-- 					                        <th data-options="field:'cd_id',align:'center',halign:'center'" width="50">ID</th> -->
					                        <th data-options="field:'cd',halign:'center'" width="80">코드</th>
					                        <th data-options="field:'cd_nm',halign:'center'" width="200">코드명</th>
<!-- 					                        <th data-options="field:'parent_cd',halign:'center'" width="100">상위코드</th> -->
<!-- 					                        <th data-options="field:'depth',halign:'center'" width="60">depth</th> -->
					                        <th data-options="field:'cd_seq',align:'right',halign:'center'" width="60">정렬순서</th>
<!-- 					                        <th data-options="field:'del_yn',align:'center',halign:'center'" width="60">삭제여부</th> -->
					                        <th data-options="field:'bigo',halign:'center'" width="200">비고</th>
					                        <th data-options="field:'f_create_dt',align:'center',halign:'center'" width="90">등록일</th>
<!-- 					                        <th data-options="field:'create_nm',align:'center',halign:'center'" width="80">등록자</th> -->
					                        <th data-options="field:'f_modify_dt',align:'center',halign:'center'" width="90">수정일</th>
<!-- 					                        <th data-options="field:'modify_nm',align:'center',halign:'center'" width="80">수정자</th> -->
					                    </tr>
					                </thead>
					            	</table>
								</div>
							</div>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script>
	
		function getGoodsList(){
			
			$("#dg4").datagrid({
				method : "GET",
				url : "<c:url value='/manufacture/goodsTypeTotalList.do'/>",
				queryParams : {
					searchTxt2 : $("#search_goods_txt2").textbox("getValue"),
					searchTxt3 : $("#search_goods_txt3").textbox("getValue")
				}
			});
			
		}
	
		function getGoodsApi(){
			$.messager.confirm('알림', "물품분류번호를 가져오시겠습니까?<br/>기존물품분류번호는 갱신됩니다.", function(r){
		        if (r){
	    			var effectRow = new Object();
	    			var win = $.messager.progress({
	    		            title:'물품분류정보 가져오기',
	    		            msg:'데이터 로딩중입니다.<br/>잠시만 기다려주세요...'
	    		        });
					
					$.post("<c:url value='/code/getBidGoodsInfoApi.do'/>", effectRow, function(rsp) {
						if(rsp.status){
							 $("#dg4").datagrid('reload');
							 $.messager.progress('close');
							 $.messager.alert("알림", "갱신되었습니다.");
						}
					}, "JSON").error(function() {
						$.messager.alert("알림", "API에러！");
					});
		        }
	    	});
		}
	
		function append1(){
			clearCodeGrp();
		}
		
		function chgCodeGrp( newValue,oldValue ){
			if(oldValue!=newValue){
				$("#chkCodeGrp").val("");
				$("#codeGrpBtn").linkbutton("enable");
			}
		}

		function clearCodeGrp(){
			$("#cd_group_id").textbox("setValue","");
			$("#cd_group_nm").textbox("setValue","");
			$("#cd_group_cd").textbox("setValue","");
			
			$('#cd_group_nm').textbox('textbox').attr('maxlength', '100');
			$('#cd_group_cd').textbox('textbox').attr('maxlength', '100');
			
			$("#type1").val("I");
			$("#cd_group_id").textbox({disabled:true});
			$("#codeGrpBtn").linkbutton("enable");
			
			$('#codeGrpDlg').dialog('open');
		}
	
		function getData1(row){
			clearCodeGrp();
			$("#cd_group_id").textbox("setValue",row.cd_group_id);
			$("#cd_group_nm").textbox("setValue",row.cd_group_nm);
			$("#cd_group_cd").textbox("setValue",row.cd_group_cd);
	
			$("#type1").val("U");
			$("#chkCodeGrp").val("Y");
			
			$("#codeGrpBtn").linkbutton("disable");
			
		}
		
		function save1(type){

			var text = '저장하시겠습니까?';
			
			if(type=="D"){
				text = '삭제하시겠습니까?';
			}else{
				if($("#cd_group_id").textbox("getValue").length==0){
					type='I';
				}
				if($("#cd_group_cd").textbox("getValue").length==0 || $("#cd_group_nm").textbox("getValue").length==0){
					$.messager.alert("알림", "코드 및 코드명을 입력해주세요.");
					return;
				}
				
				if($("#chkCodeGrp").val()!="Y"){
					$.messager.alert("알림", "코드를 확인해주세요.");
					return;
				}
			}
			
			
	    	$.messager.confirm('알림', text, function(r){
		        if (r){
	    			var effectRow = new Object();
	    			effectRow["type"] = type;
	    			effectRow["cd_group_id"] = $("#cd_group_id").textbox("getValue");
	    			effectRow["cd_group_cd"] = $("#cd_group_cd").textbox("getValue");
					effectRow["cd_group_nm"] = $("#cd_group_nm").textbox("getValue");
					
					$.post("<c:url value='/code/updateCodeGrp.do'/>", effectRow, function(rsp) {
						if(rsp.status){
							$.messager.alert("알림", "저장하였습니다.");
							 $("#dg").datagrid('reload');
							$('#codeGrpDlg').dialog('close');
						}
					}, "JSON").error(function() {
						$.messager.alert("알림", "저장에러！");
					});
		        }
	    	});
		}
		
		function append2(){
			clearCodeSub();
		}
		
		function chgCodeSub( newValue,oldValue ){
			if(oldValue!=newValue){
				$("#chkCodeGrp").val("");
				$("#codeSubBtn").linkbutton("enable");
			}
		}

		function clearCodeSub(){
			$("#cd_id").textbox("setValue","");
			$("#cd").textbox("setValue","");
			$("#cd_nm").textbox("setValue","");
			$("#parent_cd").textbox("setValue","");
			$("#depth").numberbox("setValue","");
			$("#cd_seq").numberbox("setValue","");
			$("#bigo").textbox("setValue","");
			
			$("#type2").val("I");
			$("#cd_id").textbox({disabled:true});
			$("#codeSubBtn").linkbutton("enable");
			
			$('#codeSubDlg').dialog('open');
		}
	
		function getData2(row){
			clearCodeSub();
			$("#cd_id").textbox("setValue",row.cd_id);
			$("#cd").textbox("setValue",row.cd);
			$("#cd_nm").textbox("setValue",row.cd_nm);
			$("#parent_cd").textbox("setValue",row.parent_cd);
			$("#depth").numberbox("setValue",row.depth);
			$("#cd_seq").numberbox("setValue",row.cd_seq);
			$("#bigo").textbox("setValue",row.bigo);
			
			$("#type2").val("U");
			$("#chkCodeSub").val("Y");
			
			$("#codeSubBtn").linkbutton("disable");
			
		}
		
		
		function save2(type){
			

			var text = '저장하시겠습니까?';
			
			if(type=="D"){
				text = '삭제하시겠습니까?';
			}else{
				
				if($("#cd_id").textbox("getValue").length==0){
					type='I';
				}
				
				if($("#cd").textbox("getValue").length==0 || $("#cd_nm").textbox("getValue").length==0){
					$.messager.alert("알림", "코드 및 코드명을 입력해주세요.");
					return;
				}
				
				if($("#chkCodeSub").val()!="Y"){
					$.messager.alert("알림", "코드를 확인해주세요.");
					return;
				}
			}
			
	    	$.messager.confirm('알림', text, function(r){
		        if (r){
	    			var effectRow = new Object();
	    			effectRow["type"] = type;
					effectRow["cd_group_id"] = $("#cd_group_id").textbox("getValue");
	    			effectRow["cd_id"] = $("#cd_id").textbox("getValue");
	    			effectRow["cd"] = $("#cd").textbox("getValue");
					effectRow["cd_nm"] = $("#cd_nm").textbox("getValue");
	    			effectRow["parent_cd"] = $("#parent_cd").textbox("getValue");
	    			effectRow["depth"] = $("#depth").numberbox("getValue");
					effectRow["cd_seq"] = $("#cd_seq").numberbox("getValue");
	    			effectRow["bigo"] = $("#bigo").textbox("getValue");
					
					$.post("<c:url value='/code/updateCodeSub.do'/>", effectRow, function(rsp) {
						if(rsp.status){
							$.messager.alert("알림", "저장하였습니다.");
							 $("#dg2").datagrid('reload');
							$('#codeSubDlg').dialog('close');
						}
					}, "JSON").error(function() {
						$.messager.alert("알림", "저장에러！");
					});
		        }
	    	});
		}
	
		
		function chkCodeGrp(){
			if($("#cd_group_cd").textbox("getValue").length==0){
				$.messager.alert("알림", "코드를 입력해주세요.");
				return;
			}
			
			var effectRow = new Object();
			effectRow["cd_group_cd"] = $("#cd_group_cd").textbox("getValue");
			
			$.post("<c:url value='/code/chkCodeGrp.do'/>", effectRow, function(rsp) {
				if(rsp.status=="100"){
					$.messager.alert("알림", "사용하는 코드입니다.");
				}else if(rsp.status=="200"){
					$.messager.alert("알림", "사용가능합니다.");
					$("#chkCodeGrp").val("Y");
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "에러！");
			});
		}
		
		function chkCodeSub(){
			
			var effectRow = new Object();
			effectRow["cd_group_id"] = $("#cd_group_id").textbox("getValue");
			
			if($("#cd").textbox("getValue").length==0){
				$.messager.alert("알림", "코드를 입력해주세요.");
				return;
			}
			effectRow["cd"] = $("#cd").textbox("getValue");
			
			$.post("<c:url value='/code/chkCodeSub.do'/>", effectRow, function(rsp) {
				if(rsp.status=="100"){
					$.messager.alert("알림", "사용하는 코드입니다.");
				}else if(rsp.status=="200"){
					$.messager.alert("알림", "사용가능합니다.");
					$("#chkCodeSub").val("Y");
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "에러！");
			});
		}
		
		function getBizTypeGrp(){
			$("#dg5").datagrid({
				method : "GET",
				url : "<c:url value='/code/selectBizTypeList.do'/>",
				queryParams : {
				}
				,
				onLoadSuccess : function(row, param) {
					if(row.rows.length==0){
						getBizTypeSub(row);
					}else{
						$('#dg5').datagrid('selectRow', 0);
						getBizTypeSub(row.rows[0].cd);
					}
				},
				onSelect : function(index, row){
					getBizTypeSub(row.cd);
				}
			});
		}
		
		function getBizTypeSub(parent_cd){

			$("#dg6").datagrid({
				method : "GET",
				url : "<c:url value='/code/selectBizTypeList.do'/>",
				queryParams : {
					parent_cd : parent_cd
				}
			});
		}
	
	</script>
	
	<div id="codeGrpDlg" class="easyui-dialog" title="그룹 코드"
			data-options="iconCls:'icon-save',modal:true,closed:true"
			style="width: 35%; height: 150px;">
			<div class="easyui-layout" style="width:100%;height:100%; border:0">
				<div data-options="region:'center'">
					<table style="width:100%;">
				        <tr>
				            <td width="60%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save1('U')">저장</a>
				            </td>
				        </tr>
				    </table>
				    <input type="hidden" id="type1" style="width:100px"> 
				    <input type="hidden" id="chkCodeGrp" style="width:100px" >
				 	<table style="width: 100%">
						<tr>
							<td class="bc" width="100px">코드 ID</td>
							<td colspan="3"><input type="text" class="easyui-textbox" id="cd_group_id" style="width:150px"/></td>
						</tr>
						<tr>
							<td class="bc" width="100px">코드</td>
							<td><input type="text" class="easyui-textbox" id="cd_group_cd" style="width:150px" data-options="onChange:chgCodeGrp"/> <a id="codeGrpBtn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onClick="chkCodeGrp()">확인</a></td>
							<td class="bc" width="100px">코드명</td>
							<td><input type="text" class="easyui-textbox" id="cd_group_nm" style="width:150px"/></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div id="codeSubDlg" class="easyui-dialog" title="상세 코드"
			data-options="iconCls:'icon-save',modal:true,closed:true"
			style="width: 35%; height: 230px;">
			<div class="easyui-layout" style="width:100%;height:100%; border:0">
				<div data-options="region:'center'">
					<table style="width:100%;">
				        <tr>
				            <td width="60%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save2('U')">저장</a>
				            </td>
				        </tr>
				    </table>
				    <input type="hidden" id="type2" style="width:100px"> 
				    <input type="hidden" id="chkCodeSub" style="width:100px" >
				 	<table style="width: 100%">
						<tr>
							<td class="bc" width="100px">코드 ID</td>
							<td colspan="3"><input type="text" class="easyui-textbox" id="cd_id" style="width:150px"/></td>
						</tr>
						<tr>
							<td class="bc" width="100px">코드</td>
							<td><input type="text" class="easyui-textbox" id="cd" style="width:150px" data-options="onChange:chgCodeSub"/> <a id="codeSubBtn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onClick="chkCodeSub()">확인</a></td>
							<td class="bc" width="100px">코드명</td>
							<td><input type="text" class="easyui-textbox" id="cd_nm" style="width:150px"/></td>
						</tr>
						<tr>
							<td class="bc" width="100px">상위코드</td>
							<td><input type="text" class="easyui-textbox" id="parent_cd" style="width:150px" /> </td>
							<td class="bc" width="100px">depth</td>
							<td><input type="text" class="easyui-numberbox" id="depth" style="width:150px"/></td>
						</tr>
						<tr>
							<td class="bc" width="100px">순서</td>
							<td colspan="3"><input type="text" class="easyui-numberbox" id="cd_seq" style="width:150px" /> </td>
						</tr>
						<tr>
							<td class="bc" width="100px">비고</td>
							<td colspan="3"><input type="text" class="easyui-numberbox" id="bigo" style="width:150px" /> </td>
						</tr>
					</table>
				</div>
			</div>
		</div>

</body>
</html>