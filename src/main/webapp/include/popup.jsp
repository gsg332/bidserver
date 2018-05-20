<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <script>
$(document).ready(function() {
	keydownEvent1();
});

function keydownEvent1(){
	
	var t = $('#search_goods_txt');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsTypeList();
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
	
	t = $('#search_goods_direct_txt');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   getGoodsDirectList();
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
}


function getCompanyTypeList(){
	
	$("#bizCompanyTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/companyTypeList.do'/>",
		queryParams : {
			business_no : $("#business_no").val(),
			searchTxt : $("#search_company_txt").textbox("getValue")
		},
		onLoadSuccess : function(row, param) {
			
			$('#bizCompanyTypeDlg').dialog('open');
		}
	});
	
}

function getCompanyTypeTotalList(){
	
	$("#companyTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/companyTypeTotalList.do'/>",
		queryParams : {
			business_no : $("#business_no").val(),
			searchTxt2 : $("#search_company_txt2").textbox("getValue"),
			searchTxt3 : $("#search_company_txt3").textbox("getValue")
		}
	});
	
}



function companyTypeSave(){
	var $dg = $("#companyTypeTb");
		
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
					effectRow["business_no"] = $("#business_no").val();
					effectRow["selecter"] = JSON.stringify(row);

					$.post("<c:url value='/manufacture/updateBizCompanyTypeList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						$("#companyTypeDlg").dialog('close');
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


function addCompanyType(){
	$('#companyTypeDlg').dialog('open');
}

function removeCompanyType(){
		var $dg = $("#bizCompanyTb");
			
		var row = $dg.datagrid('getSelections');
		
		if (row.length == 0){
			$.messager.alert("알림", "삭제할 내용을 선택해주세요.");
			return;
		}
	
	$.messager.confirm('알림', '삭제하시겠습니까?', function(r){
        if (r){
        	if (endEditing()){
    			if (row.length) {
    				var effectRow = new Object();
					effectRow["business_no"] = $("#business_no").val();
					effectRow["selecter"] = JSON.stringify(row);
    				
					$.post("<c:url value='/manufacture/removeBizCompanyTypeList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						getCompanyTypeList();
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "삭제에러！");
    				});
    			 }
    		}
        }
	});
}


function getGoodsTypeList(){
	
	$("#bizGoodsTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/goodsTypeList.do'/>",
		queryParams : {
			business_no : $("#business_no").val(),
			searchTxt : $("#search_goods_txt").textbox("getValue")
		},
		onLoadSuccess : function(row, param) {
			
			$('#bizGoodsDlg').dialog('open');
		}
	});
	
}

function getGoodsTypeTotalList(){
	
	$("#goodsTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/goodsTypeTotalList.do'/>",
		queryParams : {
			business_no : $("#business_no").val(),
			searchTxt2 : $("#search_goods_txt2").textbox("getValue"),
			searchTxt3 : $("#search_goods_txt3").textbox("getValue")
		}
	});
	
}

function goodsTypeSave(){
	var $dg = $("#goodsTb");
		
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
					effectRow["business_no"] = $("#business_no").val();
					effectRow["selecter"] = JSON.stringify(row);

					$.post("<c:url value='/manufacture/updateBizGoodsTypeList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						$("#goodsDlg").dialog('close');
    						getGoodsTypeList();
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "등록에러！");
    				});
    			 }
    		}
        }
	});
}


function getGoodsTypeList2(){
	
	$("#bizGoodsTb2").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/goodsTypeList2.do'/>",
		queryParams : {
			business_no : $("#business_no").val(),
			searchTxt : $("#search_goods_txt2").textbox("getValue")
		},
		onLoadSuccess : function(row, param) {
			
			$('#bizGoodsDlg2').dialog('open');
		}
	});
	
}


function addGoodsType(){
	$('#goodsDlg').dialog('open');
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
        	if (endEditing()){
    			if (row.length) {
    				var effectRow = new Object();
					effectRow["business_no"] = $("#business_no").val();
					effectRow["selecter"] = JSON.stringify(row);
    				
					$.post("<c:url value='/manufacture/removeBizGoodsTypeList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						getGoodsTypeList();
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "삭제에러！");
    				});
    			 }
    		}
        }
	});
}

