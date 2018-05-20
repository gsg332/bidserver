
/**
 * 콤마찍기
 * @param _number
 * @param type
 * @returns
 */
function numberComma(_number, type) {
	
  if(isNaN(_number)){
	  return _number;
  }
  
  if(_number.length==0){
	  return _number;
  }

	_number = ""+parseInt(_number);	
  var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
  while (_regExp.test(_number)) {
   _number = _number.replace(_regExp, "$1,$2");
  }
  if(type=="1"){
	  return '<span style="color:blue;">'+_number+'</span>';
  }else{
	  return _number;
  }
}

function numberComma(_number) {
	
	if(isNaN(_number)){
		return _number;
	}
	
	if(_number.length==0){
		return _number;
	}
	
	_number = ""+parseInt(_number);	
	var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
	while (_regExp.test(_number)) {
		_number = _number.replace(_regExp, "$1,$2");
	}

	return _number;
}
function numberComma2(_number) {
	
	if(isNaN(_number)){
		return _number;
	}
	
	if(_number.length==0){
		return _number;
	}
	
	_number = ""+parseFloat(_number);	
	var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
	while (_regExp.test(_number)) {
		_number = _number.replace(_regExp, "$1,$2");
	}
	
	return _number;
}


function formatNumber(_number) {
	
	  if(isNaN(_number)){
		  return 0;
	  }
	  
	  if(_number.length==0){
		  return 0;
	  }

	return parseFloat(_number);	
}

/**
 * 공고번호 포맷 (공고번호+차수)
 * @param val
 * @param row
 * @returns {String}
 */
function formatNoticeNo(val,row){
	if(row.bid_notice_no !=null){
		return row.bid_notice_no+"-"+row.bid_notice_cha_no;
	}else{
		return "";
	}
}
function formatNoticeNo2(val,row){
	if(row.bid_notice_cha_no !=null){
		return row.bid_notice_no+"-"+row.bid_notice_cha_no;
	}else{
		return "";
	}
}

/**
 * 공고명 포맷 (공고유형+공고명)
 * @param val
 * @param row
 * @returns {String}
 */
function formatNoticeNm(val,row){
	
	var color = "";
	if(row.notice_type=="긴급"){
		color ="red";
	}else if(row.notice_type=="변경"){
		color ="blue";
	}else if(row.notice_type=="취소"){
		color ="green";
	}else{
		color ="black";
	}
	
    return "<span style='color:"+color+";font-weight:bold;'>["+row.notice_type+"]</span> "+row.bid_notice_nm;
}
function formatNoticeNm2(val,row){
	
	var result = "";
	var color = "";
	if(row.notice_type=="긴급"){
		color ="red";
		
	}else if(row.notice_type=="변경"){
		color ="blue";
	}else if(row.notice_type=="취소"){
		color ="green";
	}else{
		color ="black";
	}
	if(typeof(row.bid_notice_nm) != "undefined"){
		result = "<span style='color:"+color+";font-weight:bold;'>["+row.notice_type+"]</span> "+row.bid_notice_nm;
	}
    return result;
}
/**
 * 계약방법 포맷
 * @param val
 * @param row
 * @returns {String}
 */
function formatMethod(val,row){
	
	var stdStr ="";
	
	if(row.contract_type_nm.search("규격가격")>=0)	stdStr ="규격가격";
	if(row.contract_type_nm.search("조합추천")>=0)	stdStr ="조합추전";
	if(row.contract_type_nm.search("제한")>=0)	 stdStr ="제한";
	if(row.contract_type_nm.search("총액")>=0)		stdStr ="총액";
	if(row.contract_type_nm.search("협상")>=0) 	stdStr ="협상";
	
	var endStr ="";
	
	if(row.bid_price_type.search("복수")>=0){
		endStr ="복수";
	}else if(row.bid_price_type.search("단일")>=0){
		endStr ="단일";
	}else if(row.bid_price_type.search("비예")>=0){
		endStr ="비예";
	}
	
     return stdStr+"<br/>"+endStr;
}

