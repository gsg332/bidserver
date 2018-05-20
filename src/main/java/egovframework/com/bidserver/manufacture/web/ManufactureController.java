package egovframework.com.bidserver.manufacture.web;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.manufacture.service.ManufactureService;
import egovframework.com.cmm.message.ResultStatus;

/**
 * 제조사 관리 클래스를 정의 한다
 * 
 * @author 정진고
 ** @since 2016.03.10
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
public class ManufactureController extends CommonController {

	@Resource(name = "manufactureService")
	private ManufactureService manufactureService;

	@Autowired
	private View jSonView;

	/**
	 * 제조사관리 페이지 이동
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/manufacture/main.do")
	public String getManufactureMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/manufacture/main";
	}

	/**
	 * 제조사 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/manufactureList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View manufactureList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = manufactureService.selectManufactureList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", manufactureService.getManufactureListCnt(map));

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
	 * 제조사 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/updateManufactureList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateManufactureList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			String inserted = request.getParameter("inserted");
			String deleted = request.getParameter("deleted");
			String updated = request.getParameter("updated");

			if (deleted != null) {
//				deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", jo.getString("business_no"));
					manufactureService.deleteManufactureList(map);

				}
			}

			if (inserted != null) {
//				inserted = URLDecoder.decode(inserted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(inserted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", null);
					map.put("company_no", jo.getString("company_no"));
					map.put("company_nm", jo.getString("company_nm"));
					map.put("delegate", jo.getString("delegate"));
					map.put("delegate_explain", jo.getString("delegate_explain"));
					map.put("company_type", "");
					map.put("company_registration_day", "");
					map.put("address", jo.getString("address"));
					map.put("address_detail", jo.getString("address_detail"));
					map.put("phone_no", jo.getString("phone_no"));
					map.put("mobile_no", jo.getString("mobile_no"));
					map.put("fax_no", jo.getString("fax_no"));
					map.put("department", jo.getString("department"));
					map.put("position", jo.getString("position"));
					map.put("bidmanager", jo.getString("bidmanager"));
					map.put("email", jo.getString("email"));
					map.put("business_condition", "");
					map.put("business_condition_detail", "");
					map.put("zip_no", "");
					
					map.put("gubun", "B");
					map.put("unuse_yn", jo.getString("unuse_yn"));
					map.put("bigo", "");
					manufactureService.updateManufactureList(map);

				}
			}
			if (updated != null) {
//				updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("business_no", jo.getString("business_no"));
					map.put("company_no", jo.getString("company_no"));
					map.put("company_nm", jo.getString("company_nm"));
					map.put("delegate", jo.getString("delegate"));
					map.put("delegate_explain", jo.getString("delegate_explain"));
					map.put("company_type", "");
					map.put("company_registration_day", "");
					map.put("address", jo.getString("address"));
					map.put("address_detail", jo.getString("address_detail"));
					map.put("phone_no", jo.getString("phone_no"));
					map.put("mobile_no", jo.getString("mobile_no"));
					map.put("fax_no", jo.getString("fax_no"));
					map.put("department", jo.getString("department"));
					map.put("position", jo.getString("position"));
					map.put("bidmanager", jo.getString("bidmanager"));
					map.put("email", jo.getString("email"));
					map.put("business_condition", "");
					map.put("business_condition_detail", "");
					map.put("zip_no", "");
					map.put("gubun", "B");
					map.put("unuse_yn", jo.getString("unuse_yn"));
					map.put("bigo", "");
					manufactureService.updateManufactureList(map);

				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

			// } catch (JsonParseException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
			// } catch (JsonMappingException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
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
	 * 제조사 업종 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/companyTypeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View companyTypeList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = manufactureService.selectCompanyTypeList(map);

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
	 * 업종 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/companyTypeTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View companyTypeTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = manufactureService.selectCompanyTypeTotalList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", manufactureService.getCompanyTypeTotalCnt(map));

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
	 * 제조사 업종 정보 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/updateBizCompanyTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBizCompanyTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				// addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("cd", jo.getString("cd"));
					manufactureService.updateBizCompanyTypeList(map);

				}
			}

			// System.out.println("bidcompany"+bidcompany);
			// bidCompanyService.insertBidcompany(bidcompany);
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

			// } catch (JsonParseException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
			// } catch (JsonMappingException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
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
	 * 제조사 업종 정보 삭제
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/removeBizCompanyTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View removeBizCompanyTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("cd", jo.getString("cd"));
					manufactureService.removeBizCompanyTypeList(map);

				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

			// } catch (JsonParseException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
			// } catch (JsonMappingException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
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
	 * 제조사 물품 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/goodsTypeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsTypeList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = manufactureService.selectGoodsTypeList(map);

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
	 * 물품 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/goodsTypeTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsTypeTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = manufactureService.selectGoodsTypeTotalList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", manufactureService.getGoodsTypeTotalCnt(map));

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
	 * 제조사 물품 정보 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/updateBizGoodsTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBizGoodsTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			// manufactureService.deleteCompanyTypeList(map);

			if (map.get("selecter") != null) {
				// addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					manufactureService.updateBizGoodsTypeList(map);

				}
			}

			// System.out.println("bidcompany"+bidcompany);
			// bidCompanyService.insertBidcompany(bidcompany);
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

			// } catch (JsonParseException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
			// } catch (JsonMappingException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
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
	 * 제조사 물품 정보 삭제
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/removeBizGoodsTypeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View removeBizGoodsTypeList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					manufactureService.removeBizGoodsTypeList(map);

				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

			// } catch (JsonParseException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
			// } catch (JsonMappingException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
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
	 * 제조사 직생물품 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/goodsDirectList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsDirectList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = manufactureService.selectGoodsDirectList(map);

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
	 * 직생물품 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/goodsDirectTotalList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsDirectTotalList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = manufactureService.selectGoodsDirectTotalList(map);

			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", manufactureService.getGoodsDirectTotalCnt(map));

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
	 * 제조사 직생물품 정보 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/updateBizGoodsDirectList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBizGoodsDirectList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			// manufactureService.deleteCompanyTypeList(map);

			if (map.get("selecter") != null) {
				// addData = URLDecoder.decode(addData, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					manufactureService.updateBizGoodsDirectList(map);

				}
			}

			// System.out.println("bidcompany"+bidcompany);
			// bidCompanyService.insertBidcompany(bidcompany);
			model.addAttribute("status", ResultStatus.OK.value());
			// model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

			// } catch (JsonParseException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
			// } catch (JsonMappingException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
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
	 * 제조사 직생물품 정보 삭제
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/removeBizGoodsDirectList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View removeBizGoodsDirectList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);

			if (map.get("selecter") != null) {
				JSONArray jArr = JSONArray.fromObject(map.get("selecter"));

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					map.put("goods_no", jo.getString("goods_no"));
					manufactureService.removeBizGoodsDirectList(map);

				}
			}
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

			// } catch (JsonParseException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
			// } catch (JsonMappingException e1) {
			// // TODO Auto-generated catch block
			// e1.printStackTrace();
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
	 * 견적이력 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/getBizHisList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBizHisList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = manufactureService.selectBizHisList(map);
			

			map.put("pageNo", 0);
			map.put("rows", 1);

			List<HashMap> resultList2 = manufactureService.selectManufactureList(map);

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
	
	/**
	 * 견적보고서 이력 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/getBidReportList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidReportList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = manufactureService.selectBidReportList(map);
			
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
	 * 공공구매정보망 기업 제조물품 리스트
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/manufacture/goodsTypeList2.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View goodsTypeList2(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = manufactureService.selectGoodsTypeList2(map);

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
	 * 제조사 저장
	 * 
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/manufacture/updateManufactureBigo.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateManufactureBigo(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			HashMap map = this.bind(request);
			
			manufactureService.updateManufactureBigo(map);
			
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
	
	@RequestMapping(value = "/manufacture/downloadExcelList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void downloadExcelList(HttpServletRequest request, HttpServletResponse response, SessionStatus status, HttpSession session) throws Exception {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			map.put("pageNo", 0);
			map.put("rows", 1000000000);

			resultList = manufactureService.selectManufactureList(map);
			
			
			Date nowDate = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar today = Calendar.getInstance();
			String nowDate1 = sdf.format(nowDate);
			String modelName = "제조사 정보";

			String fileName = nowDate1 + "_manufacture" + ".xls";
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
}
