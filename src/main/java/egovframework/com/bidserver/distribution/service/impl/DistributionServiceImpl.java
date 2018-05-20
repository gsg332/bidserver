package egovframework.com.bidserver.distribution.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.distribution.service.DistributionService;
import egovframework.com.bidserver.schedule.service.impl.PublicDataMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("distributionService")
public class DistributionServiceImpl extends EgovAbstractServiceImpl implements DistributionService {

	@Resource(name = "distributionMapper")
	private DistributionMapper distributionMapper;
	
	@Resource(name = "publicDataMapper")
	private PublicDataMapper publicDataMapper;
	 
	@Resource(name = "distributionService")
	private DistributionService distributionService;
	
	@Override
	public List<HashMap> selectBidList(HashMap map) throws Exception {
		return distributionMapper.selectBidList(map);
	}
	
	@Override
	public int getBidListCnt(HashMap map) throws Exception {
		return distributionMapper.getBidListCnt(map);
	}
	
	@Override
	public List<HashMap> selectBidUserCnt(HashMap map) throws Exception {
		return distributionMapper.selectBidUserCnt(map);
	}
	
	@Override
	public List<HashMap> selectBidList2(HashMap map) throws Exception {
		return distributionMapper.selectBidList2(map);
	}
	
	@Override
	public int getBidListCnt2(HashMap map) throws Exception {
		return distributionMapper.getBidListCnt2(map);
	}
	
	@Override
	public int selectDisCnt(HashMap map) throws Exception {
		return distributionMapper.selectDisCnt(map);
	}
	
	@Override
	public int insertDistributionList(HashMap map) throws Exception {
		int result = 0;
		result = distributionMapper.insertDistributionList(map);
		/*if(result > 0){
			distributionMapper.insertDistributionList2(map);
			distributionMapper.insertDistributionList3(map);
			distributionMapper.insertDistributionList4(map);
			distributionMapper.insertDistributionList5(map);
			//distributionMapper.insertDistributionList6(map);
			distributionMapper.insertDistributionList7(map);
			distributionMapper.insertDistributionList8(map);
			distributionMapper.insertDistributionList9(map);
		}*/
		return result;
	}
	
	@Override
	public void updateDistributionList(HashMap map) throws Exception {
		distributionMapper.updateDistributionList(map);
	}
	
	@Override
	public int selectDisDtlCnt(HashMap map) throws Exception {
		return distributionMapper.selectDisDtlCnt(map);
	}
	
	@Override
	public List<HashMap> selectDistributionDtl(HashMap map) throws Exception {
		return distributionMapper.selectDistributionDtl(map);
	}
	
	@Override
	public void updateBidBaseAmount(HashMap map) throws Exception {
		distributionMapper.updateBidBaseAmount(map);
	}
	
	@Override
	public void updateBidDetailInfo(HashMap map) throws Exception {
		distributionMapper.updateBidDetailInfo(map);
	}
	
	@Override
	public List<HashMap> selectBidDtl(HashMap map) throws Exception {
		return distributionMapper.selectBidDtl(map);
	}
	
	@Override
	public HashMap selectBidSubj(HashMap map) throws Exception {
		return distributionMapper.selectBidSubj(map);
	}
	
	@Override
	public HashMap selectBidRisk(HashMap map) throws Exception {
		return distributionMapper.selectBidRisk(map);
	}
	
	@Override
	public HashMap selectApplyInfo(HashMap map) throws Exception {
		return distributionMapper.selectApplyInfo(map);
	}
	
	@Override
	public int manufactureChk(HashMap map) throws Exception {
		return distributionMapper.manufactureChk(map);
	}
	
	@Override
	public List<HashMap> selectBizRelList(HashMap map) throws Exception {
		return distributionMapper.selectBizRelList(map);
	}
	
	@Override
	public List<HashMap> selectBizManufactureList(HashMap map) throws Exception {
		return distributionMapper.selectBizManufactureList(map);
	}
	
	@Override
	public void updateBidDtl(HashMap map) throws Exception {
		distributionMapper.updateBidDtl(map);
	}
	
	@Override
	public void updateBidList(HashMap map) throws Exception {
		distributionMapper.updateBidList(map);
	}
	
	@Override
	public void updateBidRisk(HashMap map) throws Exception {
		distributionMapper.updateBidRisk(map);
	}
	
	@Override
	public void updateBidRisk2(HashMap map) throws Exception {
		distributionMapper.updateBidRisk2(map);
	}
	
	@Override
	public void updateBidSubj(HashMap map) throws Exception {
		distributionMapper.updateBidSubj(map);
	}
	
