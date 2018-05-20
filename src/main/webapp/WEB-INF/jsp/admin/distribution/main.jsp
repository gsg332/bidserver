<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>입찰관리</title>
<%@ include file="/include/session.jsp" %>
<style>  
.mytable { border-collapse:collapse; margin-top:25px; width: 100%; padding: 10px;}  
.mytable th, .mytable td { border:1px solid black; }
.mytable2 { border-collapse:collapse; margin-top:25px; width: 100%; padding: 10px;}  
.mytable2 th, .mytable2 td { border:1px solid black; }
.mytable3 { border-collapse:collapse; margin-top:25px; width: 100%; padding: 10px;}  
.mytable3 th, .mytable3 td { border:1px solid black; }
.mytable4 { border-collapse:collapse; margin-top:25px; width: 100%; padding: 10px;}  
.mytable4 th, .mytable4 td { border:1px solid black; }
</style>
<script>
var jsonData=null;
var jsonData2=null;
var jsonData3=null;
var jsonData4=null;
var jsonData5=null;
var jsonData6=null;
var jsonData7=null;
var jsonData8=null;
var jsonData9=null;
//담당자 콤보 선택
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/distribution/userList.do'/>"
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
   ,url: "<c:url value='/distribution/userList.do'/>"
   ,async: false 
   ,data : {
		searchType :'A'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData2=json;
   }
});
//조달사이트 콤보
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/distribution/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd : 'bid_site_cd'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData3=json;
   }
});
//적격정보 콤보
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/distribution/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd : 'business_license_cd'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData4=json;
   }
});
//기업규모 콤보
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/distribution/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd : 'business_scale_cd'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData5=json;
   }
});
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/distribution/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd :'main_area_cd'
	}
   ,dataType: "json"
   ,success:function(json){
	   jsonData6=json;
   }
});
//지역 콤보
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/distribution/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd : 'main_area_cd'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData7=json;
   }
});
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/enterprise/comboEvalList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		eval_type : '신용평가',
		eval_group : '신용평가'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData8=json;
   }
});
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/enterprise/comboEvalList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		eval_type : '기업규모',
		eval_group : '신용평가'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData9=json;
   }
});
$(function() { 
	$("input:checkbox[name='choice_yn']").bind('click',function() { 
			$('input[type="checkbox"]').not(this).prop("checked", false);
	});
	$("input:checkbox[name='choice_yn2']").bind('click',function() { 
		$('input[type="checkbox"]').not(this).prop("checked", false);
	});
});
$(document).ready(function() {
	<%
		String userid = (String)session.getAttribute("loginid");
		if(userid != null){
			if(Integer.parseInt((String)session.getAttribute("auth"))==1){ 
	%>
				/* $('.tabs-title').filter(":eq(0)").parents('li').hide();
				$('.tabs-title').filter(":eq(1)").parents('li').trigger("click");	 */	
				$("#userId").combobox('setValue', '<%=userid%>');
				//$("#userId").combobox("disable");
				$("#userId2").combobox('setValue', '<%=userid%>');
				//$("#userId2").combobox("disable");
				$("#userId3").combobox('setValue', '<%=userid%>');
				//$("#userId3").combobox("disable");
	<%
			}
		} 
	%>
	$(".mytable").hide();
	$("#mytableBtn").hide();
	$(".mytable2").hide();
	$("#mytableBtn2").hide();
	$("#pickBtn").hide();
	$(".mytable3").hide();
	$("#moveBtn").hide();
	
	$(".mytable4").hide();
	$("#mytable5").hide();
	$("#mytable6").hide();
	$("#mytableBtn4").hide();
	$("#mytableBtn5").hide();
	
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
							selectList();
							break;
						case 1:
							selectList2();
							break;
						case 2:
							selectView('');
							break;
						case 3:
							selectList3();
							break;
						case 4:
							selectView2('');
							break;
						case 5:
							selectList4();
							break;
						case 6:
							selectView3('');
							break;
						case 7:
							selectList5();
							break;
						case 8:
							selectView6('');
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
	selectList();
	selectList2();
	selectList3();
	selectList4();
	selectList5();
}

//tab1 조회
function selectList(){
	$("#dg").datagrid({
		method : "GET",
		url : "<c:url value='/distribution/selectList.do'/>",
		queryParams : {
			disDt : $('#disDt').datebox('getValue'),
			bidNoticeNo : $('#bid_notice_no').val().replace( /(\s*)/g, "")
		},
		onLoadSuccess:function(data){
			userCnt(data.cnt);
		}
	});
}
function userCnt(data){
	var html = "";
	var sum = 0;
	html += "<span style='display:inline-block;' >";
	html += "<table>";
	html += "<tr>";
			for(var i=0; i < data.length; i++){
				if(typeof(data[i].user_nm) != "undefined"){			
					html += "<td>"+data[i].user_nm+" :</td>";
					html += "<td>"+data[i].user_cnt+"</td>";
					sum += data[i].user_cnt;
				}
			}
			html += "<td>전체 : </td><td>"+sum+"</td>";
	html += "</tr>";
	html += "</table>";
	html += "</span>";
	
	$("#userCnt").html(html);
}
//tab2 조회
function selectList2(){
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
	$("#dg2").datagrid({
		method : "GET",
		url : "<c:url value='/distribution/selectList.do'/>",
		queryParams : {
			disSDt : $('#disSDt').datebox('getValue'),
			disEDt : $('#disEDt').datebox('getValue'),
			bidNoticeNo : $('#searchBidType').combobox('getValue')=="1"?$('#bidNoticeNo').val().replace( /(\s*)/g, ""):"",
			bidNoticeNm : $('#searchBidType').combobox('getValue')=="2"?$('#bidNoticeNo').val().replace( /(\s*)/g, ""):"",
			opinion : $('#searchBidType').combobox('getValue')=="3"?$('#bidNoticeNo').val().replace( /(\s*)/g, ""):"",
			userId : userId,
			status_step : $("#status_step_combo3").combobox('getValue'),
			status_step_list :'selectList2'
		},
		onDblClickRow : function(index, row){
			onDblClickCell2(row);
		},
		onLoadSuccess:function(data){
			$('#dg2').datagrid('selectRow', 0);
			eventBtn();
		}

	});
}
function eventBtn(){
	$('#dg2').datagrid('getPanel').find("[type='bigo_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var param = $(this).attr('val').split("&&");
				var bid_notice_no = param[0];
				var bid_notice_cha_no = param[1];
				$("#bigo_notice_no").val(bid_notice_no);
				$("#bigo_notice_cha_no").val(bid_notice_cha_no);
				var colorType = $(this).attr('colorType');
				getBigoList(colorType);
			}
		})
	});
}
function getBigoList(colorType){
	 $.ajax({ 
	    type: "POST"
	   ,url: "<c:url value='/distribution/getBigoDtl.do'/>"
	   ,async: false 
	   ,data : {
		   bid_notice_no : $("#bigo_notice_no").val(),
		   bid_notice_cha_no : $("#bigo_notice_cha_no").val(),
		}
	   ,dataType: "json"
	   ,success:function(json){
		   $("#bigo_column4").textbox('setValue', '');
		   $("#bigo_bigo").textbox('setValue', '');	
		   
		   if(json.rows.length>0){
			   if(typeof(json.rows[0].column4)!="undefined"){
				   $("#bigo_column4").textbox('setValue', json.rows[0].column4);
			   }
			   if(typeof(json.rows[0].bigo)!="undefined"){
				   $("#bigo_bigo").textbox('setValue', json.rows[0].bigo);
			   }	   
		   }
			if(json.rows2.length>0){
				if(json.rows2[0]){
					if(json.rows2[0].status_step == "2"){
					   $.messager.alert("알림", "해당 공고는 승인진행중 입니다.");
						return;
				   }else if(json.rows2[0].status_step == "3"){
					   $.messager.alert("알림", "해당 공고는 승인완료 입니다.");
						return;
				   }else{
					   $("#bigo_apply").combobox('setValue', json.rows2[0].status_step);
				   }   
			   	}else{
			   		$("#bigo_apply").combobox('setValue', '미진행');
			   	}
		   }else{
			   $("#bigo_apply").combobox('setValue', '미진행');
		   }
		   
		   
		   console.log('colorType', colorType);
		   
		   if(colorType && colorType != 'undefined'){
			   $("#color_type").combobox('setValue', colorType);
		   }else{
			   $("#color_type").combobox('setValue', '선택');
		   }
		   
		   $('#bigoInsertDlg').dialog('open');
	   }
	});
}
//tab4 조회
function selectList3(){
	var userId = "";
	<%
		if(userid != null){
			if(Integer.parseInt((String)session.getAttribute("auth"))==1){ %>
				<%-- userId = "<%=(String)session.getAttribute("loginid")%>"; --%>
				userId = $('#userId2').combogrid('getValue');
	<%		}else{ %>
				userId = $('#userId2').combogrid('getValue');
	<%
			} 
		}
	%>
	$("#dg3").datagrid({
		method : "GET",
		url : "<c:url value='/distribution/selectList2.do'/>",
		queryParams : {
			disSDt : $('#tenderSDt').datebox('getValue'),
			disEDt : $('#tenderEDt').datebox('getValue'),
			bidNoticeNo : $('#searchBidType2').combobox('getValue')=="1"?$('#bidNoticeNo2').val().replace( /(\s*)/g, ""):"",
			bidNoticeNm : $('#searchBidType2').combobox('getValue')=="2"?$('#bidNoticeNo2').val().replace( /(\s*)/g, ""):"",
			opinion : $('#searchBidType2').combobox('getValue')=="3"?$('#bidNoticeNo2').val().replace( /(\s*)/g, ""):"",
			userId : userId,
			status_step : $("#status_step_combo").combobox('getValue'),
			status_step_list :'selectList3'
		},
		onDblClickRow : function(index, row){
			onDblClickCell3(row);
		}
	});
}
//tab5 조회
function selectList4(){
	var userId = "";
	<%
		if(userid != null){
			if(Integer.parseInt((String)session.getAttribute("auth"))==1){ %>
				<%-- userId = "<%=(String)session.getAttribute("loginid")%>"; --%>
				userId = $('#userId3').combogrid('getValue');
	<%		}else{ %>
				userId = $('#userId3').combogrid('getValue');
	<%
			} 
		}
	%>
	$("#dg4").datagrid({
		method : "GET",
		url : "<c:url value='/distribution/selectList2.do'/>",
		queryParams : {
			disSDt : $('#tenderSDt2').datebox('getValue'),
			disEDt : $('#tenderEDt2').datebox('getValue'),
			bidNoticeNo : $('#searchBidType3').combobox('getValue')=="1"?$('#bidNoticeNo3').val().replace( /(\s*)/g, ""):"",
			bidNoticeNm : $('#searchBidType3').combobox('getValue')=="2"?$('#bidNoticeNo3').val().replace( /(\s*)/g, ""):"",
			opinion : $('#searchBidType3').combobox('getValue')=="3"?$('#bidNoticeNo3').val().replace( /(\s*)/g, ""):"",
			userId : userId,
			status_step2 : $("#status_step_combo2").combobox('getValue'),
			status_step_list :'selectList4'
		},
		onDblClickRow : function(index, row){
			onDblClickCell4(row);
		}
	});
}
function selectList5(){
	var userId = "";
	<%
		if(userid != null){
			if(Integer.parseInt((String)session.getAttribute("auth"))==1){ %>
				<%-- userId = "<%=(String)session.getAttribute("loginid")%>"; --%>
				userId = $('#userId5').combogrid('getValue');
	<%		}else{ %>
				userId = $('#userId5').combogrid('getValue');
	<%
			} 
		}
	%>
	$("#dg5").datagrid({
		method : "GET",
		url : "<c:url value='/distribution/selectList.do'/>",
		queryParams : {
			disSDt : $('#bidStartDt5').datebox('getValue'),
			disEDt : $('#bidEndDt5').datebox('getValue'),
			bidNoticeNo : $('#searchBidType5').combobox('getValue')=="1"?$('#bidNoticeNo5').val():"",
			bidNoticeNm : $('#searchBidType5').combobox('getValue')=="2"?$('#bidNoticeNo5').val():"",
			userId : userId,
			status_step_list :'selectList5'
		},
		onDblClickRow : function(index, row){
			onDblClickCell5(row);
		}
	});
}
function getBidInfoApi(){
	var startDt = $('#startDt').datebox('getValue').replaceAll("-","");
	if(startDt.length==0){
		$.messager.alert("알림", "공고일을 입력하세요.");
		return;
	}
	
	$.messager.confirm('알림', "해당일의 공고를 갱신하시겠습니까?", function(r){
        if (r){
			var effectRow = new Object();
			var win = $.messager.progress({
		            title:'공고 갱신',
		            msg:'데이터 처리중입니다.<br/>잠시만 기다려주세요...'
		        });
			
			effectRow["startDt"] = startDt
			
			$.post("<c:url value='/distribution/getBidInfoApi.do'/>", effectRow, function(rsp) {
				if(rsp.status){
					$('#bidInfoDlg').dialog('close');
					 $.messager.progress('close');
					 $.messager.alert("알림", "갱신되었습니다.");
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "API에러！");
			});
        }
	});
}

function save(){
	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
        if (r){
        	if (endEditing()){
    			var $dg = $("#dg");

    			if ($dg.datagrid('getChanges').length) {
    				var updated = $dg.datagrid('getChanges', "updated");
    				
    				var effectRow = new Object();
    				if (updated.length) {
    					effectRow["updated"] = JSON.stringify(updated);
    				}
    				$.post("<c:url value='/distribution/updateDistributionList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						$.messager.alert("알림", "저장하였습니다.");
    						$dg.datagrid('acceptChanges');
    						setGrid();
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "저장에러！");
    				});
    			 }
    		}
        }
	});
}
function save2(){
	if($("#bid_notice_no").val().trim() == ""){
		$.messager.alert("알림", "공고번호를 입력해주세요.");
	}else{
		$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	        if (r){			
	        	var effectRow = new Object();
	 			effectRow["bid_notice_no"] = $("#bid_notice_no").val().replace( /(\s*)/g, "");		
				$.post("<c:url value='/distribution/insertDistributionList.do'/>", effectRow, function(rsp) {
					if(rsp.status=="200"){
						$.messager.alert("알림", "저장하였습니다.");
						$("#bid_notice_no").textbox("setValue","");
						$("#dg").datagrid('reload');
						$('#disDlg').dialog('close');
					}else if(rsp.status=="201"){
						$.messager.alert("알림", "이미 데이터가 존재합니다.");
						$("#dg").datagrid('reload');
						$('#disDlg').dialog('close');
					}else if(rsp.status=="202"){
						$.messager.alert("알림", "데이터가 존재하지 않습니다.");
						$("#dg").datagrid('reload');
						$('#disDlg').dialog('close');
					}
				}, "JSON").error(function() {
					$.messager.alert("알림", "저장에러！");
				});
	        }
		});
	}
}
function selectView(bid_notice_no){
	var bidNoticeNo = "";
	if(bid_notice_no == ""){
		if($("#tab3_bidNoticeNo").val().trim() == ""){
			$.messager.alert("알림", "공고번호를 입력해주세요.");
			return;
		}else{
			bidNoticeNo = $("#tab3_bidNoticeNo").val();
		}
	}else{
		bidNoticeNo = bid_notice_no;
	}
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/getDistributionDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no : bidNoticeNo,
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.status=="202"){
				   $.messager.alert("알림", "데이터가 존재하지 않습니다.");
			   }else if(json.status=="203"){
				   $.messager.alert("알림", "공고담당자를 지정하여 주세요.");				   	
			   }else{
				   $(".mytable").show(); 				   
				   setBizInfoInit();				   
				   $("#noti_dt").val(json.rows[0].noti_dt);
				   $("#notice_no").val(json.rows[0].bid_notice_no);
				   $("#notice_cha_no").val(json.rows[0].bid_notice_cha_no);
				   $("#tab3_bidNoticeNo").textbox('setValue',json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   
				   if(json.rows[0].manual_yn=="Y"){
					   $("#tab3_bid_notice_no").text(json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   }else{
					   $("#tab3_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+json.rows[0].notice_detail_link+"')\">"+json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no+"</a>");
				   }
				   
				   var color = "";
					if(json.rows[0].notice_type=="긴급"){
						color ="red";
					}else if(json.rows[0].notice_type=="변경"){
						color ="blue";
					}else if(json.rows[0].notice_type=="취소"){
						color ="green";
					}else{
						color ="black";
					}
				   $("#tab3_notice_type").combobox('setValue', json.rows[0].notice_type);
				   $("#tab3_bid_notice_nm").textbox('setValue',json.rows[0].bid_notice_nm);
				   $("#tab3_order_agency_nm").textbox('setValue',json.rows[0].order_agency_nm);
				   $("#tab3_demand_nm").textbox('setValue', json.rows[0].demand_nm);
				   $("#tab3_contract_type_nm").textbox('setValue', json.rows[0].contract_type_nm);				  
				   $("#tab3_pre_price").textbox('setValue', numberComma(json.rows[0].pre_price));				   				   
				   $("#tab3_base_price").textbox('setValue', numberComma(json.rows[0].base_price));
				   $('#s_range').textbox('setValue',json.rows[0].s_range);
				    $('#e_range').textbox('setValue',json.rows[0].e_range);
 				   if(typeof(json.rows[0].product_yn)=="undefined"){
 					  $("#tab3_product_yn").combobox('setValue', "N");
				   }else{
					   $("#tab3_product_yn").combobox('setValue', json.rows[0].product_yn);
				   }
		   			
 				  $("#tab3_bigo").textbox('setValue', json.rows[0].bigo);
 				  
				   $("#tab3_notice_spec_file").append(bid_info_detail(json.rows[0])[0]);
				   if(typeof(json.rows[0].bid_start_dt)!="undefined"){
					   $("#tab3_bid_start_dt_y").datebox('setValue', formatDate(json.rows[0].bid_start_dt.substring(0,8)));
					   $("#tab3_bid_start_dt_h").textbox('setValue', json.rows[0].bid_start_dt.substring(8,10));		
					   $("#tab3_bid_start_dt_m").textbox('setValue', json.rows[0].bid_start_dt.substring(10,12));
				   }
				   if(typeof(json.rows[0].bid_end_dt)!="undefined"){
					   $("#tab3_bid_end_dt_y").datebox('setValue', formatDate(json.rows[0].bid_end_dt.substring(0,8)));
					   $("#tab3_bid_end_dt_h").textbox('setValue', json.rows[0].bid_end_dt.substring(8,10));		
					   $("#tab3_bid_end_dt_m").textbox('setValue', json.rows[0].bid_end_dt.substring(10,12));
				   }			   
				   $("#tab3_bidmanager").textbox('setValue', json.rows[0].reg_user_nm);  
				   $("#tab3_bidmanager_t").textbox('setValue', json.rows[0].reg_user_tel);
				   $("#tab3_bidmanager_e").textbox('setValue', json.rows[0].reg_user_mail);
				   
				   if(typeof(json.rows[0].bid_open_dt)!="undefined"){
					   $("#tab3_bid_open_dt_y").datebox('setValue', formatDate(json.rows[0].bid_open_dt.substring(0,8)));
					   $("#tab3_bid_open_dt_h").textbox('setValue', json.rows[0].bid_open_dt.substring(8,10));		
					   $("#tab3_bid_open_dt_m").textbox('setValue', json.rows[0].bid_open_dt.substring(10,12));
				   }
				   $("#tab3_use_area_info").textbox('setValue', bid_info_detail(json.rows[0])[4]);
				   $("#tab3_stad_no").textbox('setValue', json.rows[0].detail_goods_no);
				   $("#tab3_stad_nm").textbox('setValue', json.rows[0].detail_goods_nm);
				   if(typeof(json.rows[0].permit_biz_type_info)!="undefined"){
					   if(bidLicense(json.rows[0].permit_biz_type_info,'') == ""){
						   	$("#tab3_permit_biz_type_info").textbox('setValue', "");   
					   }else{
					   		$("#tab3_permit_biz_type_info").textbox('setValue', bidLicense(json.rows[0].permit_biz_type_info,''));
					   }
				   }
				   if(typeof(json.rows[0].goods_grp_limit_yn)=="undefined"){
 					  $("#tab3_goods_grp_limit_yn").combobox('setValue', "N");
				   }else{
					   $("#tab3_goods_grp_limit_yn").combobox('setValue', json.rows[0].goods_grp_limit_yn);
				   }
				   if(typeof(json.rows[0].bid_lic_reg_dt)!="undefined"){
					   $("#tab3_bid_lic_reg_dt_y").datebox('setValue', formatDate(json.rows[0].bid_lic_reg_dt.substring(0,8)));
					   $("#tab3_bid_lic_reg_dt_h").textbox('setValue', json.rows[0].bid_lic_reg_dt.substring(8,10));		
					   $("#tab3_bid_lic_reg_dt_m").textbox('setValue', json.rows[0].bid_lic_reg_dt.substring(10,12));
				   }
				 	//입찰사용자등록정보
					getBidDtl(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
					
					//입찰 제조사 정보
					setBizGrid(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
			   }	  	 
		   }
	});
}
//견적요청탭 입찰관련정보 초기화
function setBizInfoInit(){
	$("#notice_no").val('');
	$("#notice_cha_no").val('');
	$("#tab3_bid_notice_no").empty();
	$("#tab3_notice_spec_file").empty();
	$("#tab3_order_agency_nm").textbox('setValue','');
	$("#tab3_permit_biz_type_info").textbox('setValue','');
	$("#tab3_use_area_info").textbox('setValue','');
	$("#tab3_stad_no").textbox('setValue', '');	
	$("#tab3_stad_nm").textbox('setValue', '');	
	$("#tab3_demand_nm").textbox('setValue', '');	
	$("#tab3_contract_type_nm").textbox('setValue', '');	
	$("#tab3_bid_notice_nm").textbox('setValue', '');
	$("#tab3_bidmanager").textbox('setValue', '');
	$('#tab3_product_yn').combobox('setValue', '');
	$('#tab3_notice_type').combobox('setValue', '');
	$('#tab3_goods_grp_limit_yn').combobox('setValue', '');
	
	$('#companyB1').textbox('setValue','');
	$('#companyB2').textbox('setValue','');
	$('#companyB3').textbox('setValue','');
	$('#companyB4').textbox('setValue','');
	$('#companyB5').textbox('setValue','');
	
	$('#companyB1_bigo').textbox('setValue','');
	$('#companyB2_bigo').textbox('setValue','');
	$('#companyB3_bigo').textbox('setValue','');
	$('#companyB4_bigo').textbox('setValue','');
	$('#companyB5_bigo').textbox('setValue','');
	
	$('#tab_bid_site').combobox('setValue', '');
    $('#tab_bid_risk').combobox('setValue', '');
    $("#tab_bid_stock_issue_yn").textbox('setValue','');
	$("#tab_bid_term").textbox('setValue','');
	$("#tab_bid_num_of_days").textbox('setValue','');
	$("#tab_bid_cont").textbox('setValue','');
	$("#tab_bid_sp_cont").textbox('setValue','');
	$("#tab_bid_tot_cont").textbox('setValue','');
	$("#tab_bid_manager_bigo").textbox('setValue', '');
	$("#column7").textbox('setValue', '');
	
	$('#risk_yn1').combobox('setValue', '');
	$('#risk_yn2').combobox('setValue', '');
	$('#risk_yn3').combobox('setValue', '');
	$('#risk_yn4').combobox('setValue', '');
	$('#risk_yn5').combobox('setValue', '');
	$('#risk_yn6').combobox('setValue', '');
	$('#risk_yn7').combobox('setValue', '');
	$('#risk_yn8').combobox('setValue', '');
	$('#risk_yn9').combobox('setValue', '');
	$('#risk_yn10').combobox('setValue', '');
	$('#risk_yn11').combobox('setValue', '');
	$('#risk_yn14').combobox('setValue', '');
	$('#risk_yn15').combobox('setValue', '');
	
	$('#risk_m_yn1').combobox('setValue', '');
	$('#risk_m_yn2').combobox('setValue', '');
	$('#risk_m_yn3').combobox('setValue', '');
	$('#risk_m_yn4').combobox('setValue', '');
	$('#risk_m_yn5').combobox('setValue', '');
	$('#risk_m_yn6').combobox('setValue', '');
	$('#risk_m_yn7').combobox('setValue', '');
	$('#risk_m_yn8').combobox('setValue', '');
	$('#risk_m_yn9').combobox('setValue', '');
	$('#risk_m_yn10').combobox('setValue', '');
	$('#risk_m_yn11').combobox('setValue', '');
	$('#risk_m_yn14').combobox('setValue', '');
	$('#risk_m_yn15').combobox('setValue', '');
    setBizGrid('','');
}

//견적요청탭 입찰관련정보 추가정보 설정
function getBidDtl(bidNoticeNo, bidNoticeChaNo){
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/getBidDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :bidNoticeNo,
			   bid_notice_cha_no :bidNoticeChaNo
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				    //$('#column1').textbox('setValue',numberComma(json.rows[0].column1));
				    $('#column2').combobox('setValue',json.rows[0].column2);
					$('#column3').combobox('setValue', json.rows[0].column3);
				    $('#column4').textbox('setValue',json.rows[0].column4);
				    $('#column5').textbox('setValue',json.rows[0].column5);
				    $('#column7').textbox('setValue',json.rows[0].column7);
				    
				    $('#s_range').textbox('setValue',json.rows[0].s_range);
				    $('#e_range').textbox('setValue',json.rows[0].e_range);
				    $('#tab_bid_manager_bigo').textbox('setValue',json.rows[0].bigo);
			   }else{
				   //$('#column1').textbox('setValue',"");
				    $('#column2').combobox('setValue',"");
				    $('#column3').combobox('setValue',"");
				    $('#column4').textbox('setValue',"");
				    $('#column5').textbox('setValue',"");
				    $('#column7').textbox('setValue',"");
				    
				    $('#s_range').textbox('setValue',"");
				    $('#e_range').textbox('setValue',"");
				    $('#tab_bid_manager_bigo').textbox('setValue',"");
			   }
			   if(json.bidSubj !=null){
				    $('#tab_bid_site').combobox('setValue', json.bidSubj.bid_site);
				    $('#tab_bid_risk').combobox('setValue', json.bidSubj.bid_risk);
				    $('#tab_bid_stock_issue_yn').textbox('setValue', json.bidSubj.bid_stock_issue_yn);
					$('#tab_bid_term').textbox('setValue', json.bidSubj.bid_term);
					$('#tab_bid_num_of_days').textbox('setValue', json.bidSubj.bid_num_of_days);
					$('#tab_bid_cont').textbox('setValue', json.bidSubj.bid_cont);
					$('#tab_bid_sp_cont').textbox('setValue', json.bidSubj.bid_sp_cont);
					$('#tab_bid_tot_cont').textbox('setValue', json.bidSubj.bid_tot_cont);
			   }else{
				    $('#tab_bid_risk').combobox('setValue', '003');
					$('#tab_bid_cont').textbox('setValue', '본 건은 ['+$('#tab3_demand_nm').textbox('getValue')+'] ['+$('#tab3_bid_notice_nm').textbox('getValue')+'] 납품건 입니다.');
					$('#tab_bid_tot_cont').textbox('setValue', '본건은 다수의 제조사 및 유통사가 공급할 있는 입찰건으로 투찰 가능하신업체는 투찰을 진행하셔도 별다른 리스크가 없는것으로 판단됩니다.');
			   }

			   if(json.bidRisk !=null){
				    $('#risk_yn1').combobox('setValue', json.bidRisk.risk_yn1);
					$('#risk_m_yn1').combobox('setValue', json.bidRisk.risk_m_yn1);
					$('#risk_yn2').combobox('setValue', json.bidRisk.risk_yn2);
					$('#risk_m_yn2').combobox('setValue', json.bidRisk.risk_m_yn2);
					$('#risk_yn3').combobox('setValue', json.bidRisk.risk_yn3);
					$('#risk_m_yn3').combobox('setValue', json.bidRisk.risk_m_yn3);
					$('#risk_yn4').combobox('setValue', json.bidRisk.risk_yn4);
					$('#risk_m_yn4').combobox('setValue', json.bidRisk.risk_m_yn4);
					$('#risk_yn5').combobox('setValue', json.bidRisk.risk_yn5);
					$('#risk_m_yn5').combobox('setValue', json.bidRisk.risk_m_yn5);
					$('#risk_yn6').combobox('setValue', json.bidRisk.risk_yn6);
					$('#risk_m_yn6').combobox('setValue', json.bidRisk.risk_m_yn6);
					$('#risk_yn7').combobox('setValue', json.bidRisk.risk_yn7);
					$('#risk_m_yn7').combobox('setValue', json.bidRisk.risk_m_yn7);
					$('#risk_yn8').combobox('setValue', json.bidRisk.risk_yn8);
					$('#risk_m_yn8').combobox('setValue', json.bidRisk.risk_m_yn8);
					$('#risk_yn9').combobox('setValue', json.bidRisk.risk_yn9);
					$('#risk_m_yn9').combobox('setValue', json.bidRisk.risk_m_yn9);
					$('#risk_yn10').combobox('setValue', json.bidRisk.risk_yn10);
					$('#risk_m_yn10').combobox('setValue', json.bidRisk.risk_m_yn10);	
					$('#risk_yn11').combobox('setValue', json.bidRisk.risk_yn11);
					$('#risk_m_yn11').combobox('setValue', json.bidRisk.risk_m_yn11);
					$('#risk_yn14').combobox('setValue', json.bidRisk.risk_yn14);
					$('#risk_m_yn14').combobox('setValue', json.bidRisk.risk_m_yn14);
					$('#risk_yn15').combobox('setValue', json.bidRisk.risk_yn15);
					$('#risk_m_yn15').combobox('setValue', json.bidRisk.risk_m_yn15);
			   }else{
				   	$('#risk_yn1').combobox('setValue', 'Y');
				   	$('#risk_yn2').combobox('setValue', 'Y');
				   	$('#risk_yn3').combobox('setValue', 'Y');
				   	$('#risk_yn4').combobox('setValue', 'Y');
				   	$('#risk_yn5').combobox('setValue', 'Y');
				   	$('#risk_yn6').combobox('setValue', 'Y');
				   	$('#risk_yn7').combobox('setValue', 'Y');
				   	$('#risk_yn8').combobox('setValue', 'Y');
				   	$('#risk_yn9').combobox('setValue', 'Y');
				   	$('#risk_yn10').combobox('setValue', 'Y');
				   	$('#risk_yn11').combobox('setValue', 'Y');
				   	$('#risk_yn14').combobox('setValue', 'Y');
				   	$('#risk_yn15').combobox('setValue', 'Y');
			   }
			   if(json.bidStatus !=null){
			   		if(json.bidStatus.status_step=="0"){
			   			$("#mytableBtn").hide();
			   			$("#callBtn").hide();
			   			$("#moveBtn").hide();
			   			$("#pickBtn").show(); 			   					   			
			   		}else if(json.bidStatus.status_step=="1"){
			   			$("#mytableBtn").hide();
			   			$("#moveBtn").show();			   			
			   			$("#callBtn").hide();
				   	}else if(json.bidStatus.status_step=="미진행"){
				   		$("#mytableBtn").show();
					   	$("#callBtn").show();
					   	$("#moveBtn").hide();
					   	$("#pickBtn").hide();
				   	}else if(json.bidStatus.status_step==null){
				   		$("#mytableBtn").show();
					   	$("#callBtn").show();
					   	$("#moveBtn").hide();
						$("#pickBtn").hide();
				   	}
			   }else{
				   $("#mytableBtn").show();
				   $("#callBtn").show();
				   $("#moveBtn").hide();
				   $("#pickBtn").hide();
			   }			   		  	 
		   }
	});
}
//견적요청탭  제조사 정보 조회
function setBizGrid(bidNoticeNo, bidNoticeChaNo){
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/bidBizRelList.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :bidNoticeNo,
			   bid_notice_cha_no :bidNoticeChaNo
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				   for(var i=0; i<json.rows.length;i++){
					   $("#companyB"+(i+1)).textbox('setValue',json.rows[i].company_nm+" / "+json.rows[i].phone_no+" / "+json.rows[i].email);
					   $("#companyB"+(i+1)+"_business_no").val(json.rows[i].business_no);
					   $("#companyB"+(i+1)+"_bigo").textbox('setValue',json.rows[i].bigo);
				   }
			   }
		   }
	});
}

