   package egovframework.com.bidserver.main.web;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.bidserver.main.service.CmmnUtilService;
import egovframework.com.bidserver.sever.company.bidCompany.entity.Bidcompany;
import egovframework.com.bidserver.sever.company.bidCompany.service.BidCompanyService;
import egovframework.com.bidserver.sever.company.manufactureCompany.service.ManufactureCompanyService;
import egovframework.com.cmm.message.ResultStatus;



@Controller
public class MainController {

	@Resource(name="cmmnUtilService")
	private CmmnUtilService cmmnUtilService;
	@Resource(name="bidCompanyService")
	private BidCompanyService bidCompanyService;
	
	@Resource(name="manufactureCompanyService")
	private ManufactureCompanyService manufactureCompanyService;
		

	@Autowired
	private View jSonView;
	
	@RequestMapping(value = "/admin/manufactureCompany/main.do")	
	public String getManufactureCompanyMainPage(HttpServletRequest request, ModelMap model)
	throws Exception{
		return "/admin/manufactureCompany/main";
	}
	
	@RequestMapping(value = "/admin/bidcompany/main.do")	
	public String getBidcompanyMainPage(HttpServletRequest request, ModelMap model)
			throws Exception{
		
		
		if("A".equals(request.getParameter("GUBUN"))){
			
		request.setAttribute("gubun_name","투찰"); 
		
			
		}
		if("B".equals(request.getParameter("GUBUN"))){
			request.setAttribute("gubun_name","제조"); 
			
		}
		return "/admin/bidcompany/main";
	}
	
	
	
	
	@RequestMapping(value="/admin/bidcompany/bidCompanyList.do", method=RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidcompany(HttpServletRequest request,Model model) {
		
		List<HashMap> resultList = null;
		try {
			
			Map<String, Object> map = new HashMap<String, Object>();
			String gubun="A";
			if(null==request.getParameter("GUBUN"))  gubun="A";
			else gubun=request.getParameter("GUBUN");
			map.put("gubun",  gubun   );
			
			resultList = bidCompanyService.selectBidcompany(map);
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", 100);
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows",resultList );
		} catch(Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}
	
	@RequestMapping(value="/admin/bidcompany/bidcompanyWrite.do", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View bidcompanyWrite(HttpServletRequest request,Model model, Map<String,Object> data) {
		
	 	
	  	try {
	 		
	 		String addData = request.getParameter("addData");
	 		
			addData=URLDecoder.decode(addData, "UTF-8");
		 
	 	
	 
	 	JSONObject  jo = JSONObject.fromObject(addData); 
		
	 
		
		ObjectMapper mapper = new ObjectMapper();
	 
		Map<String, Object> map = new HashMap<String, Object>();
		

		// convert JSON string to Map
		String sendQuery = "";
		 sendQuery = " insert into  bidcompany (business_no,company_nm,delegate,delegate_explain,company_type,company_registration_day"
		 		+ ",address,address_detail,phone_no, "
				 +" mobile_no,fax_no,department,position,bidmanager,email,business_condition,business_condition_detail,zip_no,gubun) "
				 +" values ('"+jo.get("business_no")+"','"+jo.get("company_nm")+"','"+jo.get("delegate")+"','"+jo.get("delegate_explain")+
				 "','"+jo.get("company_type")+"',curdate(),'"+jo.get("address")+"','"+jo.get("address_detail")+"','"+jo.get("phone_no")+"','"+jo.get("mobile_no")+"','"+jo.get("fax_no")+"','"+
				 jo.get("department")+"','"+jo.get("position")+"','"+jo.get("bidmanager")+"','"+jo.get("email")+"','"+jo.get("business_condition")+"','"+jo.get("business_condition_detail")+"','"+jo.get("zip_no")+"')";
 		 
	 
				  
		map.put("sendQuery", sendQuery);
		//map.put("query","bopMaster.insert");
		  		bidCompanyService.update(map);
		 
	  		
			
			
			map = mapper.readValue(addData, new TypeReference<Map<String, String>>(){});
		
		
			//System.out.println(map);
			

	  		//System.out.println("bidcompany"+bidcompany);
			//	bidCompanyService.insertBidcompany(bidcompany);
				model.addAttribute("resultCode", ResultStatus.OK.value());
			//	model.addAttribute("total", 100);
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		
		
		} catch (JsonParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JsonMappingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}	  catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 	
	 
 	 
		return jSonView;
	}
	
	
	
	
	@RequestMapping(value="/admin/bidcompany/bidcompanyUpdate.do", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View bidcompanyUpdate(HttpServletRequest request,Model model, Map<String,Object> data) {
	  	try {
	 		
	//	request.setCharacterEncoding("UTF-8");
		
		
	    String GUBUN = request.getParameter("GUBUN");
		String deleted = request.getParameter("deleted");
		String inserted = request.getParameter("inserted");
		String updated = request.getParameter("updated");
		Map<String, Object> map = new HashMap<String, Object>();
		 
		if(deleted != null){
			deleted=URLDecoder.decode(deleted, "UTF-8");
		 	JSONArray  jArr = JSONArray.fromObject(deleted); 
		 	//JSONArray jArr =   JSONArray.fromObject(jo.get(""));
		 
	 
		 	for(int i = 0; i < jArr.size(); i++){ 
		    	JSONObject jo=jArr.getJSONObject(i);
		 		if("".equals(jo.get("ID"))) jo.put("ID",UUID.randomUUID().toString().replace("-",""));
		 		String sendQuery = "";
		 		   sendQuery = " DELETE FROM  bidcompany  WHERE ID='"+jo.getString("ORG_ID")+"'";
			 	map.put("sendQuery", sendQuery);
				bidCompanyService.update(map);
				 
		 	}
	 	 }

		if(inserted != null){
			inserted=URLDecoder.decode(inserted, "UTF-8");
			
			JSONArray  jArr = JSONArray.fromObject(inserted); 
		 	//JSONArray jArr =   JSONArray.fromObject(jo.get(""));
		 
	 
		 	for(int i = 0; i < jArr.size(); i++){ 
		    	JSONObject jo=jArr.getJSONObject(i);
		 		if("".equals(jo.get("ID"))) jo.put("ID",UUID.randomUUID().toString().replace("-",""));
		 		String sendQuery = "";
				 sendQuery = " insert into  bidcompany (id,password,business_no,company_nm,delegate,delegate_explain,company_type,company_registration_day"
				 		+ ",address,address_detail,phone_no, "
						 +" mobile_no,fax_no,department,position,bidmanager,email,business_condition,business_condition_detail,zip_no,gubun) "
						 +" values ('"+jo.get("id")+"','"+jo.get("password")+"','"+jo.get("business_no")+"','"+jo.get("company_nm")+"','"+jo.get("delegate")+"','"+jo.get("delegate_explain")+
						 "','"+jo.get("company_type")+"',curdate(),'"+jo.get("address")+"','"+jo.get("address_detail")+"','"+jo.get("phone_no")+"','"+jo.get("mobile_no")+"','"+jo.get("fax_no")+"','"+
						 jo.get("department")+"','"+jo.get("position")+"','"+jo.get("bidmanager")+"','"+jo.get("email")+"','"+jo.get("business_condition")+"','"+jo.get("business_condition_detail")+"','"+jo.get("zip_no")+"','"+GUBUN+"')";
		 		 
			 	map.put("sendQuery", sendQuery);
				bidCompanyService.update(map);
				 
		 	}
			 
		}

		if(updated != null){
			updated=URLDecoder.decode(updated, "UTF-8");
			JSONArray  jArr = JSONArray.fromObject(updated); 
		 	//JSONArray jArr =   JSONArray.fromObject(jo.get(""));
		 
	 
		 	for(int i = 0; i < jArr.size(); i++){ 
		    	JSONObject jo=jArr.getJSONObject(i);
		 		if("".equals(jo.get("ID"))) jo.put("ID",UUID.randomUUID().toString().replace("-",""));
		 		String sendQuery = "";
				 sendQuery = " update bidcompany set password='"+jo.get("password")+"',business_no='"+jo.get("business_no")+"',company_nm='"
		 		+jo.get("company_nm")+"',delegate='"+jo.get("delegate")+"',delegate_explain='"+jo.get("delegate_explain")+"',company_type='"+jo.get("company_type")+"',company_registration_day=curdate()"
				 		+ ",address='"+jo.get("address")+"',address_detail='"+jo.get("address_detail")+"',phone_no='"+jo.get("phone_no")+"', "
						 +" mobile_no='"+jo.get("mobile_no")+"',fax_no='"+jo.get("fax_no")+"',department='"+jo.get("department")+"',position='"
				 		+jo.get("position")+"',bidmanager='"+jo.get("bidmanager")+"',email='"+jo.get("email")+"',business_condition='"
						 +jo.get("business_condition")+"',business_condition_detail='"+jo.get("business_condition_detail")+"',zip_no='"
				 		+jo.get("zip_no")+"' where id='"+jo.get("org_id")+"' ";
						 
			 	map.put("sendQuery", sendQuery);
				bidCompanyService.update(map);
				 
		 	}
			
			
			
			
			
			
			
		}
		
	 		

	  		//System.out.println("bidcompany"+bidcompany);
			//	bidCompanyService.insertBidcompany(bidcompany);
				model.addAttribute("status", ResultStatus.OK.value());
			//	model.addAttribute("total", 100);
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		
		
		} catch (JsonParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JsonMappingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}	  catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 	
		
		
		
		return jSonView;

		
		
		
		
		
	}
	
	@RequestMapping(value="/admin/bidcompany/bidcompanyDelete.do", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View bidcompanyDelete(HttpServletRequest request,Model model, Map<String,Object> data) {
		
		Bidcompany bidcompany = null;
		
	  	try {
	 		
	 		String addData = request.getParameter("addData");
	 		
			addData=URLDecoder.decode(addData, "UTF-8");
		 
	 	
	 
			JSONArray  jArr = JSONArray.fromObject(addData); 
	 	//JSONArray jArr =   JSONArray.fromObject(jo.get(""));
	 
 
	 	for(int i = 0; i < jArr.size(); i++){ 
	 		
	 		JSONObject jdata=jArr.getJSONObject(i);
	 		
			ObjectMapper mapper = new ObjectMapper();
		 
			Map<String, Object> map = new HashMap<String, Object>();
		
	 		
	 		 String sendQuery = " DELETE FROM  bidcompany  WHERE ID='"+jdata.getString("ID")+"'";
	 		map.put("sendQuery", sendQuery);
			//map.put("query","bopMaster.insert");
			 bidCompanyService.update(map);
			 
	  		
     } 


	 		//	map = mapper.readValue(addData, new TypeReference<Map<String, String>>(){});
	 		//System.out.println(map);
 	  		//System.out.println("bidcompany"+bidcompany);
			//	bidCompanyService.insertBidcompany(bidcompany);
				model.addAttribute("resultCode", ResultStatus.OK.value());
			//	model.addAttribute("total", 100);
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
		
		
		} catch (JsonParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JsonMappingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}	  catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 	
	 
 	 
		return jSonView;
	}
	
	@RequestMapping("/file/download.do")
	public void download(ModelMap model,
			HttpServletRequest request, HttpServletResponse response)throws Exception{
		cmmnUtilService.download(model,request,response);
	}
	
	
	
}