function getGoodsDirectList(){
	
	$("#bizGoodsDirectTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/goodsDirectList.do'/>",
		queryParams : {
			business_no : $("#business_no").val(),
			searchTxt : $("#search_goods_direct_txt").textbox("getValue")
		},
		onLoadSuccess : function(row, param) {
			
			$('#bizGoodsDirectDlg').dialog('open');
		}
	});
	
}

function getGoodsDirectTotalList(){
	
	$("#goodsDirectTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/goodsDirectTotalList.do'/>",
		queryParams : {
			business_no : $("#business_no").val(),
			searchTxt2 : $("#search_goods_direct_txt2").textbox("getValue"),
			searchTxt3 : $("#search_goods_direct_txt3").textbox("getValue")
		}
	});
	
}

function goodsDirectSave(){
	var $dg = $("#goodsDirectTb");
		
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
					effectRow["business_no"] = $("#business_no").val();
					effectRow["selecter"] = JSON.stringify(row);

					$.post("<c:url value='/manufacture/updateBizGoodsDirectList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						$("#goodsDirectDlg").dialog('close');
    						getGoodsDirectList();
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "등록에러！");
    				});
    			 }
    		}
        }
	});
}


function addGoodsDirect(){
	$('#goodsDirectDlg').dialog('open');
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
        	if (endEditing()){
    			if (row.length) {
    				var effectRow = new Object();
					effectRow["business_no"] = $("#business_no").val();
					effectRow["selecter"] = JSON.stringify(row);
    				
					$.post("<c:url value='/manufacture/removeBizGoodsDirectList.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						getGoodsDirectList();
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "삭제에러！");
    				});
    			 }
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
		searchIdName.textbox('setValue',"");
		searchNmName.textbox('setValue',"");
	}
	
}

function companyTypeChoice(){
	var row = $("#searchCompanyTypeTb").datagrid('getSelected');
	
	searchIdName.textbox('setValue',row.cd);
	searchNmName.textbox('setValue',row.cd_nm);
	
	$('#searchCompanyTypeDlg').dialog('close');
}


