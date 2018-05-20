package egovframework.com.bidserver.enterprise.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.enterprise.service.EnterpriseService;
import egovframework.com.bidserver.main.service.FileService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.schedule.service.PublicDataService;
import egovframework.com.bidserver.util.FileUtil;
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
public class EnterpriseController extends CommonController {
	
	@Autowired private FileSystemResource fsResource;
	
	@Resource(name = "fileService")
	private FileService fileService;
	
	@Resource(name = "enterpriseService")
	private EnterpriseService enterpriseService;
	
	@Resource(name = "publicDataService")
	private PublicDataService publicDataService;

	@Autowired
	private View jSonView;

	@RequestMapping(value = "/admin/enterprise/main.do")
	public String getBidNoticeNewMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/enterprise/main";
	}
	
	@RequestMapping(value = "/enterprise/manufactureList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View enterpriseList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = enterpriseService.selectManufactureList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", enterpriseService.getManufactureListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/enterprise/insertManufacture.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View insertManufacture(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				enterpriseService.insertManufacture(map);		
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
	
	@RequestMapping(value = "/enterprise/updateManufacture.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateManufactureList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			String updated = request.getParameter("updated");
			String company_type = "";
			if (updated != null) {
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					
					map.put("business_no", jo.getString("business_no"));
					map.put("company_no", jo.getString("company_no"));
					map.put("company_nm", jo.getString("company_nm"));
					map.put("delegate", jo.getString("delegate"));
					map.put("delegate_explain", jo.getString("delegate_explain"));
					map.put("delegate_explain2", jo.getString("delegate_explain2"));
					map.put("delegate_explain3", jo.getString("delegate_explain3"));
					if(jo.getString("company_type1").equals("Y") && !jo.getString("company_type2").equals("Y")){
						company_type = "1";
					}else if(!jo.getString("company_type1").equals("Y") && jo.getString("company_type2").equals("Y")){
						company_type = "2";
					}else if(jo.getString("company_type1").equals("Y") && jo.getString("company_type2").equals("Y")){
						company_type = "3";
					}
					map.put("company_type", company_type);
					map.put("address", jo.getString("address"));
					map.put("address_detail", jo.getString("address_detail"));
					map.put("phone_no", jo.getString("phone_no"));
					map.put("mobile_no", jo.getString("mobile_no"));
					map.put("position", jo.getString("position"));
					map.put("bidmanager", jo.getString("bidmanager"));
					map.put("email", jo.getString("email"));
					map.put("unuse_yn", jo.getString("unuse_yn"));
					enterpriseService.updateManufacture(map);

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
	
	@RequestMapping(value = "/enterprise/deleteManufacture.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteManufacture(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				enterpriseService.deleteManufacture(map);		
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
	
	@RequestMapping(value = "/enterprise/deleteBusiness.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteBusiness(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				enterpriseService.deleteBusiness(map);		
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
	
	@RequestMapping(value = "/enterprise/getBizHisList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBizHisList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectBizHisList(map);
			

			map.put("pageNo", 0);
			map.put("rows", 1);

			List<HashMap> resultList2 = enterpriseService.selectManufactureList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
			model.addAttribute("rows2", resultList2);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/enterprise/selectBizNotiHisList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectBizNotiHisList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectBizNotiHisList(map);

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
	
	@RequestMapping(value = "/enterprise/updateBizNotiHisList.do", method = RequestMethod.POST)
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
					enterpriseService.deleteBizNotiHisList(map);

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
					enterpriseService.insertBizNotiHisList(map);

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
					enterpriseService.updateBizNotiHisList(map);

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
	
	@RequestMapping(value = "/enterprise/getBidReportList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidReportList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = enterpriseService.selectBidReportList(map);
			
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
	
	@RequestMapping(value = "/enterprise/insertBusiness.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View insertBusiness(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			if (map != null) {
				enterpriseService.insertBusiness(map);
				enterpriseService.insertBusinessDetail(map);
				System.out.println("맵키===" + map.get("business_no"));				
			}
			String company_type = (String) map.get("company_type");
			String[] company_type_result = company_type.split(",");
			for(int i=0; i<company_type_result.length;i++){
				map.put("company_type_cd", company_type_result[i]);
				enterpriseService.insertCompanyType(map);	
			}
			String goods_type = (String) map.get("goods_type");
			String[] goods_type_result = goods_type.split(",");
			for(int j=0; j<goods_type_result.length;j++){
				map.put("goods_no", goods_type_result[j]);
				enterpriseService.insertGoodsType(map);	
			}
			String goods_direct = (String) map.get("goods_direct");
			String[] goods_direct_result = goods_direct.split(",");
			for(int i=0; i<goods_direct_result.length;i++){
				map.put("goods_no", goods_direct_result[i]);
				enterpriseService.insertGoodsDirectType(map);	
			}						
			String license = (String) map.get("license_cd");
			String[] license_result = license.split(",");
			for(int i=0; i<license_result.length;i++){
				map.put("license_cd", license_result[i]);
				enterpriseService.insertCompanylicense(map);	
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
	
	@RequestMapping(value = "/enterprise/comboEvalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public void comboEvalList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");

		HashMap map = this.bind(request);
		List<HashMap> resultList = null;

		resultList = enterpriseService.selectComboEvalList(map);

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
	
	@RequestMapping(value = "/enterprise/businessList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = enterpriseService.selectBusinessList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", enterpriseService.getBusinessListCnt(map));

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
	 * 투찰사 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/enterprise/updateBusinessList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBusinessList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			String updated = request.getParameter("updated");

			if (updated != null) {
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
					map.put("mobile_no", jo.getString("mobile_no"));
					map.put("position", jo.getString("position"));
					map.put("bidmanager", jo.getString("bidmanager"));
					map.put("email", jo.getString("email"));
					map.put("pwd", jo.getString("pwd"));
					map.put("unuse_yn", jo.getString("unuse_yn"));
					map.put("join_route", jo.getString("join_route"));
					
					enterpriseService.updateBusinessList(map);
					
					map.put("start_dt", jo.getString("start_dt").replaceAll("-", ""));
					map.put("scale_cd", jo.getString("scale_cd"));
					map.put("scale_dt", jo.getString("scale_dt").replaceAll("-", ""));
					map.put("credit_cd", jo.getString("credit_cd"));
					map.put("credit_dt", jo.getString("credit_dt").replaceAll("-", ""));
					map.put("female_yn", jo.getString("female_yn"));
					map.put("female_dt", jo.getString("female_dt").replaceAll("-", ""));
					
					enterpriseService.updateBusinessList2(map);
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
	
	@RequestMapping(value = "/enterprise/licenseList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View licenseList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectLicenseList(map);

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
	
	@RequestMapping(value = "/enterprise/removeLicenseList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View removeLicenseList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("license_cd", jo.getString("license_cd"));
					enterpriseService.removeLicenseList(map);

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
	
	@RequestMapping(value = "/enterprise/licenseTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View licenseTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectLicenseTotalList(map);

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
	
	@RequestMapping(value = "/enterprise/updateLicenseList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateLicenseList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("cd", jo.getString("cd"));
					enterpriseService.updateLicenseList(map);

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
	
	@RequestMapping(value = "/enterprise/companyTypeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View companyTypeList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectCompanyTypeList(map);

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
	
	@RequestMapping(value = "/enterprise/removeBizCompanyTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View removeBizCompanyTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("cd", jo.getString("cd"));
					enterpriseService.removeBizCompanyTypeList(map);

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
	
	@RequestMapping(value = "/enterprise/goodsTypeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsTypeList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectGoodsTypeList(map);

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
	
	@RequestMapping(value = "/enterprise/goodsTypeTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsTypeTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = enterpriseService.selectGoodsTypeTotalList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", enterpriseService.getGoodsTypeTotalCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/enterprise/updateBizGoodsTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBizGoodsTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					enterpriseService.updateBizGoodsTypeList(map);

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
	
	@RequestMapping(value = "/enterprise/removeBizGoodsTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View removeBizGoodsTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					enterpriseService.removeBizGoodsTypeList(map);

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
	
	@RequestMapping(value = "/enterprise/goodsDirectList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsDirectList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectGoodsDirectList(map);

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
	
	@RequestMapping(value = "/enterprise/goodsDirectTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsDirectTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = enterpriseService.selectGoodsDirectTotalList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", enterpriseService.getGoodsDirectTotalCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/enterprise/updateBizGoodsDirectList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBizGoodsDirectList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					enterpriseService.updateBizGoodsDirectList(map);

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
	
	@RequestMapping(value = "/enterprise/removeBizGoodsDirectList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View removeBizGoodsDirectList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					enterpriseService.removeBizGoodsDirectList(map);
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
	
	@RequestMapping(value = "/enterprise/companyTypeTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View companyTypeTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = enterpriseService.selectCompanyTypeTotalList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", enterpriseService.getCompanyTypeTotalCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	@RequestMapping(value = "/enterprise/licenseTypeTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View licenseTypeTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = enterpriseService.selectLicenseTypeTotalList(map);

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
	
	@RequestMapping(value = "/enterprise/updateBizCompanyTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBizCompanyTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("cd", jo.getString("cd"));
					enterpriseService.updateBizCompanyTypeList(map);
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
	
	@RequestMapping(value = "/enterprise/updateCompanyFileList.do", method = RequestMethod.POST)
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
			beforeList = enterpriseService.selectFileDtl(beforeMap);
			
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
				if(beforeList.get(0) != null){
					fileMap.put("file_id1", fileId1);
				}
			}
			if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()>0){
				if(request.getFile("file2")==null || request.getFile("file2").getBytes().length==0){
					fileMap.put("file_id2", (String)beforeList.get(0).get("file_id2"));
				}else{
					fileId2 = uploadFile1(request.getFile("file2"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id2"), "UTF-8"));
					fileMap.put("file_id2", fileId2);
				}
			}else{
				if(beforeList.get(0) != null){
					fileMap.put("file_id2", fileId2);
				}
			}
			if(URLDecoder.decode(request.getParameter("file_id3"), "UTF-8").length()>0){
				if(request.getFile("file3")==null || request.getFile("file3").getBytes().length==0){
					fileMap.put("file_id3", (String)beforeList.get(0).get("file_id3"));
				}else{
					fileId3 = uploadFile1(request.getFile("file3"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id3"), "UTF-8"));
					fileMap.put("file_id3", fileId3);
				}
			}else{
				if(beforeList.get(0) != null){
					fileMap.put("file_id3", fileId3);
				}
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
			
			
			enterpriseService.updateCompanyFileList(fileMap);
			
			//이전파일 삭제
			if(fileId1!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id1"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id1"));
					}
				}
			}
			if(fileId2!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id2"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id2"));
					}
				}
			}
			if(fileId3!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id3"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id3"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id3"));
					}
				}
			}
			if(fileId4!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id4"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id4"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id4"));
					}
				}
			}
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		} catch (IOException e1) {
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;

	}
	
	@RequestMapping(value = "/enterprise/updateCompanyFileList2.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateCompanyFileList2(MultipartHttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap paramMap = this.bindEncoding(request,"utf-8");
			
			String key = (String)paramMap.get("business_no");
			
			//이전 목록 불러오기
			List<HashMap> beforeList = null;
			HashMap beforeMap = new HashMap();
			beforeMap.put("business_no", key);
			beforeMap.put("pageNo", 0);
			beforeMap.put("rows", 1);
			beforeList = enterpriseService.selectFileDtl(beforeMap);
			
			String fileId1 = null;
			String fileId2 = null;
			String fileId3 = null;
			String fileId4 = null;
			
			HashMap fileMap = new HashMap();
			fileMap.put("business_no", key);

			if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()>0){
				if(request.getFile("joinReqFile1")==null || request.getFile("joinReqFile1").getBytes().length==0){
					fileMap.put("file_id1", (String)beforeList.get(0).get("file_id1"));
				}else{
					fileId1 = uploadFile1(request.getFile("joinReqFile1"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id1"), "UTF-8"));
					fileMap.put("file_id1", fileId1);
				}
			}else{
				fileMap.put("file_id1", fileId1);
			}
			if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()>0){
				if(request.getFile("joinReqFile2")==null || request.getFile("joinReqFile2").getBytes().length==0){
					fileMap.put("file_id2", (String)beforeList.get(0).get("file_id2"));
				}else{
					fileId2 = uploadFile1(request.getFile("joinReqFile2"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id2"), "UTF-8"));
					fileMap.put("file_id2", fileId2);
				}
			}else{
				fileMap.put("file_id2", fileId2);
			}
			if(URLDecoder.decode(request.getParameter("file_id3"), "UTF-8").length()>0){
				if(request.getFile("joinReqFile3")==null || request.getFile("joinReqFile3").getBytes().length==0){
					fileMap.put("file_id3", (String)beforeList.get(0).get("file_id3"));
				}else{
					fileId3 = uploadFile1(request.getFile("joinReqFile3"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id3"), "UTF-8"));
					fileMap.put("file_id3", fileId3);
				}
			}else{
				fileMap.put("file_id3", fileId3);
			}
			if(URLDecoder.decode(request.getParameter("file_id4"), "UTF-8").length()>0){
				if(request.getFile("joinReqFile4")==null || request.getFile("joinReqFile4").getBytes().length==0){
					fileMap.put("file_id4", (String)beforeList.get(0).get("file_id4"));
				}else{
					fileId4 = uploadFile1(request.getFile("joinReqFile4"), "business/"+key+"/", URLDecoder.decode(request.getParameter("file_id4"), "UTF-8"));
					fileMap.put("file_id4", fileId4);
				}
			}else{
				fileMap.put("file_id4", fileId4);
			}
			
			
			enterpriseService.updateCompanyFileList(fileMap);
			
			//이전파일 삭제
			if(fileId1!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id1"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id1"));
					}
				}
			}
			if(fileId2!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id2"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id2"));
					}
				}
			}
			if(fileId3!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id3"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id3"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id3"));
					}
				}
			}
			if(fileId4!=null){
				if(beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id4"));
				}
			}else{
				if(URLDecoder.decode(request.getParameter("file_id4"), "UTF-8").length()==0){
					if(beforeList.get(0) != null){
						removeFile((String)beforeList.get(0).get("file_id4"));
					}
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
	
	@RequestMapping(value = "/enterprise/joinArrpoveOrRefusal.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View joinArrpoveOrRefusal(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			String businessNo = (String) map.get("business_no");
			String msgText = null;
			
			MailUtil mu = new MailUtil();
			
			HashMap commandMap = new HashMap();
			
			commandMap.put("to", map.get("email"));
			//commandMap.put("to","gsg332@nate.com");
			commandMap.put("email","bid@in-con.biz");     
			commandMap.put("emailPw","whekf00!!");     
			commandMap.put("emailHost","smart.whoismail.net");    
			commandMap.put("emailPort","587");

			StringBuffer sb = new StringBuffer();
			
			if("Y".equals(map.get("join_approve_yn"))){ // 승인

				enterpriseService.updateBusinessList(map);
				
				commandMap.put("subject","회원가입 승인 완료");  //subject
				
				sb.append("안녕하세요 (주)인콘 입니다.");
				sb.append("<br/>");
				sb.append("조달포털 시스템을 이용해 주셔서 감사합니다. (진행시 전화문의 부탁드립니다. 안내드리도록 하겠습니다.");
				sb.append("<br/>");
				sb.append("<br/>");
				sb.append("물품조달포털시스템 주소 : <a href=\"http://122.199.233.89:8080/bidmobild/login.jsp\">http://122.199.233.89:8080/bidmobild/login.jsp</a>");
				sb.append("<br/>");
				sb.append("아이디 : ");
				sb.append(businessNo);
				sb.append("<br/>");
				sb.append("비밀번호 : 일회용비밀번호 받기 이용");
				sb.append("<br/>");
				sb.append("<br/>");
				sb.append("저희 조달포털시스템은");
				sb.append("<br/>");
				sb.append("&nbsp;&nbsp;&nbsp;&nbsp; 1. 가격을 직접제공하지 않는 대신, 가격을 신청할 수 있는 추천구간 등을 제공해드립니다.");
				sb.append("<br/>");
				sb.append("&nbsp;&nbsp;&nbsp;&nbsp; 2. 상품건이 올라와 있는 경우 문자 알림을 드리며, 웹에서는 push 기능이 없으므로 수시로 확인해주시길 바랍니다.");
				sb.append("<br/>");
				sb.append("&nbsp;&nbsp;&nbsp;&nbsp; 3. 부여해 드린 아이디는 디지털라인이 진행 가능한 공고들만 보내드립니다.");
				sb.append("<br/>");
				sb.append("&nbsp;&nbsp;&nbsp;&nbsp; 4. 카카오톡 옐로아이디 : 입찰참가신청 및 물품등록요청 / 조달포털 : 투찰안내");
				sb.append("<br/>");
				sb.append("<br/>");
				sb.append("이외 문의사항 담당자는 ");
				sb.append("<br/>");
				sb.append("&nbsp;&nbsp;&nbsp;&nbsp; ** 포털시스템 및 프로세스문의 ; 인콘 조달팀 함혜련 대리 070-5075-0252");
				sb.append("<br/>");
				sb.append("&nbsp;&nbsp;&nbsp;&nbsp; ** 총괄문의 : 인콘 조달팀 조시형차장 070-5075-0246");
				sb.append("<br/>");
				sb.append("<br/>");
				sb.append("이며 문의 사항이 있으시면 연락 부탁드립니다.");
				sb.append("<br/>");
				sb.append("(첨부파일 사용자메뉴얼을 확인 부탁드립니다.)");
				sb.append("<br/>");
				sb.append("감사합니다.");
			}else{ // 반려
				//이전 목록 불러오기
				List<HashMap> beforeList = null;
				HashMap beforeMap = new HashMap();
				beforeMap.put("business_no", businessNo);
				beforeMap.put("pageNo", 0);
				beforeMap.put("rows", 1);
				beforeList = enterpriseService.selectFileDtl(beforeMap);
				
				/*
				HashMap fileMap = new HashMap();
				fileMap.put("business_no", businessNo);
				fileMap.put("file_id1", null);
				fileMap.put("file_id2", null);
				fileMap.put("file_id3", null);
				fileMap.put("file_id4", null);
				enterpriseService.updateCompanyFileList(fileMap);
				*/
				
				//이전파일 삭제
				if(beforeList.size() > 0 && beforeList.get(0) != null){
					removeFile((String)beforeList.get(0).get("file_id1"));
					removeFile((String)beforeList.get(0).get("file_id2"));
					removeFile((String)beforeList.get(0).get("file_id3"));
					removeFile((String)beforeList.get(0).get("file_id4"));
				}

				enterpriseService.deleteBusiness(map);
				enterpriseService.deleteBusinessDetail(map);
				enterpriseService.deleteBusinessGoods(map);
				enterpriseService.deleteBusinessGoodsDirect(map);
				enterpriseService.deleteBusinessLicense(map);
				enterpriseService.deleteBusinessType(map);
				enterpriseService.deleteBusinessCreditDegree(map);
				
				commandMap.put("subject","회원가입 반려 처리");  //subject
				
				sb.append("안녕하세요 (주)인콘 입니다.");
				sb.append("<br/>");
				sb.append("<br/>");
				sb.append("인콘 조달포털메신저의 \"반려\"처리 되었습니다.");
				sb.append("<br/>");
				sb.append("<br/>");
				sb.append("자세한 사항은 이메일로 문의부탁드립니다.");
			}
			
			commandMap.put("msgText", sb.toString());  //message
			
			mu.sendMail(commandMap, null);
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jSonView;

	}
	
	@RequestMapping(value = "/enterprise/downloadExcelList.do")
	@ResponseStatus(HttpStatus.OK)
	public void downloadExcelList(HttpServletRequest request, HttpServletResponse response, SessionStatus status, HttpSession session) throws Exception {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			/*
			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));
			*/

			resultList = enterpriseService.selectBusinessExcelList(map);
			
			Date nowDate = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar today = Calendar.getInstance();
			String nowDate1 = sdf.format(nowDate);
			String modelName = "투찰사 목록";

			String fileName = nowDate1 + "_enterprise" + ".xls";
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			response.setHeader("Content-Description", "JSP Generated Data");
		    response.setContentType("application/vnd.ms-excel");
			// 신규 워크북을 작성

			HSSFWorkbook wb = new HSSFWorkbook();
			// sheet1」라는 이름의 워크시트를 표시하는 오브젝트 생성
			HSSFSheet sheet1 = wb.createSheet("투찰사 목록");

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
			String header[] = new String[31];
			header[h++] = "No.";
			header[h++] = "계정";
			header[h++] = "사업자번호";
			header[h++] = "업체명";
			header[h++] = "개인/법인";
			header[h++] = "대표자명";
			header[h++] = "기본주소";
			header[h++] = "상세주소";
			header[h++] = "직위";
			header[h++] = "담당자명";
			header[h++] = "휴대폰";
			header[h++] = "사업자";
			header[h++] = "신용평가";
			header[h++] = "신용평가유효일";
			header[h++] = "기업형태";
			header[h++] = "기업형태유효기간";
			header[h++] = "업면허";
			header[h++] = "신인도";
			header[h++] = "관계사";
			header[h++] = "조달청 고시금액미만";
			header[h++] = "조달청 10억미만";
			header[h++] = "조달청 중소기업 고시금액미만";
			header[h++] = "조달청 중소기업 10억미만";
			header[h++] = "지방자치단체 고시금액미만";
			header[h++] = "지방자치단체 10억미만";
			header[h++] = "국방부 고시금액미만";
			header[h++] = "국방부 10억미만";
			header[h++] = "중기청 고시금액미만";
			header[h++] = "중기청 10억미만";
			header[h++] = "국제 고시금액미만";
			header[h++] = "국제 10억미만";
			
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
			
			HSSFCellStyle cellStyle0 = wb.createCellStyle();
			cellStyle0.setBorderRight(HSSFCellStyle.BORDER_THIN);
			cellStyle0.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			cellStyle0.setBorderTop(HSSFCellStyle.BORDER_THIN);
			cellStyle0.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			font = wb.createFont();
			// font .setBoldweight((short)700);
			cellStyle0.setFont(font);
			cellStyle0.setAlignment(HSSFCellStyle.ALIGN_CENTER);

			for (int i = 0; i < resultList.size(); i++) {
				Map map1 = resultList.get(i);
				row = sheet1.createRow(i + 1);

				for (int z = 0; z < header.length; z++) {
					cell = row.createCell(z);
					cell.setCellStyle(cellStyle0);
				}

				row.getCell(0).setCellValue(i+1);
				row.getCell(1).setCellValue((Integer)map1.get("business_no"));
				row.getCell(2).setCellValue((String)map1.get("company_no"));

				String companyNm = (String) map1.get("company_nm");
				row.getCell(3).setCellValue(companyNm);
				
				String type = null;
				if(companyNm.indexOf("(주)") > -1){
					type = "법인";
				}else{
					type = "개인";
				}
				row.getCell(4).setCellValue(type);   
				row.getCell(5).setCellValue((String)map1.get("delegate"));
				row.getCell(6).setCellValue((String)map1.get("address_nm"));
				row.getCell(7).setCellValue((String)map1.get("address_detail"));
				row.getCell(8).setCellValue((String)map1.get("position"));
				row.getCell(9).setCellValue((String)map1.get("bidmanager"));
				row.getCell(10).setCellValue((String)map1.get("mobile_no"));
				row.getCell(11).setCellValue((String)map1.get("start_dt"));
				row.getCell(12).setCellValue((String)map1.get("credit_nm"));
				row.getCell(13).setCellValue((String)map1.get("credit_dt"));
				row.getCell(14).setCellValue((String)map1.get("scale_nm"));
				row.getCell(15).setCellValue((String)map1.get("scale_dt"));
				row.getCell(16).setCellValue((String)map1.get("goodsList"));
				row.getCell(17).setCellValue((String)map1.get("creditDgreeList"));
				row.getCell(18).setCellValue((String)map1.get("join_route"));
				row.getCell(19).setCellValue((String)map1.get("license1"));
				row.getCell(20).setCellValue((String)map1.get("license2"));
				row.getCell(21).setCellValue((String)map1.get("license3"));
				row.getCell(22).setCellValue((String)map1.get("license4"));
				row.getCell(23).setCellValue((String)map1.get("license5"));
				row.getCell(24).setCellValue((String)map1.get("license6"));
				row.getCell(25).setCellValue((String)map1.get("license7"));
				row.getCell(26).setCellValue((String)map1.get("license8"));
				row.getCell(27).setCellValue((String)map1.get("license9"));
				row.getCell(28).setCellValue((String)map1.get("license10"));
				row.getCell(29).setCellValue((String)map1.get("license11"));
				row.getCell(30).setCellValue((String)map1.get("license12"));
			}

			OutputStream fileOut = response.getOutputStream();
			wb.write(fileOut);
			
			fileOut.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/enterprise/updateGoodsDirectLimitDt.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateGoodsDirectLimitDt(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));
				
				map.put("business_no", map.get("business_no").toString());

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					map.put("limit_dt", (jo.containsKey("limit_dt") && !StringUtils.isEmpty(jo.getString("limit_dt"))) ? jo.getString("limit_dt") : null);
					enterpriseService.updateGoodsDirectType(map);
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
	
	@RequestMapping(value = "/enterprise/updateLicenseLimitDt.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateLicenseLimitDt(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));
				
				map.put("business_no", map.get("business_no").toString());

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("license_cd", jo.getString("license_cd"));
					map.put("limit_dt", (jo.containsKey("limit_dt") && !StringUtils.isEmpty(jo.getString("limit_dt"))) ? jo.getString("limit_dt") : null);
					enterpriseService.updateBusinessLicense(map);
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
	
}
