package egovframework.com.bidserver.distribution.web;

import java.io.IOException;
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

import egovframework.com.bidserver.bid.service.BidInfoService;
import egovframework.com.bidserver.business.service.BusinessService;
import egovframework.com.bidserver.distribution.service.DistributionService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.opening.service.OpeningService;
import egovframework.com.bidserver.schedule.service.PublicDataService;
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
public class DistributionController extends CommonController {

	@Resource(name = "distributionService")
	private DistributionService distributionService;
	
	@Resource(name = "businessService")
	private BusinessService businessService;

	@Resource(name = "openingService")
	private OpeningService openingService;
	
	@Resource(name = "publicDataService")
	private PublicDataService publicDataService;
	
	@Resource(name = "bidInfoService")
	private BidInfoService bidInfoService;

	@Autowired
	private View jSonView;

	@RequestMapping(value = "/admin/distribution/main.do")
	public String getBidNoticeNewMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/distribution/main";
	}
	
	@RequestMapping(value = "/distribution/selectList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View distributionList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;
		List<HashMap> userCnt = null;

		try {
			HashMap map = this.bind(request);
			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = distributionService.selectBidList(map);
			
			userCnt = distributionService.selectBidUserCnt(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", distributionService.getBidListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
			model.addAttribute("cnt", userCnt);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/distribution/selectList2.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View distributionList2(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = distributionService.selectBidList2(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", distributionService.getBidListCnt2(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/distribution/insertDistributionList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateUserList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			int disCnt = distributionService.selectDisCnt(map);
			
			if(disCnt > 0){
				model.addAttribute("status", ResultStatus.OVERLAP.value());
				model.addAttribute("resultMessage", ResultStatus.OVERLAP.getReasonPhrase());
			}else{
				int bidCnt = distributionService.insertDistributionList(map);
				if(bidCnt <= 0){
					model.addAttribute("status", ResultStatus.NULL.value());
					model.addAttribute("resultMessage", ResultStatus.NULL.getReasonPhrase());
				}else{
					HashMap bizRelMap = new HashMap<>();
					String[] bidNoticeNoArr = null;
					if(map.get("bid_notice_no") instanceof String){
						bidNoticeNoArr = map.get("bid_notice_no").toString().split("-");
					}
					bizRelMap.put("bid_notice_no", bidNoticeNoArr[0]);
					bizRelMap.put("bid_notice_cha_no", bidNoticeNoArr[1]);
					bizRelMap.put("business_no", "108005");
					bizRelMap.put("user", "win4net");
					bidInfoService.updateBusinessList(bizRelMap);
					
					map.put("pageNo", 0);
					map.put("rows", 10);
					map.put("bidNoticeNo", map.get("bid_notice_no"));
					
					List bidInfo = openingService.selectBidList(map);
					
					if(bidInfo.size() > 0){
						List<HashMap> businessList = openingService.businessList(map);
						map.put("pageNo", 0);
						map.put("rows", 10000);
						List<HashMap> businessDtlList = openingService.selectBusinessDtlList(map);
						
						HashMap info = (HashMap)bidInfo.get(0);
						
						List<String> passBussinessNo1 = new ArrayList<String>();
						List<String> passBussinessNo2 = new ArrayList<String>();
						List<String> passBussinessNo3 = new ArrayList<String>();
						List<String> passBussinessNo4 = new ArrayList<String>();
						
						String bidNoticeNo = map.get("bid_notice_no").toString().substring(0, map.get("bid_notice_no").toString().lastIndexOf("-"));
						String bidNoticeChaNo =	map.get("bid_notice_no").toString().substring(map.get("bid_notice_no").toString().lastIndexOf("-")+1);
						map.put("bid_notice_no", bidNoticeNo);
						map.put("bid_notice_cha_no", bidNoticeChaNo);
						
						List<HashMap> bidDtl = openingService.selectBidDtl(map); 
													
						String scaleCode = "";
						if(bidDtl.size()>0){
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
						
						//지역제한
						String use_area_info = (String)info.get("use_area_info");
						
						if(use_area_info!=null && use_area_info.length()>0){
							String area[] = use_area_info.split(",");
							for(int i=0;i<businessList.size();i++){
								HashMap businessMap = (HashMap)businessList.get(i);
								for(int j=0;j<area.length;j++){
									if(businessMap.get("address")!=null){
										if(businessMap.get("address_nm") != null ){
											if(((String)businessMap.get("address_nm")).contains(area[j])){									
												passBussinessNo1.add(String.valueOf(((HashMap)businessList.get(i)).get("business_no")));
												break;
											}
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
						lic_limit_nm[0] = (String)info.get("lic_limit_nm1") == null ? "" : (String)info.get("lic_limit_nm1");
						lic_limit_nm[1] = (String)info.get("lic_limit_nm2") == null ? "" : (String)info.get("lic_limit_nm2");
						lic_limit_nm[2] = (String)info.get("lic_limit_nm3") == null ? "" : (String)info.get("lic_limit_nm3");
						lic_limit_nm[3] = (String)info.get("lic_limit_nm4") == null ? "" : (String)info.get("lic_limit_nm4");
						lic_limit_nm[4] = (String)info.get("lic_limit_nm5") == null ? "" : (String)info.get("lic_limit_nm5");
						lic_limit_nm[5] = (String)info.get("lic_limit_nm6") == null ? "" : (String)info.get("lic_limit_nm6");
						lic_limit_nm[6] = (String)info.get("lic_limit_nm7") == null ? "" : (String)info.get("lic_limit_nm7");
						lic_limit_nm[7] = (String)info.get("lic_limit_nm8") == null ? "" : (String)info.get("lic_limit_nm8");
						lic_limit_nm[8] = (String)info.get("lic_limit_nm9") == null ? "" : (String)info.get("lic_limit_nm9");
						lic_limit_nm[9] = (String)info.get("lic_limit_nm10") == null ? "" : (String)info.get("lic_limit_nm10");
						lic_limit_nm[10] = (String)info.get("lic_limit_nm11") == null ? "" : (String)info.get("lic_limit_nm11");
						lic_limit_nm[11] = (String)info.get("lic_limit_nm12") == null ? "" : (String)info.get("lic_limit_nm12"); 
						if(lic_limit_nm != null){
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
											List<HashMap> companyTypeList = openingService.selectBusinessCompanyTypeList(paramMap);
											
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
						}else{
							for(int i=0; i<passBussinessNo1.size();i++){
								passBussinessNo2.add((String)passBussinessNo1.get(i));
							}
						}
						//물품분류제한
						String goods_grp_limit_yn = (String)info.get("goods_grp_limit_yn");
						
						if(goods_grp_limit_yn!=null && goods_grp_limit_yn.equals("Y")){
							
							String buy_target_goods_info = (String)info.get("buy_target_goods_info");
							String paramGoods[] = null;
							
							if(buy_target_goods_info != null){
								String goods[] = buy_target_goods_info.split("##");
								
								paramGoods = new String [goods.length];
								
								for(int i=0; i<goods.length;i++){
									if(paramGoods[i] !=null){
										paramGoods[i] = goods[i].split("\\^")[1];
									}
								}
							}
							
							for(int x=0; x<passBussinessNo2.size();x++){
								HashMap paramMap = new HashMap();
								paramMap.put("business_no", (String)passBussinessNo2.get(x));
								paramMap.put("paramGoods", paramGoods);
								
								List<HashMap> goodsTypeList = openingService.selectBusinessGoodsTypeList(paramMap);
								
								if(goodsTypeList.size()>0){
									passBussinessNo3.add((String)passBussinessNo2.get(x));
									break;
								}
							}
						}else{
							for(int i=0; i<passBussinessNo2.size();i++){
								passBussinessNo3.add((String)passBussinessNo2.get(i));
							}
						}
						
						//적격정보제한
						String license_cd = (String)info.get("column2");
						if(license_cd!=null){				
							
							for(int x=0; x<passBussinessNo3.size();x++){
								HashMap paramMap = new HashMap();
								paramMap.put("business_no", (String)passBussinessNo3.get(x));
								paramMap.put("license_cd", license_cd);
								
								List<HashMap> licenseList = openingService.selectLicenseList(paramMap);
								
								if(licenseList.size()>0){
									passBussinessNo4.add((String)passBussinessNo3.get(x));
									break;
								}
							}
						}else{
							for(int i=0; i<passBussinessNo3.size();i++){
								passBussinessNo4.add((String)passBussinessNo3.get(i));
							}
						}
						
						HashMap paramMap = new HashMap();
						
						String business_no_list[] = new String[passBussinessNo4.size()];
						
						if(passBussinessNo4.size()>0){
							for(int i=0;i<business_no_list.length;i++){
								business_no_list[i] = passBussinessNo4.get(i);
							}
						}else{
							business_no_list = new String[1];
							business_no_list[0] = "";
						}
						paramMap.put("business_no_list", business_no_list);
						
						paramMap.put("bid_notice_no", bidNoticeNo);
						paramMap.put("bid_notice_cha_no", bidNoticeChaNo);
						paramMap.put("user", map.get("user"));
						
						openingService.insertBusinessRelList(paramMap);
						
						model.addAttribute("status", ResultStatus.OK.value());
						model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
					}
				}
			}
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;

	}
	
	@RequestMapping(value = "/distribution/updateDistributionList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateDistributionList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			String updated = request.getParameter("updated");
			
			if (updated != null) {
//				updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("bid_notice_no", jo.getString("bid_notice_no"));
					map.put("user_id", jo.getString("user_id"));					
					map.put("bigo", jo.getString("bigo"));
					map.put("important_yn", jo.getString("important_yn"));
					distributionService.updateDistributionList(map);
				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jSonView;

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/distribution/getDistributionDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getDistributionDtl(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			int disCnt = distributionService.selectDisCnt(map);
			
			if(disCnt <= 0){
				model.addAttribute("status", ResultStatus.NULL.value());
				model.addAttribute("resultMessage", ResultStatus.NULL.getReasonPhrase());
			}else{
				List<HashMap> resultList = null;
				resultList = distributionService.selectDistributionDtl(map);
	
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
	
	@RequestMapping(value = "/distribution/updateBidBaseAmount.do", method = RequestMethod.POST)
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
			
			distributionService.updateBidBaseAmount(map);
			
			distributionService.updateBidDetailInfo(map);
			
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
	
	@RequestMapping(value = "/distribution/getBidInfoApi.do", method = RequestMethod.POST)
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
	
	@RequestMapping(value = "/distribution/getBidDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidDtl(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			List<HashMap> resultList = null;
			resultList = distributionService.selectBidDtl(map);

			HashMap bidSubject = distributionService.selectBidSubj(map);
			HashMap bidRisk = distributionService.selectBidRisk(map);
			
			HashMap statusMap = distributionService.selectApplyInfo(map);

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
	
	@RequestMapping(value = "/distribution/bidBizRelList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidBizRelList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			List<HashMap> resultList = null;
			
			int manufactureChk = distributionService.manufactureChk(map);
			if(manufactureChk <= 0){
				resultList = distributionService.selectBizRelList(map);
			}else{
				resultList = distributionService.selectBizManufactureList(map);
			}
			model.addAttribute("rows", resultList);
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
	
	@RequestMapping(value = "/distribution/setBidDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setBidDtl(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				distributionService.updateBidDtl(map);
				distributionService.updateBidList(map);
				distributionService.updateBidRisk(map);
				distributionService.updateBidSubj(map);
				
				distributionService.deleteManufactureList(map);
				if (map.get("addData") != null) {
					JSONArray jArr = JSONArray.fromObject(map.get("addData"));					
					for (int i = 0; i < jArr.size(); i++) {
						JSONObject jo = jArr.getJSONObject(i);
						map.put("business_no", jo.getString("business_no"));
						map.put("company_nm", jo.getString("company_nm"));
						map.put("bigo", jo.getString("bigo"));
						if(!map.get("business_no").equals("") && !map.get("company_nm").equals("")){
							distributionService.updateManufactureList(map);
						}
						
					}
				}
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
	
	@RequestMapping(value = "/distribution/setApply.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setApply(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {				
				distributionService.updateApply(map);			
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
	
	@RequestMapping(value = "/distribution/setBidDtl2.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setBidDtl2(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				distributionService.updateBidDtl2(map);
				if (map.get("addData") != null) {
					JSONArray jArr = JSONArray.fromObject(map.get("addData"));					
					for (int i = 0; i < jArr.size(); i++) {
						JSONObject jo = jArr.getJSONObject(i);
						map.put("business_no", jo.getString("business_no"));
						map.put("quotation", jo.getString("quotation"));
						map.put("margin", jo.getString("margin"));
						map.put("send_yn", jo.getString("send_yn"));
						map.put("stock_yn", jo.getString("stock_yn"));
						map.put("choice_reason", jo.getString("choice_reason"));
						map.put("review", jo.getString("review"));
						map.put("choice_yn", jo.getString("choice_yn"));
						map.put("credit_yn", jo.getString("credit_yn"));
						if(!map.get("business_no").equals("")){
							distributionService.updateManufactureList2(map);
						}
					}
				}
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
	
	@RequestMapping(value = "/distribution/setApply2.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setApply2(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				map.put("type", map.get("type"));
				map.put("subType", map.get("subType"));
				distributionService.updateApply2(map);
				distributionService.updateBidRisk2(map);
				if(map.get("type").equals("pass") || map.get("subType").equals("pass") || map.get("subType").equals("ok")){
					if (map.get("addData") != null) {
						JSONArray jArr = JSONArray.fromObject(map.get("addData"));
						distributionService.deleteManufactureChoice(map);
						for (int i = 0; i < jArr.size(); i++) {
							JSONObject jo = jArr.getJSONObject(i);
							map.put("business_no", jo.getString("business_no"));
							map.put("choice_yn", jo.getString("choice_yn"));
							if(!map.get("choice_yn").equals("")){
								distributionService.updateManufactureList3(map);
							}
						}
					}
				}
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
	
	@RequestMapping(value = "/distribution/setDrop.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setDrop(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				distributionService.updateDrop(map);			
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
	
	@RequestMapping(value = "/distribution/setPick.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setPick(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				distributionService.updatePick(map);			
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
	
	@RequestMapping(value = "/distribution/manufactureList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View manufactureList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			resultList = distributionService.manufactureList(map);
			
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
	
	@RequestMapping(value = "/distribution/userList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public void userList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap map = this.bind(request);
		List<HashMap> resultList = null;

		resultList = distributionService.selectUserList(map);
		
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
		response.getWriter().write(JSONObject.fromObject(obj).toString().replace("{\"children\":[", "[").replaceAll("]}", "]"));

	}
	
	@RequestMapping(value = "/distribution/comboList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public void comboList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HashMap map = this.bind(request);
		List<HashMap> resultList = null;
		
		resultList = distributionService.selectComboList(map);
		
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
		response.getWriter().write(JSONObject.fromObject(obj).toString().replace("{\"children\":[", "[").replaceAll("]}", "]"));
		
	}
	
	@RequestMapping(value = "/distribution/sendManufacture.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View sendManufacture(HttpServletRequest request, Model model, Map<String, Object> data) throws Exception{
		
		try {
			HashMap map = this.bind(request);

			map.put("pageNo", 0);
			map.put("rows", 10);
			map.put("bidNoticeNo", map.get("bid_notice_no"));

			List<HashMap> bidInfo = distributionService.selectBidList(map);
			
			map.put("business_no", map.get("business_no"));
			map.put("send_yn", "Y");
			List<HashMap> resultList = null;
			map.put("user", request.getSession().getAttribute("loginid"));
			map.put("s_business_no", map.get("business_no"));
			map.put("message", map.get("send_message").toString().replaceAll("\n", "<br/>"));
			resultList = distributionService.manufactureList(map); 
			
			String subject = "견적요청 의뢰.";
			
			if(resultList!=null && resultList.size()>0){
				try{
					HashMap dataMap = resultList.get(0);
					
					HashMap messageMap = new HashMap();
					messageMap.put("bid_notice_no", map.get("bid_notice_no"));
					messageMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
					messageMap.put("catagory", "sendManufacture");
					messageMap.put("business_no", map.get("business_no"));
					messageMap.put("send_id", map.get("user"));

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
							commandMap.put("nameCardUrl", request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/images/nameCard/nameCard_함혜련.png");
							
							mu.sendMailLink(commandMap, bidInfo);
						}

						messageMap.put("subject", subject);
						messageMap.put("message_type", "mail");
						messageMap.put("message", ((String)map.get("message")).replaceAll("<br/>", "\n"));
						messageMap.put("sender", request.getSession().getAttribute("email"));
						messageMap.put("receiver", dataMap.get("email"));
						messageMap.put("sms_key", "");
						
						distributionService.insertBidMessage(messageMap);
						
						distributionService.updateBusinessRelList(map);
					}catch(Exception e){
						e.printStackTrace();
					}
																											
				}catch(Exception e){
					e.printStackTrace();
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
	
	@RequestMapping(value = "/distribution/setBidNotice.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View setBidNotice(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);

			int disCnt = distributionService.selectDisCnt(map);
			if(disCnt <= 0){
				distributionService.insertBidNotice(map);
				
				HashMap bizRelMap = new HashMap<>();
				bizRelMap.put("bid_notice_no", map.get("bid_notice_no"));
				bizRelMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
				bizRelMap.put("business_no", "108005");
				bizRelMap.put("user", "win4net");
				bidInfoService.updateBusinessList(bizRelMap);

				map.put("pageNo", 0);
				map.put("rows", 10);
				map.put("bidNoticeNo", map.get("bid_notice_no") + "-" + map.get("bid_notice_cha_no"));
				
				List bidInfo = openingService.selectBidList(map);
				
				if(bidInfo.size() > 0){
					List<HashMap> businessList = openingService.businessList(map);
					map.put("pageNo", 0);
					map.put("rows", 10000);
					List<HashMap> businessDtlList = openingService.selectBusinessDtlList(map);
					
					HashMap info = (HashMap)bidInfo.get(0);
					
					List<String> passBussinessNo1 = new ArrayList<String>();
					List<String> passBussinessNo2 = new ArrayList<String>();
					List<String> passBussinessNo3 = new ArrayList<String>();
					List<String> passBussinessNo4 = new ArrayList<String>();
					
					List<HashMap> bidDtl = openingService.selectBidDtl(map); 
												
					String scaleCode = "";
					if(bidDtl.size()>0){
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
					
					//지역제한
					String use_area_info = (String)info.get("use_area_info");
					
					if(use_area_info!=null && use_area_info.length()>0){
						String area[] = use_area_info.split(",");
						for(int i=0;i<businessList.size();i++){
							HashMap businessMap = (HashMap)businessList.get(i);
							for(int j=0;j<area.length;j++){
								if(businessMap.get("address")!=null){
									if(businessMap.get("address_nm") != null ){
										if(((String)businessMap.get("address_nm")).contains(area[j])){									
											passBussinessNo1.add(String.valueOf(((HashMap)businessList.get(i)).get("business_no")));
											break;
										}
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
					lic_limit_nm[0] = (String)info.get("lic_limit_nm1") == null ? "" : (String)info.get("lic_limit_nm1");
					lic_limit_nm[1] = (String)info.get("lic_limit_nm2") == null ? "" : (String)info.get("lic_limit_nm2");
					lic_limit_nm[2] = (String)info.get("lic_limit_nm3") == null ? "" : (String)info.get("lic_limit_nm3");
					lic_limit_nm[3] = (String)info.get("lic_limit_nm4") == null ? "" : (String)info.get("lic_limit_nm4");
					lic_limit_nm[4] = (String)info.get("lic_limit_nm5") == null ? "" : (String)info.get("lic_limit_nm5");
					lic_limit_nm[5] = (String)info.get("lic_limit_nm6") == null ? "" : (String)info.get("lic_limit_nm6");
					lic_limit_nm[6] = (String)info.get("lic_limit_nm7") == null ? "" : (String)info.get("lic_limit_nm7");
					lic_limit_nm[7] = (String)info.get("lic_limit_nm8") == null ? "" : (String)info.get("lic_limit_nm8");
					lic_limit_nm[8] = (String)info.get("lic_limit_nm9") == null ? "" : (String)info.get("lic_limit_nm9");
					lic_limit_nm[9] = (String)info.get("lic_limit_nm10") == null ? "" : (String)info.get("lic_limit_nm10");
					lic_limit_nm[10] = (String)info.get("lic_limit_nm11") == null ? "" : (String)info.get("lic_limit_nm11");
					lic_limit_nm[11] = (String)info.get("lic_limit_nm12") == null ? "" : (String)info.get("lic_limit_nm12"); 
					if(lic_limit_nm != null){
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
										List<HashMap> companyTypeList = openingService.selectBusinessCompanyTypeList(paramMap);
										
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
					}else{
						for(int i=0; i<passBussinessNo1.size();i++){
							passBussinessNo2.add((String)passBussinessNo1.get(i));
						}
					}
					//물품분류제한
					String goods_grp_limit_yn = (String)info.get("goods_grp_limit_yn");
					
					if(goods_grp_limit_yn!=null && goods_grp_limit_yn.equals("Y")){
						
						String buy_target_goods_info = (String)info.get("buy_target_goods_info");
						String paramGoods[] = null;
						
						if(buy_target_goods_info != null){
							String goods[] = buy_target_goods_info.split("##");
							
							paramGoods = new String [goods.length];
							
							for(int i=0; i<goods.length;i++){
								if(paramGoods[i] !=null){
									paramGoods[i] = goods[i].split("\\^")[1];
								}
							}
						}
						
						for(int x=0; x<passBussinessNo2.size();x++){
							HashMap paramMap = new HashMap();
							paramMap.put("business_no", (String)passBussinessNo2.get(x));
							paramMap.put("paramGoods", paramGoods);
							
							List<HashMap> goodsTypeList = openingService.selectBusinessGoodsTypeList(paramMap);
							
							if(goodsTypeList.size()>0){
								passBussinessNo3.add((String)passBussinessNo2.get(x));
								break;
							}
						}
					}else{
						for(int i=0; i<passBussinessNo2.size();i++){
							passBussinessNo3.add((String)passBussinessNo2.get(i));
						}
					}
					
					//적격정보제한
					String license_cd = (String)info.get("column2");
					if(license_cd!=null){				
						
						for(int x=0; x<passBussinessNo3.size();x++){
							HashMap paramMap = new HashMap();
							paramMap.put("business_no", (String)passBussinessNo3.get(x));
							paramMap.put("license_cd", license_cd);
							
							List<HashMap> licenseList = openingService.selectLicenseList(paramMap);
							
							if(licenseList.size()>0){
								passBussinessNo4.add((String)passBussinessNo3.get(x));
								break;
							}
						}
					}else{
						for(int i=0; i<passBussinessNo3.size();i++){
							passBussinessNo4.add((String)passBussinessNo3.get(i));
						}
					}
					
					HashMap paramMap = new HashMap();
					
					String business_no_list[] = new String[passBussinessNo4.size()];
					
					if(passBussinessNo4.size()>0){
						for(int i=0;i<business_no_list.length;i++){
							business_no_list[i] = passBussinessNo4.get(i);
						}
					}else{
						business_no_list = new String[1];
						business_no_list[0] = "";
					}
					paramMap.put("business_no_list", business_no_list);
					
					paramMap.put("bid_notice_no", map.get("bid_notice_no"));
					paramMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
					paramMap.put("user", map.get("user"));
					
					openingService.insertBusinessRelList(paramMap);
					
					model.addAttribute("status", ResultStatus.OK.value());
					model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
				}
			}else{
				model.addAttribute("status", ResultStatus.OVERLAP.value());
				model.addAttribute("resultMessage", ResultStatus.OVERLAP.getReasonPhrase());
			}					
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jSonView;

	}
	
	@RequestMapping(value = "/distribution/selectEstimateList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectEstimateList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = distributionService.selectEstimateList(map);
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
	
	@RequestMapping(value = "/distribution/bidApplyList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidApplyList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = distributionService.selectBidApplyList(map);
			
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
	
	@RequestMapping(value = "/distribution/getBigoDtl.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBigoDtl(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			List<HashMap> resultList = null;
			List<HashMap> resultList2 = null;
			resultList = distributionService.selectBigoDtl(map);
			resultList2 = distributionService.selectBigoDtl2(map);
			model.addAttribute("rows", resultList);
			model.addAttribute("rows2", resultList2);
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
	
	@RequestMapping(value = "/distribution/updateBigo.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBigo(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				distributionService.updateBigo(map);
				distributionService.updateBigo2(map);
				distributionService.updateColorType(map);
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
}
