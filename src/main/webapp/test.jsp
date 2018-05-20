<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Basic DataGrid - jQuery EasyUI Demo</title>
	<link rel="stylesheet" type="text/css" href="./themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="./themes/icon.css">
	<link rel="stylesheet" type="text/css" href="./demo/demo.css">
	<script type="text/javascript" src="./jquery.min.js"></script>
	<script type="text/javascript" src="./jquery.easyui.min.js"></script>
<script>
 $(document).ready(function() {
	 setGrid();
   
 });


function setGrid(){
	
	 $("#dg").datagrid({
		   method: "POST",
		   url: "./mbListDao.php?tableName=valSheetList",
		   queryParams: {
				idnum: "2",
				pagenum: "1"
		   },
		   onDblClickRow: function(rowIndex, rowData){
			   writeDetail(rowData.PUBLICID);
		   },
		   onLoadSuccess: function(row, param) {
			   
		   }
	 });
	 
}

</script>




</head>
<body>
	<h2>Basic DataGrid</h2>
	<p>The DataGrid is created from markup, no JavaScript code needed.</p>
	<div style="margin:20px 0;"></div>
	
	<table id="dg" class="easyui-datagrid" title="Basic DataGrid"  
			style="width:1000px;height:500px;" data-options="singleSelect:true,pagination:true">
		<thead>
			<tr>
				<th data-options="field:'mb1',width:80">현장명</th>
				<th data-options="field:'mb2',width:100">구분</th>
				<th data-options="field:'mb3',width:80,align:'right'">접수일</th>
				<th data-options="field:'mb4',width:80,align:'right'">완료일</th>
				<th data-options="field:'mb5',width:80,align:'right'">완료구분</th>
				 
				<th data-options="field:'mb6',width:250">동</th>
				<th data-options="field:'mb7',width:60,align:'center'">호</th>
				<th data-options="field:'mb8',width:60,align:'center'">신청자명</th>
				<th data-options="field:'mb9',width:60,align:'center'">전화번호</th>
				<th data-options="field:'mb10',width:60,align:'center'">휴대폰</th>
				<th data-options="field:'mb11',width:60,align:'left'">내용</th>
				<th data-options="field:'mb12',width:60,align:'center'">불만제기사항</th>
				<th data-options="field:'mb13',width:60,align:'center'">실</th>
				<th data-options="field:'mb14',width:60,align:'center'">부위</th>
				<th data-options="field:'mb15',width:60,align:'center'">공종</th>
				<th data-options="field:'mb16',width:60,align:'center'">유형</th>
				<th data-options="field:'mb17',width:60,align:'center'">원인</th>
				<th data-options="field:'mb18',width:60,align:'center'">협력업체</th>
				<th data-options="field:'mb19',width:60,align:'center'">처리내용</th>
				<th data-options="field:'mb20',width:60,align:'center'">미처리내용</th>
				<th data-options="field:'mb21',width:60,align:'center'">사유</th>
				<th data-options="field:'mb22',width:60,align:'left'">처리방안</th>
				<th data-options="field:'mb23',width:60,align:'center'">작업자</th>
	 		</tr>
		</thead>
	</table>

</body>
</html> 