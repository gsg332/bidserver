package egovframework.com.bidserver.opening.web;

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

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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

import egovframework.com.bidserver.business.service.BusinessService;
import egovframework.com.bidserver.opening.service.OpeningService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.schedule.service.PublicDataService;
import egovframework.com.bidserver.util.Config;
import egovframework.com.bidserver.util.Coolsms;
import egovframework.com.bidserver.util.MailUtil;
import egovframework.com.cmm.message.ResultStatus;

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
public class OpeningController extends CommonController {

	@Resource(name = "openingService")
	private OpeningService openingService;
	
	@Resource(name = "businessService")
	private BusinessService businessService;
	
	@Resource(name = "publicDataService")
	private PublicDataService publicDataService;

	@Autowired
	private View jSonView;

	@RequestMapping(value = "/admin/opening/main.do")
	public String getBidNoticeNewMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/opening/main";
	}
	
	@RequestMapping(value = "/opening/bidConfirmList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidConfirmList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = openingService.selectBidConfirmList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", openingService.getBidConfirmListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/opening/selectBusinessList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectBusinessList(HttpServletRequest request, Model model) {
	
		try{
			HashMap map = this.bind(request);
			List<HashMap> resultList = null;
			
			int businessChk = openingService.businessChk(map);
			if(businessChk <= 0){
				resultList = openingService.selectBusinessList(map);
			}else{
				resultList = openingService.selectBusinessList2(map);
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
	
	@RequestMapping(value = "/opening/selectBusinessList2.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectBusinessList2(HttpServletRequest request, Model model) {
	
		try{
			HashMap map = this.bind(request);
			List<HashMap> resultList = null;
			
			int businessChk = openingService.businessChk(map);
			if(businessChk <= 0){
				resultList = openingService.selectBusinessList(map);
			}else{
				resultList = openingService.selectBusinessList3(map);
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/opening/getBusinessDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBusinessDtl(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			int disCnt = openingService.selectBusinessDtlCnt(map);
			
			if(disCnt <= 0){
				model.addAttribute("status", ResultStatus.NULL.value());
				model.addAttribute("resultMessage", ResultStatus.NULL.getReasonPhrase());
			}else{			
				List<HashMap> resultList = null;
				resultList = openingService.selectBusinessDtl(map);		
				model.addAttribute("rows", resultList);
				model.addAttribute("status", ResultStatus.OK.value());
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
				
			}

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
	
	@RequestMapping(value = "/opening/businessList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			resultList = openingService.businessList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 200);

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/opening/bidOpenResultList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidOpenResultList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = openingService.selectBidOpenResultList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", openingService.getBidOpenResultListCnt(map));

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
	@RequestMapping(value = "/opening/bidOpenResultDetail.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidOpenResultDetail(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			if(map.get("bid_step_type").equals("개찰완료")){
				resultList = openingService.selectBidOpenResultCompt(map);
			}else if(map.get("bid_step_type").equals("유찰")){
				resultList = openingService.selectBidOpenResultFail(map);
			}else if(map.get("bid_step_type").equals("재입찰M")){
				resultList = openingService.selectBidOpenResultRebid(map);
			}else if(map.get("bid_step_type").equals("재입찰")){
				resultList = openingService.selectBidOpenResultCompt(map);
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
	@RequestMapping(value = "/opening/bidOpenResultPriceDetail.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidOpenResultPriceDetail(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = openingService.selectBidOpenResultComptBy(map);
			
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
	@RequestMapping(value = "/opening/updateBidResult.do", method = RequestMethod.POST)
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

		} catch (Exception e) {
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
	@RequestMapping(value = "/opening/getBidResultInfoApi.do", method = RequestMethod.POST)
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
	 * 입찰공고에 대한 투찰사 메세지요청
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/opening/sendBusiness.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendBusiness(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		try {
			HashMap map = this.bind(request);
			
			String message_type = (String)map.get("message_type");
			if (map.get("addData") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				
				map.put("pageNo", 0);
				map.put("rows", 10);
				map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));

				List<HashMap> bidInfo = openingService.selectBidList(map);
				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					map.put("send_yn", "Y");
					
					String message = (String)map.get("send_message");
					
					String bigo = "";

					if(jo.has("bigo")){
						if(jo.getString("bigo")!=null && jo.getString("bigo").length()>0){
							bigo = jo.getString("bigo");
						}
					}

					message = message.replaceAll("\\<입력된 비고\\>", bigo);
					
					map.put("message",message.replaceAll("\n", "<br/>"));
					
					List<HashMap> resultList = null;
					map.put("user", request.getSession().getAttribute("loginid"));
					map.put("s_business_no", jo.getString("business_no"));
					resultList = openingService.businessList(map); 
					
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
										commandMap.put("email","bid@in-con.biz");     
										commandMap.put("emailPw","whekf00!!");     
										commandMap.put("emailHost","smart.whoismail.net");    
										commandMap.put("emailPort","587");   
										
										mu.sendMailLink(commandMap, bidInfo);
									}
									messageMap.put("subject", subject);
									messageMap.put("message_type", "mail");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("email"));
									messageMap.put("receiver", dataMap.get("email"));
									messageMap.put("sms_key", "");
									
									openingService.insertBidMessage(messageMap);
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

								org.json.simple.JSONObject result = coolsms.send(set); // 보내기&전송결과받기
								if ((Boolean) result.get("status") == true) {
									// 메시지 보내기 성공 및 전송결과 출력

									messageMap.put("subject", subject);
									messageMap.put("message_type", "sms");
									messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
									messageMap.put("sender", request.getSession().getAttribute("mobile_no"));
									messageMap.put("receiver", ((String)dataMap.get("mobile_no")).replaceAll("-", ""));
									messageMap.put("sms_key", result.get("group_id"));
									
									openingService.insertBidMessage(messageMap);
								} else {
									// 메시지 보내기 실패
									System.out.println("실패");
									System.out.println(result.get("code")); // REST API 에러코드
									System.out.println(result.get("message")); // 에러메시지
								}								
							}else if(message_type.equals("msg")){
								HashMap<String, String> set = new HashMap<String, String>();								

								messageMap.put("message_type", "msg");
								messageMap.put("subject", subject);
								messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
								openingService.insertBidMessage(messageMap);								
							}else if(message_type.equals("send")){
								HashMap<String, String> set = new HashMap<String, String>();								
								openingService.updateBusinessRelList2(map);
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
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;	
	}
	
	@RequestMapping(value = "/opening/updateBusinessList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBusinessList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
				//openingService.deleteBusinessList(map);
				
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));				
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("business_no", jo.getString("business_no"));
					if(jo.has("bigo")){
						if(jo.getString("bigo")!=null && jo.getString("bigo").length()>0){
							map.put("bigo", jo.getString("bigo"));
						}
					}													
					openingService.updateBusinessList(map);
				}
			}
			openingService.updateBusinessSendYn(map);
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
	 * 입찰공고에 대한 투찰사 삭제
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/opening/deleteBusinessList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteBusinessList(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		try {
			HashMap map = this.bind(request);
			
			if (map.get("addData") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("addData"));
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					if(jo.containsKey("business_no")){
						map.put("business_no", jo.getString("business_no"));
						openingService.deleteMessage(map);
					}
					/*
					if(jo.containsKey("message_id")){
						map.put("message_id", jo.getString("message_id"));
						openingService.deleteMessage(map);
					}
					*/
					int msgTotalCnt = openingService.selectMessageTotalCnt(map);
					if(msgTotalCnt <= 0){
						openingService.deleteBusinessList(map);
					}
				}
			}
			
			model.addAttribute("status", true);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			e1.printStackTrace();
			model.addAttribute("status", false);
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("status", false);
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
	@RequestMapping(value = "/opening/sendBigoMsg.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendBigoMsg(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap map = this.bind(request);

			openingService.updateBusinessList2(map);
												
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
	 * 추천구간 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/opening/getBidRangeDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidRangeDtl(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = openingService.selectBidRangeList(map);
			
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
	@RequestMapping(value = "/opening/saveRange.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View saveRange(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			String[] range = ((String)map.get("range")).split(",");
			if(range.length>0){
				if(!range[0].equals("")){
					openingService.deleteBidRangeList(map);
					for(int i=0;i<range.length;i++){
						
						HashMap paramMap = new HashMap();
						paramMap.put("bid_notice_no", map.get("bid_notice_no"));
						paramMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
						paramMap.put("range", range[i]);
						
						openingService.insertBidRangeList(paramMap);
					}
				}else{
					openingService.deleteBidRangeList(map);
				}
			}else{
				openingService.deleteBidRangeList(map);
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
	 * 견적보고서 정보
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/opening/estimateReportInfo.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View estimateReportInfo(HttpServletRequest request, Model model) {

		HashMap item = null;

		try {
			HashMap map = this.bind(request);

			item = openingService.selectEstimateReportInfo(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("item", item);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
}
