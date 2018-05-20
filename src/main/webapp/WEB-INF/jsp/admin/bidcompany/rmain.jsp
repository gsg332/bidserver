<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>투찰사관리</title>

</head>
<link rel="stylesheet" type="text/css" href="<c:url value='/images/demo.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/sub.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/jquery/themes/default/easyui.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/jquery/themes/icon.css'/>">
<script type="text/javascript" src="<c:url value='/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/jquery/jquery.easyui.min.js'/>"></script>
<script type="text/javascript" src='<c:url value='/jquery/jquery.form.js'/>' ></script>
<script type="text/javascript" src='<c:url value='/jquery/jquery.json-2.3.min.js'/>' ></script>
 <%@ include file="/include/session.jsp" %>
	
<script>
$(document).ready(function() {
	 setGrid();
  
});


function setGrid(){
	
	$("#bc").datagrid({
		   method: "GET",
		   url: "./bidCompanyList.do?GUBUN=<%=request.getParameter("GUBUN")%>",
		   queryParams: {
				idnum: "3",
				pagenum: "2"
		   },
// 		   onDblClickRow: function(rowIndex, rowData){
// 			   writeDetail(rowData.PUBLICID);
// 		   },
		   onLoadSuccess: function(row, param) {
			   
		   }
	 });
}

function formatDate(val){
	
	var dt;
	    dt = new Date();
    dt = dt.getFullYear()+""+((dt.getMonth() + 1)<9?"0"+(dt.getMonth() + 1):(dt.getMonth() + 1))+""+dt.getDate();
	
    if(val!=null){
	    var valdt = val.substring(0,val.length);
	    
    	val = valdt;
        if (eval(dt)-eval(valdt) == 0){
        	
        	val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8)+" "+val.substring(8,10)+":"+val.substring(10,12);
        	
            return '<span style="color:red;">'+val+'</span>';
        } else {

        	val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8)+" "+val.substring(8,10)+":"+val.substring(10,12);
            return val;
        }
    }else{
    	return val;
    }
}

</script>	
<script type="text/javascript">
     function myformatter(date){
    	 if(date){
	         var y = date.getFullYear();
	         var m = date.getMonth()+1;
	         var d = date.getDate();
	         return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
    	 }else{
    		 return '';
    	 }
     }
     function myparser(s){
         if (!s) return new Date();
         var ss = (s.split('-'));
         var y = parseInt(ss[0],10);
         var m = parseInt(ss[1],10);
         var d = parseInt(ss[2],10);
         if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
             return new Date(y,m-1,d);
         } else {
             return new Date();
         }
     }

</script>
 
<body>

			<div id="header" class="group wrap header">
			<div class="content">
<%@ include file="/include/top.jsp" %>
		</div>
			</div>
			<div id="mainwrap">
			<div id="content">
	
	<div style="margin:1px 0;"></div>
	<div class="easyui-layout" style="width:100%;height:800px;">
		<div data-options="region:'center'">
		
			<div class="easyui-tabs" data-options="fit:true,border:false,plain:true">
				 	<div title="<%=request.getAttribute("gubun_name") %>사정보" style="padding:5px">
		<form name="bidcompanyForm" id="bidcompanyForm" target="./bidcompanyWrite.do" method="POST" >	

		<input type="hidden" id="addData" name="addData" value="" />
		 
		 			<table style="width:100%;">
				        <tr>
				            <td class="bc">업체명</td>
				            <td>
				                <input type="text" class="easyui-textbox"  id="company_nm" name="company_nm"   style="width:200px;height:20px;" value=""  >
				            </td>
				            
				            <td width="250px">
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="setGrid()">조회</a>
				            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="append()">추가</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit()">삭제</a>
								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a>
<!-- 								<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="reject()">취소</a> -->
				            </td>
				        </tr>
				    </table>
		
		
		
					<table id="bc" class="easyui-datagrid"
							style="width:100%;height:600px;" 
							
							data-options="iconCls: 'icon-edit',
										rownumbers:true,
										toolbar: '#tb',
										singleSelect:true,
										striped:true,
										pagination:false,
										onDblClickCell : onDbleClickCell,
										onClickCell: onClickCell, onEndEdit: onEndEdit"						
							>
						<thead>
							<tr>
							 	<th data-options="field:'id',editor:'textbox'" width="80" id="id" >id</th>
						 		<th data-options="field:'company_nm',halign:'center',editor:'textbox'" width="150" id="company_nm" >업체명</th>
								<th data-options="field:'delegate',halign:'center',editor:'textbox',max:10"  width="100">대표자명</th>
<!-- 								<th data-options="field:'delegate_explain',halign:'center',editor:'textbox'" width="100">대표자설명</th> -->
								<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="100" formatter="formatMethod">업종</th>
								<th data-options="field:'business_no',halign:'center',editor:'textbox',max:20" width="120">사업자번호</th>
<!-- 								<th data-options="field:'company_registration_day',align:'center',halign:'center',editor:'datebox',formatter:myformatter,parser:myparser" width="100">사업자 등록일</th> -->
								<th data-options="field:'zip_no',align:'center',halign:'center',editor:'textbox',max:5" width="60">우편번호</th>
								<th data-options="field:'address',halign:'center',editor:'textbox',max:100" width="200">기본주소</th>
								<th data-options="field:'address_detail',halign:'center',editor:'textbox',max:100" width="100">상세주소</th>
								<th data-options="field:'department',halign:'center',editor:'textbox',max:20" width="100">담당부서</th>
								<th data-options="field:'position',halign:'center',editor:'textbox',max:20" width="100">직위</th>
								<th data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox',max:10" width="100">담당자명</th>
								<th data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',max:11"  width="100">전화</th>
								<th data-options="field:'mobile_no',align:'center',halign:'center',editor:'textbox',max:11" width="100">휴대폰</th>
								<th data-options="field:'fax_no',align:'center',halign:'center',editor:'textbox',max:11"  width="100">fax</th>
								<th data-options="field:'email',halign:'center',editor:'validatebox',required:true,validType:['email','length[0,30]']"  width="140">이메일</th>