	@Override
	public void deleteManufactureList(HashMap map) throws Exception {
		distributionMapper.deleteManufactureList(map);
	}
	
	@Override
	public void updateManufactureList(HashMap map) throws Exception {
		distributionMapper.updateManufactureList(map);
	}
	
	@Override
	public void updateApply(HashMap map) throws Exception {
		distributionMapper.updateApply(map);
	}
	
	@Override
	public void updateManufactureList2(HashMap map) throws Exception {
		distributionMapper.updateManufactureList2(map);
	}
	
	@Override
	public void updateManufactureList3(HashMap map) throws Exception {
		distributionMapper.updateManufactureList3(map);
	}
	
	@Override
	public void deleteManufactureChoice(HashMap map) throws Exception {
		distributionMapper.deleteManufactureChoice(map);
	}
	
	@Override
	public void updateApply2(HashMap map) throws Exception {
		distributionMapper.updateApply2(map);
	}
	
	@Override
	public void updateBidDtl2(HashMap map) throws Exception {
		distributionMapper.updateBidDtl2(map);
	}
	
	@Override
	public void updateDrop(HashMap map) throws Exception {
		distributionMapper.updateDrop(map);
	}
	
	@Override
	public void updatePick(HashMap map) throws Exception {
		distributionMapper.updatePick(map);
	}
	
	@Override
	public List<HashMap> selectUserList(HashMap map) throws Exception {
		return distributionMapper.selectUserList(map);
	}
	
	@Override
	public List<HashMap> selectComboList(HashMap map) throws Exception {
		return distributionMapper.selectComboList(map);
	}
	
	@Override
	public List<HashMap> manufactureList(HashMap map) throws Exception {
		return distributionMapper.manufactureList(map);
	}
	
	@Override
	public void insertBidMessage(HashMap map) throws Exception {
		distributionMapper.insertBidMessage(map);
	}
	
	@Override
	public void updateBusinessRelList(HashMap map) throws Exception {
		distributionMapper.updateBusinessRelList(map);
	}
	
	@Override
	public void scheduleDrop(HashMap map) throws Exception {
		List<HashMap> dropList = distributionMapper.selectScheduleDropList(map);
		HashMap statusMap = null;
		for(int i=0;i<dropList.size();i++){	
			map = new HashMap<Object, String>();
			map.put("bid_notice_no", dropList.get(i).get("bid_notice_no"));
			map.put("bid_notice_cha_no", dropList.get(i).get("bid_notice_cha_no"));
			
			distributionMapper.scheduleDrop(map);		
		}
	}
	
	@Override
	public void insertBidNotice(HashMap map) throws Exception {
		distributionMapper.insertBidNotice(map);
	}
	
	@Override
	public List<HashMap> selectEstimateList(HashMap map) throws Exception {
		return distributionMapper.selectEstimateList(map);
	}
	
	@Override
	public List<HashMap> selectBidApplyList(HashMap map) throws Exception {
		return distributionMapper.selectBidApplyList(map);
	}
	
	@Override
	public void scheduleJoinCnt(HashMap map) throws Exception {	
		List<HashMap> joinList = distributionMapper.selectScheduleJoinList(map);
		for(int i=0;i<joinList.size();i++){	
			map = new HashMap<Object, String>();
			map.put("bid_notice_no", joinList.get(i).get("bid_notice_no"));
			map.put("bid_notice_cha_no", joinList.get(i).get("bid_notice_cha_no"));
			int joinComCnt = distributionMapper.selectBidOpenResultComptByCnt(map); //실제 투찰에 응한 투찰사 목록수
			if(joinComCnt >= 0){
				map.put("join_com_cnt", String.valueOf(joinComCnt));		
				distributionMapper.updateOpengResultListInfoThng(map);
			}
		}
	}
	
	@Override
	public List<HashMap> selectBigoDtl(HashMap map) throws Exception {
		return distributionMapper.selectBigoDtl(map);
	}
	
	@Override
	public List<HashMap> selectBigoDtl2(HashMap map) throws Exception {
		return distributionMapper.selectBigoDtl2(map);
	}
	
	@Override
	public void updateBigo(HashMap map) throws Exception {
		distributionMapper.updateBigo(map);
	}
	
	@Override
	public void updateBigo2(HashMap map) throws Exception {
		distributionMapper.updateBigo2(map);
	}
	
	@Override
	public void updateColorType(HashMap map) throws Exception {
		distributionMapper.updateColorType(map);
	}
	
}