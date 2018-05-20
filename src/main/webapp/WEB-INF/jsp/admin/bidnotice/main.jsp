<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>입찰관리</title>
<%@ include file="/include/session.jsp"%>
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
	   ,url: "<c:url value='/bid/userList.do'/>"
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
	   ,url: "<c:url value='/bid/userList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'A'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData2=json;
	   }
	});
	
	//적격정보 콤보
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/comboList.do'/>"
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
	
	//지역 콤보
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/comboList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'C',
			cdGroupCd : 'main_area_cd'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData4=json;
	   }
	});
	
	//기업규모 콤보
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/comboList.do'/>"
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
	  	 jsonData6=json;
	   }
	});
	
	//조달사이트 콤보
	$.ajax({ 
	    type: "GET"
	   ,url: "<c:url value='/bid/comboList.do'/>"
	   ,async: false 
	   ,data : {
			searchType :'C',
			cdGroupCd : 'bid_site_cd'
		}
	   ,dataType: "json"
	   ,success:function(json){
	  	 jsonData7=json;
	   }
	});
	
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
	  	 jsonData8=json;
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
	  	 jsonData9=json;
	   }
	});
	
	//나의 견적승인요청건수
	function popupApplyInfo(){
		
		$.ajax({ 
		    type: "GET"
		   ,url: "<c:url value='/bid/getApplyCnt.do'/>"
		   ,async: false 
		   ,dataType: "json"
		   ,success:function(json){
			   
			   if(json.rows!="0"){
				   $.messager.show({
			              title:'알림',
			              msg:"금일 승인요청 공고가 "+json.rows+"개 있습니다.<br/>요청된 공고를 확인하시기 바랍니다.",
			              showType:'show'
			          });
			   }
			   
			   popupProjectInfo(json.rows);
		   }
		});
    }
	
	//나의 프로젝트 알람건수
	function popupProjectInfo(brows){
		
		var bottom =0;
		 if(brows!="0"){
			 bottom =-document.body.scrollTop-document.documentElement.scrollTop+100;
		 }else{
			 bottom =-document.body.scrollTop-document.documentElement.scrollTop;
		 }
		
		$.ajax({ 
		    type: "GET"
		   ,url: "<c:url value='/bid/getProjectCnt.do'/>"
		   ,async: false 
		   ,dataType: "json"
		   ,success:function(json){
			   
			   if(json.rows!="0"){
				   $.messager.show({
			              title:'알림',
			              msg:"금일 프로젝트 업무가 "+json.rows+"개 있습니다.<br/>프로젝트 관리를 확인하시기 바랍니다.",
			              showType:'show',
			              style:{
        	                      left:'',
        	                      right:0,
        	                      top:'',
        	                      bottom:bottom

        	              }

			       });
			   }
		   }
		});
    }

	$(document).ready(function() {
		eventInit();
		init();
		popupApplyInfo();
	});
	
	//조회 텍스트 박스 이벤트 binding
	function eventInit(){
		var textbox_name = ["#bidNoticeNo", "#bidAreaNm", "#bidDemandNm","#bidBigo","#bidGoodsNm", 
			              "#bidNoticeNo2", "#bidAreaNm2", "#bidDemandNm2","#bidBigo2","#bidGoodsNm2", 
			              "#bidNoticeNo3", "#bidAreaNm3", "#bidDemandNm3","#bidBigo3","#bidGoodsNm3", 
			              "#bidNoticeNo4", "#bidAreaNm4", "#bidDemandNm4","#bidBigo4","#bidGoodsNm4",
			              "#bidNoticeNo5", "#bidAreaNm5", "#bidDemandNm5","#bidGoodsNm5",
			              "#bidNoticeNo6"
			              ];
		for(var i=0; i<textbox_name.length;i++){
			var t = $(textbox_name[i]);
			if(i < 5){
				t.textbox('textbox').bind('keydown', function(e){
				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
					   selectBidList();
				   }
				});	
		     }else if(i>=5 && i < 10){
				t.textbox('textbox').bind('keydown', function(e){
				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
					   selectBidList2();
				   }
				});	
		     }else if(i>=10 && i < 15){
			   t.textbox('textbox').bind('keydown', function(e){
				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
					   selectBidList3();
				   }
				});	
		     }else if(i>=15 && i < 20){
			   t.textbox('textbox').bind('keydown', function(e){
				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
					   selectBidList4();
				   }
				});	
		     }else if(i>=20 && i < 24){
			   t.textbox('textbox').bind('keydown', function(e){
				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
					   selectBidList5();
				   }
				});	
		     }else if(i==24){
			   t.textbox('textbox').bind('keydown', function(e){
				   if (e.keyCode == 13){   // when press ENTER key, accept the inputed value.
					   selectBidList6();
				   }
				});	
		     }
		}
		
	}
	
    //조회조건 날짜 초기화
	function init(){
	    var dts = new Date();
		var dte = new Date();
		var dtn = new Date();
	    var dayOfMonth = dts.getDate();
	    dts.setDate(dayOfMonth-30);
	    dte.setDate(dayOfMonth+7);
	    dts = dts.getFullYear()+"-"+((dts.getMonth() + 1)<9?"0"+(dts.getMonth() + 1):(dts.getMonth() + 1))+"-"+dts.getDate();
	    dte = dte.getFullYear()+"-"+((dte.getMonth() + 1)<9?"0"+(dte.getMonth() + 1):(dte.getMonth() + 1))+"-"+dte.getDate();
	    dtn = dtn.getFullYear()+"-"+((dtn.getMonth() + 1)<9?"0"+(dtn.getMonth() + 1):(dtn.getMonth() + 1))+"-"+dtn.getDate();
	    
	    for(var i=1;i<6;i++){
	    	if(i==1){
			    $('#bidStartDt').datebox('setValue',dts);
			    $('#bidEndDt').datebox('setValue',dte);
	    	}else{
			    $('#bidStartDt'+i).datebox('setValue',dts);
			    $('#bidEndDt'+i).datebox('setValue',dte);
	    	}
	    }
	    
	    $('#bidEndDt6').datebox('setValue',dtn);
	    selectBidList();
	}
    
    //물품공고현황탭 공고갱신
	function getBidInfoApi(){
		var startDt = $('#startDt').datebox('getValue').replaceAll("-","");
		if(startDt.length==0){
			$.messager.alert("알림", "공고일을 입력하세요.");
			return;
		}
		
		$.messager.confirm('알림', "해당일의 공고를 가져오시겠습니까?", function(r){
	        if (r){
    			var effectRow = new Object();
    			var win = $.messager.progress({
    		            title:'공고 가져오기',
    		            msg:'데이터 처리중입니다.<br/>잠시만 기다려주세요...'
    		        });
    			
    			effectRow["startDt"] = startDt
				
				$.post("<c:url value='/bid/getBidInfoApi.do'/>", effectRow, function(rsp) {
					if(rsp.status){
						selectBidList();
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
	
	//물품공고현황탭 입찰공고 조회
	function selectBidList(){
		$("#dg").datagrid({
			method : "GET",
			url : "<c:url value='/bid/bidList.do'/>",
			queryParams : {
				searchDateType :$('#searchDateType').combobox('getValue'),
				bidStartDt :$('#bidStartDt').datebox('getValue'),
				bidEndDt : $('#bidEndDt').datebox('getValue'),
				bidNoticeNo : $('#searchBidType').combobox('getValue')=="1"?$('#bidNoticeNo').val():"",
				bidNoticeNm : $('#searchBidType').combobox('getValue')=="2"?$('#bidNoticeNo').val():"",
				bidAreaNm : $('#bidAreaNm').val(),
				bidGoodsNm : $('#bidGoodsNm').val(),
				bidDemandNm : $('#bidDemandNm').val(),
				bidBigo : $('#bidBigo').val(),
				userId : $('#userId').combogrid('getValue')
			},
			onLoadSuccess : function(row, param) {

				$("#mainwrap").css("display","");
				eventBtn();
				if(row.rows.length==0){
					setBizInfoInit1();
				}else{
					$('#dg').datagrid('selectRow', 0);
					$('#dg').datagrid('fixColumnSize');
				}
			},
			onSelect : function(index, row){
				setBizInfo1(row);
			}
		});
	}
	
	//나라장터 링크 팝업
	function popupDetail(link){
		var xleft= screen.width * 0.4;
		var xmid= screen.height * 0.4;
		window.open(link, "popup", "width=850,height=800,scrollbars=1", true)
	}
	
	//물품공고현황탭 입찰관련정보 초기화
	function setBizInfoInit1(){
		$("#tab1_notice_type").empty();
		$("#tab1_bid_notice_no").empty();
		$("#tab1_bid_notice_nm").empty();
		$("#tab1_noti_dt").empty();
		$("#tab1_order_agency_nm").empty();
		$("#tab1_bid_demand_nm").empty();
		$("#tab1_bid_cont_demand").empty();
		$("#tab1_nation_bid_yn").empty();
		$("#tab1_pre_price").empty();
		$("#tab1_base_price").empty();
		
		
		$("#tab1_detal1").empty();
		$("#tab1_detal2").empty();
		$("#tab1_detal3").empty();
		$("#tab1_detal4").empty();
		
		$("#tab1_base_price2").empty();
		$("#tab1_column5").empty();
		$("#tab1_pre_price").empty();
	    $('#tab1_success_per').textbox('setValue',"");
	    $('#tab1_result_price').textbox('setValue',"");
	    $('#tab1_pre_per').textbox('setValue',"");
	}
	
	//물품공고현황탭 입찰관련정보 설정
	function setBizInfo1(row){
		setBizInfoInit1();
		$("#tab1_notice_type").text(row.notice_type);
		$("#tab1_bid_notice_no").text(row.bid_notice_no+"-"+row.bid_notice_cha_no);
		$("#tab1_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+row.notice_detail_link+"')\">상세보기</a>");
		$("#tab1_bid_notice_nm").text(row.bid_notice_nm);
		$("#tab1_noti_dt").text(formatDate(row.noti_dt));
		$("#tab1_order_agency_nm").append(formatEnter(row.order_agency_nm));
		$("#tab1_bid_demand_nm").append(formatEnter(row.demand_nm));
		$("#tab1_bid_cont_demand").text(row.contract_type_nm);
		$("#tab1_nation_bid_yn").text(row.nation_bid_yn);
		$("#tab1_pre_price").empty();
		$("#tab1_pre_price").append(numberComma(row.pre_price));
		$("#tab1_base_price").empty();
		$("#tab1_base_price").append(numberComma(row.base_price));
		
		
		$("#tab1_detal1").append(bid_info_detail1(row));
		$("#tab1_detal2").append(bid_info_detail2(row));
		$("#tab1_detal3").append(bid_info_detail3(row));
		$("#tab1_detal4").append(bid_info_detail4(row));
		
		$("#tab1_base_price2").empty();
		$("#tab1_base_price2").append(numberComma(row.base_price));
		
		//입찰사용자등록정보
		getBidDtl1(row.bid_notice_no,row.bid_notice_cha_no);
	}
	
	//물품공고현황탭 입찰가격 상세정보
	function getBidDtl1(bidNoticeNo, bidNoticeChaNo){
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
					    $('#tab1_column5').text(json.rows[0].column5);
					    $('#tab1_success_per').numberbox("setValue",json.rows[0].column5);
				   }else{
					    $('#tab1_column5').empty();
					    $('#tab1_success_per').empty();
				   }
			   }
		});
	}
	
	//견적요청탭 입찰공고 조회
	function selectBidList2(){
		$("#dg2").datagrid({
			method : "GET",
			url : "<c:url value='/bid/bidList.do'/>",
			queryParams : {
				searchDateType :$('#searchDateType2').combobox('getValue'),
				bidStartDt :$('#bidStartDt2').datebox('getValue'),
				bidEndDt : $('#bidEndDt2').datebox('getValue'),
				bidNoticeNo : $('#searchBidType2').combobox('getValue')=="1"?$('#bidNoticeNo2').val():"",
				bidNoticeNm : $('#searchBidType2').combobox('getValue')=="2"?$('#bidNoticeNo2').val():"",
				bidAreaNm : $('#bidAreaNm2').val(),
				bidGoodsNm : $('#bidGoodsNm2').val(),
				bidDemandNm : $('#bidDemandNm2').val(),
				bidBigo : $('#bidBigo2').val(),
				userId : $('#userId2').combogrid('getValue'),
				allYn :'Y'
			},
			onLoadSuccess : function(row, param) {
				eventBtn();
				if(row.rows.length==0){
					setBizInfoInit();
				}else{
					$('#dg2').datagrid('selectRow', 0);
					$('#dg2').datagrid('fixColumnSize');
				}
			},
			onSelect : function(index, row){
				setBizInfo(row);
			},
		});
	}
	
	//견적요청탭 입찰관련정보 초기화
	function setBizInfoInit(){
		
		$("#tab2_notice_type").empty();
		$("#tab2_bid_notice_no").empty();
		$("#tab2_bid_notice_nm").empty();
		$("#tab2_noti_dt").empty();
		$("#tab2_order_agency_nm").empty();
		$("#tab2_bid_demand_nm").empty();
		$("#tab2_bid_cont_demand").empty();
		$("#tab2_nation_bid_yn").empty();
		$("#tab2_pre_price").empty();
		$("#tab2_base_price").empty();
		
		
		$("#tab2_detal1").empty();
		$("#tab2_detal2").empty();
		$("#tab2_detal3").empty();
		$("#tab2_detal4").empty();
		
		$('#column1').textbox('setValue',"");
	    $('#column2').combobox('setValue',"");
	    $('#column3').combobox('setValue',"");
	    $('#column4').textbox('setValue',"");
	    $('#column5').textbox('setValue',"");
	    $('#column6').textbox('setValue',"");

	    $('#s_range').textbox('setValue',"");
	    $('#e_range').textbox('setValue',"");
	    setBizGrid('','');
	}
	
	//견적요청탭 입찰관련정보 설정
	function setBizInfo(row){
		setBizInfoInit();
		$("#tab2_notice_type").text(row.notice_type);
		$("#tab2_bid_notice_no").text(row.bid_notice_no+"-"+row.bid_notice_cha_no);
		$("#tab2_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+row.notice_detail_link+"')\">상세보기</a>");
		$("#tab2_bid_notice_nm").text(row.bid_notice_nm);
		$("#tab2_noti_dt").text(formatDate(row.noti_dt));
		$("#tab2_order_agency_nm").append(formatEnter(row.order_agency_nm));
		$("#tab2_bid_demand_nm").append(formatEnter(row.demand_nm));
		$("#tab2_bid_cont_demand").text(row.contract_type_nm);
		$("#tab2_nation_bid_yn").text(row.nation_bid_yn);
		$("#tab2_pre_price").empty();
		$("#tab2_pre_price").append(numberComma(row.pre_price));
		$("#tab2_base_price").empty();
		$("#tab2_base_price").append(numberComma(row.base_price));
		
		
		$("#tab2_detal1").append(bid_info_detail1(row));
		$("#tab2_detal2").append(bid_info_detail2(row));
		$("#tab2_detal3").append(bid_info_detail3(row));
		$("#tab2_detal4").append(bid_info_detail4(row));
		
		//입찰사용자등록정보
		getBidDtl(row.bid_notice_no,row.bid_notice_cha_no);
		
		//입찰 제조사 정보
		setBizGrid(row.bid_notice_no,row.bid_notice_cha_no);
	}
	
	//견적요청탭 입찰관련정보 추가정보 설정
	function getBidDtl(bidNoticeNo, bidNoticeChaNo){
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
					    $('#column1').textbox('setValue',numberComma(json.rows[0].column1));
					    $('#column2').combobox('setValue',json.rows[0].column2);
						$('#column3').combobox('setValue', json.rows[0].column3);
					    $('#column4').textbox('setValue',json.rows[0].column4);
					    $('#column5').textbox('setValue',json.rows[0].column5);

					    $('#s_range').textbox('setValue',json.rows[0].s_range);
					    $('#e_range').textbox('setValue',json.rows[0].e_range);
				   }else{
					   $('#column1').textbox('setValue',"");
					    $('#column2').combobox('setValue',"");
					    $('#column3').combobox('setValue',"");
					    $('#column4').textbox('setValue',"");
					    $('#column5').textbox('setValue',"");

					    $('#s_range').textbox('setValue',"");
					    $('#e_range').textbox('setValue',"");
				   }
				   
				   var status = false;
				   if(json.bidStatus !=null){
					   if(json.bidStatus.status_step=="1"){
						   if(json.bidStatus.status_cd1=="002"){
							   if(json.bidStatus.status_cd2=="003"){
								   status = true;
							   }else{
								   status = false;
							   }
						   }else if(json.bidStatus.status_cd1=="003"){
							   status = true;
						   }
					   }else if(json.bidStatus.status_step=="2"){
						   status = false;
					   }else if(json.bidStatus.status_step=="3"){
						   status = false;
					   }
				   }else{
					   status = true;
				   }
				   
				   if(status){
					   $("#addManufactureBtn").linkbutton("enable");
					   $("#delManufactureBtn").linkbutton("enable");
					   $("#manufactureSaveBtn").linkbutton("enable");
				   }else{
					   $("#addManufactureBtn").linkbutton("disable");
					   $("#delManufactureBtn").linkbutton("disable");
					   $("#manufactureSaveBtn").linkbutton("disable");
				   }
			  	 
			   }
		});
	}
	
	//견적요청탭  제조사 정보 조회
	function setBizGrid(bidNoticeNo, bidNoticeChaNo){
		
		$("#bc2").datagrid({
			method : "GET",
			url : "<c:url value='/bid/bidBizRelList.do'/>",
			queryParams : {
				bid_notice_no :bidNoticeNo,
				bid_notice_cha_no : bidNoticeChaNo,
			},
			onLoadSuccess : function(row, param) {

			}
		});
	}
	
	//견적요청탭 입찰관련정보 사용자 정보 저장
	function tab2_save(){
      	var row = $("#dg2").datagrid('getSelected');
      	var effectRow = new Object();
		if (row) {
			effectRow["bid_notice_no"] = row.bid_notice_no;
			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
		}else{
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
      	$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	        if (r){
	    		effectRow["column1"] = $('#column1').val().replaceAll(",","");
	    		effectRow["column2"] = $('#column2').combogrid('getValue');
	    		effectRow["column3"] = $('#column3').combogrid('getValue');
	    		effectRow["column4"] = $('#column4').val();
	    		effectRow["column5"] = $('#column5').val();
	    		effectRow["s_range"] = $('#s_range').val();
	    		effectRow["e_range"] = $('#e_range').val();
	    		
	    		$.post("<c:url value='/bid/setBidDtl.do'/>", effectRow, function(rsp) {
	    			if(rsp.status){
	    				$.messager.alert("알림", "저장하였습니다.");
	    			}
	    		}, "JSON").error(function() {
	    			$.messager.alert("알림", "저장에러！");
	    		});
	        }
		});
	}
	
	//제조업체 추가 팝업
	function getManufactureList(){
		
		var row = $("#dg2").datagrid('getSelected');
		if (!row) {
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
		
		$("#manufactureTb").datagrid({
			method : "GET",
			url : "<c:url value='/bid/manufactureList.do'/>",
			queryParams : {
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				s_business_nm : $("#s_business_nm").textbox("getValue"),
				s_company_type : $("#s_company_type").textbox("getValue"),
				s_goods_type : $("#s_goods_type").textbox("getValue"),
				s_area_cd : $("#s_area_cd").combobox("getValue"),
				s_area_txt : $("#s_area_txt").textbox("getValue")
			},
			onLoadSuccess : function(row, param) {
				
				$('#manufactureList').dialog('open');
				
				eventBtn();
			}
		});
		
	}
	
	//제조업체 추가하기
	function tab2_save2(){
		var row = $("#dg2").datagrid('getSelected');
		var addData=$('#manufactureTb').datagrid('getChecked');
		
		if(addData==null || addData.length==0){
			$.messager.alert("알림", "등록할 제조업체를 선택하세요.");
			return;
		}
		
		$.messager.confirm('알림', '등록하시겠습니까?', function(r){
	        if (r){
	        	$('#manufactureList').dialog('close');
	    		
	    		var effectRow = new Object();
	    		if (row) {
	    			effectRow["bid_notice_no"] = row.bid_notice_no;
	    			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
	    		}
	    		if (addData.length) {
	    			effectRow["addData"] = JSON.stringify(addData);
	    		}
	    		
	    		$.post("<c:url value='/bid/updateManufactureList.do'/>", effectRow, function(rsp) {
	    			if(rsp.status){
	    				$.messager.alert("알림", "저장하였습니다.");
	    				setBizGrid(row.bid_notice_no, row.bid_notice_cha_no)
	    			}
	    		}, "JSON").error(function() {
	    			$.messager.alert("알림", "저장에러！");
	    		});
	        }
	        
		});
	}
	
	
	function tab2_save3(){
		var row =$("#dg2").datagrid('getSelected');
		var addData=$('#companyTb').datagrid('getChecked');
		
		if(!row){
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
		if(addData==null || addData.length==0){
			$.messager.alert("알림", "하나 이상의 업종을 선택하세요.");
			return;
		}
		
		$.messager.confirm('알림', '저장하시겠습니까?', function(r){
	        if (r){
	        	$('#companyTypeList').dialog('close');
	    		
	    		var effectRow = new Object();
	    		if (row!=null) {
	    			effectRow["bid_notice_no"] = row.bid_notice_no;
	    			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
	    		}
	    		if (addData.length) {
	    			effectRow["addData"] = JSON.stringify(addData);
	    		}
	    		
	    		$.post("<c:url value='/bid/updateCompanyTypeList.do'/>", effectRow, function(rsp) {
	    			if(rsp.status){
	    				$.messager.alert("알림", "저장하였습니다.");
	    				setBizGrid(row.bid_notice_no, row.bid_notice_cha_no);
	    				
	    			}
	    		}, "JSON").error(function() {
	    			$.messager.alert("알림", "저장에러！");
	    		});
	        }
	        
		});
	}
	
	
	//tab2 제조사 견적요청
	
	function sendManufacture(){
		var row = $("#dg2").datagrid('getSelected');
		var addData=$('#bc2').datagrid('getChecked');
		
		if(!row){
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
		if(addData==null || addData.length==0){
			$.messager.alert("알림", "제조업체를 선택하세요.");
			return;
		}
		
		
		var message = "안녕하세요 \n"+
			"㈜인콘 <%=(String) session.getAttribute("loginidNM")%> <%=(String) session.getAttribute("position")%>입니다.\n"+
			"공고번호 : "+($('#tab2_bid_notice_no').text())+"\n"+
			"공고명 : "+($('#tab2_bid_notice_nm').text())+"\n"+
			"수요기관 : "+($('#tab2_bid_demand_nm').text())+"\n\n"+
			"관련 하여 견적을 요청드립니다."+"\n\n"+
			"Tel <%=(String) session.getAttribute("tel")%> "+"\n"+
			"Email <%=(String) session.getAttribute("email")%> "+"\n"+
			"Fax <%=(String) session.getAttribute("fax")%> 로 부탁드립니다. "+"\n\n"+
			"견적서는 이메일로 부탁드리며 기타문의사항은 직통전화를 통하여 연락부탁드립니다. "+"\n"+
			"감사합니다"+"\n";
 

			
		$('#sendMessage1').textbox('setValue',message);
		

		$('#sendMessageDlg').dialog('open');
		
	}
	
	function sendMessage(type){
		
		var row = $("#dg2").datagrid('getSelected');
		var addData=$('#bc2').datagrid('getChecked');
		
		$.messager.confirm('알림', '선택하신 업체에 견적을 요청하시겠습니까?', function(r){
            if (r){
            	$('#sendMessageDlg').dialog('close');
        		
        		var effectRow = new Object();
        		if (row) {
        			effectRow["bid_notice_no"] = row.bid_notice_no;
        			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
        		}
        		effectRow["message_type"] = type; 
        		if (addData.length) {
        			effectRow["addData"] = JSON.stringify(addData);
        		}
//         		$.messager.alert($("#sendMessage1").textbox('getValue'));
        		effectRow["send_message"] = $("#sendMessage1").textbox('getValue');
        		
        		$.post("<c:url value='/bid/sendManufacture.do'/>", effectRow, function(rsp) {
        			
        			if(rsp.status){
        				$.messager.alert("알림", "견적요청을 발송하였습니다.");
        				$('#bc2').datagrid('reload');
        			}else{
	        			$.messager.alert("알림", "견적요청에러！");
        				$('#bc2').datagrid('reload');
        			}
        		}, "JSON").error(function() {
        			$.messager.alert("알림", "견적요청에러！");
        		});
            }
        });
		
	}
	
	
	//tab3 조회
	function selectBidList3(){
		$("#dg3").datagrid({
			method : "GET",
			url : "<c:url value='/bid/bidList.do'/>",
			queryParams : {
				searchDateType :$('#searchDateType3').combobox('getValue'),
				bidStartDt :$('#bidStartDt3').datebox('getValue'),
				bidEndDt : $('#bidEndDt3').datebox('getValue'),
				bidNoticeNo : $('#searchBidType3').combobox('getValue')=="1"?$('#bidNoticeNo3').val():"",
				bidNoticeNm : $('#searchBidType3').combobox('getValue')=="2"?$('#bidNoticeNo3').val():"",
				bidAreaNm : $('#bidAreaNm3').val(),
				bidGoodsNm : $('#bidGoodsNm3').val(),
				bidDemandNm : $('#bidDemandNm3').val(),
				bidBigo : $('#bidBigo3').val(),
				userId : $('#userId3').combogrid('getValue'),
				allYn :'Y'
			},
			onLoadSuccess : function(row, param) {
				if(row.rows.length==0){
					setBizInfoInit3();
				}else{
					$('#dg3').datagrid('selectRow', 0);
				}
			},
			onSelect : function(index, row){
				setBizInfo3(row);
			},
		});
	}
	
	
	//tab3 입찰관련정보 
	function setBizInfoInit3(){
		$("#tab3_notice_type").empty();
		$("#tab3_bid_notice_no").empty();
		$("#tab3_bid_notice_nm").empty();
		$("#tab3_noti_dt").empty();
		$("#tab3_order_agency_nm").empty();
		$("#tab3_bid_demand_nm").empty();
		$("#tab3_bid_cont_demand").empty();
		$("#tab3_nation_bid_yn").empty();
		$("#tab3_pre_price").empty();
		$("#tab3_base_price").empty();
		
		$("#tab3_detal1").empty();
		$("#tab3_detal2").empty();
		$("#tab3_detal3").empty();
		$("#tab3_detal4").empty();

		$('#tab3_column1').empty();
		$('#tab3_column2').empty();
		$('#tab3_column3').empty();
		$('#tab3_column4').empty();
		$('#tab3_column5').empty();
	    setBizGrid3('','');
	}
	
	//tab3 입찰관련정보 
	function setBizInfo3(row){
		setBizInfoInit3();
		$("#tab3_notice_type").text(row.notice_type);
		$("#tab3_bid_notice_no").text(row.bid_notice_no+"-"+row.bid_notice_cha_no);
		$("#tab3_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+row.notice_detail_link+"')\">상세보기</a>");
		$("#tab3_bid_notice_nm").text(row.bid_notice_nm);
		$("#tab3_noti_dt").text(formatDate(row.noti_dt));
		$("#tab3_order_agency_nm").append(formatEnter(row.order_agency_nm));
		$("#tab3_bid_demand_nm").append(formatEnter(row.demand_nm));
		$("#tab3_bid_cont_demand").text(row.contract_type_nm);
		$("#tab3_nation_bid_yn").text(row.nation_bid_yn);
		$("#tab3_pre_price").empty();
		$("#tab3_pre_price").append(numberComma(row.pre_price));
		$("#tab3_base_price").empty();
		$("#tab3_base_price").append(numberComma(row.base_price));
		
		
		$("#tab3_detal1").append(bid_info_detail1(row));
		$("#tab3_detal2").append(bid_info_detail2(row));
		$("#tab3_detal3").append(bid_info_detail3(row));
		$("#tab3_detal4").append(bid_info_detail4(row));
		
		//입찰사용자등록정보
		getBidDtl3(row.bid_notice_no,row.bid_notice_cha_no);
		
		//입찰 제조사 정보
		setBizGrid3(row.bid_notice_no,row.bid_notice_cha_no);
	}
	
	//tab3  상세정보
	function getBidDtl3(bidNoticeNo, bidNoticeChaNo){
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
					    $('#tab3_column1').text(json.rows[0].column1);
					    $('#tab3_column2').text(json.rows[0].column2_nm);
						$('#tab3_column3').text(json.rows[0].column3_nm);
					    $('#tab3_column4').text(json.rows[0].column4);
					    $('#tab3_column5').text(json.rows[0].column5);
				   }else{
					    $('#tab3_column1').empty();
					    $('#tab3_column2').empty();
					    $('#tab3_column3').empty();
					    $('#tab3_column4').empty();
					    $('#tab3_column5').empty();
				   }
				   
				   var status = false;
				   if(json.bidStatus !=null){
					   if(json.bidStatus.status_step=="1"){
						   if(json.bidStatus.status_cd1=="001"){
							   status = true;
						   }else{
							   status = false;
						   }
					   }else if(json.bidStatus.status_step=="2" || json.bidStatus.status_step=="3"){
						   status = false;
					   }
					   
					   if(json.bidStatus.status_cd1=="001"){
						   $("#apply1").text("승인대기");
					   }else if(json.bidStatus.status_cd1=="002"){
						   $("#apply1").text("승인");
					   }else if(json.bidStatus.status_cd1=="003"){
						   $("#apply1").text("반려");
					   }else{
						   $("#apply1").text("");
					   }
					   if(json.bidStatus.status_cd2=="001"){
						   $("#apply2").text("승인대기");
					   }else if(json.bidStatus.status_cd2=="002"){
						   $("#apply2").text("승인");
					   }else if(json.bidStatus.status_cd2=="003"){
						   $("#apply2").text("반려");
					   }else{
						   $("#apply2").text("");
					   }
					   if(json.bidStatus.status_cd3=="001"){
						   $("#apply3").text("승인대기");
					   }else if(json.bidStatus.status_cd3=="002"){
						   $("#apply3").text("승인");
					   }else if(json.bidStatus.status_cd3=="003"){
						   $("#apply3").text("반려");
					   }else{
						   $("#apply3").text("");
					   }
				   }else{
					   status = true;
					   $("#apply1").text("");
					   $("#apply2").text("");
					   $("#apply3").text("");
				   }
				   var row = $("#dg3").datagrid('getSelected');
				   if(row.user_id=='<%=loginId%>'){
						$("#applyBtn").css("display","");
					   if(status){
						   $("#applyBtn").css("display","");
						   $("#applySaveBtn").css("display","");
					   }else{
						   $("#applyBtn").css("display","none");
						   $("#applySaveBtn").css("display","none");
					   }
					}else{
						$("#applyBtn").css("display","none");
					   if(status){
						   $("#applySaveBtn").css("display","");
					   }else{
						   $("#applySaveBtn").css("display","none");
					   }
					} 
			   }
		});
	}
	//tab3 제조사 조회
	function setBizGrid3(bidNoticeNo, bidNoticeChaNo){
		$("#bc3").datagrid({
			method : "GET",
			url : "<c:url value='/bid/selectEstimateList.do'/>",
			queryParams : {
				bid_notice_no :bidNoticeNo,
				bid_notice_cha_no : bidNoticeChaNo,
			},
			onLoadSuccess : function(row, param) {
				editIndex3 = undefined;
			}
		});
	}
	

	//tab4 조회
	function selectBidList4(){
		$("#dg4").datagrid({
			method : "GET",
			url : "<c:url value='/bid/bidConfirmList.do'/>",
			queryParams : {
				searchDateType :$('#searchDateType4').combobox('getValue'),
				bidStartDt :$('#bidStartDt4').datebox('getValue'),
				bidEndDt : $('#bidEndDt4').datebox('getValue'),
				bidNoticeNo : $('#searchBidType4').combobox('getValue')=="1"?$('#bidNoticeNo4').val():"",
				bidNoticeNm : $('#searchBidType4').combobox('getValue')=="2"?$('#bidNoticeNo4').val():"",
				bidAreaNm : $('#bidAreaNm4').val(),
				bidGoodsNm : $('#bidGoodsNm4').val(),
				bidDemandNm : $('#bidDemandNm4').val(),
				bidBigo : $('#bidBigo4').val(),
				userId : $('#userId4').combogrid('getValue'),
				allYn :'Y'
			},
			onLoadSuccess : function(row, param) {
				eventBtn();
				if(row.rows.length==0){
					setBizInfoInit4();
				}else{
					$('#dg4').datagrid('selectRow', 0);
				}
				
				$('.importantCheckbox').on('click',function(e){
					e.stopPropagation();
				    e.cancelBubble = true;   
				});
			},
			onSelect : function(index, row){
				$("input:radio[name='msgGrp'][value='']").prop("checked",true);
				setBizInfo4(row);
			},
		});
	}
	
	//tab4 입찰관련정보 
	function setBizInfoInit4(){
		$("#tab4_notice_type").empty();
		$("#tab4_bid_notice_no").empty();
		$("#tab4_bid_notice_nm").empty();
		$("#tab4_noti_dt").empty();
		$("#tab4_order_agency_nm").empty();
		$("#tab4_bid_demand_nm").empty();
		$("#tab4_bid_cont_demand").empty();
		$("#tab4_nation_bid_yn").empty();
		$("#tab4_pre_price").empty();
		$("#tab4_base_price").empty();
		
		$("#tab4_detal1").empty();
		$("#tab4_detal2").empty();
		$("#tab4_detal3").empty();
		$("#tab4_detal4").empty();

		$('#tab4_column1').empty();
		$('#tab4_column2').empty();
		$('#tab4_column3').empty();
		$('#tab4_column4').empty();
		$('#tab4_column5').empty();

	    setBizGrid4('','');
	}
	
	//tab4 입찰관련정보 
	function setBizInfo4(row){
		setBizInfoInit4();
		$("#tab4_notice_type").text(row.notice_type);
		$("#tab4_bid_notice_no").text(row.bid_notice_no+"-"+row.bid_notice_cha_no);
		$("#tab4_bid_notice_no").append(" <a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"popupDetail('"+row.notice_detail_link+"')\">상세보기</a>");
		$("#tab4_bid_notice_nm").text(row.bid_notice_nm);
		$("#tab4_noti_dt").text(formatDate(row.noti_dt));
		$("#tab4_order_agency_nm").append(formatEnter(row.order_agency_nm));
		$("#tab4_bid_demand_nm").append(formatEnter(row.demand_nm));
		$("#tab4_bid_cont_demand").text(row.contract_type_nm);
		$("#tab4_nation_bid_yn").text(row.nation_bid_yn);
		$("#tab4_pre_price").empty();
		$("#tab4_pre_price").append(numberComma(row.pre_price));
		$("#tab4_base_price").empty();
		$("#tab4_base_price").append(numberComma(row.base_price));
		
		
		$("#tab4_detal1").append(bid_info_detail1(row));
		$("#tab4_detal2").append(bid_info_detail2(row));
		$("#tab4_detal3").append(bid_info_detail3(row));
		$("#tab4_detal4").append(bid_info_detail4(row));
		
		
		//입찰사용자등록정보
		getBidDtl4(row.bid_notice_no,row.bid_notice_cha_no);

		//입찰 투찰사 정보
		setBizGrid4(row.bid_notice_no,row.bid_notice_cha_no);
	}
	
	//tab4  상세정보
	function getBidDtl4(bidNoticeNo, bidNoticeChaNo){
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
					    $('#tab4_column1').text(json.rows[0].column1);
					    $('#tab4_column2').text(json.rows[0].column2_nm);
						$('#tab4_column3').text(json.rows[0].column3_nm);
					    $('#tab4_column4').text(json.rows[0].column4);
					    $('#tab4_column5').text(json.rows[0].column5);
				   }else{
					    $('#tab4_column1').empty();
					    $('#tab4_column2').empty();
					    $('#tab4_column3').empty();
					    $('#tab4_column4').empty();
					    $('#tab4_column5').empty();
				   }
			   }
		});
	}
	
	//tab4 투찰사 조회
	function setBizGrid4(bidNoticeNo, bidNoticeChaNo){
		$("#bc4").datagrid({
			method : "GET",
			url : "<c:url value='/bid/selectBusinessList.do'/>",
			queryParams : {
				bid_notice_no :bidNoticeNo,
				bid_notice_cha_no : bidNoticeChaNo
			},
			onLoadSuccess : function(row, param) {
				editIndex4 = undefined;
			}
		});
	}

	function getBusinessList(){
		$("#s_area_cd2").combobox("setValue","");
		$("#s_scale_cd2").combobox("setValue","");
		$("#s_credit_cd2").combobox("setValue","");
		
		var row = $("#dg4").datagrid('getSelected');
		if (!row) {
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
		
		$("#businessTb").datagrid({
			method : "GET",
			url : "<c:url value='/bid/businessList.do'/>",
			queryParams : {
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				s_business_nm : $("#s_business_nm2").textbox("getValue"),
				s_company_type : $("#s_company_type2").textbox("getValue"),
				s_goods_type : $("#s_goods_type2").textbox("getValue"),
				s_area_cd : $("#s_area_cd2").combobox("getValue"),
				s_scale_cd : $("#s_scale_cd2").combobox("getValue"),
				s_credit_cd : $("#s_credit_cd2").combobox("getValue"),
				s_area_txt : $("#s_area_txt2").textbox("getValue")
			},
			onLoadSuccess : function(row, param) {
				
 			   $("#addTab4SaveBtn1").css("display","");
			   $("#addTab4SaveBtn2").css("display","none");
				
				$('#businessList').dialog('open');
				
				
				eventBtn();
			}
		});
		
	}
	function getBusinessList2(){
		
		var row = $("#dg3").datagrid('getSelected');
		if (!row) {
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
		
		$("#businessTb").datagrid({
			method : "GET",
			url : "<c:url value='/bid/businessList.do'/>",
			queryParams : {
				bid_notice_no : row.bid_notice_no,
				bid_notice_cha_no : row.bid_notice_cha_no,
				s_business_nm : $("#s_business_nm2").textbox("getValue"),
				s_company_type : $("#s_company_type2").textbox("getValue"),
				s_goods_type : $("#s_goods_type2").textbox("getValue"),
				s_area_cd : $("#s_area_cd2").combobox("getValue"),
				s_scale_cd : $("#s_scale_cd2").combobox("getValue"),
				s_credit_cd : $("#s_credit_cd2").combobox("getValue"),
				s_area_txt : $("#s_area_txt2").textbox("getValue")
			},
			onLoadSuccess : function(row, param) {
				
				$("#addTab4SaveBtn1").css("display","none");
			    $("#addTab4SaveBtn2").css("display","");
				
				$('#businessList').dialog('open');
				
				eventBtn();
			}
		});
		
	}
	
	function tab4_save2(){
		var row = $("#dg4").datagrid('getSelected');
		var addData=$('#businessTb').datagrid('getChecked');
		
		if(addData==null || addData.length==0){
			$.messager.alert("알림", "등록할 투찰사를 선택하세요.");
			return;
		}
		
		$.messager.confirm('알림', '등록하시겠습니까?', function(r){
	        if (r){
	        	$('#businessList').dialog('close');
	    		
	    		var effectRow = new Object();
	    		if (row) {
	    			effectRow["bid_notice_no"] = row.bid_notice_no;
	    			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
	    		}
	    		if (addData.length) {
	    			effectRow["addData"] = JSON.stringify(addData);
	    		}
	    		
	    		$.post("<c:url value='/bid/insertBusinessRelList.do'/>", effectRow, function(rsp) {
	    			if(rsp.status){
	    				$.messager.alert("알림", "저장하였습니다.");
	    				setBizGrid4(row.bid_notice_no, row.bid_notice_cha_no)
	    			}
	    		}, "JSON").error(function() {
	    			$.messager.alert("알림", "저장에러！");
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
		
		$.messager.confirm('알림', '추가하시겠습니까?', function(r){
	        if (r){
	    		
    			for(var i=0;i<addData.length;i++){
   	    			var isNo = false;
   	    			var msgData=$('#businessMsgTb').datagrid('getRows');
   					for(var j=0;j<msgData.length;j++){
    					
		    			if(addData[i].business_no == msgData[j].business_no){
		    				isNo = true;
		    			}
    				}

	    			if(!isNo){
	    				$('#businessMsgTb').datagrid('insertRow',{
	    					index: 1,	// index start with 0
	    					row: {
	    						business_no: addData[i].business_no,
		    					company_nm: addData[i].company_nm,
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
	        
		});
	}
	
	function sendGoodsMsg(){

		$('#sendMessage3').textbox('setValue','');
		var row = $("#dg3").datagrid('getSelected');
		var addData=$('#businessMsgTb').datagrid('getChecked');
		
		if(!row){
			$.messager.alert("알림", "공고를 선택하세요.");
			return;
		}
		if(addData==null || addData.length==0){
			$.messager.alert("알림", "투찰업체를 선택하세요.");
			return;
		}
		
		$('#sendMessageDlg3').dialog('open');
		
	}
	
	function messageType3(type){
		var row = $("#dg3").datagrid('getSelected');
		var message = ""
		if(type==1){
			message = "<투찰요청>\n\n"+
			"㈜인콘 입니다.\n"+
			"공고번호 : "+($('#tab3_bid_notice_no').text().replace("상세보기",""))+"\n"+
			"공고명 : "+($('#tab3_bid_notice_nm').text())+"\n\n"+
			"투찰추천금액 : <입력된 추천가격>"+"\n"+
			"비고 : <입력된 비고>\n"+
			"투찰마감일시 : "+formatDate(row.bid_end_dt)+" 까지\n"+
			"물품분류번호 : "+row.detail_goods_no+"("+row.detail_goods_nm+")\n\n"+
			"투찰 부탁드리겠습니다.\n"+
			"감사합니다.\n";
		}else if(type==2){
			message = "<입찰참가신청요청>\n\n"+
			"㈜인콘 입니다.\n"+
			"공고번호 : "+($('#tab3_bid_notice_no').text().replace("상세보기",""))+"\n"+
			"공고명 : "+($('#tab3_bid_notice_nm').text())+"\n"+
			"수요기관 : "+($('#tab3_bid_demand_nm').text())+"\n"+
			"입찰신청마감일시 : "+formatDate(row.bid_end_dt)+" 까지\n"+
			"비고 : <입력된 비고>\n\n"+
			"관련하여 입찰참가신청을 요청드립니다."+"\n\n"+
			"*국군조달사이트에서 참가신청하시면 됩니다."+"\n"+
			"- 첨부서류는 없습니다."+"\n"+
			"- 입찰보증금 면제로 입찰보증금 지급확약서 내용에 동의함으로써 갈음합니다."+"\n\n"+
			"감사합니다."+"\n";
			
			
		}else if(type==3){
				message = "<물품분류번호등록요청>\n\n"+
				"㈜인콘 입니다.\n\n"+
				"물품분류번호 : "+row.detail_goods_no+"("+row.detail_goods_nm+")\n\n"+
				"등록을 요청드립니다."+"\n"+
				"감사합니다."+"\n";
		}
		$('#sendMessage3').textbox('setValue',message);
	}
		
		function sendMessage3(type){
			var title;
			var title2;
			if(type=="email"){
				title ="메일을";
				title2 ="메일";
			}else{
				title ="SMS를";
				title2 ="SMS";
			}
			var message = $('#sendMessage3').textbox('getValue');
			if(message==null || message.length==0){
				$.messager.alert("알림", title2+" 문구를 등록하세요.");
				return;
			}
			
			var row = $("#dg3").datagrid('getSelected');
			var addData=$('#businessMsgTb').datagrid('getChecked');
			
			$.messager.confirm('알림', '선택하신 업체에 '+title+' 발송하시겠습니까?', function(r){
	            if (r){
	            	$('#sendMessageDlg3').dialog('close');
	            	
	        		
	        		var effectRow = new Object();
	        		if (row) {
	        			effectRow["bid_notice_no"] = row.bid_notice_no;
	        			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
	        		}
	        		
	        		effectRow["message_type"] = type;
	        		if (addData.length) {
	        			effectRow["addData"] = JSON.stringify(addData);
	        		}
	        		effectRow["send_message"] = $("#sendMessage3").textbox('getValue');
	        		
	        		$.post("<c:url value='/bid/sendBusinessMsg.do'/>", effectRow, 
	        			function(rsp) {
		        			if(rsp.status){
		        				$.messager.alert("알림", title+" 발송하였습니다.");
		        			}else{
			        			$.messager.alert("알림", title2+"발송에러！");
		        			}
		        		}, "JSON").error(function() {
		        			$.messager.alert("알림", title2+"발송에러！");
	        		});
	            }
	        });
		}
	
		//tab5 조회
		function selectBidList5(){
			$("#dg5").datagrid({
				method : "GET",
				url : "<c:url value='/bid/bidOpenResultList.do'/>",
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
// 				$("#tab5_detal2").append(bid_result_info_detail2(row));
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
					url : "<c:url value='/bid/bidOpenResultDetail.do'/>",
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
				   ,url: "<c:url value='/bid/bidOpenResultDetail.do'/>"
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
				   ,url: "<c:url value='/bid/bidOpenResultDetail.do'/>"
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
					url : "<c:url value='/bid/bidOpenResultDetail.do'/>",
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
					url : "<c:url value='/bid/bidOpenResultPriceDetail.do'/>",
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
					url : "<c:url value='/bid/bidOpenResultPriceDetail.do'/>",
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
			   ,url: "<c:url value='/bid/updateBidResult.do'/>"
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

					$.post("<c:url value='/bid/getBidResultInfoApi.do'/>", effectRow, function(rsp) {
						if(rsp.status){
							selectBidList();
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
		 
		 
		 
		//tab6 조회
		function selectBidList6(){
			$("#dg6").datagrid({
				method : "GET",
				url : "<c:url value='/bid/selectSendMsgList.do'/>",
				queryParams : {
					bidEndDt : $('#bidEndDt6').datebox('getValue'),
					bidNoticeNo : $('#searchBidType6').combobox('getValue')=="1"?$('#bidNoticeNo6').val():"",
					bidNoticeNm : $('#searchBidType6').combobox('getValue')=="2"?$('#bidNoticeNo6').val():"",
					companyNm : $('#searchBidType6').combobox('getValue')=="3"?$('#bidNoticeNo6').val():""
				},
				onLoadSuccess : function(row, param) {
					if(row.rows.length==0){
						$('#sendMsg').textbox('setValue',"");
					}else{
						$('#dg6').datagrid('selectRow', 0);
						$('#dg6').datagrid('fixColumnSize');
					}
				},
				onSelect : function(index, row){
					$('#sendMsg').textbox('setValue',row.message);
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
 
	<div id="mainwrap" style="display: block;">
		<div id="content">
			<div style="margin: 1px 0; vertical-align: top"></div>
			<div class="easyui-layout" style="width: 100%; height: 800px; vertical-align: top;">
				<div data-options="region:'center'">
					<div id="maintab" class="easyui-tabs" data-options="fit:true,border:false,plain:true">
						<div title="물품공고현황" style="padding: 5px">
							<div class="easyui-layout" style="width:100%;height:750px;">
							    <div data-options="region:'north',border:false">
							    	<table style="width: 100%;">
										<tr>
											<td class="bc">공고</td>
											<td>
												<select class="easyui-combobox" id="searchBidType" data-options="panelHeight:'auto'" style="width:100px;">
												        <option value="1">공고번호</option>
												        <option value="2">공고명</option>
												</select>
												<input type="text" class="easyui-textbox" id="bidNoticeNo" style="width: 120px;">
											</td>
											<td class="bc">지역</td>
											<td>
												<input type="text" class="easyui-textbox" id="bidAreaNm" style="width: 120px;">
											</td>
											<td class="bc">검색일</td>
											<td>
												<select class="easyui-combobox" id="searchDateType" data-options="panelHeight:'auto'"  style="width:100px;">
												        <option value="1">공고게시일</option>
												        <option value="2">입찰개시일</option>
												        <option value="3">입찰마감일</option>
												</select>
		
											</td>
											<td><input class="easyui-datebox" id="bidStartDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
												~ <input class="easyui-datebox" id="bidEndDt"  style="width:100px;"	data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											</td>
											<td class="bc">수요처</td>
											<td><input type="text" class="easyui-textbox" id="bidDemandNm" style="width: 150px;"></td>
											<td class="bc">물품명</td>
											<td><input type="text" class="easyui-textbox" id="bidGoodsNm" style="width: 150px;"></td>
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
											<td class="bc">비고내용</td>
											<td><input type="text" class="easyui-textbox" id="bidBigo" style="width: 150px;"></td>
											<td width="200px">
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList()">조회</a> 
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">저장</a>
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload'" onclick="$('#bidInfoDlg').dialog('open');">공고갱신</a>
											</td>
										</tr>
									</table>
							    </div>
							    <div data-options="region:'south',split:true,border:false" style="height:300px;">
									<div class="easyui-layout" style="width: 100%; height: 100%;">
										<div data-options="region:'west',collapsible:false" title="입찰관련정보" style="width: 50%;">
												<form id="tab1_left_form" method="post" >
												<font style="font-weight: bold; padding-left: 10px;"> [ 공고일반 ] </font>
												<table cellpadding="5" style="width: 100%; padding: 10px;">
													<tr>
														<td class="bc" style="width: 20%;">공고종류</td>
														<td style="width: 30%;"><font id="tab1_notice_type"></font></td>
														<td class="bc" style="width: 20%;">게시일시</td>
														<td style="width: 30%;"><font id="tab1_noti_dt"></font></td>
													</tr>
													<tr>
														<td class="bc" style="width: 20%;">공고번호</td>
														<td colspan="3" style="width: 80%;"><font id="tab1_bid_notice_no"></font></td>
													</tr>
													<tr>
														<td class="bc">공고명</td>
														<td colspan="3" ><font id="tab1_bid_notice_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">공고기관</td>
														<td><font id="tab1_order_agency_nm"></font></td>
														<td class="bc">수요기관</td>
														<td><font id="tab1_bid_demand_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">계약방법</td>
														<td><font id="tab1_bid_cont_demand"></font></td>
														<td class="bc">국제입찰구분</td>
														<td><font id="tab1_nation_bid_yn"></font></td>
													</tr>
													<tr>
														<td class="bc">추정가격</td>
														<td><font id="tab1_pre_price"></font></td>
														<td class="bc">기초금액</td>
														<td><font id="tab1_base_price"></font></td>
													</tr>
													<tr>
														<td class="bc">낙찰하한율</td>
														<td><font id="tab1_column5"></font> %</td>
													</tr>
												</table>
												<div id="tab1_detal1"></div>
												<div id="tab1_detal2"></div>
												<div id="tab1_detal3"></div>
												<div id="tab1_detal4"></div>
											</form>
										</div>
										<div data-options="region:'east',collapsible:false"
											title="입찰가격" style="width: 50%;">
											<form id="tab1_right_form" method="post">
												<table cellpadding="5" style="width: 100%;padding:10px">
													<tr>
														<td class="bc" style="width: 20%;">기초금액</td>
														<td style="width: 80%;"><font id="tab1_base_price2"></font></td>
													</tr>
													<tr>
														<td class="bc">예정가격</td>
														<td><font id="tab1_pre_price"></font></td>
													</tr>
													<tr>
														<td class="bc">낙찰하한율</td>
														<td><input id="tab1_success_per"
															class="easyui-numberbox" data-options="width:100,min:0,max:100,precision:3,onChange:onChgVal" /> %</td>
													</tr>
													<tr>
														<td class="bc">투찰기준금액</td>
														<td><input id="tab1_result_price"
															class="easyui-numberbox" data-options="width:100,disabled:true" /></td>
													</tr>
													<tr>
														<td class="bc">예정가격/기초금액</td>
														<td><input id="tab1_pre_per" class="easyui-numberbox"
															data-options="width:100,min:0,max:200,precision:3,onChange:onChgVal" /> %</td>
													</tr>
												</table>
												
											</form>
										</div>
									</div>
							    </div>
							    <div data-options="region:'center',border:false">
							    	<table id="dg" class="easyui-datagrid"
										style="width: 100%; height: 100%"
										data-options="rownumbers:true,
													  singleSelect:true,
													  pagination:true,
													  pageSize:30,
													  method:'get',
													  striped:true,
													  nowrap:false,
													  sortName:'noti_dt',
													  sortOrder:'desc',
													  onClickCell:onClickCell,
													  onEndEdit:onEndEdit,
													  onBeforeEdit:onBeforeEdit,
													  pageList:[30,50,70,100,150,200,500],
													  rowStyler: function(index,row){
										                    if (row.finish_status=='F'){
										                        return 'background-color:#eeeeee;color:#999999;';
										                    }
										              }">
										<thead>
											<tr>
		<!-- 										<th data-options="field:'ck',checkbox:true"></th> -->
		
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
											                        }">담당자</th>
												<th data-options="field:'permit_biz_type_info',halign:'center',width:200" formatter="bidLicense">업종제한</th>
												<th data-options="field:'product_yn',align:'center',halign:'center',width:40,resizable:true">제조<br/>제한</th>
												<th data-options="field:'nation_bid_yn',align:'center',halign:'center',width:40">국제<br/>입찰</th>
												<th data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true"	formatter="formatNoticeNo">공고번호</th>
												<th data-options="field:'bid_notice_nm',align:'left',width:300,halign:'center',sortable:true" formatter="formatNoticeNm">공고명</th>
												<th data-options="field:'demand_nm',align:'left',width:150 ,halign:'center',sortable:true" formatter="formatEnter">수요처</th>
												<th	data-options="field:'bid_method',align:'left',width:100 ,halign:'center'">입찰방식</th>
												<th	data-options="field:'contract_type_nm',align:'left',width:100 ,halign:'center'">계약방법</th>
												<th data-options="field:'detail_goods_nm',align:'left',width:100 ,halign:'center'">물품명</th>
												<th data-options="field:'use_area_info',align:'left',width:100 ,halign:'center'" formatter="formatCommaEnter">지역</th>
												<th data-options="field:'pre_price',align:'right',width:100 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
												<th data-options="field:'base_price',align:'right',width:100 ,halign:'center',editor:{type:'numberbox',options:{groupSeparator:','}}" formatter="numberComma">기초금액</th>
												<th data-options="field:'base_price2',align:'center',width:80 ,halign:'center'" formatter="formatRowButton2">기초금액<br/>가져오기</th>
<!-- 												<th data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th> -->
<!-- 												<th data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰개시일시</th> -->
												<th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="bidFormatDate">입찰개시일시<br/>입찰마감일시</th>
												<th data-options="field:'bigo',align:'left',width:150 ,halign:'center',editor:'textbox'">비고</th>
											</tr>
										</thead>
									</table>
							    </div>
							</div>

							<div id="cc" class="easyui-calendar"></div>

							<script type="text/javascript">
								function onChgVal(){
									var base = $("#tab1_base_price2").text();
									var column5 = $("#tab1_success_per").textbox("getValue");
									var column6 = $("#tab1_pre_per").textbox("getValue");
									
									if(base.length>0){
										base = base.replaceAll(",","");
										var result = base * (column5/100) * (column6/100)
										$("#tab1_result_price").textbox("setValue",numberComma(result));
									}
									
								}
							
								function eventBtn() {
									$('#dg').datagrid('getPanel').find("[type='noti']").each(function(index) {
										$(this).linkbutton({
											onClick : function() {
											}
										})
									});

									$('#dg').datagrid('getPanel').find("[type='value']").each(function(index) {
										$(this).linkbutton({
											onClick : function() {
												var bid_notice_no = $(this).attr('val');
											}
										})
									});
									
									$('#manufactureTb').datagrid('getPanel').find("[type='company_type']").each(function(index){
										$(this).linkbutton({
											onClick:function(){
												var business_no = $(this).attr('val');
												$("#business_no").val(business_no);
												getCompanyTypeList();
											}
										})
									});
									$('#manufactureTb').datagrid('getPanel').find("[type='goods_type']").each(function(index){
										$(this).linkbutton({
											onClick:function(){
												var business_no = $(this).attr('val');
												$("#business_no").val(business_no);
												getGoodsTypeList();
											}
										})
									});
									$('#businessTb').datagrid('getPanel').find("[type='company_type']").each(function(index){
										$(this).linkbutton({
											onClick:function(){
												var business_no = $(this).attr('val');
												$("#business_no").val(business_no);
												getCompanyTypeList();
											}
										})
									});
									$('#businessTb').datagrid('getPanel').find("[type='goods_type']").each(function(index){
										$(this).linkbutton({
											onClick:function(){
												var business_no = $(this).attr('val');
												$("#business_no").val(business_no);
												getGoodsTypeList();
											}
										})
									});
									
									$('#dg2').datagrid('getPanel').find("[type='value']").each(function(index) {
										$(this).linkbutton({
											onClick : function() {
												var bid_notice_no = $(this).attr('val');
											}
										})
									});
									
									
									
									 $('#dg4').datagrid('getPanel').find("[type='report_type']").each(function(index){
											$(this).linkbutton({
												onClick:function(){
													var business_no = $(this).attr('val');
													$("#business_no").val(business_no);
													
													$('#reportDlg').dialog('open');
													
													var row = $("#dg4").datagrid("selectRow",index);
													var row = $("#dg4").datagrid("getSelected");
													
													setReportInfo(row);
												}
											})
									});

									 $('#dg4').datagrid('getPanel').find("[type='range_type']").each(function(index){
											$(this).linkbutton({
												onClick:function(){
													var row = $("#dg4").datagrid("selectRow",index);
													getRange();
												}
											})
									});
									
									 $('#dg5').datagrid('getPanel').find("[type='report_type']").each(function(index){
											$(this).linkbutton({
												onClick:function(){
													var bid_notice_no = $(this).attr('val');
													
													setOpenResult(bid_notice_no, index);
												}
											})
										});
									
									
								}

								function formatRowButton2(val, row) {
									return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-upload'\" type=\"value\" val=\"\"></a>";
								}
								
								var editIndex = undefined;
								function endEditing() {
									if (editIndex == undefined) {
										return true
									}
									if ($('#dg').datagrid('validateRow',editIndex)) {
										$('#dg').datagrid('endEdit', editIndex);
										editIndex = undefined;
										return true;
									} else {
										return false;
									}
								}
								function onClickCell(index, field) {
									if (field == "base_price2") {
										editIndex = index;
										$('#dg').datagrid('selectRow', index);
										var row = $('#dg').datagrid('getSelected');

										var effectRow = new Object();
										if (row) {
											effectRow["noti_dt"] = row.noti_dt;
											effectRow["bid_notice_no"] = row.bid_notice_no;
										}
										$.post("<c:url value='/bid/updateBidBaseAmount.do'/>",effectRow,
											function(rsp) {
												if (rsp.status) {
													$.messager.alert("알림","해당공고의 기초금액을 등록하였습니다.<br/>미등록시 재요청하시거나 <br/>수기로 등록하시기 바랍니다.");
													$('#dg').datagrid('reload');
												}
											}, "JSON").error(
											function() {
												$.messager.alert("알림","승인요청에러！");
										});
										return;
									}

									// 							           if (editIndex != index){
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
									eventBtn();
									// 							           }
								}
								function onEndEdit(index, row) {
									var ed = $(this).datagrid('getEditor', {
										index : index,
										field : 'user_id'
									});
									row.user_nm = $(ed.target).combobox('getText');
								}
								function onBeforeEdit(index, row) {
									row.editing = true;
									$(this).datagrid('refreshRow', index);
								}

								function save() {
									$.messager.confirm('알림','저장하시겠습니까?',
										function(r) {
											if (r) {
												if (endEditing()) {
													var $dg = $('#dg');

													if ($dg.datagrid('getChanges').length) {
														var deleted = $dg.datagrid('getChanges',"deleted");
														var updated = $dg.datagrid('getChanges',"updated");

														var effectRow = new Object();
														if (deleted.length) {
															effectRow["deleted"] = JSON.stringify(deleted);
														}
														if (updated.length) {
															effectRow["updated"] = JSON.stringify(updated);
														}
														$.post("<c:url value='/bid/updateBidList.do'/>",effectRow,
															function(rsp) {
																if (rsp.status) {
																	$.messager.alert("알림","저장하였습니다.");
																	$dg.datagrid('acceptChanges');
																	selectBidList();
																}
															},"JSON").error(
															function() {
																$.messager.alert("알림","저장에러！");
														});
													}
												}
											}
										});
								}

								function onChgColumn2(str){
									$("#column5").textbox("setValue",str.bigo);
									onChgColumn5();
								}
								function onChgColumn5(){
									var base = $("#tab2_base_price").text();
									var column5 = $("#column5").textbox("getValue");
									var column6 = $("#column6").textbox("getValue");
									
									if(base.length>0){
										base = base.replaceAll(",","");

										var result = base * (column5/100) * (column6/100)
										
										$("#column1").textbox("setValue",numberComma(result));
									}
									
								}
							</script>


							<form id="excelForm" name="excelForm" method="post"
								enctype="multipart/form-data"
								action="<c:url value='/excelUploadController.do'/>">
								<input type="hidden" name="method" value="updateTable4" />
								<input type="hidden" id="p_columList" name="p_columList" /> <input
									type="hidden" id="p_ruleList" name="p_ruleList" /> <input
									type="hidden" id="modify" name="modify" value="N" />
								<!-- 								<div style="width:100%;text-align: right; margin-top: 5px;"> -->
								<!-- 						            <input id="file" class="easyui-filebox" name="excelfile" data-options="buttonText:'파일찾기',buttonIcon:'icon-search',prompt:'업로드할 엑셀파일을 첨부해주세요.'" style="width:450px;height:24px;"> -->
								<!-- 									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'"  onclick="excelUpdate('N',this.value)" >엑셀파일저장</a> -->
								<!-- 								</div> -->
							</form>
						</div>
						<div title="견적요청" style="padding: 5px">
							<div class="easyui-layout" style="width:100%;height:750px;">
								<div data-options="region:'north',border:false">
									<table style="width: 100%">
										<tr>
											<td class="bc">공고</td>
											<td>
												<select class="easyui-combobox" id="searchBidType2"  data-options="panelHeight:'auto'" style="width:100px;">
												        <option value="1">공고번호</option>
												        <option value="2">공고명</option>
												</select>
												<input type="text" class="easyui-textbox" id="bidNoticeNo2" style="width: 120px;">
											</td>
											<td class="bc">지역</td>
											<td>
												<input type="text" class="easyui-textbox" id="bidAreaNm2" style="width: 120px;">
											</td>
											<td class="bc">검색일</td>
											<td>
												<select class="easyui-combobox" id="searchDateType2" data-options="panelHeight:'auto'" style="width:100px;">
												        <option value="1">공고게시일</option>
												        <option value="2">입찰개시일</option>
												        <option value="3">입찰마감일</option>
												</select>
											</td>
											<td><input class="easyui-datebox" id="bidStartDt2"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
												~ <input class="easyui-datebox" id="bidEndDt2"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											</td>
											<td class="bc">수요처</td>
											<td><input type="text" class="easyui-textbox" id="bidDemandNm2" style="width: 150px;"></td>
											<td class="bc">물품명</td>
											<td><input type="text" class="easyui-textbox" id="bidGoodsNm2" style="width: 150px;"></td>
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
											<td class="bc">비고내용</td>
											<td><input type="text" class="easyui-textbox" id="bidBigo2" style="width: 150px;">
											</td>
											<td width="200px">
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList2()">조회</a>
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save2()">저장</a>
											</td>
										</tr>
									</table>
								</div>
								<div data-options="region:'south',split:true,border:false" style="height:300px;">
									<div class="easyui-layout" style="width: 100%; height: 100%;">
										<div data-options="region:'west',collapsible:false" title="입찰관련정보" style="width: 50%;">
										<table style="width: 100%">
											<tr>
												<td align="right">
													<a
													href="javascript:void(0)" class="easyui-linkbutton"
													data-options="iconCls:'icon-save'" onclick="tab2_save()">저장</a>
												</td>
											</tr>
										</table>
										
										<form id="tab2_left_form" method="post" >
											<font style="font-weight: bold; padding-left: 10px;"> [ 공고일반 ] </font>
											<table cellpadding="5" style="width: 100%; padding: 10px;">
												<tr>
													<td class="bc" style="width: 20%;">공고종류</td>
													<td style="width: 30%;"><font id="tab2_notice_type"></font></td>
													<td class="bc" style="width: 20%;">게시일시</td>
													<td style="width: 30%;"><font id="tab2_noti_dt"></font></td>
												</tr>
												<tr>
													<td class="bc" style="width: 20%;">공고번호</td>
													<td colspan="3" style="width: 80%;"><font id="tab2_bid_notice_no"></font></td>
												</tr>
												<tr>
													<td class="bc">공고명</td>
													<td colspan="3" ><font id="tab2_bid_notice_nm"></font></td>
												</tr>
												<tr>
													<td class="bc">공고기관</td>
													<td><font id="tab2_order_agency_nm"></font></td>
													<td class="bc">수요기관</td>
													<td><font id="tab2_bid_demand_nm"></font></td>
												</tr>
												<tr>
													<td class="bc">계약방법</td>
													<td><font id="tab2_bid_cont_demand"></font></td>
													<td class="bc">국제입찰구분</td>
													<td><font id="tab2_nation_bid_yn"></font></td>
												</tr>
												<tr>
													<td class="bc">추정가격</td>
													<td><font id="tab2_pre_price"></font></td>
													<td class="bc">기초금액</td>
													<td><font id="tab2_base_price"></font></td>
												</tr>
												<tr>
													<td class="bc">투찰기준금액
													</td>
													<td><input id="column1" name="column1"
														class="easyui-numberbox" data-options="
														width:100,
														disabled:true,
														groupSeparator:','"
														formatter="numberComma" /></td>
													<td class="bc">사정율범위</td>
													<td>
														<input id="s_range" name="s_range"
														class="easyui-textbox" data-options="width:50" />
														~
														<input id="e_range" name="e_range"
														class="easyui-textbox" data-options="width:50"/> %
													</td>
												</tr>
												<tr>
													<td class="bc">적격정보</td>
													<td><input id="column2" name="column2"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
														onSelect:onChgColumn2,
												        valueField: 'cd',
												        textField: 'cd_nm',
												        data:jsonData3" />
													</td>
													<td class="bc">기업구분</td>
													<td><input id="column3" name="column3"
														class="easyui-combobox"
														data-options="
														method:'get',
														width:250,
														panelHeight:'auto',
												        valueField: 'cd',
												        textField: 'cd_nm',
														data:jsonData5" />
													</td>
												</tr>
												<tr>
													<td class="bc">낙찰하한율</td>
													<td>
														<input id="column5" name="column5" class="easyui-numberbox" data-options="precision:3,width:100,onChange:onChgColumn5"/> %
													</td>
													<td class="bc">예정가격/기초금액</td>
													<td>
														<input id="column6" name="column6" class="easyui-numberbox" data-options="onChange:onChgColumn5,precision:3,width:100,min:0,max:200"/> %
													</td>
												</tr>
												<tr>
													<td class="bc">담당자 의견</td>
													<td><input id="column4" name="column4" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 100px;" maxlength="1000" /></td>
												</tr>
											</table>
											<div id="tab2_detal1"></div>
											<div id="tab2_detal2"></div>
											<div id="tab2_detal3"></div>
											<div id="tab2_detal4"></div>
										</form>
									</div>
	
									<div data-options="region:'east',collapsible:false" title="제조사 정보" style="width: 50%;">
										<table style="width: 100%;height: 20px;">
											<tr>
												<td align="left">
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" id="addManufactureBtn" onClick="getManufactureList()">제조업체 추가</a>
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" id="delManufactureBtn" onClick="deleteManufactureList()">제조업체 삭제</a>
												</td>
												<td align="right">
													<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" id="manufactureSaveBtn" onClick="sendManufacture()">견적요청 보내기</a> 
												</td>
											</tr>
										</table>
										<div style="display: none;">
											<table class="easyui-datagrid"
													style="width:0px;height:0px;border: 0" 
													>
											</table>
										</div>
										<table id="bc2" class="easyui-datagrid" data-options="singleSelect:false,pagination:false,striped:true" style="width: 100%;height: 85%;">
											<thead>
												<tr>
													<th data-options="field:'send_yn',checkbox:true"></th>
													<th data-options="field:'business_no',align:'center',halign:'center',editor:'textbox'" width="70">No.</th>
													<th data-options="field:'company_nm',halign:'center',editor:'textbox'" width="150">제조업체명</th>
													<th	data-options="field:'send_dt',align:'left',halign:'center',editor:'textbox'" width="80">견적의뢰일</th>
													<th data-options="field:'company_no',align:'left',halign:'center',editor:'textbox'" width="100">사업자번호</th>
<!-- 													<th data-options="field:'delegate',align:'center',halign:'center',editor:'textbox'" width="80">대표자</th> -->
													<th data-options="field:'bidmanager',align:'center',halign:'center',editor:'textbox'" width="70">담당자</th>
													<th data-options="field:'phone_no',align:'left',halign:'center', editor:'textbox'" width="100">연락처</th>
													<th data-options="field:'mobile_no',align:'left',halign:'center', editor:'textbox'" width="100">휴대폰</th>
													<th data-options="field:'email',align:'left',halign:'center',editor:'textbox'" width="200">메일주소</th>
												</tr>
											</thead>
										</table>
									</div>
									</div>
								</div>
								<div data-options="region:'center',border:false">
									<table id="dg2" class="easyui-datagrid"
											style="width: 100%; height: 100%;"
											data-options="rownumbers:true,
														  singleSelect:true,
														  pagination:true,
														  resizeHandle:'both',
														  pageSize:30,
														  method:'get',
														  striped:true,
														  nowrap:false,
														  sortName:'noti_dt',
														  sortOrder:'desc',
														  onClickCell:onClickCell2,
														  onEndEdit:onEndEdit,
														  onBeforeEdit:onBeforeEdit,
													  	  pageList:[30,50,70,100,150,200,500],
														  rowStyler: function(index,row){
											                    if (row.finish_status=='F'){
											                        return 'background-color:#eeeeee;color:#999999;';
											                    }
											              }">
										<thead>
											<tr>
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
											                                panelHeight:'auto',
											                                data:jsonData,
											                                required:false
											                            }
											                        }">담당자</th>
											    <th data-options="field:'permit_biz_type_info',halign:'center',width:200" formatter="bidLicense">업종제한</th>
												<th data-options="field:'product_yn',align:'center',halign:'center',width:40,resizable:true">제조<br/>제한</th>
												<th data-options="field:'nation_bid_yn',align:'center',halign:'center',width:40">국제<br/>입찰</th>
												<th data-options="field:'bid_notice_no',halign:'center',width:150,sortable:true" formatter="formatNoticeNo">공고번호</th>
												<th data-options="field:'bid_notice_nm',align:'left',width:300,halign:'center',sortable:true" formatter="formatNoticeNm">공고명</th>
												<th data-options="field:'demand_nm',align:'left',width:150 ,halign:'center',sortable:true" formatter="formatEnter">수요처</th>
												<th	data-options="field:'bid_method',align:'left',width:100 ,halign:'center'">입찰방식</th>
												<th data-options="field:'contract_type_nm',align:'left',width:100 ,halign:'center'">계약방법</th>
												<th data-options="field:'detail_goods_nm',align:'left',width:100 ,halign:'center'">물품명</th>
												<th data-options="field:'use_area_info',align:'left',width:100 ,halign:'center'" formatter="formatCommaEnter">지역</th>
												<th data-options="field:'pre_price',align:'right',width:100 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
												<th data-options="field:'base_price',align:'right',width:100 ,halign:'center',editor:{type:'numberbox',options:{groupSeparator:','}}" formatter="numberComma">기초금액</th>
												<th data-options="field:'base_price2',align:'center',width:80 ,halign:'center'" formatter="formatRowButton2">기초금액<br/>가져오기</th>
<!-- 												<th data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th> -->
<!-- 												<th data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰개시일시</th> -->
												<th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="bidFormatDate">입찰개시일시<br/>입찰마감일시</th>
												<th data-options="field:'bigo',align:'left',width:150 ,halign:'center',editor:'textbox'">비고</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
							
							<script>
								var editIndex2 = undefined;
								function endEditing2() {
									if (editIndex2 == undefined) {
										return true
									}
									if ($('#dg2').datagrid('validateRow',editIndex2)) {
										$('#dg2').datagrid('endEdit', editIndex2);
										editIndex2 = undefined;
										return true;
									} else {
										return false;
									}
								}
								function onClickCell2(index, field) {
									if (field == "base_price2") {
										editIndex2 = index;
										$('#dg2').datagrid('selectRow', index);
										var row = $('#dg2').datagrid('getSelected');

										var effectRow = new Object();
										if (row) {
											effectRow["noti_dt"] = row.noti_dt;
											effectRow["bid_notice_no"] = row.bid_notice_no;
										}
										$.post("<c:url value='/bid/updateBidBaseAmount.do'/>",effectRow,
											function(rsp) {
												if (rsp.status) {
													$.messager.alert("알림","해당공고의 기초금액을 등록하였습니다.<br/>미등록시 재요청하시거나 <br/>수기로 등록하시기 바랍니다.");
													$('#dg2').datagrid('reload');
												}
											}, "JSON").error(
											function() {
												$.messager.alert("알림","승인요청에러！");
										});
										return;
									}
									
									if (endEditing2()) {
										$('#dg2').datagrid('selectRow', index)
												.datagrid('beginEdit', index);
										var ed = $('#dg2').datagrid('getEditor',{index : index,field : field});
										if (ed) {
											($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
										}
										editIndex2 = index;
									} else {
										setTimeout(function() {
											$('#dg2').datagrid('selectRow',editIndex);
										}, 0);
									}
									eventBtn();
								}
	
								function save2() {
									$.messager.confirm('알림','저장하시겠습니까?',
										function(r) {
											if (r) {
												if (endEditing2()) {
													var $dg = $('#dg2');
	
													if ($dg.datagrid('getChanges').length) {
														var deleted = $dg.datagrid('getChanges',"deleted");
														var updated = $dg.datagrid('getChanges',"updated");
	
														var effectRow = new Object();
														if (deleted.length) {
															effectRow["deleted"] = JSON.stringify(deleted);
														}
														if (updated.length) {
															effectRow["updated"] = JSON.stringify(updated);
														}
														$.post("<c:url value='/bid/updateBidList.do'/>",effectRow,
															function(rsp) {
																if (rsp.status) {
																	$.messager.alert("알림","저장하였습니다.");
																	$dg.datagrid('acceptChanges');
																	selectBidList2();
																}
															},"JSON").error(
															function() {
																$.messager.alert("알림","저장에러！");
														});
													}
												}
											}
										});
								}
								
								function deleteManufactureList() {
									var row = $("#dg2").datagrid('getSelected');
									var addData = $('#bc2').datagrid('getChecked');
									
									if(!row){
										$.messager.alert("알림", "공고를 선택하세요.");
										return;
									}
									if(addData==null || addData.length==0){
										$.messager.alert("알림", "제조업체를 선택하세요.");
										return;
									}

									$.messager.confirm('알림','삭제하시겠습니까?',
										function(r) {
											if (r) {

												if (endEditing2()) {
													var $dg = $("#bc2");

													if (addData.length) {
														var effectRow = new Object();
														if (row) {
															effectRow["bid_notice_no"] = row.bid_notice_no;
															effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
														}
														if (addData.length) {
															effectRow["addData"] = JSON.stringify(addData);
														}
														$.post("<c:url value='/bid/deleteManufactureist.do'/>",effectRow,
															function(rsp) {
																if (rsp.status) {
																	$.messager.alert("알림","삭제하였습니다.");
																	$('#bc2').datagrid('reload');
																}
															},"JSON").error(function() {
																$.messager.alert("알림","삭제에러！");
														});
													}
												}
											}
										});
								}
							
							</script>
						</div>
						<div title="견적관리" style="padding: 5px">
							<div class="easyui-layout" style="width:100%;height:750px;">
								<div data-options="region:'north',border:false">
									<table style="width: 100%">
										<tr>
											<td class="bc">공고</td>
											<td>
												<select class="easyui-combobox" id="searchBidType3" data-options="panelHeight:'auto'"  style="width:100px;">
												        <option value="1">공고번호</option>
												        <option value="2">공고명</option>
												</select>
												<input type="text" class="easyui-textbox" id="bidNoticeNo3" style="width: 120px;">
											</td>
											<td class="bc">지역</td>
											<td>
												<input type="text" class="easyui-textbox" id="bidAreaNm3" style="width: 120px;">
											</td>
											<td class="bc">검색일</td>
											<td>
												<select class="easyui-combobox" id="searchDateType3" data-options="panelHeight:'auto'" style="width:100px;">
												        <option value="1">공고게시일</option>
												        <option value="2">입찰개시일</option>
												        <option value="3">입찰마감일</option>
												</select>
											</td>
											<td><input class="easyui-datebox" id="bidStartDt3"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
												~ <input class="easyui-datebox" id="bidEndDt3"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											</td>
											<td class="bc">수요처</td>
											<td><input type="text" class="easyui-textbox" id="bidDemandNm3" style="width: 150px;"></td>
											<td class="bc">물품명</td>
											<td><input type="text" class="easyui-textbox" id="bidGoodsNm3" style="width: 150px;"></td>
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
											<td class="bc">비고내용</td>
											<td><input type="text" class="easyui-textbox" id="bidBigo3" style="width: 150px;"></td>
											<td width="200px"><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList3()">조회</a></td>
										</tr>
									</table>
								</div>
								<div data-options="region:'south',split:true,border:false" style="height:300px;">
									<div class="easyui-layout" style="width: 100%; height: 100%;">
										<div data-options="region:'west',collapsible:false" title="입찰관련정보" style="width: 50%;">
											<form id="tab3_left_form" method="post" >
												<font style="font-weight: bold; padding-left: 10px;"> [ 공고일반 ] </font>
												<table cellpadding="5" style="width: 100%; padding: 10px;">
													<tr>
														<td class="bc" style="width: 20%;">공고종류</td>
														<td style="width: 30%;"><font id="tab3_notice_type"></font></td>
														<td class="bc" style="width: 20%;">게시일시</td>
														<td style="width: 30%;"><font id="tab3_noti_dt"></font></td>
													</tr>
													<tr>
														<td class="bc" style="width: 20%;">공고번호</td>
														<td colspan="3" style="width: 80%;"><font id="tab3_bid_notice_no"></font></td>
													</tr>
													<tr>
														<td class="bc">공고명</td>
														<td colspan="3" ><font id="tab3_bid_notice_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">공고기관</td>
														<td><font id="tab3_order_agency_nm"></font></td>
														<td class="bc">수요기관</td>
														<td><font id="tab3_bid_demand_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">계약방법</td>
														<td><font id="tab3_bid_cont_demand"></font></td>
														<td class="bc">국제입찰구분</td>
														<td><font id="tab3_nation_bid_yn"></font></td>
													</tr>
													<tr>
														<td class="bc">추정가격</td>
														<td><font id="tab3_pre_price"></font></td>
														<td class="bc">기초금액</td>
														<td><font id="tab3_base_price"></font></td>
													</tr>
													<tr>
														<td class="bc">낙찰하한율</td>
														<td><font id="tab3_column5"></font> %</td>
														<td class="bc">투찰기준금액</td>
														<td><font id="tab3_column1"></font></td>
													</tr>
													<tr>
														<td class="bc">적격정보</td>
														<td><font id="tab3_column2"></font></td>
														<td class="bc">기업구분</td>
														<td><font id="tab3_column3"></font></td>
													</tr>
													<tr>
														<td class="bc">담당자 의견</td>
														<td><font id="tab3_column4"></font></td>
													</tr>
												</table>
												<div id="tab3_detal1"></div>
												<div id="tab3_detal2"></div>
												<div id="tab3_detal3"></div>
												<div id="tab3_detal4"></div>
											</form>
		
										</div>
		
		
										<div data-options="region:'east',collapsible:false"
											title="견적진행 및 승인" style="width: 50%;">
											<table style="width: 100%;height:10%">
												<tr>
													<td align="left">
														<table
															style="width: 550px; border-collapse: collapse; border: 1px; border-style: solid;">
															<tr style="border: 1px; border-style: solid; height: 50px;">
																<td class="bc" style="width: 80px; border: 1px; border-style: solid;">담당자</td>
																<td style="width: 100px; border: 1px; border-style: solid; text-align: center;">
																	<font id="apply1"></font>
																</td>
																<td class="bc" style="width: 80px; border: 1px; border-style: solid; text-align: center;">팀장</td>
																<td style="width: 100px; border: 1px; border-style: solid; text-align: center;">
																	<font id="apply2"></font>
																</td>
																<td class="bc" style="width: 80px; border: 1px; border-style: solid; text-align: center;">총괄책임</td>
																<td style="width: 100px; border: 1px; border-style: solid; text-align: center;">
																	<font id="apply3"></font>
																</td>
															</tr>
														</table>
													</td>
													<td align="right" style="vertical-align: bottom;">
<!-- 														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" id="businessGoodsBtn" onClick="businessGoods()">투찰사물품등록요청</a>  -->
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" id="businessGoodsBtn" onClick="businessGoods()">투찰사물품등록요청</a> 
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" id="applyBtn" name="applyBtn" onClick="subjectInfoDlg()">승인요청</a> 
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" id="applySaveBtn" name="applySaveBtn" onClick="save3()">저장</a>
													</td>
												</tr>
											</table>
											<table id="bc3" class="easyui-datagrid"
													data-options="singleSelect:false,pagination:false,striped:true,
													  onClickCell:onClickCell3,
													  onBeforeEdit:onBeforeEdit" style="width: 100%;height:75%">
												<thead>
													<tr>
														<th data-options="field:'ck',checkbox:true"></th>
														<th data-options="field:'business_no',align:'center',halign:'center'" width="70">No.</th>
														<th data-options="field:'company_nm',halign:'center'" width="150">제조업체명</th>
														<th data-options="field:'margin',align:'right',halign:'center',editor:{type:'numberbox',options:{groupSeparator:','}}" formatter="numberComma" width="120">견적금액</th>
														<th data-options="field:'bigo',halign:'center',editor:'textbox'" width="200">검토의견</th>
														<th data-options="field:'choice_reason',halign:'center',editor:'textbox'" width="200">지급조건</th>
														<th data-options="field:'choice_yn',align:'center',halign:'center',sortable:true,width:100,editor:{type:'checkbox',options:{on:'Y',off:'N'}}"  >선택업체</th>
													</tr>
												</thead>
											</table>
											<script>
												var editIndex3 = undefined;
											
												function endEditing3() {
													if (editIndex3 == undefined) {
														return true
													}
													if ($('#bc3').datagrid('validateRow', editIndex3)) {
														$('#bc3').datagrid('endEdit',editIndex3);
														editIndex3 = undefined;
														return true;
													} else {
														return false;
													}
												}
		
												function onClickCell3(index, field) {
													if (editIndex3 != index) {
														if (endEditing3()) {
															$('#bc3').datagrid('selectRow',index)
																	 .datagrid('beginEdit',index);
															var ed = $('#bc3').datagrid('getEditor',
																			{
																				index : index,
																				field : field
																			});
															if (ed) {
																($(ed.target).data('textbox') ? $(ed.target).textbox('textbox'): $(ed.target)).focus();
															}
															editIndex3 = index;
														} else {
															setTimeout(function() {
																$('#bc3').datagrid('selectRow',editIndex3);
															}, 0);
														}
													}
												}
		
												function sendApply() {
													var row = $("#dg3").datagrid('getSelected');
													$.messager.confirm('알림','해당업체로 승인요청 하시겠습니까?',
														function(r) {
															if (r) {
																var effectRow = new Object();
																if (row) {
																	effectRow["bid_notice_no"] = row.bid_notice_no;
																	effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
																	effectRow["status_step"] = "2";
																	effectRow["status_cd1"] = "002";
																	effectRow["status_cd2"] = "001";
																	effectRow["status_cd3"] = "";
																	
																	effectRow["bid_cont"] = $("#bid_cont").textbox('getValue');
																	effectRow["bid_term"] = $("#bid_term").textbox('getValue');
																	effectRow["bid_sp_cont"] = $("#bid_sp_cont").textbox('getValue');
																	effectRow["bid_tot_cont"] = $("#bid_tot_cont").textbox('getValue');
																	effectRow["bid_site"] = $("#bid_site").combobox('getValue');
																	effectRow["bid_risk"] = $("#bid_risk").combobox('getValue');
																	effectRow["info1_1"] = $("#info1_1").combobox('getValue');
																	effectRow["info1_2"] = $("#info1_2").combobox('getValue');
																	effectRow["info1_3"] = $("#info1_3").combobox('getValue');
																	effectRow["info1_4"] = $("#info1_4").combobox('getValue');
																	effectRow["info1_5"] = $("#info1_5").combobox('getValue');
																	effectRow["info1_6"] = $("#info1_6").combobox('getValue');
																	effectRow["info1_6t"] = $("#info1_6t").textbox('getValue');
																	effectRow["info1_1d"] = $("#info1_1d").textbox('getValue');
																	effectRow["info1_2d"] = $("#info1_2d").textbox('getValue');
																	effectRow["info1_3d"] = $("#info1_3d").textbox('getValue');
																	effectRow["info1_4d"] = $("#info1_4d").textbox('getValue');
																	effectRow["info1_5d"] = $("#info1_5d").textbox('getValue');
																	effectRow["info1_6d"] = $("#info1_6d").textbox('getValue');
																	effectRow["info1_7"] = $("#info1_7").textbox('getValue');
																	effectRow["info2_1"] = $("#info2_1").combobox('getValue');
																	effectRow["info2_2"] = $("#info2_2").combobox('getValue');
																	effectRow["info2_3"] = $("#info2_3").combobox('getValue');
																	effectRow["info2_4"] = $("#info2_4").combobox('getValue');
																	effectRow["info2_5"] = $("#info2_5").combobox('getValue');
																	effectRow["info2_5t"] = $("#info2_5t").textbox('getValue');
																	effectRow["info2_1d"] = $("#info2_1d").textbox('getValue');
																	effectRow["info2_2d"] = $("#info2_2d").textbox('getValue');
																	effectRow["info2_3d"] = $("#info2_3d").textbox('getValue');
																	effectRow["info2_4d"] = $("#info2_4d").textbox('getValue');
																	effectRow["info2_5d"] = $("#info2_5d").textbox('getValue');
																	effectRow["info2_6"] = $("#info2_6").textbox('getValue');
																	effectRow["info3"] = $("#info3").textbox('getValue');
																}
																$.post("<c:url value='/bid/updateApply.do'/>",effectRow,
																	function(rsp) {
																		if (rsp.status) {
																			$.messager.alert("알림","입찰공고를 승인요청하였습니다.");
																			$('#bc3').datagrid('reload');
																			$('#reportInfoDlg').dialog('close');
																			setBizInfo3(row);
																		}
																	},"JSON").error(function() {
																		$.messager.alert("알림","승인요청에러！");
																});
		
															}
													});
												}
												
												function cleanSubject(){
													
													$("#bid_cont").textbox('setValue',"");
													$("#bid_term").textbox('setValue',"");
													$("#bid_sp_cont").textbox('setValue',"");
													$("#bid_tot_cont").textbox('setValue',"");
												    $('#bid_site').combobox('setValue',"");
												    $('#bid_risk').combobox('setValue',"");

												    $('#info1_1').combobox('setValue',"");
												    $('#info1_2').combobox('setValue',"");
												    $('#info1_3').combobox('setValue',"");
												    $('#info1_4').combobox('setValue',"");
												    $('#info1_5').combobox('setValue',"");
												    $('#info1_6').combobox('setValue',"");
													$("#info1_6t").textbox('setValue',"");
													$("#info1_1d").textbox('setValue',"");
													$("#info1_2d").textbox('setValue',"");
													$("#info1_3d").textbox('setValue',"");
													$("#info1_4d").textbox('setValue',"");
													$("#info1_5d").textbox('setValue',"");
													$("#info1_6d").textbox('setValue',"");
													$("#info1_7").textbox('setValue',"");
												    $('#info2_1').combobox('setValue',"");
												    $('#info2_2').combobox('setValue',"");
												    $('#info2_3').combobox('setValue',"");
												    $('#info2_4').combobox('setValue',"");
												    $('#info2_5').combobox('setValue',"");
													$("#info2_5t").textbox('setValue',"");
													$("#info2_1d").textbox('setValue',"");
													$("#info2_2d").textbox('setValue',"");
													$("#info2_3d").textbox('setValue',"");
													$("#info2_4d").textbox('setValue',"");
													$("#info2_5d").textbox('setValue',"");
													$("#info2_6").textbox('setValue',"");
													$("#info3").textbox('setValue',"");
												}
												
												function subjectInfoDlg(){
													var row = $("#bc3").datagrid('getRows');
													if(row.length==0){
														$.messager.alert("알림", "승인요청할 업체를 등록해주세요.");
														return;
													}
													cleanSubject();
													
													$('#reportInfoDlg').dialog('open');
												}
												
												function businessGoods(){
													
													$("#s_area_cd3").combobox("setValue","");
													$("#s_scale_cd3").combobox("setValue","");
													$("#s_credit_cd3").combobox("setValue","");
													
													var row = $("#dg3").datagrid('getSelected');
													if (!row) {
														$.messager.alert("알림", "공고를 선택하세요.");
														return;
													}
													
													$('#businessMsgDlg').dialog('open');
													
													$("#businessMsgTb").datagrid({
														method : "GET",
														url : "<c:url value='/bid/selectBusinessList2.do'/>",
														queryParams : {
															bid_notice_no :row.bid_notice_no,
															bid_notice_cha_no : row.bid_notice_cha_no
														},
														onLoadSuccess : function(row, param) {
															
														}
													});
												}
												
												function businessGoodChgArea(){
													var row = $("#dg3").datagrid('getSelected');
													if (!row) {
														$.messager.alert("알림", "공고를 선택하세요.");
														return;
													}
													
													$("#businessMsgTb").datagrid({
														method : "GET",
														url : "<c:url value='/bid/selectBusinessList2.do'/>",
														queryParams : {
															bid_notice_no :row.bid_notice_no,
															bid_notice_cha_no : row.bid_notice_cha_no,
															s_area_cd : $("#s_area_cd3").combobox("getValue"),
															s_scale_cd : $("#s_scale_cd3").combobox("getValue"),
															s_credit_cd : $("#s_credit_cd3").combobox("getValue")
														},
														onLoadSuccess : function(row, param) {
														}
													});
												}
		
												function save3() {
													var row = $("#dg3").datagrid('getSelected');
													var addData = $('#bc3').datagrid('getChecked');
		
													$.messager.confirm('알림','저장하시겠습니까?',
														function(r) {
															if (r) {
		
																if (endEditing3()) {
																	var $dg = $("#bc3");
		
																	if ($dg.datagrid('getChanges').length) {
																		var updated = $dg.datagrid('getChanges',"updated");
		
																		var effectRow = new Object();
																		if (row) {
																			effectRow["bid_notice_no"] = row.bid_notice_no;
																			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
																		}
																		if (updated.length) {
																			effectRow["addData"] = JSON
																					.stringify(updated);
																		}
																		$.post("<c:url value='/bid/updateEstimateList.do'/>",effectRow,
																			function(rsp) {
																				if (rsp.status) {
																					$.messager.alert("알림","저장하였습니다.");
																					$dg.datagrid('acceptChanges');
																					$('#bc3').datagrid('reload');
																					setBizInfo3(row);
																				}
																			},"JSON").error(function() {
																				$.messager.alert("알림","저장에러！");
																		});
																	}
																}
															}
														});
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
								</div>
								<div data-options="region:'center',border:false">
									<table id="dg3" class="easyui-datagrid"
											style="width: 100%; height: 100%;"
											data-options="rownumbers:true,
														  singleSelect:true,
														  pagination:true,
														  pageSize:30,
														  method:'get',
														  striped:true,
														  nowrap:false,
														  sortName:'noti_dt',
														  sortOrder:'desc',
													  	  pageList:[30,50,70,100,150,200,500],
														  rowStyler: function(index,row){
											                    if (row.finish_status=='F'){
											                        return 'background-color:#eeeeee;color:#999999;';
											                    }
											              }">
										<thead>
											<tr>
												<th data-options="field:'user_nm',align:'center',halign:'center',width:70">담당자</th>
												<th data-options="field:'permit_biz_type_info',halign:'center',width:200" formatter="bidLicense">업종제한</th>
												<th data-options="field:'product_yn',align:'center',halign:'center',width:40,resizable:true">제조<br/>제한</th>
												<th data-options="field:'nation_bid_yn',align:'center',halign:'center',width:40">국제<br/>입찰</th>
												<th data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true" formatter="formatNoticeNo">공고번호</th>
												<th data-options="field:'bid_notice_nm',align:'left',width:300,halign:'center',sortable:true" formatter="formatNoticeNm">공고명</th>
												<th data-options="field:'demand_nm',align:'left',width:150 ,halign:'center',sortable:true" formatter="formatEnter">수요처</th>
												<th	data-options="field:'bid_method',align:'left',width:100 ,halign:'center'">입찰방식</th>
												<th data-options="field:'contract_type_nm',align:'left',width:100 ,halign:'center'">계약방법</th>
												<th data-options="field:'detail_goods_nm',align:'left',width:100 ,halign:'center'">물품명</th>
												<th data-options="field:'use_area_info',align:'left',width:100 ,halign:'center'" formatter="formatCommaEnter">지역</th>
												<th data-options="field:'pre_price',align:'right',width:100 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
												<th data-options="field:'base_price',align:'right',width:100 ,halign:'center'" formatter="numberComma">기초금액</th>
<!-- 												<th data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th> -->
<!-- 												<th data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰개시일시</th> -->
												<th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="bidFormatDate">입찰개시일시<br/>입찰마감일시</th>
												<th data-options="field:'bigo',align:'left',width:200 ,halign:'center'">비고</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
						<div title="투찰관리" style="padding: 5px">
							<div class="easyui-layout" style="width:100%;height:750px;">
								<div data-options="region:'north',border:false">
									<table style="width: 100%">
										<tr>
											<td class="bc">공고</td>
											<td>
												<select class="easyui-combobox" id="searchBidType4" data-options="panelHeight:'auto'"  style="width:100px;">
												        <option value="1">공고번호</option>
												        <option value="2">공고명</option>
												</select>
												<input type="text" class="easyui-textbox" id="bidNoticeNo4" style="width: 120px;">
											</td>
											<td class="bc">지역</td>
											<td>
												<input type="text" class="easyui-textbox" id="bidAreaNm4" style="width: 120px;">
											</td>
											<td class="bc">검색일</td>
											<td>
												<select class="easyui-combobox" id="searchDateType4" data-options="panelHeight:'auto'" style="width:100px;">
												        <option value="1">공고게시일</option>
												        <option value="2">입찰개시일</option>
												        <option value="3">입찰마감일</option>
												</select>
		
											</td>
											<td><input class="easyui-datebox" id="bidStartDt4"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
												~ <input class="easyui-datebox" id="bidEndDt4"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											</td>
											<td class="bc">수요처</td>
											<td><input type="text" class="easyui-textbox" id="bidDemandNm4" style="width: 150px;"></td>
											<td class="bc">물품명</td>
											<td><input type="text" class="easyui-textbox" id="bidGoodsNm4" style="width: 150px;"></td>
											<td class="bc">담당자</td>
											<td><input id="userId4" class="easyui-combobox"
													data-options="
													method:'get',
											        valueField: 'user_id',
											        textField: 'user_nm',
											        width:100,
											        panelHeight:'auto',
										        	data:jsonData2">
											</td>
											<td class="bc">비고내용</td>
											<td><input type="text" class="easyui-textbox" id="bidBigo4" style="width: 150px;">
											</td>
											<td width="200px"><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList4()">조회</a></td>
										</tr>
									</table>
								</div>
								<div data-options="region:'south',split:true,border:false" style="height:300px;">
									<div class="easyui-layout" style="width: 100%; height: 100%;">
										<div data-options="region:'west',collapsible:false" title="입찰관련정보" style="width: 50%;">
											<form id="tab4_left_form" method="post" >
												<font style="font-weight: bold; padding-left: 10px;"> [ 공고일반 ] </font>
												<table cellpadding="5" style="width: 100%; padding: 10px;">
													<tr>
														<td class="bc" style="width: 20%;">공고종류</td>
														<td style="width: 30%;"><font id="tab4_notice_type"></font></td>
														<td class="bc" style="width: 20%;">게시일시</td>
														<td style="width: 30%;"><font id="tab4_noti_dt"></font></td>
													</tr>
													<tr>
														<td class="bc" style="width: 20%;">공고번호</td>
														<td colspan="3" style="width: 80%;"><font id="tab4_bid_notice_no"></font></td>
													</tr>
													<tr>
														<td class="bc">공고명</td>
														<td colspan="3" ><font id="tab4_bid_notice_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">공고기관</td>
														<td><font id="tab4_order_agency_nm"></font></td>
														<td class="bc">수요기관</td>
														<td><font id="tab4_bid_demand_nm"></font></td>
													</tr>
													<tr>
														<td class="bc">계약방법</td>
														<td><font id="tab4_bid_cont_demand"></font></td>
														<td class="bc">국제입찰구분</td>
														<td><font id="tab4_nation_bid_yn"></font></td>
													</tr>
													<tr>
														<td class="bc">추정가격</td>
														<td><font id="tab4_pre_price"></font></td>
														<td class="bc">기초금액</td>
														<td><font id="tab4_base_price"></font></td>
													</tr>
													<tr>
														<td class="bc">낙찰하한율</td>
														<td><font id="tab4_column5"></font> %</td>
														<td class="bc">투찰기준금액</td>
														<td><font id="tab4_column1"></font></td>
													</tr>
													<tr>
														<td class="bc">적격정보</td>
														<td><font id="tab4_column2"></font></td>
														<td class="bc">기업구분</td>
														<td><font id="tab4_column3"></font></td>
													</tr>
													<tr>
														<td class="bc">담당자 의견</td>
														<td><font id="tab4_column4"></font></td>
													</tr>
												</table>
												<div id="tab4_detal1"></div>
												<div id="tab4_detal2"></div>
												<div id="tab4_detal3"></div>
												<div id="tab4_detal4"></div>
											</form>
		
		
										</div>
										<div data-options="region:'east',collapsible:false" title="투찰사 정보" style="width: 50%;">
											<table style="width: 100%">
												<tr>
													<td align="left">
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'"  onClick="getBusinessList()">투찰업체 추가</a>
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'"  onClick="delBusinessList()">투찰업체 삭제</a>
													</td>
													<td align="right">
														<input type="radio" name="msgGrp" value="" onchange="msgChk($(this).val())" checked="checked">해제</input>
														<input type="radio" name="msgGrp" value="all" onchange="msgChk($(this).val())">전체선택</input>
														<input type="radio" name="msgGrp" value="msg_info1" onchange="msgChk($(this).val())">APP</input>
														<input type="radio" name="msgGrp" value="msg_info2" onchange="msgChk($(this).val())">SMS</input>
														<input type="radio" name="msgGrp" value="msg_info3" onchange="msgChk($(this).val())">Email</input>
														
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onClick="sendBigo()">비고일괄등록</a>
<!-- 														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onClick="getRange()">추천구간등록</a> -->
<!-- 														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onClick="sendGCMBusiness()">추천가격안내(App)</a> -->
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onClick="sendBusiness()">보내기</a>
														<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onClick="save4()">저장</a>
													</td>
												</tr>
											</table>
											<table id="bc4" class="easyui-datagrid"
													data-options="singleSelect:false,pagination:false,striped:true,
																  onClickCell:onClickCell4,
																  onBeforeEdit:onBeforeEdit"
													style="width:100%;height: 85%;">
												<thead>
													<tr>
														<th rowspan="2" data-options="field:'send_yn',checkbox:true"></th>
														<th rowspan="2" data-options="field:'business_no',align:'center',halign:'center'" width="70">No.</th>
														<th rowspan="2" data-options="field:'company_nm',halign:'center'" width="150">투찰업체명</th>
														<th rowspan="2" data-options="field:'send_dt',align:'left',halign:'center'" width="80">투찰요청일</th>
														<th rowspan="2" data-options="field:'chk_dt',align:'left',halign:'center'" width="80">공고확인</th>
														<th rowspan="2" data-options="field:'confirm_yn',align:'center',halign:'center'" width="50">가격<br/>산정</th>
														<th rowspan="2" data-options="field:'choice_price',align:'right',halign:'center'" formatter="numberComma" width="120">투찰가격</th>
<!-- 														<th rowspan="2" data-options="field:'bidding_price',align:'right',halign:'center',editor:{type:'numberbox',options:{groupSeparator:','}}" formatter="numberComma" width="120">추천가격</th> -->
														<th rowspan="2" data-options="field:'bigo',align:'left',halign:'center',editor:'textbox'" width="110">비고</th>
														<th rowspan="2" data-options="field:'bidmanager',align:'center',halign:'center'" width="70">담당자</th>
														<th colspan="3">메세지유형</th>
														<th rowspan="2" data-options="field:'mobile_no',align:'left',halign:'center'" width="110">휴대폰</th>
														<th rowspan="2" data-options="field:'email',align:'left',halign:'center'" width="150">메일주소</th>
													</tr>
													<tr>
														<th data-options="field:'msg_info1',align:'center',halign:'center',width:40">APP</th>
														<th data-options="field:'msg_info2',align:'center',halign:'center',width:40">SMS</th>
														<th data-options="field:'msg_info3',align:'center',halign:'center',width:40">Email</th>
													</tr>
												</thead>
											</table>
											<script>
											function msgChk(val){
												var row = $('#bc4').datagrid('getRows');
												if(val=="all"){
													for(var i=0; i<row.length;i++){
														$('#bc4').datagrid('checkRow',i);
													}
												}else if(val==""){
													for(var i=0; i<row.length;i++){
														$('#bc4').datagrid('uncheckRow',i);
													}
												}else if(val=="msg_info1"){
													for(var i=0; i<row.length;i++){
														if(row[i].msg_info1=='Y'){
															$('#bc4').datagrid('checkRow',i);
														}else{
															$('#bc4').datagrid('uncheckRow',i);
														}
													}
												}else if(val=="msg_info2"){
													for(var i=0; i<row.length;i++){
														if(row[i].msg_info2=='Y'){
															$('#bc4').datagrid('checkRow',i);
														}else{
															$('#bc4').datagrid('uncheckRow',i);
														}
													}
												}else if(val=="msg_info3"){
													for(var i=0; i<row.length;i++){
														if(row[i].msg_info3=='Y'){
															$('#bc4').datagrid('checkRow',i);
														}else{
															$('#bc4').datagrid('uncheckRow',i);
														}
													}
												}
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
											
											//tab4 투찰사 
											
											function sendBusiness(){

												$('#sendMessage2').textbox('setValue','');
												var row = $("#dg4").datagrid('getSelected');
												var addData=$('#bc4').datagrid('getChecked');
												
												if(!row){
													$.messager.alert("알림", "공고를 선택하세요.");
													return;
												}
												if(addData==null || addData.length==0){
													$.messager.alert("알림", "투찰업체를 선택하세요.");
													return;
												}
												
												$('#sendMessageDlg2').dialog('open');
												
											}
											
											function messageType(type){
												var row = $("#dg4").datagrid('getSelected');
												var message = ""
												if(type==1){
													message = "<투찰요청>\n\n"+
													"㈜인콘 입니다.\n"+
													"공고번호 : "+($('#tab4_bid_notice_no').text().replace("상세보기",""))+"\n"+
													"공고명 : "+($('#tab4_bid_notice_nm').text())+"\n\n"+
													"투찰추천금액 : <입력된 추천가격>"+"\n"+
													"비고 : <입력된 비고>\n"+
													"투찰마감일시 : "+formatDate(row.bid_end_dt)+" 까지\n"+
													"물품분류번호 : "+row.detail_goods_no+"("+row.detail_goods_nm+")\n\n"+
													"투찰 부탁드리겠습니다.\n"+
													"감사합니다.\n";
												}else if(type==2){
													message = "<입찰참가신청요청>\n\n"+
													"㈜인콘 입니다.\n"+
													"공고번호 : "+($('#tab4_bid_notice_no').text().replace("상세보기",""))+"\n"+
													"공고명 : "+($('#tab4_bid_notice_nm').text())+"\n"+
													"수요기관 : "+($('#tab4_bid_demand_nm').text())+"\n"+
													"입찰신청마감일시 : "+formatDate(row.bid_end_dt)+" 까지\n"+
													"비고 : <입력된 비고>\n\n"+
													"관련하여 입찰참가신청을 요청드립니다."+"\n\n"+
													"*국군조달사이트에서 참가신청하시면 됩니다."+"\n"+
													"- 첨부서류는 없습니다."+"\n"+
													"- 입찰보증금 면제로 입찰보증금 지급확약서 내용에 동의함으로써 갈음합니다."+"\n\n"+
													"감사합니다."+"\n";
												}else if(type==3){
													message = "<물품분류번호등록요청>\n\n"+
													"㈜인콘 입니다.\n\n"+
													"물품분류번호 : "+row.detail_goods_no+"("+row.detail_goods_nm+")\n\n"+
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
													"등록된 "+($('#tab4_bid_notice_nm').text())+" 상품이 오늘 "+
													""+formatDate(row.bid_end_dt)+" 마감입니다.\n"+
													"확인 후 투찰 부탁드리겠습니다."+"\n\n"+
													"감사합니다."+"\n";
												}
												$('#sendMessage2').textbox('setValue',message);
											}
											
											function sendMessage2(type){
												var title;
												var title2;
												if(type=="email"){
													title ="메일을";
													title2 ="메일";
												}else{
													title ="SMS를";
													title2 ="SMS";
												}
												
												var message = $('#sendMessage2').textbox('getValue');
												if(message==null || message.length==0){
													$.messager.alert("알림", title2+" 문구를 등록하세요.");
													return;
												}
												
												var row = $("#dg4").datagrid('getSelected');
												var addData=$('#bc4').datagrid('getChecked');
												
												$.messager.confirm('알림', '선택하신 업체에 '+title+' 발송하시겠습니까?', function(r){
										            if (r){
										            	$('#sendMessageDlg2').dialog('close');
										        		
										        		var effectRow = new Object();
										        		if (row) {
										        			effectRow["bid_notice_no"] = row.bid_notice_no;
										        			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
										        		}
										        		
										        		effectRow["message_type"] = type;
										        		if (addData.length) {
										        			effectRow["addData"] = JSON.stringify(addData);
										        		}
		//								         		$.messager.alert($("#sendMessage1").textbox('getValue'));
										        		effectRow["send_message"] = $("#sendMessage2").textbox('getValue');
										        		
										        		$.post("<c:url value='/bid/sendBusiness.do'/>", effectRow, 
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
										        });
											}
											
											function save4() {
												var row = $("#dg4").datagrid('getSelected');
												var addData = $('#bc4').datagrid('getChecked');
		
												$.messager.confirm('알림','저장하시겠습니까?',
													function(r) {
														if (r) {
		
															if (endEditing4()) {
																var $dg = $("#bc4");
		
																if ($dg.datagrid('getChanges').length) {
																	var updated = $dg.datagrid('getChanges',"updated");
		
																	var effectRow = new Object();
																	if (row) {
																		effectRow["bid_notice_no"] = row.bid_notice_no;
																		effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
																	}
																	if (updated.length) {
																		effectRow["addData"] = JSON.stringify(updated);
																	}
																	$.post("<c:url value='/bid/updateBusinessList.do'/>",effectRow,
																		function(rsp) {
																			if (rsp.status) {
																				$.messager.alert("알림","저장하였습니다.");
																				$dg.datagrid('acceptChanges');
																				$('#bc4').datagrid('reload');
																				setBizInfo4(row);
																			}
																		},"JSON").error(function() {
																			$.messager.alert("알림","저장에러！");
																	});
																}
															}
														}
													});
											}
											

											function sendGCMBusiness(){
												
												var row = $("#dg4").datagrid('getSelected');
												var addData=$('#bc4').datagrid('getChecked');
												
												if(!row){
													$.messager.alert("알림", "공고를 선택하세요.");
													return;
												}
												if(addData==null || addData.length==0){
													$.messager.alert("알림", "투찰업체를 선택하세요.");
													return;
												}
												
												$.messager.confirm('알림', '선택하신 업체에 추천가격을 안내하시겠습니까? 앱을 등록한 업체만 푸쉬메세지 발송이 가능합니다.', function(r){
										            if (r){
										        		var effectRow = new Object();
										        		if (row) {
										        			effectRow["bid_notice_no"] = row.bid_notice_no;
										        			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
										        		}
										        		
										        		if (addData.length) {
										        			effectRow["addData"] = JSON.stringify(addData);
										        		}
										        		
										        		$.post("<c:url value='/bid/sendGCMBusiness.do'/>", effectRow, 
										        			function(rsp) {
											        			if(rsp.status){
											        				$.messager.alert("알림","메세지를 발송하였습니다.");
											        				$('#bc4').datagrid('reload');
											        			}else{
												        			$.messager.alert("알림", "발송에러！");
											        				$('#bc4').datagrid('reload');
											        			}
											        		}, "JSON").error(function() {
											        			$.messager.alert("알림", "발송에러！");
										        		});
										            }
										        });
											}
											
											function getRange(){
												
												var row = $("#dg4").datagrid('getSelected');
												
												if(!row){
													$.messager.alert("알림", "공고를 선택하세요.");
													return;
												}
												
												 $.ajax({ 
													    type: "POST"
													   ,url: "<c:url value='/bid/getBidRangeDtl.do'/>"
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
											
											function saveRange(){
												var row = $("#dg4").datagrid('getSelected');
												
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
								        		
								        		$.post("<c:url value='/bid/saveRange.do'/>", effectRow, 
									        			function(rsp) {
									        				$.messager.alert("알림","저장하였습니다.");
									        				$('#rangeDlg').dialog('close');
										        		}, "JSON").error(function() {
										        			$.messager.alert("알림", "저장에러！");
									        		});
											}
											
											function sendBigo(){

												$('#bigoMsg').textbox('setValue','');
												var row = $("#dg4").datagrid('getSelected');
												var addData=$('#bc4').datagrid('getChecked');
												
												if(!row){
													$.messager.alert("알림", "공고를 선택하세요.");
													return;
												}
												if(addData==null || addData.length==0){
													$.messager.alert("알림", "투찰업체를 선택하세요.");
													return;
												}
												
												$('#sendBigoDlg').dialog('open');
												
											}
											
											function sendBigoMsg(){
												
												var row = $("#dg4").datagrid('getSelected');
												var addData=$('#bc4').datagrid('getChecked');
												
												if(!row){
													$.messager.alert("알림", "공고를 선택하세요.");
													return;
												}
												if(addData==null || addData.length==0){
													$.messager.alert("알림", "투찰업체를 선택하세요.");
													return;
												}
												
												$.messager.confirm('알림', '선택하신 업체에 비고를 일괄등록 하시겠습니까?', function(r){
										            if (r){
										        		var effectRow = new Object();
										        		if (row) {
										        			effectRow["bid_notice_no"] = row.bid_notice_no;
										        			effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
										        			effectRow["bigo"] = $("#bigoMsg").textbox('getValue');
										        		}
										        		
										        		if (addData.length) {
										        			effectRow["addData"] = JSON.stringify(addData);
										        		}
										        		
										        		$.post("<c:url value='/bid/sendBigoMsg.do'/>", effectRow, 
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
											
											function delBusinessList() {
												var row = $("#dg4").datagrid('getSelected');
												var addData = $('#bc4').datagrid('getChecked');
												
												if(!row){
													$.messager.alert("알림", "공고를 선택하세요.");
													return;
												}
												if(addData==null || addData.length==0){
													$.messager.alert("알림", "투찰업체를 선택하세요.");
													return;
												}
		
												$.messager.confirm('알림','삭제하시겠습니까?',
													function(r) {
														if (r) {
		
															if (endEditing4()) {
																var $dg = $("#bc4");
		
																if (addData.length) {
																	var effectRow = new Object();
																	if (row) {
																		effectRow["bid_notice_no"] = row.bid_notice_no;
																		effectRow["bid_notice_cha_no"] = row.bid_notice_cha_no;
																	}
																	if (addData.length) {
																		effectRow["addData"] = JSON.stringify(addData);
																	}
																	$.post("<c:url value='/bid/deleteBusinessList.do'/>",effectRow,
																		function(rsp) {
																			if (rsp.status) {
																				$.messager.alert("알림","삭제하였습니다.");
																				$dg.datagrid('acceptChanges');
																				$('#bc4').datagrid('reload');
																				setBizInfo4(row);
																			}
																		},"JSON").error(function() {
																			$.messager.alert("알림","삭제에러！");
																	});
																}
															}
														}
													});
											}
											</script>
										</div>
									</div>
								</div>
								<div data-options="region:'center',border:false">
									<table id="dg4" class="easyui-datagrid"
											style="width: 100%; height: 100%;"
											data-options="rownumbers:true,
											  singleSelect:true,
											  pagination:true,
											  pageSize:30,
											  method:'get',
											  striped:true,
											  nowrap:false,
											  sortName:'noti_dt',
											  sortOrder:'desc',
											  pageList:[30,50,70,100,150,200,500],
											  rowStyler: function(index,row){
								                    if (row.finish_status=='F'){
								                        return 'background-color:#eeeeee;color:#999999;';
								                    }
								              }">
										<thead>
											<tr>
												<th data-options="field:'check', align:'center',halign:'center',width:35" formatter="formatCheckBox">중요</th>
												<th data-options="field:'user_nm',align:'center',halign:'center',width:70">담당자</th>
												<th data-options="field:'permit_biz_type_info',halign:'center',width:200" formatter="bidLicense">업종제한</th>
												<th data-options="field:'product_yn',align:'center',halign:'center',width:40,resizable:true">제조<br/>제한</th>
												<th data-options="field:'nation_bid_yn',align:'center',halign:'center',width:40">국제<br/>입찰</th>
												<th data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true" formatter="formatNoticeNo">공고번호</th>
												<th data-options="field:'bid_notice_nm',align:'left',width:300,halign:'center',sortable:true" formatter="formatNoticeNm">공고명</th>
												<th data-options="field:'demand_nm',align:'left',width:150 ,halign:'center',sortable:true" formatter="formatEnter">수요처</th>
												<th	data-options="field:'bid_method',align:'left',width:100 ,halign:'center'">입찰방식</th>
												<th data-options="field:'contract_type_nm',align:'left',width:100 ,halign:'center'">계약방법</th>
												<th data-options="field:'detail_goods_nm',align:'left',width:100 ,halign:'center'">물품명</th>
												<th data-options="field:'use_area_info',align:'left',width:100 ,halign:'center'" formatter="formatCommaEnter">지역</th>
												<th data-options="field:'pre_price',align:'right',width:100 ,halign:'center',sortable:true" formatter="numberComma">추정가격</th>
												<th data-options="field:'base_price',align:'right',width:100 ,halign:'center'" formatter="numberComma">기초금액</th>
<!-- 												<th data-options="field:'noti_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">공고일시</th> -->
<!-- 												<th data-options="field:'bid_start_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="formatDate">입찰개시일시</th> -->
												<th data-options="field:'bid_end_dt',align:'center',width:130 ,halign:'center',sortable:true" formatter="bidFormatDate">입찰개시일시<br/>입찰마감일시</th>
												<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton5">견적<br/>보고서</th>
												<th data-options="field:'company_type_insert2',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton7">추천<br/>구간</th>
												<th data-options="field:'bigo',align:'left',width:200 ,halign:'center'">비고</th>
											</tr>
										</thead>
									</table>
									<script>
										function formatRowButton5(val,row){
											   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"report_type\" val=\""+row.business_no+"\" onclick=\"\" ></a>";
										}
										function formatRowButton7(val,row){
											   return "<a href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" type=\"range_type\" onclick=\"\" ></a>";
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
											<td><input class="easyui-datebox" id="bidStartDt5"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
												~ <input class="easyui-datebox" id="bidEndDt5"  style="width:100px;"	data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
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
										        data:jsonData2">
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
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList5()">조회</a> 
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
<!-- 														<th data-options="field:'open_seq_no',align:'center',halign:'center',width:50">구분</th> -->
<!-- 														<th data-options="field:'sche_price',align:'right',width:120 ,halign:'center'" formatter="numberComma">예정가격</th> -->
<!-- 														<th data-options="field:'base_price',align:'right',width:120 ,halign:'center'" formatter="numberComma">기초금액</th> -->
<!-- 														<th data-options="field:'base_sche_price',align:'right',width:120 ,halign:'center'" formatter="numberComma">금액</th> -->
<!-- 														<th	data-options="field:'draw_result_yn',align:'center',width:50 ,halign:'center'">추첨여부</th> -->
													</tr>
												</thead>
											</table>
										</div>
									</div>
							    </div>
							    <div data-options="region:'center',border:false">
							    	<table id="dg5" class="easyui-datagrid"
										style="width: 100%; height: 100%"
										data-options="rownumbers:true,
													  singleSelect:true,
													  pagination:true,
 													  pageSize:30,
													  pageList:[30,50,70,100,150,200,500],
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
						
						<div title="발신메세지" style="padding: 5px">
							<div class="easyui-layout" style="width:100%;height:750px;">
							    <div data-options="region:'north',border:false">
							    	<table style="width: 100%;">
										<tr>
											<td class="bc">공고</td>
											<td>
												<select class="easyui-combobox" id="searchBidType6" data-options="panelHeight:'auto'"  style="width:100px;">
												        <option value="1">공고번호</option>
												        <option value="2">공고명</option>
												        <option value="3">업체명</option>
												</select>
												<input type="text" class="easyui-textbox" id="bidNoticeNo6" style="width: 120px;">
											</td>
											<td class="bc">발신일</td>
											<td><input class="easyui-datebox" id="bidEndDt6"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'">
											</td>
											<td width="200px">
												<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectBidList6()">조회</a> 
											</td>
										</tr>
									</table>
							    </div>
							    <div data-options="region:'center',border:false">
							    	<table id="dg6" class="easyui-datagrid"
										style="width: 100%; height: 100%"
										data-options="rownumbers:true,
													  singleSelect:true,
													  pagination:true,
													  pageSize:200,
													  sortName:'send_time',
													  sortOrder:'desc',
													  method:'get',
													  striped:true,
													  pageList:[30,50,70,100,150,200,500],
													  nowrap:false">
										<thead>
											<tr>
												<th data-options="field:'bid_notice_no',halign:'center',width:150,resizable:true,sortable:true"	formatter="formatNoticeNo">공고번호</th>
<!-- 												<th data-options="field:'bid_notice_nm',align:'left',width:350,halign:'center',sortable:true">공고명</th> -->
												<th data-options="field:'business_no',align:'left',width:60,halign:'center',sortable:true">업체번호</th>
												<th data-options="field:'company_nm',align:'left',width:200,halign:'center',sortable:true">업체명</th>
												<th data-options="field:'catagory',align:'center',width:100,halign:'center',sortable:true"	formatter="formatCatagory">카테고리</th>
												<th data-options="field:'message_type',align:'center',width:50,halign:'center',sortable:true">유형</th>
												<th data-options="field:'subject',align:'left',width:150,halign:'center'">제목</th>
												<th data-options="field:'receiver',align:'center',width:150,halign:'center'">수신자정보</th>
												<th data-options="field:'send_nm',align:'center',width:80,halign:'center'">발신자</th>
												<th data-options="field:'send_time',align:'center',width:150,halign:'center',sortable:true">발신일</th>
											</tr>
										</thead>
									</table>
									<script>
										function formatCatagory(val,row){
											if(val=="sendBusiness"){
												return "투찰사";
											}else if(val=="sendManufacture"){
												return "제조사";
											}else{
												return "";
											}
										}
									</script>
							    </div>
							    <div data-options="region:'east',collapsible:false" title="메세지 정보" style="width: 30%;">
							    	<input id="sendMsg" name="sendMsg" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 100%;" />
							    </div>
							</div>
						</div>
					</div>

					<!-- 견적요청 메세지 Dialog start -->
					<div id="sendMessageDlg" class="easyui-dialog" title="견적요청" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 400px; padding: 10px">
						<input id="sendMessage1" name="sendMessage1" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 90%"> 
						<div style="margin: 5px 0; vertical-align: top"></div>
						<div style="width: 100%" align="center">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage('email')">Email보내기</a>
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage('sms')">SMS보내기</a>
						</div>
					</div>
					<!-- 견적요청 메세지 Dialog end -->
					
					<!-- 투찰요청 메세지 Dialog start -->
					<div id="sendMessageDlg2" class="easyui-dialog" title="투찰정보" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 400px; padding: 10px">
						<div style="width: 100%" align="left">
<!-- 							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(1)">투찰요청</a> -->
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(2)">참가신청요청</a>
<!-- 							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType(3)">물품분류번호등록요청</a> -->
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

					<!-- 투찰요청 메세지 Dialog start -->
					<div id="sendMessageDlg3" class="easyui-dialog" title="투찰정보" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 500px; height: 400px; padding: 10px">
						<div style="width: 100%" align="left">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType3(2)">참가신청요청</a>
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-comment'" onclick="messageType3(3)">물품분류번호등록요청</a>
						</div>
						<div style="margin: 5px 0; vertical-align: top"></div>
						<input id="sendMessage3" name="sendMessage3" class="easyui-textbox" data-options="multiline:true" style="width: 100%; height: 80%"/> 
						<div style="margin: 5px 0; vertical-align: top"></div>
						<div style="width: 100%" align="center">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage3('email')">Email보내기</a>
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="sendMessage3('sms')">SMS보내기</a>
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

					<!-- 업종등록 Dialog start -->
					<div id="companyTypeList" class="easyui-dialog" title="대표업종" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 400px; height: 80%; padding: 10px">
						<table style="width: 100%">
							<tr>
								<td align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="tab2_save3()">저장</a>
								</td>
							</tr>
						</table>
						<table id="companyTb" class="easyui-datagrid"
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
									<th data-options="field:'cd',align:'left',width:100,halign:'center',sortable:true">업종코드</th>
									<th data-options="field:'cd_nm',align:'left',width:200,halign:'center',sortable:true">업종명</th>
								</tr>
							</thead>
						</table>
					</div>
					<!-- 업종등록 Dialog end -->

					<!-- 제조업체Dialog start -->
					<div id="manufactureList" class="easyui-dialog" title="제조업체 검색" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 70%; height: 500px; padding: 10px">
						<table style="width: 100%">
							<tr>
								<td class="bc">업체명</td>
								<td><input type="text" class="easyui-textbox" id="s_business_nm" style="width: 120px;"></td>
								<td class="bc">업종</td>
					            <td>
					                <input type="text" class="easyui-textbox"  id="s_company_type" style="width:70px;"   >
					                <input type="text" class="easyui-textbox"  id="s_company_type_nm" style="width:120px;"  disabled="disabled"  >
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCompanyType('s_company_type', 's_company_type_nm', 's')" ></a>
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchCompanyType('s_company_type', 's_company_type_nm', 'c')" ></a>
					            </td>
					            <td class="bc">물품</td>
					            <td>
					                <input type="text" class="easyui-textbox"  id="s_goods_type" style="width:70px;"   >
					                <input type="text" class="easyui-textbox"  id="s_goods_type_nm" style="width:120px;"  disabled="disabled"  >
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType('s_goods_type', 's_goods_type_nm', 's')" ></a>
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType('s_goods_type', 's_goods_type_nm', 'c')" ></a>
					            </td>
					            <td class="bc">지역</td>
					            <td>
					            	<input id="s_area_cd" class="easyui-combobox"
												data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:120,
										        panelHeight:'auto',
												data:jsonData4">
					                <input type="text" class="easyui-textbox"  id="s_area_txt" style="width:100px;"   >
					            </td>
								<td align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getManufactureList()">조회</a>
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="tab2_save2()">추가</a>
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
									<th data-options="field:'ck',checkbox:true"></th>
									<th data-options="field:'business_no',align:'left',halign:'center',width:70">No.</th>
									<th data-options="field:'company_no',align:'left',halign:'center',width:150">사업자번호</th>
									<th data-options="field:'company_nm',align:'left',halign:'center',width:150">제조사명</th>
									<th data-options="field:'delegate',align:'center',halign:'center',width:80">대표</th>
									<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton3">업종</th>
									<th data-options="field:'company_type_insert2',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton4">물품</th>
									<th data-options="field:'address_nm',halign:'center',max:10" width="100" >주소</th>
									<th data-options="field:'address_detail',halign:'center',max:10" width="250">상세주소</th>
									<th data-options="field:'bidmanager',align:'center',halign:'center',width:70">담당자</th>
									<th data-options="field:'phone_no',align:'left',halign:'center',width:120">연락처</th>
									<th data-options="field:'mobile_no',align:'left',halign:'center',width:120">핸드폰</th>
									<th data-options="field:'fax_no',align:'left',halign:'center',width:120">팩스</th>
									<th data-options="field:'email',align:'left',halign:'center',width:200">메일주소</th>
								</tr>
							</thead>
						</table>
					</div>
					<!-- 제조업체 Dialog end -->
					
					<!-- 투찰업체Dialog start -->
					<div id="businessList" class="easyui-dialog" title="투찰업체 검색" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 70%; height: 500px; padding: 10px">
						<table style="width: 100%">
							<tr>
								<td class="bc">업체명</td>
								<td><input type="text" class="easyui-textbox" id="s_business_nm2" style="width: 120px;"></td>
								<td class="bc">업종</td>
					            <td>
					                <input type="text" class="easyui-textbox"  id="s_company_type2" style="width:70px;"   >
					                <input type="text" class="easyui-textbox"  id="s_company_type_nm2" style="width:120px;"  disabled="disabled"  >
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCompanyType('s_company_type2', 's_company_type_nm2', 's')" ></a>
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchCompanyType('s_company_type2', 's_company_type_nm2', 'c')" ></a>
					            </td>
					            <td class="bc">물품</td>
					            <td>
					                <input type="text" class="easyui-textbox"  id="s_goods_type2" style="width:70px;"   >
					                <input type="text" class="easyui-textbox"  id="s_goods_type_nm2" style="width:120px;"  disabled="disabled"  >
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchGoodsType('s_goods_type2', 's_goods_type_nm2', 's')" ></a>
					                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="searchGoodsType('s_goods_type2', 's_goods_type_nm2', 'c')" ></a>
					            </td>
							</tr>
							<tr>
					            <td class="bc">지역</td>
					            <td>
					            	<input id="s_area_cd2" class="easyui-combobox"
												data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:120,
										        panelHeight:'auto',
												data:jsonData4">
					                <input type="text" class="easyui-textbox"  id="s_area_txt2" style="width:100px;"   >
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
												data:jsonData9">
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
												data:jsonData8">
					            </td>
								<td align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getBusinessList()">조회</a>
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" id="addTab4SaveBtn1" onclick="tab4_save2()">추가</a>
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" id="addTab4SaveBtn2" onclick="tab4_save3()">추가</a>
								</td>
							</tr>
						</table>
						<table id="businessTb" class="easyui-datagrid"
							style="width: 100%; height: 80%;"
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
									<th data-options="field:'company_type_insert',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton3">업종</th>
									<th data-options="field:'company_type_insert2',align:'center',halign:'center',max:10" width="50" formatter="formatRowButton4">물품</th>
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
					
					<!-- 투찰업체 메세지 보내기 Dialog start -->
					<div id="businessMsgDlg" class="easyui-dialog" title="투찰업체 물품등록 요청" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 800px; height: 500px; padding: 10px">
						<table style="width: 100%">
							<tr>
								<td align="left">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onClick="getBusinessList2()">투찰업체 추가</a>
									
									지역 : 
									<input id="s_area_cd3" class="easyui-combobox"
												data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:120,
										        panelHeight:'auto',
												data:jsonData4,
												onSelect:businessGoodChgArea"
												>
									기업규모 : 
									<input id="s_scale_cd3" class="easyui-combobox"
												data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:120,
												data:jsonData9,
										        panelHeight:'auto',
												onSelect:businessGoodChgArea"
												>
									신용등급 : 
									<input id="s_credit_cd3" class="easyui-combobox"
												data-options="
												method:'get',
										        valueField: 'cd',
										        textField: 'cd_nm',
										        width:120,
										        panelHeight:'auto',
												data:jsonData8,
												onSelect:businessGoodChgArea"
												>
								</td>
								<td align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onClick="sendGoodsMsg()">보내기</a>
								</td>
							</tr>
						</table>
						<table id="businessMsgTb" class="easyui-datagrid"
								data-options="singleSelect:false,pagination:false,striped:true,
											  onClickCell:onClickCell4,
											  onBeforeEdit:onBeforeEdit"
								style="width:100%;height: 85%;">
							<thead>
								<tr>
									<th data-options="field:'send_yn',checkbox:true"></th>
									<th data-options="field:'business_no',align:'center',halign:'center'" width="70">No.</th>
									<th data-options="field:'company_nm',halign:'center'" width="150">투찰업체명</th>
									<th data-options="field:'bidmanager',align:'center',halign:'center'" width="70">담당자</th>
									<th data-options="field:'address_nm',align:'center',halign:'center',width:60">지역</th>
									<th data-options="field:'scale_nm',align:'center',halign:'center',width:60">기업규모</th>
									<th data-options="field:'credit_nm',align:'center',halign:'center',width:60">신용등급</th>
									<th data-options="field:'mobile_no',align:'left',halign:'center'" width="110">휴대폰</th>
									<th data-options="field:'email',align:'left',halign:'center'" width="150">메일주소</th>
								</tr>
							</thead>
						</table>
					</div>
					<!-- 투찰업체 메세지 보내기 Dialog end -->
					
					
					<div id="bidInfoDlg" class="easyui-dialog" title="공고 가져오기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 20%; height: 100px; padding: 10px">
						<table style="width: 100%">
							<tr>
								<td class="bc">공고일</td>
								<td><input class="easyui-datebox" id="startDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
								<td align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getBidInfoApi()">가져오기</a>
								</td>
							</tr>
						</table>
					</div>
					<div id="bidResultInfoDlg" class="easyui-dialog" title="개찰결과 가져오기" data-options="iconCls:'icon-save',modal:true,closed:true" style="width: 20%; height: 100px; padding: 10px">
						<table style="width: 100%">
							<tr>
								<td class="bc">개찰일</td>
								<td><input class="easyui-datebox" id="resultStartDt"  style="width:100px;" data-options="formatter:myformatter,parser:myparser,sharedCalendar:'#cc'"></td>
								<td align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getBidResultInfoApi()">가져오기</a>
								</td>
							</tr>
						</table>
					</div>
					
					
					<!-- 견적보고서 Dialog start -->
					<div id="reportDlg" class="easyui-dialog" title="견적 보고서" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:900px;height:800px;padding:10px">
				    	
				    	
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
// 											$("#apply_comment1").textbox("setValue",json.rows[0].apply_comment1);
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
										choice_yn : 'Y',
									},
									onLoadSuccess : function(row, param) {
		
									}
								});
							}
				    </script>
				    
				    
				    
				    <!-- 견적승인추가 Dialog start -->
					<div id="reportInfoDlg" class="easyui-dialog" title="과업정보등록" data-options="iconCls:'icon-save',modal:true,closed:true" style="width:900px;height:800px;padding:10px">
				    	
				    	<table style="width: 100%">
							<tr>
								<td align="right">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onClick="sendApply()">승인요청</a>
								</td>
							</tr>
						</table>
				    	<table cellpadding="5" style="width: 100%;">
				            <tr>
				                <td class="bc">조달사이트</td>
				                <td>
	                				<input id="bid_site" name="bid_site"
											class="easyui-combobox"
											data-options="
											method:'get',
											width:250,
                 							panelHeight:'auto',
									        valueField: 'cd',
									        textField: 'cd_nm',
									        data:jsonData7" />
								</td>
				            </tr>
				            <tr>
				                <td class="bc">과업내용</td>
				                <td>
		                			<input class="easyui-textbox" data-options="multiline:true" id="bid_cont"  style="width:98%;height:80px">
								</td>
				            </tr>
				            <tr>
				                <td class="bc">리스크</td>
				                <td>
		                			<input id="bid_risk" name="bid_risk"
											class="easyui-combobox"
											data-options="
											method:'get',
											width:250,
                 							panelHeight:'auto',
									        valueField: 'cd',
									        textField: 'cd_nm',
									        data:jsonData6" />
								</td>
				            </tr>
				            <tr>
				                <td class="bc">과업기간</td>
				                <td>
		                			<input class="easyui-textbox" data-options="width:250" id="bid_term" >
								</td>
				            </tr>
				            <tr>
				                <td class="bc">특이사항</td>
				                <td>
		                			<input class="easyui-textbox" data-options="multiline:true" id="bid_sp_cont"  style="width:98%;height:80px">
								</td>
				            </tr>
				            <tr>
				                <td class="bc">심사총평</td>
				                <td>
		                			<input class="easyui-textbox" data-options="multiline:true" id="bid_tot_cont"  style="width:98%;height:80px">
								</td>
				            </tr>
				            <tr>
				                <td class="bc" colspan="4">리스크분석</td>
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
									<select class="easyui-combobox" id="info1_1" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info1_1d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ 제조사 담당자와 규격을 확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info1_2" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info1_2d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ 품질보증 관련 인증보유 및 시험성적 여부확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info1_3" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info1_3d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ 특정 규격 및 특정 제조사 여부에 확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info1_4" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info1_4d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ 납품될 제품의 정품여부에 대하여 확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info1_5" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info1_5d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ <input class="easyui-textbox" id="info1_6t" style="width:95%;"></td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info1_6" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info1_6d" >
								</td>
							</tr>
							<tr>
								<td class="cont" colspan="3">의견 : <input class="easyui-textbox" id="info1_7" style="width:93%;"> </td>
							</tr>
							<tr>
								<td class="bc" rowspan="6">납품<br/>관련</td>
								<td class="cont" style="width: 55%">○ 제조사 담당자와 납기의 적절성 확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info2_1" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info2_1d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ 제조사 담당자와 납품장소의 적절성 확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info2_2" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info2_2d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ 제조사분석 확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info2_3" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info2_3d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ 운송비용, 설치비용의 확인</td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info2_4" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info2_4d" >
								</td>
							</tr>
							<tr>
								<td class="cont" style="width: 55%">○ <input class="easyui-textbox" id="info2_5t" style="width:95%;"></td>
								<td class="cont" style="text-align: center">
									<select class="easyui-combobox" id="info2_5" data-options="panelHeight:'auto'" style="width:100px;">
										        <option value="">선택</option>
										        <option value="Y">Y</option>
										        <option value="N">N</option>
										        <option value="C">해당사항없음</option>
									</select>
								</td>
								<td class="cont">
									<input class="easyui-textbox" id="info2_5d" >
								</td>
							</tr>
							<tr>
								<td class="cont" colspan="3">의견 : <input class="easyui-textbox" id="info2_6" style="width:93%;"></td>
							</tr>
							<tr>
								<td class="bc">기타리스크 : </td>
								<td class="cont" colspan="3" style="min-height: 50px;">
									<input class="easyui-textbox" data-options="multiline:true" id="info3"  style="width:98%;height:50px">
								</td>
							</tr>
				        </table>
				    </div>
				    <!-- 견적승인추가 Dialog end -->
				    
				    
				    
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
				</div>
			</div>
		</div>
		<%@ include file="/include/popup.jsp" %>
	</div>
</body>
</html>