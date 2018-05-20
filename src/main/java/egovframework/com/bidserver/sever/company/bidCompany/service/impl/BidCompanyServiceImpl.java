package egovframework.com.bidserver.sever.company.bidCompany.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.sever.company.bidCompany.entity.Bidcompany;
import egovframework.com.bidserver.sever.company.bidCompany.service.BidCompanyService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("bidCompanyService")
public class BidCompanyServiceImpl extends EgovAbstractServiceImpl implements BidCompanyService  {


	@Resource(name = "bidCompanyMapper")
	private  BidCompanyMapper  bidCompanyMapper;

	
	@Override
	public void insertBidcompany(Bidcompany bidcompany) throws Exception {
		
	}


	@Override
	public List<HashMap> selectBidcompany(Map<String, Object> map) throws Exception {
		return bidCompanyMapper.selectBidcompany(map);
	}


	@Override
	public void update(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		//return bidCompanyMapper.update(map);
		bidCompanyMapper.update(map);
		
	}


	
}

	
