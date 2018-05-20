   package egovframework.com.bidserver.sever.company.bidCompany.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.sever.company.bidCompany.entity.Bidcompany;
import egovframework.com.bidserver.sever.company.bidCompany.service.BidCompanyService;
import egovframework.com.cmm.message.ResultStatus;


@Controller
public class BidCompanyController {

	
	
	@Resource(name="bidCompanyService")
	private BidCompanyService bidCompanyService;
		

	@Autowired
	private View jSonView;
		
	

/*	
	@RequestMapping(value="/company/bidCompany.do", method=RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View company(HttpServletRequest request,Model model) {
		
		List<Bidcompany> resultList = null;
		try {
			
			resultList = bidCompanyService.selectBidcompany();
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
	
	*/
	
}
