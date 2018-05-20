package egovframework.com.bidserver.main.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.main.service.UserService;
import egovframework.com.bidserver.sever.company.bidCompany.service.BidCompanyService;
import egovframework.com.bidserver.util.StringUtil;
import egovframework.com.cmm.message.ResultStatus;



@Controller
public class UserController {
	
	@Autowired
	private View jSonView;
	
	@Resource(name="userService")
	private UserService userService;

	static Logger log = Logger.getLogger(UserController.class.getName());
	
	@RequestMapping(value="/user/login.do", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View login(HttpServletRequest request,Model model, Map<String,Object> data) {
		HttpSession session = request.getSession();
		
		Map  result  = null;
		try {
			
			Map<String, Object> map = new HashMap<String, Object>();
			String login_id="A";
			if(null==request.getParameter("epno"))  login_id="A";
			else login_id=request.getParameter("epno");
			
			String pwd;
			if(null==request.getParameter("eppw"))  pwd="A";
			else pwd=request.getParameter("eppw");
			
			
			map.put("user_id",  login_id  );
			map.put("pwd",  pwd  );
			
			result =  userService.get(map);
			
			userService.update(map);
			
			if(result==null){
		 		model.addAttribute("loginOK", "false");
		 		model.addAttribute("resultCode", ResultStatus.OK.value());
				model.addAttribute("total", 100);
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		 	} else {
		 		session.setAttribute("loginOK", "true");
				session.setAttribute("loginid", result.get("user_id"));
				session.setAttribute("loginidnum", result.get(""));
				session.setAttribute("loginidNM", result.get("user_nm"));
				session.setAttribute("position", StringUtil.nvl((String)result.get("position")));
				session.setAttribute("auth", StringUtil.nvl((String)result.get("role_cd")));
				session.setAttribute("tel", StringUtil.nvl((String)result.get("tel")));
				session.setAttribute("mobile", StringUtil.nvl((String)result.get("mobile")));
				session.setAttribute("fax", StringUtil.nvl((String)result.get("fax")));
				session.setAttribute("email", StringUtil.nvl((String)result.get("email")));
				session.setAttribute("emailPw", StringUtil.nvl((String)result.get("email_pw")));
				session.setAttribute("emailHost", StringUtil.nvl((String)result.get("email_host")));
				session.setAttribute("emailPort", StringUtil.nvl((String)result.get("email_port")));
				
				
				model.addAttribute("loginOK", "true");
				model.addAttribute("resultCode", ResultStatus.OK.value());
				model.addAttribute("total", 100);
				model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
				
				
				model.addAttribute("login_id",result.get("user_id") );
				model.addAttribute("login_nm",result.get("user_nm") );
		 	}
			
		} catch(Exception e) {
			model.addAttribute("loginOK", "false");
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}
	
	
	@RequestMapping(value="/user/logout.do", method=RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View loginout(HttpServletRequest request,Model model, Map<String,Object> data) {
		HttpSession session = request.getSession();
	 
	  	
	 	JSONObject obj = new JSONObject();
		obj.put("loginOK","false");  
		session.setAttribute("loginOK", "false");
	    
	
		return jSonView;
	 
	}
	
	

}
