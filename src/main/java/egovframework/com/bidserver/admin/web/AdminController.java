package egovframework.com.bidserver.admin.web;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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

import egovframework.com.bidserver.admin.service.AdminService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.schedule.service.PublicDataService;
import egovframework.com.cmm.message.ResultStatus;

/**
 * 관리자 클래스를 정의 한다
 * 
 * @author 정진고
 ** @since 2016.04.25
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2016.04.25  정진고          최초 생성
 * 
 * </pre>
 */
@Controller
public class AdminController extends CommonController{

	@Resource(name = "adminService")
	private AdminService adminService;
	
	@Autowired(required=true)
	private PublicDataService publicDataService;
	
	@Autowired
	private View jSonView;
	

	/**
	 * 사용자관리 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/admin/userMain.do")
	public String userMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/admin/userMain";
	}
	
	/**
	 * 코드관리 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/admin/codeMain.do")
	public String codeMainPage(HttpServletRequest request, ModelMap model) throws Exception {
		
		return "/admin/admin/codeMain";
	}
	
	/**
	 * 사용자 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user/selectUserList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectUserList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = adminService.selectUserList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", adminService.getUserListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	/**
	 * 사용자 등록
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/user/updateUserList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateUserList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			int isRole = adminService.chkUserRole(map);
			
			if(isRole >0){
				model.addAttribute("status", "101");
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}else{
				if(map.get("type").equals("I")){
					adminService.insertUserList(map);
					
					model.addAttribute("status", ResultStatus.OK.value());
					model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
				}else if(map.get("type").equals("U")){
					int isUser = adminService.isUser(map);
					
					if(isUser>0){
						adminService.updateUserList(map);
						
						model.addAttribute("status", ResultStatus.OK.value());
						model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
					}else{
						model.addAttribute("status", "100");
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
	

	/**
	 * 아이디 확인
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user/chkUserId.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View chkUserId(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int result = adminService.chkUserId(map);
			
			if(result!=0){
				model.addAttribute("status", "100");
				model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			}else{
				model.addAttribute("status", "200");
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	/**
	 * 비밀번호 변경
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user/chgUserPwd.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View chgUserPwd(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			map.put("pwd", map.get("oldPwd"));
			
			int isUser = adminService.isUser(map);
			
			if(isUser>0){
				int result = adminService.chgUserPwd(map);
				
				if(result==1){
					model.addAttribute("status", "200");
					model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
				}else{
					model.addAttribute("status", "100");
					model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
				}
			}else{
				model.addAttribute("status", "100");
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}
			
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		
		return jSonView;
	}
	
	/**
	 * 사용자 등록
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/user/deleteUserList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteUserList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			adminService.deleteUserList(map);
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
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
	
	
	/**
	 * 공통코드 그룹리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/code/selectCodeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectCodeList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = adminService.selectCodeList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", adminService.getCodeListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	
	/**
	 * 공통코드 그룹리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/code/selectCodeSubList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectCodeSubList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = adminService.selectCodeSubList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	/**
	 * 적격심사정보 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/code/selectEvalList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectEvalList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = adminService.selectEvalList(map);
			
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
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/code/updateEvalList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateEvalList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			// request.setCharacterEncoding("UTF-8");

			String updated = request.getParameter("updated");

			if (updated != null) {
//				updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("eval_id", jo.getString("eval_id"));
					map.put("val", jo.getString("val"));
					adminService.updateEvalList(map);

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
	 * 공통코드 그룹 수정
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/code/updateCodeGrp.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateCodeGrp(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			if(map.get("type").equals("I")){
				adminService.insertCodeGrp(map);
				
				model.addAttribute("status", ResultStatus.OK.value());
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}else if(map.get("type").equals("U")){
				adminService.updateCodeGrp(map);
				
				model.addAttribute("status", ResultStatus.OK.value());
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}else if(map.get("type").equals("D")){
				adminService.deleteCodeGrp(map);
				adminService.deleteCodeSubAll(map);
				
				model.addAttribute("status", ResultStatus.OK.value());
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
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
	
	/**
	 * 공통코드 상세 코드 수정
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/code/updateCodeSub.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateCodeSub(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			if(map.get("type").equals("I")){
				adminService.insertCodeSub(map);
				
				model.addAttribute("status", ResultStatus.OK.value());
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}else if(map.get("type").equals("U")){
				adminService.updateCodeSub(map);
				
				model.addAttribute("status", ResultStatus.OK.value());
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}else if(map.get("type").equals("D")){
				adminService.deleteCodeSub(map);
				
				model.addAttribute("status", ResultStatus.OK.value());
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
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
	
	/**
	 * 공통코드 중복 확인
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/code/chkCodeGrp.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View chkCodeGrp(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int result = adminService.chkCodeGrp(map);
			
			if(result!=0){
				model.addAttribute("status", "100");
				model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			}else{
				model.addAttribute("status", "200");
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	/**
	 * 코드 상세 중복 확인
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/code/chkCodeSub.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View chkCodeSub(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int result = adminService.chkCodeSub(map);
			
			if(result!=0){
				model.addAttribute("status", "100");
				model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			}else{
				model.addAttribute("status", "200");
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	

	/**
	 * 물품목록 가져오기
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/code/getBidGoodsInfoApi.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getBidGoodsInfoApi(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);
			
			for(int i=1; i<10;i++){
				HashMap paramMap = new HashMap();
				/*
				paramMap.put("cate_name", "");
				paramMap.put("cate_id", String.valueOf(i));
				paramMap.put("numOfRows", "10000");
				paramMap.put("pageNo", "1");
				*/
				
				paramMap.put("krnPrdctNm", "");
				paramMap.put("dtilPrdctClsfcNo", String.valueOf(i));
				paramMap.put("numOfRows", "10000");
				paramMap.put("pageNo", "1");
				
				publicDataService.getData2(ThngListInfoService, getThngPrdnmLocplcAccotListInfoInfoPrdlstSearch , paramMap);
			}
			
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
	 * 업종코드  리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/code/selectBizTypeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectBizTypeList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = adminService.selectBizTypeList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
}
