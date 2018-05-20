<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>투찰사관리</title>
<%@ include file="/include/session.jsp" %>
	
<script>
$(document).ready(function() {
	init();
	keydownEvent();
	setGrid();
	$('#search_cd').combobox('setValue', 1);
});

var jsonData1=null;
var jsonData2=null;
var jsonData3=[{search_cd:1,search_nm:'중소기업정보'},{search_cd:2,search_nm:'여성기업정보'},{search_cd:3,search_nm:'장애인기업정보'}];
var jsonData4=null;

$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/business/comboEvalList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		eval_type : '신용평가',
		eval_group : '신용평가'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData1=json;
   }
});



$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/business/comboEvalList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		eval_type : '기업규모',
		eval_group : '신용평가'
	}
   ,dataType: "json"
   ,success:function(json){
  	 jsonData2=json;
   }
});

$.ajax({ 
    type: "GET"
   ,url: "<c:url value='/bid/comboList.do'/>"
   ,async: false 
   ,data : {
		searchType :'C',
		cdGroupCd :'main_area_cd'
	}
   ,dataType: "json"
   ,success:function(json){
	   jsonData4=json;
   }
});

function keydownEvent(){
	
	var t = $('#s_company_no');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid();
	   }
	});	

	t = $('#s_company_nm');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid();
	   }
	});	

	t = $('#s_area_txt');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid();
	   }
	});	
	
	t = $('#s_company_no2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid2();
	   }
	});	

	t = $('#s_company_nm2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid2();
	   }
	});	
	
	t = $('#s_company_nm3');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid3();
	   }
	});	

	t = $('#s_area_txt3');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid3();
	   }
	});	
	
	t = $('#s_company_nm4');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid4();
	   }
	});	
	
	t = $('#s_area_txt4');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid4();
	   }
	});	

	t = $('#s_company_no5');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid5();
	   }
	});	
	
	t = $('#s_company_nm5');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid5();
	   }
	});	

	t = $('#s_company_no6');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid6();
	   }
	});	
	
	t = $('#s_company_nm6');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid6();
	   }
	});	

}

function excelDown(){
 	
	$("input[name='s_area_cd']").val($('#s_area_cd').combobox('getValue'));

	$("#excel").submit();

}

function setGrid(){
	$("#bc").datagrid({
		method : "GET",
		   url: "<c:url value='/business/businessList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no').val(),
			s_company_nm : $('#s_company_nm').val(),
			s_area_cd : $('#s_area_cd').combobox('getValue'),
			s_area_txt : $('#s_area_txt').val(),
			s_company_type : $('#s_company_type').val(),
			s_goods_type : $('#s_goods_type').val(),
			s_goods_direct : $('#s_goods_direct').val()
		},
		onLoadSuccess:function(data){
			$('#bc').datagrid('selectRow', 0);
			eventBtn();
			areaCnt(data.cnt);
		}

	});
}

function areaCnt(data){
	$("#서울").text(data.seoul);
	$("#경기").text(data.gg);
	$("#인천").text(data.inchen);
	$("#부산").text(data.busan);
	$("#대구").text(data.daegu);
	$("#광주").text(data.gwangju);
	$("#대전").text(data.daejaen);
	$("#울산").text(data.ulsan);
	$("#강원").text(data.gw);
	$("#충북").text(data.cn);
	$("#충남").text(data.cs);
	$("#전북").text(data.jn);
	$("#전남").text(data.js);
	$("#경북").text(data.gn);
	$("#경남").text(data.gs);
	$("#제주").text(data.jj);
	$("#세종").text(data.seajong);
	$("#기타1").text(data.order);

	$("#소기업").text(data.scale1);
	$("#소상공인").text(data.scale2);
	$("#중기업").text(data.scale3);
	$("#없음").text(data.scale4);
	$("#기타2").text(data.scale5);
}

function setGrid3(){
	$("#bc3").datagrid({
		method : "GET",
		   url: "<c:url value='/business/orderBusinessList.do'/>",
		queryParams : {
			s_company_nm : $('#s_company_nm3').textbox("getValue"),
			s_goods_type : $('#s_goods_type3').textbox("getValue"),
			s_area_txt : $('#s_area_txt3').textbox("getValue")
		},
		onLoadSuccess:function(){
			$('#bc3').datagrid('selectRow', 0);
			eventBtn();
		}

	});
}

function setGrid4(){
	$("#bc4").datagrid({
		method : "GET",
		   url: "<c:url value='/business/orderBusinessList2.do'/>",
		queryParams : {
			s_company_nm : $('#s_company_nm4').textbox("getValue"),
			s_area_txt : $('#s_area_txt4').textbox("getValue"),
			search_cd : $("#search_cd").combogrid("getValue")
		},
		onLoadSuccess:function(){
			$('#bc4').datagrid('selectRow', 0);
		}
	});
}