function formatTypeLimitStr(row, type){
	var str = "";
	
	if(row.lic_limit_nm1.length>3){
		str +="[ <font color='blue'>"+formatParenthesis(row.lic_limit_nm1)+"</font>";
		if(row.lic_limit_nm2.length>3){
			str +=" 과 <font color='blue'>"+formatParenthesis(row.lic_limit_nm2)+"</font>";
		}
		str += " ]";
	}
	if(row.lic_limit_nm3.length>3){
		str +="업종 또는<br/>[ <font color='blue'>"+formatParenthesis(row.lic_limit_nm3)+"</font>";
		if(row.lic_limit_nm4.length>3){
			str +=" 과 <font color='blue'>"+formatParenthesis(row.lic_limit_nm4)+"</font>";
		}
		str += " ]";
	}
	if(row.lic_limit_nm5.length>3){
		str +="업종 또는<br/>[ <font color='blue'>"+formatParenthesis(row.lic_limit_nm5)+"</font>";
		if(row.lic_limit_nm6.length>3){
			str +=" 과 <font color='blue'>"+formatParenthesis(row.lic_limit_nm6)+"</font>";
		}
		str += " ]";
	}
	if(row.lic_limit_nm7.length>3){
		str +="업종 또는<br/>[ <font color='blue'>"+formatParenthesis(row.lic_limit_nm7)+"</font>";
		if(row.lic_limit_nm8.length>3){
			str +=" 과 <font color='blue'>"+formatParenthesis(row.lic_limit_nm8)+"</font>";
		}
		str += " ]";
	}
	if(row.lic_limit_nm9.length>3){
		str +="업종 또는<br/>[ <font color='blue'>"+formatParenthesis(row.lic_limit_nm9)+"</font>";
		if(row.lic_limit_nm10.length>3){
			str +=" 과 <font color='blue'>"+formatParenthesis(row.lic_limit_nm10)+"</font>";
		}
		str += " ]";
	}
	if(row.lic_limit_nm11.length>3){
		str +="업종 또는<br/>[ <font color='blue'>"+formatParenthesis(row.lic_limit_nm11)+"</font>";
		if(row.lic_limit_nm12.length>3){
			str +=" 과 <font color='blue'>"+formatParenthesis(row.lic_limit_nm12)+"</font>";
		}
		str += " ]";
	}
	if(str.length>0){
		str +="업종을 등록한 업체<br/>";
	}else{
		str +="";
	}
	
	if(type==1){
		return str;
	}else{
		if(str.length>0){
			return "Y";
		}else{
			return "N";
		}
	}
}

function formatParenthesis(str){
	
	if(str.length>0){
		var part = str.split("/");
		
		if(part.length==2){
			return part[0]+"("+part[1]+")";
		}else{
			return str;
		}
	}else{
		return str;
	}
}

function formatTypeLimitDtl(row){
	var headerStr = "<tr>"
	+	"<td class=\"bc\" style=\"width: 10%;\">No.</td>"
	+	"<td class=\"bc\" style=\"width: 30%;\">투찰가능한업종</td>"
	+	"<td class=\"bc\" style=\"width: 50%;\">허용업종</td>"
	+"</tr>";
	
	var str = "";
	
	var cnt = 1;
	
	var limitstr = row.lic_permit_biz_type.replaceAll("\\[","").replaceAll("\\]","");
	
	var limit = limitstr.split(",");
	
	var pos = [row.lic_limit_nm1,row.lic_limit_nm2,row.lic_limit_nm3,row.lic_limit_nm4,row.lic_limit_nm5,row.lic_limit_nm6,
	       row.lic_limit_nm7,row.lic_limit_nm8,row.lic_limit_nm9,row.lic_limit_nm10,row.lic_limit_nm11,row.lic_limit_nm12];
	
	for(var i=0; i<pos.length;i++){
		if(pos[i].length>3){
			
			if(limit[i].length>0){
				var sublimit = limit[i].split("\^");
				
				if(sublimit.length>1){
					for(var j=0;j<sublimit.length;j++){
						str +="<tr>"
							+"<td class=\"bd\" style=\"text-align:center;width: 10%;\">"+cnt+"</td>"
							+"<td class=\"bd\" style=\"width: 30%;\">"+formatParenthesis(pos[i])+"</td>"
							+"<td class=\"bd\" style=\"width: 50%;\">"+formatParenthesis(sublimit[j])+"</td>"
							+"</tr>";
						cnt++;
					}
				}else{
					str +="<tr>"
						+"<td class=\"bd\" style=\"text-align:center;width: 10%;\">"+cnt+"</td>"
						+"<td class=\"bd\" style=\"width: 30%;\">"+formatParenthesis(pos[i])+"</td>"
						+"<td class=\"bd\" style=\"width: 50%;\">"+formatParenthesis(sublimit)+"</td>"
						+"</tr>";
					cnt++;
				}
			}
		}
	}
	
	if(str.length==0){
		str +="<tr>"
			+"<td colspan=\"3\" style=\"text-align:center;width: 100%;\">공고서에 의함</td>"
			+"</tr>";
	}
	return headerStr+str;
}

