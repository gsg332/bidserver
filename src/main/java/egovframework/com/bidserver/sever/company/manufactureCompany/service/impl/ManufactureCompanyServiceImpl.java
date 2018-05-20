package egovframework.com.bidserver.sever.company.manufactureCompany.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.sever.company.manufactureCompany.service.ManufactureCompanyService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("manufactureCompanyService")
public class ManufactureCompanyServiceImpl extends EgovAbstractServiceImpl implements ManufactureCompanyService  {


	@Resource(name = "manufactureCompanyMapper")
	private ManufactureCompanyMapper  manufactureCompanyMapper;

/*	@Override
	public List<test> selectTest() throws Exception {
		return testMapper.selectTest();
	}
*/
	
}

	
