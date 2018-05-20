<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트관리</title>
<%@ include file="/include/session.jsp" %>
<link rel='stylesheet' href='<c:url value='/jquery/fullcalendar/lib/cupertino/jquery-ui.min.css'/>' />
<link href='<c:url value='/jquery/fullcalendar/fullcalendar.css'/>' rel='stylesheet' />
<link href='<c:url value='/jquery/fullcalendar/fullcalendar.print.css'/>' rel='stylesheet' media='print' />
<script src='<c:url value='/jquery/fullcalendar/lib/moment.min.js'/>'></script>
<script src='<c:url value='/jquery/fullcalendar/fullcalendar.min.js'/>'></script>
<script src='<c:url value='/jquery/fullcalendar/lang-all.js'/>'></script>
<style type="text/css">

	#calendar {
		max-width: 900px;
		margin: 0 auto;
	}
</style>	
<script>


var jsonCode1=null;
var jsonCode2=null;
var jsonCode3=null;
var jsonCode4=null;

$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/bid/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd :'project_bill_cd'
	}
   ,dataType: "json"
   ,success:function(json){
	   jsonCode1=json;
   }
});
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/bid/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd :'project_collect_cd'
	}
   ,dataType: "json"
   ,success:function(json){
	   jsonCode2=json;
   }
});
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/bid/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd :'project_secur_cd'
	}
   ,dataType: "json"
   ,success:function(json){
	   jsonCode3=json;
   }
});
$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/project/yearList.do'/>"
   ,async: false 
   ,data : {
	}
   ,dataType: "json"
   ,success:function(json){
	   jsonCode4=json;
   }
});

