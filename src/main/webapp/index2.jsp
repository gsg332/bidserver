<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>


<meta charset="UTF-8"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/images/demo.css'/>">
	<link rel="stylesheet" type="text/css" href="<c:url value='/jquery/themes/default/easyui.css'/>">
	<link rel="stylesheet" type="text/css" href="<c:url value='/jquery/themes/icon.css'/>">
   <script type="text/javascript" src="<c:url value='/jquery/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/jquery/jquery.easyui.min.js'/>"></script>
		<script src='<c:url value='/jquery/jquery.form.js'/>' type="text/javascript"></script>
<script src='<c:url value='/jquery/./jquery.json-2.3.min.js'/>' type="text/javascript"></script>

<script>
	$(document).ready(function() {
		var dts = new Date();
		var dte = new Date();
	    var dayOfMonth = dts.getDate();
	    dts.setDate(dayOfMonth-30);
	    dte.setDate(dayOfMonth+30);
	    dts = dts.getFullYear()+"-"+((dts.getMonth() + 1)<9?"0"+(dts.getMonth() + 1):(dts.getMonth() + 1))+"-"+dts.getDate();
	    dte = dte.getFullYear()+"-"+((dte.getMonth() + 1)<9?"0"+(dte.getMonth() + 1):(dte.getMonth() + 1))+"-"+dte.getDate();
	    
	    
	    $('#bidStdDt').datebox('setValue',dts);
	    $('#bidEndDt').datebox('setValue',dte);
	    
	    setGrid();

	});
	

	
	var jsonData=null;
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/userList.do'/>"
		       ,async: false 
	   ,dataType: "json"
	   ,success:function(json){
	  	 
	  	 jsonData=json;
	  	 
	   }
	});

	
	function selectBidList(){
		
		$("#dg").datagrid({
			method : "GET",
			url : "<c:url value='/bid/bidList.do'/>",
			queryParams : {
				bidStdDt :$('#bidStdDt').datebox('getValue'),
				bidEndDt : $('#bidEndDt').datebox('getValue'),
				bidTitleNm : $('#bidTitleNm').val(),
				userId : $('#userId').combogrid('getValue')
			},
			onDblClickRow : function(rowIndex, rowData) {
				//   alert(rowData.notice_detail_link);
				$("#ifdeatailview").attr('src', rowData.notice_detail_link);

				$('#maintab').tabs('select', '입찰상세');

			},
			onLoadSuccess : function(row, param) {

			}
		});
	}
	
	function setGrid() {

		selectBidList();
		
		$("#bc").datagrid({
			method : "GET",
			url : "<c:url value='/admin/bidcompany/bidCompanyList.do'/>",
			queryParams : {
				idnum : "3",
				pagenum : "2"
			},
			onDblClickRow : function(rowIndex, rowData) {
				writeDetail(rowData.PUBLICID);
			},
			onLoadSuccess : function(row, param) {

			}
		});

		$("#bc2").datagrid({
			method : "GET",
			url : "<c:url value='/admin/bidcompany/bidCompanyList.do'/>",
			queryParams : {
				idnum : "3",
				pagenum : "2"
			},
			onDblClickRow : function(rowIndex, rowData) {
				writeDetail(rowData.PUBLICID);
			},
			onLoadSuccess : function(row, param) {

			}
		});

	}

	function excelUpdate(gbn, str) {

		$("#modify").val(gbn);
		if (!confirm("[" + str + "] 저장 하시겠습니까 저장하시는동안 잠시만 기다리세요"))
			return;

		$('#dlg').dialog('open');
		var options = {
			dataType : "json"

			,
			beforeSubmit : function(data) {
				for (var i = 0; i < data.length; i++) {
					data[i].value = encodeURI(data[i].value);
				}
			},
			success : function(data, status) {
				$('#dlg').dialog('close');

				alert('저장되었습니다.');
				
				selectBidList();

			},
			error : function(request, status, error) {
				$('#dlg').dialog('close');
				alert("error:" + request.responseText);
			}
		};

		//전송
		$("#excelForm").ajaxSubmit(options);
		return false;
	}
	
	
