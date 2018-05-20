package egovframework.com.bidserver.schedule.service.impl;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.bidserver.distribution.service.impl.DistributionMapper;
import egovframework.com.bidserver.enterprise.service.EnterpriseService;
import egovframework.com.bidserver.schedule.service.PublicDataService;
import egovframework.com.bidserver.schedule.web.PublicDataConstants;
import egovframework.com.bidserver.util.StringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * 공공데이터 조회 후 DB저장
 * 
 * @author tips
 * 
 */




@Service("publicDataService")
public class PublicDataServiceImpl extends PublicDataConstants implements PublicDataService {

	@Resource(name = "propertiesService")
	EgovPropertyService egovPropertyService;
	
	@Resource(name = "publicDataMapper")
	private PublicDataMapper publicDataMapper;
	
	@Resource(name = "distributionMapper")
	private DistributionMapper distributionMapper;
	
	@Resource(name = "enterpriseService")
	private EnterpriseService enterpriseService;
	
	@Resource(name = "publicDataService")
	private PublicDataService publicDataService;
	
	@Override
	public void getData() throws Exception {
		System.out.println("데이터 실행");

		Calendar cal = Calendar.getInstance();
		
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		
		String eDate = format.format(cal.getTime());
		cal.add(cal.DATE, -1);
		String sDate = format.format(cal.getTime());

		// 사전규격서비스 나라장터_사전규격_물품_목록을_조회
		HashMap paramMap = new HashMap();
//		paramMap.put("sDate", sDate);
//		paramMap.put("eDate", eDate);
//		getData(HrcspSsstndrdInfoService, getPublicPrcureThngInfoThng, new HashMap());

		// 입찰공고정보서비스 나라장터_입찰공고_물품_목록을_조회
		paramMap = new HashMap();
		/*
		paramMap.put("dateType", "");
		paramMap.put("sDate", sDate);
		paramMap.put("eDate", eDate);
		*/
		paramMap.put("inqryDiv", "1"); //  조회구분 1:등록일시, 2:입찰공고번호
		paramMap.put("inqryBgnDt", sDate);
		paramMap.put("inqryEndDt", eDate);
		
		getData(BidPublicInfoService, getBidPblancListInfoThng, paramMap);

		// 낙찰정보조회서비스 나라장터 최종낙찰자 물품 목록을 조회
//		paramMap = new HashMap();
//		paramMap.put("dateType", "");
//		paramMap.put("sDate", sDate);
//		paramMap.put("eDate", eDate);
//		getData(ScsbidInfoService, getScsbidListSttusThng, paramMap);

		// 낙찰정보조회서비스 나라장터 개찰결과 물품 목록을 조회
//		paramMap = new HashMap();
//		paramMap.put("dateType", "");
//		paramMap.put("sDate", sDate);
//		paramMap.put("eDate", eDate);
//		getData(ScsbidInfoService, getOpengResultListInfoThng, paramMap);
//
//		// 계약정보조회서비스 나라장터 계약현황 물품 목록을 조회
//		paramMap = new HashMap();
//		paramMap.put("dateType", "");
//		paramMap.put("sDate", sDate);
//		paramMap.put("eDate", eDate);
//		getData(CntrctInfoService, getCntrctInfoListThngCntrctSttus, paramMap);

		System.out.println("데이터 종료");
	}
	
