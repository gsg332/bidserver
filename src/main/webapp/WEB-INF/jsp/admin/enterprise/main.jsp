<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>업체관리</title>
<%@ include file="/include/session.jsp"%>
<style>
.mytable {
	border-collapse: collapse;
	margin-top: 25px;
	width: 100%;
	padding: 10px;
}

.mytable th, .mytable td {
	border: 1px solid black;
}
</style>
<script>
var jsonData2=[{role_cd:'',role_nm:'선택'},{role_cd:1,role_nm:'담당자'},{role_cd:2,role_nm:'팀장'},{role_cd:3,role_nm:'총괄책임자'}];
var jsonData=null;
var jsonData3=null;
var jsonData4=null;
var jsonData5=null;
var jsonData6=null;
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
	   jsonData=json;
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
$(document).ready(function() {
	keydownEvent();
	setGrid();
	setGrid2();
	setGrid3();
	selectUserList();
	var html = "";
    for(var i=1;i<jsonData4.length;i++){
	    html += "<input type='checkbox' id='license_A' name='license_A' value='"+jsonData4[i].cd+"'/>"+jsonData4[i].cd_nm+" ";   
    }
    $("#license_txt").append(html);
    
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
							break;
						case 2:
							setGrid();
							break;
						case 3:
							setGrid2();
							break;
						case 4:
							break;
						}
					},300);
				}
			});
		}
		//return false;
	});
	
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
                var ed = $(this).datagrid('getEditor', param);
                if (ed){
                    if ($(ed.target).hasClass('textbox-f')){
                        $(ed.target).textbox('textbox').focus();
                    } else {
                        $(ed.target).focus();
                    }
                }
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		},
        enableCellEditing: function(jq){
            return jq.each(function(){
                var dg = $(this);
                var opts = dg.datagrid('options');
                opts.oldOnClickCell = opts.onClickCell;
                opts.onClickCell = function(index, field){
                    if (opts.editIndex != undefined){
                        if (dg.datagrid('validateRow', opts.editIndex)){
                            dg.datagrid('endEdit', opts.editIndex);
                            opts.editIndex = undefined;
                        } else {
                            return;
                        }
                    }
                    dg.datagrid('selectRow', index).datagrid('editCell', {
                        index: index,
                        field: field
                    });
                    opts.editIndex = index;
                    opts.oldOnClickCell.call(this, index, field);
                }
            });
        }
	});
	$('#bizGoodsDirectTb').datagrid().datagrid('enableCellEditing');
	$('#bizLicenseTb').datagrid().datagrid('enableCellEditing');
});
function setGrid(){
	$("#s_business_no").val("");	
	$("#bc").datagrid({
		method : "GET",
		   url: "<c:url value='/enterprise/manufactureList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no').val(),
			s_company_nm : $('#s_company_nm').val(),
			s_bidmanager : $('#s_bidmanager').val(),
			s_area_cd : $('#s_area_cd').combobox('getValue'),
			s_area_txt : $('#s_area_txt').val(),
			s_delegate_explain_txt : $('#s_delegate_explain_txt').val(),
			s_company_type : $('#s_company_type').val(),
			s_goods_type : $('#s_goods_type').val()
		},
		onClickRow : function(index, row){
			$("#s_business_no").val(row.business_no);
		},
		onLoadSuccess:function(){
			$('#bc').datagrid('selectRow', 0);
			eventBtn();
		}
	});
}
function setGrid2(){
	$("#s_business_no2").val("");
	$("#bc2").datagrid({
		method : "GET",
		   url: "<c:url value='/enterprise/businessList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no2').val(),
			s_company_nm : $('#s_company_nm2').val(),
			s_area_cd : $('#s_area_cd2').combobox('getValue'),
			s_area_txt : $('#s_area_txt2').val(),
			s_company_type : $('#s_company_type2').val(),
			s_goods_type : $('#s_goods_type2').val(),
			s_goods_direct : $('#s_goods_direct2').val(),
			s_license_type : $('#s_license_type2').val(),
			s_join_approve_yn : 'Y'
		},
		onClickRow : function(index, row){
			$("#s_business_no2").val(row.business_no);
		},
		onLoadSuccess:function(data){
			$('#bc2').datagrid('selectRow', 0);
			eventBtn2();
		}
	});
}

function setGrid3(){
	$("#s_business_no3").val("");
	$("#bc4").datagrid({
		method : "GET",
		   url: "<c:url value='/enterprise/businessList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no3').val(),
			s_company_nm : $('#s_company_nm3').val(),
			s_area_cd : $('#s_area_cd3').combobox('getValue'),
			s_area_txt : $('#s_area_txt3').val(),
			s_company_type : $('#s_company_type3').val(),
			s_goods_type : $('#s_goods_type3').val(),
			s_goods_direct : $('#s_goods_direct3').val(),
			s_license_type : $('#s_license_type3').val(),
			s_join_approve_yn : 'N'
		},
		onClickRow : function(index, row){
			$("#s_business_no3").val(row.business_no);
		},
		onLoadSuccess:function(data){
			$('#bc4').datagrid('selectRow', 0);
			eventBtn3();
		}
	});
}