function formatGoodsListDtl(row){
	var headerStr = "<tr>"
	+"	<td rowspan=\"2\" class=\"bc\" style=\"width: 5%;\">분류</td>"
	+"	<td colspan=\"3\" class=\"bc\" style=\"width: 30%;\">수요기관</td>"
	+"	<td colspan=\"3\" class=\"bc\" style=\"width: 30%;\">세부품명</td>"
	+"	<td colspan=\"3\" class=\"bc\" style=\"width: 30%;\">납품장소</td>"
	+"</tr>"
	+"<tr>"
	+"	<td class=\"bc\" style=\"width: 10%;\">수량</td>"
	+"	<td class=\"bc\" style=\"width: 10%;\">단위</td>"
	+"	<td class=\"bc\" style=\"width: 10%;\">추정단가</td>"
	+"	<td class=\"bc\" style=\"width: 10%;\">세부품명번호</td>"
	+"	<td class=\"bc\" style=\"width: 10%;\">규격</td>"
	+"	<td class=\"bc\" style=\"width: 10%;\">납품기한</td>"
	+"	<td class=\"bc\" colspan=\"3\" style=\"width: 30%;\">인도조건</td>"
	+"</tr>";
	
    var str = "";
	
	var cnt = 1;
	
	if(row.buy_target_goods_info!=null){
		var goodsList = row.buy_target_goods_info.replaceAll("\\##"," ").split(" ");
		
		for(var i=0; i<goodsList.length;i++){
			if(goodsList[i].length>3){
				var sublimit = goodsList[i].split("\^");
				
				str += "<tr>"
					+"	<td rowspan=\"2\" class=\"bd\" style=\"text-align:center;width: 5%;\">"+sublimit[0]+"</td>"
					+"	<td colspan=\"3\" class=\"bd\" style=\"text-align:center;width: 30%;\">"+row.demand_nm+"</td>"
					+"	<td colspan=\"3\" class=\"bd\" style=\"text-align:center;width: 30%;\">"+sublimit[2]+"</td>"
					+"	<td colspan=\"3\" class=\"bd\" style=\"width: 30%;\">"+row.trans_cond_nm+"</td>"
					+"</tr>"
					+"<tr>"
					+"	<td class=\"bd\" style=\"text-align:center;width: 10%;\"></td>"
					+"	<td class=\"bd\" style=\"text-align:center;width: 10%;\">"+row.unit+"</td>"
					+"	<td class=\"bd\" style=\"text-align:center;width: 10%;\"></td>"
					+"	<td class=\"bd\" style=\"text-align:center;width: 10%;\">"+sublimit[1]+"</td>"
					+"	<td class=\"bd\" style=\"width: 10%;\">"+row.stad_nm+"</td>"
					+"	<td class=\"bd\" style=\"text-align:center;width: 10%;\">"+formatDate2(row.dev_limit_dt)+"</td>"
					+"	<td colspan=\"3\" class=\"bd\" style=\"width: 30%;\">"+row.trans_cond_nm+"</td>"
					+"</tr>";
			}
		}
		
		if(str.length==0){
//			str +="<tr>"
//				+"<td colspan=\"3\" style=\"text-align:center;width: 100%;\">공고서에 의함</td>"
//				+"</tr>";
		}
	}
	
	
	return headerStr+str;
}

/**
 * , => 엔터처리
 * @param val
 * @param row
 * @returns {String}
 */
function formatCommaEnter(val,row){
	if(val == null) return;
	var str = val.split(",");
	var returnStr="";
	for(var i=0;i<str.length;i++){
		if(i>0){
			returnStr +="<br/>";
		}
		returnStr +=str[i];
	}
	
    return returnStr;
}


function formatEnter(val,row){
	if(val == null) return;
	
	if(val.length <=13){
		return val;
	}else{
		var str = val.split(" ");
		var returnStr="";
		for(var i=0;i<str.length;i++){
			if(i>0){
				returnStr +="<br/>";
			}
			returnStr +=str[i];
		}
		
		return returnStr;
	}
}

