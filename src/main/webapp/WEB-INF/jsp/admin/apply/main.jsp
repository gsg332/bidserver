<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<%@ include file="/include/session.jsp" %>
<script>

	var jsonData=null;
	var jsonData6=null;
	var jsonData7=null;
	
	
	//리스크 콤보
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/comboList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'C',
			cdGroupCd : 'bid_risk_cd'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData6=json;
	   }
	});
	
	//조달사이트 콤보
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/comboList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'C',
			cdGroupCd : 'bid_site_cd'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData7=json;
	   }
	});
	
	$(document).ready(function() {
		init();
		
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
	
    //조회조건 날짜 초기화
	function init(){
	    keydownEvent();
	    setGrid();
	}
	
	function setGrid() {
		//tab1
		selectBidList();
	}
	

	function keydownEvent(){
		
		var t = $('#bidNoticeNo');
		t.textbox('textbox').bind('keydown', function(e){
		   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
			   setGrid();
		   }
		});	

		t = $('#bidNoticeNm');
		t.textbox('textbox').bind('keydown', function(e){
		   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
			   setGrid();
		   }
		});	

	}
	
	
	//tab1 조회
	function selectBidList(){
		
		$("#dg").datagrid({
			method : "GET",
			url : "<c:url value='/apply/bidMyApplyList.do'/>",
			/*
			queryParams : {
				userId : $("#userId").combogrid("getValue")? $("#userId").combogrid("getValue") : 'sylee',
				bidNoticeNo : $('#bidNoticeNo').val()? $('#bidNoticeNo').val() : '',
				bidNoticeNm : $('#bidNoticeNm').val()? $('#bidNoticeNm').val() : '',
				bidStartDt :$('#bidStartDt').datebox('getValue')? $('#bidStartDt').datebox('getValue') : '2017-06-01',
				bidEndDt : $('#bidEndDt').datebox('getValue')? $('#bidEndDt').datebox('getValue') : '2017-07-10',
				finishYn : $('#finishYn').combobox("getValue")? $('#finishYn').combobox("getValue") : ''
			},
			*/
			queryParams : {
				userId : $("#userId").combogrid("getValue"),
				bidNoticeNo : $('#bidNoticeNo').val(),
				bidNoticeNm : $('#bidNoticeNm').val(),
				bidStartDt :$('#bidStartDt').datebox('getValue'),
				bidEndDt : $('#bidEndDt').datebox('getValue'),
				finishYn : $('#finishYn').combobox("getValue")
			},
			onLoadSuccess : function(row, param) {
				eventBtn();
			},
			onDblClickRow : function(index, row){
				setReportInfo(row);
				
				$("#apply_comment1").textbox("setValue","");
				$("#apply_comment2").textbox("setValue","");
				$("#apply_comment3").textbox("setValue","");
				if(row.status_step=="1"){
					$("#apply_comment2").textbox("disable");
					$("#apply_comment3").textbox("disable");
					if(row.apply_user_id1=="<%=loginId%>"){
						$("#apply_comment1").textbox("enable");
						$("#applyBtn").css("display","");
// 						$("#saveBtn").css("display","");
						$("#cancelBtn").css("display","");
					}else{
						$("#apply_comment1").textbox("disable");
						$("#applyBtn").css("display","none");
// 						$("#saveBtn").css("display","none");
						$("#cancelBtn").css("display","none");
					}
				}
				if(row.status_step=="2"){
					$("#apply_comment1").textbox("disable");
					$("#apply_comment3").textbox("disable");
					
					if(row.apply_user_id2=="<%=loginId%>"){
						$("#apply_comment2").textbox("enable");
						$("#applyBtn").css("display","");
// 						$("#saveBtn").css("display","");
						$("#cancelBtn").css("display","");
					}else{
						$("#apply_comment2").textbox("disable");
						$("#applyBtn").css("display","none");
// 						$("#saveBtn").css("display","none");
						$("#cancelBtn").css("display","none");
					}
				}
				if(row.status_step=="3"){
					$("#apply_comment1").textbox("disable");
					$("#apply_comment2").textbox("disable");
					if(row.status_cd=="002"){
						$("#apply_comment3").textbox("enable");
					}else{
						$("#apply_comment3").textbox("disable");
					}
					
					if(row.apply_user_id3=="<%=loginId%>"){
						$("#apply_comment3").textbox("enable");
						$("#applyBtn").css("display","");
// 						$("#saveBtn").css("display","");
						$("#cancelBtn").css("display","");
					}else{
						$("#apply_comment3").textbox("disable");
						$("#applyBtn").css("display","none");
// 						$("#saveBtn").css("display","none");
						$("#cancelBtn").css("display","none");
					}
				}
				
				$("#apply_comment1").textbox("setValue",row.apply_comment1);
				$("#apply_comment2").textbox("setValue",row.apply_comment2);
				$("#apply_comment3").textbox("setValue",row.apply_comment3);
				
				getBidApplyDtl()
			}
		});
	}
	
	function getBidApplyDtl(){
		
		var row = $("#dg").datagrid('getSelected');
		if (!row) {
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
		
		$('#manufactureList').dialog('open');
// 		$("#manufactureTb").datagrid({
// 			method : "GET",
// 			url : "<c:url value='/apply/manufactureList.do'/>",
// 			queryParams : {
// 				bid_notice_no : row.bid_notice_no,
// 				bid_notice_cha_no : row.bid_notice_cha_no
// 			},
// 			onLoadSuccess : function(row, param) {
				
// 				$('#manufactureList').dialog('open');
// 			}
// 		});
		
	}
	
	//tab3 입찰관련정보 
	function setReportInfoInit(){
		$("#tab_bid_notice_no").empty();
		$("#tab_bid_notice_nm").empty();
		$("#tab_noti_dt").empty();
		$("#tab_bid_demand_nm").empty();
		$("#tab_bid_start_dt").empty();
		$("#tab_bid_end_dt").empty();
		$("#tab_bid_open_dt").empty();
		$("#tab_bid_cont_demand").empty();
		$("#tab_nation_bid_yn").empty();
		$("#tab_pre_price").empty();
		$("#tab_base_price").empty();
		$("#tab_bid_success").empty();
		$("#tab_notice_spec_form1").empty();
		$("#tab_notice_spec_form2").empty();
		$("#tab_notice_spec_form3").empty();
		$("#tab_notice_spec_form4").empty();
		$("#tab_notice_spec_form5").empty();
		$("#tab_notice_spec_form6").empty();
		$("#tab_notice_spec_form7").empty();
		$("#tab_notice_spec_form8").empty();
		$("#tab_notice_spec_form9").empty();
		$("#tab_notice_spec_form10").empty();
		$('#tab_column1').empty();
		$('#tab_column2').empty();
		$('#tab_column3').empty();
		$('#tab_column5').empty();
		
		
		
	    setReportBidList('','');
	}
	
	//tab3 입찰관련정보 
	function setReportInfo(row){
		setReportInfoInit();
		cleanSubject();
		$("#tab_bid_notice_no").text(row.bid_notice_no+"-"+row.bid_notice_cha_no);
		$("#tab_bid_notice_nm").text(row.bid_notice_nm);
		$("#tab_noti_dt").text(formatDate(row.noti_dt));
		$("#tab_bid_demand_nm").text(row.demand_nm);
		$("#tab_bid_start_dt").text(formatDate(row.bid_start_dt));
		$("#tab_bid_end_dt").text(formatDate(row.bid_end_dt));
		$("#tab_bid_open_dt").text(formatDate(row.bid_open_dt));
		$("#tab_bid_cont_demand").text(row.contract_type_nm);
		$("#tab_nation_bid_yn").text(row.nation_bid_yn);
		$("#tab_pre_price").empty();
		$("#tab_pre_price").append(numberComma(row.pre_price));
		$("#tab_base_price").empty();
		$("#tab_base_price").append(numberComma(row.base_price));
		$("#tab_bid_success").text(row.bid_success);
		$("#tab_notice_spec_form1").text("");
		$("#tab_notice_spec_form2").text("");
		$("#tab_notice_spec_form3").text("");
		$("#tab_notice_spec_form4").text("");
		$("#tab_notice_spec_form5").text("");
		$("#tab_notice_spec_form6").text("");
		$("#tab_notice_spec_form7").text("");
		$("#tab_notice_spec_form8").text("");
		$("#tab_notice_spec_form9").text("");
		$("#tab_notice_spec_form10").text("");
		
		if(row.notice_spec_file_nm1==null) $("#div_notice_spec_form1").css("display","none");
		if(row.notice_spec_file_nm2==null) $("#div_notice_spec_form2").css("display","none");
		if(row.notice_spec_file_nm3==null) $("#div_notice_spec_form3").css("display","none");
		if(row.notice_spec_file_nm4==null) $("#div_notice_spec_form4").css("display","none");
		if(row.notice_spec_file_nm5==null) $("#div_notice_spec_form5").css("display","none");
		if(row.notice_spec_file_nm6==null) $("#div_notice_spec_form6").css("display","none");
		if(row.notice_spec_file_nm7==null) $("#div_notice_spec_form7").css("display","none");
		if(row.notice_spec_file_nm8==null) $("#div_notice_spec_form8").css("display","none");
		if(row.notice_spec_file_nm9==null) $("#div_notice_spec_form9").css("display","none");
		if(row.notice_spec_file_nm10==null) $("#div_notice_spec_form10").css("display","none");

		if(row.notice_spec_file_nm1!=null) $("#div_notice_spec_form1").css("display","");
		if(row.notice_spec_file_nm2!=null) $("#div_notice_spec_form2").css("display","");
		if(row.notice_spec_file_nm3!=null) $("#div_notice_spec_form3").css("display","");
		if(row.notice_spec_file_nm4!=null) $("#div_notice_spec_form4").css("display","");
		if(row.notice_spec_file_nm5!=null) $("#div_notice_spec_form5").css("display","");
		if(row.notice_spec_file_nm6!=null) $("#div_notice_spec_form6").css("display","");
		if(row.notice_spec_file_nm7!=null) $("#div_notice_spec_form7").css("display","");
		if(row.notice_spec_file_nm8!=null) $("#div_notice_spec_form8").css("display","");
		if(row.notice_spec_file_nm9!=null) $("#div_notice_spec_form9").css("display","");
		if(row.notice_spec_file_nm10!=null) $("#div_notice_spec_form10").css("display","");
		
		$("#tab_notice_spec_form1").text(row.notice_spec_file_nm1);
		$("#tab_notice_spec_form1").prop('href',row.notice_spec_form1);
		$("#tab_notice_spec_form2").text(row.notice_spec_file_nm2);
		$("#tab_notice_spec_form2").prop('href',row.notice_spec_form2);
		$("#tab_notice_spec_form3").text(row.notice_spec_file_nm3);
		$("#tab_notice_spec_form3").prop('href',row.notice_spec_form3);
		$("#tab_notice_spec_form4").text(row.notice_spec_file_nm4);
		$("#tab_notice_spec_form4").prop('href',row.notice_spec_form4);
		$("#tab_notice_spec_form5").text(row.notice_spec_file_nm5);
		$("#tab_notice_spec_form5").prop('href',row.notice_spec_form5);
		$("#tab_notice_spec_form6").text(row.notice_spec_file_nm6);
		$("#tab_notice_spec_form6").prop('href',row.notice_spec_form6);
		$("#tab_notice_spec_form7").text(row.notice_spec_file_nm7);
		$("#tab_notice_spec_form7").prop('href',row.notice_spec_form7);
		$("#tab_notice_spec_form8").text(row.notice_spec_file_nm8);
		$("#tab_notice_spec_form8").prop('href',row.notice_spec_form8);
		$("#tab_notice_spec_form9").text(row.notice_spec_file_nm9);
		$("#tab_notice_spec_form9").prop('href',row.notice_spec_form9);
		$("#tab_notice_spec_form10").text(row.notice_spec_file_nm10);
		$("#tab_notice_spec_form10").prop('href',row.notice_spec_form10);
		
		$("#file_id").filebox("setValue","");
		$("#file_id").textbox("setValue",row.file_nm);
		$('#file_link').unbind('click',null);
		$('#file_remove').unbind('click',null);
		
		$('#file_link').bind('click', function(){
			if($("#file_id").textbox("getText").length>0){
				location.href = "<c:url value='/file/download.do?file_id="+row.file_id+"'/>";
			}else{
				$.messager.alert("알림", "파일이 존재하지 않습니다.");
				return;
			}
		});
		$('#file_remove').bind('click', function(){
			if($("#file_id").textbox("getText").length>0){
				$("#file_id").textbox("setValue","");
			}else{
				$.messager.alert("알림", "파일이 존재하지 않습니다.");
				return;
			}
		});
		
		//입찰사용자등록정보
		getReportDtl(row.bid_notice_no,row.bid_notice_cha_no);
		
		//입찰 제조사 정보
		setReportBidList(row.bid_notice_no,row.bid_notice_cha_no);
	}
	
	function setDefaultComboBoxValue(){
		$('#info1_1').combobox('setValue',"Y");
	    $('#info1_2').combobox('setValue',"Y");
	    $('#info1_3').combobox('setValue',"Y");
	    $('#info1_4').combobox('setValue',"Y");
	    $('#info1_5').combobox('setValue',"Y");
	    $('#info1_6').combobox('setValue',"Y");
	    $('#info2_1').combobox('setValue',"Y");
	    $('#info2_2').combobox('setValue',"Y");
	    $('#info2_3').combobox('setValue',"Y");
	    $('#info2_4').combobox('setValue',"Y");
	    $('#info2_5').combobox('setValue',"Y");
	} 
	
	function cleanSubject(){
		
		$("#bid_cont").textbox('setValue',"");
		$("#bid_term").textbox('setValue',"");
		$("#bid_sp_cont").textbox('setValue',"");
		$("#bid_tot_cont").textbox('setValue',"");
	    $('#bid_site').combobox('setValue',"");
	    $('#bid_risk').combobox('setValue',"");

	    $('#info1_1').combobox('setValue',"");
	    $('#info1_2').combobox('setValue',"");
	    $('#info1_3').combobox('setValue',"");
	    $('#info1_4').combobox('setValue',"");
	    $('#info1_5').combobox('setValue',"");
	    $('#info1_6').combobox('setValue',"");
		$("#info1_6t").textbox('setValue',"");
		$("#info1_1d").textbox('setValue',"");
		$("#info1_2d").textbox('setValue',"");
		$("#info1_3d").textbox('setValue',"");
		$("#info1_4d").textbox('setValue',"");
		$("#info1_5d").textbox('setValue',"");
		$("#info1_6d").textbox('setValue',"");
		$("#info1_7").textbox('setValue',"");
	    $('#info2_1').combobox('setValue',"");
	    $('#info2_2').combobox('setValue',"");
	    $('#info2_3').combobox('setValue',"");
	    $('#info2_4').combobox('setValue',"");
	    $('#info2_5').combobox('setValue',"");
		$("#info2_5t").textbox('setValue',"");
		$("#info2_1d").textbox('setValue',"");
		$("#info2_2d").textbox('setValue',"");
		$("#info2_3d").textbox('setValue',"");
		$("#info2_4d").textbox('setValue',"");
		$("#info2_5d").textbox('setValue',"");
		$("#info2_6").textbox('setValue',"");
		$("#info3").textbox('setValue',"");
	}
	
	//tab3  상세정보
	function getReportDtl(bidNoticeNo, bidNoticeChaNo){
		 $.ajax({ 
			    type: "POST"
			   ,url: "<c:url value='/bid/getBidDtl.do'/>"
			   ,async: false 
			   ,data : {
				   bid_notice_no :bidNoticeNo,
				   bid_notice_cha_no :bidNoticeChaNo
				}
			   ,dataType: "json"
			   ,success:function(json){
				   if(json.rows.length>0){
					    $('#tab_column1').text(numberComma(json.rows[0].column1));
					    $('#tab_column2').text(json.rows[0].column2_nm);
						$('#tab_column3').text(json.rows[0].column3_nm);
						$("#apply_comment1").textbox("setValue",json.rows[0].column4);
					    $('#tab_column5').text(json.rows[0].column5);
				   }
				   
				   if(json.bidSubj !=null){
					    $('#bid_site').combobox("setValue",json.bidSubj.bid_site);
					    $('#bid_risk').combobox("setValue",json.bidSubj.bid_risk);
						$('#bid_term').textbox("setValue",json.bidSubj.bid_term);
						$('#bid_cont').textbox("setValue",json.bidSubj.bid_cont);
						$('#bid_sp_cont').textbox("setValue",json.bidSubj.bid_sp_cont);
						$('#bid_tot_cont').textbox("setValue",json.bidSubj.bid_tot_cont);
				   }

				   if(json.bidRisk !=null){
					    $('#info1_1').combobox("setValue",json.bidRisk.info1_1);
						$('#info1_2').combobox("setValue",json.bidRisk.info1_2);
						$('#info1_3').combobox("setValue",json.bidRisk.info1_3);
						$('#info1_4').combobox("setValue",json.bidRisk.info1_4);
						$('#info1_5').combobox("setValue",json.bidRisk.info1_5);
						$('#info1_6').combobox("setValue",json.bidRisk.info1_6);
						$('#info1_6t').textbox("setValue",json.bidRisk.info1_6t);
						$('#info1_7').textbox("setValue",json.bidRisk.info1_7);
						$('#info1_1d').textbox("setValue",json.bidRisk.info1_1d);
						$('#info1_2d').textbox("setValue",json.bidRisk.info1_2d);
						$('#info1_3d').textbox("setValue",json.bidRisk.info1_3d);
						$('#info1_4d').textbox("setValue",json.bidRisk.info1_4d);
						$('#info1_5d').textbox("setValue",json.bidRisk.info1_5d);
						$('#info1_6d').textbox("setValue",json.bidRisk.info1_6d);
						$('#info2_1').combobox("setValue",json.bidRisk.info2_1);
						$('#info2_2').combobox("setValue",json.bidRisk.info2_2);
						$('#info2_3').combobox("setValue",json.bidRisk.info2_3);
						$('#info2_4').combobox("setValue",json.bidRisk.info2_4);
						$('#info2_5').combobox("setValue",json.bidRisk.info2_5);
						$('#info2_5t').textbox("setValue",json.bidRisk.info2_5t);
						$('#info2_6').textbox("setValue",json.bidRisk.info2_6);
						$('#info2_1d').textbox("setValue",json.bidRisk.info2_1d);
						$('#info2_2d').textbox("setValue",json.bidRisk.info2_2d);
						$('#info2_3d').textbox("setValue",json.bidRisk.info2_3d);
						$('#info2_4d').textbox("setValue",json.bidRisk.info2_4d);
						$('#info2_5d').textbox("setValue",json.bidRisk.info2_5d);
						$('#info3').textbox("setValue",json.bidRisk.info3);
				   }
			   }
		});
	}
	
	//tab3 제조사 조회
	function setReportBidList(bidNoticeNo, bidNoticeChaNo){
		$("#bc3_1").datagrid({
			method : "GET",
			url : "<c:url value='/bid/selectEstimateList.do'/>",
			queryParams : {
				bid_notice_no :bidNoticeNo,
				bid_notice_cha_no : bidNoticeChaNo,
			},
			onLoadSuccess : function(row, param) {
				setDefaultComboBoxValue();
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
			<div class="easyui-layout" style="width: 100%; height: 800px; vertical-align: top;">
				<!-- 	<div data-options="region:'north'" style="height:0px;vertical-align:top;"></div> -->

				<div data-options="region:'center'">
					<div id="maintab" class="easyui-tabs"
						data-options="fit:true,border:false,plain:true">
						<div title="결재요청목록" style="padding: 5px">
							<table style="width:100%;">
							        <tr>
							            <td class="bc">공고번호</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="bidNoticeNo" name="bidNoticeNo"   style="width:200px;"   >
							            </td>
							            <td class="bc">공고명</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="bidNoticeNm" name="bidNoticeNm"   style="width:200px;"   >
							            </td>
							            
							        	<td class="bc">결재요청일</td>
							            <td>
							                <input class="easyui-datebox" id="bidStartDt" name="bidStartDt" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
							                ~
							                <input class="easyui-datebox" id="bidEndDt" name="bidEndDt"  data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
							            </td>
							            <td class="bc">담당자 </td>
							            <td>
							            	<input id="userId" class="easyui-combobox" data-options="
											method:'get',
									        valueField: 'user_id',
									        textField: 'user_nm',
									        panelHeight:'auto',
									        url: '<c:url value='/bid/userList.do?searchType=A'/>'">
							            </td>
							            <td class="bc">승인완료</td>
							            <td>
							            	<select class="easyui-combobox" id="finishYn" data-options="panelHeight:'auto'" style="width:100px;">
											        <option value="">전체</option>
											        <option value="Y">미완료</option>
											        <option value="N">완료</option>
											</select>
 							            </td>
							            <td style="float: right;">
							                <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectBidList()" >조회</a>
							            </td>
							        </tr>
							    </table>
							    <div id="cc" class="easyui-calendar"></div>
							<table id="dg" class="easyui-datagrid" style="width:100%;height:85%;"
								data-options="rownumbers:true,
											  singleSelect:true,
											  pagination:true,
											  pageSize:30,
									  		  pageList:[30,50,70,100,150,200,500],
											  method:'get',
											  striped:true,
											  nowrap:false,
											  sortName:'noti_dt',
											  sortOrder:'desc',
											   rowStyler: function(index,row){
										                    if (row.status_cd3=='002'){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }
										              }
											  ">
								<thead>
									<tr>
										<th rowspan="2" data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true" formatter="formatNoticeNo">공고번호</th>
										<th rowspan="2" data-options="field:'bid_notice_nm',align:'left',width:300,halign:'center',sortable:true" formatter="formatNoticeNm">공고명</th>
										<th rowspan="2" data-options="field:'demand_nm',align:'left',width:150 ,halign:'center',sortable:true" formatter="formatEnter">수요처</th>
										<th rowspan="2" data-options="field:'detail_goods_nm',align:'left',width:100 ,halign:'center'">물품명</th>
										<th	rowspan="2" data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th>
										<th	rowspan="2" data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰개시일시</th>
										<th	rowspan="2" data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰마감일시</th>
										<th	colspan="3">담당자</th>
										<th	colspan="3">팀장</th>
										<th	colspan="3">총책임자</th>
										<th rowspan="2" data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton">삭제</th>
									</tr>
									<tr>
										<th	data-options="field:'user_nm1',align:'center',width:60 ,halign:'center'">담당자</th>
										<th	data-options="field:'apply_dt_nm1',align:'center',width:100 ,halign:'center'">처리일자</th>
										<th	data-options="field:'status_nm1',align:'center',width:60 ,halign:'center'">승인상태</th>
										<th	data-options="field:'user_nm2',align:'center',width:60 ,halign:'center'">담당자</th>
										<th	data-options="field:'apply_dt_nm2',align:'center',width:100 ,halign:'center'">처리일자</th>
										<th	data-options="field:'status_nm2',align:'center',width:60 ,halign:'center'">승인상태</th>
										<th	data-options="field:'user_nm3',align:'center',width:60 ,halign:'center'">담당자</th>
										<th	data-options="field:'apply_dt_nm3',align:'center',width:100 ,halign:'center'">처리일자</th>
										<th	data-options="field:'status_nm3',align:'center',width:60 ,halign:'center'">승인상태</th>
									</tr>
								</thead>
							</table>
							
							<script type="text/javascript">
									function eventBtn() {
										 $('#dg').datagrid('getPanel').find("[type='del_type']").each(function(index){
												$(this).linkbutton({
													onClick:function(){
														var row = $("#dg").datagrid("selectRow",index);
														var row = $("#dg").datagrid("getSelected");
														
														if(row.status_cd2=='002'){
															$.messager.alert("알림","담당자가 승인대기중이거나 팀장 미승인 공고만 삭제가능합니다.");
															return;
														}
														
														$.messager.confirm('알림', "삭제하시겠습니까?", function(r){
															if (r) {
																if (endEditing()) {
																	var $dg = $("#dg");
			
																	var effectRow = new Object();
																	if (row) {
																		effectRow["bid_notice_no"] = row.bid_notice_no;
																		effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
																	}
																	$.post("<c:url value='/apply/deleteBidApplyList.do'/>",effectRow,
																		function(rsp) {
																			if (rsp.status) {
																				$.messager.alert("알림","삭제하였습니다.");
																				$dg.datagrid('reload');
																			}
																		},"JSON").error(function() {
																			$.messager.alert("알림","삭제에러！");
																	});
																}
															}
											        	});
													}
												})
											});
										
										
									}
							
									function formatRowButton(val,row){
										   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-remove'\" type=\"del_type\" val=\""+row.bid_notice_no+"\" onclick=\"\" >삭제</a>";
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
							       function onClickCell(index, field){
							           if (editIndex != index){
							        	   getBidApplyDtl();
// 							               if (endEditing()){
// 							                   $('#dg').datagrid('selectRow', index)
// 							                           .datagrid('beginEdit', index);
// 							                   var ed = $('#dg').datagrid('getEditor', {index:index,field:field});
// 							                   if (ed){
// 							                       ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
// 							                   }
// 							                   editIndex = index;
// 							               } else {
// 							                   setTimeout(function(){
// 							                       $('#dg').datagrid('selectRow', editIndex);
// 							                   },0);
// 							               }
							           }
							           eventBtn();
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
							       
							       function append(){
							   		if (endEditing()){
							   			$('#dg').datagrid('appendRow',{status:'P'});
							   			editIndex = $('#bc').datagrid('getRows').length-1;
							   			$('#dg').datagrid('selectRow', editIndex)
							   					.datagrid('beginEdit', editIndex);
							   		}
							   	}
						   	
							 	
						        
						        function save(type){
						        	var type_nm = "저장";
						        	
						        	if(type=="1"){
						        		type_nm = "저장";
						        	}else if(type=="2"){
						        		type_nm = "반려";
						        	}else if(type=="3"){
						        		type_nm = "승인";
						        	}
						        	
						        	$.messager.confirm('알림', type_nm+"하시겠습니까?", function(r){
						    	        if (r){
								    		var $dg = $("#dg");
								    		
								    		var row = $dg.datagrid('getSelected');

						    				var effectRow = new Object();

							    			var form = new FormData(document.getElementById('uploadForm'));
							    			
							    			form.append("bid_notice_no", encodeURIComponent(row.bid_notice_no));
							    			form.append("bid_notice_cha_no", encodeURIComponent(row.bid_notice_cha_no));
							    			form.append("status_step", encodeURIComponent(row.status_step));
					    					if(row.status_step=="1"){
								    			form.append("apply_comment", encodeURIComponent($("#apply_comment1").textbox("getValue")));
					    					}
					    					if(row.status_step=="2"){
								    			form.append("apply_comment", encodeURIComponent($("#apply_comment2").textbox("getValue")));
					    					}
					    					if(row.status_step=="3"){
								    			form.append("apply_comment", encodeURIComponent($("#apply_comment3").textbox("getValue")));
					    					}
							    			form.append("save_type", encodeURIComponent(type));
							    			
						    				form.append("file_id", encodeURIComponent($("#file_id").filebox("getText")));

						    				form.append("bid_cont", encodeURIComponent($("#bid_cont").textbox("getValue")));
						    				form.append("bid_term", encodeURIComponent($("#bid_term").textbox("getValue")));
						    				form.append("bid_sp_cont", encodeURIComponent($("#bid_sp_cont").textbox("getValue")));
						    				form.append("bid_tot_cont", encodeURIComponent($("#bid_tot_cont").textbox("getValue")));
						    				form.append("bid_site", encodeURIComponent($("#bid_site").combobox("getValue")));
						    				form.append("bid_risk", encodeURIComponent($("#bid_risk").combobox("getValue")));
						    				form.append("info1_1", encodeURIComponent($("#info1_1").combobox("getValue")));
						    				form.append("info1_2", encodeURIComponent($("#info1_2").combobox("getValue")));
						    				form.append("info1_3", encodeURIComponent($("#info1_3").combobox("getValue")));
						    				form.append("info1_4", encodeURIComponent($("#info1_4").combobox("getValue")));
						    				form.append("info1_5", encodeURIComponent($("#info1_5").combobox("getValue")));
						    				form.append("info1_6", encodeURIComponent($("#info1_6").combobox("getValue")));
						    				form.append("info1_7", encodeURIComponent($("#info1_7").textbox("getValue")));
						    				form.append("info1_1d", encodeURIComponent($("#info1_1d").textbox("getValue")));
						    				form.append("info1_2d", encodeURIComponent($("#info1_2d").textbox("getValue")));
						    				form.append("info1_3d", encodeURIComponent($("#info1_3d").textbox("getValue")));
						    				form.append("info1_4d", encodeURIComponent($("#info1_4d").textbox("getValue")));
						    				form.append("info1_5d", encodeURIComponent($("#info1_5d").textbox("getValue")));
						    				form.append("info1_6d", encodeURIComponent($("#info1_6d").textbox("getValue")));
						    				form.append("info1_6t", encodeURIComponent($("#info1_6t").textbox("getValue")));
						    				form.append("info2_1", encodeURIComponent($("#info2_1").combobox("getValue")));
						    				form.append("info2_2", encodeURIComponent($("#info2_2").combobox("getValue")));
						    				form.append("info2_3", encodeURIComponent($("#info2_3").combobox("getValue")));
						    				form.append("info2_4", encodeURIComponent($("#info2_4").combobox("getValue")));
						    				form.append("info2_5", encodeURIComponent($("#info2_5").combobox("getValue")));
						    				form.append("info2_1d", encodeURIComponent($("#info2_1d").textbox("getValue")));
						    				form.append("info2_2d", encodeURIComponent($("#info2_2d").textbox("getValue")));
						    				form.append("info2_3d", encodeURIComponent($("#info2_3d").textbox("getValue")));
						    				form.append("info2_4d", encodeURIComponent($("#info2_4d").textbox("getValue")));
						    				form.append("info2_5d", encodeURIComponent($("#info2_5d").textbox("getValue")));
						    				form.append("info2_5t", encodeURIComponent($("#info2_5t").textbox("getValue")));
						    				form.append("info2_6", encodeURIComponent($("#info2_6").textbox("getValue")));
						    				form.append("info3", encodeURIComponent($("#info3").textbox("getValue")));
						    				
						    				
					    				    $.ajax({
					    				      url: "<c:url value='/apply/updateBidMyApplyList.do'/>",
					    				      data: form,
					    				      dataType: 'text',
					    				      processData: false,
					    				      contentType: false,
					    				      type: 'POST',
					    				      success: function (rsp) {
					    				    	  $.messager.alert("알림", type_nm+"하였습니다.");
						    						$("#manufactureList").dialog('close');
						    						selectBidList();
					    				      },
					    				      error: function (jqXHR) {
					    				    	  $.messager.alert("알림", type_nm+"에러！");
					    				      }
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
	<!-- 제조업체Dialog start -->
	<div id="manufactureList" class="easyui-dialog" title="견적 보고서" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:900px;height:800px;padding:10px">
    	
    	
    	<table cellpadding="5" style="width: 100%;">
            <tr>
                <td colspan="4" style="text-align:center;font-size:20px;text-decoration: underline; height: 20px;">견적 보고서</td>
            </tr>
            <tr>
                <td class="bc">공고번호/공고명</td>
                <td colspan="3"><font id="tab_bid_notice_no"></font> / <font id="tab_bid_notice_nm"></font></td>
            </tr>
            <tr>
                <td class="bc">공고기관</td>
                <td colspan="3"><font id="tab_bid_demand_nm"></font></td>
            </tr>
            <tr>
                <td class="bc" style="width:20%">게시일시 /개찰일시</td>
                <td style="width:30%"><font id="tab_noti_dt"></font> / <font id="tab_bid_open_dt"></font></td>
                <td class="bc" style="width:20%">국제입찰/기업구분</td>
                <td style="width:30%"><font id="tab_nation_bid_yn"></font> / <font id="tab_column3"></font></td>
            </tr>
            <tr>
                <td class="bc">입찰기간</td>
                <td><font id="tab_bid_start_dt"></font>~<font id="tab_bid_end_dt"></font></td>
                <td class="bc">조달사이트</td>
                <td>
                	<input id="bid_site" name="bid_site"
						class="easyui-combobox"
						data-options="
						method:'get',
						width:150,
            			panelHeight:'auto',
				        valueField: 'cd',
				        textField: 'cd_nm',
				        data:jsonData7" />
                </td>
            </tr>
            <tr>
                <td class="bc">계약방법</td>
                <td><font id="tab_bid_cont_demand"></font></td>
                <td class="bc">리스크</td>
                <td>
                	<input id="bid_risk" name="bid_risk"
						class="easyui-combobox"
						data-options="
						method:'get',
						width:150,
            			panelHeight:'auto',
				        valueField: 'cd',
				        textField: 'cd_nm',
				        data:jsonData6" />
                </td>
            </tr>
            <tr>
                <td class="bc">적격정보</td>
                <td><font id="tab_column2"></font></td>
                <td class="bc">과업기간</td>
                <td>
	                <input class="easyui-textbox" data-options="width:150" id="bid_term" />
                </td>
            </tr>
            <tr>
                <td class="bc">추정가격/기초금액</td>
                <td><font id="tab_pre_price"></font> / <font id="tab_base_price"></font></td>
                <td class="bc">투찰기준금액(낙찰하한율)</td>
                <td><font id="tab_column1"></font>(<font id="tab_column5"></font> %)</td>
            </tr>
            <tr>
                <td class="bc">과업내용</td>
                <td colspan="3">
                	<input class="easyui-textbox" data-options="multiline:true" id="bid_cont"  style="width:90%;height:80px">
                </td>
            </tr>
            <tr>
                <td class="bc">특이사항</td>
                <td colspan="3">
                	<input class="easyui-textbox" data-options="multiline:true" id="bid_sp_cont"  style="width:90%;height:80px">
                </td>
            </tr>
            <tr>
                <td class="bc">심사총평</td>
                <td colspan="3">
                	<input class="easyui-textbox" data-options="multiline:true" id="bid_tot_cont"  style="width:90%;height:80px">
                </td>
            </tr>
            <tr>
                <td class="bc">의견서 첨부파일</td>
                <td colspan="3">
                
<form id="uploadForm" enctype="multipart/form-data">
                	<input id="file_id" class="easyui-filebox" name="file" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
				 	<a id="file_link" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
				 	<a id="file_remove" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
</form>
                </td>
            </tr>
            <tr>
                <td class="bc">첨부문서(공고문)</td>
                <td colspan="3">
                	<div id="div_notice_spec_form1"><a href="" id="tab_notice_spec_form1"></a></div>
                	<div id="div_notice_spec_form2"><br/><a href="" id="tab_notice_spec_form2"></a></div>
                	<div id="div_notice_spec_form3"><br/><a href="" id="tab_notice_spec_form3"></a></div>
                	<div id="div_notice_spec_form4"><br/><a href="" id="tab_notice_spec_form4"></a></div>
                	<div id="div_notice_spec_form5"><br/><a href="" id="tab_notice_spec_form5"></a></div>
                	<div id="div_notice_spec_form6"><br/><a href="" id="tab_notice_spec_form6"></a></div>
                	<div id="div_notice_spec_form7"><br/><a href="" id="tab_notice_spec_form7"></a></div>
                	<div id="div_notice_spec_form8"><br/><a href="" id="tab_notice_spec_form8"></a></div>
                	<div id="div_notice_spec_form9"><br/><a href="" id="tab_notice_spec_form9"></a></div>
                	<div id="div_notice_spec_form10"><br/><a href="" id="tab_notice_spec_form10"></a></div>
                </td>
            </tr>
            <tr>
                <td class="bc">견적진행 및 승인</td>
                <td colspan="3">
                	<table id="bc3_1" class="easyui-datagrid"
						data-options="singleSelect:false,pagination:false,nowrap:false" style="width:80%;">
						<thead>
							<tr>
								<th data-options="field:'company_nm',halign:'center'" width="20%">제조사</th>
								<th data-options="field:'margin',align:'right',halign:'center'" formatter="numberComma" width="20%">견적금액</th>
								<th data-options="field:'bigo',halign:'center'" width="30%">검토의견</th>
								<th data-options="field:'choice_reason',halign:'center'" width="30%">지급조건</th>
							</tr>
						</thead>
					</table>
                </td>
            </tr>
        </table>
        <table cellpadding="5" style="width: 100%;">
            <tr>
                <td class="bc">담당자 의견</td>
                <td class="bc">팀장 의견</td>
                <td class="bc">총괄책임자 의견</td>
            </tr>
            <tr>
                <td style="text-align: cetner;"> <input class="easyui-textbox" data-options="multiline:true" id="apply_comment1" value="" style="width:270px;height:100px"></td>
                <td style="text-align: cetner;"> <input class="easyui-textbox" data-options="multiline:true" id="apply_comment2" value="" style="width:270px;height:100px"></td>
                <td style="text-align: cetner;"> <input class="easyui-textbox" data-options="multiline:true" id="apply_comment3" value="" style="width:270px;height:100px"></td>
            </tr>
        </table>
        <table cellpadding="5" style="width: 100%;">
			<tr>
				<td class="bc" style="width: 15%">항목</td>
				<td class="bc" style="width: 60%">내용</td>
				<td class="bc" style="width: 10%">확인</td>
				<td class="bc" style="width: 15%">비고</td>
			</tr>
			<tr>
				<td class="bc" rowspan="7">규격<br/>관련</td>
				<td class="cont">○ 수요처 담당자와 규격을 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info1_1" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info1_1d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 규격을 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info1_2" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info1_2d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 품질보증 관련 인증보유 및 시험성적 여부확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info1_3" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info1_3d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 특정 규격 및 특정 제조사 여부에 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info1_4" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info1_4d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 납품될 제품의 정품여부에 대하여 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info1_5" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info1_5d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ <input class="easyui-textbox" id="info1_6t" style="width:95%;"></td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info1_6" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info1_6d" >
				</td>
			</tr>
			<tr>
				<td class="cont" colspan="3">의견 : <input class="easyui-textbox" id="info1_7" style="width:93%;"> </td>
			</tr>
			<tr>
				<td class="bc" rowspan="6">납품<br/>관련</td>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 납기의 적절성 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info2_1" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info2_1d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 납품장소의 적절성 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info2_2" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info2_2d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사분석 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info2_3" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info2_3d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 운송비용, 설치비용의 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info2_4" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info2_4d" >
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ <input class="easyui-textbox" id="info2_5t" style="width:95%;"></td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="info2_5" data-options="panelHeight:'auto'" style="width:100px;">
						        <option value="">선택</option>
						        <option value="Y">Y</option>
						        <option value="N">N</option>
						        <option value="C">해당사항없음</option>
					</select>
				</td>
				<td class="cont">
					<input class="easyui-textbox" id="info2_5d" >
				</td>
			</tr>
			<tr>
				<td class="cont" colspan="3">의견 : <input class="easyui-textbox" id="info2_6" style="width:93%;"></td>
			</tr>
			<tr>
				<td class="bc">기타리스크 : </td>
				<td class="cont" colspan="3" style="min-height: 50px;">
					<input class="easyui-textbox" data-options="multiline:true" id="info3"  style="width:98%;height:50px">
				</td>
			</tr>
        </table>
         <table cellpadding="5" style="width: 100%;">
            <tr>
                 <td width="100%" colspan="3" style="text-align: right;">
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" id="applyBtn" onclick="save(3)" >승인</a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" id="cancelBtn" onclick="save(2)" >반려</a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" id="saveBtn" onclick="save(1)" >저장</a>
	            </td>
            </tr>
        </table>
    </div>
    <!-- 제조업체 Dialog end -->
</body>
</html>