function save(){
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
					$.messager.alert("알림", "저장하였습니다.");	
					
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
					
					setGrid();
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "저장에러！");
			});
        }
	});
}
function save3(){
	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
        if (r){
        	if (endEditing()){
    			var $dg = $("#bc");

    			if ($dg.datagrid('getChanges').length) {
    				var updated = $dg.datagrid('getChanges', "updated");
    				
    				var effectRow = new Object();
    				if (updated.length) {
    					effectRow["updated"] = JSON.stringify(updated);
    				}
    				$.post("<c:url value='/enterprise/updateManufacture.do'/>", effectRow, function(rsp) {
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
function save5(){
	if($('#company_nm_A').textbox('getValue')==""){
		$.messager.alert("알림", "업체명을 입력해주세요.");
		return;
	}
	if($('#address_A').combobox('getValue')==""){
		$.messager.alert("알림", "기본주소를 선택해주세요.");
		return;
	}
	var unuse_yn = "";
	if(choice_chk($("#unuse_yn_A"))=="Y"){
		unuse_yn = "Y";
	}else{
		unuse_yn = "N";
	}
	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
        if (r){			
        	var effectRow = new Object();
 			effectRow["company_no"] = $("#company_no_A").textbox('getValue');
 			effectRow["address"] = $("#address_A").combobox('getValue');
 			effectRow["company_nm"] = $("#company_nm_A").textbox('getValue');
 			effectRow["address_detail"] = $("#address_detail_A").textbox('getValue');
 			effectRow["delegate"] = $("#delegate_A").textbox('getValue');
 			effectRow["position"] = $("#position_A").textbox('getValue');
 			effectRow["bidmanager"] = $("#bidmanager_A").textbox('getValue');
 			
 			effectRow["company_type"] = $("#s_company_type_A").val();
 			effectRow["goods_type"] = $("#s_goods_type_A").val();
 			effectRow["goods_direct"] = $("#s_goods_direct_A").val();
 			
 			effectRow["phone_no"] = $("#phone_no_A").textbox('getValue');
 			effectRow["mobile_no"] = $("#mobile_no_A").textbox('getValue');
 			effectRow["email"] = $("#email_A").textbox('getValue');
 			effectRow["join_route"] = $("#join_route_A").textbox('getValue');
 			effectRow["unuse_yn"] = unuse_yn;
 			
 			effectRow["open_day"] = $("#open_day_A").datebox('getValue').replaceAll("-","");
 			effectRow["scale_cd"] = $("#scale_cd_A").textbox('getValue');
 			effectRow["scale_dt"] = $("#scale_dt_A").datebox('getValue').replaceAll("-","");
 			effectRow["credit_cd"] = $("#credit_cd_A").textbox('getValue');
 			effectRow["credit_dt"] = $("#credit_dt_A").datebox('getValue').replaceAll("-","");
 			effectRow["female_yn"] = $("#female_yn_A").combobox('getValue');
 			effectRow["female_dt"] = $("#female_dt_A").datebox('getValue').replaceAll("-","");
 			
 			var licenseRes = "";

 			$("input:checkbox[name=license_A]:checked").each(function(){
 				licenseRes += $(this).val()+",";
 			});
 			
 			effectRow["license_cd"] = licenseRes.slice(0,-1);
 			
 			effectRow["gubun"] = "A";
 			
			$.post("<c:url value='/enterprise/insertBusiness.do'/>", effectRow, function(rsp) {
				if(rsp.status=="200"){
					$.messager.alert("알림", "저장하였습니다.");	

					$("#company_no_A").textbox('setValue','');
		 			$("#address_A").combobox('setValue','');
		 			$("#company_nm_A").textbox('setValue','');
		 			$("#address_detail_A").textbox('setValue','');
		 			$("#delegate_A").textbox('setValue','');
		 			$("#position_A").textbox('setValue','');
		 			$("#bidmanager_A").textbox('setValue','');
		 			
		 			$("#s_company_type_A").val("");
		 			$("#s_goods_type_A").val("");
		 			$("#s_goods_direct_A").val("");
		 			$("#s_company_type_nm_A").textbox('setValue','');
		 			$("#s_goods_type_nm_A").textbox('setValue','');
		 			$("#s_goods_direct_nm_A").textbox('setValue','');
		 			
		 			$("#phone_no_A").textbox('setValue','');
		 			$("#mobile_no_A").textbox('setValue','');
		 			$("#email_A").textbox('setValue','');		
		 			$("#join_route_A").textbox('setValue','');
		 					 			
		 			$("#open_day_A").datebox('setValue','');
		 			$("#scale_cd_A").textbox('setValue','');
		 			$("#scale_dt_A").datebox('setValue','');
		 			$("#credit_cd_A").combobox('setValue','');
		 			$("#credit_dt_A").datebox('setValue','');
		 			$("#female_yn_A").combobox('setValue','N');
		 			$("#female_dt_A").datebox('setValue','');
		 			
					$("input:checkbox[id='unuse_yn_A']").attr("checked", false);
					$("input:checkbox[name='license_A']").attr("checked", false);
					
					setGrid2();
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "저장에러！");
			});
        }
	});
}
function delete_manu(){
	if($("#s_business_no").val()==""){
		$.messager.alert("알림", "삭제할 제조사를 클릭해 주세요.");	
		return;
	}
	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
        if (r){			
        	var effectRow = new Object();
 			effectRow["business_no"] = $("#s_business_no").val();		
			$.post("<c:url value='/enterprise/deleteManufacture.do'/>", effectRow, function(rsp) {
				if(rsp.status=="200"){
					$.messager.alert("알림", "삭제하였습니다.");					
					setGrid();
				}
			}, "JSON").error(function() {
				$.messager.alert("알림", "저장에러！");
			});
        }
	});
}
function getHisList(){
	$('#hisDlg').dialog('open');
	
	$("#hisTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/getBizHisList.do'/>",
		queryParams : {
			business_no : $("#s_business_no").val()
		},
		onLoadSuccess : function(row, param) {
			setBizHisGrid()
		}
		
	});
	
}
function getBidReportList(){
	$('#bidDlg').dialog('open');
	
	$("#bidTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/getBidReportList.do'/>",
		queryParams : {
			business_no : $("#s_business_no").val()
		},
		onLoadSuccess : function(row, param) {
			eventBtn();
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
function eventBtn(){
	$('#bc').datagrid('getPanel').find("[type='his_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no").val(business_no);
				getHisList();
			}
		})
	});
	$('#bc').datagrid('getPanel').find("[type='bid_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no").val(business_no);
				getBidReportList();
			}
		})
	});
	$('#bidTb').datagrid('getPanel').find("[type='report_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no").val(business_no);
				
				$('#manufactureList').dialog('open');
				
				var row = $("#bidTb").datagrid("selectRow",index);
				var row = $("#bidTb").datagrid("getSelected");
				
				setReportInfo(row);
			}
		})
	});
}
function setLicenseList(){
	$("#bizLicenseTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/licenseList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val()
		},
		onLoadSuccess : function(row, param) {		
			$('#bizLicenseDlg').dialog('open');
		}
	});
}
function joinApproveOrRefusal(approveYn, businessNo, email){
	$.ajax({ 
	    type: "post"
	   ,url: "<c:url value='/enterprise/joinArrpoveOrRefusal.do'/>"
	   ,async: false
	   ,data : {
		   join_approve_yn : approveYn,
		   business_no : businessNo,
		   email : email
		}
	   ,dataType: "json"
	   ,success:function(json){
		   if(approveYn == 'Y'){
			   $.messager.alert("알림", "승인 처리 되었습니다.");   
		   }else{
			   $.messager.alert("알림", "반려 처리 되었습니다.");
		   }
		   $("#bc4").datagrid('reload');
		   $("#bc2").datagrid('reload');
	   }
	});
}
function removeLicense(){
	var $dg = $("#bizLicenseTb");
		
	var row = $dg.datagrid('getChecked');
	
	if (row.length == 0){
		$.messager.alert("알림", "삭제할 내용을 선택해주세요.");
		return;
	}

	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
	    if (r){
			if (row.length) {
				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(row);
				
				$.post("<c:url value='/enterprise/removeLicenseList.do'/>", effectRow, function(rsp) {
					if(rsp.status){
						setLicenseList();
					}
				}, "JSON").error(function() {
					$.messager.alert("알림", "삭제에러！");
				});
			 }
		}  
	});
}
function getLicenseTotalList(){
	$("#bizLicenseTb2").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/licenseTotalList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val()
		}
	});
}
function addLicense(){
	getLicenseTotalList();
	$('#bizLicenseDlg2').dialog('open');
}
function getCompanyTypeList(){
	
	$("#bizCompanyTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/companyTypeList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt : $("#search_company_txt").textbox("getValue")
		},
		onLoadSuccess : function(row, param) {
			
			$('#bizCompanyTypeDlg').dialog('open');
		}
	});
	
}
function licenseSave(){
	var $dg = $("#bizLicenseTb2");
		
		var row = $dg.datagrid('getChecked');
		
		if (row.length == 0){
			$.messager.alert("알림", "등록할 내용을 선택해주세요.");
			return;
		}
		
	$.messager.confirm('알림', '등록하시겠습니까?', function(r){
        if (r){
       		if (row.length) {
   				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(row);

				$.post("<c:url value='/enterprise/updateLicenseList.do'/>", effectRow, function(rsp) {
   					if(rsp.status){
   						$("#bizLicenseDlg2").dialog('close');
   						setLicenseList();
   					}
   				}, "JSON").error(function() {
   					$.messager.alert("알림", "등록에러！");
   				});
   			 }
    		
        }
	});
}
function addCompanyType(){
	getCompanyTypeTotalList2();
	$('#companyTypeDlg2').dialog('open');
}
function removeCompanyType(){
	var $dg = $("#bizCompanyTypeTb");
		
	var row = $dg.datagrid('getSelections');
	
	if (row.length == 0){
		$.messager.alert("알림", "삭제할 내용을 선택해주세요.");
		return;
	}

	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
	    if (r){
			if (row.length) {
				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(row);
				
				$.post("<c:url value='/enterprise/removeBizCompanyTypeList.do'/>", effectRow, function(rsp) {
					if(rsp.status){
						getCompanyTypeList();
					}
				}, "JSON").error(function() {
					$.messager.alert("알림", "삭제에러！");
				});
			 }
		}  
	});
}
function getGoodsTypeList(){
	
	$("#bizGoodsTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsTypeList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt : $("#search_goods_txt").textbox("getValue")
		},
		onLoadSuccess : function(row, param) {			
			$('#bizGoodsDlg').dialog('open');
		}
	});
	
}
function addGoodsType(){
	getGoodsTypeTotalList2();
	$('#goodsDlg2').dialog('open');
}
function getGoodsTypeTotalList(){
	
	$("#goodsTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsTypeTotalList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt2 : $("#search_goods_txt2").textbox("getValue"),
			searchTxt3 : $("#search_goods_txt3").textbox("getValue")
		}
	});
	
}
function getGoodsTypeTotalList2(){
	
	$("#goodsTb2").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsTypeTotalList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt2 : $("#search_goods_txt22").textbox("getValue"),
			searchTxt3 : $("#search_goods_txt32").textbox("getValue")
		}
	});
	
}
function goodsTypeSave(){
	var $dg = $("#goodsTb");
		var row = $dg.datagrid('getSelections');
		if (row.length == 0){
			$.messager.alert("알림", "추가할 물품을 선택해주세요.");
			return;
		}
		var jsonResult = JSON.stringify(row);
		var jsonData = JSON.parse(jsonResult);
		var setNm = "";
		var setCd = "";
		for(var i=0;i<jsonData.length;i++){
			setNm += jsonData[i].goods_nm + ",";
			setCd += jsonData[i].goods_no + ",";
		}
		$("#s_goods_type_A").val(setCd.slice(0,-1));
		$("#s_goods_type_nm_A").textbox('setValue', setNm.slice(0,-1));
		$('#goodsDlg').dialog('close');
}
function goodsTypeSave2(){
	var $dg = $("#goodsTb2");
		
		var row = $dg.datagrid('getSelections');
		
		if (row.length == 0){
			$.messager.alert("알림", "등록할 내용을 선택해주세요.");
			return;
		}
		
	$.messager.confirm('알림', '등록하시겠습니까?', function(r){
        if (r){
       		if (row.length) {
   				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(row);

				$.post("<c:url value='/enterprise/updateBizGoodsTypeList.do'/>", effectRow, function(rsp) {
   					if(rsp.status){
   						$("#goodsDlg2").dialog('close');
   						getGoodsTypeList();
   					}
   				}, "JSON").error(function() {
   					$.messager.alert("알림", "등록에러！");
   				});
   			 }
   		}
	});
}
function removeGoodsType(){
	var $dg = $("#bizGoodsTb");
		
	var row = $dg.datagrid('getSelections');
	
	if (row.length == 0){
		$.messager.alert("알림", "삭제할 내용을 선택해주세요.");
		return;
	}

	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
	    if (r){
			if (row.length) {
				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(row);
				
				$.post("<c:url value='/enterprise/removeBizGoodsTypeList.do'/>", effectRow, function(rsp) {
					if(rsp.status){
						getGoodsTypeList();
					}
				}, "JSON").error(function() {
					$.messager.alert("알림", "삭제에러！");
				});
			 }
		}	  
	});
}
function getGoodsDirectList(){
	
	$("#bizGoodsDirectTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsDirectList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt : $("#search_goods_direct_txt").textbox("getValue")
		},
		onLoadSuccess : function(row, param) {
			
			$('#bizGoodsDirectDlg').dialog('open');
		}
	});
	
}
function addGoodsDirect(){
	getGoodsDirectTotalList2();
	$('#goodsDirectDlg2').dialog('open');
}
function getGoodsDirectTotalList(){
	$("#goodsDirectTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsDirectTotalList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt2 : $("#search_goods_direct_txt2").textbox("getValue"),
			searchTxt3 : $("#search_goods_direct_txt3").textbox("getValue")
		}
	});
}
function getGoodsDirectTotalList2(){
	$("#goodsDirectTb2").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/goodsDirectTotalList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt2 : $("#search_goods_direct_txt22").textbox("getValue"),
			searchTxt3 : $("#search_goods_direct_txt32").textbox("getValue")
		}
	});
}
function goodsDirectSave(){
	var $dg = $("#goodsDirectTb");
	var row = $dg.datagrid('getSelections');
	if (row.length == 0){
		$.messager.alert("알림", "추가할 물품을 선택해주세요.");
		return;
	}
	var jsonResult = JSON.stringify(row);
	var jsonData = JSON.parse(jsonResult);
	var setNm = "";
	var setCd = "";
	for(var i=0;i<jsonData.length;i++){
		setNm += jsonData[i].goods_nm + ",";
		setCd += jsonData[i].goods_no + ",";
	}
	$("#s_goods_direct_A").val(setCd.slice(0,-1));
	$("#s_goods_direct_nm_A").textbox('setValue', setNm.slice(0,-1));
	$('#goodsDirectDlg').dialog('close');
}
function goodsDirectSave2(){
	var $dg = $("#goodsDirectTb2");
		
		var row = $dg.datagrid('getSelections');
		
		if (row.length == 0){
			$.messager.alert("알림", "등록할 내용을 선택해주세요.");
			return;
		}
		
	$.messager.confirm('알림', '등록하시겠습니까?', function(r){
        if (r){
       		if (row.length) {
   				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(row);

				$.post("<c:url value='/enterprise/updateBizGoodsDirectList.do'/>", effectRow, function(rsp) {
   					if(rsp.status){
   						$("#goodsDirectDlg2").dialog('close');
   						getGoodsDirectList();
   					}
   				}, "JSON").error(function() {
   					$.messager.alert("알림", "등록에러！");
   				});
   			 }
   		}      
	});
}
function removeGoodsDirect(){
	var $dg = $("#bizGoodsDirectTb");
		
	var row = $dg.datagrid('getSelections');
	
	if (row.length == 0){
		$.messager.alert("알림", "삭제할 내용을 선택해주세요.");
		return;
	}

	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
	    if (r){
			if (row.length) {
				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(row);
				
				$.post("<c:url value='/enterprise/removeBizGoodsDirectList.do'/>", effectRow, function(rsp) {
					if(rsp.status){
						getGoodsDirectList();
					}
				}, "JSON").error(function() {
					$.messager.alert("알림", "삭제에러！");
				});
			 }
		}
	});
}
function updateGoodsDirectLimitDt(){
	$.messager.confirm('알림', '변경된 내용을 저장하시겠습니까?', function(r){
	    if (r){
	    	var $dg = $("#bizGoodsDirectTb");
	    	var rows = $dg.datagrid("getRows");
	    	for(var i=0; i<rows.length; i++){
	    		if ($dg.datagrid('validateRow', i)){
	            	$dg.datagrid('endEdit', i);
	            } 
	    	}
			if (rows.length) {
				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(rows);
				//console.log(JSON.stringify(rows));
				$.post("<c:url value='/enterprise/updateGoodsDirectLimitDt.do'/>", effectRow, function(rsp) {
					if(rsp.status){
						$.messager.alert("알림", "저장하였습니다.");
					}
				}, "JSON").error(function() {
					$.messager.alert("알림", "삭제에러！");
				});
			}		
		}
	});
}
function updateLicenseLimitDt(){
	$.messager.confirm('알림', '변경된 내용을 저장하시겠습니까?', function(r){
	    if (r){
	    	var $dg = $("#bizLicenseTb");
	    	var rows = $dg.datagrid("getRows");
	    	for(var i=0; i<rows.length; i++){
	    		if ($dg.datagrid('validateRow', i)){
	            	$dg.datagrid('endEdit', i);
	            } 
	    	}
			if (rows.length) {
				var effectRow = new Object();
				effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
				effectRow["selecter"] = JSON.stringify(rows);
				//console.log(JSON.stringify(rows));
				$.post("<c:url value='/enterprise/updateLicenseLimitDt.do'/>", effectRow, function(rsp) {
					if(rsp.status){
						$.messager.alert("알림", "저장하였습니다.");
					}
				}, "JSON").error(function() {
					$.messager.alert("알림", "삭제에러！");
				});
			}		
		}
	});
}
var searchIdName;
var searchNmName;
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
function eventBtn2(){
	$('#bc2').datagrid('getPanel').find("[type='company_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no2").val(business_no);
				getCompanyTypeList();
			}
		})
	});
	$('#bc2').datagrid('getPanel').find("[type='goods_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no2").val(business_no);
				getGoodsTypeList();
			}
		})
	});
	$('#bc2').datagrid('getPanel').find("[type='goods_direct']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no2").val(business_no);
				getGoodsDirectList();
			}
		})
	});
	$('#bc2').datagrid('getPanel').find("[type='biz_history']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no2").val(business_no);
				$("#bizHistoryDlg").dialog('open');
				setBizHisGrid2();
			}
		})
	});
	$('#bc2').datagrid('getPanel').find("[type='file_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no2").val(business_no);
				$("#bizFileDlg").dialog('open');

				var row = $("#bc2").datagrid("selectRow",index);
				var row = $("#bc2").datagrid("getSelected");
				setFileList(row);
				
			}
		})
	});
	$('#bc2').datagrid('getPanel').find("[type='license_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no2").val(business_no);
				setLicenseList();
			}
		})
	});
}
function eventBtn3(){
	$('#bc4').datagrid('getPanel').find("[type='company_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no3").val(business_no);
				getCompanyTypeList();
			}
		})
	});
	$('#bc4').datagrid('getPanel').find("[type='goods_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no3").val(business_no);
				getGoodsTypeList();
			}
		})
	});
	$('#bc4').datagrid('getPanel').find("[type='goods_direct']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no3").val(business_no);
				getGoodsDirectList();
			}
		})
	});
	$('#bc4').datagrid('getPanel').find("[type='biz_history']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no3").val(business_no);
				$("#bizHistoryDlg").dialog('open');
				setBizHisGrid2();
			}
		})
	});
	$('#bc4').datagrid('getPanel').find("[type='file_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no3").val(business_no);
				$("#bizFileDlg").dialog('open');

				var row = $("#bc4").datagrid("selectRow",index);
				var row = $("#bc4").datagrid("getSelected");
				setFileList(row);
				
			}
		})
	});
	$('#bc4').datagrid('getPanel').find("[type='license_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#s_business_no3").val(business_no);
				setLicenseList();
			}
		})
	});
	$('#bc4').datagrid('getPanel').find("[type='approve_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				var email = $(this).attr('email');
				$.messager.confirm('알림', '승인 처리하시겠습니까?', function(r){
			        if (r){
						joinApproveOrRefusal("Y", business_no, email);		
			        }
				});
			}
		})
	});
	$('#bc4').datagrid('getPanel').find("[type='refusal_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				var email = $(this).attr('email');
				$.messager.confirm('알림', '반려 처리하시겠습니까?', function(r){
			        if (r){
						joinApproveOrRefusal("N", business_no, email);		
			        }
				});
			}
		})
	});
}
function setFileList(row){
	$("#bizFileDlg #file_id1").filebox("setValue","");
	$("#bizFileDlg #file_id2").filebox("setValue","");
	$("#bizFileDlg #file_id3").filebox("setValue","");
	$("#bizFileDlg #file_id4").filebox("setValue","");
	
	$("#bizFileDlg #file_id1").filebox("setText",row.file_nm1);
	$("#bizFileDlg #file_id2").filebox("setText",row.file_nm2);
	$("#bizFileDlg #file_id3").filebox("setText",row.file_nm3);
	$("#bizFileDlg #file_id4").filebox("setText",row.file_nm4);
	
	$('#bizFileDlg #file_link1').unbind('click',null);
	$('#bizFileDlg #file_link2').unbind('click',null);
	$('#bizFileDlg #file_link3').unbind('click',null);
	$('#bizFileDlg #file_link4').unbind('click',null);
	$('#bizFileDlg #file_remove1').unbind('click',null);
	$('#bizFileDlg #file_remove2').unbind('click',null);
	$('#bizFileDlg #file_remove3').unbind('click',null);
	$('#bizFileDlg #file_remove4').unbind('click',null);
	
	$('#bizFileDlg #file_link1').bind('click', function(){
		if($("#bizFileDlg #file_id1").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id1+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#bizFileDlg #file_link2').bind('click', function(){
		if($("#bizFileDlg #file_id2").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id2+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#bizFileDlg #file_link3').bind('click', function(){
		if($("#bizFileDlg #file_id3").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id3+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#bizFileDlg #file_link4').bind('click', function(){
		if($("#bizFileDlg #file_id4").textbox("getText").length>0){
			location.href = "<c:url value='/file/download.do?file_id="+row.file_id4+"'/>";
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#bizFileDlg #file_remove1').bind('click', function(){
		if($("#bizFileDlg #file_id1").textbox("getText").length>0){
			$("#bizFileDlg #file_id1").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#bizFileDlg #file_remove2').bind('click', function(){
		if($("#bizFileDlg #file_id2").textbox("getText").length>0){
			$("#bizFileDlg #file_id2").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#bizFileDlg #file_remove3').bind('click', function(){
		if($("#bizFileDlg #file_id3").textbox("getText").length>0){
			$("#bizFileDlg #file_id3").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
	$('#bizFileDlg #file_remove4').bind('click', function(){
		if($("#bizFileDlg #file_id4").textbox("getText").length>0){
			$("#bizFileDlg #file_id4").textbox("setValue","");
		}else{
			$.messager.alert("알림", "파일이 존재하지 않습니다.");
			return;
		}
	});
}
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
	
	t = $('#s_bidmanager');
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
	
	t = $('#s_delegate_explain_txt');
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

	t = $('#s_area_txt2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid2();
	   }
	});	
	
	t = $('#search_company_txt2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getCompanyTypeTotalList();
	   }
	});	
	
	t = $('#search_company_txt3');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getCompanyTypeTotalList();
	   }
	});	
	
	t = $('#search_company_txt22');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getCompanyTypeTotalList2();
	   }
	});	
	
	t = $('#search_company_txt32');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getCompanyTypeTotalList2();
	   }
	});	
	
	t = $('#search_goods_txt22');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeTotalList2();
	   }
	});	
	
	t = $('#search_goods_txt32');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeTotalList2();
	   }
	});	
	
	t = $('#search_goods_direct_txt22');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsDirectTotalList2();
	   }
	});	
	
	t = $('#search_goods_direct_txt32');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsDirectTotalList2();
	   }
	});	
	
	t = $('#search_goods_txt2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeTotalList();
	   }
	});
	
	t = $('#search_goods_txt3');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeTotalList();
	   }
	});
	
	t = $('#search_goods_direct_txt2');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsDirectTotalList();
	   }
	});
	
	t = $('#search_goods_direct_txt3');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsDirectTotalList();
	   }
	});
	
	t = $('#search_company_txt2_1');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getCompanyTypeTotalSearchList();
	   }
	});
	
	t = $('#search_company_txt3_1');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getCompanyTypeTotalSearchList();
	   }
	});
	
	t = $('#search_goods_txt2_1');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeTotalSearchList();
	   }
	});
	
	t = $('#search_goods_txt3_1');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeTotalSearchList();
	   }
	});
	
	t = $('#search_company_txt');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getCompanyTypeList();
	   }
	});
	
	t = $('#search_goods_txt');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeList();
	   }
	});
	
	t = $('#search_goods_direct_txt');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsDirectList();
	   }
	});
	
}
function selectUserList(){
	$("#dg").datagrid({
		method : "GET",
		url : "<c:url value='/user/selectUserList.do'/>",
		queryParams : {
		},
		onDblClickRow : function(index, row){
			getData(row);
		}
	});
}

