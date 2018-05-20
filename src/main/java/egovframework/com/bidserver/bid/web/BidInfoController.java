package egovframework.com.bidserver.bid.web;

import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.View;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.google.android.gcm.server.Constants;
import com.google.android.gcm.server.Message;
import com.google.android.gcm.server.Result;
import com.google.android.gcm.server.Sender;

import egovframework.com.bidserver.bid.service.BidInfoService;
import egovframework.com.bidserver.business.service.BusinessService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.schedule.service.PublicDataService;
import egovframework.com.bidserver.util.Config;
import egovframework.com.bidserver.util.Coolsms;
import egovframework.com.bidserver.util.GCMConfig;
import egovframework.com.bidserver.util.MailUtil;
import egovframework.com.cmm.message.ResultStatus;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 입찰관리 클래스를 정의 한다
 * 
 * @author 전영환
 ** @since 2015.09.22
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2015.09.22  전영환          최초 생성
 * 
 * </pre>
 */
@Controller
public class BidInfoController extends CommonController {

	@Resource(name = "bidInfoService")
	private BidInfoService bidInfoService;
	
	@Resource(name = "businessService")
	private BusinessService businessService;
	
	@Resource(name = "publicDataService")
	private PublicDataService publicDataService;

	@Autowired
	private View jSonView;

	
	/**
	 * 입찰공고 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/bidList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = bidInfoService.selectBidList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", bidInfoService.getBidListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	
	/**
	 * 해당일자 공고 가져오기
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/getBidInfoApi.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidInfoApi(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			publicDataService.getData((String)map.get("startDt"));
			
			model.addAttribute("status", "200");
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	/**
	 * 입찰공고에 대한 제조사 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/bidBizRelList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidBizRelList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

//			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
//			map.put("pageNo", startIndex);
//			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = bidInfoService.selectBizRelList(map);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}

	/**
	 * 제조사 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/bidBizList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidBizList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = bidInfoService.selectBizList(map);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}

	
	/**
	 * 입찰공고 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateBidList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBidList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			// request.setCharacterEncoding("UTF-8");

			String deleted = request.getParameter("deleted");
			String updated = request.getParameter("updated");

			if (deleted != null) {
//				deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("bid_notice_no", jo.getString("bid_notice_no"));
					map.put("bid_notice_cha_no", jo.getString("bid_notice_cha_no"));
					
					bidInfoService.deleteBidList(map);

				}
			}

			if (updated != null) {
//				updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("bid_notice_no", jo.getString("bid_notice_no"));
					map.put("bid_notice_cha_no", jo.getString("bid_notice_cha_no"));
					map.put("bigo", jo.getString("bigo"));
					map.put("base_price", jo.getString("base_price"));
					
					if(jo.getString("user_id").equals("non")){
						map.put("user_id", "");
					}else{
						map.put("user_id", jo.getString("user_id"));
					}
					bidInfoService.updateBidList(map);

				}
			}

			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;

	}
	
	/**
	 * 입찰공고 사용자 데이터 가져오기
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/getBidDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidDtl(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			List<HashMap> resultList = null;
			resultList = bidInfoService.selectBidDtl(map);

			HashMap bidSubject = bidInfoService.selectBidSubj(map);
			HashMap bidRisk = bidInfoService.selectBidRisk(map);
			
			HashMap statusMap = bidInfoService.selectApplyInfo(map);

			model.addAttribute("rows", resultList);
			model.addAttribute("bidSubj", bidSubject);
			model.addAttribute("bidRisk", bidRisk);
			model.addAttribute("bidStatus", statusMap);
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;

	}
	
	/**
	 * 입찰공고 사용자 데이터 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/setBidDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setBidDtl(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
					bidInfoService.updateBidDtl(map);
			}

			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jSonView;

	}
	
	/**
	 * 입찰공고에 대한 제조사 견적요청
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/sendManufacture.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendManufacture(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		
		try {
			HashMap map = this.bind(request);
			
			String message_type = (String)map.get("message_type");
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				map.put("pageNo", 0);
				map.put("rows", 10);
				map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));

				List<HashMap> bidInfo = bidInfoService.selectBidList(map);
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("send_yn", "Y");
					map.put("message", map.get("send_message").toString().replaceAll("\n", "<br/>"));
					
					List<HashMap> resultList = null;
					map.put("user", request.getSession().getAttribute("loginid"));
					map.put("s_business_no", jo.getString("business_no"));
					resultList = bidInfoService.manufactureList(map); 
					
					
					String subject = "견적요청 의뢰.";
					
					if(resultList!=null && resultList.size()>0){
						try{
							HashMap dataMap = resultList.get(0);
							
							HashMap messageMap = new HashMap();
							messageMap.put("bid_notice_no", map.get("bid_notice_no"));
							messageMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
							messageMap.put("catagory", "sendManufacture");
							messageMap.put("business_no", jo.getString("business_no"));
							messageMap.put("send_id", map.get("user"));
							if(message_type.equals("email")){
								
								try{
									if(dataMap.get("email")!=null){
										MailUtil mu = new MailUtil();
										
										HashMap commandMap = new HashMap();
										commandMap.put("subject",subject);  //subject
										commandMap.put("msgText",map.get("message"));  //message
										commandMap.put("to",dataMap.get("email"));  
										commandMap.put("email",request.getSession().getAttribute("email"));     
										commandMap.put("emailPw",request.getSession().getAttribute("emailPw"));     
										commandMap.put("emailHost",request.getSession().getAttribute("emailHost"));    
										commandMap.put("emailPort",request.getSession().getAttribute("emailPort"));   
										
										mu.sendMailLink(commandMap, bidInfo);
									}

									messageMap.put("subject", subject);
									messageMap.put("message_type", "mail");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("email"));
									messageMap.put("receiver", dataMap.get("email"));
									messageMap.put("sms_key", "");
									
									bidInfoService.insertBidMessage(messageMap);
									
									bidInfoService.updateBusinessRelList(map);
								}catch(Exception e){
									e.printStackTrace();
								}
								
								
							}else if(message_type.equals("sms")){
								Coolsms coolsms = new Coolsms(Config.api_key, Config.api_secret);
							
								
								/*
								 * Parameters
								 * 관련정보 : http://www.coolsms.co.kr/SDK_Java_API_Reference_ko#toc-0
								 */
								HashMap<String, String> set = new HashMap<String, String>();
								set.put("to", ((String)dataMap.get("mobile_no")).replaceAll("-", "")); // 수신번호
								
