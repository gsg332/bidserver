   package egovframework.com.bidserver.sever.company.manufactureCompany.web;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.sever.company.manufactureCompany.service.ManufactureCompanyService;


@Controller
public class ManufactureCompanyController {

	
	
	@Resource(name="manufactureCompanyService")
	private ManufactureCompanyService manufactureCompanyService;
		

	@Autowired
	private View jSonView;
		
	

	
	/*@RequestMapping(value="/test/test.do", method=RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View test(HttpServletRequest request,Model model) {
		
		List<test> resultList = null;
		try {
			
			
			
			resultList = testService.selectTest();
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