function bidFormatDate(val,row){
	
	var returnStr="";
	
	returnStr = formatDate(row.bid_start_dt);
	returnStr += "<br/>"+ formatDate(row.bid_end_dt);
	
	return returnStr;
}

function bidLicense(val,row){
	var returnStr=val;
	
	returnStr = returnStr.replaceAll("\\\[","");
	returnStr = returnStr.replaceAll("\\\]","");
	returnStr = returnStr.replaceAll(",","");
	returnStr = returnStr.replaceAll("\\\^","<br/>");
	
	
	
	
	return returnStr;
}


/**
 * 날짜 포맷
 * @param val
 * @returns {String}
 */
function formatDate(val){
	
	var dt;
    dt = new Date();
    dt = dt.getFullYear()+""+((dt.getMonth() + 1)<9?"0"+(dt.getMonth() + 1):(dt.getMonth() + 1))+""+(dt.getDate()<10?"0"+dt.getDate():dt.getDate());
	
    if(val!=null && val.length>0){
	    var valdt = val.substring(0,val.length);
	    
    	val = valdt;
        if (eval(dt)-eval(valdt) == 0){

        	if(val.length >8 ){
        		val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8)+" "+val.substring(8,10)+":"+val.substring(10,12);
        	}else{
        		val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8);
        	}
        	
//            return '<span style="color:red;">'+val+'</span>';
        	return val;
        } else {

        	if(val.length >8 ){
        		val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8)+" "+val.substring(8,10)+":"+val.substring(10,12);
        	}else{
        		val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8);
        	}
            return val;
        }
    }else{
    	return "";
    }
}
function formatDate2(val){
	
	var dt;
	dt = new Date();
	dt = dt.getFullYear()+""+((dt.getMonth() + 1)<9?"0"+(dt.getMonth() + 1):(dt.getMonth() + 1))+""+(dt.getDate()<10?"0"+dt.getDate():dt.getDate());
	
	if(val!=null && val.length>0){
		var valdt = val.substring(0,val.length);
		
		val = valdt;
		if (eval(dt)-eval(valdt) == 0){
			
			if(val.length >8 ){
				val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8);
			}else{
				val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8);
			}
			
			return '<span style="color:red;">'+val+'</span>';
		} else {
			
			if(val.length >8 ){
				val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8);
			}else{
				val = val.substring(0,4)+"-"+val.substring(4,6)+"-"+val.substring(6,8);
			}
			return val;
		}
	}else{
		return "";
	}
}