function getCompanyTypeTotalSearchList(){
	
	$("#searchCompanyTypeTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/companyTypeTotalList.do'/>",
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

function searchGoodsType(cd, cd_nm, type){
	searchIdName = $("#"+cd);
	searchNmName = $("#"+cd_nm);

	$("#search_goods_txt2_1").textbox("setValue","");
	$("#search_goods_txt3_1").textbox("setValue","");
	
	if(type=='s'){
		getGoodsTypeTotalSearchList();
	}else if(type=='c'){
		searchIdName.textbox('setValue',"");
		searchNmName.textbox('setValue',"");
	}
	
}

function goodsTypeChoice(){
	var row = $("#searchGoodsTb").datagrid('getSelected');
	
	searchIdName.textbox('setValue',row.goods_no);
	searchNmName.textbox('setValue',row.goods_nm);
	
	$('#searchGoodsDlg').dialog('close');
}


function getGoodsTypeTotalSearchList(){
	
	$("#searchGoodsTb").datagrid({
		method : "GET",
		url : "<c:url value='/manufacture/goodsTypeTotalList.do'/>",
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

</script>
    <!-- 업종등록 Dialog start -->
	<div id="bizCompanyTypeDlg" class="easyui-dialog" title="등록업종" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">업종번호 및 업종명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_company_txt" style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getCompanyTypeList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addCompanyType()" >추가</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeCompanyType()" >삭제</a>
		            </td>
		        </tr>
		</table>
    	<table id="bizCompanyTypeTb" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
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
    <!-- 업종등록 Dialog end -->
	<!-- 업종등록 Dialog start -->
	<div id="companyTypeDlg" class="easyui-dialog" title="세부업종목록" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">업종명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_company_txt2"  style="width:150px;" value=""  >
		            </td>
		        	<td class="bc">업종번호</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_company_txt3"  style="width:150px;" value=""  >
		            	<input type="hidden" id="business_no" name="business_no"   style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getCompanyTypeTotalList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="companyTypeSave()" >등록</a>
		            </td>
		        </tr>
		</table>
    	<table id="companyTypeTb" class="easyui-datagrid" style="width:100%;height:90%;"
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
					<th data-options="field:'parent_cd',align:'left',width:100,halign:'center'" >업종그룹코드</th>
					<th data-options="field:'parent_nm',align:'left',width:100,halign:'center'" >업종그룹명</th>
					<th data-options="field:'cd',align:'left',width:100,halign:'center'" >업종코드</th>
					<th data-options="field:'cd_nm',align:'left',width:300,halign:'center'" >업종명</th>
				</tr>
			</thead>
		</table>
    </div>
    <!-- 업종등록 Dialog end -->
    
    
    <!-- 업종등록 Dialog start -->
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
    <!-- 업종등록 Dialog end -->
    
    
	<!-- 물품등록 Dialog start -->
	<div id="bizGoodsDlg" class="easyui-dialog" title="제조물품" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">물품번호 및 품명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_txt" style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getGoodsTypeList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addGoodsType()" >추가</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeGoodsType()" >삭제</a>
		            </td>
		        </tr>
		</table>
    	<table id="bizGoodsTb" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
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
    <!-- 물품등록 Dialog end -->
	<!-- 물품등록 Dialog start -->
	<div id="goodsDlg" class="easyui-dialog" title="세부품명찾기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
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
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getGoodsTypeTotalList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="goodsTypeSave()" >등록</a>
		            </td>
		        </tr>
		</table>
    	<table id="goodsTb" class="easyui-datagrid" style="width:100%;height:90%;"
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
					<th data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true" >세부품명번호</th>
					<th data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true" >세부품명</th>
				</tr>
			</thead>
		</table>
    </div>
    <!-- 물품등록 Dialog end -->	
    
    <!-- 물품등록 Dialog start -->
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
    <!-- 물품등록 Dialog end -->
    
    
    <!-- 직생물품등록 Dialog start -->
	<div id="bizGoodsDirectDlg" class="easyui-dialog" title="직접생산물품" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">물품번호 및 품명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_direct_txt" style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getGoodsDirectList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addGoodsDirect()" >추가</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeGoodsDirect()" >삭제</a>
		            </td>
		        </tr>
		</table>
    	<table id="bizGoodsDirectTb" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
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
    <!-- 직생물품등록 Dialog end -->
	<!-- 직생물품등록 Dialog start -->
	<div id="goodsDirectDlg" class="easyui-dialog" title="세부품명찾기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">세부품명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_direct_txt2"  style="width:150px;" value=""  >
		            </td>
		        	<td class="bc">세부품명번호</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_direct_txt3"  style="width:150px;" value=""  >
		            	<input type="hidden" id="business_no" name="business_no"   style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getGoodsDirectTotalList()" >조회</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="goodsDirectSave()" >등록</a>
		            </td>
		        </tr>
		</table>
    	<table id="goodsDirectTb" class="easyui-datagrid" style="width:100%;height:90%;"
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
					<th data-options="field:'goods_no',align:'left',width:100,halign:'center',sortable:true" >세부품명번호</th>
					<th data-options="field:'goods_nm',align:'left',width:400,halign:'center',sortable:true" >세부품명</th>
				</tr>
			</thead>
		</table>
    </div>
    <!-- 직생물품등록 Dialog end -->	
    
    
    <!-- 공공구매등록물품 Dialog start -->
	<div id="bizGoodsDlg2" class="easyui-dialog" title="제조물품" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:600px;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">물품번호 및 품명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_txt4" style="width:150px;" value=""  >
		            </td>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getGoodsTypeList2()" >조회</a>
		            </td>
		        </tr>
		</table>
    	<table id="bizGoodsTb2" class="easyui-datagrid" style="width:100%;height:90%;"
			data-options="rownumbers:true,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
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
    <!-- 공공구매등록물품 Dialog end -->	
    
   