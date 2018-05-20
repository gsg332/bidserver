<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>개찰관리</title>
<%@ include file="/include/session.jsp" %>
<style>  
.mytable { border-collapse:collapse; margin-top:25px; width: 100%; padding: 10px;}  
.mytable th, .mytable td { border:1px solid black; }
h1 {margin-bottom:-20px;}
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
  	 jsonData2=json;
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
  	 jsonData3=json;
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
  	 jsonData4=json;
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
  	 jsonData5=json;
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
  	 jsonData6=json;
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
  	 jsonData7=json;
   }
});
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
  	 jsonData8=json;
   }
});
$(document).ready(function() {	
	<%
		String userid = (String)session.getAttribute("loginid");
		if(userid != null){
			if(Integer.parseInt((String)session.getAttribute("auth"))==1){ 
	%>
				$("#userId").combobox('setValue', '<%=userid%>');
				//$("#userId").combobox("disable");
				$("#userId5").combobox('setValue', '<%=userid%>');
				//$("#userId5").combobox("disable");
	<%
			}
		} 
	%>
	$(".mytable").hide();
	$("#mytable2").hide();
	$("#mytable3").hide();
	$("#mytableBtn").hide();
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
							selectView('');
							break;
						case 2:
							selectBidList5();
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
	selectBidList5();
}

//tab1 조회
function selectList(){
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
		url : "<c:url value='/opening/bidConfirmList.do'/>",
		queryParams : {
			bidStartDt :$('#bidStartDt').datebox('getValue'),
			bidEndDt : $('#bidEndDt').datebox('getValue'),
			bidNoticeNo : $('#searchBidType').combobox('getValue')=="1"?$('#bidNoticeNo').val():"",
			bidNoticeNm : $('#searchBidType').combobox('getValue')=="2"?$('#bidNoticeNo').val():"",
			userId : $('#userId').combogrid('getValue'),
			allYn :'Y'
		},
		onDblClickRow : function(index, row){
			onDblClickCell(row);
		},
		onLoadSuccess : function(json, param) {
			eventBtn2();
			eventBtn3(json);
		},
	});
}
function selectView(bid_notice_no){
	var bidNoticeNo = "";
	if(bid_notice_no == ""){
		if($("#tab_bidNoticeNo").val().trim() == ""){
			$.messager.alert("알림", "공고번호를 입력해주세요.");
			return;
		}else{
			bidNoticeNo = $("#tab_bidNoticeNo").val();
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
			   }else if(json.rows[0].status_cd3!="002"){
				   $.messager.alert("알림", "데이터가 존재하지 않습니다.");
			   }else{
				   $(".mytable").show(); 
				   $("#mytable2").show();
				   $("#mytable3").show();
				   $("#mytableBtn").show();
				   setBizInfoInit();				   
				   $("#notice_no").val(json.rows[0].bid_notice_no);
				   $("#notice_cha_no").val(json.rows[0].bid_notice_cha_no);
				   $("#tab_bidNoticeNo").textbox('setValue',json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   if(json.rows[0].manual_yn=="Y"){
					   $("#tab_bid_notice_no").text(json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no);
				   }else{
					   $("#tab_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+json.rows[0].notice_detail_link+"')\">"+json.rows[0].bid_notice_no+'-'+json.rows[0].bid_notice_cha_no+"</a>");
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
				   $("#tab_bid_notice_nm").append("<span style='color:"+color+";font-weight:bold;'>["+json.rows[0].notice_type+"]</span>"+json.rows[0].bid_notice_nm+"");
				   $("#tab_order_agency_nm").text(json.rows[0].order_agency_nm);
				   $("#tab_demand_nm").text(json.rows[0].demand_nm);
				   $("#tab_permit_biz_type_info").text(json.rows[0].permit_biz_type_info);
				   $("#tab_use_area_info").text(json.rows[0].use_area_info);
				   $("#tab_contract_type_nm").text(json.rows[0].contract_type_nm);				  
				   $("#tab_pre_price").text(numberComma(json.rows[0].pre_price));				   				   
				   $("#tab_base_price").textbox('setValue', numberComma(json.rows[0].base_price));
				   $('#s_range').textbox('setValue',json.rows[0].s_range);
				    $('#e_range').textbox('setValue',json.rows[0].e_range);
					   if(typeof(json.rows[0].product_yn)=="undefined"){
						  $("#tab_product_yn").text("N");
				   }else{
					   $("#tab_product_yn").text(numberComma(json.rows[0].product_yn));
				   }
				  
				   $("#tab_business_send_yn").combobox('setValue', json.rows[0].business_send_yn);
				   $("#tab_business_send_msg").textbox('setValue', json.rows[0].business_send_msg);
				   
				   $("#tab_notice_spec_file").append(bid_info_detail(json.rows[0])[0]);
				   $("#tab_bid_start_dt").text(bid_info_detail(json.rows[0])[1]);			
				   $("#tab_bid_end_dt").val(json.rows[0].bid_end_dt);
				   //$("#tab_bid_lic_reg_dt").text(bid_info_detail(json.rows[0]));
				   $("#tab_detail_goods_no").val(json.rows[0].detail_goods_no);				   
				   $("#tab_detail_goods_nm").val(json.rows[0].detail_goods_nm);
				   $("#tab_bidmanager").text(bid_info_detail(json.rows[0])[2]);
				   $("#tab_bid_open_dt").text(bid_info_detail(json.rows[0])[3]);
				   $("#tab_use_area_info").append(bid_info_detail(json.rows[0])[4]);
				   if(typeof(json.rows[0].permit_biz_type_info)!="undefined"){
					   if(bidLicense(json.rows[0].permit_biz_type_info,'') == ""){
						   	$("#tab_permit_biz_type_info").append("");   
					   }else{
					   		$("#tab_permit_biz_type_info").append(bidLicense(json.rows[0].permit_biz_type_info,''));
					   }
				   }
				   if(typeof(json.rows[0].goods_grp_limit_yn)=="undefined"){
 					  $("#tab_goods_grp_limit_yn").text("N");
				   }else{
					   $("#tab_goods_grp_limit_yn").text(json.rows[0].goods_grp_limit_yn);
				   }
				   $("#tab_bid_lic_reg_dt").text(formatDate(json.rows[0].bid_lic_reg_dt));   
				 	//개찰사용자등록정보
					getBidDtl(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
					
					//개찰 투찰사 정보
					setBizGrid(json.rows[0].bid_notice_no,json.rows[0].bid_notice_cha_no);
			   }
		   }
	});
}
function setBizInfoInit(){
	$("#notice_no").val('');
	$("#notice_cha_no").val('');
	$("#tab_bid_notice_no").empty();
	$("#tab_bid_notice_nm").empty();
	$("#tab_notice_spec_file").empty();
	$("#tab_permit_biz_type_info").empty();
	$("#tab_use_area_info").empty();
	$("#tab_business_send_yn").combobox('setValue', 'N');
	$("#tab_business_send_msg").textbox('setValue', '');
	$('#tab_bid_site').combobox('setValue', '');
	
	setBizGrid('','');
}
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

				    $('#s_range').textbox('setValue',json.rows[0].s_range);
				    $('#e_range').textbox('setValue',json.rows[0].e_range);
			   }else{
				   //$('#column1').textbox('setValue',"");
				    $('#column2').combobox('setValue',"");
				    $('#column3').combobox('setValue',"");
				    $('#column4').textbox('setValue',"");
				    $('#column5').textbox('setValue',"");

				    $('#s_range').textbox('setValue',"");
				    $('#e_range').textbox('setValue',"");
			   }
			  			   
			   if(json.bidSubj !=null){
				    $('#tab_bid_site').combobox('setValue', json.bidSubj.bid_site);
					
			   }			   	   		  	 
		   }
	});
}
function setBizGrid(bidNoticeNo, bidNoticeChaNo){
	$("#bc4").datagrid({
		method : "GET",
		url : "<c:url value='/opening/selectBusinessList.do'/>",
		queryParams : {
			bid_notice_no :bidNoticeNo,
			bid_notice_cha_no : bidNoticeChaNo
		},
		onLoadSuccess : function(row, param) {
			editIndex4 = undefined;
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
		info1 = "전국";
	}

	str[4] = info1;
	
	return str;
	
}
function getBusinessList(){
	$("#businessTb").datagrid({
		method : "GET",
		url : "<c:url value='/opening/businessList.do'/>",
		queryParams : {
			bid_notice_no : $("#notice_no").val(),
			bid_notice_cha_no : $("#notice_cha_no").val(),
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
function selectBidList5(){
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
		url : "<c:url value='/opening/bidOpenResultList.do'/>",
		queryParams : {
			searchDateType :$('#searchDateType5').combobox('getValue'),
			bidStartDt :$('#bidStartDt5').datebox('getValue'),
			bidEndDt : $('#bidEndDt5').datebox('getValue'),
			bidNoticeNo : $('#searchBidType5').combobox('getValue')=="1"?$('#bidNoticeNo5').val():"",
			bidNoticeNm : $('#searchBidType5').combobox('getValue')=="2"?$('#bidNoticeNo5').val():"",
			bidAreaNm : $('#bidAreaNm5').val(),
			bidGoodsNm : $('#bidGoodsNm5').val(),
			bidDemandNm : $('#bidDemandNm5').val(),
			bidBigo : $('#bidStepNm5').combobox('getValue'),
			userId : $('#userId5').combogrid('getValue'),
			allYn :'Y'
		},
		onLoadSuccess : function(row, param) {
			eventBtn();
			if(row.rows.length==0){
				setBizInfoInit5();
			}else{
				$('#dg5').datagrid('selectRow', 0);
				$('#dg5').datagrid('fixColumnSize');
			}
		},
		onSelect : function(index, row){
			setBizInfo5(row);
		},
	});
}
function eventBtn() {
	 $('#dg5').datagrid('getPanel').find("[type='report_type']").each(function(index){
			$(this).linkbutton({
				onClick:function(){
					var bid_notice_no = $(this).attr('val');				
					setOpenResult(bid_notice_no, index);
				}
			})
		});
}
function eventBtn2() {
	 $('#dg').datagrid('getPanel').find("[type='range_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var row = $("#dg").datagrid("selectRow",index);
				getRange();
			}
		})
	});
}
function eventBtn3(json) {
	$('#dg').datagrid('getPanel').find("[type='estimate_report']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var row = $("#dg").datagrid("selectRow",index);
				getEstimateReport(json.rows[index]);
			}
		})
	});
}

