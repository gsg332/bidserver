package egovframework.com.bidserver.analysis.web;

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
import egovframework.com.bidserver.analysis.service.AnalysisService;
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
public class AnalysisController extends CommonController {

	@Resource(name = "analysisService")
	private AnalysisService analysisService;

	@Resource(name = "publicDataService")
	private PublicDataService publicDataService;

	@Autowired
	private View jSonView;

	@RequestMapping(value = "/admin/analysis/main.do")
	public String getBidNoticeNewMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/analysis/main";
	}
	
	@RequestMapping(value = "/analysis/selectKpiList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectKpiList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;
		List<HashMap> userCnt = null;

		try {
			HashMap map = this.bind(request);
			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = analysisService.selectKpiList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);

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
	
	@RequestMapping(value = "/analysis/businessBidInfoList.do", method = RequestMethod.GET)
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

			resultList = analysisService.selectBusinessBidInfoList(map);
			

			map.put("pageNo", 0);
			map.put("rows", 100000);
			List<HashMap> totResultList  = analysisService.selectBusinessBidInfoList(map);

			
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
			model.addAttribute("total", analysisService.getBusinessBidInfoListCnt(map));

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
	
	@RequestMapping(value = "/analysis/businessBidInfoDtlList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View businessBidInfoDtlList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = analysisService.selectBusinessBidInfoDtlList(map);

			HashMap areaMap = new HashMap();
			
			int eventBitCnt = analysisService.selectBusinessBidCnt(map);
			model.addAttribute("eventBidCnt", eventBitCnt);
			
			HashMap lastEventInfo = analysisService.selectLastEventInfo(map);
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			lastEventInfo.put("start_date", sdf.format(lastEventInfo.get("start_date")));
			lastEventInfo.put("end_date", sdf.format(lastEventInfo.get("end_date")));		

			model.addAttribute("lastEventInfo", lastEventInfo);

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
