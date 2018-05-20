package egovframework.com.bidserver.apply.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.apply.service.BidApplyService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("bidApplyService")
public class BidApplyServiceImpl extends EgovAbstractServiceImpl implements BidApplyService {

	@Resource(name = "bidApplyMapper")
	private BidApplyMapper bidApplyMapper;

	@Override
	public List<HashMap> selectBidMyApplyList(HashMap map) throws Exception {
		return bidApplyMapper.selectBidMyApplyList(map);
	}
	
	@Override
	public List<HashMap> selectBidApplyList(HashMap map) throws Exception {
		return bidApplyMapper.selectBidApplyList(map);
	}
	
	@Override
	public int getBidMyApplyListCnt(HashMap map) throws Exception {
		return bidApplyMapper.getBidMyApplyListCnt(map);
	}
	
	@Override
	public void updateBidMyApplyList(HashMap map) throws Exception {
		bidApplyMapper.updateBidMyApplyList(map);
	}
	
	@Override
	public void deleteBidApplyList(HashMap map) throws Exception{
		bidApplyMapper.deleteBidApplyList(map);
	}
	
	@Override
	public void updateBidMyApplyFileList(HashMap map) throws Exception{
		bidApplyMapper.updateBidMyApplyFileList(map);
	}
	
}
