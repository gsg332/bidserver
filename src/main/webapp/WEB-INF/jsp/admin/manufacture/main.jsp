<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>제조사관리</title>
<%@ include file="/include/session.jsp" %>
	
<script>
var jsonData4=null;

$(document).ready(function() {
	 keydownEvent();
	 setGrid();
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

	t = $('#s_company_type');
	t.textbox('textbox').bind('keydown', function(e){
	   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
		   setGrid();
	   }
	});	

	t = $('#s_goods_type');
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

}

function setGrid(){
	$("#bc").datagrid({
		method : "GET",
		   url: "<c:url value='/manufacture/manufactureList.do'/>",
		queryParams : {
			s_company_no : $('#s_company_no').val(),
			s_company_nm : $('#s_company_nm').val(),
			s_area_cd : $('#s_area_cd').combobox('getValue'),
			s_area_txt : $('#s_area_txt').val(),
			s_delegate_explain_txt : $('#s_delegate_explain_txt').val(),
			s_company_type : $('#s_company_type').val(),
			s_goods_type : $('#s_goods_type').val()
		},
		onLoadSuccess:function(){
			$('#bc').datagrid('selectRow', 0);
			eventBtn();
		}

	});
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
	$('#bc').datagrid('getPanel').find("[type='his_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				getHisList();
			}
		})
	});
	$('#bc').datagrid('getPanel').find("[type='bid_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				getBidReportList();
			}
		})
	});
	$('#bidTb').datagrid('getPanel').find("[type='report_type']").each(function(index){
		$(this).linkbutton({
			onClick:function(){
				var business_no = $(this).attr('val');
				$("#business_no").val(business_no);
				
				$('#manufactureList').dialog('open');
				
				var row = $("#bidTb").datagrid("selectRow",index);
				var row = $("#bidTb").datagrid("getSelected");
				
				setReportInfo(row);
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
}

function excelDown(){
 	
	$("input[name='s_area_cd']").val($('#s_area_cd').combobox('getValue'));

	$("#excel").submit();

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
				 	<div title="제조사정보" style="padding:5px">
					<input type="hidden" id="addData" name="addData" value="" />
		 			<table style="width:100%;">
				        <tr>
				        	<td width="80%"  align="left">
				        	 <form id="excel" method="post" action="<c:url value='/manufacture/downloadExcelList.do'/>" accept-charset="utf-8">
    							<input type="hidden" name="s_area_cd" value=""/>
				        		<table style="width:100%;">
							        <tr>
							            <td class="bc">사업자번호</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_no" name="s_company_no"   style="width:100px;"   >
							            </td>
							            <td class="bc">업체명</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_nm" name="s_company_nm"   style="width:150px;"   >
							            </td>
							            <td class="bc">업종</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_company_type" style="width:80px;"   >
							                <input type="text" class="easyui-textbox"  id="s_company_type_nm" style="width:110px;"  disabled="disabled"  >
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCompanyType('s_company_type', 's_company_type_nm', 's')" ></a>
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchCompanyType('s_company_type', 's_company_type_nm', 'c')" ></a>
							            </td>
							            <td class="bc">물품</td>
							            <td>
							                <input type="text" class="easyui-textbox"  id="s_goods_type" style="width:80px;"   >
							                <input type="text" class="easyui-textbox"  id="s_goods_type_nm" style="width:110px;"  disabled="disabled"  >
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType('s_goods_type', 's_goods_type_nm', 's')" ></a>
							                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType('s_goods_type', 's_goods_type_nm', 'c')" ></a>
							            </td>
							            <td class="bc">지역명</td>
							            <td>
							                <input id="s_area_cd" class="easyui-combobox"
												data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:120,
										        panelHeight:'auto',
										        url: '<c:url value='/bid/comboList.do?searchType=A&cdGroupCd=main_area_cd'/>'">
										    <input type="text" class="easyui-textbox"  id="s_area_txt" style="width:100px;"  />
							            </td>
							            <td class="bc">대표물품</td>
							            <td>
										    <input type="text" class="easyui-textbox"  id="s_delegate_explain_txt" style="width:100px;"  />
							            </td>
							        </tr>
							    </table>
							 </form>
				        	</td>
				            
				            <td width="20%" align="right">
				            	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="excelDown()">엑셀다운로드</a>
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
  									    nowrap:false,
										onClickCell: onClickCell, onEndEdit: onEndEdit,
										rowStyler: function(index,row){
										                    if (row.unuse_yn=='Y'){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }
										              }"						
							>
						<thead>
							<tr>
								<th data-options="field:'business_no',align:'center',halign:'center'" width="80">No.</th>
						 		<th data-options="field:'company_no',halign:'center',editor:'textbox'" width="150">사업자번호</th>
						 		<th data-options="field:'company_nm',halign:'center',editor:'textbox'" width="150">업체명</th>
						 		<th data-options="field:'unuse_yn',align:'center',halign:'center',width:40,editor:{type:'checkbox',options:{on:'Y',off:'N'}}">보류</th>
								<th data-options="field:'delegate',align:'center',halign:'center',editor:'textbox',max:10"  width="80">대표자명</th>
								<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton">업종</th>
								<th data-options="field:'company_type_insert2',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton2">물품</th>
								<th data-options="field:'delegate_explain',align:'center',halign:'center',editor:'textbox'"  width="80">대표물품</th>
<!-- 								<th data-options="field:'zip_no',align:'center',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['number','length[5,5]'],invalidMessage:'우편번호를 5자리로 입력하세요'}}" width="60">우편번호</th> -->
								<th  data-options="field:'address',align:'left',halign:'center',sortable:true,width:100,
									                        formatter:function(value,row){
									                            return row.address_nm;
									                        },
									                        editor:{
									                            type:'combobox',
									                            options:{
									                                valueField:'cd',
									                                textField:'cd_nm',
									                                method:'get',
									                                data:jsonData4,
									                                required:false
									                            }
									                        }">기본주소</th>
								<th data-options="field:'address_detail',halign:'center',editor:'textbox',max:100" width="250">상세주소</th>
								<th data-options="field:'department',halign:'center',editor:'textbox',max:20" width="70">담당부서</th>
								<th data-options="field:'position',halign:'center',editor:'textbox',max:20" width="60">직위</th>
								<th data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox',max:10" width="80">담당자명</th>
								<th data-options="field:'phone_no',align:'center',halign:'center',editor:'textbox',max:11"  width="110">전화</th>
								<th data-options="field:'mobile_no',align:'center',halign:'center',editor:'textbox',max:11" width="110">휴대폰</th>
								<th data-options="field:'fax_no',align:'center',halign:'center',editor:'textbox',max:11"  width="110">fax</th>
								<th data-options="field:'email',halign:'center',editor:{type:'validatebox',options:{required:false,validType:['email','length[0,30]'],invalidMessage:'알맞은 이메일 형식을 사용하세요(0~30자내)'}}"  width="200">이메일</th>
								<th data-options="field:'company_type_insert3',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton3">이력보기</th>
								<th data-options="field:'company_type_insert4',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton4">견적보고서</th>
							</tr>
						</thead>
					</table>
					<script>
						function formatMethod(val,row){
				        	if(val=="1"){
				        		return "등록하기";
				        	}
				        }
						
						function onDbleClickCell(index,field,value){
							if(field=='company_type_insert'){
								if(value=="1"){
								getCompanyTypeList();
								}
							}
						}
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
					<div title="공공구매정보망 기업정보" style="padding:5px">
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
					</div>
				</div>
			</div>
		</div>
		
		<!-- 견적보고서 Dialog start -->
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
                <td><font id="tab_pre_price"></font> / <font id="tab_base_price"></font></td>
                <td class="bc">투찰기준금액(낙찰하한율)</td>
                <td><font id="tab_column1"></font>(<font id="tab_column5"></font> %)</td>
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
                <td colspan="3">
                <input id="file_id" class="easyui-filebox" name="file" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 파일을 첨부해주세요.',editable:false" style="width:450px;height:24px;">
			 	<a id="file_link" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" >다운로드</a>
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
						data-options="singleSelect:false,pagination:false,
									  nowrap:false" style="width:80%;">
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
                <td style="text-align: cetner;"> <input class="easyui-textbox" data-options="multiline:true,disabled:true" id="apply_comment1" value="" style="width:270px;height:100px"></td>
                <td style="text-align: cetner;"> <input class="easyui-textbox" data-options="multiline:true,disabled:true" id="apply_comment2" value="" style="width:270px;height:100px"></td>
                <td style="text-align: cetner;"> <input class="easyui-textbox" data-options="multiline:true,disabled:true" id="apply_comment3" value="" style="width:270px;height:100px"></td>
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
					<font id="tab_info1_1"></font>
				</td>
				<td class="cont">
					<font id="tab_info1_1d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 규격을 확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info1_2"></font>
				</td>
				<td class="cont">
					<font id="tab_info1_2d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 품질보증 관련 인증보유 및 시험성적 여부확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info1_3"></font>
				</td>
				<td class="cont">
					<font id="tab_info1_3d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 특정 규격 및 특정 제조사 여부에 확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info1_4"></font>
				</td>
				<td class="cont">
					<font id="tab_info1_4d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 납품될 제품의 정품여부에 대하여 확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info1_5"></font>
				</td>
				<td class="cont">
					<font id="tab_info1_5d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ <font id="tab_info1_6t"></font></td>
				<td class="cont" style="text-align: center">
					<font id="tab_info1_6"></font>
				</td>
				<td class="cont">
					<font id="tab_info1_6d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" colspan="3">의견 : <font id="tab_info1_7"></font></td>
			</tr>
			<tr>
				<td class="bc" rowspan="6">납품<br/>관련</td>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 납기의 적절성 확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info2_1"></font>
				</td>
				<td class="cont">
					<font id="tab_info2_1d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사 담당자와 납품장소의 적절성 확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info2_2"></font>
				</td>
				<td class="cont">
					<font id="tab_info2_2d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 제조사분석 확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info2_3"></font>
				</td>
				<td class="cont">
					<font id="tab_info2_3d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ 운송비용, 설치비용의 확인</td>
				<td class="cont" style="text-align: center">
					<font id="tab_info2_4"></font>
				</td>
				<td class="cont">
					<font id="tab_info2_4d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" style="width: 55%">○ <font id="tab_info2_5t"></font></td>
				<td class="cont" style="text-align: center">
					<font id="tab_info2_5"></font>
				</td>
				<td class="cont">
					<font id="tab_info2_5d"></font>
				</td>
			</tr>
			<tr>
				<td class="cont" colspan="3">의견 : <font id="tab_info2_6"></font></td>
			</tr>
			<tr>
				<td class="bc">기타리스크 </td>
				<td class="cont" colspan="3">
					<font id="tab_info3"></font>
				</td>
			</tr>
        </table>
    </div>
    <!-- 견적보고서 Dialog end -->
	</div>
	
	<%@ include file="/include/popup.jsp" %>
    
    <!-- 이력 Dialog start -->
	<div id="hisDlg" class="easyui-dialog" title="이력정보" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:50%;height:80%;padding:10px">
    	<table id="hisTb" class="easyui-datagrid" style="width:100%;height:70%;"
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
					<th data-options="field:'bid_notice_no',align:'left',width:150,halign:'center',sortable:true" formatter="formatNoticeNo">공고번호</th>
					<th data-options="field:'bid_notice_nm',align:'left',width:250,halign:'center',sortable:true" >공고명</th>
					<th data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th>
					<th data-options="field:'quotation',align:'right',width:100,halign:'center',sortable:true" formatter="numberComma">견적금액</th>
					<th data-options="field:'review',align:'left',width:200,halign:'center',sortable:true" >담당자 견적의견</th>
				</tr>
			</thead>
		</table>
        <table style="width:100%">
		        <tr>
		            <td align="right">
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addBizHis()" >추가</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeit3()" >삭제</a>
		                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveBizHis()" >저장</a>
		            </td>
		        </tr>
		</table>
    	<table id="bizHisTb" class="easyui-datagrid" style="width:100%;height:20%;"
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
		<script>

			function setBizHisGrid(){
	
				$("#bizHisTb").datagrid({
					method : "GET",
					   url: "<c:url value='/business/selectBizNotiHisList.do'/>",
					queryParams : {
						business_no : $('#business_no').val(),
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
    </div>
    <!-- 이력 Dialog end -->
    <!-- 이력 Dialog start -->
	<div id="bidDlg" class="easyui-dialog" title="견적보고서목록" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:70%;height:80%;padding:10px">
    	<table id="bidTb" class="easyui-datagrid" style="width:100%;height:100%;"
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
					<th data-options="field:'bid_notice_no',align:'left',width:150,halign:'center',sortable:true" formatter="formatNoticeNo">공고번호</th>
					<th data-options="field:'bid_notice_nm',align:'left',width:250,halign:'center',sortable:true" >공고명</th>
					<th data-options="field:'demand_nm',align:'left',width:100,halign:'center',sortable:true" formatter="formatEnter" >수요처</th>
					<th data-options="field:'detail_goods_nm',align:'left',width:100,halign:'center',sortable:true" >물품명</th>
					<th data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th>
					<th data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">앱찰개시일시</th>
					<th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰마감일시</th>
					<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="70" formatter="formatRowButton5">상세</th>
					
				</tr>
			</thead>
		</table>
    </div>
    <!-- 이력 Dialog end -->
    
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
		   ,url: "<c:url value='/apply/bidApplyList.do'/>"
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
			url : "<c:url value='/bid/selectEstimateList.do'/>",
			queryParams : {
				bid_notice_no :bidNoticeNo,
				bid_notice_cha_no : bidNoticeChaNo,
			},
			onLoadSuccess : function(row, param) {

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
				if(field=="company_type_insert") {editIndex = index; return};
				if(field=="company_type_insert2"){editIndex = index; return};
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
	    				$.post("<c:url value='/manufacture/updateManufactureList.do'/>", effectRow, function(rsp) {
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
    	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	        if (r){
	        	if (endEditing()){
    				var effectRow = new Object();
					effectRow["business_no"] = $("#business_no").val();
					effectRow["bigo"] = $("#bigo").textbox("getValue");
    				$.post("<c:url value='/manufacture/updateManufactureBigo.do'/>", effectRow, function(rsp) {
    					if(rsp.status){
    						$.messager.alert("알림", "저장하였습니다.");
    					}
    				}, "JSON").error(function() {
    					$.messager.alert("알림", "저장에러！");
    				});
	    		}
	        }
    	});
	}
	
	function getHisList(){
		$('#hisDlg').dialog('open');
		
		$("#hisTb").datagrid({
			method : "GET",
			url : "<c:url value='/manufacture/getBizHisList.do'/>",
			queryParams : {
				business_no : $("#business_no").val()
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
			url : "<c:url value='/manufacture/getBidReportList.do'/>",
			queryParams : {
				business_no : $("#business_no").val()
			},
			onLoadSuccess : function(row, param) {
				eventBtn();
			}
		});
		
	}

	</script>
	
</body>
</html>