</script>
<script type="text/javascript">
        function myformatter(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
        }
        function myparser(s){
            if (!s) return new Date();
            var ss = (s.split('-'));
            var y = parseInt(ss[0],10);
            var m = parseInt(ss[1],10);
            var d = parseInt(ss[2],10);
            if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
                return new Date(y,m-1,d);
            } else {
                return new Date();
            }
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
			<script>
				function formatPrice(val, row) {
					if (val == 1) {
						return '<input type="checkbox" name="" checked>';
					} else {
						return '<checkbox name="" value=""     >';
					}
				}
			</script>
			<div style="margin: 1px 0; vertical-align: top"></div>
			<div class="easyui-layout"
				style="width: 100%; height: 850px; vertical-align: top;">
				<!-- 	<div data-options="region:'north'" style="height:0px;vertical-align:top;"></div> -->
				<div data-options="region:'south',split:true" style="height: 50px;"></div>
				<div data-options="region:'east',split:true" title="업체관리"
					style="width: 600px;">

					<div class="easyui-tabs"
						data-options="fit:true,border:false,plain:true">
						<div title="적용제조사" style="padding:0 10px 10px 10px">
							<table style="width:100%">
						        <tr>
						            <td align="right">
						                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" >견적요청 보내기</a>
						            </td>
						        </tr>
						    </table>


							<table id="bc2" class="easyui-datagrid"
								data-options="singleSelect:false,pagination:true">
								<thead>
									<tr>

										<th data-options="field:'ck',checkbox:true"></th>
										<th data-options="field:'COMPANY_NM',editor:'textbox'"
											width="80" id="COMPANY_NM">업체명</th>
										<th data-options="field:'DELEGATE',editor:'textbox'"
											width="60">대표자명</th>
										<th
											data-options="field:'DELEGATE_EXPLAIN',align:'right',editor:'textbox'"
											width="80">대표자설명</th>
										<th
											data-options="field:'COMPANY_TYPE',align:'right',editor:'textbox'"
											width="70">기업구분</th>
										<th
											data-options="field:'COMPANY_REGISTRATION_DAY',editor:'textbox'"
											width="40">사업자 등록일</th>
										<th
											data-options="field:'ZIP_NO',align:'center',editor:'textbox'"
											width="30">우편번호</th>
										<th
											data-options="field:'ADDRESS',align:'center',editor:'textbox'"
											width="50">기본주소</th>
										<th
											data-options="field:'ADDRESS_DETAIL',align:'center',editor:'textbox'"
											width="90">상세주소</th>
										<th
											data-options="field:'PHONE_NO',align:'center',editor:'textbox'"
											width="90">전화</th>
										<th
											data-options="field:'MOBILE_NO',align:'center',editor:'textbox'"
											width="90">휴대폰</th>
										<th
											data-options="field:'FAX_NO',align:'center',editor:'textbox'"
											width="90">fax</th>
										<th
											data-options="field:'DEPARTMENT',align:'center',editor:'textbox'"
											width="90">담당부서</th>
										<th
											data-options="field:'POSITION',align:'center',editor:'textbox'"
											width="90">직위</th>
										<th
											data-options="field:'BIDMANAGER',align:'center',editor:'textbox'"
											width="90">입찰담당자</th>
										<th
											data-options="field:'EMAIL',align:'center',editor:'textbox'"
											width="90">이메일</th>
										<th
											data-options="field:'BUSINESS_CONDITION',align:'center',editor:'textbox'"
											width="90">업태</th>
										<th
											data-options="field:'BUSINESS_CONDITION_DETAIL',align:'center',editor:'textbox'"
											width="90">종명</th>
									</tr>
								</thead>
							</table>
						</div>
						
						
						<div title="적용 투찰사" style="padding:0 10px 10px 10px">
							<table style="width:100%">
						        <tr>
						            <td align="right">
						                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'"  >투찰정보 보내기</a>
						            </td>
						        </tr>
						    </table>

							<table id="bc" class="easyui-datagrid"
								data-options="singleSelect:false,pagination:true">
								<thead>
									<tr>

										<th data-options="field:'ck',checkbox:true"></th>
										<th data-options="field:'COMPANY_NM',editor:'textbox'"
											width="80" id="COMPANY_NM">업체명</th>
										<th data-options="field:'DELEGATE',editor:'textbox'"
											width="60">대표자명</th>
										<th
											data-options="field:'DELEGATE_EXPLAIN',align:'right',editor:'textbox'"
											width="80">대표자설명</th>
										<th
											data-options="field:'COMPANY_TYPE',align:'right',editor:'textbox'"
											width="70">기업구분</th>
										<th
											data-options="field:'COMPANY_REGISTRATION_DAY',editor:'textbox'"
											width="40">사업자 등록일</th>
										<th
											data-options="field:'ZIP_NO',align:'center',editor:'textbox'"
											width="30">우편번호</th>
										<th
											data-options="field:'ADDRESS',align:'center',editor:'textbox'"
											width="50">기본주소</th>
										<th
											data-options="field:'ADDRESS_DETAIL',align:'center',editor:'textbox'"
											width="90">상세주소</th>
										<th
											data-options="field:'PHONE_NO',align:'center',editor:'textbox'"
											width="90">전화</th>
										<th
											data-options="field:'MOBILE_NO',align:'center',editor:'textbox'"
											width="90">휴대폰</th>
										<th
											data-options="field:'FAX_NO',align:'center',editor:'textbox'"
											width="90">fax</th>
										<th
											data-options="field:'DEPARTMENT',align:'center',editor:'textbox'"
											width="90">담당부서</th>
										<th
											data-options="field:'POSITION',align:'center',editor:'textbox'"
											width="90">직위</th>
										<th
											data-options="field:'BIDMANAGER',align:'center',editor:'textbox'"
											width="90">입찰담당자</th>
										<th
											data-options="field:'EMAIL',align:'center',editor:'textbox'"
											width="90">이메일</th>
										<th
											data-options="field:'BUSINESS_CONDITION',align:'center',editor:'textbox'"
											width="90">업태</th>
										<th
											data-options="field:'BUSINESS_CONDITION_DETAIL',align:'center',editor:'textbox'"
											width="90">종명</th>
									</tr>
								</thead>
							</table>



						</div>

						



					</div>

				</div>
				<div data-options="region:'center',title:' 입찰정보 ',iconCls:'icon-ok'">
					<div id="maintab" class="easyui-tabs"
						data-options="fit:true,border:false,plain:true">
						<div title="입찰리스트" style="padding: 5px">

							<form id="excelForm" name="excelForm" method="post"
								enctype="multipart/form-data"
								action="<c:url value='/excelUploadController.do'/>">
								<input
									type="hidden" name="method" value="upload_notice_info" /> <input
									type="hidden" id="p_columList" name="p_columList" value="" />
								<input type="hidden" id="p_ruleList" name="p_ruleList" value="" />
								<input type="hidden" id="modify" name="modify" value="N" /> 
							
							
							<table style="width:90%">
						        <tr>
						            <td>공고일 :</td>
						            <td>
						                <input class="easyui-datebox" id="bidStdDt" name="bidStdDt" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
						                ~
						                <input class="easyui-datebox" id="bidEndDt" name="bidEndDt"  data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
						            </td>
						            <td>공고명:</td>
						            <td>
						                <input type="text" class="easyui-validatebox"  id="bidTitleNm" name="bidTitleNm"   style="width:200px;height:20px;" value=""  >
						            </td>
						            <td>
						                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList()" >조회</a>
						            </td>
						            <td align="right">
						            <input id="file" class="easyui-filebox"  name="excelfile" style="width:300px" data-options="prompt:'업로드할 엑셀파일을 첨부해주세요.'">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'"  onclick="excelUpdate('N',this.value)" >엑셀업로드</a>
						            </td>
						        </tr>
						        <tr>
						            <td>담당자 :</td>
						            <td>
						            	<input id="userId" class="easyui-combobox" data-options="
										method:'get',
								        valueField: 'user_id',
								        textField: 'user_nm',
								        url: '<c:url value='/bid/userList.do'/>'">
						            </td>
						        </tr>
						    </table>
						    <div id="cc" class="easyui-calendar"></div>
									
							</form>
							

							<table id="dg" class="easyui-datagrid" style="width:90%;height:80%;"
								data-options="loadMsg:'조회중입니다',rownumbers:true,singleSelect:false,pagination:true,method:'get',toolbar:'#tb',striped:true,sortOrder:'desc',sortName:'bid_notice_dt',nowrap:false,onClickCell:onClickCell,onEndEdit:onEndEdit,onBeforeEdit:onBeforeEdit"
								sortName="itemid" sortOrder="asc" rownumbers="true" pagination="true">




								<thead data-options="frozen:true">
						            <tr>
										<th data-options="field:'ck',checkbox:true"></th>
											
											<th data-options="field:'user_id',width:70,halign:'center',
									                        formatter:function(value,row){
									                            return row.user_nm;
									                        },
									                        editor:{
									                            type:'combobox',
									                            options:{
									                                valueField:'user_id',
									                                textField:'user_nm',
									                                method:'get',
									                                data:jsonData,
									                                required:true
									                            }
									                        }">담당</th>
											
											
										<th
											data-options="field:'bid_no',halign:'center',width:130,resizable:true,sortable:true" formatter="formatNoticeNo">공고번호</th>
										<th
											data-options="field:'bid_title_nm',align:'left',width:250,halign:'center',sortable:true" >공고명</th>
						            </tr>
						        </thead>

								<thead>
									<tr>
										<th data-options="field:'demand_nm',align:'left',width:150 ,halign:'center'">수요기관</th>
										<th data-options="field:'cont_method',align:'left',width:80 ,halign:'center'" formatter="formatMethod">계약방법<br/>예가방법</th>
										<th data-options="field:'goods_type_nm',align:'left',width:100 ,halign:'center'">물품명</th>
										<th data-options="field:'area_nm',align:'left',width:50 ,halign:'center'" formatter="formatCommaEnter">지역</th>
										<th
											data-options="field:'base_price_val',align:'right',width:100 ,halign:'center'" formatter="formatBidPrice">추정가격<br/>기초금액</th>
										<th
											data-options="field:'bid_std_dt',align:'center',width:100 ,halign:'center'" formatter="formatBidDate">입찰개시<br/>입찰마감</th>
									</tr>
								</thead>
							</table>
							<script type="text/javascript">
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
						       function onClickCell(index, field){
						           if (editIndex != index){
						               if (endEditing()){
						                   $('#dg').datagrid('selectRow', index)
						                           .datagrid('beginEdit', index);
						                   var ed = $('#dg').datagrid('getEditor', {index:index,field:field});
						                   if (ed){
						                       ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
						                   }
						                   editIndex = index;
						               } else {
						                   setTimeout(function(){
						                       $('#dg').datagrid('selectRow', editIndex);
						                   },0);
						               }
						           }
						       }
						       function onEndEdit(index, row){
						           var ed = $(this).datagrid('getEditor', {
						               index: index,
						               field: 'user_id'
						           });
						           row.user_nm = $(ed.target).combobox('getText');
						       }
						       function onBeforeEdit(index,row){
						    	   row.editing=true;
						    	   $(this).datagrid('refreshRow', index);
						       }
						       function onAfterEdit(index,row){
						    	   row.editing=false;
						    	   $(this).datagrid('refreshRow', index);
						       }
						       function onCancelEdit(index,row){
						    	   row.editing=false;
						    	   $(this).datagrid('refreshRow', index);
						       }
						    </script>

											
							 <script>
							 	function numberComma(_number, type) {
								  if (isNaN(_number))
									  if(_number=="공개 이전"){
										  return '<span style="color:red;">'+_number+'</span>';
									  }else{
										  if(type=="1"){
											  return '<span style="color:blue;">'+_number+'</span>';
										  }else{
										   	return _number;
										  }
									  }

								 

								  var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
								  while (_regExp.test(_number)) {
								   _number = _number.replace(_regExp, "$1,$2");
								  }
								  if(type=="1"){
									  return '<span style="color:blue;">'+_number+'</span>';
								  }else{
									  return _number;
								  }
								 }

						        function formatNoticeNo(val,row){
						        	
						             return row.bid_no+"-"+row.bid_cha_no;
						        }
						        function formatMethod(val,row){
						        	
						        	
									var stdStr ="";
						        	
						        	if(row.cont_method.search("규격가격")>=0)	stdStr ="규격가격";
						        	if(row.cont_method.search("조합추천")>=0)	stdStr ="조합추전";
						        	if(row.cont_method.search("제한")>=0)	 stdStr ="제한";
						        	if(row.cont_method.search("총액")>=0)		stdStr ="총액";
						        	if(row.cont_method.search("협상")>=0) 	stdStr ="협상";
						        	
						        	var endStr ="";
						        	
						        	if(row.bid_price_type.search("복수")>=0){
						        		endStr ="복수";
						        	}else if(row.bid_price_type.search("단일")>=0){
						        		endStr ="단일";
						        	}else if(row.bid_price_type.search("비예")>=0){
						        		endStr ="비예";
						        	}
						        	
						             return stdStr+"<br/>"+endStr;
						        }
						        
						        function formatCommaEnter(val,row){
						        	
						        	var str = val.split(",");
						        	var returnStr="";
						        	for(var i=0;i<str.length;i++){
						        		if(i>0){
						        			returnStr +="<br/>"
						        		}
						        		returnStr +=str[i];
						        	}
						        	
						            return returnStr;
						        }
						        function formatBidDate(val, row){
						        	var stdStr = formatDate(row.bid_std_dt, row);
						        	var endStr = formatDate(row.bid_end_dt, row);
						        	return stdStr+"<br/>"+endStr;
						        }
						        function formatBidPrice(val, row){
						        	var stdStr = numberComma(row.pre_price_val, 0);
						        	var endStr = numberComma(row.base_price_val, 1);
						        	return stdStr+"<br/>"+endStr;
						        }
						        function formatDate(val,row){
						        	
						        	var dt;
		 			        	    dt = new Date();
					        	    dt = dt.getFullYear()+""+((dt.getMonth() + 1)<9?"0"+(dt.getMonth() + 1):(dt.getMonth() + 1))+""+dt.getDate();
						        	var valdt = val.substring(0,11).replace(/-/gi, "");
						        	
						        	val = val.substring(5,val.length);
						            if (eval(dt)-eval(valdt) < 0){
						                return '<span style="color:red;">'+val+'</span>';
						            } else {
						                return val;
						            }
						        }
						    </script>
							
							
						</div>
						<div title="입찰상세" style="padding: 10px">

							<iframe id="ifdeatailview" width="90%" height="100%"
								name="ifdeatailview"
								src="http://www.g2b.go.kr:8067/contract/contDetail.jsp?Union_number=2014110074446">
							</iframe>

						</div>




					</div>

				</div>
			</div>
		</div>
	</div>
</body>
</html>