function setReportInfoInit(estimateReportInfoRow){
	$("#manufactureList #tab_bid_notice_no").empty();
	$("#manufactureList #tab_bid_notice_nm").empty();
	$("#manufactureList #tab_noti_dt").empty();
	$("#manufactureList #tab_order_agency_nm").empty();
	$("#manufactureList #tab_bid_demand_nm").empty();
	$("#manufactureList #tab_permit_biz_type_info").empty();
	$("#manufactureList #tab_use_area_info").empty();
	$("#manufactureList #tab_bid_start_dt").empty();
	$("#manufactureList #tab_bid_end_dt").empty();
	$("#manufactureList #tab_bid_lic_reg_dt").empty();
	$("#manufactureList #tab_bid_open_dt").empty();
	$("#manufactureList #tab_bid_cont_demand").empty();
	$("#manufactureList #tab_nation_bid_yn").empty();
	$("#manufactureList #tab_pre_price").empty();
	$("#manufactureList #tab_base_price").empty();
	$("#manufactureList #tab_bid_success").empty();
	$("#manufactureList #tab_notice_spec_form1").empty();
	$("#manufactureList #tab_notice_spec_form2").empty();
	$("#manufactureList #tab_notice_spec_form3").empty();
	$("#manufactureList #tab_notice_spec_form4").empty();
	$("#manufactureList #tab_notice_spec_form5").empty();
	$("#manufactureList #tab_notice_spec_form6").empty();
	$("#manufactureList #tab_notice_spec_form7").empty();
	$("#manufactureList #tab_notice_spec_form8").empty();
	$("#manufactureList #tab_notice_spec_form9").empty();
	$("#manufactureList #tab_notice_spec_form10").empty();
	$('#manufactureList #tab_column1').empty();
	$('#manufactureList #tab_column2').empty();
	$('#manufactureList #tab_column3').empty();
	$('#manufactureList #tab_column5').empty();
	
    setReportBidList('','',estimateReportInfoRow);
}

function setReportInfo(row){
	setReportInfoInit(row);
	cleanSubject();
	
	$("#manufactureList #tab_bid_notice_no").text(row.bid_notice_no+"-"+row.bid_notice_cha_no);
	$("#manufactureList #tab_bid_notice_nm").text(row.bid_notice_nm);
	$("#manufactureList #tab_noti_dt").text(formatDate(row.noti_dt));
	$("#manufactureList #tab_order_agency_nm").text(row.order_agency_nm);
	$("#manufactureList #tab_bid_demand_nm").text(row.demand_nm);
	$("#manufactureList #tab_permit_biz_type_info").text(row.permit_biz_type_info);
	$("#manufactureList #tab_use_area_info").text(row.use_area_info);
	$("#manufactureList #tab_bid_start_dt").text(formatDate(row.bid_start_dt));
	$("#manufactureList #tab_bid_end_dt").text(formatDate(row.bid_end_dt));
	$("#manufactureList #tab_bid_lic_reg_dt").text(formatDate(row.bid_lic_reg_dt));
	$("#manufactureList #tab_bid_open_dt").text(formatDate(row.bid_open_dt));
	$("#manufactureList #tab_bid_cont_demand").text(row.contract_type_nm);
	$("#manufactureList #tab_nation_bid_yn").text(row.nation_bid_yn);
	$("#manufactureList #tab_pre_price").empty();
	$("#manufactureList #tab_pre_price").append(numberComma(row.pre_price));
	$("#manufactureList #tab_base_price").empty();
	$("#manufactureList #tab_base_price").append(numberComma(row.base_price));
	$("#manufactureList #tab_bid_success").text(row.bid_success);
	$("#manufactureList #tab_notice_spec_form1").text("");
	$("#manufactureList #tab_notice_spec_form2").text("");
	$("#manufactureList #tab_notice_spec_form3").text("");
	$("#manufactureList #tab_notice_spec_form4").text("");
	$("#manufactureList #tab_notice_spec_form5").text("");
	$("#manufactureList #tab_notice_spec_form6").text("");
	$("#manufactureList #tab_notice_spec_form7").text("");
	$("#manufactureList #tab_notice_spec_form8").text("");
	$("#manufactureList #tab_notice_spec_form9").text("");
	$("#manufactureList #tab_notice_spec_form10").text("");
	
	if(row.notice_spec_file_nm1==null) $("#manufactureList #div_notice_spec_form1").css("display","none");
	if(row.notice_spec_file_nm2==null) $("#manufactureList #div_notice_spec_form2").css("display","none");
	if(row.notice_spec_file_nm3==null) $("#manufactureList #div_notice_spec_form3").css("display","none");
	if(row.notice_spec_file_nm4==null) $("#manufactureList #div_notice_spec_form4").css("display","none");
	if(row.notice_spec_file_nm5==null) $("#manufactureList #div_notice_spec_form5").css("display","none");
	if(row.notice_spec_file_nm6==null) $("#manufactureList #div_notice_spec_form6").css("display","none");
	if(row.notice_spec_file_nm7==null) $("#manufactureList #div_notice_spec_form7").css("display","none");
	if(row.notice_spec_file_nm8==null) $("#manufactureList #div_notice_spec_form8").css("display","none");
	if(row.notice_spec_file_nm9==null) $("#manufactureList #div_notice_spec_form9").css("display","none");
	if(row.notice_spec_file_nm10==null) $("#manufactureList #div_notice_spec_form10").css("display","none");

	if(row.notice_spec_file_nm1!=null) $("#manufactureList #div_notice_spec_form1").css("display","");
	if(row.notice_spec_file_nm2!=null) $("#manufactureList #div_notice_spec_form2").css("display","");
	if(row.notice_spec_file_nm3!=null) $("#manufactureList #div_notice_spec_form3").css("display","");
	if(row.notice_spec_file_nm4!=null) $("#manufactureList #div_notice_spec_form4").css("display","");
	if(row.notice_spec_file_nm5!=null) $("#manufactureList #div_notice_spec_form5").css("display","");
	if(row.notice_spec_file_nm6!=null) $("#manufactureList #div_notice_spec_form6").css("display","");
	if(row.notice_spec_file_nm7!=null) $("#manufactureList #div_notice_spec_form7").css("display","");
	if(row.notice_spec_file_nm8!=null) $("#manufactureList #div_notice_spec_form8").css("display","");
	if(row.notice_spec_file_nm9!=null) $("#manufactureList #div_notice_spec_form9").css("display","");
	if(row.notice_spec_file_nm10!=null) $("#manufactureList #div_notice_spec_form10").css("display","");
	
	$("#manufactureList #tab_notice_spec_form1").text(row.notice_spec_file_nm1);
	$("#manufactureList #tab_notice_spec_form1").prop('href',row.notice_spec_form1);
	$("#manufactureList #tab_notice_spec_form2").text(row.notice_spec_file_nm2);
	$("#manufactureList #tab_notice_spec_form2").prop('href',row.notice_spec_form2);
	$("#manufactureList #tab_notice_spec_form3").text(row.notice_spec_file_nm3);
	$("#manufactureList #tab_notice_spec_form3").prop('href',row.notice_spec_form3);
	$("#manufactureList #tab_notice_spec_form4").text(row.notice_spec_file_nm4);
	$("#manufactureList #tab_notice_spec_form4").prop('href',row.notice_spec_form4);
	$("#manufactureList #tab_notice_spec_form5").text(row.notice_spec_file_nm5);
	$("#manufactureList #tab_notice_spec_form5").prop('href',row.notice_spec_form5);
	$("#manufactureList #tab_notice_spec_form6").text(row.notice_spec_file_nm6);
	$("#manufactureList #tab_notice_spec_form6").prop('href',row.notice_spec_form6);
	$("#manufactureList #tab_notice_spec_form7").text(row.notice_spec_file_nm7);
	$("#manufactureList #tab_notice_spec_form7").prop('href',row.notice_spec_form7);
	$("#manufactureList #tab_notice_spec_form8").text(row.notice_spec_file_nm8);
	$("#manufactureList #tab_notice_spec_form8").prop('href',row.notice_spec_form8);
	$("#manufactureList #tab_notice_spec_form9").text(row.notice_spec_file_nm9);
	$("#manufactureList #tab_notice_spec_form9").prop('href',row.notice_spec_form9);
	$("#manufactureList #tab_notice_spec_form10").text(row.notice_spec_file_nm10);
	$("#manufactureList #tab_notice_spec_form10").prop('href',row.notice_spec_form10);
	
	$("#manufactureList #file_id").filebox("setValue","");
	$("#manufactureList #file_id").textbox("setValue",row.file_nm);
	$('#manufactureList #file_link').unbind('click',null);
	$('#manufactureList #file_remove').unbind('click',null);
	
	$('#manufactureList #file_link').bind('click', function(){
		if($("#manufactureList #file_id").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#manufactureList #file_remove').bind('click', function(){
		if($("#file_id").textbox("getText").length>0){
			$("#file_id").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	
	//입찰사용자등록정보
	//getReportDtl(row.bid_notice_no,row.bid_notice_cha_no);
	
	//입찰 제조사 정보
	setReportBidList(row.bid_notice_no,row.bid_notice_cha_no, row);
}

function cleanSubject(){
	$("#manufactureList #bid_cont").textbox('setValue',"");
	$("#manufactureList #bid_term").textbox('setValue',"");
	$("#manufactureList #bid_stad_nm").textbox('setValue',"");
	$("#manufactureList #bid_stad_no").textbox('setValue',"");
	$("#manufactureList #bid_stock_issue_yn").textbox('setValue',"");
	$("#manufactureList #bid_num_of_days").textbox('setValue',"");
	$("#manufactureList #bid_sp_cont").textbox('setValue',"");
	$("#manufactureList #bid_tot_cont").textbox('setValue',"");
    $('#manufactureList #bid_site').combobox('setValue',"");
    $('#manufactureList #bid_risk').combobox('setValue',"");

    $('#manufactureList #risk_yn1').combobox('setValue',"");
    $('#manufactureList #risk_yn2').combobox('setValue',"");
    $('#manufactureList #risk_yn3').combobox('setValue',"");
    $('#manufactureList #risk_yn4').combobox('setValue',"");
    $('#manufactureList #risk_yn5').combobox('setValue',"");
    $('#manufactureList #risk_yn6').combobox('setValue',"");
	$("#manufactureList #risk_yn7").combobox('setValue',"");
    $('#manufactureList #risk_yn8').combobox('setValue',"");
    $('#manufactureList #risk_yn9').combobox('setValue',"");
    $('#manufactureList #risk_yn10').combobox('setValue',"");
    $('#manufactureList #risk_yn11').combobox('setValue',"");
    $('#manufactureList #risk_yn14').combobox('setValue',"");
	$("#manufactureList #risk_yn15").combobox('setValue',"");
}

function setDefaultComboBoxValue(){
    $('#manufactureList #risk_yn1').combobox('setValue',"Y");
    $('#manufactureList #risk_yn2').combobox('setValue',"Y");
    $('#manufactureList #risk_yn3').combobox('setValue',"Y");
    $('#manufactureList #risk_yn4').combobox('setValue',"Y");
    $('#manufactureList #risk_yn5').combobox('setValue',"Y");
    $('#manufactureList #risk_yn6').combobox('setValue',"Y");
	$("#manufactureList #risk_yn7").combobox('setValue',"Y");
    $('#manufactureList #risk_yn8').combobox('setValue',"Y");
    $('#manufactureList #risk_yn9').combobox('setValue',"Y");
    $('#manufactureList #risk_yn10').combobox('setValue',"Y");
    $('#manufactureList #risk_yn11').combobox('setValue',"Y");
    $('#manufactureList #risk_yn14').combobox('setValue',"Y");
	$("#manufactureList #risk_yn15").combobox('setValue',"Y");
}

function getReportDtl(bidNoticeNo, bidNoticeChaNo, estimateReportInfoRow){
	
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
				    $('#manufactureList #tab_column1').text(numberComma(json.rows[0].column1));
				    $('#manufactureList #tab_column2').text(json.rows[0].column2_nm);
					$('#manufactureList #tab_column3').text(json.rows[0].column3_nm);
					$("#manufactureList #apply_comment1").textbox("setValue",json.rows[0].column4);
				    $('#manufactureList #tab_column5').text(json.rows[0].column5);

				    onChgColumn1(json.rows[0], estimateReportInfoRow);
			   }
			   
			   if(json.bidSubj !=null){
				    $('#manufactureList #bid_site').combobox("setValue",json.bidSubj.bid_site);
				    $('#manufactureList #bid_risk').combobox("setValue",json.bidSubj.bid_risk);
					$('#manufactureList #bid_term').textbox("setValue",json.bidSubj.bid_term);
					$("#manufactureList #bid_stad_nm").textbox("setValue",json.bidSubj.detail_goods_nm);
					$("#manufactureList #bid_stad_no").textbox("setValue",json.bidSubj.detail_goods_no);
					$("#manufactureList #bid_stock_issue_yn").textbox("setValue",json.bidSubj.bid_stock_issue_yn);
					$("#manufactureList #bid_num_of_days").textbox("setValue",json.bidSubj.bid_num_of_days);
					$('#manufactureList #bid_cont').textbox("setValue",json.bidSubj.bid_cont);
					$('#manufactureList #bid_sp_cont').textbox("setValue",json.bidSubj.bid_sp_cont);
					$('#manufactureList #bid_tot_cont').textbox("setValue",json.bidSubj.bid_tot_cont);
			   }

			   if(json.bidRisk !=null){
				    $('#manufactureList #risk_yn1').combobox("setValue",json.bidRisk.risk_yn1);
				    $('#manufactureList #risk_yn2').combobox("setValue",json.bidRisk.risk_yn2);
				    $('#manufactureList #risk_yn3').combobox("setValue",json.bidRisk.risk_yn3);
				    $('#manufactureList #risk_yn4').combobox("setValue",json.bidRisk.risk_yn4);
				    $('#manufactureList #risk_yn5').combobox("setValue",json.bidRisk.risk_yn5);
				    $('#manufactureList #risk_yn6').combobox("setValue",json.bidRisk.risk_yn6);
				    $('#manufactureList #risk_yn7').combobox("setValue",json.bidRisk.risk_yn7);
				    $('#manufactureList #risk_yn8').combobox("setValue",json.bidRisk.risk_yn8);
				    $('#manufactureList #risk_yn9').combobox("setValue",json.bidRisk.risk_yn9);
				    $('#manufactureList #risk_yn10').combobox("setValue",json.bidRisk.risk_yn10);
				    $('#manufactureList #risk_yn11').combobox("setValue",json.bidRisk.risk_yn11);
				    $('#manufactureList #risk_yn14').combobox("setValue",json.bidRisk.risk_yn14);
				    $('#manufactureList #risk_yn15').combobox("setValue",json.bidRisk.risk_yn15);
			   }
		   }
	});
}

