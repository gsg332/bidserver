<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>계찰결과</title>
<%@ include file="/include/session.jsp"%>
<script>

	var jsonData=null;
	var jsonData2=null;
	var jsonData3=null;
	var jsonData4=null;
	var jsonData5=null;
	
	//담당자 콤보 선택
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/userList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'N'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData=json;
	   }
	});
	
	//담당자 콤보 전체
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/userList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'A'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData2=json;
	   }
	});
	
	
	//지역 콤보
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/comboList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'C',
			cdGroupCd : 'main_area_cd'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData4=json;
	   }
	});
	
	$(document).ready(function() {
		eventInit();
		init();
		popupApplyInfo();
	});
	
	
	//조회 텍스트 박스 이벤트 binding
	function eventInit(){
		var textbox_name = ["#bidNoticeNo", "#bidAreaNm", "#bidDemandNm","#bidBigo","#bidGoodsNm"
			              ];
		for(var i=0; i<textbox_name.length;i++){
			var t = $(textbox_name[i]);
// 			if(i < 5){
// 				t.textbox('textbox').bind('keydown', function(e){
// 				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
// 					   selectBidList();
// 				   }
// 				});	
// 		     }else if(i>=5 && i < 10){
// 				t.textbox('textbox').bind('keydown', function(e){
// 				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
// 					   selectBidList2();
// 				   }
// 				});	
// 		     }else if(i>=10 && i < 15){
// 			   t.textbox('textbox').bind('keydown', function(e){
// 				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
// 					   selectBidList3();
// 				   }
// 				});	
// 		     }else if(i>=15 && i < 20){
// 			   t.textbox('textbox').bind('keydown', function(e){
// 				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
// 					   selectBidList4();
// 				   }
// 				});	
// 		     }
		}
		
	}
	
    //조회조건 날짜 초기화
	function init(){
	    var dts = new Date();
		var dte = new Date();
	    var dayOfMonth = dts.getDate();
	    dts.setDate(dayOfMonth-30);
	    dte.setDate(dayOfMonth+7);
	    dts = dts.getFullYear()+"-"+((dts.getMonth() + 1)<9?"0"+(dts.getMonth() + 1):(dts.getMonth() + 1))+"-"+dts.getDate();
	    dte = dte.getFullYear()+"-"+((dte.getMonth() + 1)<9?"0"+(dte.getMonth() + 1):(dte.getMonth() + 1))+"-"+dte.getDate();
	    
	    for(var i=1;i<5;i++){
	    	if(i==1){
			    $('#bidStartDt').datebox('setValue',dts);
			    $('#bidEndDt').datebox('setValue',dte);
	    	}else{
			    $('#bidStartDt'+i).datebox('setValue',dts);
			    $('#bidEndDt'+i).datebox('setValue',dte);
	    	}
	    }
	}
    
	
