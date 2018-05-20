package egovframework.com.bidserver.project.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.main.service.FileService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.project.service.ProjectService;
import egovframework.com.bidserver.util.FileUtil;
import egovframework.com.bidserver.util.StringUtil;
import egovframework.com.cmm.message.ResultStatus;

/**
 * 프로젝트 관리 클래스를 정의 한다
 * 
 * @author 정진고
 ** @since 2016.04.12
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * 
 * </pre>
 */
@Controller
public class ProjectController extends CommonController {

	
	@Autowired private FileSystemResource fsResource;
	
	@Resource(name = "projectService")
	private ProjectService projectService;

	@Resource(name = "fileService")
	private FileService fileService;

	@Autowired
	private View jSonView;
	

	/**
	 * 프로젝트 관리 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/project/main.do")
	public String getProjectMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/project/main";
	}
	
	/**
	 * 프로젝트 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project/projectList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View projectList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;
		List<HashMap> footerList = new ArrayList();

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = projectService.selectProjectList(map);
			
			for(int i=0;i<resultList.size();i++){
				
				HashMap paramMap = new HashMap();
				
				paramMap.put("project_id", resultList.get(i).get("project_id"));
				
				List<HashMap> resultDtlList = projectService.selectProjectDtlList(paramMap);
				
				String value = "";
				
				for(int j=0;j<resultDtlList.size();j++){
					
					if(value.length()>0){
						value+=",";
					}
					value +=resultDtlList.get(j).get("make_company_nm");
				}
				
				resultList.get(i).put("makeList", value);
				

				String date[] = {
						String.valueOf(resultList.get(i).get("day1")),
						String.valueOf(resultList.get(i).get("day2")),
						String.valueOf(resultList.get(i).get("day3")),
						String.valueOf(resultList.get(i).get("day4")),
						String.valueOf(resultList.get(i).get("day5")),
						String.valueOf(resultList.get(i).get("day6")),
						String.valueOf(resultList.get(i).get("day7")),
						String.valueOf(resultList.get(i).get("day8"))
				};
				
				String str[] = {"1","2","3","4","5","6","7","8"};
				
				int base = 0;                                         // String타입 str의 기준값을 int 형으로 받을 변수 설정

				  int target = 0;                                       // String타입 str의 비교값을 int 형으로 받을 변수 설정

				  String strTemp = "";                                  // 내림차순이기에, 기준값과 비교값을 비교하고나서 제일 큰값을 받을 임시값 설정
				  String strTempPosition = "";                                  // 내림차순이기에, 기준값과 비교값을 비교하고나서 제일 큰값을 받을 임시값 설정

				  

				  for(int k=0; k<str.length; k++){      

				   base = Integer.parseInt(date[k]==null || date[k].equals("")?"111111111":date[k]);                  // Integer.parseInt()를 써줘서 String형을 int형으로 전환시켜준다!!! 

				   for(int j=k; j<str.length; j++){  

				    target = Integer.parseInt(date[j]==null || date[j].equals("")?"111111111":date[j]);            // Integer.parseInt()를 써서 String형의 str값을 int형의 값으로 전환해서 target에 삽입!! 

				    if(base>target){

				     strTemp = date[k];
				     strTempPosition = str[k];

				     date[k] = date[j];
				     str[k] = str[j];

				     date[j] = strTemp;
				     str[j] = strTempPosition;

				    }

				   }
				  }
				  
				  resultList.get(i).put("date1", resultList.get(i).get("day"+str[0]));
				  resultList.get(i).put("date2", resultList.get(i).get("day"+str[1]));
				  resultList.get(i).put("date3", resultList.get(i).get("day"+str[2]));
				  resultList.get(i).put("date4", resultList.get(i).get("day"+str[3]));
				  resultList.get(i).put("date5", resultList.get(i).get("day"+str[4]));
				  resultList.get(i).put("date6", resultList.get(i).get("day"+str[5]));
				  resultList.get(i).put("date7", resultList.get(i).get("day"+str[6]));
				  resultList.get(i).put("date8", resultList.get(i).get("day"+str[7]));
				  resultList.get(i).put("re1", resultList.get(i).get("note"+str[0]));
				  resultList.get(i).put("re2", resultList.get(i).get("note"+str[1]));
				  resultList.get(i).put("re3", resultList.get(i).get("note"+str[2]));
				  resultList.get(i).put("re4", resultList.get(i).get("note"+str[3]));
				  resultList.get(i).put("re5", resultList.get(i).get("note"+str[4]));
				  resultList.get(i).put("re6", resultList.get(i).get("note"+str[5]));
				  resultList.get(i).put("re7", resultList.get(i).get("note"+str[6]));
				  resultList.get(i).put("re8", resultList.get(i).get("note"+str[7]));
			}
			
			map.put("pageNo", 0);
			map.put("rows", 100000);
			List<HashMap> totResultList  = projectService.selectProjectList(map);
			
			float totalValue1 = 0;
			float totalValue2 = 0;
			float totalValue3 = 0;
			float totalValue4 = 0;
			float totalValue5 = 0;
			float avgValue1=0;
			float avgValue2=0;
			float avgValue3=0;
			float avgValue4=0;
			float avgValue5=0;
			
			int thisCo = 0;
			int orderCo = 0;
			
			
			for(int i=0;i<totResultList.size();i++){
				
				String value;
				
				if(totResultList.get(i).get("cont_price")!=null){
					value = String.valueOf(totResultList.get(i).get("cont_price"));
					if(value!=null && value.length()>0){
						totalValue1 += Float.parseFloat(value);
					}
				}
				
				if(totResultList.get(i).get("dist_price")!=null){
					value = String.valueOf(totResultList.get(i).get("dist_price"));
					if(value!=null && value.length()>0){
						totalValue2 += Float.parseFloat(value);
					}
				}

				if(totResultList.get(i).get("make_price")!=null){
					value = String.valueOf(totResultList.get(i).get("make_price"));
					if(value!=null && value.length()>0){
						totalValue3 += Float.parseFloat(value);
					}
				}
				if(totResultList.get(i).get("dist_margin")!=null){
					value = String.valueOf(totResultList.get(i).get("dist_margin"));
					if(value!=null && value.length()>0){
						totalValue4 += Float.parseFloat(value);
					}
				}
				if(totResultList.get(i).get("cont_margin")!=null){
					value = String.valueOf(totResultList.get(i).get("cont_margin"));
					if(value!=null && value.length()>0){
						totalValue5 += Float.parseFloat(value);
					}
				}
				
				if(totResultList.get(i).get("cont_company_nm")!=null){
					if(totResultList.get(i).get("cont_company_nm").equals("인콘")){
						thisCo++;
					}else{
						orderCo++;
					}
				}else{
					orderCo++;
				}

			}
			
			HashMap itemMap = new HashMap();
			itemMap.put("demand_nm", "Average");
			
			if(totResultList.size()==0){
				avgValue1 = 0;
				avgValue2 = 0;
				avgValue3 = 0;
				avgValue4 = 0;
				avgValue5 = 0;
			}else{
				avgValue1 = totalValue1/totResultList.size();
				avgValue2 = totalValue2/totResultList.size();
				avgValue3 = totalValue3/totResultList.size();
				avgValue4 = totalValue4/totResultList.size();
				avgValue5 = totalValue5/totResultList.size();
			}
			itemMap.put("cont_price", avgValue1);
			itemMap.put("dist_price", avgValue2);
			itemMap.put("make_price", avgValue3);
    		DecimalFormat df = new DecimalFormat("0.00");
			itemMap.put("dist_margin", df.format(avgValue4));
			itemMap.put("cont_margin", df.format(avgValue5));
			
			footerList.add(itemMap);

			itemMap = new HashMap();
			itemMap.put("demand_nm", "Total");
			itemMap.put("cont_company_nm", "인콘("+thisCo+")<br/>협력사("+orderCo+")");
			itemMap.put("cont_price", totalValue1);
			itemMap.put("dist_price", totalValue2);
			itemMap.put("make_price", totalValue3);
//			itemMap.put("dist_margin", totalValue4);
//			itemMap.put("cont_margin", totalValue5);
			
			footerList.add(itemMap);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", projectService.getProjectListCnt(map));

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
	 * 프로젝트 제소업체 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project/projectDtlList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View projectDtlList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = projectService.selectProjectDtlList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", projectService.getProjectListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
			model.addAttribute("schedule", projectService.selectProjectScheduleList(map));
			model.addAttribute("tax", projectService.selectProjectTaxList(map));
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 프로젝트 제소업체 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project/getUserProjectScheduleList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View getUserProjectScheduleList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			resultList = projectService.getUserProjectScheduleList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", projectService.getProjectListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
			model.addAttribute("schedule", projectService.selectProjectScheduleList(map));
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	
	/**
	 * 프로젝트 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/project/updateProjectList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateProjectList(MultipartHttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap paramMap = this.bindEncoding(request,"utf-8");
			
			
			
			int key = 0;
			if(paramMap.get("project_id")!=null && String.valueOf(paramMap.get("project_id")).length()>0){
				projectService.updateProjectList(paramMap);
				
				key = Integer.parseInt(String.valueOf(paramMap.get("project_id")));
			}else{
				projectService.insertProjectList(paramMap);
				
				key = (Integer)paramMap.get("project_id");
			}
			
			//이전 목록 불러오기
			List<HashMap> beforeList = null;
			HashMap beforeMap = new HashMap();
			beforeMap.put("project_id", key);
			beforeList = projectService.selectProjectList2(beforeMap);
			
			String fileId1 = null;
			String fileId2 = null;
			String fileId3 = null;
			String fileId4 = null;
			String fileId5 = null;
			
			HashMap fileMap = new HashMap();
			fileMap.put("project_id", key);

			if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()>0){
				if(request.getFile("file1")==null || request.getFile("file1").getBytes().length==0){
					fileMap.put("file_id1", (String)beforeList.get(0).get("file_id1"));
				}else{
					fileId1 = uploadFile1(request.getFile("file1"), "project/"+key+"/", URLDecoder.decode(request.getParameter("file_id1"), "UTF-8"));
					fileMap.put("file_id1", fileId1);
				}
			}else{
				fileMap.put("file_id1", fileId1);
			}
			if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()>0){
				if(request.getFile("file2")==null || request.getFile("file2").getBytes().length==0){
					fileMap.put("file_id2", (String)beforeList.get(0).get("file_id2"));
				}else{
					fileId2 = uploadFile1(request.getFile("file2"), "project/"+key+"/", URLDecoder.decode(request.getParameter("file_id2"), "UTF-8"));
					fileMap.put("file_id2", fileId2);
				}
			}else{
				fileMap.put("file_id2", fileId2);
			}
			if(URLDecoder.decode(request.getParameter("file_id3"), "UTF-8").length()>0){
				if(request.getFile("file3")==null || request.getFile("file3").getBytes().length==0){
					fileMap.put("file_id3", (String)beforeList.get(0).get("file_id3"));
				}else{
					fileId3 = uploadFile1(request.getFile("file3"), "project/"+key+"/", URLDecoder.decode(request.getParameter("file_id3"), "UTF-8"));
					fileMap.put("file_id3", fileId3);
				}
			}else{
				fileMap.put("file_id3", fileId3);
			}
			if(URLDecoder.decode(request.getParameter("file_id4"), "UTF-8").length()>0){
				if(request.getFile("file4")==null || request.getFile("file4").getBytes().length==0){
					fileMap.put("file_id4", (String)beforeList.get(0).get("file_id4"));
				}else{
					fileId4 = uploadFile1(request.getFile("file4"), "project/"+key+"/", URLDecoder.decode(request.getParameter("file_id4"), "UTF-8"));
					fileMap.put("file_id4", fileId4);
				}
			}else{
				fileMap.put("file_id4", fileId4);
			}
			if(URLDecoder.decode(request.getParameter("file_id5"), "UTF-8").length()>0){
				if(request.getFile("file5")==null || request.getFile("file5").getBytes().length==0){
					fileMap.put("file_id5", (String)beforeList.get(0).get("file_id5"));
				}else{
					fileId4 = uploadFile1(request.getFile("file5"), "project/"+key+"/", URLDecoder.decode(request.getParameter("file_id5"), "UTF-8"));
					fileMap.put("file_id5", fileId5);
				}
			}else{
				fileMap.put("file_id5", fileId5);
			}
			
			projectService.updateProjectFileList(fileMap);
			
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
			if(fileId5!=null){
				removeFile((String)beforeList.get(0).get("file_id5"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id5"), "UTF-8").length()==0){
					removeFile((String)beforeList.get(0).get("file_id5"));
				}
			}
			
			
			String deleted = request.getParameter("deleted1");
			String updated = request.getParameter("updated1");
			String inserted = request.getParameter("inserted1");

			if (deleted != null) {
				deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", jo.getString("project_id"));
					map.put("project_dtl_id", jo.getString("project_dtl_id"));
					
					projectService.deleteProjectDtlList(map);

				}
			}

			if (updated != null) {
				updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", jo.getString("project_id"));
					map.put("project_dtl_id", jo.getString("project_dtl_id"));
					map.put("make_company_nm", jo.getString("make_company_nm"));
					map.put("make_price", jo.getString("make_price"));
					map.put("make_user_nm", jo.getString("make_user_nm"));
					map.put("make_tel", jo.getString("make_tel"));
					map.put("make_bigo", jo.getString("make_bigo"));
					projectService.updateProjectDtlList(map);

				}
			}
			
			if (inserted != null) {
				inserted = URLDecoder.decode(inserted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(inserted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", key);
					map.put("make_company_nm", jo.getString("make_company_nm"));
					map.put("make_price", jo.getString("make_price"));
					map.put("make_user_nm", jo.getString("make_user_nm"));
					map.put("make_tel", jo.getString("make_tel"));
					map.put("make_bigo", jo.getString("make_bigo"));
					projectService.insertProjectDtlList(map);

				}
			}
			

			deleted = request.getParameter("deleted2");
			updated = request.getParameter("updated2");
			inserted = request.getParameter("inserted2");

			if (deleted != null) {
				deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", jo.getString("project_id"));
					map.put("schedule_id", jo.getString("schedule_id"));
					
					projectService.deleteProjectScheduleList(map);

				}
			}

			if (updated != null) {
				updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", jo.getString("project_id"));
					map.put("schedule_id", jo.getString("schedule_id"));
					map.put("project_start_dt", jo.getString("project_start_dt"));
					map.put("project_end_dt", jo.getString("project_end_dt"));
					map.put("alarm", jo.getString("alarm"));
					map.put("bigo", jo.getString("bigo"));
					projectService.updateProjectScheduleList(map);

				}
			}
			
			if (inserted != null) {
				inserted = URLDecoder.decode(inserted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(inserted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", key);
					map.put("project_start_dt", jo.getString("project_start_dt").replaceAll("-", ""));
					map.put("project_end_dt", jo.getString("project_end_dt").replaceAll("-", ""));
					map.put("alarm", jo.getString("alarm"));
					map.put("bigo", jo.getString("bigo"));
					projectService.insertProjectScheduleList(map);

				}
			}

			

			deleted = request.getParameter("deleted3");
			updated = request.getParameter("updated3");
			inserted = request.getParameter("inserted3");

			if (deleted != null) {
				deleted = URLDecoder.decode(deleted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(deleted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", jo.getString("project_id"));
					map.put("tax_id", jo.getString("tax_id"));
					
					projectService.deleteProjectTaxList(map);

				}
			}

			if (updated != null) {
				updated = URLDecoder.decode(updated, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(updated);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", jo.getString("project_id"));
					map.put("tax_id", jo.getString("tax_id"));
					map.put("tax_dt", jo.getString("tax_dt"));
					map.put("sales", jo.getString("sales"));
					map.put("purchase", jo.getString("purchase"));
					projectService.updateProjectTaxList(map);

				}
			}
			
			if (inserted != null) {
				inserted = URLDecoder.decode(inserted, "UTF-8");
				JSONArray jArr = JSONArray.fromObject(inserted);

				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jo = jArr.getJSONObject(i);
					HashMap map = new HashMap();
					map.put("project_id", key);
					map.put("tax_dt", jo.getString("tax_dt"));
					map.put("sales", jo.getString("sales"));
					map.put("purchase", jo.getString("purchase"));
					projectService.insertProjectTaxList(map);

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
	 * 프로젝트 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/project/deleteProjectList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteProjectList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {

			
			HashMap paramMap = this.bind(request);
			
			projectService.deleteProjectList(paramMap);
			projectService.deleteProjectDtlAll(paramMap);
			projectService.deleteProjectScheduleAll(paramMap);

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
	 * 프로젝트 진행현황 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project/projectScheduleList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View projectScheduleList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = projectService.selectProjectScheduleList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", projectService.getProjectListCnt(map));
			
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
	 * 프로젝트 진행현황 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project/projectTaxList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View projectTaxList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = projectService.selectProjectTaxList(map);
			
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

    public Object uploadFile(MultipartHttpServletRequest request) {
        Iterator<String> itr =  request.getFileNames();
        
        
        int i=1;
//        while(itr.hasNext()) {
            MultipartFile mpf = request.getFile("file1");
            System.out.println(mpf.getOriginalFilename() +" uploaded!");
            try {
            	String fileNm = URLDecoder.decode(request.getParameter("file_id"+i), "UTF-8");
            	i++;
                //just temporary save file info into ufile
                System.out.println("file length : " + mpf.getBytes().length);
                System.out.println("file name : " + fileNm);
                
                try {

                	File dir = new File(fsResource.getPath());  // 폴더경로지정
                	
                	if(!dir.isDirectory()){
                		dir.mkdirs();
                	}
                	
                    File outFileName = new File(fsResource.getPath() + fileNm);

                    FileOutputStream fileoutputStream = new FileOutputStream(outFileName);

                    fileoutputStream.write(mpf.getBytes());

                    fileoutputStream.close();

               } catch (IOException ie) {

                    System.err.println("File writing error! ");

               }

            } catch (IOException e) {
                System.out.println(e.getMessage());
                e.printStackTrace();
            }
//        }
        return true;
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
	 * 프로젝트 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project/projectList3.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View projectList3(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;
		List<HashMap> footerList = new ArrayList();

		try {
			HashMap map = this.bind(request);

			resultList = projectService.selectProjectList3(map);
			
			
			
			double totalPSum[] = new double[13];
			double totalMSum[] = new double[13];
			
			
			for(int i=0;i<resultList.size();i++){
				String value;
				
				for(int j=1;j<13;j++){
					if(resultList.get(i).get("p"+j)!=null){
						value = String.valueOf(resultList.get(i).get("p"+j));
						if(value!=null && value.length()>0){
							totalPSum[j-1] += Double.parseDouble(value);
						}
					}
					if(resultList.get(i).get("m"+j)!=null){
						value = String.valueOf(resultList.get(i).get("m"+j));
						if(value!=null && value.length()>0){
							totalMSum[j-1] += Double.parseDouble(value);
						}
					}
				}
				double tp = 0, tm = 0;
				if(resultList.get(i).get("pt")!=null){
					value = String.valueOf(resultList.get(i).get("pt"));
					if(value!=null && value.length()>0){
						totalPSum[12] += Double.parseDouble(value);
						
						tp = Double.parseDouble(value);
					}
				}
				if(resultList.get(i).get("mt")!=null){
					value = String.valueOf(resultList.get(i).get("mt"));
					if(value!=null && value.length()>0){
						totalMSum[12] += Double.parseDouble(value);
						
						tm = Double.parseDouble(value);
					}
				}
				resultList.get(i).put("per", Math.floor((tp!=0?(tp - tm) / tp:0)*1000)/10);

			}
			
			HashMap itemMap = new HashMap();
			itemMap.put("bid_notice_nm", "매출총액<br/>매입총액");
			
			for(int j=1;j<13;j++){
				itemMap.put("p"+j, totalPSum[j-1]);
				itemMap.put("m"+j, totalMSum[j-1]);
			}
			itemMap.put("pt", totalPSum[12]);
			itemMap.put("mt", totalMSum[12]);
			
			
			
//    		DecimalFormat df = new DecimalFormat("0.00");
//			itemMap.put("dist_margin", df.format(avgValue4));
//			itemMap.put("cont_margin", df.format(avgValue5));
//			
//			itemMap = new HashMap();
//			itemMap.put("demand_nm", "Total");
//			itemMap.put("cont_company_nm", "인콘("+thisCo+")<br/>협력사("+orderCo+")");
//			itemMap.put("cont_price", totalValue1);
//			itemMap.put("dist_price", totalValue2);
//			itemMap.put("make_price", totalValue3);
//			itemMap.put("dist_margin", totalValue4);
//			itemMap.put("cont_margin", totalValue5);
			
			footerList.add(itemMap);
			
			itemMap = new HashMap();
			itemMap.put("bid_notice_nm", "매출원가");
			
			for(int j=1;j<13;j++){
				itemMap.put("pm"+j, totalPSum[j-1]-totalMSum[j-1]);
			}
			itemMap.put("pmt", totalPSum[12]-totalMSum[12]);
			footerList.add(itemMap);

			itemMap = new HashMap();
			itemMap.put("bid_notice_nm", "원가율");
			
			for(int j=1;j<13;j++){
				itemMap.put("pm"+j, Math.floor((totalPSum[j-1]!=0?(totalPSum[j-1]-totalMSum[j-1])/totalPSum[j-1]:0)*1000)/10);
			}
			itemMap.put("pmt", Math.floor((totalPSum[12]!=0?(totalPSum[12]-totalMSum[12])/totalPSum[12]:0)*1000)/10);
			footerList.add(itemMap);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
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
	 * 년도 리스트 조회
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/project/yearList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public void yearList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HashMap map = this.bind(request);
		List<HashMap> resultList = null;
		
		List returnList = new ArrayList<HashMap>();
		
		HashMap itemMap = new HashMap();

		Calendar cal = Calendar.getInstance();
		
		int year = cal.get(cal.YEAR);

		
		for(int i=year; i>=2015;i--){
			itemMap = new HashMap();
			itemMap.put("year", i);
			returnList.add(itemMap);
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

}