$(document).ready(function() {
	
	init();
	selectProjectList();
	calendar();
	calendarData();
	
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
							setGrid();
							break;
						case 2:
							setGrid3();
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
    var dts = new Date();
	var dte = new Date();
    var dayOfMonth = dts.getDate();
    dts.setDate(dayOfMonth-10);
    dte.setDate(dayOfMonth+10);
    dts = dts.getFullYear()+"-01-01";
    dte = dte.getFullYear()+"-"+((dte.getMonth() + 1)<9?"0"+(dte.getMonth() + 1):(dte.getMonth() + 1))+"-"+dte.getDate();
    
    $('#contStartDt').datebox('setValue',dts);
    $('#contEndDt').datebox('setValue',dte);
	$("#year").combobox("setValue",new Date().getFullYear())
    
    $('#tt').tabs({
		onSelect : calendarData
	});
    
}

function createProject(){
	$("#project_id").val("");
	$("#bid_notice_no").textbox("setValue","");
	$("#bid_notice_cha_no").textbox("setValue","");
	$("#bid_notice_nm").textbox("setValue","");
	$("#order_agency_nm").textbox("setValue","");
	$("#demand_nm").textbox("setValue","");
	$("#demand_user_nm1").textbox("setValue","");
	$("#demand_tel1").textbox("setValue","");
	$("#demand_user_nm2").textbox("setValue","");
	$("#demand_tel2").textbox("setValue","");
	$("#cont_company_nm").textbox("setValue","");
	$("#cont_user_nm").textbox("setValue","");
	$("#cont_tel").textbox("setValue","");
	$("#cont_price").textbox("setValue","");
	$("#cont_margin").textbox("setValue","");
	$('#cont_start_dt').datebox('setValue',"");
    $('#cont_end_dt').datebox('setValue',"");
    $('#tax_dt').datebox('setValue',"");
	$("#dist_nm").textbox("setValue","");
	$("#dist_user_nm").textbox("setValue","");
	$("#dist_tel").textbox("setValue","");
	$("#dist_price").textbox("setValue","");
	$("#dist_margin").textbox("setValue","");
	$("#demand_condition").textbox("setValue","");
	$("#order_condition").textbox("setValue","");

	$("#tax").switchbutton({checked:false});
	$("#securities").switchbutton({checked:false});
	$("#completion").switchbutton({checked:false});
	
	$("#s_bill_cd").combobox("setValue","");
	$("#s_collect_cd").combobox("setValue","");
	$("#s_secur_cd").combobox("setValue","");
	$("#o_bill_cd").combobox("setValue","");
	$("#o_collect_cd").combobox("setValue","");
	$("#o_secur_cd").combobox("setValue","");
	
	$("#file_id1").filebox("setValue","");
	$("#file_id2").filebox("setValue","");
	$("#file_id3").filebox("setValue","");
	$("#file_id4").filebox("setValue","");
	$("#file_id5").filebox("setValue","");
	
	$('#file_link1').bind('click', function(){
	});
	$('#file_link2').bind('click', function(){
	});
	$('#file_link3').bind('click', function(){
	});
	$('#file_link4').bind('click', function(){
	});
	$('#file_link5').bind('click', function(){
	});
	
	$("#day1").datebox("setValue","");
	$("#day2").datebox("setValue","");
	$("#day3").datebox("setValue","");
	$("#day4").datebox("setValue","");
	$("#day5").datebox("setValue","");
	$("#day6").datebox("setValue","");
	$("#day7").datebox("setValue","");
	$("#day8").datebox("setValue","");
	$("#note1").textbox("setValue","");
	$("#note2").textbox("setValue","");
	$("#note3").textbox("setValue","");
	$("#note4").textbox("setValue","");
	$("#note5").textbox("setValue","");
	$("#note6").textbox("setValue","");
	$("#note7").textbox("setValue","");
	$("#note8").textbox("setValue","");
	
	$('#bid_notice_no').textbox('textbox').attr('maxlength', '20');
	$('#bid_notice_cha_no').textbox('textbox').attr('maxlength', '3');
	$('#bid_notice_nm').textbox('textbox').attr('maxlength', '100');
	$('#order_agency_nm').textbox('textbox').attr('maxlength', '40');
	$('#demand_nm').textbox('textbox').attr('maxlength', '40');
	$('#demand_user_nm1').textbox('textbox').attr('maxlength', '40');
	$('#demand_tel1').textbox('textbox').attr('maxlength', '13');
	$('#demand_user_nm2').textbox('textbox').attr('maxlength', '40');
	$('#demand_tel2').textbox('textbox').attr('maxlength', '13');
	$('#cont_company_nm').textbox('textbox').attr('maxlength', '40');
	$('#cont_user_nm').textbox('textbox').attr('maxlength', '40');
	$('#cont_tel').textbox('textbox').attr('maxlength', '13');
	$('#cont_price').textbox('textbox').attr('maxlength', '12');
	$('#dist_user_nm').textbox('textbox').attr('maxlength', '40');
	$('#dist_tel').textbox('textbox').attr('maxlength', '13');
	$('#dist_nm').textbox('textbox').attr('maxlength', '40');
	$('#dist_price').textbox('textbox').attr('maxlength', '12');
	$('#demand_condition').textbox('textbox').attr('maxlength', '40');
	$('#order_condition').textbox('textbox').attr('maxlength', '40');

	$('#note1').textbox('textbox').attr('maxlength', '50');
	$('#note2').textbox('textbox').attr('maxlength', '50');
	$('#note3').textbox('textbox').attr('maxlength', '50');
	$('#note4').textbox('textbox').attr('maxlength', '50');
	$('#note5').textbox('textbox').attr('maxlength', '50');
	$('#note6').textbox('textbox').attr('maxlength', '50');
	$('#note7').textbox('textbox').attr('maxlength', '50');
	$('#note8').textbox('textbox').attr('maxlength', '50');
	
	
    $("#total_price").textbox("setValue","");
	$('#total_price').textbox('textbox').css('text-align', 'right');
    
    selectProjectDtlList("");
    
	$('#projectDlg').dialog('open');
    $('#subTab').tabs('select', 0);
}

var eventData = [];
    		
function calendarData(){
	
	$('#calendar').fullCalendar('removeEventSource', eventData);
	$.ajax({ 
	    type: "GET"
		,url : "<c:url value='/project/getUserProjectScheduleList.do'/>"
	   ,async: false 
	   ,data : {
		}
	   ,dataType: "json"
	   ,success:function(row){
		   
		   eventData = row.rows
	   }
	});

    $('#calendar').fullCalendar('addEventSource', eventData);  
	$('#calendar').fullCalendar('refetchEvents');
	$('#calendar').fullCalendar('render');
}

function calendar(){
	$('#calendar').fullCalendar({
		resourceAreaWidth: 230,
		businessHours: true,
		defaultView: 'month',
		editable: false,
		selectable: true,
		eventLimit: true, // allow "more" link when too many events
		header: {
			left: ' ',
			center: 'prevYear, prev, title ,next, nextYear',
			right: 'today'
		},
		views: {
			agendaTwoDay: {
				type: 'agenda',
				duration: { days: 2 },

				// views that are more than a day will NOT do this behavior by default
				// so, we need to explicitly enable it
				groupByResource: true

				//// uncomment this line to group by day FIRST with resources underneath
				//groupByDateAndResource: true
			}
		},
		lang: 'ko'
		//// uncomment this line to hide the all-day slot
		//allDaySlot: false,

// 		,resources: [
// 			{ id: '1', title: 'Room A' },
// 			{ id: '2', title: 'Room B', eventColor: 'green' },
// 			{ id: '3', title: 'Room C', eventColor: 'orange' },
// 			{ id: '4', title: 'Room D', eventColor: 'red' }
// 		]
		,events: eventData
		,eventClick: function(calEvent, jsEvent, view) {

			if(calEvent.resourceId=='2'){
				$.messager.alert("진행공고", '공고번호 : ' + calEvent.bid_notice_no+'-'+calEvent.bid_notice_cha_no+'<br/>공고명 : ' + calEvent.bid_notice_nm+'<br/>공고기간 : ' + calEvent.start_dt+" ~ "+calEvent.end_dt);
			}else if(calEvent.resourceId=='3'){
				$.messager.alert("진행프로젝트", '공고번호 : ' + calEvent.bid_notice_no+'-'+calEvent.bid_notice_cha_no+'<br/>프로젝트 명 : ' + calEvent.bid_notice_nm+
	        		'<br/>프로젝트 기간 : ' + calEvent.start_dt+" ~ "+calEvent.end_dt+'<br/>내용 :'+calEvent.bigo);
			}

	        // change the border color just for fun
// 	        $(this).css('border-color', 'red');

	    } 
		,eventAfterRender :function( event, element, view ) { 
	        if (event.className == "holiday")
	        {
	         if (view.name == 'month') {
	          $("td[data-date=" + event.start.format('YYYY-MM-DD') + "]").addClass('holiday');
	         } else if (view.name =='agendaWeek') {
	          $("th:contains(' " + event.start.format('M.D') + "')").attr("class","fc-day-header fc-widget-header holiday");
	         } else if (view.name == 'agendaDay') {
	          if(event.start.format('YYYY-MM-DD') == $('#calendar').fullCalendar('getDate').format('YYYY-MM-DD')) {
	           $("th:contains('요일')").attr("class","fc-day-header fc-widget-header holiday");
	           //$("td.fc-col0").addClass('holiday');
	          };
	         }
	         
	        }

	       }



	});
}

//tab2 프로젝트 리스트 조회
function selectProjectList(){
	$("#dg").datagrid({
		method : "GET",
		url : "<c:url value='/project/projectList.do'/>",
		queryParams : {
			contStartDt :$('#contStartDt').datebox('getValue'),
			contEndDt : $('#contEndDt').datebox('getValue'),
			contYn : $("input:radio[name='contGrp']:checked").val()
		},
		onLoadSuccess : function(row, param) {
			
			$('#dg').datagrid('reloadFooter',row.footer);
		},
		onDblClickRow : function(index, row){
			getData(row);
		}
	});
}

function setGrid(){
	selectProjectList();
}

//tab3 프로젝트 성과 리스트 조회
function selectProjectList3(){
	$("#dg3").datagrid({
		method : "GET",
		url : "<c:url value='/project/projectList3.do'/>",
		queryParams : {
			year :$("#year").combogrid("getValue"),
		},
		onLoadSuccess : function(row, param) {
// 			$('#dg3').datagrid('reloadFooter',row.footer);
		}
	});
}

function setGrid3(){
	selectProjectList3();
}

function getData(row){

	createProject();

	$("#project_id").val(row.project_id);
	$("#bid_notice_no").textbox("setValue",row.bid_notice_no);
	$("#bid_notice_cha_no").textbox("setValue",row.bid_notice_cha_no);
	$("#bid_notice_nm").textbox("setValue",row.bid_notice_nm);
	$("#order_agency_nm").textbox("setValue",row.order_agency_nm);
	$("#demand_nm").textbox("setValue",row.demand_nm);
	$("#demand_user_nm1").textbox("setValue",row.demand_user_nm1);
	$("#demand_tel1").textbox("setValue",row.demand_tel1);
	$("#demand_user_nm2").textbox("setValue",row.demand_user_nm2);
	$("#demand_tel2").textbox("setValue",row.demand_tel);
	$("#cont_company_nm").textbox("setValue",row.cont_company_nm);
	$("#cont_user_nm").textbox("setValue",row.cont_user_nm);
	$("#cont_tel").textbox("setValue",row.cont_tel);
	$("#cont_price").numberbox("setValue",numberComma(row.cont_price));
	$("#cont_margin").textbox("setValue",row.cont_margin);
	$('#cont_start_dt').datebox('setValue',formatDate(row.cont_start_dt));
    $('#cont_end_dt').datebox('setValue',formatDate(row.cont_end_dt));
    $('#tax_dt').datebox('setValue',formatDate(row.tax_dt));
	$("#dist_nm").textbox("setValue",row.dist_nm);
	$("#dist_user_nm").textbox("setValue",row.dist_user_nm);
	$("#dist_tel").textbox("setValue",row.dist_tel);
	$("#dist_price").numberbox("setValue",numberComma(row.dist_price));
	$("#dist_margin").textbox("setValue",row.dist_margin);
	$("#demand_condition").textbox("setValue",row.demand_condition);
	$("#order_condition").textbox("setValue",row.order_condition);
	$("#tax").switchbutton({checked:row.tax=='Y'?true:false});
	$("#securities").switchbutton({checked:row.securities=='Y'?true:false});
	$("#completion").switchbutton({checked:row.completion=='Y'?true:false});
	
	$("#s_bill_cd").combobox("setValue",row.s_bill_cd);
	$("#s_collect_cd").combobox("setValue",row.s_collect_cd);
	$("#s_secur_cd").combobox("setValue",row.s_secur_cd);
	$("#o_bill_cd").combobox("setValue",row.o_bill_cd);
	$("#o_collect_cd").combobox("setValue",row.o_collect_cd);
	$("#o_secur_cd").combobox("setValue",row.o_secur_cd);
	
	$("#file_id1").filebox("setValue","");
	$("#file_id2").filebox("setValue","");
	$("#file_id3").filebox("setValue","");
	$("#file_id4").filebox("setValue","");
	$("#file_id5").filebox("setValue","");
	
	$("#file_id1").textbox("setValue",row.file_nm1);
	$("#file_id2").textbox("setValue",row.file_nm2);
	$("#file_id3").textbox("setValue",row.file_nm3);
	$("#file_id4").textbox("setValue",row.file_nm4);
	$("#file_id5").textbox("setValue",row.file_nm5);
	
	
	$('#file_link1').unbind('click',null);
	$('#file_link2').unbind('click',null);
	$('#file_link3').unbind('click',null);
	$('#file_link4').unbind('click',null);
	$('#file_link5').unbind('click',null);
	$('#file_remove1').unbind('click',null);
	$('#file_remove2').unbind('click',null);
	$('#file_remove3').unbind('click',null);
	$('#file_remove4').unbind('click',null);
	$('#file_remove5').unbind('click',null);
	

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
	$('#file_link3').bind('click', function(){
		if($("#file_id3").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id3+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#file_link4').bind('click', function(){
		if($("#file_id4").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id4+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#file_link5').bind('click', function(){
		if($("#file_id5").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id5+"'/>";
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
	$('#file_remove3').bind('click', function(){
		if($("#file_id3").textbox("getText").length>0){
			$("#file_id3").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#file_remove4').bind('click', function(){
		if($("#file_id4").textbox("getText").length>0){
			$("#file_id4").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#file_remove5').bind('click', function(){
		if($("#file_id5").textbox("getText").length>0){
			$("#file_id5").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	
	$('#day1').datebox('setValue',formatDate(row.day1));
	$('#day2').datebox('setValue',formatDate(row.day2));
	$('#day3').datebox('setValue',formatDate(row.day3));
	$('#day4').datebox('setValue',formatDate(row.day4));
	$('#day5').datebox('setValue',formatDate(row.day5));
	$('#day6').datebox('setValue',formatDate(row.day6));
	$('#day7').datebox('setValue',formatDate(row.day7));
	$('#day8').datebox('setValue',formatDate(row.day8));
	$("#note1").textbox("setValue",row.note1);
	$("#note2").textbox("setValue",row.note2);
	$("#note3").textbox("setValue",row.note3);
	$("#note4").textbox("setValue",row.note4);
	$("#note5").textbox("setValue",row.note5);
	$("#note6").textbox("setValue",row.note6);
	$("#note7").textbox("setValue",row.note7);
	$("#note8").textbox("setValue",row.note8);

	selectProjectDtlList(row.project_id);
	
}

//프로젝트 제조업체 리스트 조회
function selectProjectDtlList(project_id){
	
	if(project_id!=null){
		$("#tab1").datagrid({
			method : "GET",
			url : "<c:url value='/project/projectDtlList.do'/>",
			queryParams : {
				project_id :project_id
			},
			onLoadSuccess : function(row, param) {
				
				totalCnt();
			}
		});
	}
	
	
	$("#tab2").datagrid({
		method : "GET",
		url : "<c:url value='/project/projectScheduleList.do'/>",
		queryParams : {
			project_id :project_id
		},
		onLoadSuccess : function(row, param) {
		}
	});
	
	$("#tab3").datagrid({
		method : "GET",
		url : "<c:url value='/project/projectTaxList.do'/>",
		queryParams : {
			project_id :project_id
		},
		onLoadSuccess : function(row, param) {
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
					<div id="tt"  class="easyui-tabs" data-options="fit:true,border:false,plain:true">
					<div title="일정알림" style="padding:5px" >
						<div id='calendar'></div>
					</div>
					<div title="프로젝트 정보" style="padding:5px">
				 	<div id="cc" class="easyui-calendar"></div>
		 			<table style="width:100%;">
				        <tr>
				        	<td width="40%"  align="left">
				        		<table style="width:100%;">
							        <tr>
							            <td class="bc">계약기간</td>
							            <td><input class="easyui-datebox" id="contStartDt"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											~ <input class="easyui-datebox" id="contEndDt"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
										</td>
							            <td class="bc">준공여부</td>
							            <td>
											<input type="radio" name="contGrp" value="" onchange="selectProjectList()"  checked="checked">전체</input>
											<input type="radio" name="contGrp" value="N" onchange="selectProjectList()">진행</input>
											<input type="radio" name="contGrp" value="Y" onchange="selectProjectList()">종료</input>
							            </td>
							        </tr>
							    </table>
				        	</td>
				            
				            <td width="60%" align="right">
				            	※ 일정관리 색상 : 
				            	<font style="background-color:#92d050;padding: 5px">2주전</font>
				            	<font style="background-color:#ffff00;padding: 5px">1주전</font>
<!-- 				            	<font style="background-color:#ffc000;padding: 5px">3일전</font> -->
				            	<font style="background-color:#ff0000;padding: 5px">지남</font>  
														
								<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a>
				            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="createProject()">추가</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="save()">삭제</a>
<!-- 								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a> -->
				            </td>
				        </tr>
				    </table>
				    <script>
						function cellStyler1(val, row, index){
							return cellStyler(row, row.date1);
						}
						function cellStyler2(val, row, index){
							return cellStyler(row, row.date2);
						}
						function cellStyler3(val, row, index){
							return cellStyler(row, row.date3);
						}
						function cellStyler4(val, row, index){
							return cellStyler(row, row.date4);
						}
						function cellStyler5(val, row, index){
							return cellStyler(row, row.date5);
						}
						function cellStyler6(val, row, index){
							return cellStyler(row, row.date6);
						}
						function cellStyler7(val, row, index){
							return cellStyler(row, row.date7);
						}
						function cellStyler8(val, row, index){
							return cellStyler(row, row.date8);
						}
						function cellStyler(row, val){
							if(row.completion=='Y'){
								return '';
							}
							
							var dt;
						    dt = new Date();
						    dt = dt.getFullYear()+""+((dt.getMonth() + 1)<9?"0"+(dt.getMonth() + 1):(dt.getMonth() + 1))+""+(dt.getDate()<10?"0"+dt.getDate():dt.getDate());
							
						    if(val!=null && val.length>0){
							    var valdt = val.substring(0,val.length);
							    
						    	var term = eval(valdt)-eval(dt);
						    	
						        if (term >7 && term <=14){
						        	return 'background-color:#92d050;';
						        }else if(term >=0 && term <=7){
						        	return 'background-color:#ffff00;';
// 						        }else if(term >= 0 && term <=3){
// 						        	return 'background-color:#ffc000;';
						        }else if(term <0){
						        	return 'background-color:#ff0000;';
						        }else{
						        	return '';
						        }
						    }else{
					        	return '';
						    }
						}
						
						function formatContDay(val, row){
							if(row.completion=='Y'){
								return '';	
							}else{
								return val;
							}
						}
						function formatMarginVal(val, row){
							var margin =  eval(row.dist_price) - eval(row.make_price);
							
							return numberComma(margin);
						}
						function formatMarginVal2(val, row){
							var margin =  100 - eval(row.dist_margin);
							
							return margin;
						}

						function format01M(val, row){
							return	formatMonth(row.p1,row.m1,row.pm1);
						}
						function format02M(val, row){
							return	formatMonth(row.p2,row.m2,row.pm2);
						}
						function format03M(val, row){
							return	formatMonth(row.p3,row.m3,row.pm3);
						}
						function format04M(val, row){
							return	formatMonth(row.p4,row.m4,row.pm4);
						}
						function format05M(val, row){
							return	formatMonth(row.p5,row.m5,row.pm5);
						}
						function format06M(val, row){
							return	formatMonth(row.p6,row.m6,row.pm6);
						}
						function format07M(val, row){
							return	formatMonth(row.p7,row.m7,row.pm7);
						}
						function format08M(val, row){
							return	formatMonth(row.p8,row.m8,row.pm8);
						}
						function format09M(val, row){
							return	formatMonth(row.p9,row.m9,row.pm9);
						}
						function format10M(val, row){
							return	formatMonth(row.p10,row.m10,row.pm10);
						}
						function format11M(val, row){
							return	formatMonth(row.p11,row.m11,row.pm11);
						}
						function format12M(val, row){
							return	formatMonth(row.p12,row.m12,row.pm12);
						}
						function formatTM(val, row){
							return	formatMonth(row.pt,row.mt,row.pmt);
						}
						
						
						function formatMonth(p,m, pm){
							var returnM="";
							if(!pm){
								if(p>0){
									returnM +='<span style="color:blue;">+'+numberComma(p)+'</span>';
								}
								returnM+="<br/>";
								if(m>0){
									returnM +='<span style="color:red;">-'+numberComma(m)+'</span>';
								}
							}else{
								
								if(pm>0){
									if(pm<=100){
										returnM = numberComma2(pm);
									}else{
										returnM +='<span style="color:blue;">+'+numberComma2(pm)+'</span>';
									}
								}else{
									returnM +='<span style="color:red;">'+numberComma2(pm)+'</span>';
								}
							}
							
							return returnM;
						}
					</script>
					<table id="dg" class="easyui-datagrid"
							style="width:100%;height:700px;" 
							data-options="iconCls: 'icon-edit',
											  rownumbers:false,
											  singleSelect:true,
											  pagination:true,
											  pageSize:100,
											  method:'get',
											  striped:true,
											  nowrap:false,
											  pageList:[100,50,200,500],
											  showFooter:true"						
							>
						<thead>
							<tr>
								<th rowspan="2" data-options="field:'project_id',align:'center',halign:'center'" width="100">프로젝트번호</th>
						 		<th rowspan="2" data-options="field:'bid_notice_nm',halign:'center',editor:'textbox'" width="250">공고명</th>
<!-- 						 		<th rowspan="2" data-options="field:'bid_notice_no',halign:'center'" width="150" formatter="formatNoticeNo">공고번호</th> -->
								<th rowspan="2" data-options="field:'demand_nm',align:'left',halign:'center'"  width="150" formatter="formatEnter">수요기관</th>
								<th rowspan="2" data-options="field:'cont_company_nm',align:'left',halign:'center'" width="120">수주업체</th>
								<th rowspan="2" data-options="field:'makeList',align:'left',halign:'center'" width="120" formatter="formatCommaEnter">제조업체</th>
								<th rowspan="2" data-options="field:'cont_price',halign:'center',align:'right'" width="120" formatter="numberComma">협력사<br/>수주금액</th>
								<th rowspan="2" data-options="field:'dist_price',halign:'center',align:'right'" width="120" formatter="numberComma">인콘<br/>수주금액</th>
								<th rowspan="2" data-options="field:'make_price',halign:'center',align:'right'" width="120" formatter="numberComma">제조업체<br/>하도금액</th>
								<th rowspan="2" data-options="field:'marginval',halign:'center',align:'right'" width="120" formatter="formatMarginVal">마진금액</th>
								<th rowspan="2" data-options="field:'dist_margin',align:'right',halign:'center'" width="60">최종<br/>마진율</th>
								<th rowspan="2" data-options="field:'completion',align:'center',halign:'center'" width="50">준공<br/>처리</th>
								<th rowspan="2" data-options="field:'cont_term_day',align:'right',halign:'center'" width="50" formatter="formatContDay">준공<br/>Day</th>
								<th colspan="8">일정관리</th>
							</tr>
							<tr>
								<th	data-options="field:'re1',align:'center',width:70 ,halign:'center',styler:cellStyler1" formatter="formatContDay">1</th>
								<th	data-options="field:'re2',align:'center',width:70 ,halign:'center',styler:cellStyler2" formatter="formatContDay">2</th>
								<th	data-options="field:'re3',align:'center',width:70 ,halign:'center',styler:cellStyler3" formatter="formatContDay">3</th>
								<th	data-options="field:'re4',align:'center',width:70 ,halign:'center',styler:cellStyler4" formatter="formatContDay">4</th>
								<th	data-options="field:'re5',align:'center',width:70 ,halign:'center',styler:cellStyler5" formatter="formatContDay">5</th>
								<th	data-options="field:'re6',align:'center',width:70 ,halign:'center',styler:cellStyler6" formatter="formatContDay">6</th>
								<th	data-options="field:'re7',align:'center',width:70 ,halign:'center',styler:cellStyler7" formatter="formatContDay">7</th>
								<th	data-options="field:'re8',align:'center',width:70 ,halign:'center',styler:cellStyler8" formatter="formatContDay">8</th>
							</tr>
						</thead>
					</table>
					
					</div>
					<div title="프로젝트 성과" style="padding:5px">
						<table style="width:100%;">
					        <tr>
					        	<td width="20%"  align="left">
					        		<table style="width:100%;">
								        <tr>
								            <td class="bc">년도</td>
								            <td>
								            	<input id="year" name="year"
													class="easyui-combobox"
													data-options="
													method:'get',
													width:250,
		                 							panelHeight:'auto',
											        valueField: 'year',
											        textField: 'year',
											        data:jsonCode4" />
											</td>
								        </tr>
								    </table>
					        	</td>
					            
					            <td width="80%" align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton btnSearch" data-options="iconCls:'icon-search'" onclick="setGrid3()">조회</a>
					            </td>
					        </tr>
					    </table>
					    <table id="dg3" class="easyui-datagrid"
								style="width:100%;height:700px;" 
								data-options="iconCls: 'icon-edit',
												  rownumbers:false,
												  singleSelect:true,
												  method:'get',
												  striped:true,
												  nowrap:false,
												  showFooter:true"						
								>
							<thead>
								<tr>
							 		<th rowspan="2" data-options="field:'bid_notice_nm',halign:'center'" width="300">건명</th>
<!-- 							 		<th rowspan="2" data-options="field:'tax_dt',align:'center',halign:'center'" width="100" formatter="formatDate">발행일</th> -->
							 		<th colspan="13">매출입액(부가세 별도)</th>
									<th	rowspan="2" data-options="field:'per',align:'right',width:110 ,halign:'center'">원가율</th>
								</tr>
								<tr>
									<th	data-options="field:'01M',align:'right',width:110 ,halign:'center'" formatter="format01M">1월</th>
									<th	data-options="field:'02M',align:'right',width:110 ,halign:'center'" formatter="format02M">2월</th>
									<th	data-options="field:'03M',align:'right',width:110 ,halign:'center'" formatter="format03M">3월</th>
									<th	data-options="field:'04M',align:'right',width:110 ,halign:'center'" formatter="format04M">4월</th>
									<th	data-options="field:'05M',align:'right',width:110 ,halign:'center'" formatter="format05M">5월</th>
									<th	data-options="field:'06M',align:'right',width:110 ,halign:'center'" formatter="format06M">6월</th>
									<th	data-options="field:'07M',align:'right',width:110 ,halign:'center'" formatter="format07M">7월</th>
									<th	data-options="field:'08M',align:'right',width:110 ,halign:'center'" formatter="format08M">8월</th>
									<th	data-options="field:'09M',align:'right',width:110 ,halign:'center'" formatter="format09M">9월</th>
									<th	data-options="field:'10M',align:'right',width:110 ,halign:'center'" formatter="format10M">10월</th>
									<th	data-options="field:'11M',align:'right',width:110 ,halign:'center'" formatter="format11M">11월</th>
									<th	data-options="field:'12M',align:'right',width:110 ,halign:'center'" formatter="format12M">12월</th>
									<th	data-options="field:'tm',align:'right',width:110 ,halign:'center'" formatter="formatTM">총계</th>
								</tr>
							</thead>
						</table>
						<script>
						
						</script>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="projectDlg" class="easyui-dialog" title="프로젝트 정보"
			data-options="iconCls:'icon-save',modal:true,closed:true"
			style="width: 50%; height: 850px;">
			<div class="easyui-layout" style="width:100%;height:100%; border:0">
				<div data-options="region:'center'">
					<table style="width:100%;">
				        <tr>
				            <td width="60%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save2()">저장</a>
				            </td>
				        </tr>
				    </table>
				    
					<div id="subTab"  class="easyui-tabs" data-options="fit:true,border:false,plain:true">
					 	<div title="계약현황" style="padding:5px">
					 		<div style="height: 100%;overflow:auto">
					 			<input type="hidden" id="project_id" value="" />
						 	<table style="width: 100%">
								<tr>
									<td class="bc" width="150px">공고번호</td>
									<td colspan="9"><input type="text" class="easyui-textbox" id="bid_notice_no"> <input type="text" class="easyui-textbox" id="bid_notice_cha_no"   style="width:50px;"></td>
								</tr>
								<tr>
									<td class="bc">공고명</td>
									<td colspan="9"><input type="text" class="easyui-textbox" id="bid_notice_nm"   style="width:100%;" ></td>
								</tr>
								<tr>
									<td class="bc">공고기관</td>
									<td colspan="9"><input type="text" class="easyui-textbox" id="order_agency_nm"  style="width:100%;" ></td>
								</tr>
								<tr>
									<td class="bc">수요기관명</td>
									<td colspan="9">
										<table style="width:100%;border-spacing: 0">
											<tr>
												<td rowspan="2"><input type="text" class="easyui-textbox" id="demand_nm" style="width:250px;"></td>
												<td class="bc">계약</td>
												<td>
													<table style="width:100%;border-spacing: 0">
														<tr>
															<td class="bc">담당자</td>
															<td><input type="text" class="easyui-textbox" id="demand_user_nm1" style="width:50px"></td>
															<td class="bc">연락처</td>
															<td><input type="text" class="easyui-textbox" id="demand_tel1" style="width:80px"></td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td class="bc">검수</td>
												<td>
													<table style="width:100%;border-spacing: 0">
														<tr>
															<td class="bc">담당자</td>
															<td><input type="text" class="easyui-textbox" id="demand_user_nm2" style="width:50px"></td>
															<td class="bc">연락처</td>
															<td><input type="text" class="easyui-textbox" id="demand_tel2" style="width:80px"></td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td class="bc">협력사수주업체명</td>
									<td colspan="9">
										<table style="width:100%;border-spacing: 0">
											<tr>
												<td><input type="text" class="easyui-textbox" id="cont_company_nm"></td>
												<td class="bc">담당자</td>
												<td><input type="text" class="easyui-textbox" id="cont_user_nm" style="width:50px"></td>
												<td class="bc">연락처</td>
												<td><input type="text" class="easyui-textbox" id="cont_tel" style="width:80px"></td>
												<td class="bc">협력수주금액</td>
												<td><input type="text" class="easyui-numberbox" id="cont_price" style="width:100px"  data-options="groupSeparator:',',onChange:marginOnChange">원</td>
												<td class="bc">마진율</td>
												<td><input type="text" class="easyui-numberbox" id="cont_margin" data-options="width:50,min:0,max:200,precision:2,disabled:true">%</td>
											</tr>
										</table>
									</td>
									
								</tr>
								<tr>
									<td class="bc">인콘</td>
									<td colspan="9">
										<table style="width:100%;border-spacing: 0">
											<tr>
												<td><input type="text" class="easyui-textbox" id="dist_nm" ></td>
												<td class="bc">담당자</td>
												<td><input type="text" class="easyui-textbox" id="dist_user_nm" style="width:50px"></td>
												<td class="bc">연락처</td>
												<td><input type="text" class="easyui-textbox" id="dist_tel" style="width:80px"></td>
												<td class="bc">유통계약금액</td>
												<td><input type="text" class="easyui-numberbox" id="dist_price" style="width:100px" data-options="groupSeparator:',',onChange:marginOnChange">원</td>
												<td class="bc">마진율</td>
												<td><input type="text" class="easyui-numberbox" id="dist_margin" data-options="width:50,min:0,max:200,precision:2,disabled:true">%</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td class="bc">제조업체</td>
									<td colspan="9">
										<table style="width:100%;">
									        <tr>
									            <td width="60%" align="right">
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append2()">추가</a>
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit2()">삭제</a>
									            </td>
									        </tr>
									    </table>
										<table id="tab1" class="easyui-datagrid"
												style="width:100%;height:150px;" 
												
												data-options="iconCls: 'icon-edit',
															rownumbers:true,
															singleSelect:true,
															striped:true,
											  				nowrap:false,
														    onClickCell: onClickCell2, onEndEdit: onEndEdit2
															"						
												>
											<thead>
												<tr>
											 		<th data-options="field:'make_company_nm',halign:'center',editor:'textbox'" width="150">제조업체</th>
											 		<th data-options="field:'make_price',align:'right', halign:'center',editor:'numberbox'" formatter="numberComma" width="150">제조계약금액</th>
											 		<th data-options="field:'make_user_nm',align:'center', halign:'center',editor:'textbox'" width="100">담당자</th>
											 		<th data-options="field:'make_tel',align:'center', halign:'center',editor:'textbox'" width="100">연락처</th>
											 		<th data-options="field:'make_bigo',align:'left', halign:'center',editor:'textbox'" width="200">비고</th>
												</tr>
											</thead>
										</table>
									</td>
								</tr>
								<tr>
									<td class="bc">총하도금액</td>
									<td colspan="9"><input type="text" class="easyui-textbox" id="total_price"  data-options="disabled:true" >원</td>
								</tr>
								<tr>
									<td class="bc">계약기간</td>
									<td colspan="4"><input class="easyui-datebox" id="cont_start_dt"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											~ <input class="easyui-datebox" id="cont_end_dt"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td class="bc">세금계산서 발행일</td>
									<td colspan="4"><input class="easyui-datebox" id="tax_dt"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
								</tr>
								<tr>
									<td class="bc">지급조건</td>
									<td colspan="9">
										<table style="width: 100%;border-spacing: 0">
											<tr>
												<td class="bc">수주조건</td>
												<td><input type="text" class="easyui-textbox" id="demand_condition" style="width:250px;"></td>
												<td class="bc">외주조건</td>
												<td><input type="text" class="easyui-textbox" id="order_condition" style="width:250px;"></td>
												<td class="bc">준공처리</td>
												<td><input class="easyui-switchbutton" id="completion" data-options="onText:'Y',offText:'N'"></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr style="display: none">
									<td class="bc">세금계산서</td>
									<td colspan="2"><input class="easyui-switchbutton" id="tax" data-options="onText:'Y',offText:'N'"></td>
									<td class="bc">증권발행</td>
									<td colspan="2"><input class="easyui-switchbutton" id="securities" data-options="onText:'Y',offText:'N'"></td>
								</tr>
								<tr>
									<td class="bc">수주</td>
									<td colspan="9">
										<table style="width: 100%;border-spacing: 0">
											<tr>
												<td class="bc">계산서</td>
												<td>
													<input id="s_bill_cd"
																class="easyui-combobox"
																data-options="
																method:'get',
																width:150,
																panelHeight:'auto',
														        valueField: 'cd',
														        textField: 'cd_nm',
														        data:jsonCode1" />
												</td>
												<td class="bc">수금</td>
												<td>
													<input id="s_collect_cd"
																class="easyui-combobox"
																data-options="
																method:'get',
																width:150,
																panelHeight:'auto',
														        valueField: 'cd',
														        textField: 'cd_nm',
														        data:jsonCode2" />
												</td>
												<td class="bc">증권</td>
												<td>
													<input id="s_secur_cd"
																class="easyui-combobox"
																data-options="
																method:'get',
																width:150,
																panelHeight:'auto',
														        valueField: 'cd',
														        textField: 'cd_nm',
														        data:jsonCode3" />
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td class="bc">외주</td>
									<td colspan="9">
										<table style="width: 100%;border-spacing: 0">
											<tr>
												<td class="bc">계산서</td>
												<td>
													<input id="o_bill_cd"
																class="easyui-combobox"
																data-options="
																method:'get',
																width:150,
																panelHeight:'auto',
														        valueField: 'cd',
														        textField: 'cd_nm',
														        data:jsonCode1" />
												</td>
												<td class="bc">수금</td>
												<td>
													<input id="o_collect_cd"
																class="easyui-combobox"
																data-options="
																method:'get',
																width:150,
																panelHeight:'auto',
														        valueField: 'cd',
														        textField: 'cd_nm',
														        data:jsonCode2" />
												</td>
												<td class="bc">증권</td>
												<td>
													<input id="o_secur_cd"
																class="easyui-combobox"
																data-options="
																method:'get',
																width:150,
																panelHeight:'auto',
														        valueField: 'cd',
														        textField: 'cd_nm',
														        data:jsonCode3" />
												</td>
											</tr>
										</table>
									</td>
								</tr>
									
								<tr>
									<td class="bc">첨부파일</td>
									<td colspan="9">
									
<form id="uploadForm" enctype="multipart/form-data">
										<table style="width: 100%;">
											<tr>
												<td class="bc">수주계약서</td>
												<td>
													<div style="width:100%;">
													     <input id="file_id1" class="easyui-filebox" name="file1" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
														 <a id="file_link1" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
														 <a id="file_remove1" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
													</div>
												</td>
											</tr>
											<tr>
												<td class="bc">하도계약서</td>
												<td>
													<div style="width:100%;">
													     <input id="file_id2" class="easyui-filebox" name="file2" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
														 <a id="file_link2" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
														 <a id="file_remove2" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
													</div>
												</td>
											</tr>
											<tr>
												<td class="bc">기술협상서</td>
												<td>
													<div style="width:100%;">
													     <input id="file_id3" class="easyui-filebox" name="file3" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
														 <a id="file_link3" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
														 <a id="file_remove3" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
													</div>
												</td>
											</tr>
											<tr>
												<td class="bc">공고문</td>
												<td>
													<div style="width:100%;">
													     <input id="file_id4" class="easyui-filebox" name="file4" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
														 <a id="file_link4" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
														 <a id="file_remove4" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
													</div>
												</td>
											</tr>
											<tr>
												<td class="bc">시방서</td>
												<td>
													<div style="width:100%;">
													     <input id="file_id5" class="easyui-filebox" name="file5" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
														 <a id="file_link5" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
														 <a id="file_remove5" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
													</div>
												</td>
											</tr>
										</table>
</form>

									</td>
								</tr>
							</table>
<!-- <button id="btn-upload">file upload</button> -->
					 		</div>
					 	</div>
					 	<div title="진행현황" style="padding:5px">
					 		<table style="width:100%;">
						        <tr>
						            <td width="60%" align="right">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append()">추가</a>
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit()">삭제</a>
						            </td>
						        </tr>
						    </table>
						    <table id="tab2" class="easyui-datagrid"
									style="width:100%;height:300px;" 
									
									data-options="iconCls: 'icon-edit',
												rownumbers:true,
												singleSelect:true,
												striped:true,
											  	nowrap:false,
											    sortName:'project_start_dt',
											    sortOrder:'desc',
											    onClickCell: onClickCell, onEndEdit: onEndEdit
												"						
									>
								<thead>
									<tr>
								 		<th data-options="field:'project_start_dt',align:'center',halign:'center',sortable:true,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}" width="150">시작일</th>
								 		<th data-options="field:'project_end_dt',align:'center',halign:'center',sortable:true,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}" width="150">종료일</th>
								 		<th data-options="field:'alarm',align:'center',halign:'center',sortable:true,editor:{type:'checkbox',options:{on:'Y',off:''}}" width="50">알람</th>
								 		<th data-options="field:'bigo',halign:'center',editor:'textbox'" width="400">비고</th>
									</tr>
								</thead>
							</table>
							
							<table style="width: 200px;border-spacing: 1px">
								<tr>
									<td class="bc" colspan="3">일정관리</td>
								</tr>
								<tr>
									<td class="bc">1</td>
									<td><input class="easyui-datebox" id="day1"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note1" style="width:400px">
									</td>
								</tr>
								<tr>
									<td class="bc">2</td>
									<td><input class="easyui-datebox" id="day2"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note2" style="width:400px">
									</td>
								</tr>
								<tr>
									<td class="bc">3</td>
									<td><input class="easyui-datebox" id="day3"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note3" style="width:400px">
									</td>
								</tr>
								<tr>
									<td class="bc">4</td>
									<td><input class="easyui-datebox" id="day4"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note4" style="width:400px">
									</td>
								</tr>
								<tr>
									<td class="bc">5</td>
									<td><input class="easyui-datebox" id="day5"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note5" style="width:400px">
									</td>
								</tr>
								<tr>
									<td class="bc">6</td>
									<td><input class="easyui-datebox" id="day6"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note6" style="width:400px">
									</td>
								</tr>
								<tr>
									<td class="bc">7</td>
									<td><input class="easyui-datebox" id="day7"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note7" style="width:400px">
									</td>
								</tr>
								<tr>
									<td class="bc">8</td>
									<td><input class="easyui-datebox" id="day8"  style="width:100px;"
											data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
									<td>
										<input type="text" class="easyui-textbox" id="note8" style="width:400px">
									</td>
								</tr>
							</table>
					 	</div>
					 	<div title="매출입액" style="padding:5px">
					 		<table style="width:100%;">
						        <tr>
						            <td width="60%" align="right">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append3()">추가</a>
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit3()">삭제</a>
						            </td>
						        </tr>
						    </table>
						    <table id="tab3" class="easyui-datagrid"
									style="width:100%;height:300px;" 
									
									data-options="iconCls: 'icon-edit',
												rownumbers:true,
												singleSelect:true,
												striped:true,
											  	nowrap:false,
											    sortName:'tax_dt',
											    sortOrder:'desc',
											    onClickCell: onClickCell3, onEndEdit: onEndEdit3
												"						
									>
								<thead>
									<tr>
								 		<th data-options="field:'tax_dt',align:'center',halign:'center',sortable:true,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}" width="150">발행일</th>
								 		<th data-options="field:'sales',align:'right', halign:'center',editor:'numberbox'" formatter="numberComma" width="150">매출원가</th>
								 		<th data-options="field:'purchase',align:'right', halign:'center',editor:'numberbox'" formatter="numberComma" width="150">매입원가</th>
									</tr>
								</thead>
							</table>
					 	</div>
					</div>
				 </div>
			</div>
	</div>


	
	
	<script>
	var editIndex = undefined;
	var editIndex2 = undefined;
	var editIndex3 = undefined;
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#tab2').datagrid('validateRow', editIndex)){
	 		$('#tab2').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}

	function onClickCell(index, field){
		if (editIndex != index){
			if (endEditing()){
				$('#tab2').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				var selecter = $('#tab2').datagrid('getSelected');
				
				var ed = $('#tab2').datagrid('getEditor', {index:index,field:field});
				if (ed){
					($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
				}
				
				editIndex = index;
			} else {
				$('#tab2').datagrid('selectRow', editIndex);
			}
			eventBtn();
		}
	}
	function append(){
		if (endEditing()){
			$('#tab2').datagrid('appendRow',{status:'P'});
			editIndex = $('#tab2').datagrid('getRows').length-1;
			$('#tab2').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
		}
	}
	
	 function onEndEdit(index, row){
        // var ed = $(this).datagrid('getEditor', {
        //     index: index,
        //     field: 'productid'
       //  });
        // row.productname = $(ed.target).combobox('getText');
     }
	
	function removeit(){
		if (editIndex == undefined){return}
		$('#tab2').datagrid('cancelEdit', editIndex)
				.datagrid('deleteRow', editIndex);
		editIndex = undefined;
	}
	
	
	
	function endEditing2(){
		if (editIndex2 == undefined){return true}
		if ($('#tab1').datagrid('validateRow', editIndex2)){
	 		$('#tab1').datagrid('endEdit', editIndex2);
			editIndex2 = undefined;
			return true;
		} else {
			return false;
		}
	}
	function onClickCell2(index, field){
		if (editIndex2 != index){
			if (endEditing2()){
				$('#tab1').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				var selecter = $('#tab1').datagrid('getSelected');
				
				var ed = $('#tab1').datagrid('getEditor', {index:index,field:field});
				if (ed){
					($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
				}
				
				editIndex2 = index;
			} else {
				$('#tab1').datagrid('selectRow', editIndex2);
			}
		}
	}
	function append2(){
		if (endEditing2()){
			$('#tab1').datagrid('appendRow',{status:'P'});
			editIndex2 = $('#tab2').datagrid('getRows').length-1;
			$('#tab1').datagrid('selectRow', editIndex2)
					.datagrid('beginEdit', editIndex2);
		}
	}
	function removeit2(){
		if (editIndex2 == undefined){return}
		$('#tab1').datagrid('cancelEdit', editIndex2)
				.datagrid('deleteRow', editIndex2);
		editIndex2 = undefined;
		totalCnt();
	}
	
	function onEndEdit2(index, row){
		totalCnt();
     }

	function totalCnt(){
		
		var num=0;
		for(var i=0; i<$('#tab1').datagrid('getRows').length; i++){
			num +=formatNumber($('#tab1').datagrid('getRows')[i].make_price);
        }
		
		$('#total_price').textbox('setValue',numberComma(num));
		
		calculationMagin();
	}
	
	function marginOnChange(newValue,oldValue){
		calculationMagin();
	}
	
	function calculationMagin(){
		var total_price = formatNumber($("#total_price").numberbox('getValue').replaceAll(",",""));
		var cont_price = formatNumber($("#cont_price").numberbox('getValue').replaceAll(",",""));
		var dist_price = formatNumber($("#dist_price").numberbox('getValue').replaceAll(",",""));
		
		if(cont_price==0){
			if(dist_price==0){
				$("#cont_margin").numberbox('setValue',0.00);
				$("#dist_margin").numberbox('setValue',0.00);
			}else{
				$("#cont_margin").numberbox('setValue',0.00);
				$("#dist_margin").numberbox('setValue',((dist_price - total_price)/dist_price)*100);
			}
		}else{
			if(dist_price==0){
				$("#cont_margin").numberbox('setValue',((cont_price - total_price)/cont_price)*100);
				$("#dist_margin").numberbox('setValue',((dist_price - total_price)/cont_price)*100);
			}else{
				$("#cont_margin").numberbox('setValue',((cont_price - dist_price)/cont_price)*100);
				$("#dist_margin").numberbox('setValue',((dist_price - total_price)/cont_price)*100);
			}
		}
	}
	
	
	
	
	function formatMargin(val,row){
		if(row.dist_margin!=null){
	     return formatNumber(row.dist_margin) + formatNumber(row.cont_margin);
		}else{
			return "";
		}
	}
	
	
	function endEditing3(){
		if (editIndex3 == undefined){return true}
		if ($('#tab3').datagrid('validateRow', editIndex3)){
	 		$('#tab3').datagrid('endEdit', editIndex3);
			editIndex3 = undefined;
			return true;
		} else {
			return false;
		}
	}

	function onClickCell3(index, field){
		if (editIndex3 != index){
			if (endEditing3()){
				$('#tab3').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				var selecter = $('#tab3').datagrid('getSelected');
				
				var ed = $('#tab3').datagrid('getEditor', {index:index,field:field});
				if (ed){
					($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
				}
				
				editIndex3 = index;
			} else {
				$('#tab3').datagrid('selectRow', editIndex3);
			}
			eventBtn();
		}
	}
	function append3(){
		if (endEditing3()){
			$('#tab3').datagrid('appendRow',{status:'P'});
			editIndex3 = $('#tab3').datagrid('getRows').length-1;
			$('#tab3').datagrid('selectRow', editIndex3)
					.datagrid('beginEdit', editIndex3);
		}
	}
	
	 function onEndEdit3(index, row){
        // var ed = $(this).datagrid('getEditor', {
        //     index: index,
        //     field: 'productid'
       //  });
        // row.productname = $(ed.target).combobox('getText');
     }
	
	function removeit3(){
		if (editIndex3 == undefined){return}
		$('#tab3').datagrid('cancelEdit', editIndex3)
				.datagrid('deleteRow', editIndex3);
		editIndex3 = undefined;
	}
	
	
	function save(){
    	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
	        if (r){
	        	if (endEditing()){
	    			var $dg = $("#dg");

    				var effectRow = new Object();
					effectRow["project_id"] = $dg.datagrid('getSelected').project_id;
    				$.post("<c:url value='/project/deleteProjectList.do'/>", effectRow, function(rsp) {
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
		
		if($("#bid_notice_no").textbox("getValue").length==0 || $("#bid_notice_cha_no").textbox("getValue").length==0){
			$.messager.alert("알림", "공고번호를 입력해주세요.");
			return;
		}
		if($("#bid_notice_nm").textbox("getValue").length==0){
			$.messager.alert("알림", "공고명을 입력해주세요.");
			return;
		}
		if($("#cont_start_dt").textbox("getValue").length==0 || $("#cont_end_dt").textbox("getValue").length==0){
			$.messager.alert("알림", "계약기간을 입력해주세요.");
			return;
		}
		
    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	        if (r){
	        	if (endEditing()){
	        		
	        		if(endEditing2()){
	        		if(endEditing3()){
	        			
// 		    			var effectRow = new Object();
		    			var form = new FormData(document.getElementById('uploadForm'));
		    			
						var $dg = $("#tab1");
		    			
		    			if ($dg.datagrid('getChanges').length) {
							var inserted = $dg.datagrid('getChanges', "inserted");
		    				var deleted = $dg.datagrid('getChanges', "deleted");
		    				var updated = $dg.datagrid('getChanges', "updated");
		    				
		    				var effectRow = new Object();
		    				if (inserted.length) {
// 								effectRow["inserted1"] = JSON.stringify(inserted);
								form.append("inserted1", encodeURIComponent(JSON.stringify(inserted)));
							}
		    				if (deleted.length) {
// 		    					effectRow["deleted1"] = JSON.stringify(deleted);
								form.append("deleted1", encodeURIComponent(JSON.stringify(deleted)));
		    				}
		    				if (updated.length) {
// 		    					effectRow["updated1"] = JSON.stringify(updated);
								form.append("updated1", encodeURIComponent(JSON.stringify(updated)));
		    				}
		    			}
		    			
		    			$dg = $("#tab2");
		    			
		    			if ($dg.datagrid('getChanges').length) {
							var inserted = $dg.datagrid('getChanges', "inserted");
		    				var deleted = $dg.datagrid('getChanges', "deleted");
		    				var updated = $dg.datagrid('getChanges', "updated");
		    				
		    				var effectRow = new Object();
		    				if (inserted.length) {
// 								effectRow["inserted2"] = JSON.stringify(inserted);
								form.append("inserted2", encodeURIComponent(JSON.stringify(inserted)));
							}
		    				if (deleted.length) {
// 		    					effectRow["deleted2"] = JSON.stringify(deleted);
								form.append("deleted2", encodeURIComponent(JSON.stringify(deleted)));
		    				}
		    				if (updated.length) {
// 		    					effectRow["updated2"] = JSON.stringify(updated);
								form.append("updated2", encodeURIComponent(JSON.stringify(updated)));
		    				}
		    			}
		    			
		    			$dg = $("#tab3");
		    			
		    			if ($dg.datagrid('getChanges').length) {
							var inserted = $dg.datagrid('getChanges', "inserted");
		    				var deleted = $dg.datagrid('getChanges', "deleted");
		    				var updated = $dg.datagrid('getChanges', "updated");
		    				
		    				var effectRow = new Object();
		    				if (inserted.length) {
// 								effectRow["inserted2"] = JSON.stringify(inserted);
								form.append("inserted3", encodeURIComponent(JSON.stringify(inserted)));
							}
		    				if (deleted.length) {
// 		    					effectRow["deleted2"] = JSON.stringify(deleted);
								form.append("deleted3", encodeURIComponent(JSON.stringify(deleted)));
		    				}
		    				if (updated.length) {
// 		    					effectRow["updated2"] = JSON.stringify(updated);
								form.append("updated3", encodeURIComponent(JSON.stringify(updated)));
		    				}
		    			}
		    			
// 		    			effectRow["project_id"] = $("#project_id").val();
// 	    				effectRow["bid_notice_no"] = $("#bid_notice_no").textbox("getValue");
// 	    				effectRow["bid_notice_cha_no"] = $("#bid_notice_cha_no").textbox("getValue");
// 	    				effectRow["bid_notice_nm"] = $("#bid_notice_nm").textbox("getValue");
// 	    				effectRow["order_agency_nm"] = $("#order_agency_nm").textbox("getValue");
// 	    				effectRow["demand_nm"] = $("#demand_nm").textbox("getValue");
// 	    				effectRow["cont_company_nm"] = $("#cont_company_nm").textbox("getValue");
// 	    				effectRow["cont_user_nm"] = $("#cont_user_nm").textbox("getValue");
// 	    				effectRow["cont_tel"] = $("#cont_tel").textbox("getValue");
// 	    				effectRow["cont_price"] = $("#cont_price").textbox("getValue");
// 	    				effectRow["cont_margin"] = $("#cont_margin").textbox("getValue");
// 	    				effectRow["cont_start_dt"] = $("#cont_start_dt").textbox("getValue");
// 	    				effectRow["cont_end_dt"] = $("#cont_end_dt").textbox("getValue");
// 	    				effectRow["dist_nm"] = $("#dist_nm").textbox("getValue");
// 	    				effectRow["dist_price"] = $("#dist_price").textbox("getValue");
// 	    				effectRow["dist_margin"] = $("#dist_margin").textbox("getValue");
// 	    				effectRow["demand_condition"] = $("#demand_condition").textbox("getValue");
// 	    				effectRow["order_condition"] = $("#order_condition").textbox("getValue");
// 	    				effectRow["tax"] = $("#tax").switchbutton("options").checked?'Y':'N';
// 	    				effectRow["securities"] = $("#securities").switchbutton("options").checked?'Y':'N';
// 	    				effectRow["completion"] = $("#completion").switchbutton("options").checked?'Y':'N';
// 	    				effectRow["s_bill_cd"] = $("#s_bill_cd").combogrid("getValue");
// 	    				effectRow["s_collect_cd"] = $("#s_collect_cd").combogrid("getValue");
// 	    				effectRow["s_secur_cd"] = $("#s_secur_cd").combogrid("getValue");
// 	    				effectRow["o_bill_cd"] = $("#o_bill_cd").combogrid("getValue");
// 	    				effectRow["o_collect_cd"] = $("#o_collect_cd").combogrid("getValue");
// 	    				effectRow["o_secur_cd"] = $("#o_secur_cd").combogrid("getValue");
// 	    				effectRow["file_id1"] = $("#file_id1").filebox("getValue");
	    				
		    			form.append("project_id", encodeURIComponent($("#project_id").val()));
		    			form.append("bid_notice_no", encodeURIComponent($("#bid_notice_no").textbox("getValue")));
	    				form.append("bid_notice_cha_no", encodeURIComponent($("#bid_notice_cha_no").textbox("getValue")));
	    				form.append("bid_notice_nm", encodeURIComponent($("#bid_notice_nm").textbox("getValue")));
	    				form.append("order_agency_nm", encodeURIComponent($("#order_agency_nm").textbox("getValue")));
	    				form.append("demand_nm", encodeURIComponent($("#demand_nm").textbox("getValue")));
	    				form.append("demand_user_nm1", encodeURIComponent($("#demand_user_nm1").textbox("getValue")));
	    				form.append("demand_tel1", encodeURIComponent($("#demand_tel1").textbox("getValue")));
	    				form.append("demand_user_nm2", encodeURIComponent($("#demand_user_nm2").textbox("getValue")));
	    				form.append("demand_tel2", encodeURIComponent($("#demand_tel2").textbox("getValue")));
	    				form.append("cont_company_nm", encodeURIComponent($("#cont_company_nm").textbox("getValue")));
	    				form.append("cont_user_nm", encodeURIComponent($("#cont_user_nm").textbox("getValue")));
	    				form.append("cont_tel", encodeURIComponent($("#cont_tel").textbox("getValue")));
	    				form.append("cont_price", encodeURIComponent($("#cont_price").textbox("getValue")));
	    				form.append("cont_margin", encodeURIComponent($("#cont_margin").textbox("getValue")));
	    				form.append("cont_start_dt", encodeURIComponent($("#cont_start_dt").textbox("getValue")));
	    				form.append("cont_end_dt", encodeURIComponent($("#cont_end_dt").textbox("getValue")));
	    				form.append("tax_dt", encodeURIComponent($("#tax_dt").textbox("getValue")));
	    				form.append("dist_nm", encodeURIComponent($("#dist_nm").textbox("getValue")));
	    				form.append("dist_user_nm", encodeURIComponent($("#dist_user_nm").textbox("getValue")));
	    				form.append("dist_tel", encodeURIComponent($("#dist_tel").textbox("getValue")));
	    				form.append("dist_price", encodeURIComponent($("#dist_price").textbox("getValue")));
	    				form.append("dist_margin", encodeURIComponent($("#dist_margin").textbox("getValue")));
	    				form.append("demand_condition", encodeURIComponent($("#demand_condition").textbox("getValue")));
	    				form.append("order_condition", encodeURIComponent($("#order_condition").textbox("getValue")));
	    				form.append("tax", encodeURIComponent($("#tax").switchbutton("options").checked?'Y':'N'));
	    				form.append("securities", encodeURIComponent($("#securities").switchbutton("options").checked?'Y':'N'));
	    				form.append("completion", encodeURIComponent($("#completion").switchbutton("options").checked?'Y':'N'));
	    				form.append("s_bill_cd", encodeURIComponent($("#s_bill_cd").combogrid("getValue")));
	    				form.append("s_collect_cd", encodeURIComponent($("#s_collect_cd").combogrid("getValue")));
	    				form.append("s_secur_cd", encodeURIComponent($("#s_secur_cd").combogrid("getValue")));
	    				form.append("o_bill_cd", encodeURIComponent($("#o_bill_cd").combogrid("getValue")));
	    				form.append("o_collect_cd", encodeURIComponent($("#o_collect_cd").combogrid("getValue")));
	    				form.append("o_secur_cd", encodeURIComponent($("#o_secur_cd").combogrid("getValue")));
	    				form.append("file_id1", encodeURIComponent($("#file_id1").filebox("getText")));
	    				form.append("file_id2", encodeURIComponent($("#file_id2").filebox("getText")));
	    				form.append("file_id3", encodeURIComponent($("#file_id3").filebox("getText")));
	    				form.append("file_id4", encodeURIComponent($("#file_id4").filebox("getText")));
	    				form.append("file_id5", encodeURIComponent($("#file_id5").filebox("getText")));

	    				form.append("day1", encodeURIComponent($("#day1").textbox("getValue")));
	    				form.append("day2", encodeURIComponent($("#day2").textbox("getValue")));
	    				form.append("day3", encodeURIComponent($("#day3").textbox("getValue")));
	    				form.append("day4", encodeURIComponent($("#day4").textbox("getValue")));
	    				form.append("day5", encodeURIComponent($("#day5").textbox("getValue")));
	    				form.append("day6", encodeURIComponent($("#day6").textbox("getValue")));
	    				form.append("day7", encodeURIComponent($("#day7").textbox("getValue")));
	    				form.append("day8", encodeURIComponent($("#day8").textbox("getValue")));
	    				form.append("note1", encodeURIComponent($("#note1").textbox("getValue")));
	    				form.append("note2", encodeURIComponent($("#note2").textbox("getValue")));
	    				form.append("note3", encodeURIComponent($("#note3").textbox("getValue")));
	    				form.append("note4", encodeURIComponent($("#note4").textbox("getValue")));
	    				form.append("note5", encodeURIComponent($("#note5").textbox("getValue")));
	    				form.append("note6", encodeURIComponent($("#note6").textbox("getValue")));
	    				form.append("note7", encodeURIComponent($("#note7").textbox("getValue")));
	    				form.append("note8", encodeURIComponent($("#note8").textbox("getValue")));
// 	    				$.post("<c:url value='/project/updateProjectList.do'/>", effectRow, function(rsp) {
// 	    					if(rsp.status){
// 	    						$.messager.alert("알림", "저장하였습니다.");
// 	    						 $("#dg").datagrid('reload');
// 	    						$('#projectDlg').dialog('close');
	    						
// 	    						calendarData();
// 	    					}
// 	    				}, "JSON").error(function() {
// 	    					$.messager.alert("알림", "저장에러！");
// 	    				});

// 						console.log($("#bid_notice_nm").textbox("getValue"))
	    				
	    				    $.ajax({
	    				      url: "<c:url value='/project/updateProjectList.do'/>",
	    				      data: form,
	    				      dataType: 'text',
	    				      processData: false,
	    				      contentType: false,
	    				      type: 'POST',
	    				      success: function (rsp) {
		    				    	  $.messager.alert("알림", "저장하였습니다.");
		 	    						 $("#dg").datagrid('reload');
		 	    						$('#projectDlg').dialog('close');
			    						
		 	    						calendarData();
	    				      },
	    				      error: function (jqXHR) {
	    				        console.log('error');
	    				      }
	    				    });
	    				
	        		}
	        		}
	        	
	    			
	    			
	    		}
	        }
    	});
	}
	
	
	


	
	</script>
	
</body>
</html>