	@Override
	public void getData2() throws Exception {
		System.out.println("데이터 실행");
		
		Calendar cal = Calendar.getInstance();
		
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmm");
		
		String eDate = format.format(cal.getTime());
		cal.add(cal.DATE, -1);
		String sDate = format.format(cal.getTime());
		
		// 사전규격서비스 나라장터_사전규격_물품_목록을_조회
		HashMap paramMap = new HashMap();
		// 낙찰정보조회서비스 나라장터 최종낙찰자 물품 목록을 조회
//		paramMap = new HashMap();
//		paramMap.put("dateType", "");
//		paramMap.put("sDate", sDate);
//		paramMap.put("eDate", eDate);
//		getData(ScsbidInfoService, getScsbidListSttusThng, paramMap);
		
		// 낙찰정보조회서비스 나라장터 개찰결과 물품 목록을 조회
		//paramMap = new HashMap();
		//paramMap.put("dateType", "");
		//paramMap.put("sDate", sDate);
		//paramMap.put("eDate", eDate);
		paramMap.put("inqryDiv", "3"); // 3 = 개찰일시
		paramMap.put("inqryBgnDt", sDate);
		paramMap.put("inqryEndDt", eDate);
		getData(ScsbidInfoService, getOpengResultListInfoThng, paramMap);
//
//		// 계약정보조회서비스 나라장터 계약현황 물품 목록을 조회
//		paramMap = new HashMap();
//		paramMap.put("dateType", "");
//		paramMap.put("sDate", sDate);
//		paramMap.put("eDate", eDate);
//		getData(CntrctInfoService, getCntrctInfoListThngCntrctSttus, paramMap);
		
		System.out.println("데이터 종료");
	}
	
	
	@Override
	public void getData(String sDate) throws Exception {
		System.out.println("데이터 실행");
		
		Calendar cal = Calendar.getInstance();
		
		// 입찰공고정보서비스 나라장터_입찰공고_물품_목록을_조회
		HashMap paramMap = new HashMap();
		/*
		paramMap.put("dateType", "");
		paramMap.put("sDate", sDate);
		paramMap.put("eDate", sDate);
		*/
		paramMap.put("inqryDiv", "1"); // 조회구분 1:등록일시, 2:입찰공고번호
		paramMap.put("inqryBgnDt", sDate + "0000"); //시간, 분 추가
		paramMap.put("inqryEndDt", sDate + "2359"); //시간, 분 추가
		
		getData(BidPublicInfoService, getBidPblancListInfoThng, paramMap);

		System.out.println("데이터 종료");
	}
	
	@Override
	public void getResultData(String sDate) throws Exception {
		System.out.println("데이터 실행");
		
		Calendar cal = Calendar.getInstance();
		
		// 입찰공고정보서비스 나라장터_입찰공고_물품_목록을_조회
		HashMap paramMap = new HashMap();
		//paramMap.put("dateType", "");
		//paramMap.put("sDate", sDate);
		//paramMap.put("eDate", sDate);
		paramMap.put("inqryDiv", "3"); // 3 = 개찰일시
		paramMap.put("inqryBgnDt", sDate + "0000"); //시간, 분 추가
		paramMap.put("inqryEndDt", sDate + "2359"); //시간, 분 추가
		getData(ScsbidInfoService, getOpengResultListInfoThng, paramMap);

		System.out.println("데이터 종료");
	}