function selectView2(bid_notice_no){
	var bidNoticeNo = "";
	if(bid_notice_no == ""){
		if($("#tab4_bidNoticeNo").val().trim() == ""){
			$.messager.alert("알림", "공고번호를 입력해주세요.");
			return;
		}else{
			bidNoticeNo = $("#tab4_bidNoticeNo").val();
		}
	}else{
		bidNoticeNo = bid_notice_no;
	}
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/getDistributionDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no : bidNoticeNo,
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.status=="202"){
				   $.messager.alert("알림", "데이터가 존재하지 않습니다.");
			   }else if(json.status=="203"){
				   $.messager.alert("알림", "공고담당자를 지정하여 주세요.");				   	
			   }else if(json.rows[0].status_step=="0"){
				   $.messager.alert("알림", "Drop된 공고 입니다.");	
			   }else if(typeof(json.rows[0].status_step)=="undefined"){
				   $.messager.alert("알림", "아직 검토가 완료되지 않은 공고 입니다.");	
			   }else if(json.rows[0].status_step=="2"){
				   $.messager.alert("알림", "승인이 진행중인 공고 입니다.");	
			   }else if(json.rows[0].status_step=="3" && json.rows[0].status_cd3=="001"){
				   $.messager.alert("알림", "승인이 진행중인 공고 입니다.");	
			   }else if(json.rows[0].status_step=="3" && json.rows[0].status_cd3=="002"){
				   $.messager.alert("알림", "승인이 완료된 공고 입니다.");	
			   }else{
				   $(".mytable2").show(); 				   
				   setBizInfoInit2();
				   $("#notice_no2").val(json.rows[0].bid_notice_no);
				   $("#notice_cha_no2").val(json.rows[0].bid_notice_cha_no);
				   $("#tab4_bidNoticeNo").textbox('setValue',json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   
				   if(json.rows[0].manual_yn=="Y"){
					   $("#tab4_bid_notice_no").text(json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   }else{
					   $("#tab4_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+json.rows[0].notice_detail_link+"')\">"+json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no+"</a>");
				   }
				  
				   var color = "";
					if(json.rows[0].notice_type=="긴급"){
						color ="red";
					}else if(json.rows[0].notice_type=="변경"){
						color ="blue";
					}else if(json.rows[0].notice_type=="취소"){
						color ="green";
					}else{
						color ="black";
					}
				   $("#tab4_bid_notice_nm").append("<span style='color:"+color+";font-weight:bold;'>["+json.rows[0].notice_type+"]</span>"+json.rows[0].bid_notice_nm+"");
				   $("#tab4_order_agency_nm").text(json.rows[0].order_agency_nm);
				   $("#tab4_demand_nm").text(json.rows[0].demand_nm);
				   $("#tab4_contract_type_nm").text(json.rows[0].contract_type_nm);				  
				   $("#tab4_pre_price").text(numberComma(json.rows[0].pre_price));				   			   
				   $("#tab4_base_price").textbox('setValue', numberComma(json.rows[0].base_price));
				   $('#s_range2').textbox('setValue',json.rows[0].s_range);
				    $('#e_range2').textbox('setValue',json.rows[0].e_range);
 				   if(typeof(json.rows[0].product_yn)=="undefined"){
 					  $("#tab4_product_yn").text("N");
				   }else{
					   $("#tab4_product_yn").text(json.rows[0].product_yn);
				   }
		   			
 				  $("#tab4_bigo").textbox('setValue', json.rows[0].bigo);
 				  
				   $("#tab4_notice_spec_file").append(bid_info_detail(json.rows[0])[0]);
				   $("#tab4_bid_start_dt").text(bid_info_detail(json.rows[0])[1]);				   
				   $("#tab4_bidmanager").text(bid_info_detail(json.rows[0])[2]);
				   $("#tab4_bid_open_dt").text(bid_info_detail(json.rows[0])[3]);
				   $("#tab4_use_area_info").append(bid_info_detail(json.rows[0])[4]);
				   $("#tab4_stad_no").textbox('setValue', json.rows[0].detail_goods_no);
				   $("#tab4_stad_nm").textbox('setValue', json.rows[0].detail_goods_nm);
				   if(typeof(json.rows[0].permit_biz_type_info)!="undefined"){
					   if(bidLicense(json.rows[0].permit_biz_type_info,'') == ""){
						   	$("#tab4_permit_biz_type_info").append("");   
					   }else{
					   		$("#tab4_permit_biz_type_info").append(bidLicense(json.rows[0].permit_biz_type_info,''));
					   }
				   }
				   if(typeof(json.rows[0].goods_grp_limit_yn)=="undefined"){
 					  $("#tab4_goods_grp_limit_yn").text("N");
				   }else{
					   $("#tab4_goods_grp_limit_yn").text(json.rows[0].goods_grp_limit_yn);
				   }
				   $("#tab4_bid_lic_reg_dt").text(formatDate(json.rows[0].bid_lic_reg_dt));
				 	//입찰사용자등록정보
					getBidDtl2(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
					
					onChgColumn5();
					
					//입찰 제조사 정보
					setBizGrid2(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
			   }	  	 
		   }
	});
}

//견적요청탭 입찰관련정보 초기화
function setBizInfoInit2(){
	$("#notice_no2").val('');
	$("#notice_cha_no2").val('');
	$("#tab4_bid_notice_no").empty();
	$("#tab4_bid_notice_nm").empty();
	$("#tab4_notice_spec_file").empty();
	$("#tab4_permit_biz_type_info").empty();
	$("#tab4_use_area_info").empty();
	$("#tab4_stad_no").textbox('setValue', '');	
	$("#tab4_stad_nm").textbox('setValue', '');	
	
	$('#companyB12').textbox('setValue','');
	$('#companyB22').textbox('setValue','');
	$('#companyB32').textbox('setValue','');
	$('#companyB42').textbox('setValue','');
	$('#companyB52').textbox('setValue','');
	
	$('#companyB1_quotation').textbox('setValue','');
	$('#companyB1_margin').textbox('setValue','');
	$('#companyB1_margin_per').numberbox('setValue','');
	$('#companyB1_send_yn').combobox('setValue', '');
	$('#companyB1_stock_yn').combobox('setValue', '');
	$('#companyB1_choice_reason').textbox('setValue','');
	$('#companyB1_review').textbox('setValue','');
	$('#companyB1_choice_yn').val("");
	$('#companyB1_credit_yn').combobox('setValue', '');
	
	$('#companyB2_quotation').textbox('setValue','');
	$('#companyB2_margin').textbox('setValue','');
	$('#companyB2_margin_per').numberbox('setValue','');
	$('#companyB2_send_yn').combobox('setValue', '');
	$('#companyB2_stock_yn').combobox('setValue', '');
	$('#companyB2_choice_reason').textbox('setValue','');
	$('#companyB2_review').textbox('setValue','');
	$('#companyB2_choice_yn').val("");
	$('#companyB2_credit_yn').combobox('setValue', '');
	
	$('#companyB3_quotation').textbox('setValue','');
	$('#companyB3_margin').textbox('setValue','');
	$('#companyB3_margin_per').numberbox('setValue','');
	$('#companyB3_send_yn').combobox('setValue', '');
	$('#companyB3_stock_yn').combobox('setValue', '');
	$('#companyB3_choice_reason').textbox('setValue','');
	$('#companyB3_review').textbox('setValue','');
	$('#companyB3_choice_yn').val("");
	$('#companyB3_credit_yn').combobox('setValue', '');
	
	$('#companyB4_quotation').textbox('setValue','');
	$('#companyB4_margin').textbox('setValue','');
	$('#companyB4_margin_per').numberbox('setValue','');
	$('#companyB4_send_yn').combobox('setValue', '');
	$('#companyB4_stock_yn').combobox('setValue', '');
	$('#companyB4_choice_reason').textbox('setValue','');
	$('#companyB4_review').textbox('setValue','');
	$('#companyB4_choice_yn').val("");
	$('#companyB4_credit_yn').combobox('setValue', '');
	
	$('#companyB5_quotation').textbox('setValue','');
	$('#companyB5_margin').textbox('setValue','');
	$('#companyB5_margin_per').numberbox('setValue','');
	$('#companyB5_send_yn').combobox('setValue', '');
	$('#companyB5_stock_yn').combobox('setValue', '');
	$('#companyB5_choice_reason').textbox('setValue','');
	$('#companyB5_review').textbox('setValue','');
	$('#companyB5_choice_yn').val("");
	$('#companyB5_credit_yn').combobox('setValue', '');
	
	$("#companyB1_tr").hide();
	$("#companyB2_tr").hide();
	$("#companyB3_tr").hide();
	$("#companyB4_tr").hide();
	$("#companyB5_tr").hide();
	
	$('#tab_bid_site2').combobox('setValue', '');
    $('#tab_bid_risk2').combobox('setValue', '');
	$("#tab_bid_term2").textbox('setValue','');
	$("#tab_bid_cont2").textbox('setValue','');
	$("#tab_bid_sp_cont2").textbox('setValue','');
	$("#tab_bid_tot_cont2").textbox('setValue','');
	$("#tab_bid_manager_bigo2").textbox('setValue', '');
	
	$('#risk_yn12').combobox('setValue', '');
	$('#risk_yn22').combobox('setValue', '');
	$('#risk_yn32').combobox('setValue', '');
	$('#risk_yn42').combobox('setValue', '');
	$('#risk_yn52').combobox('setValue', '');
	$('#risk_yn62').combobox('setValue', '');
	$('#risk_yn72').combobox('setValue', '');
	$('#risk_yn82').combobox('setValue', '');
	$('#risk_yn92').combobox('setValue', '');
	$('#risk_yn102').combobox('setValue', '');
	$('#risk_yn112').combobox('setValue', '');
	$('#risk_yn142').combobox('setValue', '');
	$('#risk_yn152').combobox('setValue', '');
	
	$('#risk_m_yn12').combobox('setValue', '');
	$('#risk_m_yn22').combobox('setValue', '');
	$('#risk_m_yn32').combobox('setValue', '');
	$('#risk_m_yn42').combobox('setValue', '');
	$('#risk_m_yn52').combobox('setValue', '');
	$('#risk_m_yn62').combobox('setValue', '');
	$('#risk_m_yn72').combobox('setValue', '');
	$('#risk_m_yn82').combobox('setValue', '');
	$('#risk_m_yn92').combobox('setValue', '');
	$('#risk_m_yn102').combobox('setValue', '');
	$('#risk_m_yn112').combobox('setValue', '');
	$('#risk_m_yn142').combobox('setValue', '');
	$('#risk_m_yn152').combobox('setValue', '');
    setBizGrid2('','');
}

//견적요청탭 입찰관련정보 추가정보 설정
function getBidDtl2(bidNoticeNo, bidNoticeChaNo){
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/getBidDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :bidNoticeNo,
			   bid_notice_cha_no :bidNoticeChaNo
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				    $('#column12').textbox('setValue',numberComma(json.rows[0].column1));
				    $('#column22').combobox('setValue',json.rows[0].column2);
					$('#column32').combobox('setValue', json.rows[0].column3);
				    $('#column42').textbox('setValue',json.rows[0].column4);
				    $('#column52').textbox('setValue',json.rows[0].column5);
				    $('#s_range2').textbox('setValue',json.rows[0].s_range);
				    $('#e_range2').textbox('setValue',json.rows[0].e_range);
				    $('#tab_bid_manager_bigo2').textbox('setValue',json.rows[0].bigo);
			   }
			   
			   if(json.bidSubj !=null){
				    $('#tab_bid_site2').combobox('setValue', json.bidSubj.bid_site);
				    $('#tab_bid_risk2').combobox('setValue', json.bidSubj.bid_risk);
					$('#tab_bid_term2').textbox('setValue', json.bidSubj.bid_term);
					$('#tab_bid_cont2').textbox('setValue', json.bidSubj.bid_cont);
					$('#tab_bid_sp_cont2').textbox('setValue', json.bidSubj.bid_sp_cont);
					$('#tab_bid_tot_cont2').textbox('setValue', json.bidSubj.bid_tot_cont);
					
			   }

			   if(json.bidRisk !=null){
				    $('#risk_yn12').combobox('setValue', json.bidRisk.risk_yn1);
					$('#risk_m_yn12').combobox('setValue', json.bidRisk.risk_m_yn1);
					$('#risk_yn22').combobox('setValue', json.bidRisk.risk_yn2);
					$('#risk_m_yn22').combobox('setValue', json.bidRisk.risk_m_yn2);
					$('#risk_yn32').combobox('setValue', json.bidRisk.risk_yn3);
					$('#risk_m_yn32').combobox('setValue', json.bidRisk.risk_m_yn3);
					$('#risk_yn42').combobox('setValue', json.bidRisk.risk_yn4);
					$('#risk_m_yn42').combobox('setValue', json.bidRisk.risk_m_yn4);
					$('#risk_yn52').combobox('setValue', json.bidRisk.risk_yn5);
					$('#risk_m_yn52').combobox('setValue', json.bidRisk.risk_m_yn5);
					$('#risk_yn62').combobox('setValue', json.bidRisk.risk_yn6);
					$('#risk_m_yn62').combobox('setValue', json.bidRisk.risk_m_yn6);
					$('#risk_yn72').combobox('setValue', json.bidRisk.risk_yn7);
					$('#risk_m_yn72').combobox('setValue', json.bidRisk.risk_m_yn7);
					$('#risk_yn82').combobox('setValue', json.bidRisk.risk_yn8);
					$('#risk_m_yn82').combobox('setValue', json.bidRisk.risk_m_yn8);
					$('#risk_yn92').combobox('setValue', json.bidRisk.risk_yn9);
					$('#risk_m_yn92').combobox('setValue', json.bidRisk.risk_m_yn9);
					$('#risk_yn102').combobox('setValue', json.bidRisk.risk_yn10);
					$('#risk_m_yn102').combobox('setValue', json.bidRisk.risk_m_yn10);		
					$('#risk_yn112').combobox('setValue', json.bidRisk.risk_yn11);
					$('#risk_m_yn112').combobox('setValue', json.bidRisk.risk_m_yn11);
					$('#risk_yn142').combobox('setValue', json.bidRisk.risk_yn14);
					$('#risk_m_yn142').combobox('setValue', json.bidRisk.risk_m_yn14);		
					$('#risk_yn152').combobox('setValue', json.bidRisk.risk_yn15);
					$('#risk_m_yn152').combobox('setValue', json.bidRisk.risk_m_yn15);
			   }
			   if(json.bidStatus !=null){
			   		if(json.bidStatus.status_step=="1"){
			   			$("#mytableBtn2").show();
				   	}else{
				   		$("#mytableBtn2").hide();
				   	}
			   }
		   }
	});
}

//견적요청탭  제조사 정보 조회
function setBizGrid2(bidNoticeNo, bidNoticeChaNo){
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/bidBizRelList.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :bidNoticeNo,
			   bid_notice_cha_no :bidNoticeChaNo
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				   for(var i=0; i<json.rows.length;i++){
					   $("#companyB"+(i+1)+"_tr").show();
					   $("#companyB"+(i+1)+"2").textbox('setValue',json.rows[i].company_nm);
					   $("#companyB"+(i+1)+"_business_no2").val(json.rows[i].business_no);
					   $("#companyB"+(i+1)+"_quotation").textbox('setValue',numberComma(json.rows[i].quotation));
					   $("#companyB"+(i+1)+"_margin").textbox('setValue',numberComma(json.rows[i].margin));
					   if(typeof(json.rows[i].send_yn)=="undefined"){
						   $("#companyB"+(i+1)+"_send_yn").combobox('setValue','N');
					   }else{
					   		$("#companyB"+(i+1)+"_send_yn").combobox('setValue',json.rows[i].send_yn);
					   }
					   if(typeof(json.rows[i].stock_yn)=="undefined"){
						   $("#companyB"+(i+1)+"_stock_yn").combobox('setValue','Y');
					   }else{
						   $("#companyB"+(i+1)+"_stock_yn").combobox('setValue',json.rows[i].stock_yn);
					   }
					   if(typeof(json.rows[i].credit_yn)=="undefined"){
						   $("#companyB"+(i+1)+"_credit_yn").combobox('setValue','Y');
					   }else{
						   $("#companyB"+(i+1)+"_credit_yn").combobox('setValue',json.rows[i].credit_yn);
					   }	
					   $("#companyB"+(i+1)+"_choice_reason").textbox('setValue',json.rows[i].choice_reason);
					   $("#companyB"+(i+1)+"_review").textbox('setValue',json.rows[i].review);
					   $("#companyB"+(i+1)+"_choice_yn").val(json.rows[i].choice_yn);
				   }
			   }
		   }
	});
}

function selectView3(bid_notice_no){
	var bidNoticeNo = "";
	if(bid_notice_no == ""){
		if($("#tab5_bidNoticeNo").val().trim() == ""){
			$.messager.alert("알림", "공고번호를 입력해주세요.");
			return;
		}else{
			bidNoticeNo = $("#tab5_bidNoticeNo").val();
		}
	}else{
		bidNoticeNo = bid_notice_no;
	}
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/getDistributionDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no : bidNoticeNo,
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.status=="202"){
				   $.messager.alert("알림", "데이터가 존재하지 않습니다.");
			   }else if(json.status=="203"){
				   $.messager.alert("알림", "공고담당자를 지정하여 주세요.");				   	
			   }else if(json.rows[0].status_step=="0"){
				   $.messager.alert("알림", "Drop된 공고 입니다.");	
			   }else if(typeof(json.rows[0].status_step)=="undefined"){
				   $.messager.alert("알림", "아직 검토가 완료되지 않은 공고 입니다.");	
			   }else{
				   $(".mytable3").show(); 	
				   $("#mytableBtn5").show();
				   setBizInfoInit3();
				   $("#notice_no3").val(json.rows[0].bid_notice_no);
				   $("#notice_cha_no3").val(json.rows[0].bid_notice_cha_no);
				   $("#tab5_user_nm").text(json.rows[0].user_nm_txt);
				   $("#tab5_bidNoticeNo").textbox('setValue',json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   if(json.rows[0].manual_yn=="Y"){
					   $("#tab5_bid_notice_no").text(json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   }else{
					   $("#tab5_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+json.rows[0].notice_detail_link+"')\">"+json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no+"</a>");
				   }
				   
				   var color = "";
					if(json.rows[0].notice_type=="긴급"){
						color ="red";
					}else if(json.rows[0].notice_type=="변경"){
						color ="blue";
					}else if(json.rows[0].notice_type=="취소"){
						color ="green";
					}else{
						color ="black";
					}
				   $("#tab5_bid_notice_nm").append("<span style='color:"+color+";font-weight:bold;'>["+json.rows[0].notice_type+"]</span>"+json.rows[0].bid_notice_nm+"");
				   $("#tab5_order_agency_nm").text(json.rows[0].order_agency_nm);
				   $("#tab5_demand_nm").text(json.rows[0].demand_nm);
				   $("#tab5_contract_type_nm").text(json.rows[0].contract_type_nm);				  
				   $("#tab5_pre_price").text(numberComma(json.rows[0].pre_price));				   			   
				   $("#tab5_base_price").textbox('setValue', numberComma(json.rows[0].base_price));
				   $('#s_range3').textbox('setValue',json.rows[0].s_range);
				    $('#e_range3').textbox('setValue',json.rows[0].e_range);
 				   if(typeof(json.rows[0].product_yn)=="undefined"){
 					  $("#tab5_product_yn").text("N");
				   }else{
					   $("#tab5_product_yn").text(numberComma(json.rows[0].product_yn));
				   }
		   			
 				  $("#tab5_bigo").textbox('setValue', json.rows[0].bigo);
 				  
				   $("#tab5_notice_spec_file").append(bid_info_detail(json.rows[0])[0]);
				   $("#tab5_bid_start_dt").text(bid_info_detail(json.rows[0])[1]);				   
				   $("#tab5_bidmanager").text(bid_info_detail(json.rows[0])[2]);
				   $("#tab5_bid_open_dt").text(bid_info_detail(json.rows[0])[3]);
				   $("#tab5_use_area_info").append(bid_info_detail(json.rows[0])[4]);
				   $("#tab5_stad_no").textbox('setValue', json.rows[0].detail_goods_no);
				   $("#tab5_stad_nm").textbox('setValue', json.rows[0].detail_goods_nm);
				   if(typeof(json.rows[0].permit_biz_type_info)!="undefined"){
					   if(bidLicense(json.rows[0].permit_biz_type_info,'') == ""){
						   	$("#tab5_permit_biz_type_info").append("");   
					   }else{
					   		$("#tab5_permit_biz_type_info").append(bidLicense(json.rows[0].permit_biz_type_info,''));
					   }
				   }
				   if(typeof(json.rows[0].goods_grp_limit_yn)=="undefined"){
 					  $("#tab5_goods_grp_limit_yn").text("N");
				   }else{
					   $("#tab5_goods_grp_limit_yn").text(json.rows[0].goods_grp_limit_yn);
				   }
				   $("#tab5_bid_lic_reg_dt").text(formatDate(json.rows[0].bid_lic_reg_dt));
				 	//입찰사용자등록정보
					getBidDtl3(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);

					onChgColumn6();
					
					//입찰 제조사 정보
					setBizGrid3(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
			   }	  	 
		   }
	});
}