function eventBtn(){
	$('#bc').datagrid('getPanel').find("[type='company_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				getCompanyTypeList();
			}
		})
	});
	$('#bc').datagrid('getPanel').find("[type='goods_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				getGoodsTypeList();
			}
		})
	});
	$('#bc').datagrid('getPanel').find("[type='goods_direct']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				getGoodsDirectList();
			}
		})
	});
	$('#bc').datagrid('getPanel').find("[type='biz_history']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				$("#bizHistoryDlg").dialog('open');
				setBizHisGrid();
			}
		})
	});
	$('#bc').datagrid('getPanel').find("[type='file_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				$("#bizFileDlg").dialog('open');

				var row = $("#bc").datagrid("selectRow",index);
				var row = $("#bc").datagrid("getSelected");
				setFileList(row);
				
			}
		})
	});
	$('#bc3').datagrid('getPanel').find("[type='goods_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				getGoodsTypeList2();
			}
		})
	});
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

function setFileList(row){
	$("#file_id1").filebox("setValue","");
	$("#file_id2").filebox("setValue","");
	$("#file_id3").filebox("setValue","");
	$("#file_id4").filebox("setValue","");
	
	$("#file_id1").textbox("setValue",row.file_nm1);
	$("#file_id2").textbox("setValue",row.file_nm2);
	$("#file_id3").textbox("setValue",row.file_nm3);
	$("#file_id4").textbox("setValue",row.file_nm4);
	
	$('#file_link1').unbind('click',null);
	$('#file_link2').unbind('click',null);
	$('#file_link3').unbind('click',null);
	$('#file_link4').unbind('click',null);
	$('#file_remove1').unbind('click',null);
	$('#file_remove2').unbind('click',null);
	$('#file_remove3').unbind('click',null);
	$('#file_remove4').unbind('click',null);
	
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
}


function setBizHisGrid(){

	$("#bizHisTb").datagrid({
		method : "GET",
		   url: "<c:url value='/business/selectBizNotiHisList.do'/>",
		queryParams : {
			business_no : $('#business_no').val(),
		}
	});
}

function setGrid2(){
	$("#bc2").datagrid({
		method : "GET",
		   url: "<c:url value='/business/businessDtlList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no2').val(),
			s_company_nm : $('#s_company_nm2').val()
		},
		onLoadSuccess:function(){
			$('#bc').datagrid('selectRow', 0);
		}

	});
}
function setGrid5(){
	$("#bc5").datagrid({
		method : "GET",
		   url: "<c:url value='/business/businessDtlList2.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no5').val(),
			s_company_nm : $('#s_company_nm5').val()
		},
		onLoadSuccess:function(){
			$('#bc5').datagrid('selectRow', 0);
		}

	});
}

function setGrid6(){
	$("#bc6").datagrid({
		method : "GET",
		   url: "<c:url value='/business/businessBidInfoList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no6').val(),
			s_company_nm : $('#s_company_nm6').val(),
			bidStartDt :$('#bidStartDt').datebox('getValue'),
			bidEndDt : $('#bidEndDt').datebox('getValue')
		},
		onLoadSuccess:function(){
			eventBtn();
			$('#bc6').datagrid('selectRow', 0);
			$('#bc6').datagrid('reloadFooter',row.footer);
		}

	});
}

function getBidInfoList(){
	$("#bizBidInfoTb").datagrid({
		method : "GET",
		   url: "<c:url value='/business/businessBidInfoDtlList.do'/>",
		queryParams : {
			business_no : $('#business_no').val(),
			bidStartDt :$('#bidStartDt').datebox('getValue'),
			bidEndDt : $('#bidEndDt').datebox('getValue')
		}
	});
}