function clearUser(){
	$("#user_id").textbox("setValue","");
	$("#user_nm").textbox("setValue","");
	$("#pwd").textbox("setValue","");
	$("#team").textbox("setValue","");
	$("#email").textbox("setValue","");
	$("#email_pw").textbox("setValue","");
	$("#email_host").textbox("setValue","smart.whoismail.net");
	$("#email_port").textbox("setValue","587");
	$('#role_cd').combobox('setValue',"");
	$("#tel").textbox("setValue","");
	$("#mobile").textbox("setValue","");
	$("#fax").textbox("setValue","");
	$("#position").textbox("setValue","");
	
	$('#user_id').textbox('textbox').attr('maxlength', '100');
	$('#user_nm').textbox('textbox').attr('maxlength', '100');
	$('#pwd').textbox('textbox').attr('maxlength', '100');
	$('#team').textbox('textbox').attr('maxlength', '100');
	$('#email').textbox('textbox').attr('maxlength', '100');
	$('#email_pw').textbox('textbox').attr('maxlength', '100');
	$('#email_host').textbox('textbox').attr('maxlength', '100');
	$('#email_port').textbox('textbox').attr('maxlength', '100');
	$('#tel').textbox('textbox').attr('maxlength', '100');
	$('#mobile').textbox('textbox').attr('maxlength', '100');
	$('#fax').textbox('textbox').attr('maxlength', '100');
	$('#position').textbox('textbox').attr('maxlength', '100');
	
	$("#type").val("I");
	$("#user_id").textbox({disabled:false});
	$("#userIdBtn").linkbutton("enable");
	
	$('#userDlg').dialog('open');
}

function getData(row){

	clearUser();
	$("#user_id").textbox("setValue",row.user_id);
	$("#user_nm").textbox("setValue",row.user_nm);
	$("#team").textbox("setValue",row.team);
	$("#email").textbox("setValue",row.email);
	$("#email_pw").textbox("setValue",row.email_pw);
	$("#email_host").textbox("setValue",row.email_host);
	$("#email_port").textbox("setValue",row.email_port);
	$("#role_cd").combobox("setValue",row.role_cd);
	$("#tel").textbox("setValue",row.tel);
	$("#mobile").textbox("setValue",row.mobile);
	$("#fax").textbox("setValue",row.fax);
	$("#position").textbox("setValue",row.position);

	$("#type").val("U");
	$("#chkId").val("Y");
	
	$("#user_id").textbox({disabled:true});
	$("#userIdBtn").linkbutton("disable");
}

function getCompanyTypeTotalList(){
	
	$("#companyTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/companyTypeTotalList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt2 : $("#search_company_txt2").textbox("getValue"),
			searchTxt3 : $("#search_company_txt3").textbox("getValue")
		}
	});
	
}

function getCompanyTypeTotalList2(){
	
	$("#companyTypeTb2").datagrid({
		method : "GET",
		url : "<c:url value='/enterprise/companyTypeTotalList.do'/>",
		queryParams : {
			business_no : $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val(),
			searchTxt2 : $("#search_company_txt22").textbox("getValue"),
			searchTxt3 : $("#search_company_txt32").textbox("getValue")
		}
	});
	
}

