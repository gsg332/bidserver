<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>현황분석</title>
<%@ include file="/include/session.jsp" %>
<script>
var jsonData=null;

//담당자 콤보 전체
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/distribution/userList.do'/>"
   ,async: false 
   ,data : {
		searchType :'A'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData=json;
   }
});

$(document).ready(function() {
	<%
		String userid = (String)session.getAttribute("loginid");
		if(userid != null){
			if(Integer.parseInt((String)session.getAttribute("auth"))==1){ 
	%>
				$("#userId").combobox('setValue', '<%=userid%>');
	<%
			}
		} 
	%>
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
							setGrid();
							break;
						case 1:
							selectList();
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

function setGrid(){
	$("#bc6").datagrid({
		method : "GET",
		   url: "<c:url value='/analysis/businessBidInfoList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no6').val(),
			s_company_nm : $('#s_company_nm6').val(),
			bidStartDt :$('#bidStartDt').datebox('getValue'),
			bidEndDt : $('#bidEndDt').datebox('getValue')
		},
		onLoadSuccess:function(){
			eventBtn();
			$('#bc6').datagrid('selectRow', 0);
			//$('#bc6').datagrid('reloadFooter',row.footer);
		}

	});
}

function selectList(){
	var userId = "";
	<%
		if(userid != null){
			if(Integer.parseInt((String)session.getAttribute("auth"))==1){ %>
				<%-- userId = "<%=(String)session.getAttribute("loginid")%>"; --%>
				userId = $('#userId').combogrid('getValue');
	<%		}else{ %>
				userId = $('#userId').combogrid('getValue');
	<%
			} 
		}
	%>
	$("#dg").datagrid({
		method : "GET",
		url : "<c:url value='/analysis/selectKpiList.do'/>",
		queryParams : {
			disSDt : $('#disSDt').datebox('getValue'),
			disEDt : $('#disEDt').datebox('getValue'),
			bidNoticeNo : $('#searchBidType').combobox('getValue')=="1"?$('#bidNoticeNo').val().replace( /(\s*)/g, ""):"",
			bidNoticeNm : $('#searchBidType').combobox('getValue')=="2"?$('#bidNoticeNo').val().replace( /(\s*)/g, ""):"",
			userId : userId
		}
	});
}
function eventBtn(){
	$('#bc6').datagrid('getPanel').find("[type='bid_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				$("#bizBidInfoDlg").dialog('open');
				getBidInfoList();
			}
		})
	});
}
function getBidInfoList(){
	$("#bizBidInfoTb").datagrid({
		method : "GET",
		   url: "<c:url value='/analysis/businessBidInfoDtlList.do'/>",
		queryParams : {
			business_no : $('#business_no').val(),
			bidStartDt :$('#bidStartDt').datebox('getValue'),
			bidEndDt : $('#bidEndDt').datebox('getValue')
		},
		onLoadSuccess:function(json){
			$('#eventBidCnt').text(json.eventBidCnt);
			$('#eventStartDate').text(json.lastEventInfo.start_date);
			$('#eventEndDate').text(json.lastEventInfo.end_date);
		}
	});
}
function init(){
	var dts = new Date();
	var bidStartDt = new Date();
	var bidEndDt = new Date();
    var dayOfMonth = dts.getDate();
    dts.setDate(dayOfMonth);
    bidStartDt.setDate(dayOfMonth-7);
    bidEndDt.setDate(dayOfMonth+30);
    bidStartDt = bidStartDt.getFullYear()+"-"+((bidStartDt.getMonth() + 1)<9?"0"+(bidStartDt.getMonth() + 1):(bidStartDt.getMonth() + 1))+"-"+bidStartDt.getDate();
    bidEndDt = bidEndDt.getFullYear()+"-"+((bidEndDt.getMonth() + 1)<9?"0"+(bidEndDt.getMonth() + 1):(bidEndDt.getMonth() + 1))+"-"+bidEndDt.getDate();
    dts = dts.getFullYear()+"-"+((dts.getMonth() + 1)<9?"0"+(dts.getMonth() + 1):(dts.getMonth() + 1))+"-"+dts.getDate();
    
    $('#bidStartDt').datebox('setValue',bidStartDt);
    $('#bidEndDt').datebox('setValue',bidEndDt);
    $('#disSDt').datebox('setValue',dts);
    $('#disEDt').datebox('setValue',dts);
       
}
function eventInit(){
	var t = $('#s_company_no6');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid();
	   }
	});	
	
	t = $('#s_company_nm6');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid();
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
				 	<div title="투찰률현황분석" style="padding:5px">
				 	<input type="hidden" id="business_no">
					<div id="cc" class="easyui-calendar"></div>
						<table style="width:100%;">
					        <tr>
					        	<td width="80%"  align="left">
					        		<table style="width:100%;">
								        <tr>
								            <td class="bc">사업자번호</td>
								            <td>
								                <input type="text" class="easyui-textbox"  id="s_company_no6" name="s_company_no6" style="width:100px;"   >
								            </td>
								            <td class="bc">업체명</td>
								            <td>
								                <input type="text" class="easyui-textbox"  id="s_company_nm6" name="s_company_nm6" style="width:150px;"   >
								            </td>
								            <td class="bc">공고마감일</td>
								            <td><input class="easyui-datebox" id="bidStartDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
												~ <input class="easyui-datebox" id="bidEndDt"  style="width:100px;"	data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											</td>
								        </tr>
								    </table>
					        	</td>
					            
					            <td width="12%" align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a>
					            </td>
					        </tr>
					    </table>
					    <div style="display: none;">
							<table class="easyui-datagrid"
									style="width:0px;height:0px;border: 0" 
									>
							</table>
						</div>
						<table id="bc6" class="easyui-datagrid"
								style="width:100%;height:90%;" 
								
								data-options="iconCls: 'icon-edit',
											rownumbers:false,
											singleSelect:true,
											striped:true,
											pagination:true,
											pageSize:20,
										  	pageList:[20,50,70,100],
										  	showFooter:true"						
								>
								<thead>
								<tr>
									<th data-options="field:'business_no',align:'center',halign:'center'" width="80">No.</th>
							 		<th data-options="field:'company_no',halign:'center',editor:'textbox'" width="150">사업자번호</th>
							 		<th data-options="field:'company_nm',halign:'center',editor:'textbox'" width="150">업체명</th>
							 		<th data-options="field:'cnt',align:'right',halign:'center'" width="70">정보제공</th>
							 		<th data-options="field:'cnt1',align:'right',halign:'center'" width="70">투찰수</th>
							 		<th data-options="field:'test',align:'right',halign:'center'" width="70" formatter="formatPercent">투찰율</th>
									<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" style="width:100px;" formatter="formatRowButton6">상세보기</th>
								</tr>
							</thead>
						</table>
						<script>
								function formatPercent(val, row){
									if(row.cnt==0){
										return 0;										
									}else{
										return Math.ceil((parseInt(row.cnt1)/parseInt(row.cnt))*1000)/10;
									}
								}
								function formatRowButton6(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"bid_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
								}
						</script>
					</div>	
					<div title="KPI" style="padding:5px">
				        <table style="width: 100%;">
							<tr>
								<td class="bc">공고분배일자</td>
								<td>
									  <input class="easyui-datebox" id="disSDt"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">
									- <input class="easyui-datebox" id="disEDt"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">																										
								</td>
								<td class="bc">공고</td>
								<td>
									<select class="easyui-combobox" id="searchBidType" data-options="panelHeight:'auto'" style="width:100px;">
									        <option value="1">공고번호</option>
									        <option value="2">공고명</option>
									</select>
									<input type="text" class="easyui-textbox" id="bidNoticeNo" style="width: 120px;">
								</td>
								<td class="bc">담당자</td>
								<td><input id="userId" class="easyui-combobox"
									data-options="
									method:'get',
							        valueField: 'user_id',
							        textField: 'user_nm',
							        width:100,
							        panelHeight:'auto',
							        data:jsonData">
							        <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectList()">조회</a>	 						        
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
			                   data-options="rownumbers:false,
													  singleSelect:true,
													  pagination:true,
													  pageSize:100,
													  method:'get',
													  striped:true,
													  nowrap:false,													  								
													  pageList:[100,50,200,500],
													  rowStyler: function(index,row){
										                    if (row.finish_status=='F'){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }
										              }">
			                <thead>
			                    <tr>
			                    	<th data-options="field:'user_nm',align:'left',width:100 ,halign:'center'">담당자</th>
			                        <th data-options="field:'user_cnt',align:'left',width:100 ,halign:'center'">검토입찰건</th>
			                        <th data-options="field:'user_cnt',align:'left',width:100 ,halign:'center'">검토중</th>
			                        <th data-options="field:'user_cnt',align:'left',width:100 ,halign:'center'">Drop</th>
			                        <th data-options="field:'user_cnt',align:'left',width:100 ,halign:'center'">유효견적</th>
			                        <th data-options="field:'user_cnt',align:'left',width:100 ,halign:'center'">유효견적률</th>
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
			            </script>
					</div>
					<div title="결과리포트" style="padding:5px">
					</div>										
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 투찰사 투찰 이력정보 Dialog start -->
	<div id="bizBidInfoDlg" class="easyui-dialog" title="투찰사 투찰정보이력" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:900px;height:700px;padding:10px">
		<div style="padding: 5px; font-weight: bold; display: inline-block; background: #f9f9f9; margin-bottom: 5px; border: 1px solid #71ace6;">
			<span>누적 투찰 개수 :</span>
			<span id="eventBidCnt"></span>
			<span>
				<span>[</span>
				<span id="eventStartDate"></span>
				<span>~</span>
				<span id="eventEndDate"></span>
				<span>]</span>
			</span>
		</div>
    	<table id="bizBidInfoTb" class="easyui-datagrid" style="width:100%;height:100%;"
			data-options="rownumbers:true,
						singleSelect:true,
						striped:true,
						nowrap:false,
						rowStyler: function(index,row){
			                    if (row.bid_type!='1'){
			                        return 'background-color:#eeeeee;color:#999999;';
			                    }
			              }
						  ">
			<thead>
				<tr>
					<th data-options="field:'bid_notice_no',align:'left',width:150,halign:'center'" formatter="formatNoticeNo"> 공고번호</th>
					<th data-options="field:'bid_notice_nm',align:'left',width:250,halign:'center'" >공고명</th>
					<th data-options="field:'bid_type',align:'center',width:50,halign:'center'" formatter="formatBidYn">참여</th>
					<th data-options="field:'open_rank',align:'right',width:50,halign:'center'">순위</th>
					<th data-options="field:'bid_price',align:'right',width:100,halign:'center'" formatter="numberComma">투찰액</th>
					<th data-options="field:'bid_percent',align:'right',width:80,halign:'center'">사정율</th>
					<th data-options="field:'note',align:'left',width:150,halign:'center'">비고</th>
				</tr>
			</thead>
		</table>
    </div>
    <script>
    	function formatBidYn(val,row){
    		return val=="1"?"Y":"N";
    	}
    	
    </script>
    <!-- 투찰사 투찰 이력정보 Dialog end -->
</body>
</html>