function myformatter(date){
    var y = date.getFullYear();
    var m = date.getMonth()+1;
    var d = date.getDate();
    return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
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

function formatStatus(val,row){
	return val;
}

function formatManufactureNm(val,row){
	
	var result = "";
	
	result = row.bidmanager+" / "+row.phone_no+" / "+row.email;
	
    return result;
}

function formatBigo(val,row){	
	var result = "";	
	result = row.user_nm;
	if(typeof(row.column4) != "undefined" && row.column4 != ""){
		result += ", "+row.column4;
	}		
    return result;
}

function formatStatusStep(val,row){	
	var result = "";	
	if(typeof(row.status_step) == "undefined"){
		result = "미진행";
	}else if(row.status_step == "0"){
		result = "Drop";
	}else if(row.status_step == "1" && row.status_cd2=="003"){
		result = "견적서 대기중 (반려)";
	}else if(row.status_step == "1" && row.status_cd2!="003"){
		result = "견적서 대기중";
	}		
    return result;
}
function formatStatusStep2(val,row){	
	var result = "";	
	if(row.status_step == "1"){
		if(row.status_cd2=="003"){
			result = "[팀장] 반려";
		}
	}else if(row.status_step == "2"){
		if(row.status_cd2=="001"){
			result = "[팀장] 승인중";
		}else if(row.status_cd3=="003"){
			result = "[총괄책임자] 반려";
		}
	}else if(row.status_step == "3"){
		if(row.apply_user_id2=="pass" && row.apply_user_id3=="pass"){
			result = "구두승인 / "+row.apply_dt3;
		}else if(row.apply_user_id2!="pass" && row.apply_user_id3=="pass"){
			result = "팀장 전결 / "+row.apply_dt3;
		}else if(row.status_cd3=="001"){
			result = "[총괄책임자] 승인중";
		}else if(row.status_cd3=="002"){
			result = "유효견적 / "+row.apply_dt3;
		}
	}
    return result;
}
function formatStatusStep3(row){	
	var result = "";	
	if(row.status_step == "1"){
		if(row.status_cd2=="003"){
			result = "[팀장] 반려";
		}
	}else if(row.status_step == "2"){
		if(row.status_cd2=="001"){
			result = "[팀장] 승인중";
		}else if(row.status_cd3=="003"){
			result = "[총괄책임자] 반려";
		}
	}else if(row.status_step == "3"){
		if(row.apply_user_id2=="pass" && row.apply_user_id3=="pass"){
			result = "승인완료";
		}else if(row.apply_user_id2!="pass" && row.apply_user_id3=="pass"){
			result = "승인완료";
		}else if(row.status_cd3=="001"){
			result = "[총괄책임자] 승인중";
		}else if(row.status_cd3=="002"){
			result = "승인완료";
		}
	}
    return result;
}
function formatStatusStepAll(val,row){	
	var result = "";	
	if(typeof(row.status_step) == "undefined"){
		result = "미진행";
	}else if(row.status_step == "0"){
		result = "Drop";
	}else if(row.status_step == "1" && row.status_cd2=="003"){
		result = "견적서 대기중 (반려)";
	}else if(row.status_step == "1" && row.status_cd2!="003"){
		result = "견적서 대기중";
	}else if(row.status_step == "2"){
		result = "승인요청중";
	}else if(row.status_step == "3"){
		if(row.apply_user_id2=="pass" && row.apply_user_id3=="pass"){
			result = "승인완료";
		}else if(row.apply_user_id2!="pass" && row.apply_user_id3=="pass"){
			result = "승인완료";
		}else if(row.status_cd3=="001"){
			result = "승인요청중";
		}else if(row.status_cd3=="002"){
			result = "승인완료";
		}
	}		
    return result;
}
/**
 * 적격심사 문구 컬러
 * @param val
 * @param row
 * @returns {String}
 */
function formatEvalColor(val,row){
     if (val.indexOf("부적격")!=-1){
         return '<span style="color:red;">'+val+'</span>';
     } else {
         return val;
     }
     
     return val
}

function nvlStr(val){
	if(val!=null){
		return val;
	}else{
		return "";
	}
}

function bid_info_detail1(row){
	var str = "";
	str = "<font style=\"font-weight: bold; padding-left: 10px;\"> [ 입찰집행 및 진행정보 ] </font>"
			+"<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\">"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">집행관</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.executor_nm)+"</td>"
			+"		<td class=\"bc\" style=\"width: 20%;\">담당자</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.reg_user_nm)+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">전화번호</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.reg_user_tel)+"</td>"
			+"		<td class=\"bc\" style=\"width: 20%;\">이메일</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.reg_user_mail)+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">입찰개시일시</td>"
			+"		<td style=\"width: 30%;\">"+formatDate(row.bid_start_dt)+"</td>"
			+"		<td class=\"bc\" style=\"width: 20%;\">입찰마감일시</td>"
			+"		<td style=\"width: 30%;\">"+formatDate(row.bid_end_dt)+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\">개찰일시</td>"
			+"		<td>"+formatDate(row.bid_open_dt)+"</td>"
			+"		<td class=\"bc\">개찰장소</td>"
			+"		<td>"+row.open_place+"</td>"
			+"	</tr>"
			+"</table>";
	
	return str;
}