								String sendMsg = ((String)map.get("message")).replaceAll("<br/>", "\n");

								// 10월 16일 이후로 발신번호 사전등록제로 인해 등록된 발신번호로만 문자를 보내실 수 있습니다.
								set.put("from", Config.sender_no); // 발신번호
								set.put("text", sendMsg); // 문자내용
								set.put("type", sendMsg.getBytes().length>=80?"lms":"sms"); // 문자 타입
								set.put("subject", subject); // LMS, MMS 일때 제목	
								/*
								 * Option Parameters
								 */
								/*
								set.put("to", "01000000000, 01000000001"); // 받는사람 번호 여러개 입력시
								set.put("image_path", "./images/"); // image file path 이미지 파일 경로 설정 (기본 "./")
								set.put("image", "test.jpg"); // image file (지원형식 : 200KB 이하의 JPEG)
								set.put("refname", "참조내용"); // 참조내용
								set.put("country", "KR"); // 국가코드 한국:KR 일본:JP 미국:US 중국:CN
								set.put("datetime", "201401151230"); // 예약전송시 날짜 설정		
								set.put("subject", "제목"); // LMS, MMS 일때 제목		
								set.put("charset", "utf8"); // 인코딩 방식
								set.put("srk", ""); // 솔루션 제공 수수료를 정산받을 솔루션 등록키
								set.put("mode", "test"); // test모드 수신번호를 반드시 01000000000 으로 테스트하세요. 예약필드 datetime는 무시됨. 결과값은 60. 잔액에서 실제 차감되며 다음날 새벽에 재충전됨
								set.put("app_version", ""); // 어플리케이션 버젼 예) Purplebook 4.1
								set.put("datetime", "201701151230"); // 예약전송시 날짜 설정		
								*/

								org.json.simple.JSONObject result = coolsms.send(set); // 보내기&전송결과받기
								if ((Boolean) result.get("status") == true) {
									// 메시지 보내기 성공 및 전송결과 출력
//									System.out.println("성공");			
//									System.out.println(result.get("group_id")); // 그룹아이디
//									System.out.println(result.get("result_code")); // 결과코드
//									System.out.println(result.get("result_message"));  // 결과메시지
//									System.out.println(result.get("success_count")); // 성공갯수
//									System.out.println(result.get("error_count"));  // 발송실패 메시지 수

									messageMap.put("subject", subject);
									messageMap.put("message_type", "sms");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("mobile_no"));
									messageMap.put("receiver", ((String)dataMap.get("mobile_no")).replaceAll("-", ""));
									messageMap.put("sms_key", result.get("group_id"));
									
									bidInfoService.insertBidMessage(messageMap);
									
									bidInfoService.updateBusinessRelList(map);
								} else {
									// 메시지 보내기 실패
									System.out.println("실패");
									System.out.println(result.get("code")); // REST API 에러코드
									System.out.println(result.get("message")); // 에러메시지
								}	
								
							}
							
							
						}catch(Exception e){
							e.printStackTrace();
						}
					}
					
					
				}
			}
			
			model.addAttribute("status", true);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 입찰공고 업종 정보 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateCompanyTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateCompanyTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap map = this.bind(request);
			
			bidInfoService.deleteCompanyTypeList(map);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("cd", jo.getString("cd"));
					bidInfoService.updateCompanyTypeList(map);
					
				}
			}
			
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
//		} catch (JsonParseException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		} catch (JsonMappingException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 입찰공고에 대한 제조사 견적요청
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateManufactureList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateManufactureList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					bidInfoService.updateManufactureList(map);
					
				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 입찰공고에 대한 투찰사 등록
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/insertBusinessRelList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View insertBusinessRelList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					bidInfoService.updateBusinessList(map);
					map.put("s_business_no", jo.getString("business_no"));