</script>
</head>
<body>

	<div id="header" class="group wrap header">
		<div class="content">
			<%@ include file="/include/top.jsp"%>
		</div>
	</div>
 
	<div id="mainwrap" style="display: block;">
		<div id="content">
			<div style="margin: 1px 0; vertical-align: top"></div>
			<div class="easyui-layout" style="width: 100%; height: 800px; vertical-align: top;">
				<div data-options="region:'center'">
					<div id="maintab" class="easyui-tabs" data-options="fit:true,border:false,plain:true">
						<div title="개찰결과" style="padding: 5px">
							<div class="easyui-layout" style="width:100%;height:750px;">
							    <div data-options="region:'north',border:false">
							    	<table style="width: 100%;">
										<tr>
											<td class="bc">공고</td>
											<td>
												<select class="easyui-combobox" id="searchBidType"  style="width:100px;">
												        <option value="1">공고번호</option>
												        <option value="2">공고명</option>
												</select>
												<input type="text" class="easyui-textbox" id="bidNoticeNo" style="width: 120px;">
											</td>
											<td class="bc">지역</td>
											<td>
												<input type="text" class="easyui-textbox" id="bidAreaNm" style="width: 120px;">
											</td>
											<td class="bc">검색일</td>
											<td>
												<select class="easyui-combobox" id="searchDateType"  style="width:100px;">
												        <option value="1">개찰일</option>
												        <option value="2">공고게시일</option>
												</select>
		
											</td>
											<td><input class="easyui-datebox" id="bidStartDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
												~ <input class="easyui-datebox" id="bidEndDt"  style="width:100px;"	data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											</td>
											<td class="bc">수요처</td>
											<td><input type="text" class="easyui-textbox" id="bidDemandNm" style="width: 150px;"></td>
											<td class="bc">물품명</td>
											<td><input type="text" class="easyui-textbox" id="bidGoodsNm" style="width: 150px;"></td>
											<td class="bc">담당자</td>
											<td><input id="userId" class="easyui-combobox"
												data-options="
												method:'get',
										        valueField: 'user_id',
										        textField: 'user_nm',
										        width:100,
										        data:jsonData2">
											</td>
											<td class="bc">비고내용</td>
											<td><input type="text" class="easyui-textbox" id="bidBigo" style="width: 150px;"></td>
											<td width="200px">
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList()">조회</a> 
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload'" onclick="$('#bidInfoDlg').dialog('open');">공고갱신</a>
											</td>
										</tr>
									</table>
							    </div>
							    <div data-options="region:'south',split:true,border:false" style="height:300px;">
									<div class="easyui-layout" style="width: 100%; height: 100%;">
										<div data-options="region:'west',collapsible:false" title="개찰관련정보" style="width: 50%;">
												<form id="tab1_left_form" method="post" >
												<font style="font-weight: bold; padding-left: 10px;"> [ 입찰결과 ] </font>
												<table cellpadding="5" style="width: 100%; padding: 10px;">
													<tr>
														<td class="bc" style="width: 20%;">공고번호</td>
														<td style="width: 30%;"><font id="tab1_bid_notice_no"></font></td>
														<td class="bc" style="width: 20%;">참조번호</td>
														<td style="width: 30%;"><font id=""></font></td>
													</tr>
													<tr>
														<td class="bc">공고명</td>
														<td colspan="3" ><font id="tab1_bid_notice_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">공고기관</td>
														<td><font id="tab1_order_agency_nm"></font></td>
														<td class="bc">수요기관</td>
														<td><font id="tab1_bid_demand_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">집행관</td>
														<td><font id=""></font></td>
														<td class="bc">입회관(담당자)</td>
														<td><font id=""></font></td>
													</tr>
													<tr>
														<td class="bc">실제개찰일시</td>
														<td colspan="3" ><font id="tab1_bid_notice_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">적격심사결과</td>
														<td colspan="3" ><font id=""></font></td>
													</tr>
												</table>
												<div id="tab1_detal5"></div>
											</form>
										</div>
										<div data-options="region:'east',collapsible:false"
											title="복수예비가 및 예정가격" style="width: 50%;">
											<form id="tab1_right_form" method="post">
												<table cellpadding="5" style="width: 100%;padding:10px">
													<tr>
														<td class="bc" style="width: 20%;">입찰분류</td>
														<td style="width: 30%;"><font id="tab1_bid_notice_no"></font></td>
														<td class="bc" style="width: 20%;">재입찰번호</td>
														<td style="width: 30%;"><font id=""></font></td>
													</tr>
													<tr>
														<td class="bc">예가범위</td>
														<td><font id=""></font></td>
														<td class="bc">기초금액기준 상위갯수</td>
														<td><font id=""></font></td>
													</tr>
													<tr>
														<td class="bc">정렬기준</td>
														<td><font id=""></font></td>
														<td class="bc">복수예비가격 작성시각</td>
														<td><font id=""></font></td>
													</tr>
												</table>
												<table cellpadding="5" style="width: 100%;padding:10px">
												</table>
											</form>
										</div>
									</div>
							    </div>
							    <div data-options="region:'center',border:false">
							    	<table id="dg" class="easyui-datagrid"
										style="width: 100%; height: 100%"
										data-options="rownumbers:true,
													  singleSelect:true,
													  pagination:true,
													  pageSize:30,
													  method:'get',
													  striped:true,
													  nowrap:false,
													  sortName:'noti_dt',
													  sortOrder:'desc',
													  onClickCell:onClickCell,
													  onEndEdit:onEndEdit,
													  onBeforeEdit:onBeforeEdit,
													  pageList:[30,50,70,100,150,200,500],
													  rowStyler: function(index,row){
										                    if (row.finish_status=='F'){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }
										              }">
										<thead>
											<tr>
		<!-- 										<th data-options="field:'ck',checkbox:true"></th> -->
		
												<th data-options="field:'user_id',align:'center',halign:'center',width:70,
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
											                                required:false
											                            }
											                        }">담당자</th>
												<th data-options="field:'permit_biz_type_info',halign:'center',width:200" formatter="bidLicense">업종제한</th>
												<th data-options="field:'product_yn',align:'center',halign:'center',width:40,resizable:true">제조<br/>제한</th>
												<th data-options="field:'nation_bid_yn',align:'center',halign:'center',width:40">국제<br/>입찰</th>
												<th data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true"	formatter="formatNoticeNo">공고번호</th>
												<th data-options="field:'bid_notice_nm',align:'left',width:300,halign:'center',sortable:true" formatter="formatNoticeNm">공고명</th>
												<th data-options="field:'demand_nm',align:'left',width:150 ,halign:'center',sortable:true" formatter="formatEnter">수요처</th>
												<th	data-options="field:'bid_method',align:'left',width:100 ,halign:'center'">입찰방식</th>
												<th	data-options="field:'contract_type_nm',align:'left',width:100 ,halign:'center'">계약방법</th>
												<th data-options="field:'detail_goods_nm',align:'left',width:100 ,halign:'center'">물품명</th>
												<th data-options="field:'use_area_info',align:'left',width:100 ,halign:'center'" formatter="formatCommaEnter">지역</th>
												<th data-options="field:'pre_price',align:'right',width:100 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
												<th data-options="field:'base_price',align:'right',width:100 ,halign:'center',editor:{type:'numberbox',options:{groupSeparator:','}}" formatter="numberComma">기초금액</th>
												<th data-options="field:'base_price2',align:'center',width:80 ,halign:'center'" formatter="formatRowButton2">기초금액<br/>가져오기</th>
<!-- 												<th data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th> -->
<!-- 												<th data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰개시일시</th> -->
												<th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="bidFormatDate">입찰개시일시<br/>입찰마감일시</th>
												<th data-options="field:'bigo',align:'left',width:150 ,halign:'center',editor:'textbox'">비고</th>
											</tr>
										</thead>
									</table>
							    </div>
							</div>

							<div id="cc" class="easyui-calendar"></div>

						</div>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="/include/popup.jsp" %>
	</div>
</body>
</html>