function bid_info_detail2(row){
	
	var val1 = "";
	var display1 = "";
	var info1 = "";
	
	if(row.use_area_info!=null){
		val1 = "투찰제한";
		display1 = "";
		info1 = formatCommaEnter(row.use_area_info);
	}else{
		val1 = "공고서 참조";
		display1 = "display:none";
		info1 = "";
	}
	
	var val2 = "";
	var display2 = "";
	var info2_1 = "";
	var info2_2 = "";
	
	if(formatTypeLimitStr(row, 0)=="Y"){
		val2 = "투찰제한";
		display2 = "";
		info2_1 = formatTypeLimitStr(row, 1);
		info2_2 = formatTypeLimitDtl(row);
	}else{
		val2 = "공고서 참조";
		display2 = "display:none";
		info2_1 = "";
		info2_2 = "";
	}
	
	var val3 = "";
	var display3 = "";
	
	if(row.goods_grp_limit_yn=="Y"){
		val3 = "물품분류 8자리로 입찰참가 제한함";
		display3 = "";
	}else if(row.goods_grp_limit_yn=="N"){
		val3 = "물품분류로 입찰참가 제한하지 않음";
		display3 = "";
	}else{
		val3 = "";
		display3 = "display:none";
	}
	
	var val4 = "";
	var display4 = "";
	
	if(row.product_yn=="Y"){
		val4 = "제조물품으로 제한 (경쟁입찰참가자격등록증에 공고서상 물품분류가 제조물품으로 등록되어 있어야 함)";
		display4 = "";
	}else if(row.product_yn=="N"){
		val4 = "관련없음 (경쟁입찰참가자격등록증에 공고서상 물품분류가 공급 또는 제조물품으로 등록되어 있어야 함)";
		display4 = "";
	}else{
		val4 = "";
		display4 = "display:none";
	}

	var val5 = "";
	var display5 = "";
	
	if(row.branch_bid_use_yn=="Y"){
		val5 = "지사투찰가능";
		display5 = "";
	}else if(row.branch_bid_use_yn=="N"){
		val5 = "지사투찰불허";
		display5 = "";
	}else{
		val5 = "";
		display5 = "display:none";
	}
	
	var val6 = "";
	var display6 = "";
	
	if(row.branch_bid_use_yn=="Y"){
		val6 = "공동수급을 구성하는 모든 업체는 주된영업소(지역)가 참가가능지역에 속해야 함.";
		display6 = "";
	}else if(row.branch_bid_use_yn=="N"){
		val6 = "공고서에 의함";
		display6 = "";
	}else{
		val6 = "";
		display6 = "display:none";
	}
	
	var str="";
	str = "	<font style=\"font-weight: bold; padding-left: 10px;\"> [ 투찰제한 - 일반 ] </font>"
	+"<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\">"
	+"	<tr>"
	+"		<td class=\"bc\" style=\"width: 20%;\">지역제한</td>"
	+"		<td colspan=\"3\" style=\"width: 80%;\">"+val1+"</td>"
	+"	</tr>"
	+"	<tr style=\""+display1+"\">"
	+"		<td class=\"bc\" style=\"width: 20%;\">참가가능지역</td>"
	+"		<td colspan=\"3\">"+info1+"</td>"
	+"	</tr>"
	+"	<tr style=\""+display5+"\">"
	+"		<td class=\"bc\" style=\"width: 20%;\">지사투찰허용여부</td>"
	+"		<td colspan=\"3\">"+val5+"</td>"
	+"	</tr>"
	+"	<tr>"
	+"		<td class=\"bc\" style=\"width: 20%;\">업종제한</td>"
	+"		<td colspan=\"3\">"+val2+"</td>"
	+"	</tr>"
	+"	<tr style=\""+display2+"\">"
	+"		<td class=\"bc\" style=\"width: 20%;\">업종사항제한</td>"
	+"		<td colspan=\"3\">"
	+"			"+info2_1
	+"			<br/>"
	+"			<font color=\"#0000ff\">"
	+"				※업종명을 클릭시 관련 근거법령을 조회하실수 있습니다. <br/>"
	+"				※[]안의 업종제한은 시스템상에 입력된 제한사항으로 공고서와 상이할 수도 있습니다. <br/>"
	+"				    입찰에 참여하시기 전에 반드시 공고서를 숙지하여 정확한 제한 업종을 확인하시기 바랍니다.<br/><br/> "
	+"				 ※아래는 제한된 업종에 대해 투찰가능한 허용업종 상황을 보여줍니다. 확인하시기 바랍니다.	 "
	+"			</font>"
	+"			<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\">"
	+"			"+info2_2
	+"			</table>"
	+"		</td>"
	+"	</tr>"
	+"	<tr style=\""+display3+"\">"
	+"		<td class=\"bc\" style=\"width: 20%;\">물품분류제한여부</td>"
	+"		<td colspan=\"3\">"+val3+"</td>"
	+"	</tr>"
	+"	<tr style=\""+display4+"\">"
	+"		<td class=\"bc\" style=\"width: 20%;\">물품등록구분</td>"
	+"		<td colspan=\"3\">"+val4+"</td>"
	+"	</tr>"
	+"	<tr style=\""+display6+"\">"
	+"		<td class=\"bc\" style=\"width: 20%;\">공동수급체 구성원<br/>지역제한적용여부</td>"
	+"		<td colspan=\"3\">"+val6+"</td>"
	+"	</tr>"
	+"</table>";
	
	return str;
}