//제조사 조회
function setReportBidList(bidNoticeNo, bidNoticeChaNo, estimateReportInfoRow){
	$("#bc3_1").datagrid({
		method : "GET",
		url : "<c:url value='/bid/selectEstimateList.do'/>",
		queryParams : {
			bid_notice_no :bidNoticeNo,
			bid_notice_cha_no : bidNoticeChaNo,
		},
		onLoadSuccess : function(row, param) {
			if(bidNoticeNo && bidNoticeChaNo){
				getReportDtl(bidNoticeNo,bidNoticeChaNo, estimateReportInfoRow);
			}else{
				setDefaultComboBoxValue();
			}
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
}

function setBizInfoInit5(){
	$("#tab5_detal1").empty();
	$("#tab5_detal2").empty();
	$("#tab5_detal3").empty();
	$('#tab5_rank').datagrid('loadData', []);
	$('#tab5_value').datagrid('loadData', []);
}

function setBizInfo5(row){
	setBizInfoInit5();
	if(row.bid_step_type=="개찰완료"){
		$("#tab5_detal1").append(bid_result_info_detail1(row));
		selectBidResultRank(row);
		selectBidResultValue(row);
	}else if(row.bid_step_type=="유찰"){
		selectBidResultRank(row);
	}else if(row.bid_step_type=="재입찰"){
		selectBidResultRank(row);
		selectBidResultValue(row);
	}
}
function selectBidResultRank(row){
	
	if(row.bid_step_type=="개찰완료"){
		$("#tab5_rank").datagrid({
			method : "GET",
			url : "<c:url value='/opening/bidOpenResultDetail.do'/>",
			queryParams : {
				bid_step_type : row.bid_step_type,
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				bid_biz_re_seq_no : row.bid_biz_re_seq_no
			},
			onLoadSuccess : function(row, param) {
			}
		});
	}else if(row.bid_step_type=="유찰"){
		$.ajax({ 
		    type: "GET"
		   ,url: "<c:url value='/opening/bidOpenResultDetail.do'/>"
		   ,async: false 
		   ,data : {
			    bid_step_type : row.bid_step_type,
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				bid_biz_re_seq_no : row.bid_biz_re_seq_no
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				    $("#tab5_detal2").append(bid_result_info_detail2(json.rows[0].non_cont_reason));
			   }else{
				    $('#tab5_detal2').empty();
			   }
		   }
		});
	}else if(row.bid_step_type=="재입찰"){
		$.ajax({ 
		    type: "GET"
		   ,url: "<c:url value='/opening/bidOpenResultDetail.do'/>"
		   ,async: false 
		   ,data : {
			    bid_step_type : row.bid_step_type+"M",
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				bid_biz_re_seq_no : row.bid_biz_re_seq_no
			}
		   ,dataType: "json"
		   ,success:function(json){
			   if(json.rows.length>0){
				    $("#tab5_detal3").append(bid_result_info_detail3(json.rows[0]));
			   }else{
				    $('#tab5_detal3').empty();
			   }
		   }
		});
		
		$("#tab5_rank").datagrid({
			method : "GET",
			url : "<c:url value='/opening/bidOpenResultDetail.do'/>",
			queryParams : {
				bid_step_type : row.bid_step_type,
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				bid_biz_re_seq_no : row.bid_biz_re_seq_no
			},
			onLoadSuccess : function(row, param) {
			}
		});
	}
	
}
function selectBidResultValue(row){
	
	if(row.bid_step_type=="개찰완료"){
		$("#tab5_value").datagrid({
			method : "GET",
			url : "<c:url value='/opening/bidOpenResultPriceDetail.do'/>",
			queryParams : {
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				bid_biz_re_seq_no : row.bid_biz_re_seq_no
			},
			onLoadSuccess : function(row, param) {
			}
		});
	}else if(row.bid_step_type=="유찰"){
	}else if(row.bid_step_type=="재입찰"){
		$("#tab5_value").datagrid({
			method : "GET",
			url : "<c:url value='/opening/bidOpenResultPriceDetail.do'/>",
			queryParams : {
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				bid_biz_re_seq_no : row.bid_biz_re_seq_no
			},
			onLoadSuccess : function(row, param) {
			}
		});
	}
	
}
function setOpenResult(bid_notice_no, index){
	$.ajax({ 
	    type: "POST"
	   ,url: "<c:url value='/opening/updateBidResult.do'/>"
	   ,async: false 
	   ,data : {
			bid_notice_no : bid_notice_no
		}
	   ,dataType: "json"
	   ,success:function(json){
		   var row = $("#dg5").datagrid("selectRow",index);
	   }
	});
}
//개찰결과탭 개찰결과갱신
function getBidResultInfoApi(){
	var startDt = $('#resultStartDt').datebox('getValue').replaceAll("-","");
	if(startDt.length==0){
		$.messager.alert("알림", "개찰일을 입력하세요.");
		return;
	}
	
	$.messager.confirm('알림', "해당일의 개찰결과를 가져오시겠습니까?", function(r){
        if (r){
			var effectRow = new Object();
			var win = $.messager.progress({
		            title:'개찰결과 가져오기',
		            msg:'데이터 처리중입니다.<br/>잠시만 기다려주세요...'
		        });
			
			effectRow["startDt"] = startDt;

			$.post("<c:url value='/opening/getBidResultInfoApi.do'/>", effectRow, function(rsp) {
				if(rsp.status){
					selectBidList5();
					$('#bidResultInfoDlg').dialog('close');
					 $.messager.progress('close');
					 $.messager.alert("알림", "갱신되었습니다.");
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "API에러！");
			});
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
		var msgData=$('#bc4').datagrid('getRows');
		for(var j=0;j<msgData.length;j++){		
   			if(addData[i].business_no == msgData[j].business_no){
   				isNo = true;
   			}
		}
		if(!isNo){
			$('#bc4').datagrid('insertRow',{
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
function save2(type) {
	var addData= "";
	if(type=="send"){
		addData=$('#bc4').datagrid('getRows');
		if (endEditing4()){
    		var effectRow = new Object();
   			effectRow["bid_notice_no"] = $("#notice_no").val();
   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no").val();
   			effectRow["business_send_yn"] = $("#tab_business_send_yn").combobox('getValue');
   			effectRow["business_send_msg"] = $("#tab_business_send_msg").textbox('getValue');
   			
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
		addData=$('#bc4').datagrid('getRows');
		if (endEditing4()){
    		var effectRow = new Object();
   			effectRow["bid_notice_no"] = $("#notice_no").val();
   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no").val();
   			effectRow["business_send_yn"] = $("#tab_business_send_yn").combobox('getValue');
   			effectRow["business_send_msg"] = $("#tab_business_send_msg").textbox('getValue');
   			
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
		addData=$('#bc4').datagrid('getRows');
		var message = "";
		if(addData==null || addData.length==0){
			message = "선택하신 투찰업체가 없습니다. 그래도 저장하시겠습니까?";
		}else{
			message = "저장하시겠습니까?";
		}
		$.messager.confirm('알림', message, function(r){
	        if (r){		
	        	if (endEditing4()){
		    		var effectRow = new Object();
		   			effectRow["bid_notice_no"] = $("#notice_no").val();
		   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no").val();
		   			effectRow["business_send_yn"] = $("#tab_business_send_yn").combobox('getValue');
		   			effectRow["business_send_msg"] = $("#tab_business_send_msg").textbox('getValue');
		    		effectRow["addData"] = JSON.stringify(addData);	
		    		
		    		$.post("<c:url value='/opening/updateBusinessList.do'/>", effectRow, function(rsp) {
		    			if(rsp.status){
		    				$.messager.alert("알림", "저장하였습니다.");
		    				selectView($("#notice_no").val()+"-"+$("#notice_cha_no").val());
		    			}
		    		}, "JSON").error(function() {
		    			$.messager.alert("알림", "저장에러！");
		    		});
	        	}
	        }
	        
		});
	}
}
function searchCompanyType(cd, cd_nm, type){
	searchIdName = $("#"+cd);
	searchNmName = $("#"+cd_nm);
	
	$("#search_company_txt2_1").textbox("setValue","");
	$("#search_company_txt3_1").textbox("setValue","");

	if(type=='s'){
		getCompanyTypeTotalSearchList();
	}else if(type=='c'){
		searchIdName.val("");
		searchNmName.textbox('setValue',"");
	}
	
}
function getCompanyTypeTotalSearchList(){
	
	$("#searchCompanyTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/companyTypeTotalList.do'/>",
		queryParams : {
			searchTxt2 : $("#search_company_txt2_1").textbox("getValue"),
			searchTxt3 : $("#search_company_txt3_1").textbox("getValue")
		},
		onDblClickRow : function(index, row){
			companyTypeChoice();
		}
	});
	
	$('#searchCompanyTypeDlg').dialog('open');
	
}
function companyTypeChoice(){
	var row = $("#searchCompanyTypeTb").datagrid('getSelected');
	
	searchIdName.val(row.cd);
	searchNmName.textbox('setValue',row.cd_nm);
	
	$('#searchCompanyTypeDlg').dialog('close');
}
function searchLicenseType(cd, cd_nm, type){
	searchIdName = $("#"+cd);
	searchNmName = $("#"+cd_nm);

	if(type=='s'){
		getLicenseTypeTotalSearchList();
	}else if(type=='c'){
		searchIdName.val("");
		searchNmName.textbox('setValue',"");
	}
	
}
function getLicenseTypeTotalSearchList(){
	
	$("#searchLicenseTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/licenseTypeTotalList.do'/>",
		queryParams : {
		},
		onDblClickRow : function(index, row){
			licenseTypeChoice();
		}
	});
	
	$('#searchLicenseTypeDlg').dialog('open');
	
}
function licenseTypeChoice(){
	var row = $("#searchLicenseTypeTb").datagrid('getSelected');
	
	searchIdName.val(row.cd);
	searchNmName.textbox('setValue',row.cd_nm);
	
	$('#searchLicenseTypeDlg').dialog('close');
}
function searchGoodsType(cd, cd_nm, type){
	searchIdName = $("#"+cd);
	searchNmName = $("#"+cd_nm);

	$("#search_goods_txt2_1").textbox("setValue","");
	$("#search_goods_txt3_1").textbox("setValue","");
	
	if(type=='s'){
		getGoodsTypeTotalSearchList();
	}else if(type=='c'){
		searchIdName.val("");
		searchNmName.textbox('setValue',"");
	}
	
}
function getGoodsTypeTotalSearchList(){
	
	$("#searchGoodsTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsTypeTotalList.do'/>",
		queryParams : {
			searchTxt2 : $("#search_goods_txt2_1").textbox("getValue"),
			searchTxt3 : $("#search_goods_txt3_1").textbox("getValue")
		},
		onDblClickRow : function(index, row){
			goodsTypeChoice();
		}
	});
	
	$('#searchGoodsDlg').dialog('open');
}
function goodsTypeChoice(){
	var row = $("#searchGoodsTb").datagrid('getSelected');
	
	searchIdName.val(row.goods_no);
	searchNmName.textbox('setValue',row.goods_nm);
	
	$('#searchGoodsDlg').dialog('close');
}
function getRange(){
	
	var row = $("#dg").datagrid('getSelected');
	
	if(!row){
		$.messager.alert("알림", "공고를 선택하세요.");
		return;
	}
	
	 $.ajax({ 
		    type: "POST"
		   ,url: "<c:url value='/opening/getBidRangeDtl.do'/>"
		   ,async: false 
		   ,data : {
			   bid_notice_no :row.bid_notice_no,
			   bid_notice_cha_no :row.bid_notice_cha_no
			}
		   ,dataType: "json"
		   ,success:function(json){
			   $("input[name=range]").prop("checked",false);
			   if(json.rows.length>0){
				   
				   for(var i=0;i<json.rows.length;i++){
					   $("input[name=range][value='"+json.rows[i].range+"']").prop("checked",true);
				   }
			   }
			  
			   $('#rangeDlg').dialog('open');
		   }
	});
}
function getEstimateReport(row){
	//console.log('row', row);
	$.ajax({ 
		type: "POST"
		,url: "<c:url value='/opening/estimateReportInfo.do'/>"
		,async: false 
		,data : {
			bid_notice_no :row.bid_notice_no,
			bid_notice_cha_no :row.bid_notice_cha_no
		}
		,dataType: "json"
		,success:function(json){
			setReportInfo(row);
			getBidApplyDtl();
		}
	});
}
function saveRange(){
	var row = $("#dg").datagrid('getSelected');
	
	var effectRow = new Object();
	var param="";
	if (row) {
		effectRow["bid_notice_no"] = row.bid_notice_no;
		effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
		
		 $("input[name='range']:checked").each(function(i){
			 
			 if(param.length>0){
				 param+=",";
			 }
			 
			 param +=$(this).val();
		 });
		 
		effectRow["range"] = param;
		
	}
	
	$.post("<c:url value='/opening/saveRange.do'/>", effectRow, 
			function(rsp) {
				$.messager.alert("알림","저장하였습니다.");
				$('#rangeDlg').dialog('close');
    		}, "JSON").error(function() {
    			$.messager.alert("알림", "저장에러！");
		});
}
function init(){
	var dts = new Date();
	var bidStartDt = new Date();
	var bidEndDt = new Date();
	var bidStartDt5 = new Date();
	var bidEndDt5 = new Date();
    var dayOfMonth = dts.getDate();
    bidStartDt.setDate(dayOfMonth-7);
    bidEndDt.setDate(dayOfMonth+30);
    bidStartDt5.setDate(dayOfMonth-14);
    bidEndDt5.setDate(dayOfMonth);
    bidStartDt = bidStartDt.getFullYear()+"-"+((bidStartDt.getMonth() + 1)<9?"0"+(bidStartDt.getMonth() + 1):(bidStartDt.getMonth() + 1))+"-"+bidStartDt.getDate();
    bidEndDt = bidEndDt.getFullYear()+"-"+((bidEndDt.getMonth() + 1)<9?"0"+(bidEndDt.getMonth() + 1):(bidEndDt.getMonth() + 1))+"-"+bidEndDt.getDate();
    bidStartDt5 = bidStartDt5.getFullYear()+"-"+((bidStartDt5.getMonth() + 1)<9?"0"+(bidStartDt5.getMonth() + 1):(bidStartDt5.getMonth() + 1))+"-"+bidStartDt5.getDate();
    bidEndDt5 = bidEndDt5.getFullYear()+"-"+((bidEndDt5.getMonth() + 1)<9?"0"+(bidEndDt5.getMonth() + 1):(bidEndDt5.getMonth() + 1))+"-"+bidEndDt5.getDate();
    
    $('#bidStartDt').datebox('setValue',bidStartDt);
    $('#bidEndDt').datebox('setValue',bidEndDt);
    $('#bidStartDt5').datebox('setValue',bidStartDt5);
    $('#bidEndDt5').datebox('setValue',bidEndDt5);   
}
function eventInit(){
	var t = $('#bidNoticeNo');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectList();
	   }
	});	
	
	t = $('#tab_bidNoticeNo');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectView('');
	   }
	});	
	
	t = $('#bidNoticeNo5');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectBidList5();
	   }
	});
	
	t = $('#bidAreaNm5');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectBidList5();
	   }
	});	
	
	t = $('#bidDemandNm5');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectBidList5();
	   }
	});	
	
	t = $('#bidGoodsNm5');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   selectBidList5();
	   }
	});	
	
	t = $('#s_business_nm2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getBusinessList();
	   }
	});	
	
	t = $('#s_area_txt2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getBusinessList();
	   }
	});	
}
function popupDetail(link){
	var xleft= screen.width * 0.4;
	var xmid= screen.height * 0.4;
	window.open(link, "popup", "width=850,height=800,scrollbars=1", true)
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
			
			if(row.apply_user_id1){
				form.append("user_id", encodeURIComponent(row.apply_user_id1));	
			}else if(row.apply_user_id2){
				form.append("user_id", encodeURIComponent(row.apply_user_id2));
			}else if(row.apply_user_id3){
				form.append("user_id", encodeURIComponent(row.apply_user_id3));
			}
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
			form.append("bid_stad_nm", encodeURIComponent($("#bid_stad_nm").textbox("getValue")));
			form.append("bid_stad_no", encodeURIComponent($("#bid_stad_no").textbox("getValue")));
			form.append("bid_stock_issue_yn", encodeURIComponent($("#bid_stock_issue_yn").textbox("getValue")));
			form.append("bid_num_of_days", encodeURIComponent($("#bid_num_of_days").textbox("getValue")));
			form.append("bid_sp_cont", encodeURIComponent($("#bid_sp_cont").textbox("getValue")));
			form.append("bid_tot_cont", encodeURIComponent($("#bid_tot_cont").textbox("getValue")));
			form.append("bid_site", encodeURIComponent($("#bid_site").combobox("getValue")));
			form.append("bid_risk", encodeURIComponent($("#bid_risk").combobox("getValue")));
			form.append("risk_yn1", encodeURIComponent($("#risk_yn1").combobox("getValue")));
			form.append("risk_yn2", encodeURIComponent($("#risk_yn2").combobox("getValue")));
			form.append("risk_yn3", encodeURIComponent($("#risk_yn3").combobox("getValue")));
			form.append("risk_yn4", encodeURIComponent($("#risk_yn4").combobox("getValue")));
			form.append("risk_yn5", encodeURIComponent($("#risk_yn5").combobox("getValue")));
			form.append("risk_yn6", encodeURIComponent($("#risk_yn6").combobox("getValue")));
			form.append("risk_yn7", encodeURIComponent($("#risk_yn7").combobox("getValue")));
			form.append("risk_yn8", encodeURIComponent($("#risk_yn8").combobox("getValue")));
			form.append("risk_yn9", encodeURIComponent($("#risk_yn9").combobox("getValue")));
			form.append("risk_yn10", encodeURIComponent($("#risk_yn10").combobox("getValue")));
			form.append("risk_yn11", encodeURIComponent($("#risk_yn11").combobox("getValue")));
			form.append("risk_yn14", encodeURIComponent($("#risk_yn14").combobox("getValue")));
			form.append("risk_yn15", encodeURIComponent($("#risk_yn15").combobox("getValue")));
		
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
					//selectBidList();
		      },
		      error: function (jqXHR) {
		    	  $.messager.alert("알림", type_nm+"에러！");
		      }
		    });
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
				 	<div title="투찰요청현황" style="padding:5px">
				        <table style="width: 100%;">
							<tr>
								<td class="bc">입찰마감일자</td>
								<td>
									<input class="easyui-datebox" id="bidStartDt"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">
									- <input class="easyui-datebox" id="bidEndDt"  style="width:100px;"  data-options="formatter:myformatter,parser:myparser">									
								</td>
								<td class="bc">공고</td>
								<td>
									<select class="easyui-combobox" id="searchBidType" data-options="panelHeight:'auto'"  style="width:100px;">
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
			                        <th data-options="field:'bid_notice_no',halign:'center',width:160,resizable:true,sortable:true" formatter="formatNoticeNo">공고번호</th>
			                        <th data-options="field:'bid_notice_nm',align:'left',width:450,halign:'center',sortable:true" formatter="formatNoticeNm2">공고명</th>
			                        <th data-options="field:'pre_price',align:'right',width:100 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
			                        <th data-options="field:'user_nm',align:'center',halign:'center',width:70">담당자</th>
			                         <th data-options="field:'business_send_msg',align:'left',width:150 ,halign:'center'">요청내용</th>
			                         <th data-options="field:'send_yn',align:'left',width:150 ,halign:'center'">상태</th>
			                        <th data-options="field:'apply_dt3',align:'center',width:130 ,halign:'center',sortable:true">요청일자</th>
			                        <th data-options="field:'send_dt',align:'center',width:130 ,halign:'center',sortable:true">송신일자</th>
			                        <th data-options="field:'range_type_insert',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton7">추천<br/>구간</th>
			                        <th data-options="field:'estimate_report',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton8">견적<br/>보고서</th>			                       
			                    </tr>
			                </thead>
			            </table>
			            <script>
				            function formatRowButton7(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"range_type\" onclick=\"\" ></a>";
							}
				            function formatRowButton8(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"estimate_report\" onclick=\"\" ></a>";
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
							function onClickCell(index, field) {		
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
							function onDblClickCell(row) {
								selectView(row.bid_notice_no+"-"+row.bid_notice_cha_no);
								$('.tabs-title').filter(":eq(1)").parents('li').trigger("click");
							}
							function onChgColumn1(row, estimateReportInfoRow){
								var base = estimateReportInfoRow.base_price;
								var column5 = row.column5;
								var s_range = row.s_range;
								var e_range = row.e_range;
								if(base.length>0){
									base = base.replaceAll(",","");
									var result = base * (column5/100)* (((s_range/100) + (e_range/100))/2);
									$("#manufactureList #tab_column1").text(numberComma(result));
								}
							}
			            </script>
					</div>
					
					<div title="투찰요청" style="padding:5px; margin-left:50px;">
						<div data-options="region:'west',collapsible:false" title="" style="width: 95%;">
						<input type="hidden" id="notice_no" name="notice_no">
						<input type="hidden" id="notice_cha_no" name="notice_cha_no">
						<input type="hidden" id="tab_bid_end_dt" name="tab_bid_end_dt">
						<input type="hidden" id="tab_detail_goods_no" name="tab_detail_goods_no">
						<input type="hidden" id="tab_detail_goods_nm" name="tab_detail_goods_nm">
							<table style="width: 100%;">
								<tr>
									<td class="bc">공고번호</td>
									<td>
										<input class="easyui-textbox" style="height:26px" id="tab_bidNoticeNo">
										<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectView('');">조회</a>
									</td>			
									<td align="right" id="mytableBtn">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="save2('send')">송신</a>
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save2('')">저장</a>
										
									</td>																						            
								</tr>
							</table>
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 20%;">공고번호</td>
									<td style="width: 30%;"><font id="tab_bid_notice_no"></font></td>
									<td class="bc" style="width: 20%;">물품분류제한여부 (입찰참가 제한)</td>
									<td style="width: 30%;"><font id="tab_goods_grp_limit_yn"></font></td>								
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">공고명</td>
									<td style="width: 30%;"><font id="tab_bid_notice_nm"></font></td>
									<td class="bc" style="width: 20%;">제조여부</td>
									<td style="width: 30%;"><font id="tab_product_yn"></font></td>
								</tr>						
								<tr>
									<td class="bc" style="width: 20%;">공고기관</td>
									<td style="width: 30%;"><font id="tab_order_agency_nm"></font></td>
									<td class="bc" style="width: 20%;">업종제한</td>
									<td style="width: 30%;"><font id="tab_permit_biz_type_info"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">수요기관</td>
									<td style="width: 30%;"><font id="tab_demand_nm"></font></td>
									<td class="bc" style="width: 20%;">입찰일시</td>
									<td style="width: 30%;"><font id="tab_bid_start_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">참가가능지역 (반드시 , 로 구분)</td>
									<td style="width: 30%;"><font id="tab_use_area_info"></font></td>
									<td class="bc" style="width: 20%;">참가신청마감일시</td>
									<td style="width: 30%;"><font id="tab_bid_lic_reg_dt"></font></td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">계약방법</td>
									<td style="width: 30%;"><font id="tab_contract_type_nm"></font></td>
									<td class="bc" style="width: 20%;">개찰일시</td>
									<td style="width: 30%;"><font id="tab_bid_open_dt"></font></td>
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
									        data:jsonData2" readonly="readonly"/>
									</td>
									<td class="bc" style="width: 20%;">담당자</td>
									<td style="width: 30%;"><font id="tab_bidmanager"></font></td>
								</tr>								
							</table>							
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 20%;">추정가격</td>
									<td style="width: 30%;"><font id="tab_pre_price"></font></td>
									<td class="bc" style="width: 20%;">예가범위</td>
									<td style="width: 30%;">
										<input id="s_range" name="s_range"
										class="easyui-textbox" data-options="width:50" readonly="readonly" />
										~
										<input id="e_range" name="e_range"
										class="easyui-textbox" data-options="width:50" readonly="readonly" /> %
									</td>
								</tr>
								<tr>
									<td class="bc" style="width: 20%;">기초금액</td>
									<td style="width: 30%;"><input id="tab_base_price" class="easyui-numberbox" data-options="width:100" readonly="readonly" /></td>
									<td class="bc" style="width: 20%;">낙찰하한</td>
									<td style="width: 30%;"><input id="column5" name="column5" class="easyui-numberbox" data-options="precision:3,width:100" readonly="readonly"/> %</td>
								</tr>																				
							</table>
							<table cellpadding="5" class="mytable">
								<tr>
									<td class="bc" style="width: 20%;">공고원문</td>
									<td><font id="tab_notice_spec_file"></font></td>
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
											        valueField: 'cd',
											        textField: 'cd_nm',
											        data:jsonData3" readonly="readonly" />
									</td>
									<td class="bc" style="width: 20%;">요청내용</td>
									<td style="width: 30%;"><input id="tab_business_send_msg" name="tab_business_send_msg" class="easyui-textbox" style="width: 100%;" maxlength="1000" /></td>
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
													data:jsonData4" readonly="readonly" />
									</td>
									<td class="bc" style="width: 20%;">상태</td>
									<td style="width: 30%;">
										<select class="easyui-combobox" id="tab_business_send_yn" data-options="panelHeight:'auto'" style="width:120px;">
									        <option value="N">대기중</option>
									        <option value="Y">송신완료</option>
										</select>
									</td>
								</tr>																				
							</table>
							<h1><font id="mytable2">투찰사 리스트</font></h1>
							<div id="mytable3" data-options="region:'east',collapsible:false" title="투찰사 정보" style="width: 100%; height: 250px;">
								<table style="width: 100%">
									<tr>
										<td align="right">
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onClick="save2('bigo')">비고일괄등록</a>
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'"  onClick="getBusinessList()">투찰업체 추가</a>
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'"  onClick="delBusinessList()">투찰업체 삭제</a>
										</td>
									</tr>
								</table>
								<table id="bc4" class="easyui-datagrid"
										data-options="singleSelect:false,pagination:false,striped:true,
													  onClickCell:onClickCell4,
													  onBeforeEdit:onBeforeEdit,
													  remoteSort:false,
													  multiSort:false"
										style="width:100%;height: 85%;">
									<thead>
										<tr>
											<th data-options="field:'send_yn',checkbox:true"></th>
											<th data-options="field:'business_no',align:'center',halign:'center',sortable:true" width="70">No.</th>
											<th data-options="field:'company_nm',halign:'center',sortable:true" width="170">투찰업체명</th>
											<th data-options="field:'send_dt',align:'left',halign:'center',sortable:true" width="180">투찰요청일</th>
											<th data-options="field:'chk_dt',align:'left',halign:'center',sortable:true" width="180">공고확인</th>
											<th data-options="field:'confirm_yn',align:'center',halign:'center',sortable:true" width="50">가격<br/>산정</th>
											<th data-options="field:'choice_price',align:'right',halign:'center',sortable:true" formatter="numberComma" width="120">투찰가격</th>
											<th data-options="field:'bigo',align:'left',halign:'center',sortable:true,editor:'textbox'" width="150">비고</th>
											<th data-options="field:'bid_yn',align:'center',halign:'center',sortable:true" width="70">투찰여부</th>									
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
									var editIndex4 =  undefined;
									
									function endEditing4() {
										if (editIndex4 == undefined) {
											return true
										}
										if ($('#bc4').datagrid('validateRow', editIndex4)) {
											$('#bc4').datagrid('endEdit',
													editIndex4);
											editIndex4 = undefined;
											return true;
										} else {
											return false;
										}
									}
									
									function onClickCell4(index, field) {
										if (editIndex4 != index) {
											if (endEditing4()) {
												$('#bc4').datagrid('selectRow',index)
														.datagrid('beginEdit',index);
												var ed = $('#bc4').datagrid('getEditor',
																{
																	index : index,
																	field : field
																});
												if (ed) {
													($(ed.target).data('textbox') ? $(ed.target).textbox('textbox'): $(ed.target)).focus();
												}
												editIndex4 = index;
											} else {
												setTimeout(function() {
													$('#bc4').datagrid('selectRow',editIndex4);
												}, 0);
											}
										}
									}
									function sendBigo(){

										$('#bigoMsg').textbox('setValue','');											
										$('#sendBigoDlg').dialog('open');
										
									}
									function sendBigoMsg(){
										
										var addData=$('#bc4').datagrid('getChecked');										
										
										$.messager.confirm('알림', '비고를 일괄등록 하시겠습니까?', function(r){
								            if (r){
								        		var effectRow = new Object();
							        			effectRow["bid_notice_no"] = $("#notice_no").val();
							        			effectRow["bid_notice_cha_no"] = $("#notice_cha_no").val();
							        			effectRow["bigo"] = $("#bigoMsg").textbox('getValue');
								        		
								        		if (addData.length) {
								        			effectRow["addData"] = JSON.stringify(addData);
								        		}
								        		
								        		$.post("<c:url value='/opening/sendBigoMsg.do'/>", effectRow, 
								        			function(rsp) {
									        			if(rsp.status){
									        				$.messager.alert("알림","저장하였습니다.");
									        				$('#bc4').datagrid('reload');
															$('#sendBigoDlg').dialog('close');
									        			}else{
										        			$.messager.alert("알림", "저장에러！");
									        				$('#bc4').datagrid('reload');
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
										
								
										if($("#bc4").datagrid("getRows").length <= 0){
											$.messager.alert("알림", "송신할 투찰업체가 없습니다.");
											return;
										}
										if($("#bc4").datagrid("getChecked").length <= 0){
											$.messager.alert("알림", "송신할 투찰업체를 선택하지 않았습니다.");
											return;
										}
										sendMessage2('send');
										//$('#sendMessageDlg2').dialog('open');
										
									}
									
									function messageType(type){
										var message = "";
										if(type==1){
											message = "<투찰요청>\n\n"+
											"㈜인콘 입니다.\n"+
											"공고번호 : "+($('#tab_bid_notice_no').text().replace("상세보기",""))+"\n"+
											"공고명 : "+($('#tab_bid_notice_nm').text())+"\n\n"+
											"투찰마감일시 : "+formatDate($("#tab_bid_end_dt").val())+" 까지\n"+
											"물품분류번호 : "+$("#tab_detail_goods_no").val()+"("+$("#tab_detail_goods_nm").val()+")\n\n"+
											"투찰 부탁드리겠습니다.\n"+
											"감사합니다.\n";
										}else if(type==2){
											message = "<입찰참가신청요청>\n\n"+
											"㈜인콘 입니다.\n"+
											"공고번호 : "+($('#tab_bid_notice_no').text().replace("상세보기",""))+"\n"+
											"공고명 : "+($('#tab_bid_notice_nm').text())+"\n"+
											"수요기관 : "+($('#tab_demand_nm').text())+"\n"+
											"입찰신청마감일시 : "+formatDate($("#tab_bid_end_dt").val())+" 까지\n"+
											"관련하여 입찰참가신청을 요청드립니다."+"\n\n"+
											"*국군조달사이트에서 참가신청하시면 됩니다."+"\n"+
											"- 첨부서류는 없습니다."+"\n"+
											"- 입찰보증금 면제로 입찰보증금 지급확약서 내용에 동의함으로써 갈음합니다."+"\n\n"+
											"감사합니다."+"\n";
										}else if(type==3){
											message = "<물품분류번호등록요청>\n\n"+
											"㈜인콘 입니다.\n\n"+
											"물품분류번호 : "+$("#tab_detail_goods_no").val()+"("+$("#tab_detail_goods_nm").val()+")\n\n"+
											"등록을 요청드립니다."+"\n"+
											"감사합니다."+"\n";
										}else if(type==4){
											message = "<상품확인요청>\n\n"+
											"㈜인콘 입니다.\n\n"+
											"새로운 상품이 등록되었습니다."+"\n"+
											"확인 후 투찰 부탁드리겠습니다."+"\n\n"+
											"감사합니다."+"\n";
										}else if(type==5){
											message = "<당일상품마감알림>\n\n"+
											"㈜인콘 입니다.\n\n"+
											"등록된 "+($('#tab_bid_notice_nm').text())+" 상품이 오늘 "+
											""+formatDate($("#tab_bid_end_dt").val())+" 마감입니다.\n"+
											"확인 후 투찰 부탁드리겠습니다."+"\n\n"+
											"감사합니다."+"\n";
										}
										$('#sendMessage2').textbox('setValue',message);
									}
									
									function sendMessage2(type){
										var title = "";
										var title2 = "";
										if(type=="email"){
											title ="메일을";
											title2 ="메일";
										}else if(type=="sms"){
											title ="SMS를";
											title2 ="SMS";
										}
										
										/* var message = $('#sendMessage2').textbox('getValue');
										if(message==null || message.length==0){
											$.messager.alert("알림", title2+" 문구를 등록하세요.");
											return;
										} */
										
										var addData=$('#bc4').datagrid('getChecked');
										
										$.messager.confirm('알림', '업체에 '+title+' 발송하시겠습니까?', function(r){
								            if (r){
								            	if (endEditing4()){
									            	$('#sendMessageDlg2').dialog('close');
									        		
									        		var effectRow = new Object();
									        		
								        			effectRow["bid_notice_no"] = $("#notice_no").val();
								        			effectRow["bid_notice_cha_no"] = $("#notice_cha_no").val();							        		
									        		
									        		effectRow["message_type"] = type;
									        		if (addData.length) {
									        			effectRow["addData"] = JSON.stringify(addData);
									        		}
									        		effectRow["send_message"] = $("#sendMessage2").textbox('getValue');
									        		
									        		$.post("<c:url value='/opening/sendBusiness.do'/>", effectRow, 
									        			function(rsp) {
										        			if(rsp.status){
										        				$.messager.alert("알림", title+" 발송하였습니다.");
										        				$('#bc4').datagrid('reload');
										        			}else{
											        			$.messager.alert("알림", title2+"발송에러！");
										        				$('#bc4').datagrid('reload');
										        			}
										        		}, "JSON").error(function() {
										        			$.messager.alert("알림", title2+"발송에러！");
									        		});
								            	}
								            }
								        });
									}																																																																										
									
									function delBusinessList() {
										var addData = $('#bc4').datagrid('getChecked');
										
										if(addData==null || addData.length==0){
											$.messager.alert("알림", "투찰업체를 선택하세요.");
											return;
										}
										$.messager.confirm('알림', '투찰업체를 삭제하시겠습니까?', function(r){
								            if (r){
								            	var effectRow = new Object();
									   			effectRow["bid_notice_no"] = $("#notice_no").val();
									   			effectRow["bid_notice_cha_no"] = $("#notice_cha_no").val();	
									    		effectRow["addData"] = JSON.stringify(addData);
									    		
									    		$.post("<c:url value='/opening/deleteBusinessList.do'/>", effectRow, function(rsp) {
									    			if(rsp.status){
									    				$.messager.alert("알림", "삭제하였습니다.");
									    				var rowIndex = 0;
														
														for(var i=0;i<addData.length;i++){		
															rowIndex = $("#bc4").datagrid("getRowIndex", addData[i]); 
															$('#bc4').datagrid('deleteRow',rowIndex);
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
					<div title="개찰결과" style="padding: 5px">
						<div class="easyui-layout" style="width:100%;height:750px;">
						    <div data-options="region:'north',border:false">
						    	<table style="width: 100%;">
									<tr>
										<td class="bc">공고</td>
										<td>
											<select class="easyui-combobox" id="searchBidType5" data-options="panelHeight:'auto'"  style="width:100px;">
											        <option value="1">공고번호</option>
											        <option value="2">공고명</option>
											</select>
											<input type="text" class="easyui-textbox" id="bidNoticeNo5" style="width: 120px;">
										</td>
										<td class="bc">지역</td>
										<td>
											<input type="text" class="easyui-textbox" id="bidAreaNm5" style="width: 120px;">
										</td>
										<td class="bc">검색일</td>
										<td>
											<select class="easyui-combobox" id="searchDateType5" data-options="panelHeight:'auto'"  style="width:100px;">
											        <option value="1">개찰일</option>
											        <option value="2">공고게시일</option>
											</select>
										</td>
										<td><input class="easyui-datebox" id="bidStartDt5"  style="width:100px;" data-options="formatter:myformatter,parser:myparser">
											~ <input class="easyui-datebox" id="bidEndDt5"  style="width:100px;"	data-options="formatter:myformatter,parser:myparser">
										</td>
										<td class="bc">수요처</td>
										<td><input type="text" class="easyui-textbox" id="bidDemandNm5" style="width: 150px;"></td>
										<td class="bc">낙찰예정자</td>
										<td><input type="text" class="easyui-textbox" id="bidGoodsNm5" style="width: 150px;"></td>
										<td class="bc">담당자</td>
										<td><input id="userId5" class="easyui-combobox"
											data-options="
											method:'get',
									        valueField: 'user_id',
									        textField: 'user_nm',
									        width:100,
									        panelHeight:'auto',
									        data:jsonData">
										</td>
										<td class="bc">진행상황</td>
										<td>
											<select class="easyui-combobox" id="bidStepNm5"  data-options="panelHeight:'auto'" style="width:100px;">
											        <option value="">전체</option>
											        <option value="개찰완료">개찰완료</option>
											        <option value="유찰">유찰</option>
											        <option value="재입찰">재입찰</option>
											</select>
										</td>
										<td width="200px">
											<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="selectBidList5()">조회</a> 
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload'" onclick="$('#bidResultInfoDlg').dialog('open');">개찰결과갱신</a>
										</td>
									</tr>
								</table>
						    </div>
						    <div data-options="region:'south',split:true,border:false" style="height:300px;">
								<div class="easyui-layout" style="width: 100%; height: 100%;">
									<div data-options="region:'west',collapsible:false" title="개찰상세" style="width: 30%;">
											<div id="tab5_detal1"></div>
											<div id="tab5_detal2"></div>
											<div id="tab5_detal3"></div>
									</div>
									<div data-options="region:'center',collapsible:false" title="개찰순위" style="width: 35%;">
										<table id="tab5_rank" class="easyui-datagrid"
												style="width: 100%; height: 100%;"
												data-options="
													  singleSelect:true,
													  method:'get',
													  striped:true,
													  nowrap:false,
												  rowStyler: function(index,row){
									                    if (row.cnt=='0'){
										                    if (row.open_rank==null){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }else{
											                    if (row.open_rank=='1'){
											                        return 'color:#ff0000;';
											                    }
										                    }
									                    }else{
										                    if (row.open_rank==null){
										                        return 'background-color:#eeeeaa;color:#999999;';
										                    }else{
											                    if (row.open_rank=='1'){
											                        return 'background-color:#eeee00;color:#ff0000;';
											                    }else{
											                        return 'background-color:#eeee00;color:#0000ff;';
											                    }
										                    }
									                    }
									              }">
											<thead>
												<tr>
													<th data-options="field:'open_rank',align:'center',halign:'center',width:50">순위</th>
													<th data-options="field:'biz_reg_no',align:'center',width:100 ,halign:'center'" formatter="formatEnter">사업자등록번호</th>
													<th	data-options="field:'biz_nm',align:'left',width:150 ,halign:'center'">업체명</th>
													<th data-options="field:'biz_owner_nm',align:'center',width:70 ,halign:'center'">대표자</th>
													<th data-options="field:'bid_price',align:'right',width:100 ,halign:'center'" formatter="numberComma">투찰금액</th>
													<th data-options="field:'bid_percent',align:'right',width:60 ,halign:'center'" >투찰율</th>
													<th data-options="field:'note',align:'left',width:100 ,halign:'center'">비고</th>
												</tr>
											</thead>
										</table>
									</div>
									<div data-options="region:'east',collapsible:false"
										title="투찰사 순위" style="width: 35%;">
										<table id="tab5_value" class="easyui-datagrid"
												style="width: 100%; height: 100%;"
												data-options="
												  singleSelect:true,
												  method:'get',
												  striped:true,
												  nowrap:false">
											<thead>
												<tr>
													<th data-options="field:'open_rank',align:'center',halign:'center',width:50">순위</th>
													<th data-options="field:'biz_reg_no',align:'center',width:100 ,halign:'center'" formatter="formatEnter">사업자등록번호</th>
													<th	data-options="field:'biz_nm',align:'left',width:150 ,halign:'center'">업체명</th>
													<th data-options="field:'biz_owner_nm',align:'center',width:70 ,halign:'center'">대표자</th>
													<th data-options="field:'bid_price',align:'right',width:100 ,halign:'center'" formatter="numberComma">투찰금액</th>
													<th data-options="field:'bid_percent',align:'right',width:60 ,halign:'center'" >투찰율</th>
													<th data-options="field:'note',align:'left',width:100 ,halign:'center'">비고</th>
												</tr>
											</thead>
										</table>
									</div>
								</div>
						    </div>
						    <div data-options="region:'center',border:false">
						    	<table id="dg5" class="easyui-datagrid"
									style="width: 100%; height: 100%"
									data-options="rownumbers:false,
												  singleSelect:true,
												  pagination:true,
												  pageSize:100,
												  pageList:[100,50,200,500],
												  method:'get',
												  striped:true,
												  nowrap:false">
									<thead>
										<tr>
											<th data-options="field:'user_nm',align:'center',halign:'center',width:70">담당자</th>
											<th data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true"	formatter="formatNoticeNo">공고번호</th>
											<th data-options="field:'bid_biz_re_seq_no',align:'center',width:60,halign:'center'">재입찰<br/>번호</th>
											<th data-options="field:'bid_notice_nm',align:'left',width:350,halign:'center'">공고명</th>
											<th data-options="field:'demand_nm',align:'left',width:150,halign:'center'"  formatter="formatEnter">수요기관</th>
											<th data-options="field:'bid_open_dt',align:'center',width:150,halign:'center'" formatter="formatDate">개찰일시</th>
											<th data-options="field:'cont_biz_num',align:'right',width:60,halign:'center'">참가수</th>
											<th data-options="field:'join_com_cnt',align:'right',width:60,halign:'center'">투찰<br/>업체수</th>
											<th data-options="field:'participation_rate',align:'right',width:60,halign:'center'" formatter="formatParticipationRate">참가율</th>
											<th data-options="field:'test',align:'right',width:60,halign:'center'" formatter="formatContBizInfo4">점유율</th>
											<th data-options="field:'cont_biz_info1',align:'left',width:150,halign:'center'" formatter="formatContBizInfo1">낙찰예정자</th>
											<th data-options="field:'cont_biz_info2',align:'right',width:120,halign:'center'" formatter="formatContBizInfo2">투찰금액</th>
											<th data-options="field:'cont_biz_info3',align:'right',width:80,halign:'center'" formatter="formatContBizInfo3">투찰율</th>
											<th data-options="field:'bid_step_type',align:'center',width:60,halign:'center'">진행상황</th>
											<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="80" formatter="formatRowButton6">상세가져오기</th>
										</tr>
									</thead>
								</table>
								<script>
									function formatRowButton6(val,row){
										   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"report_type\" val=\""+row.bid_notice_no+"\" onclick=\"\" ></a>";
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
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCompanyType('s_company_type2', 's_company_type_nm2', 's')" ></a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchCompanyType('s_company_type2', 's_company_type_nm2', 'c')" ></a>
	            </td>
	            <td class="bc">물품</td>
	            <td>
	            	<input type="hidden" id="s_goods_type2" name="s_goods_type2" />
	                <input type="text" class="easyui-textbox"  id="s_goods_type_nm2" style="width:100px;"  disabled="disabled"  >
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType('s_goods_type2', 's_goods_type_nm2', 's')" ></a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType('s_goods_type2', 's_goods_type_nm2', 'c')" ></a>
	            </td>
	            <td class="bc">적격정보</td>
	            <td>
	            	<input type="hidden" id="s_license_type2" name="s_license_type2" />
	                <input type="text" class="easyui-textbox"  id="s_license_type_nm2" style="width:100px;"  disabled="disabled"  >
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchLicenseType('s_license_type2', 's_license_type_nm2', 's')" ></a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchLicenseType('s_license_type2', 's_license_type_nm2', 'c')" ></a>
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
								data:jsonData5" style="width:100px;">
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
								data:jsonData7" style="width:60px;">
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
								data:jsonData6" style="width:60px;">
	            </td>
				<td>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getBusinessList()">조회</a>
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
	<!-- 개찰결과 가져오기 Dialog start -->
	<div id="bidResultInfoDlg" class="easyui-dialog" title="개찰결과 가져오기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 20%; height: 100px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">개찰일</td>
				<td><input class="easyui-datebox" id="resultStartDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser"></td>
				<td align="right">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getBidResultInfoApi()">가져오기</a>
				</td>
			</tr>
		</table>
	</div>	
	<!-- 개찰결과 가져오기 Dialog end -->
	<!-- 투찰요청 메세지 Dialog start -->
	<div id="sendMessageDlg2" class="easyui-dialog" title="투찰정보" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 400px; padding: 10px">
		<div style="width: 100%" align="left">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(2)">참가신청요청</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(4)">상품확인요청</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(5)">당일상품마감알림</a>
		</div>
		<div style="margin: 5px 0; vertical-align: top"></div>
		<input id="sendMessage2" name="sendMessage2" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 80%"/> 
		<div style="margin: 5px 0; vertical-align: top"></div>
		<div style="width: 100%" align="center">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage2('email')">Email보내기</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage2('sms')">SMS보내기</a>
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
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getCompanyTypeTotalSearchList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="companyTypeChoice()" >선택</a>
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
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="licenseTypeChoice()" >선택</a>
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
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getGoodsTypeTotalSearchList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="goodsTypeChoice()" >선택</a>
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
    <!-- 추천구간 Dialog start -->
	<div id="rangeDlg" class="easyui-dialog" title="추천구간" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 600px; height: 350px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td align="right">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onClick="saveRange()">저장</a>
				</td>
			</tr>
		</table>
		<table style="width: 100%">
			<tr>
				<td class="bc" colspan="5">1구간</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="range" value="99.5"/>99.5</td>
				<td><input type="checkbox" name="range" value="99.6"/>99.6</td>
				<td><input type="checkbox" name="range" value="99.7"/>99.7</td>
				<td><input type="checkbox" name="range" value="99.8"/>99.8</td>
				<td><input type="checkbox" name="range" value="99.9"/>99.9</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="range" value="100.0"/>100.0</td>
				<td><input type="checkbox" name="range" value="100.1"/>100.1</td>
				<td><input type="checkbox" name="range" value="100.2"/>100.2</td>
				<td><input type="checkbox" name="range" value="100.3"/>100.3</td>
				<td><input type="checkbox" name="range" value="100.4"/>100.4</td>
			</tr>
			<tr>
				<td class="bc" colspan="5">2구간</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="range" value="99.0"/>99.0</td>
				<td><input type="checkbox" name="range" value="99.1"/>99.1</td>
				<td><input type="checkbox" name="range" value="99.2"/>99.2</td>
				<td><input type="checkbox" name="range" value="99.3"/>99.3</td>
				<td><input type="checkbox" name="range" value="99.4"/>99.4</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="range" value="100.5"/>100.5</td>
				<td><input type="checkbox" name="range" value="100.6"/>100.6</td>
				<td><input type="checkbox" name="range" value="100.7"/>100.7</td>
				<td><input type="checkbox" name="range" value="100.8"/>100.8</td>
				<td><input type="checkbox" name="range" value="100.9"/>100.9</td>
			</tr>
			<tr>
				<td class="bc" colspan="5">3구간</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="range" value="98.0"/>98.0</td>
				<td><input type="checkbox" name="range" value="98.1"/>98.1</td>
				<td><input type="checkbox" name="range" value="98.2"/>98.2</td>
				<td><input type="checkbox" name="range" value="98.3"/>98.3</td>
				<td><input type="checkbox" name="range" value="98.4"/>98.4</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="range" value="98.5"/>98.5</td>
				<td><input type="checkbox" name="range" value="98.6"/>98.6</td>
				<td><input type="checkbox" name="range" value="98.7"/>98.7</td>
				<td><input type="checkbox" name="range" value="98.8"/>98.8</td>
				<td><input type="checkbox" name="range" value="98.9"/>98.9</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="range" value="101.0"/>101.0</td>
				<td><input type="checkbox" name="range" value="101.1"/>101.1</td>
				<td><input type="checkbox" name="range" value="101.2"/>101.2</td>
				<td><input type="checkbox" name="range" value="101.3"/>101.3</td>
				<td><input type="checkbox" name="range" value="101.4"/>101.4</td>
			</tr>
		</table>
	</div>
	<!-- 투찰업체 메세지 보내기 Dialog end -->

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
                <td class="bc" style="width:20%">공고기관</td>
                <td style="width:30%"><font id="tab_order_agency_nm"></font></td>
                <td class="bc" style="width:20%">수요기관</td>
                <td style="width:30%"><font id="tab_bid_demand_nm"></font></td>
            </tr>
            <tr>
                <td class="bc" style="width:20%">업종제한</td>
                <td style="width:30%"><font id="tab_permit_biz_type_info"></font></td>
                <td class="bc" style="width:20%">참가가능지역</td>
                <td style="width:30%"><font id="tab_use_area_info"></font></td>
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
				        data:jsonData2" />
                </td>
            </tr>
            <tr>
                <td class="bc">참가신청마감일시</td>
                <td><font id="tab_bid_lic_reg_dt"></font></td>
                <td class="bc">빈공간</td>
                <td><font id="tab_"></font></td>
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
				        data:jsonData8" />
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
                <td class="bc">물품분류명</td>
                <td>
                	<input class="easyui-textbox" data-options="width:150" id="bid_stad_nm" />
                </td>
                <td class="bc">물품분류번호</td>
                <td>
	                <input class="easyui-textbox" data-options="width:150" id="bid_stad_no" />
                </td>
            </tr>
            <tr>
                <td class="bc">제조사증권발급여부</td>
                <td>
                	<input class="easyui-textbox" data-options="width:150" id="bid_stock_issue_yn" />
                </td>
                <td class="bc">업체추정 과업일수</td>
                <td>
	                <input class="easyui-textbox" data-options="width:150" id="bid_num_of_days" />
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
			</tr>
			<tr>
				<td class="bc" rowspan="6">규격<br/>관련</td>
				<td class="cont">○ 특정 규격, 특정 제조사 제품이 아님</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn1" data-options="panelHeight:'auto'" style="width:100px;">
						<option value="">선택</option>
						<option value="Y">Y</option>
						<option value="N">N</option>
						<option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 수요처와 규격을 확인함</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn2" data-options="panelHeight:'auto'" style="width:100px;">
						<option value="">선택</option>
						<option value="Y">Y</option>
						<option value="N">N</option>
						<option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사와 규격을 확인함</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn11" data-options="panelHeight:'auto'" style="width:100px;">
						<option value="">선택</option>
						<option value="Y">Y</option>
						<option value="N">N</option>
						<option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 인증서, 시험성적서 제출이 필요없음</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn3" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 필요시 이미 제조사에 서류가 구비되어 있음</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn4" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 필요시 해당 물품 제조와 더불어 발급 예정임</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn5" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="bc" rowspan="4">납품<br/>관련</td>
				<td class="cont" style="width: 55%">○ 실행 담당자와 납기의 적절성 확인</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn6" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 납품장소(납지)가 과다하거나 격오지가 아님</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn7" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 납품조건(상차도, 도착도, 하차도) 확인함</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn8" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 납품시 추가비용 확인함</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn9" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="bc" rowspan="3">기타<br/>리스크</td>
				<td class="cont" style="width: 55%">○ 입찰참가시 특이절차 여부</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn10" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 지난 개찰결과를 확인함</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn14" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 실행업체의 신용도 분석</td>
				<td class="cont" style="text-align: center">
					<select class="easyui-combobox" id="risk_yn15" data-options="panelHeight:'auto'" style="width:100px;">
						 <option value="">선택</option>
						 <option value="Y">Y</option>
						 <option value="N">N</option>
						 <option value="C">해당사항없음</option>
					</select>
				</td>
			</tr>
        </table>
         <table cellpadding="5" style="width: 100%;">
            <tr>
                 <td width="100%" colspan="3" style="text-align: right;">
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" id="applyBtn" onclick="save(3)">승인</a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" id="cancelBtn" onclick="save(2)">반려</a>
	                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" id="saveBtn" onclick="save(1)">저장</a>
	            </td>
            </tr>
        </table>
    </div>
    <!-- 제조업체 Dialog end -->
</body>
</html>