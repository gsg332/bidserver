package egovframework.com.bidserver.opening.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.opening.service.OpeningService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("openingService")
public class OpeningServiceImpl extends EgovAbstractServiceImpl implements OpeningService {
	
	List<HashMap> resultList;
	
	@Resource(name = "openingMapper")
	private OpeningMapper openingMapper;
	
	@Resource(name = "openingService")
	private OpeningService openingService;
	
	@Override
	public List<HashMap> selectBidConfirmList(HashMap map) throws Exception {
		return openingMapper.selectBidConfirmList(map);
	}
	
	@Override
	public int getBidConfirmListCnt(HashMap map) throws Exception {
		return openingMapper.getBidConfirmListCnt(map);
	}
	
	@Override
	public List<HashMap> selectBusinessList(HashMap map) throws Exception {
		
		List<HashMap> resultList = new ArrayList<HashMap>();

		if(((String)map.get("bid_notice_no")).length()>0){
			map.put("pageNo", 0);
			map.put("rows", 10);
			map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));
			
			List bidInfo = openingService.selectBidList(map);
			
			if(bidInfo.size() > 0){
				List<HashMap> businessList = openingService.businessList(map);
											
				HashMap paramMap = new HashMap();
				paramMap.put("bid_notice_no", map.get("bid_notice_no"));
				paramMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
				
				resultList = openingService.selectBusinessRelList(paramMap);
			}
		}
		
		return resultList;
	}
	
	@Override
	public int getBidListCnt(HashMap map) throws Exception {
		return openingMapper.getBidListCnt(map);
	}
	
	@Override
	public List<HashMap> selectBidList(HashMap map) throws Exception {
		return openingMapper.selectBidList(map);
	}
	
	@Override
	public List<HashMap> businessList(HashMap map) throws Exception {
		return openingMapper.businessList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessDtlList(HashMap map) throws Exception {
		return openingMapper.selectBusinessDtlList(map);
	}
	
	@Override
	public List<HashMap> selectBidDtl(HashMap map) throws Exception {
		return openingMapper.selectBidDtl(map);
	}
	
	@Override
	public String getEvalutionValue(String business_no, String type) throws Exception {
		
		String resultStr="부적격";
		
		HashMap map = new HashMap();
		map.put("s_business_no", business_no);
		map.put("pageNo", 0);
		map.put("rows", 1);
		List<HashMap> list= openingMapper.selectBusinessDtlList(map);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		
		String B = (String)list.get(0).get("start_dt");		//개업년월일
		String C = (String)list.get(0).get("credit_cd");	//신용등급
		String D = (String)list.get(0).get("nep_yn");		//nep/net 여부
		String E = (String)list.get(0).get("license_yn");	//특허여부
		String F = (String)list.get(0).get("model_yn");		//실용신안/디자인등록 여부
		String G = (String)list.get(0).get("gdgs_yn");		//GD/GS인증 여부
		String H = (String)list.get(0).get("female_dt");	//여성기업년월일
		String I = (String)list.get(0).get("innovate_yn");	//혁신형기업
		String J = (String)list.get(0).get("scale_cd");		//기업형태
		
		String now_dt = sdf.format(new Date());
		
		float K = 0;	//개업년수
		float L = 0;	//여성기업년수
		if(B!=null && B.length()>0){
			K = doDiffOfDate(B, now_dt)/365;
		}
		if(H!=null && H.length()>0){
			L = doDiffOfDate(H, now_dt)/365;
		}
		

		HashMap paramMap = new HashMap();
		resultList = openingMapper.evalutionList(paramMap);
		
		
		
		
		//경영상태 점수
		float O = 0;
		
		//창립 5년 미만
		if(K < 5){
			O = getEvalutionData("신용평가", "001", "조달청", "창업기간");
		}else{
			//신용평가
			O = getEvalutionData("신용평가", C, "조달청", "신용평가");
		}
		
		//경영상태 점수
		float P = getEvalutionData("신용평가", C, "조달청", "신용평가");
		
		//최저가격 점수
		float R = getEvalutionData("가격점수", null, "조달청", "가격점수");
		
		//신인도 점수
		float W1 = 0;
		float W2 = 0;
		float W3 = 0;
		
		
		//신인도 항목별 점수
		float S1 = 0;
		float T1 = 0;
		float U1 = 0;
		float V1 = 0;
		float S2 = 0;
		float T2 = 0;
		float U2 = 0;
		float V2 = 0;
		float S3 = 0;
		float T3 = 0;
		float U3 = 0;
		float V3 = 0;
		
		if(D!=null && D.equals("Y")){
			S1 = getEvalutionData("신인도", null, "조달청", "net/nep");
			S2 = getEvalutionData("신인도", null, "조달청(중소기업)", "net/nep");
			S3 = getEvalutionData("신인도", null, "중기청", "net/nep");
		}
		
		if(E!=null && E.equals("Y")){
			T1 = getEvalutionData("신인도", null, "조달청", "특허");
			T2 = getEvalutionData("신인도", null, "조달청(중소기업)", "특허");
			T3 = getEvalutionData("신인도", null, "중기청", "특허");
		}else{
			if(F!=null && F.equals("Y")){
				T1 = getEvalutionData("신인도", null, "조달청", "실용신안/디자인등록");
				T2 = getEvalutionData("신인도", null, "조달청(중소기업)", "실용신안/디자인등록");
				T3 = getEvalutionData("신인도", null, "중기청", "실용신안/디자인등록");
			}else{
				if(G!=null && G.equals("Y")){
					T1 = getEvalutionData("신인도", null, "조달청", "GD/GS인증");
					T2 = getEvalutionData("신인도", null, "조달청(중소기업)", "GD/GS인증");
					T3 = getEvalutionData("신인도", null, "중기청", "GD/GS인증");
				}
			}
		}

		if(H !=null && H.length()>0){
			if(L < 3){
				U1 = getEvalutionData("신인도", "004", "조달청", "기간");
				U2 = getEvalutionData("신인도", "004", "조달청(중소기업)", "기간");
				U3 = getEvalutionData("신인도", "004", "중기청", "기간");
			}else{
				if(L < 5){
					U1 = getEvalutionData("신인도", "003", "조달청", "기간");
					U2 = getEvalutionData("신인도", "003", "조달청(중소기업)", "기간");
					U3 = getEvalutionData("신인도", "003", "중기청", "기간");
				}else{
					if(L < 10){
						U1 = getEvalutionData("신인도", "002", "조달청", "기간");
						U2 = getEvalutionData("신인도", "002", "조달청(중소기업)", "기간");
						U3 = getEvalutionData("신인도", "002", "중기청", "기간");
					}else{
						U1 = getEvalutionData("신인도", "001", "조달청", "기간");
						U2 = getEvalutionData("신인도", "001", "조달청(중소기업)", "기간");
						U3 = getEvalutionData("신인도", "001", "중기청", "기간");
					}
				}
			}
		}
		
		if(I!=null && I.equals("Y")){
			V1 = getEvalutionData("신인도", null, "조달청", "혁신형중소기업");
			V2 = getEvalutionData("신인도", null, "조달청(중소기업)", "혁신형중소기업");
			V3 = getEvalutionData("신인도", null, "중기청", "혁신형중소기업");
		}else{
			if(J!=null && (J.equals("001") || J.equals("002") || J.equals("003"))){
				V1 = getEvalutionData("신인도", J, "조달청", "기업규모");
				V2 = getEvalutionData("신인도", J, "조달청(중소기업)", "기업규모");
				V3 = getEvalutionData("신인도", J, "중기청", "기업규모");
			}
		}
		
		//신인도 항목별 점수 합
		W1 = S1+T1+U1+V1;
		W2 = S2+T2+U2+V2;
		W3 = S3+T3+U3+V3;
		
		//조달청(중소기업)/중기청 고시금액 미만 경영상태
		float M = 0;
		float M1 = 0;
		
		if(J!=null && (J.equals("001") || J.equals("002"))){
			M = getEvalutionData("신용평가", J, "조달청(중소기업)", "기업규모");
			M1 = getEvalutionData("신용평가", J, "중기청", "기업규모");
		}else{
			if(K < 5){
				M = getEvalutionData("신용평가", "001", "조달청(중소기업)", "창업기간");
				M1 = getEvalutionData("신용평가", "001", "중기청", "창업기간");
			}else{
				M = getEvalutionData("신용평가", C, "조달청(중소기업)", "신용평가");
				M1 = getEvalutionData("신용평가", C, "중기청", "신용평가");
			}
		}
		
		//조달청(중소기업)/중기청 10억 미만 경영상태
		float N = getEvalutionData("신용평가", C, "조달청(중소기업)", "신용평가");
		float N1 = getEvalutionData("신용평가", C, "중기청", "신용평가");
		
		//경영상태 점수
		float Q = getEvalutionData("가격점수", null, "조달청(중소기업)", "가격점수");
		float Q1 = getEvalutionData("가격점수", null, "중기청", "가격점수");
		
		
		float AD = 0;
		float AE = 0;
		float AJ = 0;
		float AF = 0;
		float AG = 0;
		float AH = 0;
		float AI = 0;

		
		if(type.equals("301")){
			AD = getEvalutionData("신용평가", C, "안행부", "신용평가");
			AE = getEvalutionData("가격점수", null, "안행부", "가격점수");
			
			if(D!=null && D.equals("Y")){
				AF = getEvalutionData("신인도", null, "안행부", "net/nep");
			}else{
				if(E!=null && E.equals("Y")){
					AF = getEvalutionData("신인도", null, "안행부", "특허");
				}else{
					if(G!=null && G.equals("Y")){
						AF = getEvalutionData("신인도", null, "안행부", "GD/GS인증");
					}else{
						if(F!=null && F.equals("Y")){
							AF = getEvalutionData("신인도", null, "안행부", "실용신안/디자인등록");
						}
					}
				}
			}
			
			if(I!=null && I.equals("Y")){
				AG = getEvalutionData("신인도", null, "안행부", "혁신형중소기업");
			}else{
				if(J!=null && (J.equals("001") || J.equals("002") || J.equals("003"))){
					AG = getEvalutionData("신인도", J, "안행부", "기업규모");
				}
			}
			
			if(H !=null && H.length()>0){
				AH = getEvalutionData("신인도", "001", "안행부", "기간");
			}

			if(K <= 2){
				AI = 1;
			}
			
			AJ = AF+AG+AH+AI;
		}
		
		
		float AL = 0;
		float AM = 0;
		float AN = 0;
		float AO = 0;
		float AP = 0;
		float AQ = 0;
		
		if(type.equals("401") || type.equals("402")){
			
			if(K < 2){
				AL = getEvalutionData("신용평가", "002", "국방부", "창업기간");
			}else{
				//신용평가
				AL = getEvalutionData("신용평가", C, "국방부", "신용평가");
			}
			
			AM = getEvalutionData("신용평가", C, "국방부", "신용평가");
			
			AN = getEvalutionData("가격점수", null, "국방부", "가격점수");
			
			if(I!=null && I.equals("Y")){
				AO = getEvalutionData("신인도", null, "국방부", "혁신형중소기업");
			}
			
			if(H !=null && H.length()>0){
				if(L < 5){
					AP = getEvalutionData("신인도", "003", "조달청", "기간");
				}else{
					if(L < 10){
						AP = getEvalutionData("신인도", "002", "조달청", "기간");
					}else{
						AP = getEvalutionData("신인도", "001", "조달청", "기간");
					}
				}
			}
			
			AQ = AO+AP;
		}
		
		
		float AT = 0;
		float AU = 0;
		
		if(type.equals("601")){
			AT = getEvalutionData("신용평가", C, "국제입찰", "신용평가");
			AU = getEvalutionData("가격점수", null, "국제입찰", "가격점수");
		}
		
		float AV = 0;
		float AW = 0;
		
		float AX = 0;
		float AY = 0;
		float AZ = 0;
		float BA = 0;
		float BB = 0;
		
		float BC = 0;
		
		if(type.equals("701")){
			AV = getEvalutionData("신용평가", C, "도로공사", "신용평가");
			AW = getEvalutionData("가격점수", null, "도로공사", "가격점수");
			
			if(D!=null && D.equals("Y")){
				AX = getEvalutionData("신인도", null, "도로공사", "net/nep");
			}
			if(E!=null && E.equals("Y")){
				AY = getEvalutionData("신인도", null, "도로공사", "특허");
			}
			if(G!=null && G.equals("Y")){
				AZ = getEvalutionData("신인도", null, "도로공사", "GD/GS인증");
			}
			if(I!=null && I.equals("Y")){
				BA = getEvalutionData("신인도", null, "도로공사", "혁신형중소기업");
			}
			
			if(H !=null && H.length()>0){
				BB = getEvalutionData("신인도", "001", "도로공사", "기간");
			}
			
			BC = AX+AY+AZ+BA+BB;
			
			if(BC >3){
				BC = 3;
			}
		}
		
		
		if(type.equals("101")){
			//조달청 추정가격고시금액 미만
			if(O+R+W1 >= getEvalutionData("적격통과점수", null, "조달청", "적격통과점수")){
				return resultStr = "적격<br/>("+(O+R+W1)+")";
			}else{
				return resultStr = "부적격<br/>("+(O+R+W1)+")";
			}
		}
		
		if(type.equals("102")){
			//조달청 10억미만
			if(P+R+W1 >= getEvalutionData("적격통과점수", null, "조달청", "적격통과점수")){
				return resultStr = "적격<br/>("+(P+R+W1)+")";
			}else{
				return resultStr = "부적격<br/>("+(P+R+W1)+")";
			}
		}
		
		if(type.equals("201")){
			//조달청(중소기업) 추정가격고시금액 미만
			if(M+Q+W2 >= getEvalutionData("적격통과점수", null, "조달청(중소기업)", "적격통과점수")){
				return resultStr = "적격<br/>("+(M+Q+W2)+")";
			}else{
				return resultStr = "부적격<br/>("+(M+Q+W2)+")";
			}
		}
		
		if(type.equals("202")){
			//조달청(중소기업) 10억미만
			if(N+Q+W2 >= getEvalutionData("적격통과점수", null, "조달청(중소기업)", "적격통과점수")){
				return resultStr = "적격<br/>("+(N+Q+W2)+")";
			}else{
				return resultStr = "부적격<br/>("+(N+Q+W2)+")";
			}
		}
		
		if(type.equals("301")){
			//안행부 
			if(AD+AE+AJ+getEvalutionData("신용평가", null, "안행부", "실적") >= getEvalutionData("적격통과점수", null, "안행부", "적격통과점수")){
				return resultStr = "적격<br/>("+(AD+AE+AJ+getEvalutionData("신용평가", null, "안행부", "실적"))+")";
			}else{
				return resultStr = "부적격<br/>("+(AD+AE+AJ+getEvalutionData("신용평가", null, "안행부", "실적"))+")";
			}
		}
		
		if(type.equals("401")){
			//국방부 추정가격고시금액 미만
			if(AL+AN+AQ >= getEvalutionData("적격통과점수", null, "국방부", "적격통과점수")){
				return resultStr = "적격<br/>("+(AL+AN+AQ)+")";
			}else{
				return resultStr = "부적격<br/>("+(AL+AN+AQ)+")";
			}
		}
		
		if(type.equals("402")){
			//국방부 10억 미만
			if(AM+AN+AQ >= getEvalutionData("적격통과점수", null, "국방부", "적격통과점수")){
				return resultStr = "적격<br/>("+(AM+AN+AQ)+")";
			}else{
				return resultStr = "부적격<br/>("+(AM+AN+AQ)+")";
			}
		}
		
		if(type.equals("501")){
			//중기청  추정가격고시금액 미만
			if(M1+Q1+W3>= getEvalutionData("적격통과점수", null, "중기청", "적격통과점수")){
				return resultStr = "적격<br/>("+(M1+Q1+W3)+")";
			}else{
				return resultStr = "부적격<br/>("+(M1+Q1+W3)+")";
			}
		}
		
		if(type.equals("502")){
			//중기청 10억 미만
			if(N1+Q1+W3 >= getEvalutionData("적격통과점수", null, "중기청", "적격통과점수")){
				return resultStr = "적격<br/>("+(N1+Q1+W3)+")";
			}else{
				return resultStr = "부적격<br/>("+(N1+Q1+W3)+")";
			}
		}
		
		if(type.equals("601")){
			//국제입찰
			if(AT+AU >= getEvalutionData("적격통과점수", null, "국제입찰", "적격통과점수")){
				return resultStr = "적격<br/>("+(AT+AU)+")";
			}else{
				return resultStr = "부적격<br/>("+(AT+AU)+")";
			}
		}
		if(type.equals("701")){
			//도로공사 5억미만
			if(AV+AW+BC >= getEvalutionData("적격통과점수", null, "도로공사", "적격통과점수")){
				return resultStr = "적격<br/>("+(AV+AW+BC)+")";
			}else{
				return resultStr = "부적격<br/>("+(AV+AW+BC)+")";
			}
		}
		
		return "";
	}
	
public float getEvalutionData(String eval_group,String eval_cd,String eval_gubun,String eval_type) throws Exception {
		
		try {
			
			List<HashMap> backupList = new ArrayList<HashMap>();
			backupList.addAll(resultList);
			
			for(int i= backupList.size()-1; i > -1 ;i--){
				if(eval_group!=null){
					if(!((String)backupList.get(i).get("eval_group")).equals(eval_group)){
						backupList.remove(i);
						continue;
					}
				}
				if(eval_cd!=null){
					if(!((String)backupList.get(i).get("eval_cd")).equals(eval_cd)){
						backupList.remove(i);
						continue;
					}
				}
				if(eval_gubun!=null){
					if(!((String)backupList.get(i).get("eval_gubun")).equals(eval_gubun)){
						backupList.remove(i);
						continue;
					}
				}
				if(eval_type!=null){
					if(!((String)backupList.get(i).get("eval_type")).equals(eval_type)){
						backupList.remove(i);
						continue;
					}
				}
			}
			
			
			if(backupList.size()>0){
				return (float)backupList.get(0).get("val");
			}else{
				return 0;
			}
		} catch (Exception e) {
			// TODO: handle exception
			return 0;
		}
		
	}

	@Override
	public List<HashMap> selectBusinessCompanyTypeList(HashMap map) throws Exception {
		return openingMapper.selectBusinessCompanyTypeList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessGoodsTypeList(HashMap map) throws Exception {
		return openingMapper.selectBusinessGoodsTypeList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessRelList(HashMap map) throws Exception {
		return openingMapper.selectBusinessRelList(map);
	}
	
	// 두날짜의 차이 구하기 
	public long doDiffOfDate(String start, String end){
	    try {
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
	        Date beginDate = formatter.parse(start);
	        Date endDate = formatter.parse(end);
	         
	        // 시간차이를 시간,분,초를 곱한 값으로 나누면 하루 단위가 나옴
	        long diff = endDate.getTime() - beginDate.getTime();
	        long diffDays = diff / (24 * 60 * 60 * 1000);
	 
	        return diffDays;
	         
	    } catch (ParseException e) {
	        e.printStackTrace();
	        return 0;
	    }
	}
	
	@Override
	public int selectBusinessDtlCnt(HashMap map) throws Exception {
		return openingMapper.selectBusinessDtlCnt(map);
	}
	
	@Override
	public List<HashMap> selectBusinessDtl(HashMap map) throws Exception {
		return openingMapper.selectBusinessDtl(map);
	}
		
	@Override
	public List<HashMap> selectBidOpenResultList(HashMap map) throws Exception {
		return openingMapper.selectBidOpenResultList(map);
	}
	
	@Override
	public int getBidOpenResultListCnt(HashMap map) throws Exception {
		return openingMapper.getBidOpenResultListCnt(map);
	}
	
	@Override
	public List<HashMap> selectBidOpenResultCompt(HashMap map) throws Exception {
		return openingMapper.selectBidOpenResultCompt(map);
	}
	
	@Override
	public List<HashMap> selectBidOpenResultFail(HashMap map) throws Exception {
		return openingMapper.selectBidOpenResultFail(map);
	}
	
	@Override
	public List<HashMap> selectBidOpenResultRebid(HashMap map) throws Exception {
		return openingMapper.selectBidOpenResultRebid(map);
	}
	
	@Override
	public List<HashMap> selectBidOpenResultComptBy(HashMap map) throws Exception {
		return openingMapper.selectBidOpenResultComptBy(map);
	}
	
	@Override
	public void insertBidMessage(HashMap map) throws Exception {
		openingMapper.insertBidMessage(map);
	}
	
	@Override
	public void updateBusinessRelList(HashMap map) throws Exception {
		openingMapper.updateBusinessRelList(map);
	}
	
	@Override
	public void updateBusinessRelList2(HashMap map) throws Exception {
		openingMapper.updateBusinessRelList2(map);
	}
	
	@Override
	public void updateBusinessRelList3(HashMap map) throws Exception {
		openingMapper.updateBusinessRelList3(map);
	}
	
	@Override
	public void updateBusinessList(HashMap map) throws Exception {
		openingMapper.updateBusinessList(map);
	}
	
	@Override
	public void deleteBusinessList(HashMap map) throws Exception {
		openingMapper.deleteBusinessList(map);
	}
	
	@Override
	public void deleteMessage(HashMap map) throws Exception {
		openingMapper.deleteMessage(map);
	}
	
	@Override
	public int selectMessageTotalCnt(HashMap map) throws Exception {
		return openingMapper.selectMessageTotalCnt(map);
	}
	
	@Override
	public List<HashMap> selectLicenseList(HashMap map) throws Exception {
		return openingMapper.selectLicenseList(map);
	}
	
	@Override
	public int businessChk(HashMap map) throws Exception {
		return openingMapper.businessChk(map);
	}
	
	@Override
	public List<HashMap> selectBusinessList2(HashMap map) throws Exception {
		return openingMapper.selectBusinessList2(map);
	}
	
	@Override
	public List<HashMap> selectBusinessList3(HashMap map) throws Exception {
		return openingMapper.selectBusinessList3(map);
	}
	
	@Override
	public void updateBusinessList2(HashMap map) throws Exception {
		openingMapper.updateBusinessList2(map);
	}
	
	@Override
	public void updateBusinessSendYn(HashMap map) throws Exception {
		openingMapper.updateBusinessSendYn(map);
	}
	
	@Override
	public List<HashMap> selectBidRangeList(HashMap map) throws Exception {
		return openingMapper.selectBidRangeList(map);
	}
	
	@Override
	public void deleteBidRangeList(HashMap map) throws Exception {
		openingMapper.deleteBidRangeList(map);
	}
	
	@Override
	public void insertBidRangeList(HashMap map) throws Exception {
		openingMapper.insertBidRangeList(map);
	}
	
	@Override
	public HashMap selectEstimateReportInfo(HashMap map) throws Exception {
		return openingMapper.selectEstimateReportInfo(map);
	}

	@Override
	public void insertBusinessRelList(HashMap map) throws Exception {
		openingMapper.insertBusinessRelList(map);
	}
	
}