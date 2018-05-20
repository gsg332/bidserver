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
	 keydownEvent();
	 setGrid();
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

	t = $('#search_goods_txt');
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

}

function setGrid(){
	$("#bc").datagrid({
		method : "GET",
		   url: "<c:url value='/business/businessList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no').val(),
			s_company_nm : $('#s_company_nm').val()
		},
		onLoadSuccess:function(){
			$('#bc').datagrid('selectRow', 0);
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
				 	<div title="투찰사정보" style="padding:5px">
					<input type="hidden" id="addData" name="addData" value="" />
		 			<table style="width:100%;">
				        <tr>
				        	<td width="40%"  align="left">
				        		<table style="width:100%;">
							        <tr>
							            <td class="bc">사업자번호</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_no" name="s_company_no"   style="width:200px;"   >
							            </td>
							            <td class="bc">업체명</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_nm" name="s_company_nm"   style="width:200px;"   >
							            </td>
		<!-- 				            <td class="bc">업종</td> -->
		<!-- 				            <td> -->
		<!-- 				                <input type="text" class="easyui-textbox"  id="s_company_type" name="s_company_type"   style="width:100px;"   > -->
		<!-- 				                <input type="text" class="easyui-textbox"  id="s_company_type_nm" name="s_company_type_nm"   style="width:100px;"  disabled="disabled"  > -->
		<!-- 				                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="" ></a> -->
		<!-- 				            </td> -->
		<!-- 				            <td class="bc">물품</td> -->
		<!-- 				            <td> -->
		<!-- 				                <input type="text" class="easyui-textbox"  id="s_goods_type" name="s_goods_type"   style="width:100px;"   > -->
		<!-- 				                <input type="text" class="easyui-textbox"  id="s_goods_type_nm" name="s_goods_type_nm"   style="width:100px;"  disabled="disabled" > -->
		<!-- 				                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="" ></a> -->
		<!-- 				            </td> -->
							        </tr>
							    </table>
				        	</td>
				            
				            <td width="60%" align="right">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a>
				            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append()">추가</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit()">삭제</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a>
				            </td>
				        </tr>
				    </table>
					<table id="bc" class="easyui-datagrid"
							style="width:100%;height:600px;" 
							
							data-options="iconCls: 'icon-edit',
										rownumbers:true,
										singleSelect:true,
										striped:true,
										pagination:true,
										onClickCell: onClickCell, onEndEdit: onEndEdit"						
							>
						<thead>
							<tr>
								<th data-options="field:'business_no',halign:'center'" width="120">업체번호</th>
						 		<th data-options="field:'company_no',halign:'center',editor:'textbox'" width="150">사업자번호</th>
						 		<th data-options="field:'company_nm',halign:'center',editor:'textbox'" width="150">업체명</th>
								<th data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"  width="80">대표자명</th>
								<th data-options="field:'zip_no',align:'center',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['number','length[5,5]'],invalidMessage:'우편번호를 5자리로 입력하세요'}}" width="60">우편번호</th>
								<th data-options="field:'address',halign:'center',editor:'textbox',max:100" width="250">기본주소</th>
								<th data-options="field:'address_detail',halign:'center',editor:'textbox',max:100" width="100">상세주소</th>
								<th data-options="field:'department',halign:'center',editor:'textbox',max:20" width="100">담당부서</th>
								<th data-options="field:'position',halign:'center',editor:'textbox',max:20" width="100">직위</th>
								<th data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox',max:10" width="80">담당자명</th>
								<th data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',max:11"  width="100">전화</th>
								<th data-options="field:'mobile_no',align:'center',halign:'center',editor:'textbox',max:11" width="100">휴대폰</th>
								<th data-options="field:'fax_no',align:'center',halign:'center',editor:'textbox',max:11"  width="100">fax</th>
								<th data-options="field:'email',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['email','length[0,30]'],invalidMessage:'알맞은 이메일 형식을 사용하세요(0~30자내)'}}"  width="200">이메일</th>
							</tr>
						</thead>
					</table>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 업종등록 Dialog start -->
	<div id="companyTypeDlg" class="easyui-dialog" title="대표업종" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:400px;height:80%;padding:10px">
    	<table style="width:100%">
		        <tr>
		              <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="companyTypeSave()" >저장</a>
		            </td>
		        </tr>
		</table>
    	<table id="companyTb" class="easyui-datagrid" style="width:100%;height:95%;"
			data-options="rownumbers:false,
						  singleSelect:false,
						  method:'get',
						  striped:true,
						  nowrap:false
						  ">
			<thead>
				<tr>
	            	<th data-options="field:'ck',checkbox:true"></th>
					<th data-options="field:'cd',align:'left',width:100,halign:'center',sortable:true" >업종코드</th>
					<th data-options="field:'cd_nm',align:'left',width:200,halign:'center',sortable:true" >업종명</th>
				</tr>
			</thead>
		</table>
    </div>
    <!-- 업종등록 Dialog end -->
	<!-- 물품등록 Dialog start -->
	<div id="bizGoodsDlg" class="easyui-dialog" title="취급물품" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:70%;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">물품번호 및 품명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_txt" name="search_goods_txt"   style="width:150px;" value=""  >
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
	<div id="goodsDlg" class="easyui-dialog" title="세부품명찾기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:600px;height:80%;padding:10px">
    	<table style="width:100%">
		        <tr>
		        	<td class="bc">세부품명</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_txt2" name="search_goods_txt2"   style="width:150px;" value=""  >
		            </td>
		        	<td class="bc">세부품명번호</td>
		            <td>
		            	<input type="text" class="easyui-textbox"  id="search_goods_txt3" name="search_goods_txt3"   style="width:150px;" value=""  >
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

	function onClickCell(index, field){
		if(field=="company_type_insert") {editIndex = index; return};
		if(field=="company_type_insert2"){editIndex = index; return};
		if (editIndex != index){
			if (endEditing()){
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
</body>
</html>