package egovframework.com.bidserver.business.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.business.service.BusinessService;
import egovframework.com.bidserver.main.service.FileService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.project.service.ProjectService;
import egovframework.com.bidserver.util.FileUtil;
import egovframework.com.cmm.message.ResultStatus;

/**
 * 투찰사관리 클래스를 정의 한다
 * 
 * @author 정진고
 * @since 2016.03.10
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *  2016.03.10  정진고          최초 생성
 * </pre>
 */
@Controller
public class BusinessController extends CommonController {
	@Autowired private FileSystemResource fsResource;
	
	@Resource(name = "fileService")
	private FileService fileService;

	@Resource(name = "businessService")
	private BusinessService businessService;
	
	

	@Autowired
	private View jSonView;

	/**
	 * 투찰사관리 페이지 이동
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/business/main.do")
	public String getBusinessMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/business/main";
	}

	/**
	 * 투찰사 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/businessList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = businessService.selectBusinessList(map);

			HashMap areaMap = new HashMap();

			int seoul = 0;
			int busan = 0;
			int daegu = 0;
			int inchen = 0;
			int gwangju = 0;
			int daejaen = 0;
			int ulsan = 0;
			int seajong = 0;
			int order = 0;
			int gg = 0;
			int gw = 0;
			int cn = 0;
			int cs = 0;
			int jn = 0;
			int js = 0;
			int gn = 0;
			int gs = 0;
			int jj = 0;

			map.put("pageNo", 0);
			map.put("rows", 1000000);

			List<HashMap> resultList2 = businessService.selectBusinessList(map);

			for (int i = 0; i < resultList2.size(); i++) {
				String area = (String) resultList2.get(i).get("address_nm");

				if (area == null) {
					order++;
					continue;
				}

				switch (area) {
				case "서울특별시":
					seoul++;
					break;
				case "부산광역시":
					busan++;
					break;
				case "대구광역시":
					daegu++;
					break;
				case "인천광역시":
					inchen++;
					break;
				case "광주광역시":
					gwangju++;
					break;
				case "대전광역시":
					daejaen++;
					break;
				case "울산광역시":
					ulsan++;
					break;
				case "세종특별자치시":
					seajong++;
					break;
				case "경기도":
					gg++;
					break;
				case "강원도":
					gw++;
					break;
				case "충청북도":
					cn++;
					break;
				case "충청남도":
					cs++;
					break;
				case "전라북도":
					jn++;
					break;
				case "전라남도":
					js++;
					break;
				case "경상북도":
					gn++;
					break;
				case "경상남도":
					gs++;
					break;
				case "제주특별자치도":
					jj++;
					break;
				default:
					break;
				}
			}

			resultList2 = businessService.selectBusinessDtlList(map);
			int scale1 = 0;
			int scale2 = 0;
			int scale3 = 0;
			int scale4 = 0;
			int scale5 = 0;
			for (int i = 0; i < resultList2.size(); i++) {
				String scale = (String) resultList2.get(i).get("scale_nm");

				if (scale == null) {
					scale5++;
					continue;
				}

				switch (scale) {
				case "소기업":
					scale1++;
					break;
				case "소상공인":
					scale2++;
					break;
				case "중기업":
					scale3++;
					break;
				case "없음":
					scale4++;
					break;
				default:
					break;
				}
			}

			areaMap.put("seoul", seoul);
			areaMap.put("busan", busan);
			areaMap.put("daegu", daegu);
			areaMap.put("inchen", inchen);
			areaMap.put("gwangju", gwangju);
			areaMap.put("daejaen", daejaen);
			areaMap.put("ulsan", ulsan);
			areaMap.put("seajong", seajong);
			areaMap.put("gg", gg);
			areaMap.put("gw", gw);
			areaMap.put("cn", cn);
			areaMap.put("cs", cs);
			areaMap.put("jn", jn);
			areaMap.put("js", js);
			areaMap.put("gn", gn);
			areaMap.put("gs", gs);
			areaMap.put("jj", jj);
			areaMap.put("scale1", scale1);
			areaMap.put("scale2", scale2);
			areaMap.put("scale3", scale3);
			areaMap.put("scale4", scale4);
			areaMap.put("scale5", scale5);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", businessService.getBusinessListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
			model.addAttribute("cnt", areaMap);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}

	/**
	 * 투찰사 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/business/updateBusinessList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBusinessList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			String inserted = request.getParameter("inserted");
			String deleted = request.getParameter("deleted");
			String updated = request.getParameter("updated");

			if (deleted != null) {
				// deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", jo.getString("business_no"));
					businessService.deleteBusinessList(map);

				}
			}

			if (inserted != null) {
				// inserted = URLDecoder.decode(inserted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(inserted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", null);
					map.put("company_no", jo.getString("company_no"));
					map.put("company_nm", jo.getString("company_nm"));
					map.put("delegate", jo.getString("delegate"));
					map.put("delegate_explain", "");
					map.put("company_type", "");
					map.put("company_registration_day", "");
					map.put("address", jo.getString("address"));
					map.put("address_detail", jo.getString("address_detail"));
					map.put("phone_no", jo.getString("phone_no"));
					map.put("mobile_no", jo.getString("mobile_no"));
//					map.put("fax_no", jo.getString("fax_no"));
					map.put("fax_no", null);
					map.put("department", "");
					map.put("position", jo.getString("position"));
					map.put("bidmanager", jo.getString("bidmanager"));
					map.put("email", jo.getString("email"));
					map.put("business_condition", "");
					map.put("business_condition_detail", "");
					map.put("zip_no", "");
					map.put("gubun", "A");
					map.put("unuse_yn", jo.getString("unuse_yn"));
					map.put("bigo", "");
					map.put("msg_info1", jo.getString("msg_info1"));
					map.put("msg_info2", jo.getString("msg_info2"));
					map.put("msg_info3", jo.getString("msg_info3"));
					businessService.updateBusinessList(map);

				}
			}
			if (updated != null) {
				// updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", jo.getString("business_no"));
					map.put("company_no", jo.getString("company_no"));
					map.put("company_nm", jo.getString("company_nm"));
					map.put("delegate", jo.getString("delegate"));
					map.put("delegate_explain", "");
					map.put("company_type", "");
					map.put("company_registration_day", "");
					map.put("address", jo.getString("address"));
					map.put("address_detail", jo.getString("address_detail"));
					map.put("phone_no", jo.getString("phone_no"));
					map.put("mobile_no", jo.getString("mobile_no"));
//					map.put("fax_no", jo.getString("fax_no"));
					map.put("fax_no", null);
					map.put("department", "");
					map.put("position", jo.getString("position"));
					map.put("bidmanager", jo.getString("bidmanager"));
					map.put("email", jo.getString("email"));
					map.put("business_condition", "");
					map.put("business_condition_detail", "");
					map.put("zip_no", "");
					map.put("gubun", "A");
					map.put("pwd", jo.getString("pwd"));
					map.put("unuse_yn", jo.getString("unuse_yn"));
					map.put("bigo", "");
					map.put("msg_info1", jo.getString("msg_info1"));
					map.put("msg_info2", jo.getString("msg_info2"));
					map.put("msg_info3", jo.getString("msg_info3"));
					businessService.updateBusinessList(map);

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

	/**
	 * 투찰사 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/businessDtlList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessDtlList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = businessService.selectBusinessDtlList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", businessService.getBusinessListCnt(map));

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
	 * 투찰사 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/businessDtlList2.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessDtlList2(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = businessService.selectBusinessDtlList(map);

			for (int i = 0; i < resultList.size(); i++) {

				HashMap itemMap = resultList.get(i);

				String business_no = String.valueOf(itemMap.get("business_no"));

				itemMap.put("type_101", businessService.getEvalutionValue(business_no, "101"));
				itemMap.put("type_102", businessService.getEvalutionValue(business_no, "102"));
				itemMap.put("type_201", businessService.getEvalutionValue(business_no, "201"));
				itemMap.put("type_202", businessService.getEvalutionValue(business_no, "202"));
				itemMap.put("type_301", businessService.getEvalutionValue(business_no, "301"));
				itemMap.put("type_401", businessService.getEvalutionValue(business_no, "401"));
				itemMap.put("type_402", businessService.getEvalutionValue(business_no, "402"));
				itemMap.put("type_501", businessService.getEvalutionValue(business_no, "501"));
				itemMap.put("type_502", businessService.getEvalutionValue(business_no, "502"));
				itemMap.put("type_601", businessService.getEvalutionValue(business_no, "601"));
				itemMap.put("type_701", businessService.getEvalutionValue(business_no, "701"));

			}

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", businessService.getBusinessListCnt(map));

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
	 * 공통코드 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/business/comboEvalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public void comboEvalList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");

		HashMap map = this.bind(request);
		List<HashMap> resultList = null;

		resultList = businessService.selectComboEvalList(map);

		List returnList = new ArrayList<HashMap>();

		HashMap itemMap = new HashMap();
		if (map.get("searchType") != null && ((String) map.get("searchType")).equals("A")) {
			itemMap.put("cd", "");
			itemMap.put("cd_nm", "전체");
			returnList.add(itemMap);
		}
		if (map.get("searchType") != null && ((String) map.get("searchType")).equals("C")) {
			itemMap.put("cd", "");
			itemMap.put("cd_nm", "선택");
			returnList.add(itemMap);
		}

		for (int i = 0; i < resultList.size(); i++) {
			returnList.add(resultList.get(i));
		}

		JSONObject obj = new JSONObject();

		obj.put("children", returnList);

		response.setContentType("text/html; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");

		response.getWriter().write(JSONObject.fromObject(obj).toString().replace("{\"children\":[", "[").replaceAll("]}", "]"));

	}

	/**
	 * 투찰사 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/business/updateBusinessDtlList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBusinessDtlList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			String updated = request.getParameter("updated");

			if (updated != null) {
				// updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", jo.getString("business_no"));
					map.put("start_dt", jo.getString("start_dt").replaceAll("-", ""));
					map.put("credit_cd", jo.getString("credit_cd"));
					map.put("nep_yn", jo.getString("nep_yn"));
					map.put("license_yn", jo.getString("license_yn"));
					map.put("model_yn", jo.getString("model_yn"));
					map.put("gdgs_yn", jo.getString("gdgs_yn"));
					map.put("female_dt", jo.getString("female_dt").replaceAll("-", ""));
					map.put("scale_dt", jo.getString("scale_dt").replaceAll("-", ""));
					map.put("credit_dt", jo.getString("credit_dt").replaceAll("-", ""));
					map.put("innovate_yn", jo.getString("innovate_yn"));
					map.put("scale_cd", jo.getString("scale_cd"));
					map.put("user", request.getSession().getAttribute("loginid"));
					map.put("bigo", jo.getString("bigo"));
					businessService.updateBusinessDtlList(map);

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

	/**
	 * 공공구매정보망 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/orderBusinessList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View orderBusinessList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = businessService.selectOrderBusinessList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", businessService.getOrderBusinessListCnt(map));

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
	 * 중소기업 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/orderBusinessList2.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View orderBusinessList2(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = businessService.selectOrderBusinessList2(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", businessService.getOrderBusinessListCnt2(map));

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
	 * 기업정보 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/business/updateOrderBusinessList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateOrderBusinessList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			String inserted = request.getParameter("inserted");
			String deleted = request.getParameter("deleted");
			String updated = request.getParameter("updated");

			if (deleted != null) {
				// deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", jo.getString("business_no"));
					businessService.deleteOrderBusinessList(map);

				}
			}

			if (inserted != null) {
				// inserted = URLDecoder.decode(inserted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(inserted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", null);
					map.put("company_no", jo.getString("company_no"));
					map.put("company_nm", jo.getString("company_nm"));
					map.put("delegate", jo.getString("delegate"));
					map.put("address", jo.getString("address"));
					map.put("address_detail", jo.getString("address_detail"));
					map.put("phone_no", jo.getString("phone_no"));
					map.put("gubun", "C");
					businessService.updateOrderBusinessList(map);

				}
			}
			if (updated != null) {
				// updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", jo.getString("business_no"));
					map.put("company_no", jo.getString("company_no"));
					map.put("company_nm", jo.getString("company_nm"));
					map.put("delegate", jo.getString("delegate"));
					map.put("address", jo.getString("address"));
					map.put("address_detail", jo.getString("address_detail"));
					map.put("phone_no", jo.getString("phone_no"));
					map.put("gubun", "C");
					businessService.updateOrderBusinessList(map);

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

	/**
	 * 투찰사 사용자 등록 이력 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/selectBizNotiHisList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectBizNotiHisList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = businessService.selectBizNotiHisList(map);

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
	 * 투찰사 사용자 등록 이력 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/business/updateBizNotiHisList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBizNotiHisList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			String business_no = request.getParameter("business_no");
			String user = (String) map.get("user");

			String inserted = request.getParameter("inserted");
			String deleted = request.getParameter("deleted");
			String updated = request.getParameter("updated");

			if (deleted != null) {
				// deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map = new HashMap();
					map.put("his_id", jo.getString("his_id"));
					map.put("userId", user);
					map.put("del_yn", "Y");
					businessService.deleteBizNotiHisList(map);

				}
			}

			if (inserted != null) {
				// inserted = URLDecoder.decode(inserted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(inserted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map = new HashMap();
					map.put("his_id", null);
					map.put("business_no", business_no);
					map.put("userId", user);
					map.put("bigo", jo.getString("bigo"));
					map.put("del_yn", "N");
					businessService.insertBizNotiHisList(map);

				}
			}
			if (updated != null) {
				// updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map = new HashMap();
					map.put("his_id", jo.getString("his_id"));
					map.put("business_no", business_no);
					map.put("userId", user);
					map.put("bigo", jo.getString("bigo"));
					map.put("del_yn", "N");
					businessService.updateBizNotiHisList(map);

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

	@RequestMapping(value = "/business/downloadExcelList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void downloadExcelList(HttpServletRequest request, HttpServletResponse response, SessionStatus status, HttpSession session) throws Exception {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			map.put("pageNo", 0);
			map.put("rows", 1000000000);

			resultList = businessService.selectBusinessList(map);
			
			
			Date nowDate = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar today = Calendar.getInstance();
			String nowDate1 = sdf.format(nowDate);
			String modelName = "투찰사 정보";

			String fileName = nowDate1 + "_business" + ".xls";
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			response.setHeader("Content-Description", "JSP Generated Data");
		    response.setContentType("application/vnd.ms-excel");
			// 신규 워크북을 작성

			HSSFWorkbook wb = new HSSFWorkbook();
			// sheet1」라는 이름의 워크시트를 표시하는 오브젝트 생성
			HSSFSheet sheet1 = wb.createSheet("투찰사 정보");

			HSSFCellStyle cellStyle = wb.createCellStyle();
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			cellStyle.setFillForegroundColor(org.apache.poi.hssf.util.HSSFColor.GREY_25_PERCENT.index);
			cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			HSSFFont font = wb.createFont();
			font.setBoldweight((short) 700);
			cellStyle.setFont(font);

			HSSFCellStyle cellStyle1 = wb.createCellStyle();
			cellStyle1.setBorderRight(HSSFCellStyle.BORDER_THIN);
			cellStyle1.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			cellStyle1.setBorderTop(HSSFCellStyle.BORDER_THIN);
			cellStyle1.setBorderBottom(HSSFCellStyle.BORDER_THIN);

			HSSFRow row = sheet1.createRow((short) 0);
			row = sheet1.createRow((short) 0);
			int h = 0;
			String header[] = new String[12];
			header[h++] = "No.";
			header[h++] = "사업자번호";
			header[h++] = "업체명";
			header[h++] = "대표자명";
			header[h++] = "기본주소";
			header[h++] = "상세주소";
			header[h++] = "직위";
			header[h++] = "담당자명";
			header[h++] = "전화";
			header[h++] = "휴대폰";
			header[h++] = "fax";
			header[h++] = "이메일";

			sheet1.setColumnWidth(0, 2000);
			for (int i = 0; i < header.length; i++) {
				sheet1.setColumnWidth(i, 3000);
			}

			// 헤더 그리기
			HSSFCell cell = row.createCell(0);
			// cell.setEncoding(HSSFCell.ENCODING_UTF_16);

			for (int i = 0; i < header.length; i++) {

				cell = row.createCell(i);
				cell.setCellStyle(cellStyle);
				cell.setCellValue(header[i]);
			}

			for (int i = 0; i < resultList.size(); i++) {

				Map map1 = resultList.get(i);

				row = sheet1.createRow(i + 1);

				for (int z = 0; z < header.length; z++) {
					cell = row.createCell(z);
					HSSFCellStyle cellStyle0 = wb.createCellStyle();
					cellStyle0.setBorderRight(HSSFCellStyle.BORDER_THIN);
					cellStyle0.setBorderLeft(HSSFCellStyle.BORDER_THIN);
					cellStyle0.setBorderTop(HSSFCellStyle.BORDER_THIN);
					cellStyle0.setBorderBottom(HSSFCellStyle.BORDER_THIN);
					font = wb.createFont();
					// font .setBoldweight((short)700);
					cellStyle0.setFont(font);
					
					if (z == 0) {
						cellStyle0.setAlignment(HSSFCellStyle.ALIGN_CENTER);
					}else{
						cellStyle0.setAlignment(HSSFCellStyle.ALIGN_LEFT);
					}

					cell.setCellStyle(cellStyle0);

				}

				row.getCell(0).setCellValue((Integer)map1.get("business_no"));
				row.getCell(1).setCellValue((String)map1.get("company_no"));
				row.getCell(2).setCellValue((String)map1.get("company_nm"));
				row.getCell(3).setCellValue((String)map1.get("delegate"));
				row.getCell(4).setCellValue((String)map1.get("address_nm"));
				row.getCell(5).setCellValue((String)map1.get("address_detail"));
				row.getCell(6).setCellValue((String)map1.get("position"));
				row.getCell(7).setCellValue((String)map1.get("bidmanager"));
				row.getCell(8).setCellValue((String)map1.get("phone_no"));
				row.getCell(9).setCellValue((String)map1.get("mobile_no"));
				row.getCell(10).setCellValue((String)map1.get("fax_no"));
				row.getCell(11).setCellValue((String)map1.get("email"));
				

			}

			OutputStream fileOut = response.getOutputStream();
			wb.write(fileOut);
			
			fileOut.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		

//		return "/admin/business/excel";

	}
	
	/**
	 * 투찰사 파일 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/business/updateCompanyFileList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateCompanyFileList(MultipartHttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap paramMap = this.bindEncoding(request,"utf-8");
			
			String key = (String)paramMap.get("business_no");
			
			//이전 목록 불러오기
			List<HashMap> beforeList = null;
			HashMap beforeMap = new HashMap();
			beforeMap.put("business_no", key);
			beforeMap.put("pageNo", 0);
			beforeMap.put("rows", 1);
			beforeList = businessService.selectBusinessList(beforeMap);
			
			String fileId1 = null;
			String fileId2 = null;
			String fileId3 = null;
			String fileId4 = null;
			
			HashMap fileMap = new HashMap();
			fileMap.put("business_no", key);

			if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()>0){
				if(request.getFile("file1")==null || request.getFile("file1").getBytes().length==0){
					fileMap.put("file_id1", (String)beforeList.get(0).get("file_id1"));
				}else{
					fileId1 = uploadFile1(request.getFile("file1"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id1"), "UTF-8"));
					fileMap.put("file_id1", fileId1);
				}
			}else{
				fileMap.put("file_id1", fileId1);
			}
			if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()>0){
				if(request.getFile("file2")==null || request.getFile("file2").getBytes().length==0){
					fileMap.put("file_id2", (String)beforeList.get(0).get("file_id2"));
				}else{
					fileId2 = uploadFile1(request.getFile("file2"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id2"), "UTF-8"));
					fileMap.put("file_id2", fileId2);
				}
			}else{
				fileMap.put("file_id2", fileId2);
			}
			if(URLDecoder.decode(request.getParameter("file_id3"), "UTF-8").length()>0){
				if(request.getFile("file3")==null || request.getFile("file3").getBytes().length==0){
					fileMap.put("file_id3", (String)beforeList.get(0).get("file_id3"));
				}else{
					fileId3 = uploadFile1(request.getFile("file3"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id3"), "UTF-8"));
					fileMap.put("file_id3", fileId3);
				}
			}else{
				fileMap.put("file_id3", fileId3);
			}
			if(URLDecoder.decode(request.getParameter("file_id4"), "UTF-8").length()>0){
				if(request.getFile("file4")==null || request.getFile("file4").getBytes().length==0){
					fileMap.put("file_id4", (String)beforeList.get(0).get("file_id4"));
				}else{
					fileId4 = uploadFile1(request.getFile("file4"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id4"), "UTF-8"));
					fileMap.put("file_id4", fileId4);
				}
			}else{
				fileMap.put("file_id4", fileId4);
			}
			
			
			businessService.updateCompanyFileList(fileMap);
			
			//이전파일 삭제
			if(fileId1!=null){
				removeFile((String)beforeList.get(0).get("file_id1"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()==0){
					removeFile((String)beforeList.get(0).get("file_id1"));
				}
			}
			if(fileId2!=null){
				removeFile((String)beforeList.get(0).get("file_id2"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()==0){
					removeFile((String)beforeList.get(0).get("file_id2"));
				}
			}
			if(fileId3!=null){
				removeFile((String)beforeList.get(0).get("file_id3"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id3"), "UTF-8").length()==0){
					removeFile((String)beforeList.get(0).get("file_id3"));
				}
			}
			if(fileId4!=null){
				removeFile((String)beforeList.get(0).get("file_id4"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id4"), "UTF-8").length()==0){
					removeFile((String)beforeList.get(0).get("file_id4"));
				}
			}
			

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
	 * 이전 저장파일 삭제
	 * @param beforeId
	 */
	public void removeFile(String beforeId){
		try{
			if(beforeId!=null && beforeId.length()>0){
				HashMap fileMap = new HashMap();
				fileMap.put("file_id", beforeId);
				HashMap fileInfo = fileService.detail(fileMap);
				
				File removeFile = new File((String)fileInfo.get("real_file_path"));
				if(removeFile.exists()){
					removeFile.delete();
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public String uploadFile1(MultipartFile mpf, String folderPath, String realFileName) throws Exception{
        
        try {
            System.out.println("file length : " + mpf.getBytes().length);
            System.out.println("file name : " + realFileName);
            
            
            if(mpf.getBytes().length==0){
            	return "";
            }

            String fileId = UUID.randomUUID().toString();
            
            try {

            	File dir = new File(fsResource.getPath()+folderPath);  // 폴더경로지정
            	
            	if(!dir.isDirectory()){
            		dir.mkdirs();
            	}
            	
            	 HashMap map = new HashMap();
            	 
            	 map.put("file_id", fileId);
            	 map.put("org_file_name", realFileName);
            	 map.put("file_path", folderPath);
            	 map.put("real_file_path", fsResource.getPath() + folderPath + fileId +"."+FileUtil.getFileType(realFileName));
            	 map.put("real_file_name", fileId +"."+FileUtil.getFileType(realFileName));
            	 map.put("file_size", mpf.getBytes().length);
            	 map.put("file_ext", FileUtil.getFileType(realFileName));
            	 
                 fileService.insert(map);
            	
                File outFileName = new File(fsResource.getPath() + folderPath + fileId +"."+FileUtil.getFileType(realFileName));

                FileOutputStream fileoutputStream = new FileOutputStream(outFileName);

                fileoutputStream.write(mpf.getBytes());

                fileoutputStream.close();
                
               
                

           } catch (IOException ie) {

                System.err.println("File writing error! ");

           }
            return fileId;

        } catch (IOException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        return "";
	}
	
	/**
	 * 투찰사 투찰이력 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/businessBidInfoList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessBidInfoList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;
		List<HashMap> footerList = new ArrayList();

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = businessService.selectBusinessBidInfoList(map);
			

			map.put("pageNo", 0);
			map.put("rows", 100000);
			List<HashMap> totResultList  = businessService.selectBusinessBidInfoList(map);

			
			float totalValue1 = 0;
			float totalValue2 = 0;
			
			for(int i=0;i<totResultList.size();i++){
				String value;
				
				if(totResultList.get(i).get("cnt")!=null){
					value = String.valueOf(totResultList.get(i).get("cnt"));
					if(value!=null && value.length()>0){
						totalValue1 += Float.parseFloat(value);
					}
				}
				
				if(totResultList.get(i).get("cnt1")!=null){
					value = String.valueOf(totResultList.get(i).get("cnt1"));
					if(value!=null && value.length()>0){
						totalValue2 += Float.parseFloat(value);
					}
				}

			}
			
			HashMap itemMap = new HashMap();
			itemMap.put("company_nm", "Total");
			itemMap.put("cnt", totalValue1);
			itemMap.put("cnt1", totalValue2);
			
			footerList.add(itemMap);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", businessService.getBusinessBidInfoListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
			model.addAttribute("footer", footerList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 투찰사 투찰이력 상세 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/business/businessBidInfoDtlList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessBidInfoDtlList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = businessService.selectBusinessBidInfoDtlList(map);

			HashMap areaMap = new HashMap();

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
}