<!-- 								<th data-options="field:'business_condition',align:'center',halign:'center',editor:'textbox'"  width="100">업태</th> -->
<!-- 								<th data-options="field:'business_condition_detail',align:'center',halign:'center',editor:'textbox'"  width="100">종명</th> -->
		 						<th data-options="field:'org_id',hidden:true" width="100"  >id</th>
							</tr>
						</thead>
				</table>
				<script>
					function formatMethod(val,row){
			        	if(val=="1"){
			        		return "등록";
			        	}
			        }
					
					function onDbleClickCell(index,field,value){
						if(field=='company_type_insert'){
							
						}
					}
				</script>
			<form>
		</div>
				</div>
			
			</div>
		</div>
	</div>
		</div>
	</div>
	
	<!-- 업종등록 Dialog start -->
	<div id="companyTypeList" class="easyui-dialog" title="대표업종" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:400px;height:400px;padding:10px">
    	<table style="width:100%">
		        <tr>
		              <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="tab2_save3()" >저장</a>
		            </td>
		        </tr>
		</table>
    	<table id="companyTb" class="easyui-datagrid" style="width:100%;height:90%;"
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
	<script>
	
	function getCompanyTypeList(){
		
		var row = $("#bc").datagrid('getSelected');
		if (length(row.business_no) == 0) {
			$.messager.alert("알림", "사업자번호를 입력하세요.");
			return;
		}
		
		$("#companyTb").datagrid({
			method : "GET",
			url : "<c:url value='/business/companyTypeList.do'/>",
			queryParams : {
				business_no : row.business_no
			},
			onLoadSuccess : function(row, param) {
				
				var rowData = row.rows;
				
				for( var idx in rowData ){
					if( rowData[idx].chk == '1' ) $('#companyTb').datagrid('checkRow', idx);
				}
				
				$('#companyTypeList').dialog('open');
			}
		});
		
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
				$('#bc').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
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
	 function accept(){
		 if(!confirm('저장하시겠습니까?')) return false ;
		 if (endEditing()){
	 		 var myData=$('#bc').datagrid('getSelected');
			 $("#addData").val(encodeURI($.toJSON(myData)));
			 
			 
				
			 					
					
					
 			var options = { dataType: "json" ,  url: "./bidcompanyWrite.do"
		 		       ,beforeSubmit : function(data) {
		 		       }
				       ,success : function(data,status) {
				    	   //hideBodyMessage();
				    	   alert('저장되었습니다.');
		 		       }
			    	   ,error: function(request, status, error) {
			    		   //hideBodyMessage();
			               alert("error:"+request.responseText);
				       }};
			//전송 
			$("#bidcompanyForm").ajaxSubmit(options);

		}
 	}
 
	
	
	function removeit(){
		if (editIndex == undefined){return}
		$('#bc').datagrid('cancelEdit', editIndex)
				.datagrid('deleteRow', editIndex);
		editIndex = undefined;
	}
	
	
	
	
	function save(){
		 if (endEditing()){
		var $dg = $("#bc");

	 
	
			 if ($dg.datagrid('getChanges').length) {
					var inserted = $dg.datagrid('getChanges', "inserted");
					var deleted = $dg.datagrid('getChanges', "deleted");
					var updated = $dg.datagrid('getChanges', "updated");
					var effectRow = new Object();
					effectRow["GUBUN"] = "<%=request.getParameter("GUBUN")%>";
					
					if (inserted.length) {
						effectRow["inserted"] = JSON.stringify(inserted);
					}
					if (deleted.length) {
						effectRow["deleted"] = JSON.stringify(deleted);
					}
					if (updated.length) {
						effectRow["updated"] = JSON.stringify(updated);
					}
		
					$.post("./bidcompanyUpdate.do", effectRow, function(rsp) {
						if(rsp.status){
							$.messager.alert("알림", "저장완료");
							$dg.datagrid('acceptChanges');
							
							
						}
					}, "JSON").error(function() {
						$.messager.alert("알림", "저장에러！");
					});
			  }
		 }
	}
	
	
	
	
	 function removeCheck(){
		 if(!confirm('선택하신 리스트를 삭제 하시겠습니까?')) return false ;
			
		 if (endEditing()){
	 		 var myData=$('#bc').datagrid('getChecked');
			 $("#addData").val(encodeURI($.toJSON(myData)));
 			var options = { dataType: "json",  url: "./bidcompanyDelete.do"
		 		       ,beforeSubmit : function(data) {
		 		       }
				       ,success : function(data,status) {
				    	   //hideBodyMessage();
				    	   alert('저장되었습니다.');
				    //	   $('#bc').datagrid('refreshRow');
				    	   $('#bc').datagrid('reload'); 
		 		       }
			    	   ,error: function(request, status, error) {
			    		   //hideBodyMessage();
			               alert("error:"+request.responseText);
				       }};
			//전송 
			$("#bidcompanyForm").ajaxSubmit(options);
			
			
			

		}
 	}
	
	 
	
	function reject(){
		$('#bc').datagrid('rejectChanges');
		editIndex = undefined;
	}
	
	
	</script>
</body>
</html>