//견적요청탭 입찰관련정보 초기화
function setBizInfoInit3(){
	$("#notice_no3").val('');
	$("#notice_cha_no3").val('');
	$("#tab5_bid_notice_no").empty();
	$("#tab5_bid_notice_nm").empty();
	$("#tab5_notice_spec_file").empty();
	$("#tab5_permit_biz_type_info").empty();
	$("#tab5_use_area_info").empty();
	$("#tab5_stad_no").textbox('setValue', '');	
	$("#tab5_stad_nm").textbox('setValue', '');	
	
	$('#companyB13').textbox('setValue','');
	$('#companyB23').textbox('setValue','');
	$('#companyB33').textbox('setValue','');
	$('#companyB43').textbox('setValue','');
	$('#companyB53').textbox('setValue','');
	
	$('#companyB1_quotation2').textbox('setValue','');
	$('#companyB1_margin2').textbox('setValue','');
	$('#companyB1_margin_per2').numberbox('setValue','');
	$('#companyB1_send_yn2').combobox('setValue', '');
	$('#companyB1_stock_yn2').combobox('setValue', '');
	$('#companyB1_choice_reason2').textbox('setValue','');
	$('#companyB1_review2').textbox('setValue','');
	$('#companyB1_credit_yn2').combobox('setValue', '');
	
	$('#companyB2_quotation2').textbox('setValue','');
	$('#companyB2_margin2').textbox('setValue','');
	$('#companyB2_margin_per2').numberbox('setValue','');
	$('#companyB2_send_yn2').combobox('setValue', '');
	$('#companyB2_stock_yn2').combobox('setValue', '');
	$('#companyB2_choice_reason2').textbox('setValue','');
	$('#companyB2_review2').textbox('setValue','');
	$('#companyB2_credit_yn2').combobox('setValue', '');
	
	$('#companyB3_quotation2').textbox('setValue','');
	$('#companyB3_margin2').textbox('setValue','');
	$('#companyB3_margin_per2').numberbox('setValue','');
	$('#companyB3_send_yn2').combobox('setValue', '');
	$('#companyB3_stock_yn2').combobox('setValue', '');
	$('#companyB3_choice_reason2').textbox('setValue','');
	$('#companyB3_review2').textbox('setValue','');
	$('#companyB3_credit_yn2').combobox('setValue', '');
	
	$('#companyB4_quotation2').textbox('setValue','');
	$('#companyB4_margin2').textbox('setValue','');
	$('#companyB4_margin_per2').numberbox('setValue','');
	$('#companyB4_send_yn2').combobox('setValue', '');
	$('#companyB4_stock_yn2').combobox('setValue', '');
	$('#companyB4_choice_reason2').textbox('setValue','');
	$('#companyB4_review2').textbox('setValue','');
	$('#companyB4_credit_yn2').combobox('setValue', '');
	
	$('#companyB5_quotation2').textbox('setValue','');
	$('#companyB5_margin2').textbox('setValue','');
	$('#companyB5_margin_per2').numberbox('setValue','');
	$('#companyB5_send_yn2').combobox('setValue', '');
	$('#companyB5_stock_yn2').combobox('setValue', '');
	$('#companyB5_choice_reason2').textbox('setValue','');
	$('#companyB5_review2').textbox('setValue','');
	$('#companyB5_credit_yn2').combobox('setValue', '');
	
	$("input:checkbox[id='companyB1_choice_yn2']").attr("checked", false);
	$("input:checkbox[id='companyB2_choice_yn2']").attr("checked", false);
	$("input:checkbox[id='companyB3_choice_yn2']").attr("checked", false);
	$("input:checkbox[id='companyB4_choice_yn2']").attr("checked", false);
	$("input:checkbox[id='companyB5_choice_yn2']").attr("checked", false);
	
	$("#companyB1_tr2").hide();
	$("#companyB2_tr2").hide();
	$("#companyB3_tr2").hide();
	$("#companyB4_tr2").hide();
	$("#companyB5_tr2").hide();
	
	$('#authText').empty();
	$("#auth1btn").hide();
	$("#auth2btn").hide();
	$("#auth3btn").hide();
	
	$('#tab_bid_site3').combobox('setValue', '');
    $('#tab_bid_risk3').combobox('setValue', '');
	$("#tab_bid_term3").textbox('setValue','');
	$("#tab_bid_cont3").textbox('setValue','');
	$("#tab_bid_sp_cont3").textbox('setValue','');
	$("#tab_bid_tot_cont3").textbox('setValue','');
	$("#tab_bid_manager_bigo3").textbox('setValue', '');
	
	$('#risk_yn13').combobox('setValue', '');
	$('#risk_yn23').combobox('setValue', '');
	$('#risk_yn33').combobox('setValue', '');
	$('#risk_yn43').combobox('setValue', '');
	$('#risk_yn53').combobox('setValue', '');
	$('#risk_yn63').combobox('setValue', '');
	$('#risk_yn73').combobox('setValue', '');
	$('#risk_yn83').combobox('setValue', '');
	$('#risk_yn93').combobox('setValue', '');
	$('#risk_yn103').combobox('setValue', '');
	$('#risk_yn113').combobox('setValue', '');
	$('#risk_yn143').combobox('setValue', '');
	$('#risk_yn153').combobox('setValue', '');
	
	$('#risk_m_yn13').combobox('setValue', '');
	$('#risk_m_yn23').combobox('setValue', '');
	$('#risk_m_yn33').combobox('setValue', '');
	$('#risk_m_yn43').combobox('setValue', '');
	$('#risk_m_yn53').combobox('setValue', '');
	$('#risk_m_yn63').combobox('setValue', '');
	$('#risk_m_yn73').combobox('setValue', '');
	$('#risk_m_yn83').combobox('setValue', '');
	$('#risk_m_yn93').combobox('setValue', '');
	$('#risk_m_yn103').combobox('setValue', '');
	$('#risk_m_yn113').combobox('setValue', '');
	$('#risk_m_yn143').combobox('setValue', '');
	$('#risk_m_yn153').combobox('setValue', '');
	
    setBizGrid3('','');
}

//견적요청탭 입찰관련정보 추가정보 설정
function getBidDtl3(bidNoticeNo, bidNoticeChaNo){
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/getBidDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :bidNoticeNo,
			   bid_notice_cha_no :bidNoticeChaNo
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				    $('#column13').textbox('setValue',numberComma(json.rows[0].column1));
				    $('#column23').combobox('setValue',json.rows[0].column2);
					$('#column33').combobox('setValue', json.rows[0].column3);
				    $('#column43').textbox('setValue',json.rows[0].column4);
				    $('#column53').textbox('setValue',json.rows[0].column5);
				    $('#s_range3').textbox('setValue',json.rows[0].s_range);
				    $('#e_range3').textbox('setValue',json.rows[0].e_range);
				    $('#tab_bid_manager_bigo3').textbox('setValue',json.rows[0].bigo);
			   }
			   if(json.bidSubj !=null){
				    $('#tab_bid_site3').combobox('setValue', json.bidSubj.bid_site);
				    $('#tab_bid_risk3').combobox('setValue', json.bidSubj.bid_risk);
					$('#tab_bid_term3').textbox('setValue', json.bidSubj.bid_term);
					$('#tab_bid_cont3').textbox('setValue', json.bidSubj.bid_cont);
					$('#tab_bid_sp_cont3').textbox('setValue', json.bidSubj.bid_sp_cont);
					$('#tab_bid_tot_cont3').textbox('setValue', json.bidSubj.bid_tot_cont);
					
			   }

			   if(json.bidRisk !=null){
				    $('#risk_yn13').combobox('setValue', json.bidRisk.risk_yn1);				   				
					$('#risk_yn23').combobox('setValue', json.bidRisk.risk_yn2);
					$('#risk_yn33').combobox('setValue', json.bidRisk.risk_yn3);
					$('#risk_yn43').combobox('setValue', json.bidRisk.risk_yn4);
					$('#risk_yn53').combobox('setValue', json.bidRisk.risk_yn5);
					$('#risk_yn63').combobox('setValue', json.bidRisk.risk_yn6);
					$('#risk_yn73').combobox('setValue', json.bidRisk.risk_yn7);
					$('#risk_yn83').combobox('setValue', json.bidRisk.risk_yn8);
					$('#risk_yn93').combobox('setValue', json.bidRisk.risk_yn9);
					$('#risk_yn103').combobox('setValue', json.bidRisk.risk_yn10);
					$('#risk_yn113').combobox('setValue', json.bidRisk.risk_yn11);
					$('#risk_yn143').combobox('setValue', json.bidRisk.risk_yn14);
					$('#risk_yn153').combobox('setValue', json.bidRisk.risk_yn15);
					if(typeof(json.bidRisk.risk_m_yn1)=="undefined"){
				    	$('#risk_m_yn13').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn13').combobox('setValue', json.bidRisk.risk_m_yn1);
				    }	
					if(typeof(json.bidRisk.risk_m_yn2)=="undefined"){
				    	$('#risk_m_yn23').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn23').combobox('setValue', json.bidRisk.risk_m_yn2);
				    }
					if(typeof(json.bidRisk.risk_m_yn3)=="undefined"){
				    	$('#risk_m_yn33').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn33').combobox('setValue', json.bidRisk.risk_m_yn3);
				    }
					if(typeof(json.bidRisk.risk_m_yn4)=="undefined"){
				    	$('#risk_m_yn43').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn43').combobox('setValue', json.bidRisk.risk_m_yn4);
				    }
					if(typeof(json.bidRisk.risk_m_yn5)=="undefined"){
				    	$('#risk_m_yn53').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn53').combobox('setValue', json.bidRisk.risk_m_yn5);
				    }
					if(typeof(json.bidRisk.risk_m_yn6)=="undefined"){
				    	$('#risk_m_yn63').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn63').combobox('setValue', json.bidRisk.risk_m_yn6);
				    }
					if(typeof(json.bidRisk.risk_m_yn7)=="undefined"){
				    	$('#risk_m_yn73').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn73').combobox('setValue', json.bidRisk.risk_m_yn7);
				    }
					if(typeof(json.bidRisk.risk_m_yn8)=="undefined"){
				    	$('#risk_m_yn83').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn83').combobox('setValue', json.bidRisk.risk_m_yn8);
				    }
					if(typeof(json.bidRisk.risk_m_yn9)=="undefined"){
				    	$('#risk_m_yn93').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn93').combobox('setValue', json.bidRisk.risk_m_yn9);
				    }
					if(typeof(json.bidRisk.risk_m_yn10)=="undefined"){
				    	$('#risk_m_yn103').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn103').combobox('setValue', json.bidRisk.risk_m_yn10);
				    }
					if(typeof(json.bidRisk.risk_m_yn11)=="undefined"){
				    	$('#risk_m_yn113').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn113').combobox('setValue', json.bidRisk.risk_m_yn11);
				    }
					if(typeof(json.bidRisk.risk_m_yn14)=="undefined"){
				    	$('#risk_m_yn143').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn143').combobox('setValue', json.bidRisk.risk_m_yn14);
				    }
					if(typeof(json.bidRisk.risk_m_yn15)=="undefined"){
				    	$('#risk_m_yn153').combobox('setValue', 'Y');
				    }else{
				    	$('#risk_m_yn153').combobox('setValue', json.bidRisk.risk_m_yn15);
				    }
			   }
			   
			   if(json.bidStatus !=null){
				   $("#tab5_apply").text(formatStatusStep3(json.bidStatus));
			   		if(json.bidStatus.status_step=="1"){
			   			if(json.bidStatus.status_cd2=="003"){
			   				$("#authText").append("팀장 반려된 공고 입니다.");
			   			}else{
			   				$("#auth1btn").show();
			   			}
				   	}else if(json.bidStatus.status_step=="2"){
				   			$("#auth1btn").show();
			   				$("#auth2btn").show();	   		
				   	}else if(json.bidStatus.status_step=="3"){
				   		if(json.bidStatus.status_cd3=="002"){
			   				$("#authText").append("승인이 완료된 공고 입니다.");
			   			}else{
			   				$("#auth3btn").show();
			   			}
				   	}
			   } 
		   }
	});
}

//견적요청탭  제조사 정보 조회
function setBizGrid3(bidNoticeNo, bidNoticeChaNo){
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/bidBizRelList.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :bidNoticeNo,
			   bid_notice_cha_no :bidNoticeChaNo
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				   for(var i=0; i<json.rows.length;i++){
					   $("#companyB"+(i+1)+"_tr2").show();
					   $("#companyB"+(i+1)+"3").textbox('setValue',json.rows[i].company_nm);
					   $("#companyB"+(i+1)+"_business_no3").val(json.rows[i].business_no);
					   $("#companyB"+(i+1)+"_quotation2").textbox('setValue',numberComma(json.rows[i].quotation));
					   $("#companyB"+(i+1)+"_margin2").textbox('setValue',numberComma(json.rows[i].margin));
					   $("#companyB"+(i+1)+"_margin_per2").textbox('setValue', ((parseFloat(json.rows[i].margin.replaceAll(",","")) / parseFloat($("#column13").textbox('getValue').replaceAll(",",""))) * 100).toFixed(3) );
					   $("#companyB"+(i+1)+"_send_yn2").combobox('setValue',json.rows[i].send_yn);	
					   $("#companyB"+(i+1)+"_stock_yn2").combobox('setValue',json.rows[i].stock_yn);
					   $("#companyB"+(i+1)+"_credit_yn2").combobox('setValue',json.rows[i].credit_yn);
					   $("#companyB"+(i+1)+"_choice_reason2").textbox('setValue',json.rows[i].choice_reason);
					   $("#companyB"+(i+1)+"_review2").textbox('setValue',json.rows[i].review);
					   if(json.rows[i].choice_yn=="Y"){
						   $("input:checkbox[id='companyB"+(i+1)+"_choice_yn2']").prop("checked", true);
					   }
					   
				   }
			   }
		   }
	});
}
function selectView6(bid_notice_no){
	var bidNoticeNo = "";
	if(bid_notice_no == ""){
		if($("#tab6_bidNoticeNo").val().trim() == ""){
			$.messager.alert("알림", "공고번호를 입력해주세요.");
			return;
		}else{
			bidNoticeNo = $("#tab6_bidNoticeNo").val();
		}
	}else{
		bidNoticeNo = bid_notice_no;
	}
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/opening/getBusinessDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no : bidNoticeNo,
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.status=="202"){
				   $.messager.alert("알림", "데이터가 존재하지 않습니다.");
			   }else{
				   $(".mytable4").show(); 
				   $("#mytable5").show();
				   $("#mytable6").show();
				   $("#mytableBtn4").show();
				   setBizInfoInit6();				   
				   $("#notice_no6").val(json.rows[0].bid_notice_no);
				   $("#notice_cha_no6").val(json.rows[0].bid_notice_cha_no);
				   $("#tab6_bidNoticeNo").textbox('setValue',json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   if(json.rows[0].manual_yn=="Y"){
					   $("#tab6_bid_notice_no").text(json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   }else{
					   $("#tab6_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+json.rows[0].notice_detail_link+"')\">"+json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no+"</a>");
				   }
				   
				   var color = "";
					if(json.rows[0].notice_type=="긴급"){
						color ="red";
					}else if(json.rows[0].notice_type=="변경"){
						color ="blue";
					}else if(json.rows[0].notice_type=="취소"){
						color ="green";
					}else{
						color ="black";
					}
				   $("#tab6_bid_notice_nm").append("<span style='color:"+color+";font-weight:bold;'>["+json.rows[0].notice_type+"]</span>"+json.rows[0].bid_notice_nm+"");
				   $("#tab6_order_agency_nm").text(json.rows[0].order_agency_nm);
				   $("#tab6_demand_nm").text(json.rows[0].demand_nm);
				   $("#tab6_contract_type_nm").text(json.rows[0].contract_type_nm);				  
				   $("#tab6_pre_price").text(numberComma(json.rows[0].pre_price));				   				   
				   $("#tab6_base_price").textbox('setValue', numberComma(json.rows[0].base_price));
				   $('#s_range6').textbox('setValue',json.rows[0].s_range);
				    $('#e_range6').textbox('setValue',json.rows[0].e_range);
					   if(typeof(json.rows[0].product_yn)=="undefined"){
						  $("#tab6_product_yn").text("N");
				   }else{
					   $("#tab6_product_yn").text(numberComma(json.rows[0].product_yn));
				   }
				  
				   
				   $("#tab6_notice_spec_file").append(bid_info_detail(json.rows[0])[0]);
				   $("#tab6_bid_start_dt").text(bid_info_detail(json.rows[0])[1]);			
				   $("#tab6_bid_end_dt").val(json.rows[0].bid_end_dt);	
				   $("#tab6_detail_goods_no").val(json.rows[0].detail_goods_no);				   
				   $("#tab6_detail_goods_nm").val(json.rows[0].detail_goods_nm);
				   $("#tab6_bidmanager").text(bid_info_detail(json.rows[0])[2]);
				   $("#tab6_bid_open_dt").text(bid_info_detail(json.rows[0])[3]);
				   $("#tab6_use_area_info").append(bid_info_detail(json.rows[0])[4]);
				   
				   if(typeof(json.rows[0].permit_biz_type_info)!="undefined"){
					   if(bidLicense(json.rows[0].permit_biz_type_info,'') == ""){
						   	$("#tab6_permit_biz_type_info").append("");   
					   }else{
					   		$("#tab6_permit_biz_type_info").append(bidLicense(json.rows[0].permit_biz_type_info,''));
					   }
				   }
				   if(typeof(json.rows[0].goods_grp_limit_yn)=="undefined"){
 					  $("#tab6_goods_grp_limit_yn").text("N");
				   }else{
					   $("#tab6_goods_grp_limit_yn").text(json.rows[0].goods_grp_limit_yn);
				   }
				   $("#tab6_bid_lic_reg_dt").text(formatDate(json.rows[0].bid_lic_reg_dt));   
				 	//개찰사용자등록정보
					getBidDtl6(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
					
					//개찰 투찰사 정보
					setBizGrid6(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
			   }
		   }
	});
}
function setBizInfoInit6(){
	$("#notice_no6").val('');
	$("#notice_cha_no6").val('');
	$("#tab6_bid_notice_no").empty();
	$("#tab6_bid_notice_nm").empty();
	$("#tab6_notice_spec_file").empty();
	$("#tab6_permit_biz_type_info").empty();
	$("#tab6_use_area_info").empty();
	$('#tab6_bid_site').combobox('setValue', '');
	
	setBizGrid6('','');
}
function getBidDtl6(bidNoticeNo, bidNoticeChaNo){
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/distribution/getBidDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :bidNoticeNo,
			   bid_notice_cha_no :bidNoticeChaNo
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				    //$('#column1').textbox('setValue',numberComma(json.rows[0].column1));
				    $('#column26').combobox('setValue',json.rows[0].column2);
					$('#column36').combobox('setValue', json.rows[0].column3);
				    $('#column46').textbox('setValue',json.rows[0].column4);
				    $('#column56').textbox('setValue',json.rows[0].column5);

				    $('#s_range6').textbox('setValue',json.rows[0].s_range);
				    $('#e_range6').textbox('setValue',json.rows[0].e_range);
			   }else{
				   //$('#column1').textbox('setValue',"");
				    $('#column26').combobox('setValue',"");
				    $('#column36').combobox('setValue',"");
				    $('#column46').textbox('setValue',"");
				    $('#column56').textbox('setValue',"");

				    $('#s_range6').textbox('setValue',"");
				    $('#e_range6').textbox('setValue',"");
			   }
			  			   
			   if(json.bidSubj !=null){
				    $('#tab6_bid_site').combobox('setValue', json.bidSubj.bid_site);
					
			   }			   	   		  	 
		   }
	});
}
function setBizGrid6(bidNoticeNo, bidNoticeChaNo){
	$("#bc6").datagrid({
		method : "GET",
		url : "<c:url value='/opening/selectBusinessList2.do'/>",
		queryParams : {
			bid_notice_no :bidNoticeNo,
			bid_notice_cha_no : bidNoticeChaNo
		},
		onLoadSuccess : function(row, param) {
			editIndex6 = undefined;
			/* var rowData = row.rows;	
			for( var idx in rowData ){
				$('#bc4').datagrid('checkRow', idx);
			} */
		}
	});
}
function bid_info_detail(row){
	var str = new Array();
	
	var display = new Array(10);
	
	if(row.notice_spec_file_nm1==null) display[0] = "display:none";
	if(row.notice_spec_file_nm2==null) display[1] = "display:none";
	if(row.notice_spec_file_nm3==null) display[2] = "display:none";
	if(row.notice_spec_file_nm4==null) display[3] = "display:none";
	if(row.notice_spec_file_nm5==null) display[4] = "display:none";
	if(row.notice_spec_file_nm6==null) display[5] = "display:none";
	if(row.notice_spec_file_nm7==null) display[6] = "display:none";
	if(row.notice_spec_file_nm8==null) display[7] = "display:none";
	if(row.notice_spec_file_nm9==null) display[8] = "display:none";
	if(row.notice_spec_file_nm10==null) display[9] = "display:none";

	if(row.notice_spec_file_nm1!=null) display[0] = "";
	if(row.notice_spec_file_nm2!=null) display[1] = "";
	if(row.notice_spec_file_nm3!=null) display[2] = "";
	if(row.notice_spec_file_nm4!=null) display[3] = "";
	if(row.notice_spec_file_nm5!=null) display[4] = "";
	if(row.notice_spec_file_nm6!=null) display[5] = "";
	if(row.notice_spec_file_nm7!=null) display[6] = "";
	if(row.notice_spec_file_nm8!=null) display[7] = "";
	if(row.notice_spec_file_nm9!=null) display[8] = "";
	if(row.notice_spec_file_nm10!=null) display[9] = "";
	
	str[0] = "		<div style=\""+display[0]+"\">"
	+"				<a href=\""+row.notice_spec_form1+"\" >"+row.notice_spec_file_nm1+"</a>"
	+"			</div>"
	+"			<div style=\""+display[1]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form2+"\" >"+row.notice_spec_file_nm2+"</a>"
	+"			</div>"
	+"			<div style=\""+display[2]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form3+"\" >"+row.notice_spec_file_nm3+"</a>"
	+"			</div>"
	+"			<div style=\""+display[3]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form4+"\" >"+row.notice_spec_file_nm4+"</a>"
	+"			</div>"
	+"			<div style=\""+display[4]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form5+"\" >"+row.notice_spec_file_nm5+"</a>"
	+"			</div>"
	+"			<div style=\""+display[5]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form6+"\" >"+row.notice_spec_file_nm6+"</a>"
	+"			</div>"
	+"			<div style=\""+display[6]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form7+"\" >"+row.notice_spec_file_nm7+"</a>"
	+"			</div>"
	+"			<div style=\""+display[7]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form8+"\" >"+row.notice_spec_file_nm8+"</a>"
	+"			</div>"
	+"			<div style=\""+display[8]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form9+"\" >"+row.notice_spec_file_nm9+"</a>"
	+"			</div>"
	+"			<div style=\""+display[9]+"\">"
	+"				<br />	<a href=\""+row.notice_spec_form10+"\" >"+row.notice_spec_file_nm10+"</a>"
	+"			</div>";
	
	
	str[1] = formatDate(row.bid_start_dt)+" - "+formatDate(row.bid_end_dt);

	str[2] = nvlStr(row.reg_user_nm);
	if(nvlStr(row.reg_user_tel)!=""){
		str[2] += " / Tel : " + row.reg_user_tel;
	}
	if(nvlStr(row.reg_user_mail)!=""){
		str[2] += " / Email : " + row.reg_user_mail;
	}
	str[3] = formatDate(row.bid_open_dt);

	var info1 = "";
	
	if(row.use_area_info!=null){
		info1 = formatCommaEnter(row.use_area_info);
	}else{
		info1 = "";
	}

	str[4] = info1;
	
	return str;
	
}