function companyTypeSave(){
	var $dg = $("#companyTypeTb");
		
		var row = $dg.datagrid('getSelections');
		
		if (row.length == 0){
			$.messager.alert("알림", "추가할 업종을 선택해주세요.");
			return;
		}
		var jsonResult = JSON.stringify(row);
		var jsonData = JSON.parse(jsonResult);
		var setNm = "";
		var setCd = "";
		for(var i=0;i<jsonData.length;i++){
			setNm += jsonData[i].cd_nm + ",";
			setCd += jsonData[i].cd + ",";
		}
		$("#s_company_type_A").val(setCd.slice(0,-1));
		$("#s_company_type_nm_A").textbox('setValue', setNm.slice(0,-1));
		$('#companyTypeDlg').dialog('close');
}
function companyTypeSave2(){
	var $dg = $("#companyTypeTb2");
		
		var row = $dg.datagrid('getSelections');
		
		if (row.length == 0){
			$.messager.alert("알림", "등록할 내용을 선택해주세요.");
			return;
		}
		
	$.messager.confirm('알림', '등록하시겠습니까?', function(r){
        if (r){
        	if (endEditing()){
        		if (row.length) {
    				var effectRow = new Object();
					effectRow["business_no"] = $('#enterpriseTabs').tabs('getSelected').panel('options').title=='업체등록대기_투찰사'? $("#s_business_no3").val() : $("#s_business_no2").val();
					effectRow["selecter"] = JSON.stringify(row);

					$.post("<c:url value='/enterprise/updateBizCompanyTypeList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						$("#companyTypeDlg2").dialog('close');
    						getCompanyTypeList();
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "등록에러！");
    				});
    			 }
    		}
        }
	});
}
</script>
</head>
<body>
	<div id="header" class="group wrap header">
		<div class="content">
			<%@ include file="/include/top.jsp"%>
		</div>
	</div>
	<div id="mainwrap">
		<div id="content">
			<div style="margin: 1px 0; vertical-align: top"></div>
			<div class="easyui-layout" style="width: 100%; height: 800px;">
				<div data-options="region:'center'">
					<div id="enterpriseTabs" class="easyui-tabs"
						data-options="fit:true,border:false,plain:true">
						<div title="업체등록_제조사" style="padding: 5px; margin-left: 50px;">
							<div data-options="region:'west',collapsible:false" title=""
								style="width: 95%;">
								<table style="width: 100%;">
									<tr>
										<td align="right" id="moveBtn"><a
											href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-save'" onclick="save()">저장</a></td>
									</tr>
								</table>
								<table cellpadding="5" class="mytable">
									<tr>
										<td class="bc" style="width: 20%;">사업자번호</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="company_no_B"></td>
										<td class="bc" style="width: 20%;">기본주소</td>
										<td style="width: 30%;"><input id="address_B"
											class="easyui-combobox"
											data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:100,
										        panelHeight:'auto',
										        data:jsonData">
										</td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">업체명</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="company_nm_B"></td>
										<td class="bc" style="width: 20%;">상세주소</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="address_detail_B"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">대표자명</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="delegate_B"></td>
										<td class="bc" style="width: 20%;">직위 / 담당자</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 27%; height: 26px" id="position_B"> / <input
											class="easyui-textbox" style="width: 70%; height: 26px"
											id="bidmanager_B"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">대표물품1</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="delegate_explain_B"></td>
										<td class="bc" style="width: 20%;">전화번호</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="phone_no_B"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">대표물품2</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="delegate_explain2_B"></td>
										<td class="bc" style="width: 20%;">휴대폰번호</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="mobile_no_B"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">대표물품3</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="delegate_explain3_B"></td>
										<td class="bc" style="width: 20%;">이메일주소</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="email_B"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">견적형태</td>
										<td style="width: 30%;"><input type="checkbox"
											id="company_type_B1" name="company_type" />직접견적<input
											type="checkbox" id="company_type_B2" name="company_type" />정보견적</td>
										<td class="bc" style="width: 20%;">보류</td>
										<td style="width: 30%;"><input type="checkbox"
											id="unuse_yn_B" name="unuse_yn_B" /></td>
									</tr>
								</table>
							</div>
						</div>
						<div title="업체등록대기_투찰사" style="padding: 5px">
							<input type="hidden" id="s_business_no3" name="s_business_no3" />
							<table style="width: 100%;">
								<tr>
									<td width="80%" align="left"><input type="hidden"
										name="s_area_cd3" value="" />
										<table style="width: 100%;">
											<tr>
												<td class="bc">사업자번호</td>
												<td><input type="text" class="easyui-textbox"
													id="s_company_no3" name="s_company_no3"
													style="width: 100px;"></td>
												<td class="bc">업체명</td>
												<td><input type="text" class="easyui-textbox"
													id="s_company_nm3" name="s_company_nm3"
													style="width: 120px;"></td>
												<td class="bc">업종</td>
												<td><input type="hidden" id="s_company_type3"
													name="s_company_type3"> <input type="text"
													class="easyui-textbox" id="s_company_type_nm3"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchCompanyType('s_company_type3', 's_company_type_nm3', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchCompanyType('s_company_type3', 's_company_type_nm3', 'c')"></a>
												</td>
												<td class="bc">물품</td>
												<td><input type="hidden" id="s_goods_type3"
													name="s_goods_type3"> <input type="text"
													class="easyui-textbox" id="s_goods_type_nm3"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchGoodsType('s_goods_type3', 's_goods_type_nm3', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchGoodsType('s_goods_type3', 's_goods_type_nm3', 'c')"></a>
												</td>
												<td class="bc">직생물품</td>
												<td><input type="hidden" id="s_goods_direct3"
													name="s_goods_direct3"> <input type="text"
													class="easyui-textbox" id="s_goods_direct_nm2"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchGoodsType('s_goods_direct3', 's_goods_direct_nm3', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchGoodsType('s_goods_direct3', 's_goods_direct_nm3', 'c')"></a>
												</td>
												<td class="bc">적격정보</td>
												<td><input type="hidden" id="s_license_type3"
													name="s_license_type3"> <input type="text"
													class="easyui-textbox" id="s_license_type_nm3"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchLicenseType('s_license_type3', 's_license_type_nm3', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchLicenseType('s_license_type3', 's_license_type_nm3', 'c')"></a>
												</td>
												<td class="bc">지역명</td>
												<td><input id="s_area_cd3" class="easyui-combobox"
													data-options="
														method:'get',
												        valueField: 'cd',
												        textField: 'cd_nm',
												        width:110,
												        panelHeight:'auto',
												        url: '<c:url value='/bid/comboList.do?searchType=A&cdGroupCd=main_area_cd'/>'">
													<input type="text" class="easyui-textbox" id="s_area_txt3"
													name="s_area_txt3" style="width: 100px;" /></td>
											</tr>
										</table></td>

									<td width="12%" align="right"><a href="javascript:void(0)"
										class="easyui-linkbutton btnSearch"
										data-options="iconCls:'icon-search'" onclick="setGrid3()">조회</a>
										<a href="javascript:void(0)" class="easyui-linkbutton"
										data-options="iconCls:'icon-delete'"
										onclick="delete_business()">삭제</a> <a
										href="javascript:void(0)" class="easyui-linkbutton"
										data-options="iconCls:'icon-save'" onclick="save6()">저장</a></td>
								</tr>
							</table>
							<div style="display: none;">
								<table class="easyui-datagrid"
									style="width: 0px; height: 0px; border: 0">
								</table>
							</div>
							<table id="bc4" class="easyui-datagrid"
								style="width: 100%; height: 90%;"
								data-options="iconCls: 'icon-edit',
												rownumbers:false,
												singleSelect:true,
												striped:true,
												pagination:true,
												pageSize:100,
											  	pageList:[100,50,200,500],
											    method:'get',
											    striped:true,
											    nowrap:false,
												onDblClickCell: onDblClickCell3,
											  	onEndEdit:onEndEdit3,
											  	onBeforeEdit:onBeforeEdit,
											  	rowStyler: function(index,row){
								                    if (row.flag=='A'){
								                        return 'background-color:#ff99ff;color:#fff;';
								                    }
								                    if (row.unuse_yn=='Y'){
								                        return 'background-color:#eeeeee;color:#999999;';
								                    }
								              	}">
								<thead>
									<tr>
										<th
											data-options="field:'business_no',align:'center',halign:'center'"
											width="80">No.
										<th
											data-options="field:'join_req_dt',align:'center',halign:'center',width:180">요청일자</th>
										<th
											data-options="field:'unuse_yn',align:'center',halign:'center',width:40,hidden:true,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">보류</th>
										<th
											data-options="field:'company_no',halign:'center',editor:'textbox'"
											width="150">사업자번호</th>
										<th
											data-options="field:'company_nm',halign:'center',editor:'textbox'"
											width="150">업체명</th>
										<th
											data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"
											width="80">대표자명</th>
										<th
											data-options="field:'company_type_insert',align:'center',halign:'center',max:10"
											width="50" formatter="formatRowButton_C">업종</th>
										<th
											data-options="field:'company_type_insert2',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton2_C">제조물품</th>
										<th
											data-options="field:'company_type_insert3',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton3_C">직생물품</th>
										<th
											data-options="field:'company_type_insert6',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton6_C">적격정보</th>
										<th
											data-options="field:'address',align:'left',halign:'center',sortable:true,width:100,
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
											                                data:jsonData,
											                                required:false
											                            }
											                        }">기본주소</th>
										<th
											data-options="field:'address_detail',halign:'center',editor:'textbox',max:100"
											width="250">상세주소</th>
										<th
											data-options="field:'position',halign:'center',editor:'textbox',max:20"
											width="50">직위</th>
										<th
											data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox',max:10"
											width="60">담당자</th>
										<th
											data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',max:11"
											width="120">전화</th>
										<th
											data-options="field:'mobile_no',align:'center',halign:'center',editor:'textbox',max:11"
											width="120">휴대폰</th>
										<th
											data-options="field:'pwd',align:'left',halign:'center',editor:'textbox',max:11"
											width="100">pwd</th>
										<th
											data-options="field:'email',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['email','length[0,30]'],invalidMessage:'알맞은 이메일 형식을 사용하세요(0~30자내)'}}"
											width="200">이메일</th>
										<th
											data-options="field:'start_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}">개업일</th>
										<th
											data-options="field:'scale_cd',align:'center',halign:'center',sortable:true,width:100,
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
											                                data:jsonData5,
											                                required:false
											                            }
											                        }">기업구분</th>
										<th
											data-options="field:'scale_dt',align:'center',halign:'center',sortable:true,width:130,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler">중소기업확인만료일</th>
										<th
											data-options="field:'credit_cd',align:'center',halign:'center',sortable:true,width:100,
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
											                                data:jsonData6,
											                                required:false
											                            }
											                        }">신용등급</th>
										<th
											data-options="field:'credit_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler">신용등급만료일</th>
										<th
											data-options="field:'female_yn',align:'center',halign:'center',width:70,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">여성기업</th>
										<th
											data-options="field:'female_dt',align:'center',halign:'center',sortable:true,width:130,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}">여성기업시작일</th>
										<th
											data-options="field:'join_route',halign:'center',editor:'textbox',max:100"
											width="100">가입경로</th>
										<th
											data-options="field:'company_type_insert4',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton4_C">이력보기</th>
										<th
											data-options="field:'company_type_insert5',align:'center',halign:'center',max:10"
											width="90" formatter="formatRowButton5_C">첨부파일</th>
										<th
											data-options="field:'company_type_insert7',align:'center',halign:'center',max:10"
											width="90" formatter="formatRowButton7_C">처리</th>
									</tr>
								</thead>
							</table>
							<script>
								function formatRowButton_C(val,row){
									
									if(row.company_type_insert=="1"){
									   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"company_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
									}
									return ;
								}
								function formatRowButton2_C(val,row){
									if(row.company_type_insert=="1"){
									   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"goods_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
									}
									return ;
								}
								function formatRowButton3_C(val,row){
									if(row.company_type_insert=="1"){
									   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"goods_direct\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
									}
									return ;
								}
								function formatRowButton4_C(val,row){
									if(row.company_type_insert=="1"){
									   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"biz_history\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
									}
									return ;
								}
								function formatRowButton5_C(val,row){
									if(row.company_type_insert=="1"){
									   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-save'\" type=\"file_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
									}
									return ;
								}
								function formatRowButton6_C(val,row){
									if(row.company_type_insert=="1"){
									   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"license_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
									}
									return ;
								}
								function formatRowButton7_C(val,row){
									return "<a href=\"#\" class=\"easyui-linkbutton c1\" type=\"approve_type\" val=\""+row.business_no+"\" email=\""+row.email+"\" onclick=\"\">승인</a><a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" type=\"refusal_type\" val=\""+row.business_no+"\" email=\""+row.email+"\" onclick=\"\">반려</a>";
								}
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
								var editIndex6 = undefined;
								function endEditing7(){
									if (editIndex6 == undefined){return true}
									if ($('#bc4').datagrid('validateRow', editIndex6)){
								 		$('#bc4').datagrid('endEdit', editIndex6);
										editIndex6 = undefined;
										return true;
									} else {
										return false;
									}
								}
								function onDblClickCell3(index, field){
									if (editIndex6 != index){
										if (endEditing7()){
											if(field=="company_type_insert") {editIndex6 = index; return};
											if(field=="company_type_insert2"){editIndex6 = index; return};
											if(field=="company_type_insert3"){editIndex6 = index; return};
											if(field=="company_type_insert4"){editIndex6 = index; return};
											if(field=="company_type_insert5"){editIndex6 = index; return};
											if(field=="company_type_insert6"){editIndex6 = index; return};
											if(field=="company_type_insert7"){editIndex6 = index; return};
											$('#bc4').datagrid('selectRow', index)
													.datagrid('beginEdit', index);
											var selecter = $('#bc4').datagrid('getSelected');
											
											if(field=="business_no"){
												if(selecter.company_type_insert == "1"){
													var ed = $('#bc4').datagrid('getEditor', {index:index,field:'business_no'});
													if (ed){
														$(ed.target).textbox('readonly',true);
														return;
													}
												}
											}else{
												if(selecter.company_type_insert == "1"){
													var ed = $('#bc4').datagrid('getEditor', {index:index,field:'business_no'});
													if (ed){
														$(ed.target).textbox('readonly',true);
													}
												}
											}
											
											var ed = $('#bc4').datagrid('getEditor', {index:index,field:field});
											if (ed){
												($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
											}
											
											editIndex6 = index;
										} else {
											$('#bc4').datagrid('selectRow', editIndex6);
										}
									}
									eventBtn3();
								}
								function onEndEdit3(index, row){
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
								 function onBeforeEdit(index,row){
							  	   row.editing=true;
							  	   $(this).datagrid('refreshRow', index);
							     }				
								function delete_business(){
									if($("#s_business_no3").val()==""){
										$.messager.alert("알림", "삭제할 투찰사를 클릭해 주세요.");	
										return;
									}
									$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
								        if (r){			
								        	var effectRow = new Object();
								 			effectRow["business_no"] = $("#s_business_no3").val();		
											$.post("<c:url value='/enterprise/deleteBusiness.do'/>", effectRow, function(rsp) {
												if(rsp.status=="200"){
													$.messager.alert("알림", "삭제하였습니다.");					
													setGrid3();
												}
											}, "JSON").error(function() {
												$.messager.alert("알림", "저장에러！");
											});
								        }
									});
								}
								function save6(){
							    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
								        if (r){
								        	if (endEditing7()){
								    			var $dg = $("#bc4");
							
								    			if ($dg.datagrid('getChanges').length) {
								    				var updated = $dg.datagrid('getChanges', "updated");
								    				
								    				var effectRow = new Object();
								    				if (updated.length) {
								    					effectRow["updated"] = JSON.stringify(updated);
								    				}
								    				$.post("<c:url value='/enterprise/updateBusinessList.do'/>", effectRow, function(rsp) {
								    					if(rsp.status){
								    						$.messager.alert("알림", "저장하였습니다.");
								    						$dg.datagrid('acceptChanges');
								    						setGrid3();
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
						<div title="업체등록_투찰사" style="padding: 5px; margin-left: 50px;">
							<div data-options="region:'west',collapsible:false" title=""
								style="width: 95%;">
								<table style="width: 100%;">
									<tr>
										<td align="right" id="moveBtn"><a
											href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-save'" onclick="save5()">저장</a></td>
									</tr>
								</table>
								<table cellpadding="5" class="mytable">
									<tr>
										<td class="bc" style="width: 20%;">사업자번호</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="company_no_A"></td>
										<td class="bc" style="width: 20%;">기본주소</td>
										<td style="width: 30%;"><input id="address_A"
											class="easyui-combobox"
											data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:100,
										        panelHeight:'auto',
										        data:jsonData">
										</td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">업체명</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="company_nm_A"></td>
										<td class="bc" style="width: 20%;">상세주소</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="address_detail_A"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">대표자명</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="delegate_A"></td>
										<td class="bc" style="width: 20%;">직위 / 담당자</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 27%; height: 26px" id="position_A"> / <input
											class="easyui-textbox" style="width: 70%; height: 26px"
											id="bidmanager_A"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">업종</td>
										<td style="width: 30%;"><input type="hidden"
											id="s_company_type_A" name="s_company_type_A"> <input
											type="text" class="easyui-textbox" id="s_company_type_nm_A"
											style="width: 85%;" disabled="disabled"> <a
											href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-search'"
											onclick="getCompanyTypeTotalList();$('#companyTypeDlg').dialog('open');"></a>
											<a href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-cancel'"
											onclick="$('#s_company_type_nm_A').textbox('setValue','');$('#s_company_type_A').val('');"></a>
										</td>
										<td class="bc" style="width: 20%;">전화번호</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="phone_no_A"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">제조물품</td>
										<td style="width: 30%;"><input type="hidden"
											id="s_goods_type_A" name="s_goods_type_A"> <input
											type="text" class="easyui-textbox" id="s_goods_type_nm_A"
											style="width: 85%;" disabled="disabled"> <a
											href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-search'"
											onclick="getGoodsTypeTotalList();$('#goodsDlg').dialog('open');"></a>
											<a href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-cancel'"
											onclick="$('#s_goods_type_nm_A').textbox('setValue','');$('#s_goods_type_A').val('');"></a>
										</td>
										<td class="bc" style="width: 20%;">휴대폰번호</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="mobile_no_A"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">직생물품</td>
										<td style="width: 30%;"><input type="hidden"
											id="s_goods_direct_A" name="s_goods_direct_A"> <input
											type="text" class="easyui-textbox" id="s_goods_direct_nm_A"
											style="width: 85%;" disabled="disabled"> <a
											href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-search'"
											onclick="getGoodsDirectTotalList();$('#goodsDirectDlg').dialog('open');"></a>
											<a href="javascript:void(0)" class="easyui-linkbutton"
											data-options="iconCls:'icon-cancel'"
											onclick="$('#s_goods_direct_nm_A').textbox('setValue','');$('#s_goods_direct_A').val('');"></a>
										</td>
										<td class="bc" style="width: 20%;">이메일주소</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="email_A"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">가입경로</td>
										<td style="width: 30%;"><input class="easyui-textbox"
											style="width: 100%; height: 26px" id="join_route_A"></td>
										<td class="bc" style="width: 20%;">보류</td>
										<td style="width: 30%;"><input type="checkbox"
											id="unuse_yn_A" name="unuse_yn_A" /></td>
									</tr>
								</table>
								<table cellpadding="5" class="mytable">
									<tr>
										<td class="bc" style="width: 20%;">아이디</td>
										<td style="width: 30%;">저장시 생성</td>
										<td class="bc" style="width: 20%;">비밀번호</td>
										<td style="width: 30%;">1회용 비밀번호 자동생성</td>
									</tr>
								</table>
								<table cellpadding="5" class="mytable">
									<tr>
										<td class="bc" style="width: 20%;">개업일</td>
										<td style="width: 30%;"><input class="easyui-datebox"
											id="open_day_A" style="width: 100px;"
											data-options="formatter:myformatter,parser:myparser"></td>
										<td class="bc" style="width: 20%;"></td>
										<td style="width: 30%;"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">기업구분</td>
										<td style="width: 30%;"><input id="scale_cd_A"
											name="scale_cd_A" class="easyui-combobox"
											data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
												        valueField: 'cd',
												        textField: 'cd_nm',
												        data:jsonData5" />
										</td>
										<td class="bc" style="width: 20%;">중소기업확인만료일</td>
										<td style="width: 30%;"><input class="easyui-datebox"
											id="scale_dt_A" style="width: 100px;"
											data-options="formatter:myformatter,parser:myparser"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">신용등급</td>
										<td style="width: 30%;"><input id="credit_cd_A"
											name="credit_cd_A" class="easyui-combobox"
											data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
												        valueField: 'cd',
												        textField: 'cd_nm',
												        data:jsonData6" />
										</td>
										<td class="bc" style="width: 20%;">신용등급만료일</td>
										<td style="width: 30%;"><input class="easyui-datebox"
											id="credit_dt_A" style="width: 100px;"
											data-options="formatter:myformatter,parser:myparser"></td>
									</tr>
									<tr>
										<td class="bc" style="width: 20%;">여성기업</td>
										<td style="width: 30%;"><select class="easyui-combobox"
											id="female_yn_A" data-options="panelHeight:'auto'"
											style="width: 50px;">
												<option value="N">N</option>
												<option value="Y">Y</option>
										</select></td>
										<td class="bc" style="width: 20%;">여성기업시작일</td>
										<td style="width: 30%;"><input class="easyui-datebox"
											id="female_dt_A" style="width: 100px;"
											data-options="formatter:myformatter,parser:myparser"></td>
									</tr>
								</table>
								<table cellpadding="5" class="mytable">
									<tr>
										<td class="bc" style="width: 100%;">적격정보</td>
									</tr>
									<tr>
										<td><div id="license_txt"></div></td>
									</tr>
								</table>
							</div>
						</div>
						<div title="업체현황_제조사" style="padding: 5px">
							<input type="hidden" id="s_business_no" name="s_business_no" />
							<table style="width: 100%;">
								<tr>
									<td width="80%" align="left"><input type="hidden"
										name="s_area_cd" value="" />
										<table style="width: 100%;">
											<tr>
												<td class="bc">사업자번호</td>
												<td><input type="text" class="easyui-textbox"
													id="s_company_no" name="s_company_no" style="width: 100px;">
												</td>
												<td class="bc">업체명</td>
												<td><input type="text" class="easyui-textbox"
													id="s_company_nm" name="s_company_nm" style="width: 150px;">
												</td>
												<td class="bc">담당자</td>
												<td><input type="text" class="easyui-textbox"
													id="s_bidmanager" style="width: 100px;" /></td>
												<td class="bc">지역명</td>
												<td><input id="s_area_cd" class="easyui-combobox"
													data-options="
													method:'get',
											        valueField: 'cd',
											        textField: 'cd_nm',
											        width:120,
											        panelHeight:'auto',
											        url: '<c:url value='/bid/comboList.do?searchType=A&cdGroupCd=main_area_cd'/>'">
													<input type="text" class="easyui-textbox" id="s_area_txt"
													name="s_area_txt" style="width: 100px;" /></td>
												<td class="bc">대표물품</td>
												<td><input type="text" class="easyui-textbox"
													id="s_delegate_explain_txt" style="width: 100px;" /></td>
											</tr>
										</table></td>

									<td width="12%" align="right"><a href="javascript:void(0)"
										class="easyui-linkbutton btnSearch"
										data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a>
										<a href="javascript:void(0)" class="easyui-linkbutton"
										data-options="iconCls:'icon-delete'" onclick="delete_manu()">삭제</a>
										<a href="javascript:void(0)" class="easyui-linkbutton"
										data-options="iconCls:'icon-save'" onclick="save3()">저장</a></td>
								</tr>
							</table>
							<div style="display: none;">
								<table class="easyui-datagrid"
									style="width: 0px; height: 0px; border: 0">
								</table>
							</div>
							<table id="bc" class="easyui-datagrid"
								style="width: 100%; height: 90%;"
								data-options="iconCls: 'icon-edit',
											rownumbers:false,
											singleSelect:true,
											striped:true,
											pagination:true,
											pageSize:100,
										  	pageList:[100,50,200,500],
	  									    nowrap:false,
	  									    onDblClickCell: onDblClickCell,
											rowStyler: function(index,row){
											                    if (row.unuse_yn=='Y'){
											                        return 'color:#FF0000;';
											                    }
											              }">
								<thead>
									<tr>
										<th
											data-options="field:'business_no',align:'center',halign:'center'"
											width="80">No.</th>
										<th
											data-options="field:'unuse_yn',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">보류</th>
										<th
											data-options="field:'company_no',halign:'center',editor:'textbox'"
											width="150">사업자번호</th>
										<th
											data-options="field:'company_nm',halign:'center',editor:'textbox'"
											width="150">업체명</th>
										<th
											data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"
											width="80">대표자명</th>
										<th
											data-options="field:'delegate_explain',align:'center',halign:'center',editor:'textbox'"
											width="80">대표물품1</th>
										<th
											data-options="field:'delegate_explain2',align:'center',halign:'center',editor:'textbox'"
											width="80">대표물품2</th>
										<th
											data-options="field:'delegate_explain3',align:'center',halign:'center',editor:'textbox'"
											width="80">대표물품3</th>
										<th
											data-options="field:'address',align:'left',halign:'center',sortable:true,width:100,
										                        formatter:function(value,row){
										                            return row.address_nm;
										                        },
										                        editor:{
										                            type:'combobox',
										                            options:{
										                                valueField:'cd',
										                                textField:'cd_nm',
										                                method:'get',
										                                data:jsonData,
										                                required:false
										                            }
										                        }">기본주소</th>
										<th
											data-options="field:'address_detail',halign:'center',editor:'textbox',max:100"
											width="250">상세주소</th>
										<th
											data-options="field:'position',halign:'center',editor:'textbox',max:20"
											width="60">직위</th>
										<th
											data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox',max:10"
											width="80">담당자</th>
										<th
											data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',max:11"
											width="110">전화번호</th>
										<th
											data-options="field:'mobile_no',align:'center',halign:'center',editor:'textbox',max:11"
											width="110">휴대폰번호</th>
										<th
											data-options="field:'email',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['email','length[0,30]'],invalidMessage:'알맞은 이메일 형식을 사용하세요(0~30자내)'}}"
											width="200">이메일</th>
										<th
											data-options="field:'company_type1',align:'center',halign:'center',width:60,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">직접견적</th>
										<th
											data-options="field:'company_type2',align:'center',halign:'center',width:60,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">정보견적</th>
										<th
											data-options="field:'company_type_insert3',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton3">이력보기</th>
										<th
											data-options="field:'company_type_insert4',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton4">견적보고서</th>
									</tr>
								</thead>
							</table>
							<script>
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
							function onDblClickCell(index, field) {
								if (editIndex != index){
									if (endEditing()){
										if(field=="company_type_insert3"){editIndex = index; return};
										if(field=="company_type_insert4"){editIndex = index; return};
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
									eventBtn();
								}
							}					
							function formatRowButton3(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"his_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							function formatRowButton4(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"bid_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
							function formatRowButton5(val,row){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"report_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
							}
						</script>
						</div>
						<div title="업체현황_투찰사" style="padding: 5px">
							<input type="hidden" id="s_business_no2" name="s_business_no2" />
							<table style="width: 100%;">
								<tr>
									<td width="80%" align="left"><input type="hidden"
										name="s_area_cd2" value="" />
										<table style="width: 100%;">
											<tr>
												<td class="bc">사업자번호</td>
												<td><input type="text" class="easyui-textbox"
													id="s_company_no2" name="s_company_no2"
													style="width: 100px;"></td>
												<td class="bc">업체명</td>
												<td><input type="text" class="easyui-textbox"
													id="s_company_nm2" name="s_company_nm2"
													style="width: 120px;"></td>
												<td class="bc">업종</td>
												<td><input type="hidden" id="s_company_type2"
													name="s_company_type2"> <input type="text"
													class="easyui-textbox" id="s_company_type_nm2"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchCompanyType('s_company_type2', 's_company_type_nm2', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchCompanyType('s_company_type2', 's_company_type_nm2', 'c')"></a>
												</td>
												<td class="bc">물품</td>
												<td><input type="hidden" id="s_goods_type2"
													name="s_goods_type2"> <input type="text"
													class="easyui-textbox" id="s_goods_type_nm2"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchGoodsType('s_goods_type2', 's_goods_type_nm2', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchGoodsType('s_goods_type2', 's_goods_type_nm2', 'c')"></a>
												</td>
												<td class="bc">직생물품</td>
												<td><input type="hidden" id="s_goods_direct2"
													name="s_goods_direct2"> <input type="text"
													class="easyui-textbox" id="s_goods_direct_nm2"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchGoodsType('s_goods_direct2', 's_goods_direct_nm2', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchGoodsType('s_goods_direct2', 's_goods_direct_nm2', 'c')"></a>
												</td>
												<td class="bc">적격정보</td>
												<td><input type="hidden" id="s_license_type2"
													name="s_license_type2"> <input type="text"
													class="easyui-textbox" id="s_license_type_nm2"
													style="width: 100px;" disabled="disabled"> <a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-search'"
													onclick="searchLicenseType('s_license_type2', 's_license_type_nm2', 's')"></a>
													<a href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-cancel'"
													onclick="searchLicenseType('s_license_type2', 's_license_type_nm2', 'c')"></a>
												</td>
												<td class="bc">지역명</td>
												<td><input id="s_area_cd2" class="easyui-combobox"
													data-options="
													method:'get',
											        valueField: 'cd',
											        textField: 'cd_nm',
											        width:110,
											        panelHeight:'auto',
											        url: '<c:url value='/bid/comboList.do?searchType=A&cdGroupCd=main_area_cd'/>'">
													<input type="text" class="easyui-textbox" id="s_area_txt2"
													name="s_area_txt2" style="width: 100px;" /></td>
											</tr>
										</table></td>

									<td width="14%" align="right"><a href="javascript:void(0)"
										class="easyui-linkbutton btnSearch"
										data-options="iconCls:'icon-search'" onclick="setGrid2()">조회</a>
										<a href="javascript:void(0)" class="easyui-linkbutton"
										data-options="iconCls:'icon-delete'"
										onclick="delete_business()">삭제</a> <a
										href="javascript:void(0)" class="easyui-linkbutton"
										data-options="iconCls:'icon-save'" onclick="save4()">저장</a> <a
										href="javascript:void(0)" class="easyui-linkbutton "
										data-options="iconCls:'icon-save'"
										onclick="downloadExcelList()">엑셀다운로드</a></td>
								</tr>
							</table>
							<div style="display: none;">
								<table class="easyui-datagrid"
									style="width: 0px; height: 0px; border: 0">
								</table>
							</div>
							<table id="bc2" class="easyui-datagrid"
								style="width: 100%; height: 90%;"
								data-options="iconCls: 'icon-edit',
											rownumbers:false,
											singleSelect:true,
											striped:true,
											pagination:true,
											pageSize:100,
										  	pageList:[100,50,200,500],
										    method:'get',
										    striped:true,
										    nowrap:false,
										    
											onDblClickCell: onDblClickCell2,
										  	onEndEdit:onEndEdit2,
										  	onBeforeEdit:onBeforeEdit,
										  	rowStyler: function(index,row){
							                    if (row.flag=='A'){
							                        return 'background-color:#ff99ff;color:#fff;';
							                    }
							                    if (row.unuse_yn=='Y'){
							                        return 'background-color:#eeeeee;color:#999999;';
							                    }
							              	}">
								<thead>
									<tr>
										<th
											data-options="field:'business_no',align:'center',halign:'center'"
											width="80">No.</th>
										<th
											data-options="field:'unuse_yn',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">보류</th>
										<th
											data-options="field:'company_no',halign:'center',editor:'textbox'"
											width="150">사업자번호</th>
										<th
											data-options="field:'company_nm',halign:'center',editor:'textbox'"
											width="150">업체명</th>
										<th
											data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"
											width="80">대표자명</th>
										<th
											data-options="field:'company_type_insert',align:'center',halign:'center',max:10"
											width="50" formatter="formatRowButton_B">업종</th>
										<th
											data-options="field:'company_type_insert2',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton2_B">제조물품</th>
										<th
											data-options="field:'company_type_insert3',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton3_B">직생물품</th>
										<th
											data-options="field:'company_type_insert6',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton6_B">적격정보</th>
										<th
											data-options="field:'address',align:'left',halign:'center',sortable:true,width:100,
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
										                                data:jsonData,
										                                required:false
										                            }
										                        }">기본주소</th>
										<th
											data-options="field:'address_detail',halign:'center',editor:'textbox',max:100"
											width="250">상세주소</th>
										<th
											data-options="field:'position',halign:'center',editor:'textbox',max:20"
											width="50">직위</th>
										<th
											data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox',max:10"
											width="60">담당자</th>
										<th
											data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',max:11"
											width="120">전화</th>
										<th
											data-options="field:'mobile_no',align:'center',halign:'center',editor:'textbox',max:11"
											width="120">휴대폰</th>
										<th
											data-options="field:'pwd',align:'left',halign:'center',editor:'textbox',max:11"
											width="100">pwd</th>
										<th
											data-options="field:'email',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['email','length[0,30]'],invalidMessage:'알맞은 이메일 형식을 사용하세요(0~30자내)'}}"
											width="200">이메일</th>
										<th
											data-options="field:'start_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}">개업일</th>
										<th
											data-options="field:'scale_cd',align:'center',halign:'center',sortable:true,width:100,
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
										                                data:jsonData5,
										                                required:false
										                            }
										                        }">기업구분</th>
										<th
											data-options="field:'scale_dt',align:'center',halign:'center',sortable:true,width:130,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler">중소기업확인만료일</th>
										<th
											data-options="field:'credit_cd',align:'center',halign:'center',sortable:true,width:100,
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
										                                data:jsonData6,
										                                required:false
										                            }
										                        }">신용등급</th>
										<th
											data-options="field:'credit_dt',align:'center',halign:'center',sortable:true,width:100,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler">신용등급만료일</th>
										<th
											data-options="field:'female_yn',align:'center',halign:'center',width:70,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">여성기업</th>
										<th
											data-options="field:'female_dt',align:'center',halign:'center',sortable:true,width:130,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}}">여성기업시작일</th>
										<th
											data-options="field:'join_route',halign:'center',editor:'textbox',max:100"
											width="100">가입경로</th>
										<th
											data-options="field:'company_type_insert4',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton4_B">이력보기</th>
										<th
											data-options="field:'company_type_insert5',align:'center',halign:'center',max:10"
											width="70" formatter="formatRowButton5_B">첨부파일</th>
									</tr>
								</thead>
							</table>
							<script>
							function formatRowButton_B(val,row){
								
								if(row.company_type_insert=="1"){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"company_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
								}
								return ;
							}
							function formatRowButton2_B(val,row){
								if(row.company_type_insert=="1"){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"goods_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
								}
								return ;
							}
							function formatRowButton3_B(val,row){
								if(row.company_type_insert=="1"){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"goods_direct\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
								}
								return ;
							}
							function formatRowButton4_B(val,row){
								if(row.company_type_insert=="1"){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"biz_history\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
								}
								return ;
							}
							function formatRowButton5_B(val,row){
								if(row.company_type_insert=="1"){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-save'\" type=\"file_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
								}
								return ;
							}
							function formatRowButton6_B(val,row){
								if(row.company_type_insert=="1"){
								   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"license_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
								}
								return ;
							}
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
							var editIndex2 = undefined;
							function endEditing2(){
								if (editIndex2 == undefined){return true}
								if ($('#bc2').datagrid('validateRow', editIndex2)){
							 		$('#bc2').datagrid('endEdit', editIndex2);
									editIndex2 = undefined;
									return true;
								} else {
									return false;
								}
							}
						
							function onDblClickCell2(index, field){
								if (editIndex2 != index){
									if (endEditing2()){
										if(field=="company_type_insert") {editIndex2= index; return};
										if(field=="company_type_insert2"){editIndex2 = index; return};
										if(field=="company_type_insert3"){editIndex2 = index; return};
										if(field=="company_type_insert4"){editIndex2 = index; return};
										if(field=="company_type_insert5"){editIndex2 = index; return};
										if(field=="company_type_insert6"){editIndex2 = index; return};
										$('#bc2').datagrid('selectRow', index)
												.datagrid('beginEdit', index);
										var selecter = $('#bc2').datagrid('getSelected');
										
										if(field=="business_no"){
											if(selecter.company_type_insert == "1"){
												var ed = $('#bc2').datagrid('getEditor', {index:index,field:'business_no'});
												if (ed){
													$(ed.target).textbox('readonly',true);
													return;
												}
											}
										}else{
											if(selecter.company_type_insert == "1"){
												var ed = $('#bc2').datagrid('getEditor', {index:index,field:'business_no'});
												if (ed){
													$(ed.target).textbox('readonly',true);
												}
											}
										}
										
										var ed = $('#bc2').datagrid('getEditor', {index:index,field:field});
										if (ed){
											($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
										}
										
										editIndex2 = index;
									} else {
										$('#bc2').datagrid('selectRow', editIndex2);
									}
								}
								eventBtn2();
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
							 function onBeforeEdit(index,row){
						  	   row.editing=true;
						  	   $(this).datagrid('refreshRow', index);
						     }				
							function delete_business(){
								if($("#s_business_no2").val()==""){
									$.messager.alert("알림", "삭제할 투찰사를 클릭해 주세요.");	
									return;
								}
								$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
							        if (r){			
							        	var effectRow = new Object();
							 			effectRow["business_no"] = $("#s_business_no2").val();		
										$.post("<c:url value='/enterprise/deleteBusiness.do'/>", effectRow, function(rsp) {
											if(rsp.status=="200"){
												$.messager.alert("알림", "삭제하였습니다.");					
												setGrid2();
											}
										}, "JSON").error(function() {
											$.messager.alert("알림", "저장에러！");
										});
							        }
								});
							}
							
							function save4(){
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
							    				$.post("<c:url value='/enterprise/updateBusinessList.do'/>", effectRow, function(rsp) {
							    					if(rsp.status){
							    						$.messager.alert("알림", "저장하였습니다.");
							    						$dg.datagrid('acceptChanges');
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
							
							function downloadExcelList(){
								//$("#s_business_no2").val("");
							   var param = 'gubun=A&s_company_no=' + $('#s_company_no2').val() + '&s_company_nm=' + $('#s_company_nm2').val();
							   param += '&s_area_cd=' + $('#s_area_cd3').combobox('getValue') + '&s_area_txt=' + $('#s_area_txt2').val();
							   param += '&s_company_type=' + $('#s_company_type2').val() + '&s_goods_type=' + $('#s_goods_type2').val();
							   param += '&s_goods_direct=' + $('#s_goods_direct2').val() + '&s_license_type=' + $('#s_license_type2').val();
							   param += '&s_join_approve_yn=Y';
	
							   location.href = "<c:url value='/enterprise/downloadExcelList.do'/>?" + param;
							}
						</script>
						</div>
						<div title="사용자목록" style="padding: 5px">
							<table style="width: 100%;">
								<tr>
									<td width="20%" align="right"><a href="javascript:void(0)"
										class="easyui-linkbutton" data-options="iconCls:'icon-add'"
										onclick="append()">추가</a> <a href="javascript:void(0)"
										class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
										onclick="delete_user()">삭제</a></td>
								</tr>
							</table>
							<div style="display: none;">
								<table class="easyui-datagrid"
									style="width: 0px; height: 0px; border: 0">
								</table>
							</div>
							<table id="dg" class="easyui-datagrid"
								style="width: 100%; height: 90%;"
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
										<th rowspan="2"
											data-options="field:'user_id',align:'left',halign:'center'"
											width="150">사용자 ID</th>
										<th rowspan="2"
											data-options="field:'user_nm',align:'left',halign:'center'"
											width="100">사용자명</th>
										<th rowspan="2"
											data-options="field:'team',align:'left',halign:'center'"
											width="80">팀명</th>
										<th rowspan="2"
											data-options="field:'role_nm',halign:'center',width:70">권한</th>
										<th rowspan="2"
											data-options="field:'position',align:'left',halign:'center'"
											width="60">직급</th>
										<th rowspan="2" data-options="field:'email',halign:'center'"
											width="200">이메일주소</th>
										<th rowspan="2"
											data-options="field:'tel',align:'left',halign:'center'"
											width="120">연락처</th>
										<th rowspan="2"
											data-options="field:'mobile',align:'left',halign:'center'"
											width="120">휴대폰</th>
										<th rowspan="2"
											data-options="field:'fax',align:'left',halign:'center'"
											width="120">팩스</th>
										<th colspan="2">메일계정정보</th>
										<th rowspan="2"
											data-options="field:'last_login',halign:'center'" width="150">최종로그인</th>
									</tr>
									<tr>
										<th
											data-options="field:'email_host',align:'left',halign:'center'"
											width="150">SMTP</th>
										<th
											data-options="field:'email_port',align:'left',halign:'center'"
											width="50">PORT</th>
									</tr>
								</thead>
							</table>
							<script>
					            var editIndex4 = undefined;
								function endEditing4(){
									if (editIndex4 == undefined){return true}
									if ($('#dg').datagrid('validateRow', editIndex4)){
								 		$('#dg').datagrid('endEdit', editIndex4);
										editIndex4 = undefined;
										return true;
									} else {
										return false;
									}
								}
								function append(){
									clearUser();
								}
								
								function pwd(){
									$('#pwdDlg').dialog('open');
								}
								
								function delete_user(){
							    	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
								        if (r){
								        	if (endEditing4()){
								    			var $dg = $("#dg");
	
							    				var effectRow = new Object();
												effectRow["user_id"] = $dg.datagrid('getSelected').user_id;
							    				$.post("<c:url value='/user/deleteUserList.do'/>", effectRow, function(rsp) {
							    					if(rsp.status){
							    						$.messager.alert("알림", "삭제하였습니다.");
							    						selectUserList();
							    					}
							    				}, "JSON").error(function() {
							    					$.messager.alert("알림", "삭제에러！");
							    				});
								    		}
								        }
							    	});
								}
								function save2(){
									
									if($("#user_id").textbox("getValue").length==0 || $("#pwd").textbox("getValue").length==0){
										$.messager.alert("알림", "사용자ID 및 PW를 입력해주세요.");
										return;
									}
									if($("#team").textbox("getValue").length==0){
										$.messager.alert("알림", "팀명을 입력해주세요.");
										return;
									}
									if($("#role_cd").combogrid("getValue").length==0){
										$.messager.alert("알림", "권한을 입력해주세요.");
										return;
									}
									if($("#email").textbox("getValue").length==0 || $("#email_pw").textbox("getValue").length==0 ||
									   $("#email_host").textbox("getValue").length==0 || $("#email_port").textbox("getValue").length==0 ){
										$.messager.alert("알림", "메일정보를 입력해주세요.");
										return;
									}
									
									if($("#tel").textbox("getValue").length==0 || $("#mobile").textbox("getValue").length==0 || $("#fax").textbox("getValue").length==0){
										$.messager.alert("알림", "전화번호 및 팩스를 입력해주세요.");
										return;
									}
									
									if($("#chkId").val()!="Y"){
										$.messager.alert("알림", "아이디를 확인해주세요.");
										return;
									}
									
							    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
								        if (r){
							    			var effectRow = new Object();
							    			effectRow["type"] = $("#type").val();
							    			effectRow["user_id"] = $("#user_id").textbox("getValue");
							    			effectRow["user_nm"] = $("#user_nm").textbox("getValue");
						    				effectRow["pwd"] = $("#pwd").textbox("getValue");
						    				effectRow["team"] = $("#team").textbox("getValue");
						    				effectRow["role_cd"] = $("#role_cd").combogrid("getValue");
						    				effectRow["tel"] = $("#tel").textbox("getValue");
						    				effectRow["mobile"] = $("#mobile").textbox("getValue");
						    				effectRow["fax"] = $("#fax").textbox("getValue");
						    				effectRow["position"] = $("#position").textbox("getValue");
						    				effectRow["email"] = $("#email").textbox("getValue");
						    				effectRow["email_pw"] = $("#email_pw").textbox("getValue");
						    				effectRow["email_host"] = $("#email_host").textbox("getValue");
						    				effectRow["email_port"] = $("#email_port").textbox("getValue");
						    				
						    				$.post("<c:url value='/user/updateUserList.do'/>", effectRow, function(rsp) {
						    					if(rsp.status=="200"){
						    						$.messager.alert("알림", "저장하였습니다.");
						    						 $("#dg").datagrid('reload');
						    						$('#userDlg').dialog('close');
						    					}else if(rsp.status=="100"){
						    						$.messager.alert("알림", "비밀번호가 일치하지 않습니다.");
						    					}else if(rsp.status=="101"){
						    						$.messager.alert("알림", "동일 권한 사용자가 존재합니다.");
						    					}
						    				}, "JSON").error(function() {
						    					$.messager.alert("알림", "저장에러！");
						    				});
								        }
							    	});
								}
								
								function chgId( newValue,oldValue ){
									if(oldValue!=newValue){
										$("#chkId").val("");
									}
								}
								
								function chkUserId(){
									if($("#user_id").textbox("getValue").length==0){
										$.messager.alert("알림", "아이디를 입력해주세요.");
										return;
									}
									
					    			var effectRow = new Object();
					    			
					    			effectRow["user_id"] = $("#user_id").textbox("getValue");
				    				
				    				$.post("<c:url value='/user/chkUserId.do'/>", effectRow, function(rsp) {
				    					if(rsp.status=="100"){
				    						$.messager.alert("알림", "사용하는 ID입니다.");
				    					}else if(rsp.status=="200"){
				    						$.messager.alert("알림", "사용가능합니다.");
				    						$("#chkId").val("Y");
				    					}
				    				}, "JSON").error(function() {
				    					$.messager.alert("알림", "저장에러！");
				    				});
								}
								
								function chgUserPwd(){
									if($("#oldPwd").textbox("getValue").length==0){
										$.messager.alert("알림", "이전 PW를 입력해주세요.");
										return;
									}
									if($("#newPwd").textbox("getValue").length==0){
										$.messager.alert("알림", "새로운 PW를 입력해주세요.");
										return;
									}
									if($("#rePwd").textbox("getValue").length==0){
										$.messager.alert("알림", "PW 확인을 입력해주세요.");
										return;
									}
									if($("#newPwd").textbox("getValue") != $("#rePwd").textbox("getValue")){
										$.messager.alert("알림", "재입력한 PW가 새로운 PW와 일치 하지 않습니다.");
										return;
									}
									
							    	$.messager.confirm('알림', '변경하시겠습니까?', function(r){
								        if (r){
							    			var effectRow = new Object();
							    			
							    			effectRow["oldPwd"] = $("#oldPwd").textbox("getValue");
						    				effectRow["newPwd"] = $("#newPwd").textbox("getValue");
						    				effectRow["rePwd"] = $("#rePwd").textbox("getValue");
						    				effectRow["user_id"] = $("#user_id").textbox("getValue");
						    				
						    				$.post("<c:url value='/user/chgUserPwd.do'/>", effectRow, function(rsp) {
						    					if(rsp.status=="100"){
						    						$.messager.alert("알림", "비밀번호가 일치 하지 않습니다.");
						    					}else if(rsp.status=="200"){
						    						$.messager.alert("알림", "변경하였습니다.");
						    						$('#pwdDlg').dialog('close');
						    					}
						    				}, "JSON").error(function() {
						    					$.messager.alert("알림", "저장에러！");
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
	<!-- 이력 Dialog start -->
	<div id="hisDlg" class="easyui-dialog" title="이력정보"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 50%; height: 600px; padding: 10px">
		<table id="hisTb" class="easyui-datagrid"
			style="width: 100%; height: 70%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  sortName:'noti_dt',
						  sortOrder:'desc'
						  ">
			<thead>
				<tr>
					<th
						data-options="field:'bid_notice_no',align:'left',width:150,halign:'center',sortable:true"
						formatter="formatNoticeNo">공고번호</th>
					<th
						data-options="field:'bid_notice_nm',align:'left',width:250,halign:'center',sortable:true">공고명</th>
					<th
						data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true"
						formatter="formatDate">공고일시</th>
					<th
						data-options="field:'quotation',align:'right',width:100,halign:'center',sortable:true"
						formatter="numberComma">견적금액</th>
					<th
						data-options="field:'review',align:'left',width:200,halign:'center',sortable:true">담당자
						견적의견</th>
				</tr>
			</thead>
		</table>
		<table style="width: 100%">
			<tr>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					onclick="addBizHis()">추가</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
					onclick="removeit3()">삭제</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-save'"
					onclick="saveBizHis()">저장</a></td>
			</tr>
		</table>
		<table id="bizHisTb" class="easyui-datagrid"
			style="width: 100%; height: 20%;"
			data-options="rownumbers:true,
						singleSelect:true,
						striped:true,
						onClickCell: onClickCell3
						  ">
			<thead>
				<tr>
					<th
						data-options="field:'bigo',align:'left',width:400,halign:'center',editor:'textbox'">의견</th>
					<th
						data-options="field:'user_nm',align:'left',width:100,halign:'center'">등록자</th>
					<th
						data-options="field:'create_dt',align:'left',width:100,halign:'center'"
						formatter="formatDate">등록일</th>
				</tr>
			</thead>
		</table>
		<script>
			function setBizHisGrid(){
				$("#bizHisTb").datagrid({
					method : "GET",
					   url: "<c:url value='/enterprise/selectBizNotiHisList.do'/>",
					queryParams : {
						business_no : $('#s_business_no').val(),
					}
				});
			}
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
								effectRow["business_no"] = $("#s_business_no").val();
			    				if (inserted.length) {
									effectRow["inserted"] = JSON.stringify(inserted);
								}
			    				if (deleted.length) {
			    					effectRow["deleted"] = JSON.stringify(deleted);
			    				}
			    				if (updated.length) {
			    					effectRow["updated"] = JSON.stringify(updated);
			    				}
			    				$.post("<c:url value='/enterprise/updateBizNotiHisList.do'/>", effectRow, function(rsp) {
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
	</div>
	<!-- 이력 Dialog end -->
	<!-- 이력 Dialog start -->
	<div id="bidDlg" class="easyui-dialog" title="견적보고서목록"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 70%; height: 400px; padding: 10px">
		<table id="bidTb" class="easyui-datagrid"
			style="width: 100%; height: 100%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  sortName:'noti_dt',
						  sortOrder:'desc'
						  ">
			<thead>
				<tr>
					<th
						data-options="field:'bid_notice_no',align:'left',width:150,halign:'center',sortable:true"
						formatter="formatNoticeNo">공고번호</th>
					<th
						data-options="field:'bid_notice_nm',align:'left',width:250,halign:'center',sortable:true">공고명</th>
					<th
						data-options="field:'demand_nm',align:'left',width:100,halign:'center',sortable:true"
						formatter="formatEnter">수요처</th>
					<th
						data-options="field:'detail_goods_nm',align:'left',width:100,halign:'center',sortable:true">물품명</th>
					<th
						data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true"
						formatter="formatDate">공고일시</th>
					<th
						data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true"
						formatter="formatDate">앱찰개시일시</th>
					<th
						data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true"
						formatter="formatDate">입찰마감일시</th>
					<th
						data-options="field:'company_type_insert',align:'center',halign:'center',max:10"
						width="70" formatter="formatRowButton5">상세</th>

				</tr>
			</thead>
		</table>
		<script>
			//견적보고서 입찰관련정보 
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
				
				$('#tab_bid_site').empty();
				$('#tab_bid_risk').empty();
				$('#tab_bid_term').empty();
				$('#tab_bid_cont').empty();
				$('#tab_bid_sp_cont').empty();
				$('#tab_bid_tot_cont').empty();
	
				$('#tab_info1_1').empty();
				$('#tab_info1_2').empty();
				$('#tab_info1_3').empty();
				$('#tab_info1_4').empty();
				$('#tab_info1_5').empty();
				$('#tab_info1_6').empty();
				$('#tab_info1_6t').empty();
				$('#tab_info1_7').empty();
				$('#tab_info1_1d').empty();
				$('#tab_info1_2d').empty();
				$('#tab_info1_3d').empty();
				$('#tab_info1_4d').empty();
				$('#tab_info1_5d').empty();
				$('#tab_info1_6d').empty();
				$('#tab_info2_1').empty();
				$('#tab_info2_2').empty();
				$('#tab_info2_3').empty();
				$('#tab_info2_4').empty();
				$('#tab_info2_5').empty();
				$('#tab_info2_5t').empty();
				$('#tab_info2_6').empty();
				$('#tab_info2_1d').empty();
				$('#tab_info2_2d').empty();
				$('#tab_info2_3d').empty();
				$('#tab_info2_4d').empty();
				$('#tab_info2_5d').empty();
				$('#tab_info3').empty();
			    setReportBidList('','');
			}
			//견적보고서 입찰관련정보 
			function setReportInfo(row){
				setReportInfoInit();
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
				
				
				selectBidApplyList(row);
				//입찰사용자등록정보
				getReportDtl(row.bid_notice_no,row.bid_notice_cha_no);
				
				//입찰 제조사 정보
				setReportBidList(row.bid_notice_no,row.bid_notice_cha_no);
			}
			function selectBidApplyList(row){
				$.ajax({ 
				    type: "GET"
				   ,url: "<c:url value='/distribution/bidApplyList.do'/>"
				   ,async: false
				   ,data : {
					   bid_notice_no : row.bid_notice_no,
						bid_notice_cha_no : row.bid_notice_cha_no
					}
				   ,dataType: "json"
				   ,success:function(json){
					   
					   if(json.rows!="0"){
						   $("#file_id").filebox("setValue","");
							$("#file_id").textbox("setValue",json.rows[0].file_nm);
							$('#file_link').unbind('click',null);
							
							$('#file_link').bind('click', function(){
								if($("#file_id").textbox("getText").length>0){
									location.href = "<c:url value='/file/download.do?file_id="+json.rows[0].file_id+"'/>";
								}else{
									$.messager.alert("알림", "파일이 존재하지 않습니다.");
									return;
								}
							});
							
							$("#apply_comment1").textbox("setValue","");
							$("#apply_comment2").textbox("setValue","");
							$("#apply_comment3").textbox("setValue","");
							$("#apply_comment1").textbox("setValue",json.rows[0].apply_comment1);
							$("#apply_comment2").textbox("setValue",json.rows[0].apply_comment2);
							$("#apply_comment3").textbox("setValue",json.rows[0].apply_comment3);
					   }
					   
					   
				   }
				});
			}
			
			//견적보고서  상세정보
			function getReportDtl(bidNoticeNo, bidNoticeChaNo){
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
							    $('#tab_column1').text(numberComma(json.rows[0].column1));
							    $('#tab_column2').text(json.rows[0].column2_nm);
								$('#tab_column3').text(json.rows[0].column3_nm);
								$("#apply_comment1").textbox("setValue",json.rows[0].column4);
							    $('#tab_column5').text(json.rows[0].column5);
						   }
						   
						   if(json.bidSubj !=null){
							    $('#tab_bid_site').text(json.bidSubj.bid_site_nm);
							    $('#tab_bid_risk').text(json.bidSubj.bid_risk_nm);
								$('#tab_bid_term').text(json.bidSubj.bid_term);
								$('#tab_bid_cont').text(json.bidSubj.bid_cont);
								$('#tab_bid_sp_cont').text(json.bidSubj.bid_sp_cont);
								$('#tab_bid_tot_cont').text(json.bidSubj.bid_tot_cont);
						   }

						   if(json.bidRisk !=null){
							    $('#tab_info1_1').text(json.bidRisk.info1_1=='C'?'해당사항없음':json.bidRisk.info1_1);
								$('#tab_info1_2').text(json.bidRisk.info1_2=='C'?'해당사항없음':json.bidRisk.info1_2);
								$('#tab_info1_3').text(json.bidRisk.info1_3=='C'?'해당사항없음':json.bidRisk.info1_3);
								$('#tab_info1_4').text(json.bidRisk.info1_4=='C'?'해당사항없음':json.bidRisk.info1_4);
								$('#tab_info1_5').text(json.bidRisk.info1_5=='C'?'해당사항없음':json.bidRisk.info1_5);
								$('#tab_info1_6').text(json.bidRisk.info1_6=='C'?'해당사항없음':json.bidRisk.info1_6);
								$('#tab_info1_6t').text(json.bidRisk.info1_6t);
								$('#tab_info1_7').text(json.bidRisk.info1_7);
								$('#tab_info1_1d').text(json.bidRisk.info1_1d);
								$('#tab_info1_2d').text(json.bidRisk.info1_2d);
								$('#tab_info1_3d').text(json.bidRisk.info1_3d);
								$('#tab_info1_4d').text(json.bidRisk.info1_4d);
								$('#tab_info1_5d').text(json.bidRisk.info1_5d);
								$('#tab_info1_6d').text(json.bidRisk.info1_6d);
								$('#tab_info2_1').text(json.bidRisk.info2_1=='C'?'해당사항없음':json.bidRisk.info2_1);
								$('#tab_info2_2').text(json.bidRisk.info2_2=='C'?'해당사항없음':json.bidRisk.info2_2);
								$('#tab_info2_3').text(json.bidRisk.info2_3=='C'?'해당사항없음':json.bidRisk.info2_3);
								$('#tab_info2_4').text(json.bidRisk.info2_4=='C'?'해당사항없음':json.bidRisk.info2_4);
								$('#tab_info2_5').text(json.bidRisk.info2_5=='C'?'해당사항없음':json.bidRisk.info2_5);
								$('#tab_info2_5t').text(json.bidRisk.info2_5t);
								$('#tab_info2_6').text(json.bidRisk.info2_6);
								$('#tab_info2_1d').text(json.bidRisk.info2_1d);
								$('#tab_info2_2d').text(json.bidRisk.info2_2d);
								$('#tab_info2_3d').text(json.bidRisk.info2_3d);
								$('#tab_info2_4d').text(json.bidRisk.info2_4d);
								$('#tab_info2_5d').text(json.bidRisk.info2_5d);
								$('#tab_info3').text(json.bidRisk.info3);
						   }
					   }
				});
			}
			
			//견적보고서 제조사 조회
			function setReportBidList(bidNoticeNo, bidNoticeChaNo){
				$("#bc3_1").datagrid({
					method : "GET",
					url : "<c:url value='/distribution/selectEstimateList.do'/>",
					queryParams : {
						bid_notice_no :bidNoticeNo,
						bid_notice_cha_no : bidNoticeChaNo,
					},
					onLoadSuccess : function(row, param) {

					}
				});
			}			
		</script>
	</div>
	<!-- 이력 Dialog end -->
	<!-- 견적보고서 Dialog start -->
	<div id="manufactureList" class="easyui-dialog" title="견적 보고서"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 900px; height: 800px; padding: 10px">


		<table cellpadding="5" style="width: 100%;">
			<tr>
				<td colspan="4"
					style="text-align: center; font-size: 20px; text-decoration: underline; height: 20px;">견적
					보고서</td>
			</tr>
			<tr>
				<td class="bc">공고번호/공고명</td>
				<td colspan="3"><font id="tab_bid_notice_no"></font> / <font
					id="tab_bid_notice_nm"></font></td>
			</tr>
			<tr>
				<td class="bc">공고기관</td>
				<td colspan="3"><font id="tab_bid_demand_nm"></font></td>
			</tr>
			<tr>
				<td class="bc" style="width: 20%">게시일시 /개찰일시</td>
				<td style="width: 30%"><font id="tab_noti_dt"></font> / <font
					id="tab_bid_open_dt"></font></td>
				<td class="bc" style="width: 20%">국제입찰/기업구분</td>
				<td style="width: 30%"><font id="tab_nation_bid_yn"></font> / <font
					id="tab_column3"></font></td>
			</tr>
			<tr>
				<td class="bc">입찰기간</td>
				<td><font id="tab_bid_start_dt"></font>~<font
					id="tab_bid_end_dt"></font></td>
				<td class="bc">조달사이트</td>
				<td><font id="tab_bid_site"></font></td>
			</tr>
			<tr>
				<td class="bc">계약방법</td>
				<td><font id="tab_bid_cont_demand"></font></td>
				<td class="bc">리스크</td>
				<td><font id="tab_bid_risk"></font></td>
			</tr>
			<tr>
				<td class="bc">적격정보</td>
				<td><font id="tab_column2"></font></td>
				<td class="bc">과업기간</td>
				<td><font id="tab_bid_term"></font></td>
			</tr>
			<tr>
				<td class="bc">추정가격/기초금액</td>
				<td><font id="tab_pre_price"></font> / <font
					id="tab_base_price"></font></td>
				<td class="bc">투찰기준금액(낙찰하한율)</td>
				<td><font id="tab_column1"></font>(<font id="tab_column5"></font>
					%)</td>
			</tr>
			<tr>
				<td class="bc">과업내용</td>
				<td colspan="3"><font id="tab_bid_cont"></font></td>
			</tr>
			<tr>
				<td class="bc">특이사항</td>
				<td colspan="3"><font id="tab_bid_sp_cont"></font></td>
			</tr>
			<tr>
				<td class="bc">심사총평</td>
				<td colspan="3"><font id="tab_bid_tot_cont"></font></td>
			</tr>
			<tr>
				<td class="bc">의견서 첨부파일</td>
				<td colspan="3"><input id="file_id" class="easyui-filebox"
					name="file"
					data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false"
					style="width: 450px; height: 24px;"> <a id="file_link"
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-save'">다운로드</a></td>
			</tr>
			<tr>
				<td class="bc">첨부문서(공고문)</td>
				<td colspan="3">
					<div id="div_notice_spec_form1">
						<a href="" id="tab_notice_spec_form1"></a>
					</div>
					<div id="div_notice_spec_form2">
						<br />
						<a href="" id="tab_notice_spec_form2"></a>
					</div>
					<div id="div_notice_spec_form3">
						<br />
						<a href="" id="tab_notice_spec_form3"></a>
					</div>
					<div id="div_notice_spec_form4">
						<br />
						<a href="" id="tab_notice_spec_form4"></a>
					</div>
					<div id="div_notice_spec_form5">
						<br />
						<a href="" id="tab_notice_spec_form5"></a>
					</div>
					<div id="div_notice_spec_form6">
						<br />
						<a href="" id="tab_notice_spec_form6"></a>
					</div>
					<div id="div_notice_spec_form7">
						<br />
						<a href="" id="tab_notice_spec_form7"></a>
					</div>
					<div id="div_notice_spec_form8">
						<br />
						<a href="" id="tab_notice_spec_form8"></a>
					</div>
					<div id="div_notice_spec_form9">
						<br />
						<a href="" id="tab_notice_spec_form9"></a>
					</div>
					<div id="div_notice_spec_form10">
						<br />
						<a href="" id="tab_notice_spec_form10"></a>
					</div>
				</td>
			</tr>
			<tr>
				<td class="bc">견적진행 및 승인</td>
				<td colspan="3">
					<table id="bc3_1" class="easyui-datagrid"
						data-options="singleSelect:false,pagination:false,
									  nowrap:false"
						style="width: 80%;">
						<thead>
							<tr>
								<th data-options="field:'company_nm',halign:'center'"
									width="20%">제조사</th>
								<th data-options="field:'margin',align:'right',halign:'center'"
									formatter="numberComma" width="20%">견적금액</th>
								<th data-options="field:'bigo',halign:'center'" width="30%">검토의견</th>
								<th data-options="field:'choice_reason',halign:'center'"
									width="30%">지급조건</th>
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
				<td style="text-align: cetner;"><input class="easyui-textbox"
					data-options="multiline:true,disabled:true" id="apply_comment1"
					value="" style="width: 270px; height: 100px"></td>
				<td style="text-align: cetner;"><input class="easyui-textbox"
					data-options="multiline:true,disabled:true" id="apply_comment2"
					value="" style="width: 270px; height: 100px"></td>
				<td style="text-align: cetner;"><input class="easyui-textbox"
					data-options="multiline:true,disabled:true" id="apply_comment3"
					value="" style="width: 270px; height: 100px"></td>
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
				<td class="bc" rowspan="7">규격<br />관련
				</td>
				<td class="cont">○ 수요처 담당자와 규격을 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info1_1"></font></td>
				<td class="cont"><font id="tab_info1_1d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 규격을 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info1_2"></font></td>
				<td class="cont"><font id="tab_info1_2d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 품질보증 관련 인증보유 및 시험성적 여부확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info1_3"></font></td>
				<td class="cont"><font id="tab_info1_3d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 특정 규격 및 특정 제조사 여부에 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info1_4"></font></td>
				<td class="cont"><font id="tab_info1_4d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 납품될 제품의 정품여부에 대하여 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info1_5"></font></td>
				<td class="cont"><font id="tab_info1_5d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ <font id="tab_info1_6t"></font></td>
				<td class="cont" style="text-align: center"><font
					id="tab_info1_6"></font></td>
				<td class="cont"><font id="tab_info1_6d"></font></td>
			</tr>
			<tr>
				<td class="cont" colspan="3">의견 : <font id="tab_info1_7"></font></td>
			</tr>
			<tr>
				<td class="bc" rowspan="6">납품<br />관련
				</td>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 납기의 적절성 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info2_1"></font></td>
				<td class="cont"><font id="tab_info2_1d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 납품장소의 적절성 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info2_2"></font></td>
				<td class="cont"><font id="tab_info2_2d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사분석 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info2_3"></font></td>
				<td class="cont"><font id="tab_info2_3d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 운송비용, 설치비용의 확인</td>
				<td class="cont" style="text-align: center"><font
					id="tab_info2_4"></font></td>
				<td class="cont"><font id="tab_info2_4d"></font></td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ <font id="tab_info2_5t"></font></td>
				<td class="cont" style="text-align: center"><font
					id="tab_info2_5"></font></td>
				<td class="cont"><font id="tab_info2_5d"></font></td>
			</tr>
			<tr>
				<td class="cont" colspan="3">의견 : <font id="tab_info2_6"></font></td>
			</tr>
			<tr>
				<td class="bc">기타리스크</td>
				<td class="cont" colspan="3"><font id="tab_info3"></font></td>
			</tr>
		</table>
	</div>
	<!-- 견적보고서 Dialog end -->
	<div id="userDlg" class="easyui-dialog" title="사용자 정보"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 35%; height: 300px;">
		<div class="easyui-layout"
			style="width: 100%; height: 100%; border: 0">
			<div data-options="region:'center'">
				<table style="width: 100%;">
					<tr>
						<td width="60%" align="right"><a href="javascript:void(0)"
							class="easyui-linkbutton" data-options="iconCls:'icon-save'"
							onclick="save2()">저장</a></td>
					</tr>
				</table>
				<input type="hidden" id="type" style="width: 100px"> <input
					type="hidden" id="chkId" style="width: 100px">
				<table style="width: 100%">
					<tr>
						<td class="bc" width="100px">사용자 ID</td>
						<td><input type="text" class="easyui-textbox" id="user_id"
							style="width: 150px" data-options="onChange:chgId" /> <a
							id="userIdBtn" href="javascript:void(0)"
							class="easyui-linkbutton" data-options="iconCls:'icon-search'"
							onClick="chkUserId()">확인</a></td>
						<td class="bc" width="100px">사용자명</td>
						<td><input type="text" class="easyui-textbox" id="user_nm"
							style="width: 150px" /></td>
					</tr>
					<tr>
						<td class="bc" width="100px">사용자 PW</td>
						<td colspan="3"><input type="password" class="easyui-textbox"
							id="pwd" style="width: 150px"> <a id="pwdBtn"
							href="javascript:void(0)" class="easyui-linkbutton"
							data-options="iconCls:'icon-reload'" onclick="pwd()">변경</a></td>
					</tr>
					<tr>
						<td class="bc">팀명</td>
						<td><input type="text" class="easyui-textbox" id="team"
							style="width: 150px"></td>
						<td class="bc">권한</td>
						<td><input id="role_cd" class="easyui-combobox"
							data-options="
										method:'get',
								        valueField: 'role_cd',
								        textField: 'role_nm',
								        width:150,
								        panelHeight:'auto',
								        data:jsonData2" />
						</td>
					</tr>
					<tr>
						<td class="bc">전화번호</td>
						<td><input type="text" class="easyui-textbox" id="tel"
							style="width: 150px"></td>
						<td class="bc">휴대폰번호</td>
						<td><input type="text" class="easyui-textbox" id="mobile"
							style="width: 150px"></td>
					</tr>
					<tr>
						<td class="bc">팩스</td>
						<td><input type="text" class="easyui-textbox" id="fax"
							style="width: 150px"></td>
						<td class="bc">직급</td>
						<td><input type="text" class="easyui-textbox" id="position"
							style="width: 150px"></td>
					</tr>
					<tr>
						<td class="bc">메일주소</td>
						<td><input type="text" class="easyui-textbox" id="email"
							style="width: 150px"></td>
						<td class="bc">메일계정PW</td>
						<td><input type="password" class="easyui-textbox"
							id="email_pw" style="width: 150px"></td>
					</tr>
					<tr>
						<td class="bc">메일계정서버</td>
						<td><input type="text" class="easyui-textbox" id="email_host"
							style="width: 150px" disabled="disabled"></td>
						<td class="bc">메일계정PORT</td>
						<td><input type="text" class="easyui-textbox" id="email_port"
							style="width: 150px" disabled="disabled"></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div id="pwdDlg" class="easyui-dialog" title="비밀번호 변경"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 15%; height: 180px;">
		<div class="easyui-layout"
			style="width: 100%; height: 100%; border: 0">
			<div data-options="region:'center'">
				<table style="width: 100%">
					<tr>
						<td class="bc" width="100px">이전 PW</td>
						<td><input type="text" class="easyui-textbox" id="oldPwd"></td>
					</tr>
					<tr>
						<td class="bc">새로운 PW</td>
						<td><input type="password" class="easyui-textbox" id="newPwd"></td>
					</tr>
					<tr>
						<td class="bc">재입력 PW</td>
						<td><input type="password" class="easyui-textbox" id="rePwd"></td>
					</tr>
				</table>
				<table style="width: 100%;">
					<tr>
						<td width="100%" align="center"><a href="javascript:void(0)"
							class="easyui-linkbutton" data-options="iconCls:'icon-save'"
							onclick="chgUserPwd()">변경</a></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- 업종등록 Dialog start -->
	<div id="companyTypeDlg" class="easyui-dialog" title="세부업종목록"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 700px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">업종명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_company_txt2" style="width: 150px;" value="">
				</td>
				<td class="bc">업종번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_company_txt3" style="width: 150px;" value="">
					<input type="hidden" id="business_no" name="business_no"
					style="width: 150px;" value=""></td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getCompanyTypeTotalList()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="companyTypeSave()">추가</a>
				</td>
			</tr>
		</table>
		<table id="companyTypeTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'parent_cd',align:'left',width:100,halign:'center'">업종그룹코드</th>
					<th
						data-options="field:'parent_nm',align:'left',width:100,halign:'center'">업종그룹명</th>
					<th
						data-options="field:'cd',align:'left',width:100,halign:'center'">업종코드</th>
					<th
						data-options="field:'cd_nm',align:'left',width:300,halign:'center'">업종명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 업종등록 Dialog end -->
	<!-- 물품등록 Dialog start -->
	<div id="goodsDlg" class="easyui-dialog" title="세부품명찾기"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">세부품명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_txt2" style="width: 150px;" value=""></td>
				<td class="bc">세부품명번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_txt3" style="width: 150px;" value=""> <input
					type="hidden" id="business_no" name="business_no"
					style="width: 150px;" value=""></td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getGoodsTypeTotalList()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="goodsTypeSave()">추가</a>
				</td>
			</tr>
		</table>
		<table id="goodsTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true">세부품명번호</th>
					<th
						data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true">세부품명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 물품등록 Dialog end -->
	<!-- 직생물품등록 Dialog start -->
	<div id="goodsDirectDlg" class="easyui-dialog" title="세부품명찾기"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">세부품명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_direct_txt2" style="width: 150px;" value="">
				</td>
				<td class="bc">세부품명번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_direct_txt3" style="width: 150px;" value="">
					<input type="hidden" id="business_no" name="business_no"
					style="width: 150px;" value=""></td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getGoodsDirectTotalList()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="goodsDirectSave()">추가</a>
				</td>
			</tr>
		</table>
		<table id="goodsDirectTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true">세부품명번호</th>
					<th
						data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true">세부품명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 직생물품등록 Dialog end -->
	<!-- 업종검색 Dialog start -->
	<div id="searchCompanyTypeDlg" class="easyui-dialog" title="세부업종찾기"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">업종명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_company_txt2_1" style="width: 150px;" value="">
				</td>
				<td class="bc">업종번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_company_txt3_1" style="width: 150px;" value="">
				</td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getCompanyTypeTotalSearchList()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="companyTypeChoice()">선택</a>
				</td>
			</tr>
		</table>
		<table id="searchCompanyTypeTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
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
					<th
						data-options="field:'parent_cd',align:'left',width:100,halign:'center'">업종그룹코드</th>
					<th
						data-options="field:'parent_nm',align:'left',width:100,halign:'center'">업종그룹명</th>
					<th
						data-options="field:'cd',align:'left',width:100,halign:'center'">업종코드</th>
					<th
						data-options="field:'cd_nm',align:'left',width:300,halign:'center'">업종명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 업종검색 Dialog end -->
	<!-- 적격정보검색 Dialog start -->
	<div id="searchLicenseTypeDlg" class="easyui-dialog" title="적격정보"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 500px; height: 450px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					onclick="licenseTypeChoice()">선택</a></td>
			</tr>
		</table>
		<table id="searchLicenseTypeTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
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
					<th
						data-options="field:'cd',align:'left',width:100,halign:'center'">적격정보코드</th>
					<th
						data-options="field:'cd_nm',align:'left',width:300,halign:'center'">적격정보명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 적격정보검색 Dialog end -->
	<!-- 물품검색 Dialog start -->
	<div id="searchGoodsDlg" class="easyui-dialog" title="세부품명찾기"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">세부품명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_txt2_1" style="width: 150px;" value="">
				</td>
				<td class="bc">세부품명번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_txt3_1" style="width: 150px;" value="">
					<input type="hidden" id="business_no" name="business_no"
					style="width: 150px;" value=""></td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getGoodsTypeTotalSearchList()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="goodsTypeChoice()">선택</a>
				</td>
			</tr>
		</table>
		<table id="searchGoodsTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
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
					<th
						data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true">세부품명번호</th>
					<th
						data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true">세부품명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 물품검색 Dialog end -->
	<!-- 투찰사 이력정보 Dialog start -->
	<div id="bizHistoryDlg" class="easyui-dialog" title="투찰사 의견이력"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 700px; height: 550px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					onclick="addBizHis2()">추가</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
					onclick="removeit4()">삭제</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-save'"
					onclick="saveBizHis2()">저장</a></td>
			</tr>
		</table>
		<table id="bizHisTb2" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						singleSelect:true,
						striped:true,
						onClickCell: onClickCell4
						  ">
			<thead>
				<tr>
					<th
						data-options="field:'bigo',align:'left',width:400,halign:'center',editor:'textbox'">의견</th>
					<th
						data-options="field:'user_nm',align:'left',width:100,halign:'center'">등록자</th>
					<th
						data-options="field:'create_dt',align:'left',width:100,halign:'center'"
						formatter="formatDate">등록일</th>
				</tr>
			</thead>
		</table>
	</div>
	<script>
		function setBizHisGrid2() {

			$("#bizHisTb2")
					.datagrid(
							{
								method : "GET",
								url : "<c:url value='/enterprise/selectBizNotiHisList.do'/>",
								queryParams : {
									business_no : $('#enterpriseTabs').tabs(
											'getSelected').panel('options').title == '업체등록대기_투찰사' ? $(
											"#s_business_no3").val()
											: $("#s_business_no2").val(),
								}
							});
		}

		var editIndex5 = undefined;
		function endEditing5() {
			if (editIndex5 == undefined) {
				return true
			}
			if ($('#bizHisTb2').datagrid('validateRow', editIndex5)) {
				$('#bizHisTb2').datagrid('endEdit', editIndex5);
				editIndex5 = undefined;
				return true;
			} else {
				return false;
			}
		}
		function onClickCell4(index, field) {
			if (editIndex5 != index) {
				if (endEditing5()) {
					$('#bizHisTb2').datagrid('selectRow', index).datagrid(
							'beginEdit', index);
					var selecter = $('#bizHisTb2').datagrid('getSelected');

					var ed = $('#bizHisTb2').datagrid('getEditor', {
						index : index,
						field : field
					});
					if (ed) {
						($(ed.target).data('textbox') ? $(ed.target).textbox(
								'textbox') : $(ed.target)).focus();
					}

					editIndex5 = index;
				} else {
					$('#bizHisTb2').datagrid('selectRow', editIndex5);
				}
			}
		}
		function addBizHis2() {
			if (endEditing5()) {
				$('#bizHisTb2').datagrid('appendRow', {
					status : 'P'
				});
				editIndex5 = $('#bizHisTb2').datagrid('getRows').length - 1;
				$('#bizHisTb2').datagrid('selectRow', editIndex5).datagrid(
						'beginEdit', editIndex5);
			}
		}

		function removeit4() {
			if (editIndex5 == undefined) {
				return
			}
			$('#bizHisTb2').datagrid('cancelEdit', editIndex5).datagrid(
					'deleteRow', editIndex5);
			editIndex5 = undefined;
		}

		function saveBizHis2() {
			$.messager
					.confirm(
							'알림',
							'저장하시겠습니까?',
							function(r) {
								if (r) {
									if (endEditing5()) {
										var $dg = $("#bizHisTb2");

										if ($dg.datagrid('getChanges').length) {
											var inserted = $dg.datagrid(
													'getChanges', "inserted");
											var deleted = $dg.datagrid(
													'getChanges', "deleted");
											var updated = $dg.datagrid(
													'getChanges', "updated");

											var effectRow = new Object();
											effectRow["business_no"] = $(
													'#enterpriseTabs').tabs(
													'getSelected').panel(
													'options').title == '업체등록대기_투찰사' ? $(
													"#s_business_no3").val()
													: $("#s_business_no2")
															.val();
											if (inserted.length) {
												effectRow["inserted"] = JSON
														.stringify(inserted);
											}
											if (deleted.length) {
												effectRow["deleted"] = JSON
														.stringify(deleted);
											}
											if (updated.length) {
												effectRow["updated"] = JSON
														.stringify(updated);
											}
											$
													.post(
															"<c:url value='/enterprise/updateBizNotiHisList.do'/>",
															effectRow,
															function(rsp) {
																if (rsp.status) {
																	$.messager
																			.alert(
																					"알림",
																					"저장하였습니다.");
																	$dg
																			.datagrid('acceptChanges');
																	setBizHisGrid2();
																}
															}, "JSON")
													.error(
															function() {
																$.messager
																		.alert(
																				"알림",
																				"저장에러！");
															});
										} else {
											$.messager.alert("알림",
													"변경된 데이터가 없습니다.");
										}
									}
								}
							});
		}
	</script>
	<!-- 투찰사 이력정보 Dialog end -->
	<!-- 투찰사 파일 Dialog start -->
	<div id="bizFileDlg" class="easyui-dialog" title="첨부파일"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 720px; height: 220px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-save'"
					onclick="saveFile()">저장</a></td>
			</tr>
		</table>
		<form id="uploadForm" enctype="multipart/form-data">
			<table style="width: 100%;">
				<tr>
					<td class="bc">파일1
					<td>
						<div style="width: 100%;">
							<input id="file_id1" class="easyui-filebox" name="file1"
								data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false"
								style="width: 450px; height: 24px;"> <a id="file_link1"
								href="javascript:void(0)" class="easyui-linkbutton"
								data-options="iconCls:'icon-save'">다운로드</a> <a
								id="file_remove1" href="javascript:void(0)"
								class="easyui-linkbutton" data-options="iconCls:'icon-remove'">삭제</a>
						</div>
					</td>
				</tr>
				<tr>
					<td class="bc">파일2
					<td>
						<div style="width: 100%;">
							<input id="file_id2" class="easyui-filebox" name="file2"
								data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false"
								style="width: 450px; height: 24px;"> <a id="file_link2"
								href="javascript:void(0)" class="easyui-linkbutton"
								data-options="iconCls:'icon-save'">다운로드</a> <a
								id="file_remove2" href="javascript:void(0)"
								class="easyui-linkbutton" data-options="iconCls:'icon-remove'">삭제</a>
						</div>
					</td>
				</tr>
				<tr>
					<td class="bc">파일3
					<td>
						<div style="width: 100%;">
							<input id="file_id3" class="easyui-filebox" name="file3"
								data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false"
								style="width: 450px; height: 24px;"> <a id="file_link3"
								href="javascript:void(0)" class="easyui-linkbutton"
								data-options="iconCls:'icon-save'">다운로드</a> <a
								id="file_remove3" href="javascript:void(0)"
								class="easyui-linkbutton" data-options="iconCls:'icon-remove'">삭제</a>
						</div>
					</td>
				</tr>
				<tr>
					<td class="bc">파일4
					<td>
						<div style="width: 100%;">
							<input id="file_id4" class="easyui-filebox" name="file4"
								data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false"
								style="width: 450px; height: 24px;"> <a id="file_link4"
								href="javascript:void(0)" class="easyui-linkbutton"
								data-options="iconCls:'icon-save'">다운로드</a> <a
								id="file_remove4" href="javascript:void(0)"
								class="easyui-linkbutton" data-options="iconCls:'icon-remove'">삭제</a>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<script>
		function saveFile() {

			$.messager
					.confirm(
							'알림',
							'저장하시겠습니까?',
							function(r) {
								if (r) {
									var form = new FormData(document
											.getElementById('uploadForm'));

									form
											.append(
													"business_no",
													$('#enterpriseTabs').tabs(
															'getSelected')
															.panel('options').title == '업체등록대기_투찰사' ? $(
															"#s_business_no3")
															.val()
															: $(
																	"#s_business_no2")
																	.val());
									form.append("file_id1",
											encodeURIComponent($(
													"#bizFileDlg #file_id1")
													.filebox("getText")));
									form.append("file_id2",
											encodeURIComponent($(
													"#bizFileDlg #file_id2")
													.filebox("getText")));
									form.append("file_id3",
											encodeURIComponent($(
													"#bizFileDlg #file_id3")
													.filebox("getText")));
									form.append("file_id4",
											encodeURIComponent($(
													"#bizFileDlg #file_id4")
													.filebox("getText")));

									$
											.ajax({
												url : "<c:url value='/enterprise/updateCompanyFileList.do'/>",
												data : form,
												dataType : 'text',
												processData : false,
												contentType : false,
												type : 'POST',
												success : function(rsp) {
													$.messager.alert("알림",
															"저장하였습니다.");
													$('#enterpriseTabs').tabs(
															'getSelected')
															.panel('options').title == '업체등록대기_투찰사' ? $(
															"#bc4").datagrid(
															'reload')
															: $("#bc2")
																	.datagrid(
																			'reload');
													$('#bizFileDlg').dialog(
															'close');

												},
												error : function(jqXHR) {
													console.log('error');
												}
											});

								}
							});
		}
	</script>
	<!-- 적격정보등록 Dialog start -->
	<div id="bizLicenseDlg" class="easyui-dialog" title="적격정보목록"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 500px; height: 450px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					onclick="addLicense()">추가</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
					onclick="removeLicense()">삭제</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-save'"
					onclick="updateLicenseLimitDt()">저장</a></td>
			</tr>
		</table>
		<table id="bizLicenseTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>
					<th data-options="field:'license_cd',checkbox:true"></th>
					<th
						data-options="field:'cd_nm',align:'left',width:300,halign:'center'">적격정보명</th>
					<th
						data-options="field:'limit_dt',align:'center',width:100,halign:'center',sortable:true,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler">만료일자</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 적격정보등록 Dialog end -->
	<!-- 적격정보등록 Dialog start -->
	<div id="bizLicenseDlg2" class="easyui-dialog" title="적격정보목록"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 400px; height: 450px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td align="right">
					<!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getLicenseTotalList()" >조회</a> -->
					<a href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="licenseSave()">등록</a>
				</td>
			</tr>
		</table>
		<table id="bizLicenseTb2" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>
					<th data-options="field:'cd',checkbox:true"></th>
					<th
						data-options="field:'cd_nm',align:'left',width:300,halign:'center'">적격정보명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 업종등록 Dialog end -->
	<!-- 업종등록 Dialog start -->
	<div id="bizCompanyTypeDlg" class="easyui-dialog" title="등록업종"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">업종번호 및 업종명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_company_txt" style="width: 150px;" value=""></td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getCompanyTypeList()">조회</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					onclick="addCompanyType()">추가</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
					onclick="removeCompanyType()">삭제</a></td>
			</tr>
		</table>
		<table id="bizCompanyTypeTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'parent_cd',align:'left',width:100,halign:'center'">업종그룹코드</th>
					<th
						data-options="field:'parent_nm',align:'left',width:100,halign:'center'">업종그룹명</th>
					<th
						data-options="field:'cd',align:'left',width:100,halign:'center'">업종코드</th>
					<th
						data-options="field:'cd_nm',align:'left',width:300,halign:'center'">업종명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 업종등록 Dialog end -->
	<!-- 업종등록 Dialog start -->
	<div id="companyTypeDlg2" class="easyui-dialog" title="세부업종목록"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">업종명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_company_txt22" style="width: 150px;" value="">
				</td>
				<td class="bc">업종번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_company_txt32" style="width: 150px;" value="">
				</td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getCompanyTypeTotalList2()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="companyTypeSave2()">등록</a>
				</td>
			</tr>
		</table>
		<table id="companyTypeTb2" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'parent_cd',align:'left',width:100,halign:'center'">업종그룹코드</th>
					<th
						data-options="field:'parent_nm',align:'left',width:100,halign:'center'">업종그룹명</th>
					<th
						data-options="field:'cd',align:'left',width:100,halign:'center'">업종코드</th>
					<th
						data-options="field:'cd_nm',align:'left',width:300,halign:'center'">업종명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 업종등록 Dialog end -->
	<!-- 물품등록 Dialog start -->
	<div id="bizGoodsDlg" class="easyui-dialog" title="제조물품"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">물품번호 및 품명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_txt" style="width: 150px;" value=""></td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getGoodsTypeList()">조회</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					onclick="addGoodsType()">추가</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
					onclick="removeGoodsType()">삭제</a></td>
			</tr>
		</table>
		<table id="bizGoodsTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true">세부품명번호</th>
					<th
						data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true">세부품명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 물품등록 Dialog end -->
	<!-- 물품등록 Dialog start -->
	<div id="goodsDlg2" class="easyui-dialog" title="세부품명찾기"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">세부품명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_txt22" style="width: 150px;" value=""></td>
				<td class="bc">세부품명번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_txt32" style="width: 150px;" value=""></td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getGoodsTypeTotalList2()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="goodsTypeSave2()">등록</a>
				</td>
			</tr>
		</table>
		<table id="goodsTb2" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true">세부품명번호</th>
					<th
						data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true">세부품명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 물품등록 Dialog end -->
	<!-- 직생물품등록 Dialog start -->
	<div id="bizGoodsDirectDlg" class="easyui-dialog" title="직접생산물품"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">물품번호 및 품명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_direct_txt" style="width: 150px;" value="">
				</td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getGoodsDirectList()">조회</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					onclick="addGoodsDirect()">추가</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
					onclick="removeGoodsDirect()">삭제</a> <a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-save'"
					onclick="updateGoodsDirectLimitDt()">저장</a></td>
			</tr>
		</table>
		<table id="bizGoodsDirectTb" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="iconCls:'icon-edit',
						  rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true">세부품명번호</th>
					<th
						data-options="field:'goods_nm',align:'left',width:300,halign:'center',sortable:true">세부품명</th>
					<th
						data-options="field:'limit_dt',align:'center',width:100,halign:'center',sortable:true,editor:{type:'datebox',options:{formatter:myformatter,parser:myparser}},styler:cellStyler">만료일자</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 직생물품등록 Dialog end -->
	<!-- 직생물품등록 Dialog start -->
	<div id="goodsDirectDlg2" class="easyui-dialog" title="세부품명찾기"
		data-options="iconCls:'icon-save',modal:true,closed:true"
		style="width: 600px; height: 600px; padding: 10px">
		<table style="width: 100%">
			<tr>
				<td class="bc">세부품명</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_direct_txt22" style="width: 150px;" value="">
				</td>
				<td class="bc">세부품명번호</td>
				<td><input type="text" class="easyui-textbox"
					id="search_goods_direct_txt32" style="width: 150px;" value="">
				</td>
				<td align="right"><a href="javascript:void(0)"
					class="easyui-linkbutton" data-options="iconCls:'icon-search'"
					onclick="getGoodsDirectTotalList2()">조회</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					data-options="iconCls:'icon-add'" onclick="goodsDirectSave2()">등록</a>
				</td>
			</tr>
		</table>
		<table id="goodsDirectTb2" class="easyui-datagrid"
			style="width: 100%; height: 90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false,
						  pagination:true,
						  pageSize:20
						  ">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true"></th>
					<th
						data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true">세부품명번호</th>
					<th
						data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true">세부품명</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 직생물품등록 Dialog end -->
</body>
</html>