function bid_info_detail3(row){
	var str = "";
	
	str = "<font style=\"font-weight: bold; padding-left: 10px;\"> [ 구매대상물품 ] </font>"
	+"<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\" id=\"tab1_goods_list_dtl\">"
	+" "+formatGoodsListDtl(row)
	+"</table>";
	
	return str;
	
}
function bid_info_detail4(row){
	var str = "";
	
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
	
	
	str = "<font style=\"font-weight: bold; padding-left: 10px;\"> [ 첨부문서 ] </font>"
	+"<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\">"
	+"	<tr>"
	+"		<td class=\"bc\" style=\"width: 20%;\">첨부문서(공고문)</td>"
	+"		<td colspan=\"3\">"
	+"			<div style=\""+display[0]+"\">"
	+"					<a href=\""+row.notice_spec_form1+"\" >"+row.notice_spec_file_nm1+"</a>"
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
	+"			</div>"
	+"		</td>"
	+"	</tr>"
	+"</table>"
	
	return str;
	
}

function bid_result_info_detail1(row){
	var str = "";
	str = "<font style=\"font-weight: bold; padding-left: 10px;\"> [ 입찰결과 ] </font>"
			+"<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\">"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">입찰공고번호</td>"
			+"		<td colspan=\"3\">"+row.bid_notice_no+"-"+row.bid_notice_cha_no+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">공고명</td>"
			+"		<td colspan=\"3\">"+nvlStr(row.bid_notice_nm)+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">공고기관</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.order_agency_nm)+"</td>"
			+"		<td class=\"bc\" style=\"width: 20%;\">수요기관</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.demand_nm)+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">집행관</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.executor_nm)+"</td>"
			+"		<td class=\"bc\" style=\"width: 20%;\">담당자</td>"
			+"		<td style=\"width: 30%;\">"+nvlStr(row.reg_user_nm)+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">실제개찰일시</td>"
			+"		<td colspan=\"3\">"+formatDate(row.bid_open_dt)+"</td>"
			+"	</tr>"
			+"	<tr>"
			+"		<td class=\"bc\" style=\"width: 20%;\">유의사항</td>"
			+"		<td colspan=\"3\">ㅁ 사전판정 과정에서 부적격 처리된 업체의 투찰금액과 투찰률은 표시되지 않습니다. 판정관련 문의는 해당 공고의 입찰집행관에게 문의하시기 바랍니다.</td>"
			+"	</tr>"
			+"</table>";
	
	return str;
}
function bid_result_info_detail2(reason){
	var str = "";
	str = "<font style=\"font-weight: bold; padding-left: 10px;\"> [ 입찰결과 ] </font>"
		+"<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\">"
		+"	<tr>"
		+"		<td class=\"bc\" style=\"width: 20%;\">입찰결과</td>"
		+"		<td colspan=\"3\">유찰 되었습니다.</td>"
		+"	</tr>"
		+"	<tr>"
		+"		<td class=\"bc\" style=\"width: 20%;\">유찰사유</td>"
		+"		<td colspan=\"3\">"+nvlStr(reason)+"</td>"
		+"	</tr>"
		+"</table>";
	
	return str;
}
function bid_result_info_detail3(row){
	var str = "";
	str = "<font style=\"font-weight: bold; padding-left: 10px;\"> [ 입찰결과 ] </font>"
		+"<table cellpadding=\"5\" style=\"width: 100%; padding: 10px;\">"
		+"	<tr>"
		+"		<td class=\"bc\" style=\"width: 20%;\">입찰결과</td>"
		+"		<td>재입찰 되었습니다.</td>"
		+"	</tr>"
		+"	<tr>"
		+"		<td class=\"bc\" style=\"width: 20%;\">재입찰사유</td>"
		+"		<td>"+nvlStr(row.re_cont_reason)+"</td>"
		+"	</tr>"
		+"	<tr>"
		+"		<td class=\"bc\" style=\"width: 20%;\">입찰서 마감일시</td>"
		+"		<td style=\"width: 30%;\">"+formatDate(row.bid_end_dt)+"</td>"
		+"		<td class=\"bc\" style=\"width: 20%;\">개찰일시</td>"
		+"		<td style=\"width: 30%;\">"+formatDate(row.bid_open_dt)+"</td>"
		+"	</tr>"
		+"</table>";
	
	return str;
}