//조회조건 날짜 초기화
function init(){
    var dts = new Date();
	var dte = new Date();
    var dayOfMonth = dts.getDate();
    dts.setDate(dayOfMonth);
    dte.setDate(dayOfMonth);
    dts = dts.getFullYear()+"-"+((dte.getMonth() + 1)<9?"0"+(dte.getMonth() + 1):(dte.getMonth() + 1))+"-01";
    dte = dte.getFullYear()+"-"+((dte.getMonth() + 1)<9?"0"+(dte.getMonth() + 1):(dte.getMonth() + 1))+"-"+dte.getDate();
    
    
    $('#bidStartDt').datebox('setValue',dts);
    $('#bidEndDt').datebox('setValue',dte);
    
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
				 	<div title="투찰사기본정보" style="padding:5px">
		 			<table style="width:100%;">
				        <tr>
				        	<td width="80%"  align="left">
				        		
    <form id="excel" method="post" action="<c:url value='/business/downloadExcelList.do'/>" accept-charset="utf-8">
    	<input type="hidden" name="s_area_cd" value=""/>
				        		<table style="width:100%;">
							        <tr>
							            <td class="bc">사업자번호</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_no" name="s_company_no" style="width:100px;"   >
							            </td>
							            <td class="bc">업체명</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_nm" name="s_company_nm" style="width:150px;"   >
							            </td>
							            <td class="bc">업종</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_type" name="s_company_type" style="width:80px;"   >
							                <input type="text" class="easyui-textbox"  id="s_company_type_nm" style="width:110px;"  disabled="disabled"  >
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCompanyType('s_company_type', 's_company_type_nm', 's')" ></a>
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchCompanyType('s_company_type', 's_company_type_nm', 'c')" ></a>
							            </td>
							            <td class="bc">물품</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_goods_type" name="s_goods_type" style="width:80px;"   >
							                <input type="text" class="easyui-textbox"  id="s_goods_type_nm" style="width:110px;"  disabled="disabled"  >
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType('s_goods_type', 's_goods_type_nm', 's')" ></a>
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType('s_goods_type', 's_goods_type_nm', 'c')" ></a>
							            </td>
							            <td class="bc">직생물품</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_goods_direct" name="s_goods_direct" style="width:80px;"   >
							                <input type="text" class="easyui-textbox"  id="s_goods_direct_nm" style="width:110px;"  disabled="disabled"  >
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType('s_goods_direct', 's_goods_direct_nm', 's')" ></a>
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType('s_goods_direct', 's_goods_direct_nm', 'c')" ></a>
							            </td>
							            <td class="bc">지역명</td>
							            <td>
							                <input id="s_area_cd" class="easyui-combobox" 
												data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:110,
										        panelHeight:'auto',
										        url: '<c:url value='/bid/comboList.do?searchType=A&cdGroupCd=main_area_cd'/>'">
										    <input type="text" class="easyui-textbox"  id="s_area_txt" name="s_area_txt" style="width:100px;"  />
							           </td>
							        </tr>
							    </table>
    </form>
				        	</td>
				            
				            <td width="12%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a>
				            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append()">추가</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit()">삭제</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a>
				            </td>
				        </tr>
				    </table>
				    <div style="display: none;">
						<table class="easyui-datagrid"
								style="width:0px;height:0px;border: 0" 
								>
						</table>
						<table class="easyui-datagrid"
								style="width:0px;height:0px;border: 0" 
								>
						</table>
					</div>
					<table id="bc" class="easyui-datagrid"
							style="width:100%;height:90%;" 
							
							data-options="iconCls: 'icon-edit',
										rownumbers:false,
										singleSelect:true,
										striped:true,
										pagination:true,
										pageSize:30,
									  	pageList:[30,50,70,100,150,200,500],
										onClickCell: onClickCell, onEndEdit: onEndEdit,
										rowStyler: function(index,row){
										                    if (row.unuse_yn=='Y'){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }
										              }"						
							>
						<thead>
							<tr>
								<th rowspan="2" data-options="field:'business_no',align:'center',halign:'center'" width="80">No.</th>
						 		<th rowspan="2" data-options="field:'company_no',halign:'center',editor:'textbox'" width="150">사업자번호</th>
						 		<th rowspan="2" data-options="field:'company_nm',halign:'center',editor:'textbox'" width="150">업체명</th>
								<th rowspan="2" data-options="field:'unuse_yn',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">보류</th>
								<th rowspan="2" data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"  width="80">대표자명</th>
								<th rowspan="2" data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton">업종</th>
								<th rowspan="2" data-options="field:'company_type_insert2',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton2">제조물품</th>
								<th rowspan="2" data-options="field:'company_type_insert3',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton3">직생물품</th>
<!-- 								<th data-options="field:'zip_no',align:'center',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['number','length[5,5]'],invalidMessage:'우편번호를 5자리로 입력하세요'}}" width="60">우편번호</th> -->
<!-- 								<th data-options="field:'address',halign:'center',editor:'textbox',max:100" width="250">기본주소</th> -->
								<th rowspan="2"  data-options="field:'address',align:'left',halign:'center',sortable:true,width:100,
									                        formatter:function(value,row){
									                            return row.address_nm;
									                        },
									                        editor:{
									                            type:'combobox',
									                            options:{
									                                valueField:'cd',
									                                textField:'cd_nm',
									                                method:'get',
									                                panelHeight:'auto',
									                                data:jsonData4,
									                                required:false
									                            }
									                        }">기본주소</th>
								<th rowspan="2" data-options="field:'address_detail',halign:'center',editor:'textbox',max:100" width="250">상세주소</th>
<!-- 								<th data-options="field:'department',halign:'center',editor:'textbox',max:20" width="100">담당부서</th> -->
								<th rowspan="2" data-options="field:'position',halign:'center',editor:'textbox',max:20" width="50">직위</th>
								<th rowspan="2" data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox',max:10" width="60">담당자</th>
								<th colspan="3">메세지유형</th>
								<th rowspan="2" data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',max:11"  width="100">전화</th>
								<th rowspan="2" data-options="field:'mobile_no',align:'center',halign:'center',editor:'textbox',max:11" width="100">휴대폰</th>
								<th rowspan="2" data-options="field:'pwd',align:'left',halign:'center',editor:'textbox',max:11"  width="100">pwd</th>
<!-- 								<th rowspan="2" data-options="field:'fax_no',align:'center',halign:'center',editor:'textbox',max:11"  width="100">fax</th> -->
								<th rowspan="2" data-options="field:'email',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['email','length[0,30]'],invalidMessage:'알맞은 이메일 형식을 사용하세요(0~30자내)'}}"  width="200">이메일</th>
								<th rowspan="2" data-options="field:'company_type_insert4',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton4">이력보기</th>
								<th rowspan="2" data-options="field:'company_type_insert5',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton5">파일업로드</th>
							</tr>
							<tr>
								<th data-options="field:'msg_info1',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >APP</th>
								<th data-options="field:'msg_info2',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >SMS</th>
								<th data-options="field:'msg_info3',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >Email</th>
							</tr>
						</thead>
					</table>
					<span style="display:inline-block;" >
						<table  style="border: 1px solid red" width="800px" >
							<tr>
								<td class="bc_area bc">서울</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="서울">0</td>
								<td class="bc_area bc">경기</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="경기" >0</td>
								<td class="bc_area bc">인천</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="인천" >0</td>
								<td class="bc_area bc">부산</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="부산" >0</td>
								<td class="bc_area bc">대구</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="대구" >0</td>
								<td class="bc_area bc">광주</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="광주" >0</td>
								<td class="bc_area bc">대전</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="대전" >0</td>
								<td class="bc_area bc">울산</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="울산" >0</td>
								<td class="bc_area bc">강원</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="강원" >0</td>
								<td class="bc_area bc">충북</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="충북" >0</td>
								<td class="bc_area bc">충남</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="충남" >0</td>
								<td class="bc_area bc">전북</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="전북" >0</td>
								<td class="bc_area bc">전남</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="전남" >0</td>
								<td class="bc_area bc">경북</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="경북" >0</td>
								<td class="bc_area bc">경남</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="경남" >0</td>
								<td class="bc_area bc">제주</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="제주" >0</td>
								<td class="bc_area bc">세종</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="세종" >0</td>
								<td class="bc_area bc">기타</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="기타1" >0</td>
							</tr>
						</table>
					</span>
					<span style="display:inline-block;">
						<table style="border: 1px solid green" width="300px">
							<tr>
								<td class="bc_area2 bc">소기업</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="소기업">0</td>
								<td class="bc_area2 bc">소상공인</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="소상공인">0</td>
								<td class="bc_area2 bc">중기업</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="중기업">0</td>
								<td class="bc_area2 bc">없음</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="없음">0</td>
								<td class="bc_area2 bc">기타</td>
								<td class="bc_area_cnt" style="width: 50px;text-align: right;" id="기타2">0</td>
							</tr>
						</table>
					</span>
					<span style="display:inline-block;">
						<table width="100px">
							<tr>
								<td style="width: 100px;">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="excelDown()">엑셀다운</a>
								</td>
							</tr>
						</table>
					</span>
					<script>
						function formatRowButton(val,row){
							
							if(row.company_type_insert=="1"){
							   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"company_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							return ;
						}
						function formatRowButton2(val,row){
							if(row.company_type_insert=="1"){
							   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"goods_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							return ;
						}
						function formatRowButton3(val,row){
							if(row.company_type_insert=="1"){
							   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"goods_direct\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							return ;
						}
						function formatRowButton4(val,row){
							if(row.company_type_insert=="1"){
							   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"biz_history\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							return ;
						}
						function formatRowButton5(val,row){
							if(row.company_type_insert=="1"){
							   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"file_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							return ;
						}
						
						var editIndex = undefined;
						function endEditing(){
							if (editIndex == undefined){return true}
							if ($('#bc').datagrid('validateRow', editIndex)){
						 		$('#bc').datagrid('endEdit', editIndex);
								editIndex = undefined;
								return true;
							} else {
								return false;
							}
						}
					
						function onClickCell(index, field){
							if (editIndex != index){
								if (endEditing()){
									if(field=="company_type_insert") {editIndex = index; return};
									if(field=="company_type_insert2"){editIndex = index; return};
									if(field=="company_type_insert3"){editIndex = index; return};
									if(field=="company_type_insert4"){editIndex = index; return};
									if(field=="company_type_insert5"){editIndex = index; return};
									$('#bc').datagrid('selectRow', index)
											.datagrid('beginEdit', index);
									var selecter = $('#bc').datagrid('getSelected');
									
									if(field=="business_no"){
										if(selecter.company_type_insert == "1"){
											var ed = $('#bc').datagrid('getEditor', {index:index,field:'business_no'});
											if (ed){
												$(ed.target).textbox('readonly',true);
												return;
											}
										}
									}else{
										if(selecter.company_type_insert == "1"){
											var ed = $('#bc').datagrid('getEditor', {index:index,field:'business_no'});
											if (ed){
												$(ed.target).textbox('readonly',true);
											}
										}
									}
									
									var ed = $('#bc').datagrid('getEditor', {index:index,field:field});
									if (ed){
										($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
									}
									
									editIndex = index;
								} else {
									$('#bc').datagrid('selectRow', editIndex);
								}
							}
							eventBtn();
						}
						function append(){
							if (endEditing()){
								$('#bc').datagrid('appendRow',{status:'P'});
								editIndex = $('#bc').datagrid('getRows').length-1;
								$('#bc').datagrid('selectRow', editIndex)
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
						 
						 function onBeforeEdit(index,row){
					  	   row.editing=true;
					  	   $(this).datagrid('refreshRow', index);
					     }
						
						function removeit(){
							if (editIndex == undefined){return}
							$('#bc').datagrid('cancelEdit', editIndex)
									.datagrid('deleteRow', editIndex);
							editIndex = undefined;
						}
						
						
						function save(){
					    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
						        if (r){
						        	if (endEditing()){
						    			var $dg = $("#bc");
					
						    			if ($dg.datagrid('getChanges').length) {
											var inserted = $dg.datagrid('getChanges', "inserted");
						    				var deleted = $dg.datagrid('getChanges', "deleted");
						    				var updated = $dg.datagrid('getChanges', "updated");
						    				
						    				var effectRow = new Object();
						    				if (inserted.length) {
												effectRow["inserted"] = JSON.stringify(inserted);
											}
						    				if (deleted.length) {
						    					effectRow["deleted"] = JSON.stringify(deleted);
						    				}
						    				if (updated.length) {
						    					effectRow["updated"] = JSON.stringify(updated);
						    				}
						    				$.post("<c:url value='/business/updateBusinessList.do'/>", effectRow, function(rsp) {
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
						
						</script>
					</div>
					<div title="투찰사적격정보" style="padding:5px">
		 			<table style="width:100%;">
				        <tr>
				        	<td width="80%"  align="left">
				        		<table style="width:100%;">
							        <tr>
							            <td class="bc">사업자번호</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_no2" style="width:200px;"   >
							            </td>
							            <td class="bc">업체명</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_nm2" style="width:200px;"   >
							            </td>
							        </tr>
							    </table>
				        	</td>
				            
				            <td width="20%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid2()">조회</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save2()">저장</a>
				            </td>
				        </tr>
				    </table>
					<table id="bc2" class="easyui-datagrid"
							style="width:100%;height:90%;" 
							
							data-options="iconCls: 'icon-edit',
										rownumbers:false,
										singleSelect:true,
										striped:true,
										pagination:true,
										pageSize:30,
									  	pageList:[30,50,70,100,150,200,500],
									    method:'get',
									    striped:true,
									    nowrap:false,
									    sortName:'business_no',
									    sortOrder:'desc',
										onClickCell:onClickCell2,
									  onEndEdit:onEndEdit2,
									  onBeforeEdit:onBeforeEdit,
									  rowStyler: function(index,row){
						                    if (row.flag=='A'){
						                        return 'background-color:#ff99ff;color:#fff;';
						                    }
						              }"
							>
						<thead>
							<tr>
								<th  data-options="field:'business_no',align:'center',halign:'center',sortable:true" width="80">No.</th>
<!-- 						 		<th  data-options="field:'company_no',halign:'center',sortable:true" width="120">사업자번호</th> -->
						 		<th  data-options="field:'company_nm',halign:'center',sortable:true" width="140">업체명</th>
								<th  data-options="field:'start_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}" >개업일</th>
								<th  data-options="field:'scale_cd',align:'center',halign:'center',sortable:true,width:100,
									                        formatter:function(value,row){
									                            return row.scale_nm;
									                        },
									                        editor:{
									                            type:'combobox',
									                            options:{
									                                valueField:'cd',
									                                textField:'cd_nm',
									                                method:'get',
									                                panelHeight:'auto',
									                                data:jsonData2,
									                                required:false
									                            }
									                        }">중소기업확인서</th>
								<th  data-options="field:'scale_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler"  >중소기업확인<br/>만료일</th>
								<th  data-options="field:'credit_cd',align:'center',halign:'center',sortable:true,width:100,
									                        formatter:function(value,row){
									                            return row.credit_nm;
									                        },
									                        editor:{
									                            type:'combobox',
									                            options:{
									                                valueField:'cd',
									                                textField:'cd_nm',
									                                method:'get',
									                                panelHeight:'auto',
									                                data:jsonData1,
									                                required:false
									                            }
									                        }">신용등급</th>
								<th  data-options="field:'credit_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler"  >신용등급<br/>만료일</th>
								<th  data-options="field:'nep_yn',align:'center',halign:'center',sortable:true,width:100,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >nep/net</th>
								<th  data-options="field:'license_yn',align:'center',halign:'center',sortable:true,width:100,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >특허</th>
								<th  data-options="field:'model_yn',align:'center',halign:'center',sortable:true,width:100,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >실용신안/<br/>디자인등록</th>
								<th  data-options="field:'gdgs_yn',align:'center',halign:'center',sortable:true,width:100,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >GD/GS인증</th>
								<th  data-options="field:'female_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}"  >여성기업<br/>시작일</th>
								<th  data-options="field:'innovate_yn',align:'center',halign:'center',sortable:true,width:100,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >혁신형기업</th>
								<th  data-options="field:'bigo',align:'left',halign:'center',width:200,editor:'textbox'"  >비고</th>
							</tr>
						</thead>
					</table>
					<script>
						function cellStyler(value,row,index){
							
							if(value!=null){
								var a = new Date();
								var b = myparser(value);
								var c = b - a;
								
								if(c/(24 * 3600 * 1000)<30){
									return 'background-color:#ffee00;color:red;';
								}else{
									return '';
								}
							}

						}
					
					
						 function endEditing2(){
					         if (editIndex == undefined){return true}
					         if ($('#bc2').datagrid('validateRow', editIndex)){
					             $('#bc2').datagrid('endEdit', editIndex);
					             editIndex = undefined;
					             return true;
					         } else {
					             return false;
					         }
					     }
						 
						 function onClickCell2(index, field){
					         if (editIndex != index){
					             if (endEditing2()){
					                 $('#bc2').datagrid('selectRow', index)
					                         .datagrid('beginEdit', index);
					                 var ed = $('#bc2').datagrid('getEditor', {index:index,field:field});
					                 if (ed){
					                     ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
					                 }
					                 editIndex = index;
					             } else {
					                 setTimeout(function(){
					                     $('#bc2').datagrid('selectRow', editIndex);
					                 },0);
					             }
					         }
					     }
						
						 function onEndEdit2(index, row){
					        var ed = $(this).datagrid('getEditor', {
					            index: index,
					            field: 'scale_cd'
					        });
					        row.scale_nm = $(ed.target).combobox('getText');
					        
					        ed = $(this).datagrid('getEditor', {
					            index: index,
					            field: 'credit_cd'
					        });
					        row.credit_nm = $(ed.target).combobox('getText');
					     }
						 
						 
						function save2(){
					    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
						        if (r){
						        	if (endEditing2()){
						    			var $dg = $("#bc2");
					
						    			if ($dg.datagrid('getChanges').length) {
						    				var updated = $dg.datagrid('getChanges', "updated");
						    				
						    				var effectRow = new Object();
						    				if (updated.length) {
						    					effectRow["updated"] = JSON.stringify(updated);
						    				}
						    				$.post("<c:url value='/business/updateBusinessDtlList.do'/>", effectRow, function(rsp) {
						    					if(rsp.status){
						    						$.messager.alert("알림", "저장하였습니다.");
						    						setGrid2();
						    					}
						    				}, "JSON").error(function() {
						    					$.messager.alert("알림", "저장에러！");
						    				});
						    			 }
						    		}
						        }
					    	});
						}
						
						</script>
					</div>
					<div title="투찰사적격여부" style="padding:5px">
						<table style="width:100%;">
					        <tr>
					        	<td width="80%"  align="left">
					        		<table style="width:100%;">
								        <tr>
								            <td class="bc">사업자번호</td>
								            <td>
								                <input type="text" class="easyui-textbox"  id="s_company_no5" style="width:200px;"   >
								            </td>
								            <td class="bc">업체명</td>
								            <td>
								                <input type="text" class="easyui-textbox"  id="s_company_nm5" style="width:200px;"   >
								            </td>
								        </tr>
								    </table>
					        	</td>
					            
					            <td width="20%" align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid5()">조회</a>
					            </td>
					        </tr>
					    </table>
						<table id="bc5" class="easyui-datagrid"
								style="width:100%;height:90%;" 
								
								data-options="iconCls: 'icon-edit',
											rownumbers:false,
											singleSelect:true,
											striped:true,
											pagination:true,
											pageSize:30,
									  		pageList:[30,50,70,100,150,200,500],
										    method:'get',
										    striped:true,
										    nowrap:false,
										    sortName:'business_no',
										    sortOrder:'desc'"
								>
							<thead>
								<tr>
									<th rowspan="2" data-options="field:'business_no',align:'center',halign:'center',sortable:true" width="80">No.</th>
							 		<th rowspan="2" data-options="field:'company_no',halign:'center',sortable:true" width="120">사업자번호</th>
							 		<th rowspan="2" data-options="field:'company_nm',halign:'center',sortable:true" width="140">업체명</th>
									<th	colspan="2">조달청</th>
									<th	colspan="2">조달청(중소기업)</th>
									<th	colspan="2">중기청</th>
									<th	rowspan="2" data-options="field:'type_301',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">안행부</th>
									<th	colspan="2">국방부</th>
									<th	rowspan="2" data-options="field:'type_601',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">국제입찰</th>
									<th	rowspan="2" data-options="field:'type_701',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">도로공사</th>
									<th	rowspan="2" data-options="field:'bigo',align:'left',width:200 ,halign:'center'">비고</th>
								</tr>
								<tr>
									<th	data-options="field:'type_101',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">고시금액미만</th>
									<th	data-options="field:'type_102',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">10억미만</th>
									<th	data-options="field:'type_201',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">고시금액미만</th>
									<th	data-options="field:'type_202',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">10억미만</th>
									<th	data-options="field:'type_501',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">고시금액미만</th>
									<th	data-options="field:'type_502',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">10억미만</th>
									<th	data-options="field:'type_401',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">고시금액미만</th>
									<th	data-options="field:'type_402',align:'center',width:100 ,halign:'center',sortable:true" formatter="formatEvalColor">10억미만</th>
								</tr>
							</thead>
						</table>
					</div>
					<div title="직생서보유기업정보" style="padding:5px">
		 			<table style="width:100%;">
				        <tr>
				        	<td width="80%"  align="left">
				        		<table style="width:100%;">
							        <tr>
							            <td class="bc">업체명</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_nm3" style="width:200px;"   >
							            </td>
							            <td class="bc">제조물품</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_goods_type3" style="width:80px;"   >
							                <input type="text" class="easyui-textbox"  id="s_goods_type_nm3" style="width:150px;"  disabled="disabled"  >
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType('s_goods_type3', 's_goods_type_nm3', 's')" ></a>
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType('s_goods_type3', 's_goods_type_nm3', 'c')" ></a>
							            </td>
							            <td class="bc">지역</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_area_txt3" style="width:200px;"   >
							            </td>
							        </tr>
							    </table>
				        	</td>
				            
				            <td width="20%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid3()">조회</a>
<!-- 				            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append3()">추가</a> -->
<!-- 								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit3()">삭제</a> -->
<!-- 								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save3()">저장</a> -->
				            </td>
				        </tr>
				    </table>
					<table id="bc3" class="easyui-datagrid"
							style="width:100%;height:90%;" 
							
							data-options="iconCls: 'icon-edit',
										rownumbers:true,
										singleSelect:true,
										striped:true,
										pagination:true,
										pageSize:30,
									  	pageList:[30,50,70,100,150,200,500],
									    sortName:'business_no',
									    sortOrder:'desc'"						
							>
						<thead>
							<tr>
<!-- 								<th data-options="field:'business_no',align:'center',halign:'center',sortable:true" width="100">No.</th> -->
<!-- 						 		<th data-options="field:'company_no',halign:'center',editor:'textbox',sortable:true" width="150">사업자번호</th> -->
						 		<th data-options="field:'company_nm',halign:'center',editor:'textbox',sortable:true" width="200">업체명</th>
<!-- 								<th data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"  width="80">대표자명</th> -->
								<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="100" formatter="formatRowButton2">제조물품</th>
								<th data-options="field:'address',halign:'center',editor:'textbox',sortable:true,max:100" width="400">기본주소</th>
<!-- 								<th data-options="field:'address_detail',halign:'center',editor:'textbox',max:100" width="100">상세주소</th> -->
								<th data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',sortable:true,max:11"  width="100">전화</th>
							</tr>
						</thead>
					</table>
					
					</div>
					<div title="기타기업현황정보" style="padding:5px">
						<table style="width:100%;">
					        <tr>
					        	<td width="80%"  align="left">
					        		<table style="width:100%;">
								        <tr>
								            <td class="bc">조회목록</td>
											<td>
												<input id="search_cd" class="easyui-combobox"
															data-options="
															method:'get',
													        valueField: 'search_cd',
													        textField: 'search_nm',
													        width:230,
													        panelHeight:'auto',
													        data:jsonData3"/>
											</td>
								            <td class="bc">업체명</td>
								            <td>
								                <input type="text" class="easyui-textbox"  id="s_company_nm4" style="width:200px;"   >
								            </td>
											<td class="bc">지역</td>
								            <td>
								                <input type="text" class="easyui-textbox"  id="s_area_txt4" style="width:200px;"   >
								            </td>
								        </tr>
								    </table>
					        	</td>
					            
					            <td width="20%" align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid4()">조회</a>
					            </td>
					        </tr>
					    </table>
						<table id="bc4" class="easyui-datagrid"
								style="width:100%;height:90%;" 
								
								data-options="iconCls: 'icon-edit',
											rownumbers:true,
											singleSelect:true,
											striped:true,
											pagination:true,
											pageSize:30,
									  		pageList:[30,50,70,100,150,200,500],
										    sortName:'company_id',
										    sortOrder:'desc'"						
								>
							<thead>
								<tr>
<!-- 									<th data-options="field:'company_id',align:'center',halign:'center',sortable:true" width="100">No.</th> -->
<!-- 							 		<th data-options="field:'company_no',halign:'center',editor:'textbox',sortable:true" width="150">사업자번호</th> -->
							 		<th data-options="field:'company_nm',halign:'center',editor:'textbox',sortable:true" width="200">업체명</th>
<!-- 									<th data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"  width="80">대표자명</th> -->
									<th data-options="field:'address',halign:'center',editor:'textbox',sortable:true,max:100" width="400">기본주소</th>
									<th data-options="field:'tel',align:'center',halign:'center',editor:'textbox',sortable:true,max:11"  width="100">전화</th>
									<th data-options="field:'start_dt',align:'center',halign:'center',editor:'textbox',sortable:true,max:11" formatter="formatDate"  width="100">시작일</th>
									<th data-options="field:'end_dt',align:'center',halign:'center',editor:'textbox',sortable:true,max:11"  formatter="formatDate" width="100">종료일</th>
								</tr>
							</thead>
						</table>
					</div>
					<div title="투찰이력조회" style="padding:5px">
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
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid6()">조회</a>
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
											pageSize:30,
										  	pageList:[30,50,70,100,150,200,500],
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
									<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton6">상세보기</th>
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
				</div>
			</div>
		</div>
	</div>
	</div>
	<!-- 투찰사 이력정보 Dialog start -->
	<div id="bizHistoryDlg" class="easyui-dialog" title="투찰사 의견이력" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:800px;height:750px;padding:10px">
    	<table style="width:100%">
		        <tr>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addBizHis()" >추가</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit3()" >삭제</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveBizHis()" >저장</a>
		            </td>
		        </tr>
		</table>
    	<table id="bizHisTb" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						singleSelect:true,
						striped:true,
						onClickCell: onClickCell3
						  ">
			<thead>
				<tr>
					<th data-options="field:'bigo',align:'left',width:400,halign:'center',editor:'textbox'" >의견</th>
					<th data-options="field:'user_nm',align:'left',width:100,halign:'center'" >등록자</th>
					<th data-options="field:'create_dt',align:'left',width:100,halign:'center'" formatter="formatDate">등록일</th>
				</tr>
			</thead>
		</table>
    </div>
    <script>

			var editIndex3 = undefined;
						
			function endEditing3(){
				if (editIndex3 == undefined){return true}
				if ($('#bizHisTb').datagrid('validateRow', editIndex3)){
			 		$('#bizHisTb').datagrid('endEdit', editIndex3);
					editIndex3 = undefined;
					return true;
				} else {
					return false;
				}
			}
		
			function onClickCell3(index, field){
				if (editIndex3 != index){
					if (endEditing3()){
						$('#bizHisTb').datagrid('selectRow', index)
								.datagrid('beginEdit', index);
						var selecter = $('#bizHisTb').datagrid('getSelected');
						
						var ed = $('#bizHisTb').datagrid('getEditor', {index:index,field:field});
						if (ed){
							($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
						}
						
						editIndex3 = index;
					} else {
						$('#bizHisTb').datagrid('selectRow', editIndex3);
					}
				}
			}
			
			function addBizHis(){
				if (endEditing3()){
					$('#bizHisTb').datagrid('appendRow',{status:'P'});
					editIndex3 = $('#bizHisTb').datagrid('getRows').length-1;
					$('#bizHisTb').datagrid('selectRow', editIndex3)
							.datagrid('beginEdit', editIndex3);
				}
			}
			
			function removeit3(){
				if (editIndex3 == undefined){return}
				$('#bizHisTb').datagrid('cancelEdit', editIndex3)
						.datagrid('deleteRow', editIndex3);
				editIndex3 = undefined;
			}
			
			
			function saveBizHis(){
		    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
			        if (r){
			        	if (endEditing3()){
			    			var $dg = $("#bizHisTb");
		
			    			if ($dg.datagrid('getChanges').length) {
								var inserted = $dg.datagrid('getChanges', "inserted");
			    				var deleted = $dg.datagrid('getChanges', "deleted");
			    				var updated = $dg.datagrid('getChanges', "updated");
			    				
			    				var effectRow = new Object();
								effectRow["business_no"] = $("#business_no").val();
			    				if (inserted.length) {
									effectRow["inserted"] = JSON.stringify(inserted);
								}
			    				if (deleted.length) {
			    					effectRow["deleted"] = JSON.stringify(deleted);
			    				}
			    				if (updated.length) {
			    					effectRow["updated"] = JSON.stringify(updated);
			    				}
			    				$.post("<c:url value='/business/updateBizNotiHisList.do'/>", effectRow, function(rsp) {
			    					if(rsp.status){
			    						$.messager.alert("알림", "저장하였습니다.");
			    						$dg.datagrid('acceptChanges');
			    						setBizHisGrid();
			    					}
			    				}, "JSON").error(function() {
			    					$.messager.alert("알림", "저장에러！");
			    				});
			    			 }else{
	    						$.messager.alert("알림", "변경된 데이터가 없습니다.");
			    			 }
			    		}
			        }
		    	});
			}
			
			</script>
    <!-- 투찰사 이력정보 Dialog end -->	
    
    
    <!-- 투찰사 파일업로드 Dialog start -->
    <div id="bizFileDlg" class="easyui-dialog" title="파일업로드" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:720px;height:220px;padding:10px">
    	<table style="width:100%">
		        <tr>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveFile()" >저장</a>
		            </td>
		        </tr>
		</table>
    	<form id="uploadForm" enctype="multipart/form-data">
			<table style="width: 100%;">
				<tr>
					<td class="bc">사업자등록증</td>
					<td>
						<div style="width:100%;">
						     <input id="file_id1" class="easyui-filebox" name="file1" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
							 <a id="file_link1" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
							 <a id="file_remove1" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
						</div>
					</td>
				</tr>
				<tr>
					<td class="bc">기업형태</td>
					<td>
						<div style="width:100%;">
						     <input id="file_id2" class="easyui-filebox" name="file2" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
							 <a id="file_link2" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
							 <a id="file_remove2" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
						</div>
					</td>
				</tr>
				<tr>
					<td class="bc">신용평가</td>
					<td>
						<div style="width:100%;">
						     <input id="file_id3" class="easyui-filebox" name="file3" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
							 <a id="file_link3" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
							 <a id="file_remove3" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
						</div>
					</td>
				</tr>
				<tr>
					<td class="bc">기타</td>
					<td>
						<div style="width:100%;">
						     <input id="file_id4" class="easyui-filebox" name="file4" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
							 <a id="file_link4" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
							 <a id="file_remove4" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" >삭제</a>
						</div>
					</td>
				</tr>
			</table>
			</form>
    </div>
    <script>
	function saveFile(){
		
    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	        if (r){
    			var form = new FormData(document.getElementById('uploadForm'));
    			
    			form.append("business_no", $("#business_no").val());
   				form.append("file_id1", encodeURIComponent($("#file_id1").filebox("getText")));
   				form.append("file_id2", encodeURIComponent($("#file_id2").filebox("getText")));
   				form.append("file_id3", encodeURIComponent($("#file_id3").filebox("getText")));
   				form.append("file_id4", encodeURIComponent($("#file_id4").filebox("getText")));
   				
  				    $.ajax({
  				      url: "<c:url value='/business/updateCompanyFileList.do'/>",
  				      data: form,
  				      dataType: 'text',
  				      processData: false,
  				      contentType: false,
  				      type: 'POST',
  				      success: function (rsp) {
   				  	$.messager.alert("알림", "저장하였습니다.");
   				 		$("#bc").datagrid('reload');
	    				$('#bizFileDlg').dialog('close');
    						
  				      },
  				      error: function (jqXHR) {
  				        console.log('error');
  				      }
  				    });
   				
	        }
    	});
	}
    </script>
    <!-- 투찰사 파일업로드 Dialog end -->
    
    <!-- 투찰사 투찰 이력정보 Dialog start -->
	<div id="bizBidInfoDlg" class="easyui-dialog" title="투찰사 투찰정보이력" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:900px;height:700px;padding:10px">
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
    
   <%@ include file="/include/popup.jsp" %>
</body>
</html>