	/**
	 * 나라장터 XML파싱 리스트 누적형
	 * 
	 * @param strXMLData
	 * @param result
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> parsing(String strXMLData, List<EgovMap> result) throws Exception {

		try {
			DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(strXMLData));

			Document doc = db.parse(is);
			NodeList nodes = doc.getElementsByTagName("item");

			for (int i = 0; i < nodes.getLength(); i++) {
				Element element = (Element) nodes.item(i);
				EgovMap eMap = new EgovMap();

				NodeList nl = element.getChildNodes();
				for (int j = 0; j < nl.getLength(); j++) {
					Node node = nl.item(j);

					String attr = node.getNodeName();
					String value = null;
					if(node.getFirstChild() != null){
						value = node.getFirstChild().getNodeValue();
					}
					eMap.put(attr, value);
				}
				result.add(eMap);
			}
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// public List<EgovMap> parsing(String strXMLData) throws Exception {
	// List<EgovMap> result = new ArrayList<EgovMap>();
	// try {
	//
	// DocumentBuilder db =
	// DocumentBuilderFactory.newInstance().newDocumentBuilder();
	// InputSource is = new InputSource();
	// is.setCharacterStream(new StringReader(strXMLData));
	//
	// Document doc = db.parse(is);
	// NodeList nodes = doc.getElementsByTagName("item");
	//
	// for (int i = 0; i < nodes.getLength(); i++) {
	// Element element = (Element) nodes.item(i);
	// EgovMap eMap = new EgovMap();
	//
	// NodeList nl = element.getChildNodes();
	// for (int j = 0; j < nl.getLength(); j++) {
	// Node node = nl.item(j);
	//
	// String attr = node.getNodeName();
	// String value = node.getNodeValue();
	//
	// eMap.put(attr, value);
	// }
	// result.add(eMap);
	// }
	// return result;
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	// return result;
	// }

	/**
	 * 총 데이터 수
	 * 
	 * @param strXMLData
	 * @return
	 * @throws Exception
	 */
	public int parsingCnt(String strXMLData) throws Exception {
		int result = 0;
		try {

			DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(strXMLData));

			Document doc = db.parse(is);
			NodeList nodes = doc.getElementsByTagName("totalCount");

			for (int i = 0; i < nodes.getLength(); i++) {
				Element element = (Element) nodes.item(i);
				EgovMap eMap = new EgovMap();

				NodeList nl = element.getChildNodes();
				for (int j = 0; j < nl.getLength(); j++) {
					Node node = nl.item(j);

					String attr = node.getNodeName();
					String value = node.getNodeValue();

					result = Integer.parseInt(value);
				}
			}
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		}
		return result;
	}

	/**
	 * REST 파일 결과 문자열로 받기
	 * 
	 * @param serviceUrl
	 * @param map
	 * @return
	 * @throws Exception
	 */
	private String restClient(String serviceUrl, HashMap map) throws Exception {
		try {
			String addr = serviceUrl + "?ServiceKey=";
			String serviceKey = SERVICE_KEY;
			String parameter = "";

			// 인증키(서비스키) url인코딩
			// serviceKey = URLEncoder.encode(serviceKey, "UTF-8");

			Iterator ir = map.keySet().iterator();

			while (ir.hasNext()) {
				String key = (String) ir.next();
				String value = (String) map.get(key);

				if (value != null && value.length() > 0) {
					parameter = parameter + "&" + key + "=" + URLEncoder.encode(value, "UTF-8");
					;
				}
			}
			addr = addr + serviceKey + parameter;

			System.out.println(addr);

			URL url = new URL(addr);
			InputStream is = url.openStream();
			String UTF8 = "utf8";
			int BUFFER_SIZE = 8192;

			BufferedReader br = new BufferedReader(new InputStreamReader(is, UTF8), BUFFER_SIZE);
			String str;
			String file = "";
			while ((str = br.readLine()) != null) {
				file += str;
			}

			return file;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * EgovMap 을 HashMap 으로 형변환
	 * 
	 * @param item
	 * @param gsmap
	 * @return
	 */
	public HashMap parseToHashMap(EgovMap item, HashMap gsmap, String[] element, String[] method) {
		Iterator ir = item.keySet().iterator();

		while (ir.hasNext()) {
			String key = (String) ir.next();
			String value = (String) item.get(key);

			if (key != null && key.length() > 0) {
				for (int i = 0; i < element.length; i++) {
					if (key.equals(element[i])) {
						if (value != null && value.length() > 0) {
							gsmap.put(method[i], value);
						}
						break;
					}
				}
			}
		}
		return gsmap;
	}

	public void getData(String serviceName, String seviceDetailName, HashMap paramMap) {
		try {
			// 조달청 각 서비스별 REST URL
			String url = APISData + "/" + serviceName + "/" + seviceDetailName;

			// 검색 요청시 목록수
			int rowCnt = 999;
			int pageNo = 1;

			// 요청시 기본 파라미터
			HashMap map = new HashMap();
			map.put("numOfRows", String.valueOf(rowCnt));
			map.put("pageNo", String.valueOf(pageNo));

			// 요청시 추가 파라미터
			Iterator ir = paramMap.keySet().iterator();
			while (ir.hasNext()) {
				String key = (String) ir.next();
				String value = (String) paramMap.get(key);

				if (value != null && value.length() > 0) {
					map.put(key, value);
				}
			}

			// 응답 Response xml 문자열
			String textXml = restClient(url, map);

			// 검색 조건 총 데이터 건수
			int totalCnt = (int) parsingCnt(textXml);

			// 검색 조건 총 페이지 수
			int totalPageCnt = (totalCnt / rowCnt) + (totalCnt % rowCnt > 0 ? 1 : 0);

			List<EgovMap> result = new ArrayList<EgovMap>();

			// 페이지가 추가로 있을경우
			if (totalPageCnt > 1) {
				for (pageNo = 1; pageNo <= totalPageCnt; pageNo++) {
					// 요청시 기본 파라미터
					map = new HashMap();
					map.put("numOfRows", String.valueOf(rowCnt));
					map.put("pageNo", String.valueOf(pageNo));

					// 요청시 추가 파라미터
					ir = paramMap.keySet().iterator();
					while (ir.hasNext()) {
						String key = (String) ir.next();
						String value = (String) paramMap.get(key);

						if (value != null && value.length() > 0) {
							map.put(key, value);
						}
					}
					// 응답 Response xml 문자열
					textXml = restClient(url, map);

					// 데이터 parsing
					result = parsing(textXml, result);

					HashMap paramMap2 = new HashMap(paramMap);
					
					// DB저장
					setData(result, serviceName, seviceDetailName, paramMap2);
				}
			} else if (totalPageCnt == 1) {
				// 첫페이지일경우

				// 데이터 parsing
				result = parsing(textXml, result);

				// DB저장
				setData(result, serviceName, seviceDetailName, paramMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void getData2(String serviceName, String seviceDetailName, HashMap paramMap) {
		try {
			// 조달청 각 서비스별 REST URL
			String url = APISData + "/" + serviceName + "/" + seviceDetailName;
			
			// 요청시 기본 파라미터
			HashMap map = new HashMap();
			
			// 요청시 추가 파라미터
			Iterator ir = paramMap.keySet().iterator();
			while (ir.hasNext()) {
				String key = (String) ir.next();
				String value = (String) paramMap.get(key);
				
				if (value != null && value.length() > 0) {
					map.put(key, value);
				}
			}
			
			// 응답 Response xml 문자열
			String textXml = restClient(url, map);
			
			// 검색 조건 총 페이지 수
			List<EgovMap> result = new ArrayList<EgovMap>();
			
			// 데이터 parsing
			result = parsing(textXml, result);
				
			// DB저장
			setData(result, serviceName, seviceDetailName, paramMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void setData(List<EgovMap> result, String serviceName, String seviceDetailName, HashMap paramMap) {
		try {
			SimpleDateFormat beforeSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); //2017-05-08 18:00:00
			SimpleDateFormat afterSdf = new SimpleDateFormat("yyyyMMddHHmm"); //201705081800
			
			for (EgovMap item : result) {
				HashMap<String, String> gsmap = new HashMap<String, String>();

				switch (serviceName) {
				//사전 규격서비스
//				case "HrcspSsstndrdInfoService":
//					switch (seviceDetailName) {
//					//사전규격 물품 목록을 조회
//					case "getPublicPrcureThngInfoThng":
//						gsmap = parseToHashMap(item, gsmap, PUBLIC_PRCURE_THNG_INFO_THNG_ELEMENT, PUBLIC_PRCURE_THNG_INFO_THNG_METHOD);
//
//						publicDataMapper.updatePublicPrcureThngInfoThng(gsmap);
//						break;
//
//					default:
//						break;
//					}
//					break;
				//입찰공고정보 서비스
				case "BidPublicInfoService":
					switch (seviceDetailName) {
					//입찰공고 물품 목록을 조회
					case "getBidPblancListInfoThng":
						gsmap = parseToHashMap(item, gsmap, BID_PBLANC_LIST_INFO_THNG_ELEMENT, BID_PBLANC_LIST_INFO_THNG_METHOD);

						//날짜 포멧 변경.
						if(StringUtil.isNotEmpty(gsmap.get("noti_dt"))) gsmap.put("noti_dt", afterSdf.format(beforeSdf.parse(gsmap.get("noti_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("bid_lic_reg_dt"))) gsmap.put("bid_lic_reg_dt", afterSdf.format(beforeSdf.parse(gsmap.get("bid_lic_reg_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("part_sup_agree_form_reg_dt"))) gsmap.put("part_sup_agree_form_reg_dt", afterSdf.format(beforeSdf.parse(gsmap.get("part_sup_agree_form_reg_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("bid_start_dt"))) gsmap.put("bid_start_dt", afterSdf.format(beforeSdf.parse(gsmap.get("bid_start_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("bid_end_dt"))) gsmap.put("bid_end_dt", afterSdf.format(beforeSdf.parse(gsmap.get("bid_end_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("bid_open_dt"))) gsmap.put("bid_open_dt", afterSdf.format(beforeSdf.parse(gsmap.get("bid_open_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("dev_limit_dt"))) gsmap.put("dev_limit_dt", afterSdf.format(beforeSdf.parse(gsmap.get("dev_limit_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("result_apply_form_reg_dt"))) gsmap.put("result_apply_form_reg_dt", afterSdf.format(beforeSdf.parse(gsmap.get("result_apply_form_reg_dt"))));
						
						gsmap.put("bid_type", "물품");		//타입은 일괄적으로 물품으로 등록한다.

						publicDataMapper.updateBidPblancListInfoThng(gsmap);		//공고테이블 등록
						publicDataMapper.updateBidPblancListInfoThngFile(gsmap);	//공고파일테이블 등록
						
						paramMap.clear();
						paramMap.put("inqryDiv", "2"); //  조회구분 1:등록일시, 2:입찰공고번호
						paramMap.put("bidNtceNo", gsmap.get("bid_notice_no"));
						paramMap.put("bidNtceOrd", gsmap.get("bid_notice_cha_no"));
						
						publicDataService.getData(BidPublicInfoService, getBidPblancListInfoPrtcptPsblRgn, paramMap);

						break;
					//입찰공고목록 정보에 대한 참가가능 지역 정보조회
					case "getBidPblancListInfoPrtcptPsblRgn":
							gsmap = parseToHashMap(item, gsmap, BID_PBLANC_LIST_INFO_PRTCPT_PSBL_RGN_ELEMENT, BID_PBLANC_LIST_INFO_PRTCPT_PSBL_RGN_METHOD);

							publicDataMapper.updateBidPblancListInfoPrtcptPsblRgn(gsmap);	//참가가능지역 등록

							break;
					//입찰공고 물품 기초금액을 조회
					case "getBidPblancListInfoThngBsisAmount":
						gsmap = parseToHashMap(item, gsmap, BID_PBLANC_LIST_INFO_THNG_BSIS_AMOUNT_ELEMENT, BID_PBLANC_LIST_INFO_THNG_BSIS_AMOUNT_METHOD);
						
						//날짜 포멧 변경.
						if(StringUtil.isNotEmpty(gsmap.get("base_price_open_dt"))) gsmap.put("base_price_open_dt", afterSdf.format(beforeSdf.parse(gsmap.get("base_price_open_dt"))));

						publicDataMapper.updateBidPblancListInfoThngBsisAmount(gsmap);
						
						publicDataMapper.updateBidPblancListInfoThngBsisAmountCopy(gsmap);
						break;

					default:
						break;
					}
					break;
				//낙찰정보 조회 서비스
				case "ScsbidInfoService":
					switch (seviceDetailName) {
					//최종낙찰자 목록
					/*					
					case "getScsbidListSttusThng":
						gsmap = parseToHashMap(item, gsmap, SCSBID_LIST_STTUS_THNG_ELEMENT, SCSBID_LIST_STTUS_THNG_METHOD);
						
						publicDataMapper.updateScsbidListSttusThng(gsmap);
						break;
					*/	
					//개찰결과 목록
					case "getOpengResultListInfoThng":
						gsmap = parseToHashMap(item, gsmap, OPENG_RESULT_LIST_INFO_THNG_ELEMENT, OPENG_RESULT_LIST_INFO_THNG_METHOD);
						
						if(StringUtil.isNotEmpty(gsmap.get("bid_open_dt"))) gsmap.put("bid_open_dt", afterSdf.format(beforeSdf.parse(gsmap.get("bid_open_dt"))));
						if(StringUtil.isNotEmpty(gsmap.get("input_dt"))) gsmap.put("input_dt", afterSdf.format(beforeSdf.parse(gsmap.get("input_dt"))));

						List<HashMap> joinReqComList = enterpriseService.selectBusinessList(gsmap);
						int joinReqComCnt = joinReqComList.size(); //투찰권유한 투찰사 목록수
						int joinComCnt = distributionMapper.selectBidOpenResultComptByCnt(gsmap); //실제 투찰에 응한 투찰사 목록수

						gsmap.put("join_req_com_cnt", String.valueOf(joinReqComCnt));
						gsmap.put("join_com_cnt", String.valueOf(joinComCnt));
						
						publicDataMapper.updateOpengResultListInfoThng(gsmap);
						
						HashMap paramMap2 = new HashMap();
						paramMap2.put("inqryDiv", "1"); //1 : 입력일시, 2 : 입찰공고번호
						paramMap2.put("inqryBgnDt", (String) paramMap.get("sDate"));
						paramMap2.put("inqryEndDt", (String) paramMap.get("eDate"));
						paramMap2.put("bidNtceNo", (String) gsmap.get("bid_notice_no"));
						getData(serviceName, getOpengResultListInfoThngPreparPcDetail,paramMap2);

						paramMap2 = new HashMap();
						paramMap2.put("inqryDiv", "1"); //1 : 입력일시, 2 : 입찰공고번호
						paramMap2.put("inqryBgnDt", (String) paramMap.get("sDate"));
						paramMap2.put("inqryEndDt", (String) paramMap.get("eDate"));
						paramMap2.put("bidNtceNo", (String) gsmap.get("bid_notice_no"));
						getData(serviceName, getOpengResultListInfoOpengCompt,paramMap2);
						getData(serviceName, getOpengResultListInfoFailing,paramMap2);
						getData(serviceName, getOpengResultListInfoRebid,paramMap2);
						break;
					//예비가격 상세 목록
					case "getOpengResultListInfoThngPreparPcDetail":
						gsmap = parseToHashMap(item, gsmap, OPENG_RESULT_LIST_INFO_THNG_PREPAR_PC_DETAIL_ELEMENT,
								OPENG_RESULT_LIST_INFO_THNG_PREPAR_PC_DETAIL_METHOD);
						
						if(StringUtil.isNotEmpty(gsmap.get("input_dt"))) gsmap.put("input_dt", afterSdf.format(beforeSdf.parse(gsmap.get("input_dt"))));
						
						if(gsmap.get("open_seq_no")==null){
							gsmap.put("open_seq_no","1");
						}

						publicDataMapper.updateOpengResultListInfoThngPreparPcDetail(gsmap);
						break;
					//개찰완료 목록
					case "getOpengResultListInfoOpengCompt":
						gsmap = parseToHashMap(item, gsmap, OPENG_RESULT_LIST_INFO_OPENG_COMPT_ELEMENT, OPENG_RESULT_LIST_INFO_OPENG_COMPT_METHOD);

						publicDataMapper.updateOpengResultListInfoOpengCompt(gsmap);
						break;
					//유찰 목록
					case "getOpengResultListInfoFailing":
						gsmap = parseToHashMap(item, gsmap, OPENG_RESULT_LIST_INFO_FAILNB_ELEMENT, OPENG_RESULT_LIST_INFO_FAILNB_METHOD);
						
						publicDataMapper.updateOpengResultListInfoFailinb(gsmap);
						break;
					//재입찰 목록
					case "getOpengResultListInfoRebid":
						gsmap = parseToHashMap(item, gsmap, OPENG_RESULT_LIST_INFO_REBID_ELEMENT, OPENG_RESULT_LIST_INFO_REBID_METHOD);
						
						publicDataMapper.updateOpengResultListInfoRebid(gsmap);
						break;

					default:
						break;
					}
					break;
					
				//계약현황 목록	
//				case "CntrctInfoService":
//					switch (seviceDetailName) {
//					case "getCntrctInfoListThngCntrctSttus":
//						gsmap = parseToHashMap(item, gsmap, CNTRCT_INFO_LIST_THNG_CNTRCT_STTUS_ELEMENT, CNTRCT_INFO_LIST_THNG_CNTRCT_STTUS_METHOD);
//
//						publicDataMapper.updateCntrctInfoListThngCntrctSttus(gsmap);
//						break;
//					default:
//						break;
//					}
//					break;
				//물품목록정보서비스
				case "ThngListInfoService":
					switch (seviceDetailName) {
					//목록정보(일반검색) 품목 목록 조회
					case "getThngPrdnmLocplcAccotListInfoInfoPrdlstSearch":
						gsmap = parseToHashMap(item, gsmap, DETAIL_PRDNM_FND_THNG_CL_SYSTM_STRD_INFO_ELEMENT, DETAIL_PRDNM_FND_THNG_CL_SYSTM_STRD_INFO_METHOD);

						publicDataMapper.updateDetailPrdnmFndThngClSystmStrdInfo(gsmap);
						break;
					default:
						break;
					}
					break;
				default:
					break;
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	public void removeBizGoodsDirectPastLimitDt(HashMap map) throws Exception{
		publicDataMapper.removeBizGoodsDirectPastLimitDt(map);
	}
	
	public void removeBizLicensePastLimitDt(HashMap map) throws Exception{
		publicDataMapper.removeBizLicensePastLimitDt(map);
	}
	
	public void updateScaleCdPastLimitDt(HashMap map) throws Exception{
		publicDataMapper.updateScaleCdPastLimitDt(map);
	}
	
	public void updateCreditCdPastLimitDt(HashMap map) throws Exception{
		publicDataMapper.updateCreditCdPastLimitDt(map);
	}
	
}