function formatContBizInfo1(val, row){
	if(row.cont_biz_info!=null){
		var contBizInfoArr = row.cont_biz_info.split("^");
		if(contBizInfoArr.length == 1){
			contBizInfoArr = row.cont_biz_info.split("\###"); //변경전 api는 ###으로 구분. 기존DB를 수정하지 않고 기존 데이터를 그대로 사용하기 위한 처리.
		}
		if(contBizInfoArr.length >= 5){ //낙찰예정자가 한 명일 경우.
			return contBizInfoArr[0]; //업체명
		}else{ //낙찰예정자가 다수일 경우.
			return contBizInfoArr[0]; //"낙찰예정자 다수"
		}
	}
}
function formatContBizInfo2(val, row){
	if(row.cont_biz_info!=null){
		var contBizInfoArr = row.cont_biz_info.split("^");
		if(contBizInfoArr.length == 1){
			contBizInfoArr = row.cont_biz_info.split("\###"); //변경전 api는 ###으로 구분. 기존DB를 수정하지 않고 기존 데이터를 그대로 사용하기 위한 처리.
		}
		if(contBizInfoArr.length >= 5){ //낙찰예정자가 한 명일 경우.
			return numberComma(contBizInfoArr[3]); //투찰금액
		}else{ //낙찰예정자가 다수일 경우.
			return numberComma(contBizInfoArr[1]); //투찰금액
		}
	}
}
function formatContBizInfo3(val, row){
	if(row.cont_biz_info!=null){
		var contBizInfoArr = row.cont_biz_info.split("^");
		if(contBizInfoArr.length == 1){
			contBizInfoArr = row.cont_biz_info.split("\###"); //변경전 api는 ###으로 구분. 기존DB를 수정하지 않고 기존 데이터를 그대로 사용하기 위한 처리.
		}
		if(contBizInfoArr.length >= 5){ //낙찰예정자가 한 명일 경우.
			return contBizInfoArr[4]; //투찰율
		}else{ //낙찰예정자가 다수일 경우.
			return contBizInfoArr[2]; //투찰율
		}
	}
}
function formatContBizInfo4(val, row){
	return Math.ceil((parseInt(row.join_com_cnt)/parseInt(row.cont_biz_num))*1000)/10;
}

function formatParticipationRate(val, row){
	if(row.join_com_cnt == 0 || row.join_req_com_cnt == 0){
		return 0;
	}else{
		return Math.ceil((parseInt(row.join_com_cnt)/parseInt(row.join_req_com_cnt))*1000)/10;
	}
}
function formatCheckBox(value, row){
	return '<input type="checkbox" class="importantCheckbox" style="z-index:999999999 !important; display:inline-block;" onclick="checkItem(this,\'' + row.bid_notice_no + '\',\'' + row.bid_notice_cha_no + '\')" ' + (row.important_yn=="Y" ? "checked" : "") + '/>';
}
function businessState(val,row){
	var returnMsg = "";
	var str = String(row.business_state);
	
	if(str.indexOf("입찰참가 신청") != -1){
		returnMsg = "참가신청요청";
	}else if(str.indexOf("물품분류번호 등록") != -1){
		returnMsg = "물품분류번호등록요청";
	}else if(str.indexOf("상품확인요청") != -1){
		returnMsg = "상품확인요청";
	}else if(str.indexOf("당일상품마감알림") != -1){
		returnMsg = "상품마감알림";
	}else{
		returnMsg = "대기중";
	}
	
	if(typeof(row.business_send_msg)!="undefined" && row.business_send_msg!=""){
		returnMsg += " / " + row.business_send_msg;
	}
	return returnMsg;
}
function checkItem(elem, bidNoticeNo, bidNoticeChaNo){
	var hostIndex = location.href.indexOf(location.host) + location.host.length;
	var contextPath = location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
	
	$.ajax({ 
		type: "POST"
		,url: contextPath + '/' + '/bid/checkImportant.do'
		,async: true 
	    ,data : {
	    	important_yn : $(elem).is(':checked') ? 'Y' : 'N',
	    	bid_notice_no : bidNoticeNo,
	    	bid_notice_cha_no : bidNoticeChaNo
		}
	    ,dataType: "json"
	    ,success:function(json){
	    	jsonData=json;
	    }
	    ,error:function(json){	    	
	    }
	});
}
String.prototype.trim = function()
{
  this.replace(/(^\s*)|(\s*$)/gi, "");
  return this;
};

String.prototype.replaceAll = function(str1, str2)
{
  var temp_str = this.trim();
  temp_str = temp_str.replace(eval("/" + str1 + "/gi"), str2);
  return temp_str;
};