//					sendPush(map);
				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 입찰공고에 대한 투찰사 등록
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateBusinessList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBusinessList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("bidding_price", jo.getString("bidding_price"));
					map.put("bigo", jo.getString("bigo"));
					bidInfoService.updateBusinessList(map);
					
				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}

	/**
	 * 담당자 리스트 조회
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/bid/userList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public void userList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap map = this.bind(request);
		List<HashMap> resultList = null;

		resultList = bidInfoService.selectUserList(map);
		
		List returnList = new ArrayList<HashMap>();
		
		HashMap itemMap = new HashMap();
		if(map.get("searchType")!=null && ((String)map.get("searchType")).equals("A")){
			itemMap.put("user_id", "");
			itemMap.put("user_nm", "전체");
			returnList.add(itemMap);
		}
		
		itemMap = new HashMap();
		itemMap.put("user_id", "non");
		itemMap.put("user_nm", "미지정");
		returnList.add(itemMap);
		
		for(int i=0; i<resultList.size();i++){
			returnList.add(resultList.get(i));
		}

		JSONObject obj = new JSONObject();

		obj.put("children", returnList);

		response.setContentType("text/html; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");

		/*
		 * System.out.println("grouplist: "+JSONObject.fromObject(obj).toString()
		 * .replaceAll("BOPGROUPID", "id") .replaceAll("BOPGROUPNAME", "text")
		 * .replace("{\"children\":[", "[").replaceAll("]}", "]"));
		 */
		response.getWriter().write(JSONObject.fromObject(obj).toString().replace("{\"children\":[", "[").replaceAll("]}", "]"));

	}
	
	/**
	 * 공통코드 리스트 조회
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/bid/comboList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public void comboList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HashMap map = this.bind(request);
		List<HashMap> resultList = null;
		
		resultList = bidInfoService.selectComboList(map);
		
		List returnList = new ArrayList<HashMap>();
		
		HashMap itemMap = new HashMap();
		if(map.get("searchType")!=null && ((String)map.get("searchType")).equals("A")){
			itemMap.put("cd_id", "");
			itemMap.put("cd", "");
			itemMap.put("cd_nm", "전체");
			returnList.add(itemMap);
		}
		if(map.get("searchType")!=null && ((String)map.get("searchType")).equals("C")){
			itemMap.put("cd_id", "");
			itemMap.put("cd", "");
			itemMap.put("cd_nm", "선택");
			returnList.add(itemMap);
		}
		
		for(int i=0; i<resultList.size();i++){
			returnList.add(resultList.get(i));
		}
		
		JSONObject obj = new JSONObject();
		
		obj.put("children", returnList);
		
		response.setContentType("text/html; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		
		/*
		 * System.out.println("grouplist: "+JSONObject.fromObject(obj).toString()
		 * .replaceAll("BOPGROUPID", "id") .replaceAll("BOPGROUPNAME", "text")
		 * .replace("{\"children\":[", "[").replaceAll("]}", "]"));
		 */
		response.getWriter().write(JSONObject.fromObject(obj).toString().replace("{\"children\":[", "[").replaceAll("]}", "]"));
		
	}
	
	/**
	 * 제조업체 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/manufactureList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View manufactureList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			resultList = bidInfoService.manufactureList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", bidInfoService.getBidListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 제조업체 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/businessList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			resultList = bidInfoService.businessList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", bidInfoService.getBidListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 입찰관련 업종 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/companyTypeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View companyTypeList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = bidInfoService.selectCompanyTypeList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}
	
	/**
	 * 입찰공고에 대한 견적요청 제조사 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/selectEstimateList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectEstimateList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = bidInfoService.selectEstimateList(map);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}

	
	/**
	 * 입찰공고 제조사 견적내용 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateEstimateList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateEstimateList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("margin", jo.getString("margin"));
					map.put("bigo", jo.getString("bigo"));
					map.put("choice_yn", jo.getString("choice_yn"));
					map.put("choice_reason", jo.getString("choice_reason"));
					
					bidInfoService.updateEstimateList(map);
					
				}
			}
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (JsonParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (JsonMappingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 나의 금일 프로젝트 알람 수
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/getProjectCnt.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getProjectCnt(HttpServletRequest request, Model model) {
		
		int resultCnt = 0;
		
		try {
			HashMap map = this.bind(request);
			
			resultCnt = bidInfoService.getProjectCnt(map);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);
			
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultCnt);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}
	
	/**
	 * 나의 견적승인요청건수
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/getApplyCnt.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getApplyCnt(HttpServletRequest request, Model model) {

		int resultCnt = 0;

		try {
			HashMap map = this.bind(request);

			resultCnt = bidInfoService.getApplyCnt(map);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultCnt);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 견적 승인 요청
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateApply.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateApply(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			bidInfoService.updateSubject(map);
			bidInfoService.updateRisk(map);
			
			bidInfoService.updateApply(map);
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (JsonParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (JsonMappingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 공고 기초금액 가져오기 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateBidBaseAmount.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBidBaseAmount(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			
			Calendar cal = Calendar.getInstance();
			
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			
			String eDate = format.format(cal.getTime());
			cal.add(cal.DATE, -1);
			String sDate = format.format(cal.getTime());
			
			HashMap paramMap = new HashMap();
			/*
			paramMap.put("sDate", map.get("noti_dt").toString().substring(0,8));
			paramMap.put("eDate", eDate);
			paramMap.put("bidNum", map.get("bid_notice_no"));
			*/
			
			paramMap.put("inqryDiv", "2"); //  조회구분 1:입력일시, 2:입찰공고번호
			paramMap.put("inqryBgnDt", map.get("noti_dt").toString().substring(0,8));
			paramMap.put("inqryEndDt", eDate);
			paramMap.put("bidNtceNo", map.get("bid_notice_no"));

			publicDataService.getData(BidPublicInfoService, getBidPblancListInfoThngBsisAmount, paramMap);
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
//		} catch (JsonParseException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		} catch (JsonMappingException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		} catch (IOException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
	}
	
	/**
	 * 투찰결정 공고 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/bidConfirmList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidConfirmList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = bidInfoService.selectBidConfirmList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", bidInfoService.getBidConfirmListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	

	/**
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/selectBusinessList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectBusinessList(HttpServletRequest request, Model model) {
	
		try{
			HashMap map = this.bind(request);
			
			List<HashMap> resultList = bidInfoService.selectBusinessList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);
	
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 투찰사 물품등록 및 참가신청 목록
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/selectBusinessList2.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectBusinessList2(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			if(((String)map.get("bid_notice_no")).length()>0){
				map.put("pageNo", 0);
				map.put("rows", 10);
				map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));
				
				List bidInfo = bidInfoService.selectBidList(map);
				
				
				List<HashMap> businessList = bidInfoService.businessList(map);
				map.put("pageNo", 0);
				map.put("rows", 10000);
				List<HashMap> businessDtlList = businessService.selectBusinessDtlList(map);
				
				HashMap info = (HashMap)bidInfo.get(0);
				
				List<String> passBussinessNo1 = new ArrayList<String>();
				List<String> passBussinessNo2 = new ArrayList<String>();
				List<String> passBussinessNo3 = new ArrayList<String>();
				
				
				
				List<HashMap> bidDtl = bidInfoService.selectBidDtl(map);
				
				String evalCode = "";
				String scaleCode = "";
				if(bidDtl.size()>0){
					evalCode = (String)((HashMap)bidDtl.get(0)).get("column2");
					scaleCode = (String)((HashMap)bidDtl.get(0)).get("column3");
					
					for(int i=0;i<businessDtlList.size();i++){
						HashMap businessDtlMap = (HashMap)businessDtlList.get(i);
						
						if(scaleCode!=null && scaleCode.equals("002")){
							if(businessDtlMap.get("scale_cd")!=null && ((String)businessDtlMap.get("scale_cd")).equals("003")){
								for(int j= businessList.size()-1; j>0;j--){
									HashMap businessListMap = (HashMap)businessList.get(j);
									if((String.valueOf(businessListMap.get("business_no"))).equals(String.valueOf(businessDtlMap.get("business_no")))){
										businessList.remove(j);
										break;
									}
								}
							}
						}
					}
				}
				
				
				if(evalCode.length()>0){
					
					for(int j= businessList.size()-1; j>0;j--){
						HashMap businessListMap = (HashMap)businessList.get(j);
						String business_no = String.valueOf(businessListMap.get("business_no"));
						String result = businessService.getEvalutionValue(business_no, evalCode);
						if(result.indexOf("부적격")!=-1){
							businessList.remove(j);
						}
					}
				}
				
				//지역제한
				String use_area_info = (String)info.get("use_area_info");
				
				if(use_area_info!=null && use_area_info.length()>0){
					String area[] = use_area_info.split(",");
					for(int i=0;i<businessList.size();i++){
						HashMap businessMap = (HashMap)businessList.get(i);
						
						for(int j=0;j<area.length;j++){
							if(businessMap.get("address")!=null){
								if(((String)businessMap.get("address")).contains(area[j])){
									passBussinessNo1.add(String.valueOf(((HashMap)businessList.get(i)).get("business_no")));
									break;
								}
							}
						}
					}
				}else{
					for(int i=0; i<businessList.size();i++){
						passBussinessNo1.add(String.valueOf(((HashMap)businessList.get(i)).get("business_no")));
					}
				}
				
				
				//제한 업종
				String lic_limit_nm[] = new String[12];
				lic_limit_nm[0] = (String)info.get("lic_limit_nm1");
				lic_limit_nm[1] = (String)info.get("lic_limit_nm2");
				lic_limit_nm[2] = (String)info.get("lic_limit_nm3");
				lic_limit_nm[3] = (String)info.get("lic_limit_nm4");
				lic_limit_nm[4] = (String)info.get("lic_limit_nm5");
				lic_limit_nm[5] = (String)info.get("lic_limit_nm6");
				lic_limit_nm[6] = (String)info.get("lic_limit_nm7");
				lic_limit_nm[7] = (String)info.get("lic_limit_nm8");
				lic_limit_nm[8] = (String)info.get("lic_limit_nm9");
				lic_limit_nm[9] = (String)info.get("lic_limit_nm10");
				lic_limit_nm[10] = (String)info.get("lic_limit_nm11");
				lic_limit_nm[11] = (String)info.get("lic_limit_nm12");
				if(
						lic_limit_nm[0].length() >2  ||
						lic_limit_nm[2].length() >2  ||
						lic_limit_nm[4].length() >2  ||
						lic_limit_nm[6].length() >2  ||
						lic_limit_nm[8].length() >2  ||
						lic_limit_nm[10].length() >2
						){
					
					for(int x=0; x<passBussinessNo1.size();x++){
						for(int i=0; i < lic_limit_nm.length; i++){
							if(lic_limit_nm[i].length() > 2){
								String company_type1 = lic_limit_nm[i].substring(lic_limit_nm[i].indexOf("/")+1, lic_limit_nm[i].length());
								String company_type2 = "";
								if(lic_limit_nm[i+1].length() > 2){
									company_type2 = lic_limit_nm[i+1].substring(lic_limit_nm[i+1].indexOf("/")+1, lic_limit_nm[i+1].length());
								}
								
								HashMap paramMap = new HashMap();
								paramMap.put("business_no", (String)passBussinessNo1.get(x));
								paramMap.put("company_type1", company_type1);
								paramMap.put("company_type2", company_type2.length()>0?company_type2:null);
								List<HashMap> companyTypeList = bidInfoService.selectBusinessCompanyTypeList(paramMap);
								
								if(companyTypeList.size()>0){
									passBussinessNo2.add((String)passBussinessNo1.get(x));
									break;
								}
							}
							i++;
						}
					}
					
				}else{
					
					for(int i=0; i<passBussinessNo1.size();i++){
						passBussinessNo2.add((String)passBussinessNo1.get(i));
					}
				}
				
				
				//물품분류제한
				String goods_grp_limit_yn = (String)info.get("goods_grp_limit_yn");
				
				if(goods_grp_limit_yn!=null && goods_grp_limit_yn.equals("Y")){
					
					String buy_target_goods_info = (String)info.get("buy_target_goods_info");
					
					String goods[] = buy_target_goods_info.split("##");
					
					String paramGoods[] = new String [goods.length];
					
					for(int i=0; i<goods.length;i++){
						paramGoods[i] = goods[i].split("\\^")[1];
					}
					
					for(int x=0; x<passBussinessNo2.size();x++){
						HashMap paramMap = new HashMap();
						paramMap.put("business_no", (String)passBussinessNo2.get(x));
						paramMap.put("paramGoods", paramGoods);
						
						List<HashMap> goodsTypeList = bidInfoService.selectBusinessGoodsTypeList(paramMap);
						
						if(goodsTypeList.size()>0){
							passBussinessNo3.add((String)passBussinessNo1.get(x));
							break;
						}
					}
				}else{
					for(int i=0; i<passBussinessNo2.size();i++){
						passBussinessNo3.add((String)passBussinessNo2.get(i));
					}
				}
				
				HashMap paramMap = new HashMap();
				paramMap.put("bid_notice_no", map.get("bid_notice_no"));
				paramMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
				paramMap.put("s_area_cd", map.get("s_area_cd"));
				paramMap.put("s_scale_cd", map.get("s_scale_cd"));
				paramMap.put("s_credit_cd", map.get("s_credit_cd"));
				
				String business_no_list[] = new String[passBussinessNo3.size()];
				
				if(passBussinessNo3.size()>0){
					for(int i=0;i<business_no_list.length;i++){
						business_no_list[i] = passBussinessNo3.get(i);
					}
				}else{
					business_no_list = new String[1];
					business_no_list[0] = "";
				}
				paramMap.put("business_no_list", business_no_list);
				
				
				resultList = bidInfoService.selectBusinessRelList2(paramMap);
			}
			
			
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);
			
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}
	
	/**
	 * 입찰공고에 대한 투찰사 메세지요청
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/sendBusiness.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendBusiness(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		try {
			HashMap map = this.bind(request);
			
			String message_type = (String)map.get("message_type");
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				
				map.put("pageNo", 0);
				map.put("rows", 10);
				map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));

				List<HashMap> bidInfo = bidInfoService.selectBidList(map);
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("send_yn", "Y");
					
					String message = (String)map.get("send_message");
					
					String bidding_price = "";
					String bigo = "";

					if(jo.has("bidding_price")){
						if(jo.getString("bidding_price")!=null && jo.getString("bidding_price").length()>0){
							NumberFormat nf = NumberFormat.getNumberInstance();
							bidding_price = nf.format(Double.parseDouble(jo.getString("bidding_price")));
						}
					}
					if(jo.has("bigo")){
						if(jo.getString("bigo")!=null && jo.getString("bigo").length()>0){
							bigo = jo.getString("bigo");
						}
					}
					
					message = message.replaceAll("\\<입력된 추천가격\\>", bidding_price+" 원");
					message = message.replaceAll("\\<입력된 비고\\>", bigo);
					
					map.put("message",message.replaceAll("\n", "<br/>"));
					
					List<HashMap> resultList = null;
					map.put("user", request.getSession().getAttribute("loginid"));
					map.put("s_business_no", jo.getString("business_no"));
					resultList = bidInfoService.businessList(map); 
					
					
					String subject = "의뢰요청";
					
					if(resultList!=null && resultList.size()>0){
						try{
							HashMap dataMap = resultList.get(0);
							
							HashMap messageMap = new HashMap();
							messageMap.put("bid_notice_no", map.get("bid_notice_no"));
							messageMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
							messageMap.put("catagory", "sendBusiness");
							messageMap.put("business_no", jo.getString("business_no"));
							messageMap.put("send_id", map.get("user"));
							if(message_type.equals("email")){
								
								try{
									if(dataMap.get("email")!=null){
										MailUtil mu = new MailUtil();
										
										HashMap commandMap = new HashMap();
										commandMap.put("subject",subject);  //subject
										commandMap.put("msgText",map.get("message"));  //message
										commandMap.put("to",dataMap.get("email"));  
										commandMap.put("email",request.getSession().getAttribute("email"));     
										commandMap.put("emailPw",request.getSession().getAttribute("emailPw"));     
										commandMap.put("emailHost",request.getSession().getAttribute("emailHost"));    
										commandMap.put("emailPort",request.getSession().getAttribute("emailPort"));   
										
										mu.sendMailLink(commandMap, bidInfo);
									}

									messageMap.put("subject", subject);
									messageMap.put("message_type", "mail");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("email"));
									messageMap.put("receiver", dataMap.get("email"));
									messageMap.put("sms_key", "");
									
									bidInfoService.insertBidMessage(messageMap);
									
									bidInfoService.updateBusinessRelList(map);
								}catch(Exception e){
									e.printStackTrace();
								}
								
								
							}else if(message_type.equals("sms")){
								Coolsms coolsms = new Coolsms(Config.api_key, Config.api_secret);
							
								
								/*
								 * Parameters
								 * 관련정보 : http://www.coolsms.co.kr/SDK_Java_API_Reference_ko#toc-0
								 */
								HashMap<String, String> set = new HashMap<String, String>();
								set.put("to", ((String)dataMap.get("mobile_no")).replaceAll("-", "")); // 수신번호
								
								String sendMsg = ((String)map.get("message")).replaceAll("<br/>", "\n");

								// 10월 16일 이후로 발신번호 사전등록제로 인해 등록된 발신번호로만 문자를 보내실 수 있습니다.
								set.put("from", Config.sender_no); // 발신번호
								set.put("text", sendMsg); // 문자내용
								set.put("type", sendMsg.getBytes().length>=80?"lms":"sms"); // 문자 타입
								set.put("subject", subject); // LMS, MMS 일때 제목	
								/*
								 * Option Parameters
								 */
								/*
								set.put("to", "01000000000, 01000000001"); // 받는사람 번호 여러개 입력시
								set.put("image_path", "./images/"); // image file path 이미지 파일 경로 설정 (기본 "./")
								set.put("image", "test.jpg"); // image file (지원형식 : 200KB 이하의 JPEG)
								set.put("refname", "참조내용"); // 참조내용
								set.put("country", "KR"); // 국가코드 한국:KR 일본:JP 미국:US 중국:CN
								set.put("datetime", "201401151230"); // 예약전송시 날짜 설정		
								set.put("subject", "제목"); // LMS, MMS 일때 제목		
								set.put("charset", "utf8"); // 인코딩 방식
								set.put("srk", ""); // 솔루션 제공 수수료를 정산받을 솔루션 등록키
								set.put("mode", "test"); // test모드 수신번호를 반드시 01000000000 으로 테스트하세요. 예약필드 datetime는 무시됨. 결과값은 60. 잔액에서 실제 차감되며 다음날 새벽에 재충전됨
								set.put("app_version", ""); // 어플리케이션 버젼 예) Purplebook 4.1
								set.put("datetime", "201701151230"); // 예약전송시 날짜 설정		
								*/

								org.json.simple.JSONObject result = coolsms.send(set); // 보내기&전송결과받기
								if ((Boolean) result.get("status") == true) {
									// 메시지 보내기 성공 및 전송결과 출력
//									System.out.println("성공");			
//									System.out.println(result.get("group_id")); // 그룹아이디
//									System.out.println(result.get("result_code")); // 결과코드
//									System.out.println(result.get("result_message"));  // 결과메시지
//									System.out.println(result.get("success_count")); // 성공갯수
//									System.out.println(result.get("error_count"));  // 발송실패 메시지 수

									messageMap.put("subject", subject);
									messageMap.put("message_type", "sms");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("mobile_no"));
									messageMap.put("receiver", ((String)dataMap.get("mobile_no")).replaceAll("-", ""));
									messageMap.put("sms_key", result.get("group_id"));
									
									bidInfoService.insertBidMessage(messageMap);
									
									bidInfoService.updateBusinessRelList(map);
								} else {
									// 메시지 보내기 실패
									System.out.println("실패");
									System.out.println(result.get("code")); // REST API 에러코드
									System.out.println(result.get("message")); // 에러메시지
								}	
								
							}
							
							
						}catch(Exception e){
							e.printStackTrace();
						}
					}
					
					
				}
			}
			
			model.addAttribute("status", true);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 입찰공고에 대한 투찰사 메세지만 발송
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/sendBusinessMsg.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendBusinessMsg(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		try {
			HashMap map = this.bind(request);
			
			String message_type = (String)map.get("message_type");
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				
				map.put("pageNo", 0);
				map.put("rows", 10);
				map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));
				
				List<HashMap> bidInfo = bidInfoService.selectBidList(map);
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("send_yn", "Y");
					
					String message = (String)map.get("send_message");
					
					map.put("message",message.replaceAll("\n", "<br/>"));
					
					List<HashMap> resultList = null;
					map.put("user", request.getSession().getAttribute("loginid"));
					map.put("s_business_no", jo.getString("business_no"));
					resultList = bidInfoService.businessList(map); 
					
					
					String subject = "의뢰요청";
					
					if(resultList!=null && resultList.size()>0){
						try{
							HashMap dataMap = resultList.get(0);
							
							HashMap messageMap = new HashMap();
							messageMap.put("bid_notice_no", map.get("bid_notice_no"));
							messageMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
							messageMap.put("catagory", "sendBusiness");
							messageMap.put("business_no", jo.getString("business_no"));
							messageMap.put("send_id", map.get("user"));
							if(message_type.equals("email")){
								
								try{
									if(dataMap.get("email")!=null){
										MailUtil mu = new MailUtil();
										
										HashMap commandMap = new HashMap();
										commandMap.put("subject",subject);  //subject
										commandMap.put("msgText",map.get("message"));  //message
										commandMap.put("to",dataMap.get("email"));  
										commandMap.put("email",request.getSession().getAttribute("email"));     
										commandMap.put("emailPw",request.getSession().getAttribute("emailPw"));     
										commandMap.put("emailHost",request.getSession().getAttribute("emailHost"));    
										commandMap.put("emailPort",request.getSession().getAttribute("emailPort"));   
										
										mu.sendMailLink(commandMap, bidInfo);
									}
									
									messageMap.put("subject", subject);
									messageMap.put("message_type", "mail");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("email"));
									messageMap.put("receiver", dataMap.get("email"));
									messageMap.put("sms_key", "");
									
									bidInfoService.insertBidMessage(messageMap);
									
								}catch(Exception e){
									e.printStackTrace();
								}
								
								
							}else if(message_type.equals("sms")){
								Coolsms coolsms = new Coolsms(Config.api_key, Config.api_secret);
								
								
								/*
								 * Parameters
								 * 관련정보 : http://www.coolsms.co.kr/SDK_Java_API_Reference_ko#toc-0
								 */
								HashMap<String, String> set = new HashMap<String, String>();
								set.put("to", ((String)dataMap.get("mobile_no")).replaceAll("-", "")); // 수신번호
								
								String sendMsg = ((String)map.get("message")).replaceAll("<br/>", "\n");
								
								// 10월 16일 이후로 발신번호 사전등록제로 인해 등록된 발신번호로만 문자를 보내실 수 있습니다.
								set.put("from", Config.sender_no); // 발신번호
								set.put("text", sendMsg); // 문자내용
								set.put("type", sendMsg.getBytes().length>=80?"lms":"sms"); // 문자 타입
								set.put("subject", subject); // LMS, MMS 일때 제목	
								/*
								 * Option Parameters
								 */
								/*
								set.put("to", "01000000000, 01000000001"); // 받는사람 번호 여러개 입력시
								set.put("image_path", "./images/"); // image file path 이미지 파일 경로 설정 (기본 "./")
								set.put("image", "test.jpg"); // image file (지원형식 : 200KB 이하의 JPEG)
								set.put("refname", "참조내용"); // 참조내용
								set.put("country", "KR"); // 국가코드 한국:KR 일본:JP 미국:US 중국:CN
								set.put("datetime", "201401151230"); // 예약전송시 날짜 설정		
								set.put("subject", "제목"); // LMS, MMS 일때 제목		
								set.put("charset", "utf8"); // 인코딩 방식
								set.put("srk", ""); // 솔루션 제공 수수료를 정산받을 솔루션 등록키
								set.put("mode", "test"); // test모드 수신번호를 반드시 01000000000 으로 테스트하세요. 예약필드 datetime는 무시됨. 결과값은 60. 잔액에서 실제 차감되며 다음날 새벽에 재충전됨
								set.put("app_version", ""); // 어플리케이션 버젼 예) Purplebook 4.1
								set.put("datetime", "201701151230"); // 예약전송시 날짜 설정		
								 */
								
								org.json.simple.JSONObject result = coolsms.send(set); // 보내기&전송결과받기
								if ((Boolean) result.get("status") == true) {
									// 메시지 보내기 성공 및 전송결과 출력
//									System.out.println("성공");			
//									System.out.println(result.get("group_id")); // 그룹아이디
//									System.out.println(result.get("result_code")); // 결과코드
//									System.out.println(result.get("result_message"));  // 결과메시지
//									System.out.println(result.get("success_count")); // 성공갯수
//									System.out.println(result.get("error_count"));  // 발송실패 메시지 수
									
									messageMap.put("subject", subject);
									messageMap.put("message_type", "sms");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("mobile_no"));
									messageMap.put("receiver", ((String)dataMap.get("mobile_no")).replaceAll("-", ""));
									messageMap.put("sms_key", result.get("group_id"));
									
									bidInfoService.insertBidMessage(messageMap);
									
								} else {
									// 메시지 보내기 실패
									System.out.println("실패");
									System.out.println(result.get("code")); // REST API 에러코드
									System.out.println(result.get("message")); // 에러메시지
								}	
								
							}
							
							
						}catch(Exception e){
							e.printStackTrace();
						}
					}
					
					
				}
			}
			
			model.addAttribute("status", true);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	

	/**
	 * 입찰공고에 대한 투찰사 투찰가격 확인 알림(앱)
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/sendGCMBusiness.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendGCMBusiness(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		try {
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				
				map.put("pageNo", 0);
				map.put("rows", 10);
				map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));

				List<HashMap> bidInfo = bidInfoService.selectBidList(map);
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("s_business_no", jo.getString("business_no"));
					sendPush(map, "투찰가격 확인 안내", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no")+"("+bidInfo.get(0).get("bid_notice_nm")+") 의 투찰가격을 확인바랍니다.");
				}
			}
			
			model.addAttribute("status", true);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	/**
	 * 입찰공고에 대한 제조사 삭제
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/deleteManufactureist.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteManufactureist(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		try {
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("bid_notice_no", map.get("bid_notice_no"));
					map.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
					
					bidInfoService.deleteManufactureList(map); 
				}
			}
			
			model.addAttribute("status", true);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	/**
	 * 입찰공고에 대한 투찰사 삭제
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/deleteBusinessList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteBusinessList(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		try {
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("bid_notice_no", jo.getString("bid_notice_no"));
					map.put("bid_notice_cha_no", jo.getString("bid_notice_cha_no"));
					
					bidInfoService.deleteBusinessList(map); 
				}
			}
			
			model.addAttribute("status", true);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}

	@RequestMapping(value = "/admin/bidnotice/main.do")
	public String getBidNoticeMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/bidnotice/main";
	}
	@RequestMapping(value = "/admin/bidnotice/sub1.do")
	public String getBidNoticeTabPage1(HttpServletRequest request, ModelMap model) throws Exception {
		
		return "/admin/bidnotice/sub1";
	}
	@RequestMapping(value = "/admin/bidnotice/sub2.do")
	public String getBidNoticeTabPage2(HttpServletRequest request, ModelMap model) throws Exception {
		
		return "/admin/bidnotice/sub2";
	}
	@RequestMapping(value = "/admin/bidnotice/sub3.do")
	public String getBidNoticeTabPage3(HttpServletRequest request, ModelMap model) throws Exception {
		
		return "/admin/bidnotice/sub3";
	}
	
	private void sendPush(HashMap map, String title, String message){
		
		List<String>  registrationIds = new ArrayList<String>();	
		
		List resultList = null;
		
		try {
			resultList = bidInfoService.businessList(map);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String api_key ="";
		String reg_id ="";
		Result result = null;
		if(resultList.size() == 1)
		{
			Map resultMap = (Map)resultList.get(0);
			api_key = GCMConfig.API_KEY;
			reg_id =  (String)resultMap.get("reg_id");
			
			if(reg_id==null) return;
			
			Sender sender = new Sender(api_key);  //구글 코드에서 발급받은 서버 키
			Message msg = new Message.Builder()
	                       .addData("title", title)  //데이터 추가
	                       .addData("message", message)  //데이터 추가
	                       .build();

			   //푸시 전송. 파라미터는 푸시 내용, 보낼 단말의 id, 마지막은 잘 모르겠음 
			   try {
				result = sender.send(msg, reg_id, 5);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		else if(resultList.size() > 1)
		{
			
		}
		
		
		   //결과 처리
		   if(result.getMessageId() != null) {
		      //푸시 전송 성공
		   }
		   else {
		      String error = result.getErrorCodeName();   //에러 내용 받기

		      //에러 처리
		      if(Constants.ERROR_INTERNAL_SERVER_ERROR.equals(error)) {
		         //구글 푸시 서버 에러
		      }
		      else
		      {	
		    	  System.out.println("pushError==========================================");
		      }  
		   }
		}



	/**
	 * 개찰완료 공고 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/bidOpenResultList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidOpenResultList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = bidInfoService.selectBidOpenResultList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", bidInfoService.getBidOpenResultListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 개찰완료 공고 상세
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/bidOpenResultDetail.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidOpenResultDetail(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			if(map.get("bid_step_type").equals("개찰완료")){
				resultList = bidInfoService.selectBidOpenResultCompt(map);
			}else if(map.get("bid_step_type").equals("유찰")){
				resultList = bidInfoService.selectBidOpenResultFail(map);
			}else if(map.get("bid_step_type").equals("재입찰M")){
				resultList = bidInfoService.selectBidOpenResultRebid(map);
			}else if(map.get("bid_step_type").equals("재입찰")){
				resultList = bidInfoService.selectBidOpenResultCompt(map);
			}
			
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	/**
	 * 개찰완료 복수예가 상세
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/bidOpenResultPriceDetail.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidOpenResultPriceDetail(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
//			resultList = bidInfoService.selectBidOpenResultPriceDetailList(map);
			resultList = bidInfoService.selectBidOpenResultComptBy(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}
	
	/**
	 * 개찰결과 복수예비가 및 예정가격 가져오기 + 개찰결과 상세 가져오기 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/updateBidResult.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBidResult(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			HashMap paramMap = new HashMap();
			
			paramMap.put("inqryDiv", "1"); //1 : 입력일시, 2 : 입찰공고번호
			paramMap.put("bidNtceNo", map.get("bid_notice_no"));
			
			publicDataService.getData(ScsbidInfoService, getOpengResultListInfoOpengCompt, paramMap);
			publicDataService.getData(ScsbidInfoService, getOpengResultListInfoFailing, paramMap);
			publicDataService.getData(ScsbidInfoService, getOpengResultListInfoRebid, paramMap);
			publicDataService.getData(ScsbidInfoService, getOpengResultListInfoThngPreparPcDetail, paramMap);
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
//		} catch (JsonParseException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		} catch (JsonMappingException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		} catch (IOException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
	}
	
	/**
	 * 해당일자 개찰결과 가져오기
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/getBidResultInfoApi.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidResultInfoApi(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			publicDataService.getResultData((String)map.get("startDt"));
			
			model.addAttribute("status", "200");
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	/**
	 * 입찰공고에 대한 투찰사 비고 일괄등록
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/bid/sendBigoMsg.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendBigoMsg(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
//				addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("bidding_price", jo.getString("bidding_price"));
					map.put("bigo", map.get("bigo"));
					bidInfoService.updateBusinessList(map);
					
				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;
		
	}
	
	
	/**
	 * 발신메세지 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/selectSendMsgList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectSendMsgList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = bidInfoService.selectSendMsgList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", bidInfoService.getSendMsgListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	
	/**
	 * 추천구간 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/getBidRangeDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidRangeDtl(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = bidInfoService.selectBidRangeList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	

	/**
	 * 추천구간 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/saveRange.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View saveRange(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			String[] range = ((String)map.get("range")).split(",");
			if(range.length>0){
				if(!range[0].equals("")){
					bidInfoService.deleteBidRangeList(map);
					for(int i=0;i<range.length;i++){
						
						HashMap paramMap = new HashMap();
						paramMap.put("bid_notice_no", map.get("bid_notice_no"));
						paramMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
						paramMap.put("range", range[i]);
						
						bidInfoService.insertBidRangeList(paramMap);
					}
				}else{
					bidInfoService.deleteBidRangeList(map);
				}
			}else{
				bidInfoService.deleteBidRangeList(map);
			}
			
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 중요 체크
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/bid/checkImportant.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View checkImportant(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			HashMap paramMap = new HashMap();
			paramMap.put("important_yn", map.get("important_yn"));
			paramMap.put("bid_notice_no", map.get("bid_notice_no"));
			paramMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
			
			bidInfoService.updateImportantYn(paramMap);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
}
