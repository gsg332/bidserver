package egovframework.com.bidserver.mobile.service.impl;



import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.bidserver.mobile.service.MobileWebService;


@Service("mobileWebService")
@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
public  class MobileWebServiceImpl  implements MobileWebService{
	
	@Resource(name = "mobileWebMapper")
	private MobileWebMapper mobileWebMapper;

	@Override
	public List<HashMap> getLogin(HashMap map) throws Exception{
		
		return 	mobileWebMapper.getLogin(map);
		
	}
	
	@Override
	public List<HashMap> selectBusinessBidList(HashMap map) throws Exception{
		
		return 	mobileWebMapper.selectBusinessBidList(map);
		
	}
	
	@Override
	public void updateRegId(HashMap map) throws Exception {
		mobileWebMapper.updateRegId(map);
	}
	
	@Override
	public void updateChkDt(HashMap map) throws Exception {
		mobileWebMapper.updateChkDt(map);
	}
	
	@Override
	public List<HashMap> selectNotiList(HashMap map) throws Exception{
		
		return 	mobileWebMapper.selectNotiList(map);
	}
	
	@Override
	public String getVersion(HashMap map) throws Exception{
		
		return 	mobileWebMapper.getVersion(map);
	}
	
	@Override
	public List<HashMap> getBidDetailInfo1(HashMap map) throws Exception{
		
		return 	mobileWebMapper.getBidDetailInfo1(map);
		
	}
}