function basePriceCall(noti_dt,bid_notice_no){
	var effectRow = new Object();
	var bid_notice_no = $('#notice_no').val()+'-'+$('#notice_cha_no').val();
	effectRow["noti_dt"] = $('#noti_dt').val();
	effectRow["bid_notice_no"] = bid_notice_no;
	
	$.post("<c:url value='/distribution/updateBidBaseAmount.do'/>",effectRow,
		function(rsp) {
			if (rsp.status) {
				$.messager.alert("알림","해당공고의 정보를 등록하였습니다.<br/>미등록시 재요청하시거나 <br/>수기로 등록하시기 바랍니다.");
				selectView(bid_notice_no);
			}
		}, "JSON").error(
		function() {
			$.messager.alert("알림","갱신에러！");
	});
}
function selectCompany(company_seq){
	var company_nm = "";
	if(company_seq != ""){
		company_nm = $("#companyB"+company_seq).textbox('getValue');
		$("#company_seq").val(company_seq);
	}else{
		company_seq = $("#company_seq").val();
		company_nm = $("#s_business_nm").textbox('getValue');
	}
	if (company_nm=="") {
		$.messager.alert("알림", "제조업체명을 입력해 주세요.");
		return;
	}
	$("#manufactureTb").datagrid({
		method : "GET",
		url : "<c:url value='/distribution/manufactureList.do'/>",
		queryParams : {
			s_business_nm : company_nm.replace( /(\s*)/g, "")
		},
		onLoadSuccess : function(row, param) {
			$("#s_business_nm").textbox('setValue',company_nm);
			$('#manufactureList').dialog('open');
		
		},
		onDblClickRow : function(index, row){		
			$("#companyB"+company_seq).textbox('setValue','');
			$("#s_business_nm").textbox('setValue','');	
			
			$("#companyB"+company_seq).textbox('setValue',row.company_nm + " / " + row.phone_no + " / " + row.email);
			$("#companyB"+company_seq+"_business_no").val(row.business_no);
			   
			$('#manufactureList').dialog('close');
		}
	});
}
//견적요청탭 입찰관련정보 사용자 정보 저장
function save3(type){
	if(type=="check"){
		var effectRow = new Object();
  		var addData = new Array(
  				{'business_no':$("#companyB1_business_no").val(),'company_nm':$("#companyB1").val().replace( /(\s*)/g, ""),'bigo':$("#companyB1_bigo").val()},
  				{'business_no':$("#companyB2_business_no").val(),'company_nm':$("#companyB2").val().replace( /(\s*)/g, ""),'bigo':$("#companyB2_bigo").val()},
  				{'business_no':$("#companyB3_business_no").val(),'company_nm':$("#companyB3").val().replace( /(\s*)/g, ""),'bigo':$("#companyB3_bigo").val()},
  				{'business_no':$("#companyB4_business_no").val(),'company_nm':$("#companyB4").val().replace( /(\s*)/g, ""),'bigo':$("#companyB4_bigo").val()},
  				{'business_no':$("#companyB5_business_no").val(),'company_nm':$("#companyB5").val().replace( /(\s*)/g, ""),'bigo':$("#companyB5_bigo").val()}
  			);
  		if($("#companyB1_business_no").val()==""&&$("#companyB2_business_no").val()==""&&$("#companyB3_business_no").val()==""&&$("#companyB4_business_no").val()==""&&$("#companyB5_business_no").val()==""){
  			$.messager.alert("알림","제조업체를 입력하세요.");
  			return;
  		}		
		effectRow["bid_notice_no"] = $('#notice_no').val();
		effectRow["bid_notice_cha_no"] = $('#notice_cha_no').val();
		//tn_bid_distribution_info_detail
		effectRow["column2"] = $('#column2').combobox('getValue');
		effectRow["column3"] = $('#column3').combobox('getValue');
		effectRow["column4"] = $('#column4').textbox('getValue');
		effectRow["column5"] = $('#column5').numberbox('getValue');
		effectRow["column7"] = $('#column7').textbox('getValue');
		effectRow["s_range"] = $('#s_range').textbox('getValue');
		effectRow["e_range"] = $('#e_range').textbox('getValue');
		effectRow["bigo"] = $('#tab_bid_manager_bigo').textbox('getValue');
		//tn_bid_distribution_info
		effectRow["base_price"] = $('#tab3_base_price').textbox('getValue');
		effectRow["detail_goods_no"] = $('#tab3_stad_no').textbox('getValue');
		effectRow["detail_goods_nm"] = $('#tab3_stad_nm').textbox('getValue');
		
		effectRow["notice_type"] = $('#tab3_notice_type').combobox('getValue');	
		effectRow["bid_notice_nm"] = $('#tab3_bid_notice_nm').textbox('getValue');	
		effectRow["order_agency_nm"] = $('#tab3_order_agency_nm').textbox('getValue');	
		effectRow["demand_nm"] = $('#tab3_demand_nm').textbox('getValue');	
		effectRow["contract_type_nm"] = $('#tab3_contract_type_nm').textbox('getValue');	
		effectRow["use_area_info"] = $('#tab3_use_area_info').textbox('getValue');	
		effectRow["product_yn"] = $('#tab3_product_yn').combobox('getValue');
		effectRow["goods_grp_limit_yn"] = $('#tab3_goods_grp_limit_yn').combobox('getValue');
		effectRow["permit_biz_type_info"] = $('#tab3_permit_biz_type_info').textbox('getValue');	
		effectRow["bid_start_dt"] = $('#tab3_bid_start_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_start_dt_h').textbox('getValue')+$('#tab3_bid_start_dt_m').textbox('getValue');	
		effectRow["bid_end_dt"] = $('#tab3_bid_end_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_end_dt_h').textbox('getValue')+$('#tab3_bid_end_dt_m').textbox('getValue');	
		effectRow["bid_open_dt"] = $('#tab3_bid_open_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_open_dt_h').textbox('getValue')+$('#tab3_bid_open_dt_m').textbox('getValue');
		effectRow["bid_lic_reg_dt"] = $('#tab3_bid_lic_reg_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_lic_reg_dt_h').textbox('getValue')+$('#tab3_bid_lic_reg_dt_m').textbox('getValue');
		effectRow["reg_user_nm"] = $('#tab3_bidmanager').textbox('getValue');	
		effectRow["reg_user_tel"] = $('#tab3_bidmanager_t').textbox('getValue');	
		effectRow["reg_user_mail"] = $('#tab3_bidmanager_e').textbox('getValue');			
		effectRow["pre_price"] = $('#tab3_pre_price').textbox('getValue');
					
		//tn_bid_distribution_risk
		effectRow["risk_yn1"] = $('#risk_yn1').combobox('getValue');
		effectRow["risk_yn2"] = $('#risk_yn2').combobox('getValue');
		effectRow["risk_yn3"] = $('#risk_yn3').combobox('getValue');
		effectRow["risk_yn4"] = $('#risk_yn4').combobox('getValue');
		effectRow["risk_yn5"] = $('#risk_yn5').combobox('getValue');
		effectRow["risk_yn6"] = $('#risk_yn6').combobox('getValue');
		effectRow["risk_yn7"] = $('#risk_yn7').combobox('getValue');
		effectRow["risk_yn8"] = $('#risk_yn8').combobox('getValue');
		effectRow["risk_yn9"] = $('#risk_yn9').combobox('getValue');
		effectRow["risk_yn10"] = $('#risk_yn10').combobox('getValue');
		effectRow["risk_yn11"] = $('#risk_yn11').combobox('getValue');
		effectRow["risk_yn14"] = $('#risk_yn14').combobox('getValue');
		effectRow["risk_yn15"] = $('#risk_yn15').combobox('getValue');
		
		effectRow["bid_site"] = $('#tab_bid_site').combobox('getValue');
		effectRow["bid_stock_issue_yn"] = $('#tab_bid_stock_issue_yn').textbox('getValue');
		effectRow["bid_term"] = $('#tab_bid_term').textbox('getValue');
		effectRow["bid_num_of_days"] = $('#tab_bid_num_of_days').textbox('getValue');
		effectRow["bid_risk"] = $('#tab_bid_risk').combobox('getValue');
		effectRow["bid_cont"] = $('#tab_bid_cont').textbox('getValue');
		effectRow["bid_tot_cont"] = $('#tab_bid_tot_cont').textbox('getValue');
		effectRow["bid_sp_cont"] = $('#tab_bid_sp_cont').textbox('getValue');
		
		if (addData.length) {
			effectRow["addData"] = JSON.stringify(addData);
		}
		
		$.post("<c:url value='/distribution/setBidDtl.do'/>",effectRow,
			function(rsp) {
				if (rsp.status) {
					selectView('');
					save4();
				}
			});
	}else{
	  	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	  		if (r) {
		  		var effectRow = new Object();
		  		var addData = new Array(
		  				{'business_no':$("#companyB1_business_no").val(),'company_nm':$("#companyB1").val().replace( /(\s*)/g, ""),'bigo':$("#companyB1_bigo").val()},
		  				{'business_no':$("#companyB2_business_no").val(),'company_nm':$("#companyB2").val().replace( /(\s*)/g, ""),'bigo':$("#companyB2_bigo").val()},
		  				{'business_no':$("#companyB3_business_no").val(),'company_nm':$("#companyB3").val().replace( /(\s*)/g, ""),'bigo':$("#companyB3_bigo").val()},
		  				{'business_no':$("#companyB4_business_no").val(),'company_nm':$("#companyB4").val().replace( /(\s*)/g, ""),'bigo':$("#companyB4_bigo").val()},
		  				{'business_no':$("#companyB5_business_no").val(),'company_nm':$("#companyB5").val().replace( /(\s*)/g, ""),'bigo':$("#companyB5_bigo").val()}
		  			);
				effectRow["bid_notice_no"] = $('#notice_no').val();
				effectRow["bid_notice_cha_no"] = $('#notice_cha_no').val();
				//tn_bid_distribution_info_detail
				effectRow["column2"] = $('#column2').combobox('getValue');
				effectRow["column3"] = $('#column3').combobox('getValue');
				effectRow["column4"] = $('#column4').textbox('getValue');
				effectRow["column5"] = $('#column5').numberbox('getValue');
				effectRow["column7"] = $('#column7').textbox('getValue');
				effectRow["s_range"] = $('#s_range').textbox('getValue');
				effectRow["e_range"] = $('#e_range').textbox('getValue');
				effectRow["bigo"] = $('#tab_bid_manager_bigo').textbox('getValue');
				//tn_bid_distribution_info
				effectRow["base_price"] = $('#tab3_base_price').textbox('getValue');
				effectRow["detail_goods_no"] = $('#tab3_stad_no').textbox('getValue');
				effectRow["detail_goods_nm"] = $('#tab3_stad_nm').textbox('getValue');
				
				effectRow["notice_type"] = $('#tab3_notice_type').combobox('getValue');	
				effectRow["bid_notice_nm"] = $('#tab3_bid_notice_nm').textbox('getValue');	
				effectRow["order_agency_nm"] = $('#tab3_order_agency_nm').textbox('getValue');	
				effectRow["demand_nm"] = $('#tab3_demand_nm').textbox('getValue');	
				effectRow["contract_type_nm"] = $('#tab3_contract_type_nm').textbox('getValue');	
				effectRow["use_area_info"] = $('#tab3_use_area_info').textbox('getValue');	
				effectRow["product_yn"] = $('#tab3_product_yn').combobox('getValue');	
				effectRow["goods_grp_limit_yn"] = $('#tab3_goods_grp_limit_yn').combobox('getValue');
				effectRow["permit_biz_type_info"] = $('#tab3_permit_biz_type_info').textbox('getValue');	
				effectRow["bid_start_dt"] = $('#tab3_bid_start_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_start_dt_h').textbox('getValue')+$('#tab3_bid_start_dt_m').textbox('getValue');	
				effectRow["bid_end_dt"] = $('#tab3_bid_end_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_end_dt_h').textbox('getValue')+$('#tab3_bid_end_dt_m').textbox('getValue');	
				effectRow["bid_open_dt"] = $('#tab3_bid_open_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_open_dt_h').textbox('getValue')+$('#tab3_bid_open_dt_m').textbox('getValue');
				effectRow["bid_lic_reg_dt"] = $('#tab3_bid_lic_reg_dt_y').datebox('getValue').replaceAll("-","")+$('#tab3_bid_lic_reg_dt_h').textbox('getValue')+$('#tab3_bid_lic_reg_dt_m').textbox('getValue');
				effectRow["reg_user_nm"] = $('#tab3_bidmanager').textbox('getValue');	
				effectRow["reg_user_tel"] = $('#tab3_bidmanager_t').textbox('getValue');	
				effectRow["reg_user_mail"] = $('#tab3_bidmanager_e').textbox('getValue');			
				effectRow["pre_price"] = $('#tab3_pre_price').textbox('getValue');
				
				//tn_bid_distribution_risk
				effectRow["risk_yn1"] = $('#risk_yn1').combobox('getValue');
				effectRow["risk_yn2"] = $('#risk_yn2').combobox('getValue');
				effectRow["risk_yn3"] = $('#risk_yn3').combobox('getValue');
				effectRow["risk_yn4"] = $('#risk_yn4').combobox('getValue');
				effectRow["risk_yn5"] = $('#risk_yn5').combobox('getValue');
				effectRow["risk_yn6"] = $('#risk_yn6').combobox('getValue');
				effectRow["risk_yn7"] = $('#risk_yn7').combobox('getValue');
				effectRow["risk_yn8"] = $('#risk_yn8').combobox('getValue');
				effectRow["risk_yn9"] = $('#risk_yn9').combobox('getValue');
				effectRow["risk_yn10"] = $('#risk_yn10').combobox('getValue');
				effectRow["risk_yn11"] = $('#risk_yn11').combobox('getValue');
				effectRow["risk_yn14"] = $('#risk_yn14').combobox('getValue');
				effectRow["risk_yn15"] = $('#risk_yn15').combobox('getValue');
				
				effectRow["bid_site"] = $('#tab_bid_site').combobox('getValue');
				effectRow["bid_stock_issue_yn"] = $('#tab_bid_stock_issue_yn').textbox('getValue');
				effectRow["bid_term"] = $('#tab_bid_term').textbox('getValue');
				effectRow["bid_num_of_days"] = $('#tab_bid_num_of_days').textbox('getValue');
				effectRow["bid_risk"] = $('#tab_bid_risk').combobox('getValue');
				effectRow["bid_cont"] = $('#tab_bid_cont').textbox('getValue');
				effectRow["bid_tot_cont"] = $('#tab_bid_tot_cont').textbox('getValue');
				effectRow["bid_sp_cont"] = $('#tab_bid_sp_cont').textbox('getValue');
				
				if (addData.length) {
					effectRow["addData"] = JSON.stringify(addData);
				}
				
				$.post("<c:url value='/distribution/setBidDtl.do'/>",effectRow,
					function(rsp) {
						if (rsp.status) {
							$.messager.alert("알림","저장하였습니다.");
							selectView('');
						}
					}, "JSON").error(
					function() {
						$.messager.alert("알림","저장에러！");
				});
	  		}
		});
	}
}
function save4(){
  	$.messager.confirm('알림', '견적검토를 완료하셨습니까? 확인을 누르시면 다음단계로 진행합니다.', function(r){
  		if (r) {
  			
	  		var effectRow = new Object();
			effectRow["bid_notice_no"] = $('#notice_no').val();
			effectRow["bid_notice_cha_no"] = $('#notice_cha_no').val();	
			effectRow["status_step"] = "1";
			effectRow["status_cd1"] = "001";
			$.post("<c:url value='/distribution/setApply.do'/>",effectRow,
				function(rsp) {
					if (rsp.status) {
						$.messager.alert("알림","견적검토가 완료되었습니다.");
						selectList2();
						selectList3();
						selectList5();
						selectView('');
						selectView2($('#notice_no').val()+'-'+$('#notice_cha_no').val());
						$('.tabs-title').filter(":eq(4)").parents('li').trigger("click");
					}
				}, "JSON").error(
				function() {
					$.messager.alert("알림","견적검토에러！");
			});
  		}
	});
}
function save5(type){
	if(type=="check"){
		var effectRow = new Object();
		var addData = new Array(
  				{'business_no':$("#companyB1_business_no2").val(),'quotation':$("#companyB1_quotation").textbox('getValue'),
  				'margin':$("#companyB1_margin").textbox('getValue'),'send_yn':$("#companyB1_send_yn").combobox('getValue'),
  				'stock_yn':$("#companyB1_stock_yn").combobox('getValue'),'choice_reason':$("#companyB1_choice_reason").textbox('getValue'),
  				'review':$("#companyB1_review").textbox('getValue'),'choice_yn':$("#companyB1_choice_yn").val(),'credit_yn':$("#companyB1_credit_yn").combobox('getValue')},
  				{'business_no':$("#companyB2_business_no2").val(),'quotation':$("#companyB2_quotation").textbox('getValue'),
	  			'margin':$("#companyB2_margin").textbox('getValue'),'send_yn':$("#companyB2_send_yn").combobox('getValue'),
	  			'stock_yn':$("#companyB2_stock_yn").combobox('getValue'),'choice_reason':$("#companyB2_choice_reason").textbox('getValue'),
	  			'review':$("#companyB2_review").textbox('getValue'),'choice_yn':$("#companyB2_choice_yn").val(),'credit_yn':$("#companyB2_credit_yn").combobox('getValue')},
  	  			{'business_no':$("#companyB3_business_no2").val(),'quotation':$("#companyB3_quotation").textbox('getValue'),
  	    		'margin':$("#companyB3_margin").textbox('getValue'),'send_yn':$("#companyB3_send_yn").combobox('getValue'),
  	    		'stock_yn':$("#companyB3_stock_yn").combobox('getValue'),'choice_reason':$("#companyB3_choice_reason").textbox('getValue'),
  	    		'review':$("#companyB3_review").textbox('getValue'),'choice_yn':$("#companyB3_choice_yn").val(),'credit_yn':$("#companyB3_credit_yn").combobox('getValue')},
  	    		{'business_no':$("#companyB4_business_no2").val(),'quotation':$("#companyB4_quotation").textbox('getValue'),
  	    	  	'margin':$("#companyB4_margin").textbox('getValue'),'send_yn':$("#companyB4_send_yn").combobox('getValue'),
  	    	  	'stock_yn':$("#companyB4_stock_yn").combobox('getValue'),'choice_reason':$("#companyB4_choice_reason").textbox('getValue'),
  	    	  	'review':$("#companyB4_review").textbox('getValue'),'choice_yn':$("#companyB4_choice_yn").val(),'credit_yn':$("#companyB4_credit_yn").combobox('getValue')},
  	    	  	{'business_no':$("#companyB5_business_no2").val(),'quotation':$("#companyB5_quotation").textbox('getValue'),
  	    	    'margin':$("#companyB5_margin").textbox('getValue'),'send_yn':$("#companyB5_send_yn").combobox('getValue'),
  	    	    'stock_yn':$("#companyB5_stock_yn").combobox('getValue'),'choice_reason':$("#companyB5_choice_reason").textbox('getValue'),
  	    	    'review':$("#companyB5_review").textbox('getValue'),'choice_yn':$("#companyB5_choice_yn").val(),'credit_yn':$("#companyB5_credit_yn").combobox('getValue')}
  			);
		effectRow["bid_notice_no"] = $('#notice_no2').val();
		effectRow["bid_notice_cha_no"] = $('#notice_cha_no2').val();
		effectRow["bigo"] = $('#tab_bid_manager_bigo2').textbox('getValue');
		effectRow["column4"] = $('#column42').textbox('getValue');
		
		if (addData.length) {
			effectRow["addData"] = JSON.stringify(addData);
		}

		$.post("<c:url value='/distribution/setBidDtl2.do'/>",effectRow,
			function(rsp) {
				if (rsp.status) {
					selectView2('');
					save6();
				}
			});
	}else{
	  	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	  		if (r) {
	  			var effectRow = new Object();
	  			var addData = new Array(
	  	  				{'business_no':$("#companyB1_business_no2").val(),'quotation':$("#companyB1_quotation").textbox('getValue'),
	  	  				'margin':$("#companyB1_margin").textbox('getValue'),'send_yn':$("#companyB1_send_yn").combobox('getValue'),
	  	  				'stock_yn':$("#companyB1_stock_yn").combobox('getValue'),'choice_reason':$("#companyB1_choice_reason").textbox('getValue'),
	  	  				'review':$("#companyB1_review").textbox('getValue'),'choice_yn':$("#companyB1_choice_yn").val(),'credit_yn':$("#companyB1_credit_yn").combobox('getValue')},
	  	  				{'business_no':$("#companyB2_business_no2").val(),'quotation':$("#companyB2_quotation").textbox('getValue'),
	  		  			'margin':$("#companyB2_margin").textbox('getValue'),'send_yn':$("#companyB2_send_yn").combobox('getValue'),
	  		  			'stock_yn':$("#companyB2_stock_yn").combobox('getValue'),'choice_reason':$("#companyB2_choice_reason").textbox('getValue'),
	  		  			'review':$("#companyB2_review").textbox('getValue'),'choice_yn':$("#companyB2_choice_yn").val(),'credit_yn':$("#companyB2_credit_yn").combobox('getValue')},
	  	  	  			{'business_no':$("#companyB3_business_no2").val(),'quotation':$("#companyB3_quotation").textbox('getValue'),
	  	  	    		'margin':$("#companyB3_margin").textbox('getValue'),'send_yn':$("#companyB3_send_yn").combobox('getValue'),
	  	  	    		'stock_yn':$("#companyB3_stock_yn").combobox('getValue'),'choice_reason':$("#companyB3_choice_reason").textbox('getValue'),
	  	  	    		'review':$("#companyB3_review").textbox('getValue'),'choice_yn':$("#companyB3_choice_yn").val(),'credit_yn':$("#companyB3_credit_yn").combobox('getValue')},
	  	  	    		{'business_no':$("#companyB4_business_no2").val(),'quotation':$("#companyB4_quotation").textbox('getValue'),
	  	  	    	  	'margin':$("#companyB4_margin").textbox('getValue'),'send_yn':$("#companyB4_send_yn").combobox('getValue'),
	  	  	    	  	'stock_yn':$("#companyB4_stock_yn").combobox('getValue'),'choice_reason':$("#companyB4_choice_reason").textbox('getValue'),
	  	  	    	  	'review':$("#companyB4_review").textbox('getValue'),'choice_yn':$("#companyB4_choice_yn").val(),'credit_yn':$("#companyB4_credit_yn").combobox('getValue')},
	  	  	    	  	{'business_no':$("#companyB5_business_no2").val(),'quotation':$("#companyB5_quotation").textbox('getValue'),
	  	  	    	    'margin':$("#companyB5_margin").textbox('getValue'),'send_yn':$("#companyB5_send_yn").combobox('getValue'),
	  	  	    	    'stock_yn':$("#companyB5_stock_yn").combobox('getValue'),'choice_reason':$("#companyB5_choice_reason").textbox('getValue'),
	  	  	    	    'review':$("#companyB5_review").textbox('getValue'),'choice_yn':$("#companyB5_choice_yn").val(),'credit_yn':$("#companyB5_credit_yn").combobox('getValue')}
	  	  			);
	  			effectRow["bid_notice_no"] = $('#notice_no2').val();
	  			effectRow["bid_notice_cha_no"] = $('#notice_cha_no2').val();
	  			effectRow["bigo"] = $('#tab_bid_manager_bigo2').textbox('getValue');
	  			effectRow["column4"] = $('#column42').textbox('getValue');
	  			
	  			if (addData.length) {
	  				effectRow["addData"] = JSON.stringify(addData);
	  			}
				
				$.post("<c:url value='/distribution/setBidDtl2.do'/>",effectRow,
					function(rsp) {
						if (rsp.status) {
							$.messager.alert("알림","저장하였습니다.");
							selectView2('');
						}
					}, "JSON").error(
					function() {
						$.messager.alert("알림","저장에러！");
				});
	  		}
		});
	}
}
function save6(){
  	$.messager.confirm('알림', '승인요청을 하시겠습니까?', function(r){
  		if (r) {
  			
	  		var effectRow = new Object();
			effectRow["bid_notice_no"] = $('#notice_no2').val();
			effectRow["bid_notice_cha_no"] = $('#notice_cha_no2').val();	
			effectRow["status_step"] = "2";
			effectRow["status_cd1"] = "002";
			effectRow["status_cd2"] = "001";
			$.post("<c:url value='/distribution/setApply.do'/>",effectRow,
				function(rsp) {
					if (rsp.status) {
						$.messager.alert("알림","승인요청이 완료되었습니다.");
						selectView($('#notice_no2').val()+'-'+$('#notice_cha_no2').val());
						//selectView2($('#notice_no2').val()+'-'+$('#notice_cha_no2').val());
						selectList3();
						selectList4();
						$('.tabs-title').filter(":eq(5)").parents('li').trigger("click");
					}
				}, "JSON").error(
				function() {
					$.messager.alert("알림","승인요청에러！");
			});
  		}
	});
}
function choice_chk(id){
	if(id.is(":checked")){
		return "Y";
	}else{
		return "";
	}
}
function save7(type,subType){
	var chkCnt = $('input:checkbox[name=choice_yn2]:checked').length;
	var message = "";
	if(chkCnt <= 0 && subType!="return"){
		$.messager.alert("알림","한개 이상의 제조업체를 선택하세요.");
		return;
	}
	if(type=="pass"){
		message = "구두승인 하시겠습니까?";
	}else if(type=="2"){
		if(subType=="pass"){
			message = "전결 하시겠습니까?";
		}else if(subType=="ok"){
			message = "승인 하시겠습니까?";
		}else if(subType=="return"){
			message = "반려 하시겠습니까?";
		}		
	}else if(type=="3"){
		if(subType=="ok"){
			message = "승인 하시겠습니까?";
		}else if(subType=="return"){
			message = "반려 하시겠습니까?";
		}	
	}
  	$.messager.confirm('알림', message, function(r){
  		if (r) {
  			
	  		var effectRow = new Object();
	  		var addData = new Array( 
	  				{'business_no':$("#companyB1_business_no3").val(),'choice_yn':choice_chk($('#companyB1_choice_yn2'))},
	  				{'business_no':$("#companyB2_business_no3").val(),'choice_yn':choice_chk($('#companyB2_choice_yn2'))},
	  				{'business_no':$("#companyB3_business_no3").val(),'choice_yn':choice_chk($('#companyB3_choice_yn2'))},
	  				{'business_no':$("#companyB4_business_no3").val(),'choice_yn':choice_chk($('#companyB4_choice_yn2'))},
	  				{'business_no':$("#companyB5_business_no3").val(),'choice_yn':choice_chk($('#companyB5_choice_yn2'))}
	  			);
			effectRow["bid_notice_no"] = $('#notice_no3').val();
			effectRow["bid_notice_cha_no"] = $('#notice_cha_no3').val();
			effectRow["type"] = type;
			effectRow["subType"] = subType;
			
			//tn_bid_distribution_risk
			effectRow["risk_m_yn1"] = $('#risk_m_yn13').combobox('getValue');
			effectRow["risk_m_yn2"] = $('#risk_m_yn23').combobox('getValue');
			effectRow["risk_m_yn3"] = $('#risk_m_yn33').combobox('getValue');
			effectRow["risk_m_yn4"] = $('#risk_m_yn43').combobox('getValue');
			effectRow["risk_m_yn5"] = $('#risk_m_yn53').combobox('getValue');
			effectRow["risk_m_yn6"] = $('#risk_m_yn63').combobox('getValue');
			effectRow["risk_m_yn7"] = $('#risk_m_yn73').combobox('getValue');
			effectRow["risk_m_yn8"] = $('#risk_m_yn83').combobox('getValue');
			effectRow["risk_m_yn9"] = $('#risk_m_yn93').combobox('getValue');
			effectRow["risk_m_yn10"] = $('#risk_m_yn103').combobox('getValue');			
			effectRow["risk_m_yn11"] = $('#risk_m_yn113').combobox('getValue');	
			if (addData.length) {
				effectRow["addData"] = JSON.stringify(addData);
			}
			$.post("<c:url value='/distribution/setApply2.do'/>",effectRow,
				function(rsp) {
					if (rsp.status) {
						$.messager.alert("알림","정상처리 되었습니다.");
						selectView3($('#notice_no3').val()+'-'+$('#notice_cha_no3').val());
						selectList4();
						$('.tabs-title').filter(":eq(5)").parents('li').trigger("click");
					}
				}, "JSON").error(
				function() {
					$.messager.alert("알림","승인에러！");
			});
  		}
	});
}
function drop(){
  	$.messager.confirm('알림', 'Drop하시겠습니까?', function(r){
  		if (r) {
	  		var effectRow = new Object();
			effectRow["bid_notice_no"] = $('#notice_no').val();
			effectRow["bid_notice_cha_no"] = $('#notice_cha_no').val();
			effectRow["status_step"] = "0";
			$.post("<c:url value='/distribution/setDrop.do'/>",effectRow,
				function(rsp) {
					if (rsp.status) {
						$.messager.alert("알림","Drop하였습니다.");
						selectView('');
						selectList3();
					}
				}, "JSON").error(
				function() {
					$.messager.alert("알림","Drop에러！");
			});
  		}
	});
}
function drop2(){
  	$.messager.confirm('알림', 'Drop하시겠습니까?', function(r){
  		if (r) {
	  		var effectRow = new Object();
			effectRow["bid_notice_no"] = $('#notice_no2').val();
			effectRow["bid_notice_cha_no"] = $('#notice_cha_no2').val();
			effectRow["status_step"] = "0";
			$.post("<c:url value='/distribution/setDrop.do'/>",effectRow,
				function(rsp) {
					if (rsp.status) {
						$.messager.alert("알림","Drop하였습니다.");
						$(".mytable2").hide();
						$("#mytableBtn2").hide();
						$("#tab4_bidNoticeNo").textbox('setValue','');
						selectView('');
						selectList2();
						selectList3();
						$('.tabs-title').filter(":eq(3)").parents('li').trigger("click");
					}
				}, "JSON").error(
				function() {
					$.messager.alert("알림","Drop에러！");
			});
  		}
	});
}
function pick(){
  	$.messager.confirm('알림', 'Pick하시겠습니까?', function(r){
  		if (r) {
	  		var effectRow = new Object();
			effectRow["bid_notice_no"] = $('#notice_no').val();
			effectRow["bid_notice_cha_no"] = $('#notice_cha_no').val();	
			$.post("<c:url value='/distribution/setPick.do'/>",effectRow,
				function(rsp) {
					if (rsp.status) {
						$.messager.alert("알림","Pick하였습니다.");
						selectView('');
						selectList3();
					}
				}, "JSON").error(
				function() {
					$.messager.alert("알림","Pick에러！");
			});
  		}
	});
}
function move(){
	selectView('');
	selectView2($('#notice_no').val()+'-'+$('#notice_cha_no').val());
	$('.tabs-title').filter(":eq(4)").parents('li').trigger("click");	
}
function sendManufacture(message_seq){
	if($("#companyB"+message_seq+"_business_no").val()==""){
		$.messager.alert("알림", "정보가 없습니다.");
		return;
	}
	var message = "To."+ $("#companyB"+message_seq).textbox('getValue')+"\n\n"+
		"안녕하세요 \n"+
		"㈜인콘 <%=(String) session.getAttribute("loginidNM")%> <%=(String) session.getAttribute("position")%>입니다.\n"+
		"공고번호 : "+($('#tab3_bid_notice_no').text())+"\n"+
		"공고명 : "+($('#tab3_bid_notice_nm').textbox('getValue'))+"\n"+
		"수요기관 : "+($('#tab3_demand_nm').textbox('getValue'))+"\n\n"+
		"관련 하여 견적을 요청드립니다."+"\n\n"+
		"Tel <%=(String) session.getAttribute("tel")%> "+"\n"+
		"Email <%=(String) session.getAttribute("email")%> "+"\n"+
		"Fax <%=(String) session.getAttribute("fax")%> 로 부탁드립니다. "+"\n\n"+
		"견적서는 이메일로 부탁드리며 기타문의사항은 직통전화를 통하여 연락부탁드립니다. "+"\n"+
		"감사합니다"+"\n";


		
	$('#sendMessage1').textbox('setValue',message);
	$("#message_seq").val(message_seq);

	$('#sendMessageDlg').dialog('open');
	
}
function sendMessage(){
	
	$.messager.confirm('알림', '선택하신 업체에 견적을 요청하시겠습니까?', function(r){
        if (r){
        	$('#sendMessageDlg').dialog('close');
    		
    		var effectRow = new Object();
    		
    		effectRow["bid_notice_no"] = $("#notice_no").val();
    		effectRow["bid_notice_cha_no"] = $("#notice_cha_no").val();
    		effectRow["business_no"] = $("#companyB"+$("#message_seq").val()+"_business_no").val();
    		effectRow["send_message"] = $("#sendMessage1").textbox('getValue');
    		
    		$.post("<c:url value='/distribution/sendManufacture.do'/>", effectRow, function(rsp) {
    			
    			if(rsp.status){
    				$.messager.alert("알림", "견적요청을 발송하였습니다.");
    			}else{
        			$.messager.alert("알림", "견적요청에러！");
    			}
    		}, "JSON").error(function() {
    			$.messager.alert("알림", "견적요청에러！");
    		});
        }
    });
	
}
function save8(){
	if($('#in_bid_notice_no').textbox('getValue').replace( /(\s*)/g, "")=="" || $('#in_bid_notice_cha_no').textbox('getValue').replace( /(\s*)/g, "")==""){
		$.messager.alert("알림", "공고번호를 입력해주세요.");
		return;
	}
	if($('#in_bid_notice_cha_no').textbox('getValue').length > 2){
		$.messager.alert("알림", "공고번호 뒷자리는 2자리만 입력해주세요.");
		return;
	}
	if($('#in_bid_notice_nm').textbox('getValue')==""){
		$.messager.alert("알림", "공고명을 입력해주세요.");
		return;
	}		
	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
        if (r){
        	var effectRow = new Object();
			effectRow["bid_notice_no"] = $('#in_bid_notice_no').textbox('getValue').replace( /(\s*)/g, "");
			effectRow["bid_notice_cha_no"] = $('#in_bid_notice_cha_no').textbox('getValue').replace( /(\s*)/g, "");
			effectRow["notice_type"] = $('#in_notice_type').combobox('getValue');
			effectRow["bid_notice_nm"] = $('#in_bid_notice_nm').textbox('getValue');					
			effectRow["detail_goods_nm"] = $('#in_detail_goods_nm').textbox('getValue');
			effectRow["use_area_info"] = $('#in_use_area_info').textbox('getValue');	
			effectRow["bid_end_dt"] = $('#in_bid_end_dt_y').datebox('getValue').replaceAll("-","")+$('#in_bid_end_dt_h').textbox('getValue')+$('#in_bid_end_dt_m').textbox('getValue');	
			effectRow["bid_lic_reg_dt"] = $('#in_bid_lic_reg_dt_y').datebox('getValue').replaceAll("-","")+$('#in_bid_lic_reg_dt_h').textbox('getValue')+$('#in_bid_lic_reg_dt_m').textbox('getValue');			
			effectRow["pre_price"] = $('#in_pre_price').textbox('getValue');
			
			$.post("<c:url value='/distribution/setBidNotice.do'/>",effectRow,
				function(rsp) {		
					if(rsp.status=="200") {
						$.messager.alert("알림", "저장하였습니다.");
						$("#dg").datagrid('reload');
						$('#unregDlg').dialog('close');
					}else if(rsp.status=="201"){
						$.messager.alert("알림", "이미 데이터가 존재합니다.");
					}
				}, "JSON").error(
				function() {
					$.messager.alert("알림","저장에러！");
			});
        }
	});
}
function save9(){
	if($('#company_nm_B').textbox('getValue')==""){
		$.messager.alert("알림", "업체명을 입력해주세요.");
		return;
	}
	var company_type = "";
	var unuse_yn = "";
	if(choice_chk($("#company_type_B1"))=="Y" && choice_chk($("#company_type_B2"))!="Y"){
		company_type = "1";
	}else if(choice_chk($("#company_type_B1"))!="Y" && choice_chk($("#company_type_B2"))=="Y"){
		company_type = "2";
	}else if(choice_chk($("#company_type_B1"))=="Y" && choice_chk($("#company_type_B2"))=="Y"){
		company_type = "3";
	}
	if(choice_chk($("#unuse_yn_B"))=="Y"){
		unuse_yn = "Y";
	}else{
		unuse_yn = "N";
	}
	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
        if (r){			
        	var effectRow = new Object();
 			effectRow["company_no"] = $("#company_no_B").textbox('getValue');
 			effectRow["address"] = $("#address_B").combobox('getValue');
 			effectRow["company_nm"] = $("#company_nm_B").textbox('getValue');
 			effectRow["address_detail"] = $("#address_detail_B").textbox('getValue');
 			effectRow["delegate"] = $("#delegate_B").textbox('getValue');
 			effectRow["position"] = $("#position_B").textbox('getValue');
 			effectRow["bidmanager"] = $("#bidmanager_B").textbox('getValue');
 			effectRow["delegate_explain"] = $("#delegate_explain_B").textbox('getValue');
 			effectRow["phone_no"] = $("#phone_no_B").textbox('getValue');
 			effectRow["delegate_explain2"] = $("#delegate_explain2_B").textbox('getValue');
 			effectRow["mobile_no"] = $("#mobile_no_B").textbox('getValue');
 			effectRow["delegate_explain3"] = $("#delegate_explain3_B").textbox('getValue');
 			effectRow["email"] = $("#email_B").textbox('getValue');			
 			effectRow["company_type"] = company_type;
 			effectRow["unuse_yn"] = unuse_yn;
 			effectRow["gubun"] = "B";
 			
			$.post("<c:url value='/enterprise/insertManufacture.do'/>", effectRow, function(rsp) {
				if(rsp.status=="200"){				
					$("#s_business_nm").textbox('setValue',$("#company_nm_B").textbox('getValue'));
					selectCompany('');
					
					$("#company_no_B").textbox("setValue","");
					$("#address_B").combobox("setValue","");
					$("#company_nm_B").textbox("setValue","");
					$("#address_detail_B").textbox("setValue","");
					$("#delegate_B").textbox("setValue","");
					$("#position_B").textbox("setValue","");
					$("#bidmanager_B").textbox("setValue","");
					$("#delegate_explain_B").textbox("setValue","");
					$("#phone_no_B").textbox("setValue","");
					$("#delegate_explain2_B").textbox("setValue","");
					$("#mobile_no_B").textbox("setValue","");
					$("#delegate_explain3_B").textbox("setValue","");
					$("#email_B").textbox("setValue","");
					$("input:checkbox[id='company_type_B1']").attr("checked", false);
					$("input:checkbox[id='company_type_B2']").attr("checked", false);
					$("input:checkbox[id='unuse_yn_B']").attr("checked", false);
					
					$('#manufactureDlg').dialog('close');
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "저장에러！");
			});
        }
	});
}
function save10(){
	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
        if (r){			
        	var effectRow = new Object();
 			effectRow["bid_notice_no"] = $("#bigo_notice_no").val();
 			effectRow["bid_notice_cha_no"] = $("#bigo_notice_cha_no").val();
 			effectRow["column4"] = $("#bigo_column4").textbox('getValue');
 			effectRow["bigo"] = $("#bigo_bigo").textbox('getValue');
 			effectRow["status_step"] = $("#bigo_apply").combobox('getValue');
 			effectRow["color_type"] = $("#color_type").combobox('getValue');
 			
			$.post("<c:url value='/distribution/updateBigo.do'/>", effectRow, function(rsp) {
				if(rsp.status){		
					$.messager.alert("알림", "저장하였습니다.");
					$("#dg").datagrid('reload');
					$("#dg2").datagrid('reload');
					$("#dg3").datagrid('reload');
					$("#dg4").datagrid('reload');
					$("#dg5").datagrid('reload');
					$('#bigoInsertDlg').dialog('close');
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "저장에러！");
			});
        }
	});
}
function post(type) {
	var addData= "";
	if(type=="send"){
		addData=$('#bc6').datagrid('getRows');
		if (endEditing6()){
    		var effectRow = new Object();
   			effectRow["bid_notice_no"] = $("#notice_no6").val();
   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no6").val();
   			
    		effectRow["addData"] = JSON.stringify(addData);	
    		
    		$.post("<c:url value='/opening/updateBusinessList.do'/>", effectRow, function(rsp) {
    			if(rsp.status){
    				sendBusiness();
    			}
    		}, "JSON").error(function() {
    			$.messager.alert("알림", "저장에러！");
    		});
    	}
	}else if(type=="bigo"){
		addData=$('#bc6').datagrid('getRows');
		if (endEditing6()){
    		var effectRow = new Object();
   			effectRow["bid_notice_no"] = $("#notice_no6").val();
   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no6").val();
   			
    		effectRow["addData"] = JSON.stringify(addData);	
    		
    		$.post("<c:url value='/opening/updateBusinessList.do'/>", effectRow, function(rsp) {
    			if(rsp.status){
    				sendBigo();
    			}
    		}, "JSON").error(function() {
    			$.messager.alert("알림", "저장에러！");
    		});
    	}
	}else{		
		addData=$('#bc6').datagrid('getRows');
		var message = "";
		if(addData==null || addData.length==0){
			message = "선택하신 투찰업체가 없습니다. 그래도 저장하시겠습니까?";
		}else{
			message = "저장하시겠습니까?";
		}
		$.messager.confirm('알림', message, function(r){
	        if (r){		
	        	if (endEditing6()){
		    		var effectRow = new Object();
		   			effectRow["bid_notice_no"] = $("#notice_no6").val();
		   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no6").val();

		    		effectRow["addData"] = JSON.stringify(addData);	
		    		
		    		$.post("<c:url value='/opening/updateBusinessList.do'/>", effectRow, function(rsp) {
		    			if(rsp.status){
		    				$.messager.alert("알림", "저장하였습니다.");
		    				selectView6($("#notice_no6").val()+"-"+$("#notice_cha_no6").val());
		    			}
		    		}, "JSON").error(function() {
		    			$.messager.alert("알림", "저장에러！");
		    		});
	        	}
	        }
	        
		});
	}
}
function getBusinessList(){
	$("#businessTb").datagrid({
		method : "GET",
		url : "<c:url value='/opening/businessList.do'/>",
		queryParams : {
			bid_notice_no : $("#notice_no6").val(),
			bid_notice_cha_no : $("#notice_cha_no6").val(),
			s_business_nm : $("#s_business_nm2").textbox("getValue"),
			s_company_type : $("#s_company_type2").val(),
			s_goods_type : $("#s_goods_type2").val(),
			s_area_cd : $("#s_area_cd2").combobox("getValue"),
			s_scale_cd : $("#s_scale_cd2").combobox("getValue"),
			s_credit_cd : $("#s_credit_cd2").combobox("getValue"),
			s_area_txt : $("#s_area_txt2").textbox("getValue"),
			s_license_type : $('#s_license_type2').val()
		},
		onLoadSuccess : function(row, param) {				
			$('#businessList').dialog('open');				
		}
	});
}
function tab4_save3(){
	var addData=$('#businessTb').datagrid('getChecked');
	
	if(addData==null || addData.length==0){
		$.messager.alert("알림", "등록할 투찰사를 선택하세요.");
		return;
	}

	for(var i=0;i<addData.length;i++){
		var isNo = false;
		var rowIndex = 0;
		var msgData=$('#bc6').datagrid('getRows');
		for(var j=0;j<msgData.length;j++){		
   			if(addData[i].business_no == msgData[j].business_no){
   				isNo = true;
   			}
		}
		if(!isNo){
			$('#bc6').datagrid('insertRow',{
				index: 1,	// index start with 0
				row: {
					business_no: addData[i].business_no,
					company_nm: addData[i].company_nm,
					bigo: addData[i].bigo,
					bidmanager: addData[i].bidmanager,
					phone_no: addData[i].phone_no,
					mobile_no: addData[i].mobile_no,			
					email: addData[i].email
				}
			});
		}
				
	}
   	$('#businessList').dialog('close');
}
function searchCompanyType2(cd, cd_nm, type){
	searchIdName = $("#"+cd);
	searchNmName = $("#"+cd_nm);
	
	$("#search_company_txt2_1").textbox("setValue","");
	$("#search_company_txt3_1").textbox("setValue","");

	if(type=='s'){
		getCompanyTypeTotalSearchList2();
	}else if(type=='c'){
		searchIdName.val("");
		searchNmName.textbox('setValue',"");
	}
	
}
function getCompanyTypeTotalSearchList2(){
	
	$("#searchCompanyTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/companyTypeTotalList.do'/>",
		queryParams : {
			searchTxt2 : $("#search_company_txt2_1").textbox("getValue"),
			searchTxt3 : $("#search_company_txt3_1").textbox("getValue")
		},
		onDblClickRow : function(index, row){
			companyTypeChoice2();
		}
	});
	
	$('#searchCompanyTypeDlg').dialog('open');
	
}
function companyTypeChoice2(){
	var row = $("#searchCompanyTypeTb").datagrid('getSelected');
	
	searchIdName.val(row.cd);
	searchNmName.textbox('setValue',row.cd_nm);
	
	$('#searchCompanyTypeDlg').dialog('close');
}
function searchLicenseType2(cd, cd_nm, type){
	searchIdName = $("#"+cd);
	searchNmName = $("#"+cd_nm);

	if(type=='s'){
		getLicenseTypeTotalSearchList2();
	}else if(type=='c'){
		searchIdName.val("");
		searchNmName.textbox('setValue',"");
	}
	
}
function getLicenseTypeTotalSearchList2(){
	
	$("#searchLicenseTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/licenseTypeTotalList.do'/>",
		queryParams : {
		},
		onDblClickRow : function(index, row){
			licenseTypeChoice2();
		}
	});
	
	$('#searchLicenseTypeDlg').dialog('open');
	
}
function licenseTypeChoice2(){
	var row = $("#searchLicenseTypeTb").datagrid('getSelected');
	
	searchIdName.val(row.cd);
	searchNmName.textbox('setValue',row.cd_nm);
	
	$('#searchLicenseTypeDlg').dialog('close');
}
function searchGoodsType2(cd, cd_nm, type){
	searchIdName = $("#"+cd);
	searchNmName = $("#"+cd_nm);

	$("#search_goods_txt2_1").textbox("setValue","");
	$("#search_goods_txt3_1").textbox("setValue","");
	
	if(type=='s'){
		getGoodsTypeTotalSearchList2();
	}else if(type=='c'){
		searchIdName.val("");
		searchNmName.textbox('setValue',"");
	}
	
}
function getGoodsTypeTotalSearchList2(){
	
	$("#searchGoodsTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsTypeTotalList.do'/>",
		queryParams : {
			searchTxt2 : $("#search_goods_txt2_1").textbox("getValue"),
			searchTxt3 : $("#search_goods_txt3_1").textbox("getValue")
		},
		onDblClickRow : function(index, row){
			goodsTypeChoice2();
		}
	});
	
	$('#searchGoodsDlg').dialog('open');
}
function goodsTypeChoice2(){
	var row = $("#searchGoodsTb").datagrid('getSelected');
	
	searchIdName.val(row.goods_no);
	searchNmName.textbox('setValue',row.goods_nm);
	
	$('#searchGoodsDlg').dialog('close');
}
function clearNotice(){
	$("#in_bid_notice_no").textbox("setValue","");
	$("#in_bid_notice_cha_no").textbox("setValue","");
	$("#in_bid_notice_nm").textbox("setValue","");
	$("#in_notice_type").combobox("setValue","일반");
	$('#unregDlg').dialog('open');
}
function popupDetail(link){
	var xleft= screen.width * 0.4;
	var xmid= screen.height * 0.4;
	window.open(link, "popup", "width=850,height=800,scrollbars=1", true)
}
function init(){
    var dts = new Date();
	var tenderSDt = new Date();
	var tenderEDt = new Date();
    var dayOfMonth = dts.getDate();
    tenderSDt.setDate(dayOfMonth-7);
    tenderEDt.setDate(dayOfMonth+30);
    dts.setDate(dayOfMonth);
    dts = dts.getFullYear()+"-"+((dts.getMonth() + 1)<9?"0"+(dts.getMonth() + 1):(dts.getMonth() + 1))+"-"+dts.getDate();
    tenderSDt = tenderSDt.getFullYear()+"-"+((tenderSDt.getMonth() + 1)<9?"0"+(tenderSDt.getMonth() + 1):(tenderSDt.getMonth() + 1))+"-"+tenderSDt.getDate();
    tenderEDt = tenderEDt.getFullYear()+"-"+((tenderEDt.getMonth() + 1)<9?"0"+(tenderEDt.getMonth() + 1):(tenderEDt.getMonth() + 1))+"-"+tenderEDt.getDate();
    
	$('#disDt').datebox('setValue',dts);
    $('#startDt').datebox('setValue',dts);
    $('#disSDt').datebox('setValue',dts);
    $('#disEDt').datebox('setValue',dts);
    $('#tenderSDt').datebox('setValue',tenderSDt);
    $('#tenderEDt').datebox('setValue',tenderEDt);
    $('#tenderSDt2').datebox('setValue',tenderSDt);
    $('#tenderEDt2').datebox('setValue',tenderEDt);
    $('#bidStartDt5').datebox('setValue',tenderSDt);
    $('#bidEndDt5').datebox('setValue',tenderEDt);
       
}
function eventInit(){
	var textbox_name = ["#bid_notice_no", "#bidNoticeNo", "#tab3_bidNoticeNo","#companyB1","#companyB2","#companyB3","#companyB4", "#companyB5","#s_business_nm",
	                    "#bidNoticeNo2","#tab4_bidNoticeNo","#bidNoticeNo3","#tab5_bidNoticeNo","#s_business_nm2","#s_area_txt2","#bidNoticeNo5","#tab6_bidNoticeNo"];	
	$(textbox_name[0]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   save2();
	   }
	});	
	$(textbox_name[1]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectList2();
	   }
	});
	$(textbox_name[2]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectView('');
	   }
	});
	$(textbox_name[3]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectCompany('1');
	   }
	});
	$(textbox_name[4]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectCompany('2');
	   }
	});
	$(textbox_name[5]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectCompany('3');
	   }
	});
	$(textbox_name[6]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectCompany('4');
	   }
	});
	$(textbox_name[7]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectCompany('5');
	   }
	});
	$(textbox_name[8]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectCompany('');
	   }
	});    	
	$(textbox_name[9]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectList3();
	   }
	});
	$(textbox_name[10]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectView2('');
	   }
	});
	$(textbox_name[11]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectList4();
	   }
	});
	$(textbox_name[12]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectView3('');
	   }
	});
	$(textbox_name[13]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getBusinessList('');
	   }
	});
	$(textbox_name[14]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getBusinessList('');
	   }
	});
	$(textbox_name[15]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectList5();
	   }
	});
	$(textbox_name[16]).textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectView6('');
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
				 	<div title="공고분배" style="padding:5px">
				        <table style="width: 100%;">
							<tr>
								<td class="bc">공고분배일자</td>
								<td>
									<input class="easyui-datebox" id="disDt"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">
								</td>
								<td class="bc">공고번호</td>
								<td>
									<input class="easyui-textbox" style="height:26px" id="bid_notice_no">
					            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="save2()">추가</a>					            	
					            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="clearNotice()">미등록 공고추가</a>
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload'" onclick="$('#bidInfoDlg').dialog('open');">공고갱신</a>																
					            </td>			
					            <td>
					            	<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectList()">조회</a>	
					            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a>
					            </td>	            
							</tr>
						</table>
						
			            <table id="dg" class="easyui-datagrid"
					           style="width:100%;height:90%;" 
			                   data-options="rownumbers:false,
													  singleSelect:true,
													  pagination:true,
													  pageSize:100,
													  method:'get',
													  striped:true,
													  nowrap:false,													  
													  onDblClickCell:onDblClickCell,
													  onEndEdit:onEndEdit,
													  onBeforeEdit:onBeforeEdit,								
													  pageList:[100,50,200,500],
													  rowStyler: function(index,row){
										                    if (row.finish_status=='F'){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }
										                    if (row.color_type=='B'){
										                    	return 'background-color:#2f8cdd;color:#ffffff;';
										                    }
										                    if (row.color_type=='G'){
										                        return 'background-color:#7cd56c;color:#ffffff;';
										                    }
										              }">
			                <thead>
			                    <tr>
			                        <th data-options="field:'bid_notice_no',halign:'center',width:160,resizable:true,sortable:true">공고번호</th>
			                        <th data-options="field:'bid_notice_nm',align:'left',width:450,halign:'center',sortable:true" formatter="formatNoticeNm2">공고명</th>
			                        <th data-options="field:'detail_goods_nm',align:'left',width:120,halign:'center',sortable:true">물품명</th>
			                        <th data-options="field:'use_area_info',align:'left',width:120,halign:'center',sortable:true">지역제한</th>
			                        <th data-options="field:'bid_lic_reg_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">참가신청마감일시</th>
			                        <th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰마감일시</th>
			                        <th data-options="field:'pre_price',align:'right',width:120 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
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
											                                panelHeight:'auto',
											                                required:false
											                            }
											                        }">담당자지정</th>
			                        <th data-options="field:'bigo',align:'left',width:100 ,halign:'center',editor:'textbox'">비고</th>
			                        <th data-options="field:'important_yn',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">중요</th>
			                    </tr>
			                </thead>
			            </table>
			            <div id="userCnt"></div>		            
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
							function onDblClickCell(index, field) {						
								if (endEditing()) {
									$('#dg').datagrid('selectRow', index)
											.datagrid('beginEdit', index);
									var ed = $('#dg').datagrid('getEditor',{index : index,field : field});
									if (ed) {									
										($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
									}
									editIndex = index;
								} else {
									setTimeout(function() {
										$('#dg').datagrid('selectRow',editIndex);
									}, 0);
								}								
							}
							function onEndEdit(index, row) {
								var ed = $(this).datagrid('getEditor', {
									index : index,
									field : 'user_id'
								});
								row.user_nm = $(ed.target).combobox('getText');
							}
			            </script>
					</div>
					<div title="공고현황" style="padding:5px">
						<input type="hidden" id="bigo_notice_no" />
						<input type="hidden" id="bigo_notice_cha_no" />
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
									        <option value="3">담당자의견</option>
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
							        data:jsonData2">
								</td>
								<td class="bc">진행단계</td>
								<td>
									<select class="easyui-combobox" id="status_step_combo3" data-options="panelHeight:'auto'" style="width:200px;">
										<option value="">전체</option>
								        <option value="0">견적서 대기중</option>
								        <option value="1">Drop</option>
								        <option value="2">미진행</option>
								        <option value="3">승인요청중</option>
										<option value="4">승인완료</option>
									</select>
							        <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectList2()">조회</a>
								</td>								           
							</tr>
						</table>
						<div style="display: none;">
							<table class="easyui-datagrid"
									style="width:0px;height:0px;border: 0" 
									>
							</table>
						</div>
			            <table id="dg2" class="easyui-datagrid"
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
										                    if (row.color_type=='B'){
										                    	return 'background-color:#2f8cdd;color:#ffffff;';
										                    }
										                    if (row.color_type=='G'){
										                        return 'background-color:#7cd56c;color:#ffffff;';
										                    }
										              }">
			                <thead>
			                    <tr>
			                        <th data-options="field:'bid_notice_no',halign:'center',width:160,resizable:true,sortable:true">공고번호</th>
			                        <th data-options="field:'bid_notice_nm',align:'left',width:450,halign:'center',sortable:true" formatter="formatNoticeNm2">공고명</th>		                        
			                        <th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰마감일시</th>
			                        <th data-options="field:'pre_price',align:'right',width:120 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
									<th data-options="field:'user_nm',align:'center',width:60 ,halign:'center',editor:'textbox'">담당자</th>
			                        <th data-options="field:'column4',align:'left',width:350 ,halign:'center',editor:'textbox',sortable:true">담당자의견</th>
			                        <th data-options="field:'status_step',align:'left',width:180, halign:'center',editor:'textbox',sortable:true" formatter="formatStatusStepAll">진행단계</th>
			                        <th data-options="field:'manager_bigo',align:'left',width:200 ,halign:'center'">감독관의견</th>
			                        <th data-options="field:'bigo',align:'left',width:100 ,halign:'center'">비고</th>
			                        <th data-options="field:'important_yn',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">중요</th>
			                        <th data-options="field:'bigo_insert',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton_bigo">의견등록</th>
			                    </tr>
			                </thead>
			            </table>
			            <script>
							function formatRowButton_bigo(val,row){
								var bid_notice_no = row.bigo_notice_no+"&&"+row.bigo_notice_cha_no;
								return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" colorType=\""+row.color_type+"\" type=\"bigo_type\" val=\""+bid_notice_no+"\" onclick=\"\" ></a>";
							}
				            var editIndex2 = undefined;
							function endEditing2(){
								if (editIndex2 == undefined){return true}
								if ($('#dg2').datagrid('validateRow', editIndex2)){
							 		$('#dg2').datagrid('endEdit', editIndex2);
									editIndex2 = undefined;
									return true;
								} else {
									return false;
								}
							}
							function onDblClickCell2(row) {
								if(typeof(row.user_id)=="undefined"){
									$.messager.alert("알림", "공고담당자를 지정하여 주세요.");
								//}else if(row.finish_status == "F"){
									//$.messager.alert("알림", "마감된 공고 입니다.");
								}else{
									selectView(row.bid_notice_no);
									$('.tabs-title').filter(":eq(2)").parents('li').trigger("click");
								}
							}
			            </script>
					</div>
					<div title="견적요청" style="padding:5px; margin-left:50px;">
						<div data-options="region:'west',collapsible:false" title="" style="width: 95%;">
						<form id="tab3_form" method="post" >
						<input type="hidden" id="noti_dt" name="noti_dt">
						<input type="hidden" id="notice_no" name="notice_no">
						<input type="hidden" id="notice_cha_no" name="notice_cha_no">
							<table style="width: 100%;">
								<tr>
									<td class="bc">공고번호</td>
									<td>
										<input class="easyui-textbox" style="height:26px" id="tab3_bidNoticeNo">
										<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectView('');">조회</a>
									</td>
									<td align="right" id="mytableBtn">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save3('')">저장</a>
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="save3('check')">견적검토</a>
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-delete'" onclick="drop()">Drop</a>
										<!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="">요청</a> -->
									</td>
									<td align="right" id="pickBtn">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="pick()">Pick</a>
									</td>	
									<td align="right" id="moveBtn">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="move()">견적회신</a>
									</td>											            
								</tr>
							</table>
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 20%;">공고번호</td>
									<td style="width: 30%;"><font id="tab3_bid_notice_no"></font></td>
									<td class="bc" style="width: 20%;">물품분류제한여부 (입찰참가 제한)</td>
									<td style="width: 30%;">
										<select class="easyui-combobox" id="tab3_goods_grp_limit_yn" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
										</select>
									</td>								
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">공고명</td>
									<td style="width: 30%;">
										<select class="easyui-combobox" id="tab3_notice_type" data-options="panelHeight:'auto'" style="width:20%;">
										<option value="일반">일반</option>
								        <option value="긴급">긴급</option>
								        <option value="변경">변경</option>	
								        <option value="연기">연기</option>
								        <option value="재입찰">재입찰</option>									        
									</select>
										<input id="tab3_bid_notice_nm" name="tab3_bid_notice_nm" class="easyui-textbox" style="width: 75%;" maxlength="100" />
									</td>
									<td class="bc" style="width: 20%;">제조여부 (제조물픔으로 제한)</td>
									<td style="width: 30%;">
										<select class="easyui-combobox" id="tab3_product_yn" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
										</select>
									</td>
								</tr>						
								<tr>
									<td class="bc" style="width: 20%;">공고기관</td>
									<td style="width: 30%;">
										<input id="tab3_order_agency_nm" name="tab3_order_agency_nm" class="easyui-textbox" style="width: 95%;" maxlength="100" />
									</td>
									<td class="bc" style="width: 20%;">업종제한</td>
									<td style="width: 30%;">
										<input id="tab3_permit_biz_type_info" name="tab3_permit_biz_type_info" class="easyui-textbox" style="width: 95%;" maxlength="100" />
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">수요기관</td>
									<td style="width: 30%;">
										<input id="tab3_demand_nm" name="tab3_demand_nm" class="easyui-textbox" style="width: 95%;" maxlength="100" />
									</td>
									<td class="bc" style="width: 20%;">입찰일시</td>
									<td style="width: 30%;">
										<input class="easyui-datebox" id="tab3_bid_start_dt_y"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
										<input id="tab3_bid_start_dt_h" class="easyui-textbox" data-options="width:30" />:<input id="tab3_bid_start_dt_m" class="easyui-textbox" data-options="width:30" /> -
										<input class="easyui-datebox" id="tab3_bid_end_dt_y"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
										<input id="tab3_bid_end_dt_h" class="easyui-textbox" data-options="width:30" />:<input id="tab3_bid_end_dt_m" class="easyui-textbox" data-options="width:30" />
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">참가가능지역 (반드시 , 로 구분)</td>
									<td style="width: 30%;">
										<input id="tab3_use_area_info" name="tab3_use_area_info" class="easyui-textbox" style="width: 95%;" maxlength="100" />
									</td>
									<td class="bc" style="width: 20%;">참가신청마감일시</td>
									<td style="width: 30%;">
										<input class="easyui-datebox" id="tab3_bid_lic_reg_dt_y"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
										<input id="tab3_bid_lic_reg_dt_h" class="easyui-textbox" data-options="width:30" />:<input id="tab3_bid_lic_reg_dt_m" class="easyui-textbox" data-options="width:30" />				
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">계약방법</td>
									<td style="width: 30%;">
										<input id="tab3_contract_type_nm" name="tab3_contract_type_nm" class="easyui-textbox" style="width: 95%;" maxlength="100" />
									</td>
									<td class="bc" style="width: 20%;">개찰일시</td>
									<td style="width: 30%;">
										<input class="easyui-datebox" id="tab3_bid_open_dt_y"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
										<input id="tab3_bid_open_dt_h" class="easyui-textbox" data-options="width:30" />:<input id="tab3_bid_open_dt_m" class="easyui-textbox" data-options="width:30" />
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">조달사이트</td>
									<td style="width: 30%;">
										<input id="tab_bid_site" name="tab_bid_site"
											class="easyui-combobox"
											data-options="
											method:'get',
											width:250,
                 							panelHeight:'auto',
									        valueField: 'cd',
									        textField: 'cd_nm',
									        data:jsonData3" />
									</td>
									<td class="bc" style="width: 20%;">담당자</td>
									<td style="width: 30%;">
										이름 : <input id="tab3_bidmanager" name="tab3_bidmanager" class="easyui-textbox" style="width: 20%;" maxlength="100" />
										Tel : <input id="tab3_bidmanager_t" name="tab3_bidmanager_t" class="easyui-textbox" style="width: 20%;" maxlength="100" />
										Email : <input id="tab3_bidmanager_e" name="tab3_bidmanager_e" class="easyui-textbox" style="width: 30%;" maxlength="100" />
									</td>
								</tr>								
							</table>							
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" colspan="4" align="right" id="callBtn"><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload'" onclick="basePriceCall()">가져오기</a></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">추정가격</td>
									<td style="width: 30%;"><input id="tab3_pre_price" class="easyui-textbox" data-options="width:100" /></td>
									<td class="bc" style="width: 20%;">예가범위</td>
									<td style="width: 30%;">
										<input id="s_range" name="s_range"
										class="easyui-textbox" data-options="width:50" />
										~
										<input id="e_range" name="e_range"
										class="easyui-textbox" data-options="width:50"/> %
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기초금액</td>
									<td style="width: 30%;"><input id="tab3_base_price" class="easyui-textbox" data-options="width:100" /></td>
									<td class="bc" style="width: 20%;">낙찰하한</td>
									<td style="width: 30%;"><input id="column5" name="column5" class="easyui-numberbox" data-options="precision:3,width:100"/> %</td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 20%;">공고원문</td>
									<td><font id="tab3_notice_spec_file"></font></td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 20%;">적격정보</td>
									<td style="width: 30%;">
										<input id="column2" name="column2"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
														onSelect:onChgColumn2,
												        valueField: 'cd',
												        textField: 'cd_nm',
												        data:jsonData4" />
									</td>
									<td class="bc" style="width: 20%;">(견적요청)담당자 의견</td>
									<td style="width: 30%;"><input id="column4" name="column4" class="easyui-textbox" style="width: 100%;" maxlength="1000" /></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기업구분</td>
									<td style="width: 30%;">
										<input id="column3" name="column3"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
												        valueField: 'cd',
												        textField: 'cd_nm',
														data:jsonData5" />
									</td>
									<td class="bc" style="width: 20%;">공고분배자 비고</td>
									<td style="width: 30%;"><input id="tab3_bigo" name="tab3_bigo" class="easyui-textbox" style="width: 100%;" readonly="readonly"/></td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 20%;">감독관 의견</td>
									<td style="width: 30%;"><input id="tab_bid_manager_bigo" name="tab_bid_manager_bigo" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 20%;">참고 업체</td>
									<td style="width: 30%;"><input id="column7" name="column7" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">제조업체1</td>
									<td style="width: 30%;" align="right">
										<input type="hidden" id="companyB1_business_no" name="companyB1_business_no" />
										<input id="companyB1" name="companyB1" class="easyui-textbox" style="width:74%;" maxlength="100" />
										<a href="javascript:void(0)" class="easyui-linkbutton" style="width:25%;" data-options="iconCls:'icon-redo'" onClick="sendManufacture('1')">E-mail 발송</a>
									</td>
									<td class="bc" style="width: 20%;">견적요청 의견</td>
									<td style="width: 30%;"><input id="companyB1_bigo" name="companyB1_bigo" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>									
								</tr>	
								<tr>
									<td class="bc" style="width: 20%;">제조업체2</td>
									<td style="width: 30%;" align="right">
										<input type="hidden" id="companyB2_business_no" name="companyB2_business_no" />
										<input id="companyB2" name="companyB2" class="easyui-textbox" style="width:74%;" maxlength="100" />
										<a href="javascript:void(0)" class="easyui-linkbutton" style="width:25%;" data-options="iconCls:'icon-redo'" onClick="sendManufacture('2')">E-mail 발송</a>
									</td>
									<td class="bc" style="width: 20%;">견적요청 의견</td>
									<td style="width: 30%;"><input id="companyB2_bigo" name="companyB2_bigo" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">제조업체3</td>
									<td style="width: 30%;" align="right">
										<input type="hidden" id="companyB3_business_no" name="companyB3_business_no" />
										<input id="companyB3" name="companyB3" class="easyui-textbox" style="width:74%;" maxlength="100" />
										<a href="javascript:void(0)" class="easyui-linkbutton" style="width:25%;" data-options="iconCls:'icon-redo'" onClick="sendManufacture('3')">E-mail 발송</a>
									</td>
									<td class="bc" style="width: 20%;">견적요청 의견</td>
									<td style="width: 30%;"><input id="companyB3_bigo" name="companyB3_bigo" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">제조업체4</td>
									<td style="width: 30%;" align="right">
										<input type="hidden" id="companyB4_business_no" name="companyB4_business_no" />
										<input id="companyB4" name="companyB4" class="easyui-textbox" style="width:74%;" maxlength="100" />
										<a href="javascript:void(0)" class="easyui-linkbutton" style="width:25%;" data-options="iconCls:'icon-redo'" onClick="sendManufacture('4')">E-mail 발송</a>
									</td>
									<td class="bc" style="width: 20%;">견적요청 의견</td>
									<td style="width: 30%;"><input id="companyB4_bigo" name="companyB4_bigo" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">제조업체5</td>
									<td style="width: 30%;" align="right">
										<input type="hidden" id="companyB5_business_no" name="companyB5_business_no" />
										<input id="companyB5" name="companyB5" class="easyui-textbox" style="width:74%;" maxlength="100" />
										<a href="javascript:void(0)" class="easyui-linkbutton" style="width:25%;" data-options="iconCls:'icon-redo'" onClick="sendManufacture('5')">E-mail 발송</a>
									</td>
									<td class="bc" style="width: 20%;">견적요청 의견</td>
									<td style="width: 30%;"><input id="companyB5_bigo" name="companyB5_bigo" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>																											
							</table>
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 14%;">특정 규격, 특정 제조사 제품이 아님</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn1" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn1" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">수요처와 규격을 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn2" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>								
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn2" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 14%;">제조사와 규격을 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn11" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn11" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 14%;">인증서, 시험성적서 제출이 필요없음</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn3" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn3" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">필요시 이미 제조사에 서류가 구비되어 있음</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn4" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn4" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>																
								</tr>
								<tr>
									<td class="bc" style="width: 14%;">필요시 해당 물품 제조와 더불어 발급 예정임</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn5" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn5" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 14%;">실행 담당자와 납기의 적절성 확인</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn6" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn6" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품장소(납지)가 과다하거나 격오지가 아님</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn7" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn7" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품조건(상차도, 도착도, 하차도) 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn8" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn8" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품시 추가비용 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn9" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn9" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>																		
								</tr>
								<tr>
									<td class="bc" style="width: 14%;">입찰참가시 특이절차 여부</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn10" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn10" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 14%;">지난 개찰결과를 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn14" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn14" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">실행업체의 신용도 분석</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn15" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn15" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
								</tr>
							</table>
							<table cellpadding="5" class="mytable" style="margin-bottom:25px;">
								<tr>
									<td class="bc" style="width: 8%;">물품분류명/물품분류번호</td>
									<td style="width: 15%;"><input id="tab3_stad_nm" name="tab3_stad_nm" class="easyui-textbox" style="width: 45%;" maxlength="1000" /> / <input id="tab3_stad_no" name="tab3_stad_no" class="easyui-textbox" style="width: 45%;" maxlength="1000" /></td>
									<td class="bc" style="width: 8%;">제조사증권발급여부</td>
									<td style="width: 15%;"><input id="tab_bid_stock_issue_yn" name="tab_bid_term" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 8%;">과업기간</td>
									<td style="width: 15%;"><input id="tab_bid_term" name="tab_bid_term" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 8%;">업체추정 과업일수</td>
									<td style="width: 15%;"><input id="tab_bid_num_of_days" name="ab_bid_num_of_days" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 6%;">리스크</td>
									<td style="width: 10%;">
								        <select class="easyui-combobox" id="tab_bid_risk" data-options="panelHeight:'auto'" style="width: 95%;">
									        <option value="001">상(관리 불가능한 수준)</option>
									        <option value="002">중(관리 가능한 수준)</option>
									        <option value="003">하(관리 불필요한 수준)</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="bc">과업내용</td>
									<td colspan="9"><input id="tab_bid_cont" name="tab_bid_cont" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>
								<tr>
									<td class="bc">심사총평</td>
									<td colspan="9"><input id="tab_bid_tot_cont" name="tab_bid_tot_cont" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>
								<tr>
									<td class="bc">특이사항</td>
									<td colspan="9"><input id="tab_bid_sp_cont" name="tab_bid_sp_cont" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
								</tr>																					
							</table>
						</form>
						
						<script type="text/javascript">							
							function onChgColumn2(str){
								$("#column5").textbox("setValue",str.bigo);
							}
							function formatRowButton3(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"company_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							function formatRowButton4(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"goods_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
						</script>
						</div>
					</div>
					<div title="견적현황" style="padding:5px">
						<table style="width: 100%;">
							<tr>
								<td class="bc">입찰마감일자</td>
								<td>
									  <input class="easyui-datebox" id="tenderSDt"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">
									- <input class="easyui-datebox" id="tenderEDt"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">																										
								</td>
								<td class="bc">공고</td>
								<td>
									<select class="easyui-combobox" id="searchBidType2" data-options="panelHeight:'auto'" style="width:100px;">
									        <option value="1">공고번호</option>
									        <option value="2">공고명</option>
									        <option value="3">담당자의견</option>
									</select>
									<input type="text" class="easyui-textbox" id="bidNoticeNo2" style="width: 120px;">
								</td>
								<td class="bc">담당자</td>
								<td><input id="userId2" class="easyui-combobox"
									data-options="
									method:'get',
							        valueField: 'user_id',
							        textField: 'user_nm',
							        width:100,
							        panelHeight:'auto',
							        data:jsonData2">						        
								</td>
								<td class="bc">진행단계</td>
								<td>
									<select class="easyui-combobox" id="status_step_combo" data-options="panelHeight:'auto'" style="width:200px;">
										<option value="">전체</option>
								        <option value="1">견적서 대기중</option>
								        <option value="0">Drop</option>
								        <option value="nvl">미진행</option>
									</select>
							        <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectList3()">조회</a>
								</td>			            
							</tr>
						</table>
						<div style="display: none;">
							<table class="easyui-datagrid"
									style="width:0px;height:0px;border: 0" 
									>
							</table>
						</div>
			            <table id="dg3" class="easyui-datagrid"
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
										                    if (row.color_type=='B'){
										                    	return 'background-color:#2f8cdd;color:#ffffff;';
										                    }
										                    if (row.color_type=='G'){
										                        return 'background-color:#7cd56c;color:#ffffff;';
										                    }
										              }">
			                <thead>
			                    <tr>
			                        <th data-options="field:'bid_notice_no',halign:'center',width:160,resizable:true,sortable:true">공고번호</th>
			                        <th data-options="field:'bid_notice_nm',align:'left',width:450,halign:'center',sortable:true" formatter="formatNoticeNm2">공고명</th>
			                        <th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰마감일시</th>
			                        <th data-options="field:'pre_price',align:'right',width:120 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
			                        <th data-options="field:'user_nm',align:'center',width:60 ,halign:'center',editor:'textbox'">담당자</th>
			                        <th data-options="field:'column4',align:'left',width:350 ,halign:'center',editor:'textbox',sortable:true">담당자의견</th>
			                        <th data-options="field:'status_step',align:'left',width:180 ,halign:'center',sortable:true" formatter="formatStatusStep">진행단계</th>
			                        <th data-options="field:'manager_bigo',align:'left',width:200 ,halign:'center'">감독관의견</th>
			                        <th data-options="field:'bigo',align:'left',width:100 ,halign:'center'">비고</th>
			                        <th data-options="field:'important_yn',align:'center',halign:'center',width:40">중요</th>
			                    </tr>
			                </thead>
			            </table>
			            <script>
				            var editIndex3 = undefined;
							function endEditing3(){
								if (editIndex3 == undefined){return true}
								if ($('#dg3').datagrid('validateRow', editIndex3)){
							 		$('#dg3').datagrid('endEdit', editIndex3);
									editIndex3 = undefined;
									return true;
								} else {
									return false;
								}
							}
							function onDblClickCell3(row) {
								if(row.user_id == "non"){
									$.messager.alert("알림", "공고담당자를 지정하여 주세요.");
								}else if(typeof(row.status_step) == "undefined"){
									$.messager.alert("알림", "아직 검토가 완료되지 않은 공고 입니다.");
								}else if(row.status_step == "0"){
									$.messager.alert("알림", "Drop된 공고 입니다.");
								}else{
									selectView2(row.bid_notice_no);
									$('.tabs-title').filter(":eq(4)").parents('li').trigger("click");
								}
							}
			            </script>
					</div>
					<div title="견적회신" style="padding:5px; margin-left:50px;">
						<div data-options="region:'west',collapsible:false" title="" style="width: 95%;">
						<form id="tab4_form" method="post" >
						<input type="hidden" id="notice_no2" name="notice_no2">
						<input type="hidden" id="notice_cha_no2" name="notice_cha_no2">
							<table style="width: 100%;">
								<tr>
									<td class="bc">공고번호</td>
									<td>
										<input class="easyui-textbox" style="height:26px" id="tab4_bidNoticeNo">
										<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectView2('');">조회</a>
									</td>
									<td align="right" id="mytableBtn2">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save5('')">저장</a>
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="save5('check')">승인요청</a>
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-delete'" onclick="drop2()">Drop</a>
										<!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="">요청</a> -->
									</td>												            
								</tr>
							</table>
							<table cellpadding="5" class="mytable2">
								<tr>
									<td class="bc" style="width: 20%;">공고번호</td>
									<td style="width: 30%;"><font id="tab4_bid_notice_no"></font></td>
									<td class="bc" style="width: 20%;">물품분류제한여부 (입찰참가 제한)</td>
									<td style="width: 30%;"><font id="tab4_goods_grp_limit_yn"></font></td>									
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">공고명</td>
									<td style="width: 30%;"><font id="tab4_bid_notice_nm"></font></td>
									<td class="bc" style="width: 20%;">제조여부</td>
									<td style="width: 30%;"><font id="tab4_product_yn"></font></td>
								</tr>						
								<tr>
									<td class="bc" style="width: 20%;">공고기관</td>
									<td style="width: 30%;"><font id="tab4_order_agency_nm"></font></td>
									<td class="bc" style="width: 20%;">업종제한</td>
									<td style="width: 30%;"><font id="tab4_permit_biz_type_info"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">수요기관</td>
									<td style="width: 30%;"><font id="tab4_demand_nm"></font></td>
									<td class="bc" style="width: 20%;">입찰일시</td>
									<td style="width: 30%;"><font id="tab4_bid_start_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">참가가능지역 (반드시 , 로 구분)</td>
									<td style="width: 30%;"><font id="tab4_use_area_info"></font></td>
									<td class="bc" style="width: 20%;">참가신청마감일시</td>
									<td style="width: 30%;"><font id="tab4_bid_lic_reg_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">계약방법</td>
									<td style="width: 30%;"><font id="tab4_contract_type_nm"></font></td>
									<td class="bc" style="width: 20%;">개찰일시</td>
									<td style="width: 30%;"><font id="tab4_bid_open_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">조달사이트</td>
									<td style="width: 30%;">
										<input id="tab_bid_site2" name="tab_bid_site2"
											class="easyui-combobox"
											data-options="
											method:'get',
											width:250,
                 							panelHeight:'auto',
									        valueField: 'cd',
									        textField: 'cd_nm',
									        data:jsonData3" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">담당자</td>
									<td style="width: 30%;"><font id="tab4_bidmanager"></font></td>
								</tr>								
							</table>							
							<table cellpadding="5" class="mytable2">
								<tr>
									<td class="bc" style="width: 20%;">추정가격</td>
									<td style="width: 30%;"><font id="tab4_pre_price"></font></td>
									<td class="bc" style="width: 20%;">예가범위</td>
									<td style="width: 30%;">
										<input id="s_range2" name="s_range2"
										class="easyui-textbox" data-options="width:50" readonly="readonly"/>
										~
										<input id="e_range2" name="e_range2"
										class="easyui-textbox" data-options="width:50" readonly="readonly"/> %
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기초금액</td>
									<td style="width: 30%;"><input id="tab4_base_price" class="easyui-textbox" data-options="width:100" readonly="readonly" /></td>
									<td class="bc" style="width: 20%;">낙찰하한</td>
									<td style="width: 30%;"><input id="column52" name="column52" class="easyui-numberbox" data-options="precision:3,width:100" readonly="readonly"/> %</td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable2">
								<tr>
									<td class="bc" style="width: 20%;">공고원문</td>
									<td><font id="tab4_notice_spec_file"></font></td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable2">
								<tr>
									<td class="bc" style="width: 20%;">적격정보</td>
									<td style="width: 30%;">
										<input id="column22" name="column22"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
														onSelect:onChgColumn3,
												        valueField: 'cd',
												        textField: 'cd_nm',
												        data:jsonData4" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">(견적요청)담당자 의견</td>
									<td style="width: 30%;"><input id="column42" name="column42" class="easyui-textbox" style="width: 100%;" maxlength="1000"/></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기업구분</td>
									<td style="width: 30%;">
										<input id="column32" name="column32"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
												        valueField: 'cd',
												        textField: 'cd_nm',
														data:jsonData5" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">투찰 기준금액</td>
									<td style="width: 30%;"><input id="column12" name="column12" class="easyui-textbox" style="width: 100%;" formatter="numberComma" readonly="readonly"/></td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable2">
								<tr>
									<td class="bc" style="width: 5%;">감독관<br />의견</td>
									<td colspan="18" style="width: 5%;"><input id="tab_bid_manager_bigo2" name="tab_bid_manager_bigo2" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
								</tr>
								<tr id="companyB1_tr" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체1</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB1_business_no2" name="companyB1_business_no2" />
										<input id="companyB12" name="companyB12" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB1_quotation" name="companyB1_quotation" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange" formatter="numberComma"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB1_margin" name="companyB1_margin" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB1_margin_per" name="companyB1_margin_per" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB1_send_yn" data-options="panelHeight:'auto'" style="width:70px;">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB1_stock_yn" data-options="panelHeight:'auto'" style="width:80px;">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB1_credit_yn" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB1_choice_reason" name="companyB1_choice_reason" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB1_review" name="companyB1_review" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB1_choice_yn" name="choice_yn" value="Y"/></td>							
								</tr>
								<tr id="companyB2_tr" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체2</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB2_business_no2" name="companyB2_business_no2" />
										<input id="companyB22" name="companyB22" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB2_quotation" name="companyB2_quotation" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange2" formatter="numberComma"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB2_margin" name="companyB2_margin" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange2" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB2_margin_per" name="companyB2_margin_per" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB2_send_yn" data-options="panelHeight:'auto'" style="width:70px;">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB2_stock_yn" data-options="panelHeight:'auto'" style="width:80px;">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB2_credit_yn" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB2_choice_reason" name="companyB2_choice_reason" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB2_review" name="companyB2_review" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB2_choice_yn" name="choice_yn" value="Y"/></td>							
								</tr>
								<tr id="companyB3_tr" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체3</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB3_business_no2" name="companyB3_business_no2" />
										<input id="companyB32" name="companyB32" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB3_quotation" name="companyB3_quotation" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange3" formatter="numberComma"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB3_margin" name="companyB3_margin" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange3" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB3_margin_per" name="companyB3_margin_per" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB3_send_yn" data-options="panelHeight:'auto'" style="width:70px;">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB3_stock_yn" data-options="panelHeight:'auto'" style="width:80px;">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB3_credit_yn" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB3_choice_reason" name="companyB3_choice_reason" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB3_review" name="companyB3_review" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB3_choice_yn" name="choice_yn" value="Y"/></td>							
								</tr>
								<tr id="companyB4_tr" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체4</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB4_business_no2" name="companyB4_business_no2" />
										<input id="companyB42" name="companyB42" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB4_quotation" name="companyB4_quotation" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange4" formatter="numberComma"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB4_margin" name="companyB4_margin" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange4" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB4_margin_per" name="companyB4_margin_per" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB4_send_yn" data-options="panelHeight:'auto'" style="width:70px;">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB4_stock_yn" data-options="panelHeight:'auto'" style="width:80px;">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB4_credit_yn" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB4_choice_reason" name="companyB4_choice_reason" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB4_review" name="companyB4_review" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB4_choice_yn" name="choice_yn" value="Y"/></td>							
								</tr>
								<tr id="companyB5_tr" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체5</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB5_business_no2" name="companyB5_business_no2" />
										<input id="companyB52" name="companyB52" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB5_quotation" name="companyB5_quotation" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange5" formatter="numberComma"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB5_margin" name="companyB5_margin" class="easyui-textbox" style="width: 95%;" maxlength="1000" data-options="onChange:marginChange5" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB5_margin_per" name="companyB5_margin_per" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB5_send_yn" data-options="panelHeight:'auto'" style="width:70px;">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB5_stock_yn" data-options="panelHeight:'auto'" style="width:80px;">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB5_credit_yn" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB5_choice_reason" name="companyB5_choice_reason" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB5_review" name="companyB5_review" class="easyui-textbox" style="width: 90%;" maxlength="1000" /></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB5_choice_yn" name="choice_yn" value="Y"/></td>							
								</tr>																																							
							</table>
							<table cellpadding="5" class="mytable2">
								<tr>
									<td class="bc" style="width: 14%;">특정 규격, 특정 제조사 제품이 아님</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn12" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn12" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">수요처와 규격을 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn22" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>									
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn22" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">제조사와 규격을 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn112" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn112" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">인증서, 시험성적서 제출이 필요없음</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn32" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn32" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">필요시 이미 제조사에 서류가 구비되어 있음</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn42" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn42" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>																		
								</tr>
								<tr>
									<td class="bc" style="width: 14%;">필요시 해당 물품 제조와 더불어 발급 예정임</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn52" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn52" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 14%;">실행 담당자와 납기의 적절성 확인</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn62" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn62" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품장소(납지)가 과다하거나 격오지가 아님</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn72" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn72" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품조건(상차도, 도착도, 하차도) 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn82" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn82" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품시 추가비용 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn92" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn92" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>																
								</tr>
								<tr>
									<td class="bc" style="width: 14%;">입찰참가시 특이절차 여부</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn102" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn102" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 14%;">지난 개찰결과를 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn142" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn142" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">실행업체의 신용도 분석</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn152" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn152" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
								</tr>
							</table>
							<table cellpadding="5" class="mytable2" style="margin-bottom:25px;">
								<tr>
									<td class="bc" style="width: 8%;">물품분류명</td>
									<td style="width: 15%;"><input id="tab4_stad_nm" name="tab4_stad_nm" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 8%;">물품분류번호</td>
									<td style="width: 15%;"><input id="tab4_stad_no" name="tab4_stad_no" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 8%;">과업기간</td>
									<td style="width: 15%;"><input id="tab_bid_term2" name="tab_bid_term2" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 6%;">리스크</td>
									<td style="width: 10%;">
								        <select class="easyui-combobox" id="tab_bid_risk2" data-options="panelHeight:'auto'" style="width: 95%;">
									        <option value="001">상(관리 불가능한 수준)</option>
									        <option value="002">중(관리 가능한 수준)</option>
									        <option value="003">하(관리 불필요한 수준)</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="bc">과업내용</td>
									<td colspan="7" ><input id="tab_bid_cont2" name="tab_bid_cont2" class="easyui-textbox" style="width: 95%;" maxlength="1000" readonly="readonly"/></td>
								</tr>
								<tr>
									<td class="bc">심사총평</td>
									<td colspan="7" ><input id="tab_bid_tot_cont2" name="tab_bid_tot_cont2" class="easyui-textbox" style="width: 95%;" maxlength="1000" readonly="readonly"/></td>
								</tr>
								<tr>
									<td class="bc">특이사항</td>
									<td colspan="7" ><input id="tab_bid_sp_cont2" name="tab_bid_sp_cont2" class="easyui-textbox" style="width: 95%;" maxlength="1000" readonly="readonly"/></td>
								</tr>																					
							</table>
						</form>
						
						<script type="text/javascript">								
							function marginChange(){
								var quotation = formatNumber($("#companyB1_quotation").textbox('getValue').replaceAll(",","")); //견적금액
								var column12 = formatNumber($("#column12").textbox('getValue').replaceAll(",","")); //투찰 기준금액
								var margin = column12-quotation; // 마진 금액
								if(quotation > 0){
									$("#companyB1_margin").textbox('setValue',numberComma(margin));								
									var result = (margin / column12)*100;							
									$("#companyB1_margin_per").numberbox("setValue",result);
								}
							}
							function marginChange2(){
								var quotation = formatNumber($("#companyB2_quotation").textbox('getValue').replaceAll(",",""));
								var column12 = formatNumber($("#column12").textbox('getValue').replaceAll(",",""));
								var margin = column12-quotation;
								if(quotation > 0){
									$("#companyB2_margin").textbox('setValue',numberComma(margin));											
									var result = (margin / column12)*100;								
									$("#companyB2_margin_per").numberbox("setValue",result);
								}
							}
							function marginChange3(){
								var quotation = formatNumber($("#companyB3_quotation").textbox('getValue').replaceAll(",",""));
								var column12 = formatNumber($("#column12").textbox('getValue').replaceAll(",",""));
								var margin = column12-quotation;
								if(quotation > 0){
									$("#companyB3_margin").textbox('setValue',numberComma(margin));											
									var result = (margin / column12)*100;								
									$("#companyB3_margin_per").numberbox("setValue",result);
								}
							}
							function marginChange4(){
								var quotation = formatNumber($("#companyB4_quotation").textbox('getValue').replaceAll(",",""));
								var column12 = formatNumber($("#column12").textbox('getValue').replaceAll(",",""));
								var margin = column12-quotation;
								if(quotation > 0){
									$("#companyB4_margin").textbox('setValue',numberComma(margin));											
									var result = (margin / column12)*100;								
									$("#companyB4_margin_per").numberbox("setValue",result);
								}
							}
							function marginChange5(){
								var quotation = formatNumber($("#companyB5_quotation").textbox('getValue').replaceAll(",",""));
								var column12 = formatNumber($("#column12").textbox('getValue').replaceAll(",",""));
								var margin = column12-quotation;
								if(quotation > 0){
									$("#companyB5_margin").textbox('setValue',numberComma(margin));											
									var result = (margin / column12)*100;								
									$("#companyB5_margin_per").numberbox("setValue",result);
								}
							}
							function onChgColumn3(str){
								$("#column52").textbox("setValue",str.bigo);
								onChgColumn5();
							}
							function onChgColumn5(){
								var base = $("#tab4_base_price").textbox('getValue');
								var column5 = $("#column52").numberbox("getValue");
								var s_range2 = $("#s_range2").numberbox("getValue");
								var e_range2 = $("#e_range2").numberbox("getValue");

								if(base.length>0){
									base = base.replaceAll(",","");

									var result = base * (column5/100)* (((s_range2/100) + (e_range2/100))/2);
									
									$("#column12").textbox("setValue",numberComma(result));
								}
								
							}
						</script>
						</div>
					</div>
					<div title="견적회신현황" style="padding:5px">
						<table style="width: 100%;">
							<tr>
								<td class="bc">입찰마감일자</td>
								<td>
									  <input class="easyui-datebox" id="tenderSDt2"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">
									- <input class="easyui-datebox" id="tenderEDt2"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">																										
								</td>
								<td class="bc">공고</td>
								<td>
									<select class="easyui-combobox" id="searchBidType3" data-options="panelHeight:'auto'" style="width:100px;">
									        <option value="1">공고번호</option>
									        <option value="2">공고명</option>
									        <option value="3">담당자의견</option>
									</select>
									<input type="text" class="easyui-textbox" id="bidNoticeNo3" style="width: 120px;">
								</td>
								<td class="bc">담당자</td>
								<td><input id="userId3" class="easyui-combobox"
									data-options="
									method:'get',
							        valueField: 'user_id',
							        textField: 'user_nm',
							        width:100,
							        panelHeight:'auto',
							        data:jsonData2">						        
								</td>
								<td class="bc">진행단계</td>
								<td>
									<select class="easyui-combobox" id="status_step_combo2" data-options="panelHeight:'auto'" style="width:200px;">
										<option value="">전체</option>
										<option value="0">[팀장]승인중</option>
										<option value="1">[팀장]반려</option>
										<option value="2">[팀장]전결</option>
								        <option value="3">[총괄책임자]승인중</option>
								        <option value="4">[총괄책임자]반려</option>
								        <option value="5">유효견적</option>
								        <option value="6">구두승인</option>
									</select>
							        <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectList4()">조회</a>
								</td>			            
							</tr>
						</table>
						<div style="display: none;">
							<table class="easyui-datagrid"
									style="width:0px;height:0px;border: 0" 
									>
							</table>
						</div>
			            <table id="dg4" class="easyui-datagrid"
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
										                    if (row.color_type=='B'){
										                    	return 'background-color:#2f8cdd;color:#ffffff;';
										                    }
										                    if (row.color_type=='G'){
										                        return 'background-color:#7cd56c;color:#ffffff;';
										                    }
										              }">
			                <thead>
			                    <tr>
			                        <th data-options="field:'bid_notice_no',halign:'center',width:160,resizable:true,sortable:true">공고번호</th>
			                        <th data-options="field:'bid_notice_nm',align:'left',width:450,halign:'center',sortable:true" formatter="formatNoticeNm2">공고명</th>
			                        <th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰마감일시</th>
			                        <th data-options="field:'pre_price',align:'right',width:100 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
			                        <th data-options="field:'user_nm',align:'center',width:60,halign:'center',editor:'textbox'">담당자</th>
			                        <th data-options="field:'column4',align:'left',width:350,halign:'center',editor:'textbox',sortable:true">담당자의견</th>
			                        <th data-options="field:'status_step',align:'left',width:180 ,halign:'center',editor:'textbox',sortable:true" formatter="formatStatusStep2">진행단계</th>
			                    </tr>
			                </thead>
			            </table>
			            <script>
				            var editIndex4 = undefined;
							function endEditing4(){
								if (editIndex2 == undefined){return true}
								if ($('#dg4').datagrid('validateRow', editIndex4)){
							 		$('#dg4').datagrid('endEdit', editIndex4);
									editIndex4 = undefined;
									return true;
								} else {
									return false;
								}
							}
							function onDblClickCell4(row) {
								if(row.user_id == "non"){
									$.messager.alert("알림", "공고담당자를 지정하여 주세요.");
								}else if(typeof(row.status_step) == "undefined"){
									$.messager.alert("알림", "아직 검토가 완료되지 않은 공고 입니다.");
								}else if(row.status_step == "0"){
									$.messager.alert("알림", "Drop된 공고 입니다.");
								}else{
									selectView3(row.bid_notice_no);
									$('.tabs-title').filter(":eq(6)").parents('li').trigger("click");
								}
							}
			            </script>
					</div>
					<div title="승인요청" style="padding:5px; margin-left:50px;">
						<div data-options="region:'west',collapsible:false" title="" style="width: 95%;">
						<form id="tab5_form" method="post" >
						<input type="hidden" id="notice_no3" name="notice_no3">
						<input type="hidden" id="notice_cha_no3" name="notice_cha_no3">
							<table style="width: 100%;">
								<tr>
									<td class="bc">공고번호</td>
									<td>
										<input class="easyui-textbox" style="height:26px" id="tab5_bidNoticeNo">
										<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectView3('');">조회</a>
									</td>
									<td align="right" id="mytableBtn3">
											<div id="authText"></div>
										<%
											if(userid != null){
												if(Integer.parseInt((String)session.getAttribute("auth"))==1){ 
										%>
												<div id="auth1btn" style="display:none;">
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="save7('pass','pass')">구두승인</a>
												</div>
										<%
												}else if(Integer.parseInt((String)session.getAttribute("auth"))==2){
										%>
												<div id="auth2btn" style="display:none;">
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="save7('2','pass')">전결</a>
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="save7('2','ok')">승인</a>
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-delete'" onclick="save7('2','return')">반려</a>
												</div>
										<%
												}else if(Integer.parseInt((String)session.getAttribute("auth"))==3){
										%>
												<div id="auth3btn" style="display:none;">
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="save7('3','ok')">승인</a>
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-delete'" onclick="save7('3','return')">반려</a>
												</div>
										<%
												}
											}
										%>
									</td>												            
								</tr>
								<tr>
									<td colspan="10" align="right" id="mytableBtn5">
										담당자 이름 : <font id="tab5_user_nm"></font>, 진행단계 : <font id="tab5_apply"></font>
									</td>
								</tr>
							</table>
							<table cellpadding="5" class="mytable3">
								<tr>
									<td class="bc" style="width: 20%;">공고번호</td>
									<td style="width: 30%;"><font id="tab5_bid_notice_no"></font></td>
									<td class="bc" style="width: 20%;">물품분류제한여부 (입찰참가 제한)</td>
									<td style="width: 30%;"><font id="tab5_goods_grp_limit_yn"></font></td>									
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">공고명</td>
									<td style="width: 30%;"><font id="tab5_bid_notice_nm"></font></td>
									<td class="bc" style="width: 20%;">제조여부</td>
									<td style="width: 30%;"><font id="tab5_product_yn"></font></td>
								</tr>						
								<tr>
									<td class="bc" style="width: 20%;">공고기관</td>
									<td style="width: 30%;"><font id="tab5_order_agency_nm"></font></td>
									<td class="bc" style="width: 20%;">업종제한</td>
									<td style="width: 30%;"><font id="tab5_permit_biz_type_info"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">수요기관</td>
									<td style="width: 30%;"><font id="tab5_demand_nm"></font></td>
									<td class="bc" style="width: 20%;">입찰일시</td>
									<td style="width: 30%;"><font id="tab5_bid_start_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">참가가능지역 (반드시 , 로 구분)</td>
									<td style="width: 30%;"><font id="tab5_use_area_info"></font></td>
									<td class="bc" style="width: 20%;">참가신청마감일시</td>
									<td style="width: 30%;"><font id="tab5_bid_lic_reg_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">계약방법</td>
									<td style="width: 30%;"><font id="tab5_contract_type_nm"></font></td>
									<td class="bc" style="width: 20%;">개찰일시</td>
									<td style="width: 30%;"><font id="tab5_bid_open_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">조달사이트</td>
									<td style="width: 30%;">
										<input id="tab_bid_site3" name="tab_bid_site3"
											class="easyui-combobox"
											data-options="
											method:'get',
											width:250,
                 							panelHeight:'auto',
									        valueField: 'cd',
									        textField: 'cd_nm',
									        data:jsonData3" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">담당자</td>
									<td style="width: 30%;"><font id="tab5_bidmanager"></font></td>
								</tr>								
							</table>							
							<table cellpadding="5" class="mytable3">
								<tr>
									<td class="bc" style="width: 20%;">추정가격</td>
									<td style="width: 30%;"><font id="tab5_pre_price"></font></td>
									<td class="bc" style="width: 20%;">예가범위</td>
									<td style="width: 30%;">
										<input id="s_range3" name="s_range3"
										class="easyui-textbox" data-options="width:50" readonly="readonly"/>
										~
										<input id="e_range3" name="e_range3"
										class="easyui-textbox" data-options="width:50" readonly="readonly"/> %
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기초금액</td>
									<td style="width: 30%;"><input id="tab5_base_price" class="easyui-textbox" data-options="width:100" readonly="readonly" /></td>
									<td class="bc" style="width: 20%;">낙찰하한</td>
									<td style="width: 30%;"><input id="column53" name="column53" class="easyui-numberbox" data-options="precision:3,width:100" readonly="readonly"/> %</td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable3">
								<tr>
									<td class="bc" style="width: 20%;">공고원문</td>
									<td><font id="tab5_notice_spec_file"></font></td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable3">
								<tr>
									<td class="bc" style="width: 20%;">적격정보</td>
									<td style="width: 30%;">
										<input id="column23" name="column23"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
												        valueField: 'cd',
												        textField: 'cd_nm',
												        data:jsonData4" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">(견적요청)담당자 의견</td>
									<td style="width: 30%;"><input id="column43" name="column43" class="easyui-textbox" style="width: 100%;" maxlength="1000" readonly="readonly"/></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기업구분</td>
									<td style="width: 30%;">
										<input id="column33" name="column33"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
												        valueField: 'cd',
												        textField: 'cd_nm',
														data:jsonData5" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">투찰 기준금액</td>
									<td style="width: 30%;"><input id="column13" name="column13" class="easyui-textbox" style="width: 100%;" formatter="numberComma" readonly="readonly"/></td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable3">
								<tr>
									<td class="bc" style="width: 5%;">감독관<br />의견</td>
									<td colspan="18" style="width: 5%;"><input id="tab_bid_manager_bigo3" name="tab_bid_manager_bigo3" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
								</tr>
								<tr id="companyB1_tr2" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체1</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB1_business_no3" name="companyB1_business_no3" />
										<input id="companyB13" name="companyB13" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB1_quotation2" name="companyB1_quotation2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB1_margin2" name="companyB1_margin2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB1_margin_per2" name="companyB1_margin_per2" class="easyui-numberbox"style="width: 78%;" maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB1_send_yn2" data-options="panelHeight:'auto'" style="width:70px;" readonly="readonly">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB1_stock_yn2" data-options="panelHeight:'auto'" style="width:80px;" readonly="readonly">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB1_credit_yn2" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB1_choice_reason2" name="companyB1_choice_reason2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB1_review2" name="companyB1_review2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB1_choice_yn2" name="choice_yn2" value="Y"/></td>							
								</tr>
								<tr id="companyB2_tr2" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체2</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB2_business_no3" name="companyB2_business_no3" />
										<input id="companyB23" name="companyB23" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB2_quotation2" name="companyB2_quotation2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB2_margin2" name="companyB2_margin2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB2_margin_per2" name="companyB2_margin_per2" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB2_send_yn2" data-options="panelHeight:'auto'" style="width:70px;" readonly="readonly">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB2_stock_yn2" data-options="panelHeight:'auto'" style="width:80px;" readonly="readonly">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB2_credit_yn2" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB2_choice_reason2" name="companyB2_choice_reason2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB2_review2" name="companyB2_review2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB2_choice_yn2" name="choice_yn2" value="Y"/></td>							
								</tr>
								<tr id="companyB3_tr2" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체3</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB3_business_no3" name="companyB3_business_no3" />
										<input id="companyB33" name="companyB33" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB3_quotation2" name="companyB3_quotation2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB3_margin2" name="companyB3_margin2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB3_margin_per2" name="companyB3_margin_per2" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB3_send_yn2" data-options="panelHeight:'auto'" style="width:70px;" readonly="readonly">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB3_stock_yn2" data-options="panelHeight:'auto'" style="width:80px;" readonly="readonly">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB3_credit_yn2" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB3_choice_reason2" name="companyB3_choice_reason2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB3_review2" name="companyB3_review2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB3_choice_yn2" name="choice_yn2" value="Y"/></td>							
								</tr>
								<tr id="companyB4_tr2" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체4</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB4_business_no3" name="companyB4_business_no3" />
										<input id="companyB43" name="companyB43" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB4_quotation2" name="companyB4_quotation2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB4_margin2" name="companyB4_margin2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB4_margin_per2" name="companyB4_margin_per2" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB4_send_yn2" data-options="panelHeight:'auto'" style="width:70px;" readonly="readonly">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB4_stock_yn2" data-options="panelHeight:'auto'" style="width:80px;" readonly="readonly">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB4_credit_yn2" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB4_choice_reason2" name="companyB4_choice_reason2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB4_review2" name="companyB4_review2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB4_choice_yn2" name="choice_yn2" value="Y"/></td>							
								</tr>
								<tr id="companyB5_tr2" style="display:none;">
									<td class="bc" style="width: 5%;">제조업체5</td>
									<td style="width: 11%;">
										<input type="hidden" id="companyB5_business_no3" name="companyB5_business_no3" />
										<input id="companyB53" name="companyB53" class="easyui-textbox" style="width: 90%;" maxlength="100" readonly="readonly"/>										
									</td>
									<td class="bc" style="width: 5%;">견적금액</td>
									<td style="width: 5%;"><input id="companyB5_quotation2" name="companyB5_quotation2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>		
									<td class="bc" style="width: 5%;">마진금액</td>
									<td style="width: 5%;"><input id="companyB5_margin2" name="companyB5_margin2" class="easyui-textbox" style="width: 95%;" maxlength="1000" formatter="numberComma" readonly="readonly"/></td>
									<td class="bc" style="width: 3%;">마진율</td>
									<td style="width: 6%;"><input id="companyB5_margin_per2" name="companyB5_margin_per2" class="easyui-numberbox"style="width: 78%;"  maxlength="1000" data-options="precision:3" readonly="readonly"/>%</td>
									<td class="bc" style="width: 5%;">견적서<br />수령여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB5_send_yn2" data-options="panelHeight:'auto'" style="width:70px;" readonly="readonly">
									        <option value="N">N</option>
									        <option value="E">이메일</option>
									        <option value="C">확인메일</option>
									        <option value="F">팩스</option>
									        <option value="S">SNS</option>
									        <option value="V">음성</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">증권<br />가능여부</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB5_stock_yn2" data-options="panelHeight:'auto'" style="width:80px;" readonly="readonly">
									        <option value="N">불가능</option>
									        <option value="Y">증권가능</option>
									        <option value="C">각서+공증가능</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">제조사<br />신용도<br />분석</td>
									<td style="width: 2%;">
										<select class="easyui-combobox" id="companyB5_credit_yn2" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 5%;">지급조건</td>
									<td style="width: 8%;"><input id="companyB5_choice_reason2" name="companyB5_choice_reason2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td class="bc" style="width: 5%;">검토의견</td>
									<td style="width: 11%;"><input id="companyB5_review2" name="companyB5_review2" class="easyui-textbox" style="width: 90%;" maxlength="1000" readonly="readonly"/></td>
									<td style="width: 2%;"><input type="checkbox" id="companyB5_choice_yn2" name="choice_yn2" value="Y"/></td>							
								</tr>																																							
							</table>
							<table cellpadding="5" class="mytable3">
								<tr>
									<td class="bc" style="width: 14%;">특정 규격, 특정 제조사 제품이 아님</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn13" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn13" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">수요처와 규격을 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn23" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>								
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn23" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">제조사와 규격을 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn113" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn113" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">인증서, 시험성적서 제출이 필요없음</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn33" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn33" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">필요시 이미 제조사에 서류가 구비되어 있음</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn43" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn43" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>																		
								</tr>
								<tr>
									<td class="bc" style="width: 14%;">필요시 해당 물품 제조와 더불어 발급 예정임</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn53" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn53" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">실행 담당자와 납기의 적절성 확인</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn63" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn63" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품장소(납지)가 과다하거나 격오지가 아님</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn73" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn73" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품조건(상차도, 도착도, 하차도) 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn83" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn83" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">납품시 추가비용 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn93" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn93" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>																
								</tr>
								<tr>
									<td class="bc" style="width: 14%;">입찰참가시 특이절차 여부</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn103" data-options="panelHeight:'auto'" style="width:50px;" readonly="readonly">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn103" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td class="bc" style="width: 14%;">지난 개찰결과를 확인함</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn143" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn143" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									
									<td class="bc" style="width: 14%;">실행업체의 신용도 분석</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_yn153" data-options="panelHeight:'auto'" style="width:50px;">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
									<td style="width: 3%;">
										<select class="easyui-combobox" id="risk_m_yn153" data-options="panelHeight:'auto'" style="width:50px;" disabled="disabled">
									        <option value="Y">Y</option>
									        <option value="N">N</option>
									        <option value="C">해당사항없음</option>
										</select>
									</td>
								</tr>
							</table>
							<table cellpadding="5" class="mytable3" style="margin-bottom:25px;">
								<tr>
									<td class="bc" style="width: 8%;">물품분류명</td>
									<td style="width: 15%;"><input id="tab5_stad_nm" name="tab5_stad_nm" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 8%;">물품분류번호</td>
									<td style="width: 15%;"><input id="tab5_stad_no" name="tab5_stad_no" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 8%;">과업기간</td>
									<td style="width: 15%;"><input id="tab_bid_term3" name="tab_bid_term3" class="easyui-textbox" style="width: 95%;" maxlength="1000" /></td>
									<td class="bc" style="width: 6%;">리스크</td>
									<td style="width: 10%;">
								        <select class="easyui-combobox" id="tab_bid_risk3" data-options="panelHeight:'auto'" style="width: 95%;">
									        <option value="001">상(관리 불가능한 수준)</option>
									        <option value="002">중(관리 가능한 수준)</option>
									        <option value="003">하(관리 불필요한 수준)</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="bc">과업내용</td>
									<td colspan="7" ><input id="tab_bid_cont3" name="tab_bid_cont3" class="easyui-textbox" style="width: 95%;" maxlength="1000" readonly="readonly"/></td>
								</tr>
								<tr>
									<td class="bc">심사총평</td>
									<td colspan="7" ><input id="tab_bid_tot_cont3" name="tab_bid_tot_cont3" class="easyui-textbox" style="width: 95%;" maxlength="1000" readonly="readonly"/></td>
								</tr>
								<tr>
									<td class="bc">특이사항</td>
									<td colspan="7" ><input id="tab_bid_sp_cont3" name="tab_bid_sp_cont3" class="easyui-textbox" style="width: 95%;" maxlength="1000" readonly="readonly"/></td>
								</tr>																					
							</table>
						</form>
						
						<script type="text/javascript">
							function onChgColumn6(){
								var base = $("#tab5_base_price").textbox('getValue');
								var column5 = $("#column53").numberbox("getValue");
								var s_range3 = $("#s_range3").numberbox("getValue");
								var e_range3 = $("#e_range3").numberbox("getValue");
								
								if(base.length>0){
									base = base.replaceAll(",","");

									var result = base * (column5/100)* (((s_range3/100) + (e_range3/100))/2);
									
									$("#column13").textbox("setValue",numberComma(result)); //투찰 기준금액
								}
								
							}
						</script>
						</div>
					</div>
					<div title="사전요청현황" style="padding:5px">
				        <table style="width: 100%;">
							<tr>
								<td class="bc">입찰마감일자</td>
								<td>
									<input class="easyui-datebox" id="bidStartDt5"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">
									- <input class="easyui-datebox" id="bidEndDt5"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">									
								</td>
								<td class="bc">공고</td>
								<td>
									<select class="easyui-combobox" id="searchBidType5" data-options="panelHeight:'auto'"  style="width:100px;">
									        <option value="1">공고번호</option>
									        <option value="2">공고명</option>
									</select>
									<input type="text" class="easyui-textbox" id="bidNoticeNo5" style="width: 120px;">
								</td>
								<td class="bc">담당자</td>
								<td><input id="userId5" class="easyui-combobox"
									data-options="
									method:'get',
							        valueField: 'user_id',
							        textField: 'user_nm',
							        width:100,
							        panelHeight:'auto',
							        data:jsonData2">
							        <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectList5()">조회</a>						        
								</td>			            
							</tr>
						</table>
						<div style="display: none;">
							<table class="easyui-datagrid"
									style="width:0px;height:0px;border: 0" 
									>
							</table>
						</div>
			            <table id="dg5" class="easyui-datagrid"
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
										                    if (row.color_type=='B'){
										                    	return 'background-color:#2f8cdd;color:#ffffff;';
										                    }
										                    if (row.color_type=='G'){
										                        return 'background-color:#7cd56c;color:#ffffff;';
										                    }
										              }">
			                <thead>
			                    <tr>
			                        <th data-options="field:'bid_notice_no',halign:'center',width:160,resizable:true,sortable:true">공고번호</th>
			                        <th data-options="field:'bid_notice_nm',align:'left',width:450,halign:'center',sortable:true" formatter="formatNoticeNm2">공고명</th>
			                        <th data-options="field:'bid_lic_reg_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">참가신청마감일시</th>
			                        <th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰마감일시</th>
			                        <th data-options="field:'pre_price',align:'right',width:120 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
			                        <th data-options="field:'user_nm',align:'center',halign:'center',width:60">담당자</th>
			                    </tr>
			                </thead>
			            </table>
			            <script>
				            var editIndex5 = undefined;
							function endEditing5(){
								if (editIndex5 == undefined){return true}
								if ($('#dg5').datagrid('validateRow', editIndex5)){
							 		$('#dg5').datagrid('endEdit', editIndex5);
									editIndex5 = undefined;
									return true;
								} else {
									return false;
								}
							}
							function onDblClickCell5(row) {
								selectView6(row.bid_notice_no);
								$('.tabs-title').filter(":eq(8)").parents('li').trigger("click");
							}
			            </script>
					</div>
					<div title="사전요청" style="padding:5px; margin-left:50px;">
						<div data-options="region:'west',collapsible:false" title="" style="width: 95%;">
						<input type="hidden" id="notice_no6" name="notice_no6">
						<input type="hidden" id="notice_cha_no6" name="notice_cha_no6">
						<input type="hidden" id="tab6_bid_end_dt" name="tab6_bid_end_dt">
						<input type="hidden" id="tab6_detail_goods_no" name="tab6_detail_goods_no">
						<input type="hidden" id="tab6_detail_goods_nm" name="tab6_detail_goods_nm">
							<table style="width: 100%;">
								<tr>
									<td class="bc">공고번호</td>
									<td>
										<input class="easyui-textbox" style="height:26px" id="tab6_bidNoticeNo">
										<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectView6('');">조회</a>
									</td>			
									<td align="right" id="mytableBtn4">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="post('send')">요청</a>		
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="post('')">저장</a>								
									</td>																						            
								</tr>
							</table>
							<table cellpadding="5" class="mytable4">
								<tr>
									<td class="bc" style="width: 20%;">공고번호</td>
									<td style="width: 30%;"><font id="tab6_bid_notice_no"></font></td>
									<td class="bc" style="width: 20%;">물품분류제한여부 (입찰참가 제한)</td>
									<td style="width: 30%;"><font id="tab6_goods_grp_limit_yn"></font></td>								
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">공고명</td>
									<td style="width: 30%;"><font id="tab6_bid_notice_nm"></font></td>
									<td class="bc" style="width: 20%;">제조여부</td>
									<td style="width: 30%;"><font id="tab6_product_yn"></font></td>
								</tr>						
								<tr>
									<td class="bc" style="width: 20%;">공고기관</td>
									<td style="width: 30%;"><font id="tab6_order_agency_nm"></font></td>
									<td class="bc" style="width: 20%;">업종제한</td>
									<td style="width: 30%;"><font id="tab6_permit_biz_type_info"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">수요기관</td>
									<td style="width: 30%;"><font id="tab6_demand_nm"></font></td>
									<td class="bc" style="width: 20%;">입찰일시</td>
									<td style="width: 30%;"><font id="tab6_bid_start_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">참가가능지역 (반드시 , 로 구분)</td>
									<td style="width: 30%;"><font id="tab6_use_area_info"></font></td>
									<td class="bc" style="width: 20%;">참가신청마감일시</td>
									<td style="width: 30%;"><font id="tab6_bid_lic_reg_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">계약방법</td>
									<td style="width: 30%;"><font id="tab6_contract_type_nm"></font></td>
									<td class="bc" style="width: 20%;">개찰일시</td>
									<td style="width: 30%;"><font id="tab6_bid_open_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">조달사이트</td>
									<td style="width: 30%;">
										<input id="tab6_bid_site" name="tab6_bid_site"
											class="easyui-combobox"
											data-options="
											method:'get',
											width:250,
                 							panelHeight:'auto',
									        valueField: 'cd',
									        textField: 'cd_nm',
									        data:jsonData3" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">담당자</td>
									<td style="width: 30%;"><font id="tab6_bidmanager"></font></td>
								</tr>								
							</table>							
							<table cellpadding="5" class="mytable4">
								<tr>
									<td class="bc" style="width: 20%;">추정가격</td>
									<td style="width: 30%;"><font id="tab6_pre_price"></font></td>
									<td class="bc" style="width: 20%;">예가범위</td>
									<td style="width: 30%;">
										<input id="s_range6" name="s_range6"
										class="easyui-textbox" data-options="width:50" readonly="readonly" />
										~
										<input id="e_range6" name="e_range6"
										class="easyui-textbox" data-options="width:50" readonly="readonly" /> %
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기초금액</td>
									<td style="width: 30%;"><input id="tab6_base_price" class="easyui-textbox" data-options="width:100" readonly="readonly" /></td>
									<td class="bc" style="width: 20%;">낙찰하한</td>
									<td style="width: 30%;"><input id="column56" name="column56" class="easyui-numberbox" data-options="precision:3,width:100" readonly="readonly"/> %</td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable4">
								<tr>
									<td class="bc" style="width: 20%;">공고원문</td>
									<td><font id="tab6_notice_spec_file"></font></td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable4">
								<tr>
									<td class="bc" style="width: 20%;">적격정보</td>
									<td style="width: 30%;">
										<input id="column26" name="column2"
													class="easyui-combobox"
													data-options="
													method:'get',
													width:250,
													panelHeight:'auto',		
											        valueField: 'cd',
											        textField: 'cd_nm',
											        data:jsonData4" readonly="readonly" />
									</td>
									<td class="bc" style="width: 20%;"></td>
									<td style="width: 30%;"></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기업구분</td>
									<td style="width: 30%;">
										<input id="column36" name="column36"
													class="easyui-combobox"
													data-options="
													method:'get',
													width:250,
													panelHeight:'auto',
											        valueField: 'cd',
											        textField: 'cd_nm',
													data:jsonData5" readonly="readonly" />
									</td>
									<td class="bc" style="width: 20%;"></td>
									<td style="width: 30%;"></td>
								</tr>																				
							</table>
							<h1><font id="mytable5">투찰사 리스트</font></h1>
							<div id="mytable6" data-options="region:'east',collapsible:false" title="투찰사 정보" style="width: 100%; height: 250px;">
								<table style="width: 100%">
									<tr>
										<td align="right">
											<!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onClick="sendBigo()">비고일괄등록</a> -->
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'"  onClick="getBusinessList()">투찰업체 추가</a>
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'"  onClick="delBusinessList()">투찰업체 삭제</a>
										</td>
									</tr>
								</table>
								<table id="bc6" class="easyui-datagrid"
										data-options="singleSelect:false,pagination:false,striped:true,
													  onClickCell:onClickCell6,
													  onBeforeEdit:onBeforeEdit,
													  remoteSort:false,
													  multiSort:false"
										style="width:100%;height: 85%;">
									<thead>
										<tr>
											<th data-options="field:'send_yn',checkbox:true"></th>
											<th data-options="field:'business_no',align:'center',halign:'center',sortable:true" width="70">No.</th>
											<th data-options="field:'company_nm',halign:'center',sortable:true" width="170">투찰업체명</th>
											<th data-options="field:'message_type',align:'center',halign:'center',sortable:true" width="70">종류</th>
											<th data-options="field:'message',align:'left',halign:'center',sortable:true" width="300">내용</th>
											<th data-options="field:'msg_send_dt',align:'left',halign:'center',sortable:true" width="180">메세지요청일</th>
											<th data-options="field:'msg_chk_dt',align:'left',halign:'center',sortable:true" width="180">요청확인</th>
											<th data-options="field:'bidmanager',align:'center',halign:'center',sortable:true" width="75">담당자</th>
											<th data-options="field:'mobile_no',align:'left',halign:'center',sortable:true" width="130">휴대폰번호</th>
											<th data-options="field:'email',align:'left',halign:'center',sortable:true" width="200">메일주소</th>
										</tr>
									</thead>
								</table>
								<script>
									function onBeforeEdit(index, row) {
										row.editing = true;
										$(this).datagrid('refreshRow', index);
									}																	
									var editIndex6 =  undefined;
									
									function endEditing6() {
										if (editIndex6 == undefined) {
											return true
										}
										if ($('#bc6').datagrid('validateRow', editIndex6)) {
											$('#bc6').datagrid('endEdit',
													editIndex6);
											editIndex6 = undefined;
											return true;
										} else {
											return false;
										}
									}
									
									function onClickCell6(index, field) {
										if (editIndex6 != index) {
											if (endEditing6()) {
												$('#bc6').datagrid('selectRow',index)
														.datagrid('beginEdit',index);
												var ed = $('#bc6').datagrid('getEditor',
																{
																	index : index,
																	field : field
																});
												if (ed) {
													($(ed.target).data('textbox') ? $(ed.target).textbox('textbox'): $(ed.target)).focus();
												}
												editIndex6 = index;
											} else {
												setTimeout(function() {
													$('#bc6').datagrid('selectRow',editIndex6);
												}, 0);
											}
										}
									}														
									function sendBigo(){

										$('#bigoMsg').textbox('setValue','');											
										$('#sendBigoDlg').dialog('open');
										
									}
									function sendBigoMsg(){
										
										var addData=$('#bc6').datagrid('getChecked');										
										
										$.messager.confirm('알림', '비고를 일괄등록 하시겠습니까?', function(r){
								            if (r){
								        		var effectRow = new Object();
							        			effectRow["bid_notice_no"] = $("#notice_no6").val();
							        			effectRow["bid_notice_cha_no"] = $("#notice_cha_no6").val();
							        			effectRow["bigo"] = $("#bigoMsg").textbox('getValue');
								        		
								        		if (addData.length) {
								        			effectRow["addData"] = JSON.stringify(addData);
								        		}
								        		
								        		$.post("<c:url value='/opening/sendBigoMsg.do'/>", effectRow, 
								        			function(rsp) {
									        			if(rsp.status){
									        				$.messager.alert("알림","저장하였습니다.");
									        				$('#bc6').datagrid('reload');
															$('#sendBigoDlg').dialog('close');
									        			}else{
										        			$.messager.alert("알림", "저장에러！");
									        				$('#bc6').datagrid('reload');
									        			}
									        		}, "JSON").error(function() {
									        			$.messager.alert("알림", "저장에러！");
								        		});
								            }
								        });
									}
									//tab4 투찰사 
									function sendBusiness(){

										$('#sendMessage2').textbox('setValue','');
										
							
										if($("#bc6").datagrid("getRows").length <= 0){
											$.messager.alert("알림", "요청할 투찰업체가 없습니다.");
											return;
										}
										if($("#bc6").datagrid("getChecked").length <= 0){
											$.messager.alert("알림", "요청할 투찰업체를 선택하지 않았습니다.");
											return;
										}
										$('#sendMessageDlg2').dialog('open');
										
									}
									
									function messageType(type){
										var message = ""
										if(type==2){
											message = "■ 입찰참가 신청 ■\n"+
											"공고번호 : "+($('#tab6_bid_notice_no').text().replace("상세보기",""))+"\n"+
											"공고명 : "+($('#tab6_bid_notice_nm').text())+"\n"+
											"수요기관 : "+($('#tab6_demand_nm').text())+"\n"+
											"입찰신청마감일시 : "+$("#tab6_bid_lic_reg_dt").text()+"\n"+
											"조달사이트 : "+$("#tab6_bid_site").combobox('getText');
										}else if(type==3){
											message = "■ 물품분류번호 등록 ■\n"+
											"물품분류번호 : "+$("#tab6_detail_goods_no").val()+"\n"+
											"물품명 : "+$("#tab6_detail_goods_nm").val()+"\n"+
											"등록마감일시 : "+$("#tab6_bid_lic_reg_dt").text()+"\n"+
											"조달사이트 : "+$("#tab6_bid_site").combobox('getText');
										}
										$('#sendMessage2').textbox('setValue',message);
									}
									
									function sendMessage2(type){
										var title;
										var title2;
										if(type=="email"){
											title ="메일을";
											title2 ="메일";
										}else if(type=="sms"){
											title ="SMS를";
											title2 ="SMS";
										}else{
											title ="메세지를";
											title2 ="메세지";
										}
										
										var message = $('#sendMessage2').textbox('getValue');
										if(message==null || message.length==0){
											$.messager.alert("알림", title2+" 문구를 등록하세요.");
											return;
										}
										
										var addData=$('#bc6').datagrid('getChecked');
										
										$.messager.confirm('알림', '업체에 '+title+' 발송하시겠습니까?', function(r){
								            if (r){
								            	if (endEditing6()){
									            	$('#sendMessageDlg2').dialog('close');
									        		
									        		var effectRow = new Object();
									        		
								        			effectRow["bid_notice_no"] = $("#notice_no6").val();
								        			effectRow["bid_notice_cha_no"] = $("#notice_cha_no6").val();							        		
									        		
									        		effectRow["message_type"] = type;
									        		if (addData.length) {
									        			effectRow["addData"] = JSON.stringify(addData);
									        		}
									        		effectRow["send_message"] = $("#sendMessage2").textbox('getValue');
									        		
									        		$.post("<c:url value='/opening/sendBusiness.do'/>", effectRow, 
									        			function(rsp) {
										        			if(rsp.status){
										        				$.messager.alert("알림", title+" 발송하였습니다.");
										        				$('#bc6').datagrid('reload');
										        			}else{
											        			$.messager.alert("알림", title2+"발송에러！");
										        				$('#bc6').datagrid('reload');
										        			}
										        		}, "JSON").error(function() {
										        			$.messager.alert("알림", title2+"발송에러！");
									        		});
								            	}
								            }
								        });
									}																																																																										
									
									function delBusinessList() {
										var addData = $('#bc6').datagrid('getChecked');
										
										if(addData==null || addData.length==0){
											$.messager.alert("알림", "투찰업체를 선택하세요.");
											return;
										}
										$.messager.confirm('알림', '투찰업체를 삭제하시겠습니까?', function(r){
								            if (r){
								            	var effectRow = new Object();
									   			effectRow["bid_notice_no"] = $("#notice_no6").val();
									   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no6").val();	
									    		effectRow["addData"] = JSON.stringify(addData);

									    		$.post("<c:url value='/opening/deleteBusinessList.do'/>", effectRow, function(rsp) {
									    			if(rsp.status){
									    				$.messager.alert("알림", "삭제하였습니다.");
									    				var rowIndex = 0;
														
														for(var i=0;i<addData.length;i++){		
															rowIndex = $("#bc6").datagrid("getRowIndex", addData[i]); 
															$('#bc6').datagrid('deleteRow',rowIndex);
														} 
									    			}
									    		}, "JSON").error(function() {
									    			$.messager.alert("알림", "삭제에러！");
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
		</div>
	</div>
	<div id="bidInfoDlg" class="easyui-dialog" title="공고 가져오기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 20%; height: 100px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">공고일</td>
				<td><input class="easyui-datebox" id="startDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser"></td>
				<td align="right">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getBidInfoApi()">갱신</a>
				</td>
			</tr>
		</table>
	</div>
	<!-- 견적요청 메세지 Dialog start -->
	<div id="sendMessageDlg" class="easyui-dialog" title="견적요청 보내기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 400px; padding: 10px">
		<input id="sendMessage1" name="sendMessage1" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 90%"> 
		<input type="hidden" id="message_seq" name="message_seq" />
		<div style="margin: 5px 0; vertical-align: top"></div>
		<div style="width: 100%" align="center">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage()">Email보내기</a>
		</div>
	</div>
	<!-- 견적요청 메세지 Dialog end -->
	<!-- 제조업체Dialog start -->
	<div id="manufactureList" class="easyui-dialog" title="제조업체 검색" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 70%; height: 500px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">업체명</td>
				<td>
					<input type="hidden" id="company_seq" name="company_seq" />
					<input type="text" class="easyui-textbox" id="s_business_nm" style="width: 120px;">
				</td>            
				<td align="right">
					<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectCompany('')">조회</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="$('#manufactureDlg').dialog('open');">업체등록</a>
				</td>
			</tr>
		</table>
		<table id="manufactureTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:false,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>			
					<th data-options="field:'company_nm',align:'left',halign:'center',width:140">업체명</th>
					<th data-options="field:'delegate_explain',align:'left',halign:'center',width:140">대표물품1</th>
					<th data-options="field:'delegate_explain2',align:'left',halign:'center',width:140">대표물품2</th>
					<th data-options="field:'delegate_explain3',align:'left',halign:'center',width:140">대표물품3</th>
					<th data-options="field:'delegate',align:'center',halign:'center',width:100">대표자명</th>
					<th data-options="field:'bidmanager',align:'center',halign:'center',width:350" formatter="formatManufactureNm">담당자</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 제조업체 Dialog end -->
	<!-- 제조업체 추가 Dialog start -->
	<div id="manufactureDlg" class="easyui-dialog" title="제조업체 추가"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 45%; height: 300px;">
		<div class="easyui-layout" style="width:100%;height:100%; border:0">
			<div data-options="region:'center'">
				<table style="width:100%;">
			        <tr>
			            <td width="60%" align="right">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save9()">저장</a>
			            </td>
			        </tr>
			    </table>
			 	<div class="easyui-panel" style="width:100%;padding:10px;border: 0">
			 		<table style="width: 100%">
							<tr>
									<td class="bc" style="width: 20%;">사업자번호</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="company_no_B"></td>
									<td class="bc" style="width: 20%;">기본주소</td>
									<td style="width: 30%;">
										<input id="address_B" class="easyui-combobox"
											data-options="
											method:'get',
									        valueField: 'cd',
									        textField: 'cd_nm',
									        width:100,
									        panelHeight:'auto',
									        data:jsonData6">
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">업체명</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="company_nm_B"></td>
									<td class="bc" style="width: 20%;">상세주소</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="address_detail_B"></td>
								</tr>						
								<tr>
									<td class="bc" style="width: 20%;">대표자명</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="delegate_B"></td>
									<td class="bc" style="width: 20%;">직위 / 담당자</td>
									<td style="width: 30%;">
										<input class="easyui-textbox" style="width:25%;height:26px" id="position_B"> /
										<input class="easyui-textbox" style="width:67%;height:26px" id="bidmanager_B">									
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">대표물품1</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="delegate_explain_B"></td>
									<td class="bc" style="width: 20%;">전화번호</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="phone_no_B"></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">대표물품2</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="delegate_explain2_B"></td>
									<td class="bc" style="width: 20%;">휴대폰번호</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="mobile_no_B"></td>
								</tr>	
								<tr>
									<td class="bc" style="width: 20%;">대표물품3</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="delegate_explain3_B"></td>
									<td class="bc" style="width: 20%;">이메일주소</td>
									<td style="width: 30%;"><input class="easyui-textbox" style="width:100%;height:26px" id="email_B"></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">견적형태</td>
									<td style="width: 30%;"><input type="checkbox" id="company_type_B1" name="company_type"/>직접견적<input type="checkbox" id="company_type_B2" name="company_type"/>정보견적</td>
									<td class="bc" style="width: 20%;">보류</td>
									<td style="width: 30%;"><input type="checkbox" id="unuse_yn_B" name="unuse_yn_B"/></td>
								</tr>				
					</table>							
			    </div>
			</div>
		</div>
	</div>
	<!-- 제조업체 추가 Dialog end -->
	<!-- 미등록 공고 추가 Dialog start -->
	<div id="unregDlg" class="easyui-dialog" title="공고추가"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 35%; height: 320px;">
		<div class="easyui-layout" style="width:100%;height:100%; border:0">
			<div data-options="region:'center'">
				<table style="width:100%;">
			        <tr>
			            <td width="60%" align="right">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save8()">저장</a>
			            </td>
			        </tr>
			    </table>
			 	<div class="easyui-panel" style="width:100%;padding:10px;border: 0">
			 		<table style="width: 100%">
							<tr>
								<td class="bc" width="150px">공고번호</td>
								<td>
									<input class="easyui-textbox" style="width:68%;height:26px" id="in_bid_notice_no"> -
									<input class="easyui-textbox" style="width:28%;height:26px" id="in_bid_notice_cha_no" maxlength="2">
								</td>
							</tr>
							<tr>
								<td class="bc" width="150px">공고명</td>
								<td>
									<select class="easyui-combobox" id="in_notice_type" data-options="panelHeight:'auto'" style="width:20%;">
										<option value="일반">일반</option>
								        <option value="긴급">긴급</option>
								        <option value="변경">변경</option>	
								        <option value="연기">연기</option>
								        <option value="재입찰">재입찰</option>									        
									</select>
									<input class="easyui-textbox" style="width:79%;height:26px" id="in_bid_notice_nm">
								</td>
							</tr>
							<tr>
								<td class="bc" width="150px">물품명</td>
								<td>
									<input class="easyui-textbox" style="width:100%;height:26px" id="in_detail_goods_nm">
								</td>
							</tr>	
							<tr>
								<td class="bc" width="150px">지역제한<br />(반드시,로 구분)</td>
								<td>
									<input class="easyui-textbox" style="width:100%;height:26px" id="in_use_area_info">
								</td>
							</tr>					
							<tr>
								<td class="bc" width="150px">참가신청마감일시</td>
								<td>
									<input class="easyui-datebox" id="in_bid_lic_reg_dt_y"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
									<input id="in_bid_lic_reg_dt_h" class="easyui-textbox" data-options="width:30" />:<input id="in_bid_lic_reg_dt_m" class="easyui-textbox" data-options="width:30" />
								</td>
							</tr>
							<tr>
								<td class="bc" width="150px">입찰마감일시</td>
								<td>
									<input class="easyui-datebox" id="in_bid_end_dt_y"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
									<input id="in_bid_end_dt_h" class="easyui-textbox" data-options="width:30" />:<input id="in_bid_end_dt_m" class="easyui-textbox" data-options="width:30" />
								</td>
							</tr>		
							<tr>
								<td class="bc" width="150px">추정가격</td>
								<td>
									<input class="easyui-textbox" style="width:100%;height:26px" id="in_pre_price">
								</td>
							</tr>						
					</table>							
			    </div>
			</div>
		</div>
	</div>
	<!-- 미등록 공고 추가 Dialog end -->
	<!--의견등록 Dialog start -->
	<div id="bigoInsertDlg" class="easyui-dialog" title="의견등록" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 400px; padding: 10px">
		<table style="width:100%;">
	        <tr>
	            <td width="60%" align="right" colspan="2">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save10()">저장</a>
	            </td>
	        </tr>
	        <tr>
	    		<td colspan="2">
	    			<div style="margin: 10px 0;">담당자 의견</div>
	    			<input id="bigo_column4" name="bigo_column4" class="easyui-textbox" data-options="multiline:true" style="width: 95%; height: 50px"/>
	    		</td> 
	        </tr>
	        <tr>
	        	<td colspan="2">
	        		<div style="margin: 10px 0;">감독관 의견</div>
	        		<input id="bigo_bigo" name="bigo_bigo" class="easyui-textbox" data-options="multiline:true" style="width: 95%; height: 50px"/>
	        	</td>
	        </tr>
	        <tr>
	        	<td style="width:50%">
	        		<div style="display:inline-block; margin: 10px 0;">진행단계</div>
	        		<select class="easyui-combobox" id="bigo_apply" data-options="panelHeight:'auto'" style="width:30%;">
						<option value="nvl">미진행</option>
						<option value="1">견적서 대기중</option>
				        <option value="0">Drop</option>
					</select>
	        	</td>
	        	<td style="width:50%">
	        		<div style="display:inline-block; margin: 10px 0;">분류</div>
	        		<select class="easyui-combobox" id="color_type" data-options="panelHeight:'auto'" style="width:30%;">
						<option value="">선택</option>
						<option value="B">파랑</option>
				        <option value="G">초록</option>
					</select>
	        	</td>
	        </tr>
	    </table>
	</div>
	<!-- 의견등록 Dialog end -->
	<!-- 투찰요청 메세지 Dialog start -->
	<div id="sendMessageDlg2" class="easyui-dialog" title="투찰정보" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 400px; padding: 10px">
		<div style="width: 100%" align="left">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(2)">참가신청요청</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(3)">물품번호등록요청</a>
		</div>
		<div style="margin: 5px 0; vertical-align: top"></div>
		<input id="sendMessage2" name="sendMessage2" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 80%"/> 
		<div style="margin: 5px 0; vertical-align: top"></div>
		<div style="width: 100%" align="center">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage2('email')">Email보내기</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage2('sms')">SMS보내기</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage2('msg')">메세지보내기</a>
		</div>
	</div>
	<!-- 투찰요청 메세지 Dialog end -->
	<!-- 비고 일괄등록 Dialog start -->
	<div id="sendBigoDlg" class="easyui-dialog" title="비고내용" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 120px; padding: 10px">
		<div style="margin: 5px 0; vertical-align: top"></div>
		<input id="bigoMsg" name="bigoMsg" class="easyui-textbox" style="width: 100%;"/> 
		<div style="margin: 5px 0; vertical-align: top"></div>
		<div style="width: 100%" align="center">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendBigoMsg()">일괄등록</a>
		</div>
	</div>
	<!--비고 일괄등록 Dialog end -->
	<!-- 투찰업체Dialog start -->
	<div id="businessList" class="easyui-dialog" title="투찰업체 검색" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 82%; height: 500px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">업체명</td>
				<td><input type="text" class="easyui-textbox" id="s_business_nm2" style="width: 100px;"></td>
				<td class="bc">업종</td>
	            <td>
	            	<input type="hidden" id="s_company_type2" name="s_company_type2" />
	                <input type="text" class="easyui-textbox"  id="s_company_type_nm2" style="width:100px;"  disabled="disabled"  >
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCompanyType2('s_company_type2', 's_company_type_nm2', 's')" ></a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchCompanyType2('s_company_type2', 's_company_type_nm2', 'c')" ></a>
	            </td>
	            <td class="bc">물품</td>
	            <td>
	            	<input type="hidden" id="s_goods_type2" name="s_goods_type2" />
	                <input type="text" class="easyui-textbox"  id="s_goods_type_nm2" style="width:100px;"  disabled="disabled"  >
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType2('s_goods_type2', 's_goods_type_nm2', 's')" ></a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType2('s_goods_type2', 's_goods_type_nm2', 'c')" ></a>
	            </td>
	            <td class="bc">적격정보</td>
	            <td>
	            	<input type="hidden" id="s_license_type2" name="s_license_type2" />
	                <input type="text" class="easyui-textbox"  id="s_license_type_nm2" style="width:100px;"  disabled="disabled"  >
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchLicenseType2('s_license_type2', 's_license_type_nm2', 's')" ></a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchLicenseType2('s_license_type2', 's_license_type_nm2', 'c')" ></a>
	            </td>
	            <td class="bc">지역</td>
	            <td>
	            	<input id="s_area_cd2" class="easyui-combobox"
								data-options="
								method:'get',
						        valueField: 'cd',
						        textField: 'cd_nm',
						        width:120,
						        panelHeight:'auto',
								data:jsonData7" style="width:100px;">
	                <input type="text" class="easyui-textbox"  id="s_area_txt2" style="width:80px;"   >
	            </td>
	            <td class="bc">기업규모</td>
	            <td>
	            	<input id="s_scale_cd2" class="easyui-combobox"
								data-options="
								method:'get',
						        valueField: 'cd',
						        textField: 'cd_nm',
						        width:120,
						        panelHeight:'auto',
								data:jsonData9" style="width:60px;">
	            </td>
	            <td class="bc">신용등급</td>
	            <td>
	            	<input id="s_credit_cd2" class="easyui-combobox"
								data-options="
								method:'get',
						        valueField: 'cd',
						        textField: 'cd_nm',
						        width:120,
						        panelHeight:'auto',
								data:jsonData8" style="width:60px;">
	            </td>
				<td>
					<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="getBusinessList()">조회</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" id="addTab4SaveBtn2" onclick="tab4_save3()">추가</a>
				</td>
			</tr>
		</table>
		<table id="businessTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:false,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th data-options="field:'business_no',align:'left',halign:'center',width:70">No.</th>
					<th data-options="field:'company_no',align:'left',halign:'center',width:150">사업자번호</th>
					<th data-options="field:'company_nm',align:'left',halign:'center',width:150">투찰사명</th>
					<th data-options="field:'delegate',align:'center',halign:'center',width:80">대표</th>
					<th data-options="field:'address_nm',halign:'center',max:10" width="100" >주소</th>
					<th data-options="field:'address_detail',halign:'center',max:10" width="250">상세주소</th>
					<th data-options="field:'bidmanager',align:'center',halign:'center',width:60">담당자</th>
					<th data-options="field:'scale_nm',align:'center',halign:'center',width:60">기업규모</th>
					<th data-options="field:'credit_nm',align:'center',halign:'center',width:60">신용등급</th>
					<th data-options="field:'mobile_no',align:'left',halign:'center',width:120">핸드폰</th>
					<th data-options="field:'fax_no',align:'left',halign:'center',width:120">팩스</th>
					<th data-options="field:'email',align:'left',halign:'center',width:200">메일주소</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 투찰업체 Dialog end -->
	<!-- 업종검색 Dialog start -->
	<div id="searchCompanyTypeDlg" class="easyui-dialog" title="세부업종찾기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">업종명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_company_txt2_1"  style="width:150px;" value=""  >
		            </td>
		        	<td class="bc">업종번호</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_company_txt3_1"  style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="getCompanyTypeTotalSearchList2()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="companyTypeChoice2()" >선택</a>
		            </td>
		        </tr>
		</table>
    	<table id="searchCompanyTypeTb" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						  singleSelect:true,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th data-options="field:'parent_cd',align:'left',width:100,halign:'center'" >업종그룹코드</th>
					<th data-options="field:'parent_nm',align:'left',width:100,halign:'center'" >업종그룹명</th>
					<th data-options="field:'cd',align:'left',width:100,halign:'center'" >업종코드</th>
					<th data-options="field:'cd_nm',align:'left',width:300,halign:'center'" >업종명</th>
				</tr>
			</thead>
		</table>
    </div>
    <!-- 업종검색 Dialog end -->
    <!-- 적격정보검색 Dialog start -->
	<div id="searchLicenseTypeDlg" class="easyui-dialog" title="적격정보" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:500px;height:450px;padding:10px">
    	<table style="width:100%">
		        <tr>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="licenseTypeChoice2()" >선택</a>
		            </td>
		        </tr>
		</table>
    	<table id="searchLicenseTypeTb" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						  singleSelect:true,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:false,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th data-options="field:'cd',align:'left',width:100,halign:'center'" >적격정보코드</th>
					<th data-options="field:'cd_nm',align:'left',width:300,halign:'center'" >적격정보명</th>
				</tr>
			</thead>
		</table>
    </div>
    <!-- 적격정보검색 Dialog end -->
    <!-- 물품검색 Dialog start -->
	<div id="searchGoodsDlg" class="easyui-dialog" title="세부품명찾기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">세부품명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_txt2_1"  style="width:150px;" value=""  >
		            </td>
		        	<td class="bc">세부품명번호</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_txt3_1"  style="width:150px;" value=""  >
		            	<input type="hidden" id="business_no" name="business_no"   style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="getGoodsTypeTotalSearchList2()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="goodsTypeChoice2()" >선택</a>
		            </td>
		        </tr>
		</table>
    	<table id="searchGoodsTb" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						  singleSelect:true,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true" >세부품명번호</th>
					<th data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true" >세부품명</th>
				</tr>
			</thead>
		</table>
    </div>
    <!-- 물품검색 Dialog end -->
   <%@ include file="/include/popup.jsp" %>
</body>
</html>