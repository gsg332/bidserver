package egovframework.com.bidserver.mobile.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.mobile.service.MobileWebService;
import egovframework.com.cmm.message.ResultStatus;

@Controller("mobileWebController")
@RequestMapping("/mobileWebController.do")
public class MobileWebController extends CommonController {
	
	@Resource(name = "mobileWebService")
	private MobileWebService mobileWebService;
	
	@Autowired
	private View jSonView;

	@RequestMapping(params = "method=login")
	public void getLoginInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap map = this.bind(request);

		map.put("business_no", map.get("id").toString());
		List<HashMap> resultList = null;
		String resultCode = "";
		int ii = 0;

		try {
			resultList = mobileWebService.getLogin(map);
			
			if(resultList!=null && resultList.size() > 0){
				
				HashMap resultMap = resultList.get(0);
				
				if(map.get("pwd").equals(resultMap.get("pwd"))){
					
					String version = mobileWebService.getVersion(map);
					
					boolean isVer = true;
					if(map.get("ver")!=null){
						String sver = version.replaceAll("\\.", "");
						String pver = ((String)map.get("ver")).replaceAll("\\.", "");
						
						if(!sver.equals(pver)){
							isVer = false;
						}
					}else{
						isVer = false;
					}
					

					if(isVer){
						resultCode = "200";
					}else{
						resultCode = "700";
					}
					mobileWebService.updateRegId(map);
					
					
				}else{
					resultCode = "400";
				}
			}else{
				resultCode = "300";
			}

			if ("".equals(resultCode)) {
				resultCode = "600";
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			resultCode = "500";
		}

		System.out.println("resultCode===================>" + resultCode);
		JSONObject obj = new JSONObject();
		obj.put("resultCode", resultCode);
		obj.put("resultList", resultList);

		System.out.println(JSONObject.fromObject(obj).toString());

		response.setContentType("text/html; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(JSONObject.fromObject(obj).toString());

	}
	
	/**
	 * 입찰공고 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=getBusinessBidList")
	public View getBusinessBidList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = mobileWebService.selectBusinessBidList(map);
			
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
	 * 투찰가격 확인
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=updateChkDt")
	public View updateChkDt(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			mobileWebService.updateChkDt(map);
			
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
	 * 투찰가격 확인
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=getNotiList")
	public View getNotiList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = mobileWebService.selectNotiList(map);
			
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
	 * 입찰공고 상세
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=getBidDetailInfo1")
	public View getBidDetailInfo1(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = mobileWebService.getBidDetailInfo1(map);
			
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
