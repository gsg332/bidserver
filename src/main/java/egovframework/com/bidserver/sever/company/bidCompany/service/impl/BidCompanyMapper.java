package egovframework.com.bidserver.sever.company.bidCompany.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.com.bidserver.sever.company.bidCompany.entity.Bidcompany;
import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("bidCompanyMapper")
public interface BidCompanyMapper {
	
	//public List<Bidcompany> selectBidcompany() throws Exception;   			//투찰사정보 조회 
	
	public List<HashMap> selectBidcompany(Map<String, Object> map) throws Exception;   //

	
	public void insertBidcompany(Bidcompany bidcompany) throws Exception; 	//투찰사정보 저장 


	public void update(Map<String, Object> map);

	}
