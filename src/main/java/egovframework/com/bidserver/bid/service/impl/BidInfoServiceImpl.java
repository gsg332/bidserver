package egovframework.com.bidserver.bid.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.bid.entity.BidInfo2;
import egovframework.com.bidserver.bid.service.BidInfoService;
import egovframework.com.bidserver.business.service.BusinessService;
import egovframework.com.bidserver.schedule.service.PublicDataService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("bidInfoService")
public class BidInfoServiceImpl extends EgovAbstractServiceImpl implements BidInfoService {

	@Resource(name = "bidInfoMapper")
	private BidInfoMapper bidInfoMapper;
	
	@Resource(name = "bidInfoService")
	private BidInfoService bidInfoService;
	
	@Resource(name = "businessService")
	private BusinessService businessService;
	
	@Resource(name = "publicDataService")
	private PublicDataService publicDataService;

	@Override
	public List<HashMap> selectBidList(HashMap map) throws Exception {
		return bidInfoMapper.selectBidList(map);
	}
	
	@Override
	public int getBidListCnt(HashMap map) throws Exception {
		return bidInfoMapper.getBidListCnt(map);
	}
	
	@Override
	public void deleteBidList(HashMap map) throws Exception {
		bidInfoMapper.deleteBidList(map);
	}
	
	@Override
	public void updateBidList(HashMap map) throws Exception {
		bidInfoMapper.updateBidList(map);
	}
	
	@Override
	public List<HashMap> selectUserList(HashMap map) throws Exception {
		return bidInfoMapper.selectUserList(map);
	}
	
	@Override
	public List<HashMap> selectComboList(HashMap map) throws Exception {
		return bidInfoMapper.selectComboList(map);
	}

	@Override
	public void updateManufactureRelList(HashMap map) throws Exception {
		bidInfoMapper.updateManufactureRelList(map);
	}
	
	@Override
	public List<HashMap> selectBizRelList(HashMap map) throws Exception {
		return bidInfoMapper.selectBizRelList(map);
	}
	
	@Override
	public List<HashMap> selectBizList(HashMap map) throws Exception {
		return bidInfoMapper.selectBizList(map);
	}
	
	@Override
	public HashMap selectBidSubj(HashMap map) throws Exception {
		return bidInfoMapper.selectBidSubj(map);
	}

	@Override
	public HashMap selectBidRisk(HashMap map) throws Exception {
		return bidInfoMapper.selectBidRisk(map);
	}
	
	@Override
	public List<HashMap> selectBidDtl(HashMap map) throws Exception {
		return bidInfoMapper.selectBidDtl(map);
	}
	
	@Override
	public void updateBidDtl(HashMap map) throws Exception {
		bidInfoMapper.updateBidDtl(map);
	}
	
	@Override
	public List<HashMap> selectCompanyTypeList(HashMap map) throws Exception {
		return bidInfoMapper.selectCompanyTypeList(map);
	}
	
	@Override
	public void deleteCompanyTypeList(HashMap map) throws Exception {
		bidInfoMapper.deleteCompanyTypeList(map);
	}

	@Override
	public void updateCompanyTypeList(HashMap map) throws Exception {
		bidInfoMapper.updateCompanyTypeList(map);
	}
	
	@Override
	public List<HashMap> manufactureList(HashMap map) throws Exception {
		return bidInfoMapper.manufactureList(map);
	}
	
	@Override
	public List<HashMap> businessList(HashMap map) throws Exception {
		return bidInfoMapper.businessList(map);
	}
	
	

	@Override
	public void updateManufactureList(HashMap map) throws Exception {
		bidInfoMapper.updateManufactureList(map);
	}
	
	@Override
	public HashMap selectApplyInfo(HashMap map) throws Exception {
		return bidInfoMapper.selectApplyInfo(map);
	}

	@Override
	public List<HashMap> selectEstimateList(HashMap map) throws Exception {
		return bidInfoMapper.selectEstimateList(map);
	}
	
	@Override
	public void updateEstimateList(HashMap map) throws Exception {
		bidInfoMapper.updateEstimateList(map);
	}
	
	@Override
	public int getProjectCnt(HashMap map) throws Exception {
		return bidInfoMapper.getProjectCnt(map);
	}
	
	@Override
	public int getApplyCnt(HashMap map) throws Exception {
		return bidInfoMapper.getApplyCnt(map);
	}
	
	@Override
	public void updateSubject(HashMap map) throws Exception {
		bidInfoMapper.updateSubject(map);
	}
	
	@Override
	public void updateRisk(HashMap map) throws Exception {
		bidInfoMapper.updateRisk(map);
	}
	
	@Override
	public void updateApply(HashMap map) throws Exception {
		bidInfoMapper.updateApply(map);
	}

	@Override
	public List<HashMap> selectBidConfirmList(HashMap map) throws Exception {
		return bidInfoMapper.selectBidConfirmList(map);
	}
	
	@Override
	public int getBidConfirmListCnt(HashMap map) throws Exception {
		return bidInfoMapper.getBidConfirmListCnt(map);
	}
	
	
	@Override
	public List<HashMap> selectBusinessCompanyTypeList(HashMap map) throws Exception {
		return bidInfoMapper.selectBusinessCompanyTypeList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessGoodsTypeList(HashMap map) throws Exception {
		return bidInfoMapper.selectBusinessGoodsTypeList(map);
	}

	@Override
	public void updateBusinessList(HashMap map) throws Exception {
		bidInfoMapper.updateBusinessList(map);
	}
	
	@Override
	public void updateBusinessRelList(HashMap map) throws Exception {
		bidInfoMapper.updateBusinessRelList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessRelList(HashMap map) throws Exception {
		return bidInfoMapper.selectBusinessRelList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessRelList2(HashMap map) throws Exception {
		return bidInfoMapper.selectBusinessRelList2(map);
	}
	
	@Override
	public void updateBidInfo(BidInfo2 bidInfo2) throws Exception {
		bidInfoMapper.updateBidInfo(bidInfo2);
	}
	
	
	@Override
	public void updateTable1(HashMap map) throws Exception {
		bidInfoMapper.updateTable1(map);
	}
	
	@Override
	public int updateTable4(HashMap map) throws Exception {
		return bidInfoMapper.updateTable4(map);
	}
	
	@Override
	public void updateTable5(HashMap map) throws Exception {
		bidInfoMapper.updateTable5(map);
	}
	
	@Override
	public void deleteManufactureList(HashMap map) throws Exception {
		bidInfoMapper.deleteManufactureList(map);
	}

	@Override
	public void deleteBusinessList(HashMap map) throws Exception {
		bidInfoMapper.deleteBusinessList(map);
	}
	
	@Override
	public void insertBidMessage(HashMap map) throws Exception {
		bidInfoMapper.insertBidMessage(map);
	}


	@Override
	public List<HashMap> selectBidOpenResultList(HashMap map) throws Exception {
		return bidInfoMapper.selectBidOpenResultList(map);
	}
	
	@Override
	public int getBidOpenResultListCnt(HashMap map) throws Exception {
		return bidInfoMapper.getBidOpenResultListCnt(map);
	}

	@Override
	public List<HashMap> selectBidOpenResultCompt(HashMap map) throws Exception {
		return bidInfoMapper.selectBidOpenResultCompt(map);
	}
	
	@Override
	public List<HashMap> selectBidOpenResultComptBy(HashMap map) throws Exception {
		return bidInfoMapper.selectBidOpenResultComptBy(map);
	}
	
	@Override
	public int selectBidOpenResultComptByCnt(HashMap map) throws Exception {
		return bidInfoMapper.selectBidOpenResultComptByCnt(map);
	}

	@Override
	public List<HashMap> selectBidOpenResultFail(HashMap map) throws Exception {
		return bidInfoMapper.selectBidOpenResultFail(map);
	}

	@Override
	public List<HashMap> selectBidOpenResultRebid(HashMap map) throws Exception {
		return bidInfoMapper.selectBidOpenResultRebid(map);
	}
	
	@Override
	public List<HashMap> selectBidOpenResultPriceDetailList(HashMap map) throws Exception {
		return bidInfoMapper.selectBidOpenResultPriceDetailList(map);
	}
	

	@Override
	public List<HashMap> selectSendMsgList(HashMap map) throws Exception {
		return bidInfoMapper.selectSendMsgList(map);
	}
	
	@Override
	public int getSendMsgListCnt(HashMap map) throws Exception {
		return bidInfoMapper.getSendMsgListCnt(map);
	}
	
	@Override
	public List<HashMap> selectBidRangeList(HashMap map) throws Exception {
		return bidInfoMapper.selectBidRangeList(map);
	}
	
	@Override
	public void deleteBidRangeList(HashMap map) throws Exception {
		bidInfoMapper.deleteBidRangeList(map);
	}
	
	@Override
	public void insertBidRangeList(HashMap map) throws Exception {
		bidInfoMapper.insertBidRangeList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessList(HashMap map) throws Exception {
		
		List<HashMap> resultList = new ArrayList<HashMap>();

		if(((String)map.get("bid_notice_no")).length()>0){
			map.put("pageNo", 0);
			map.put("rows", 10);
			map.put("bidNoticeNo", map.get("bid_notice_no")+"-"+map.get("bid_notice_cha_no"));
			
			List bidInfo = bidInfoService.selectBidList(map);
			
			if(bidInfo.size() > 0){
				List<HashMap> businessList = bidInfoService.businessList(map);
				map.put("pageNo", 0);
				map.put("rows", 10000);
				List<HashMap> businessDtlList = businessService.selectBusinessDtlList(map);
				
				HashMap info = (HashMap)bidInfo.get(0);
				
				List<String> passBussinessNo1 = new ArrayList<String>();
				List<String> passBussinessNo2 = new ArrayList<String>();
				List<String> passBussinessNo3 = new ArrayList<String>();
	
				List<HashMap> bidDtl = bidInfoService.selectBidDtl(map);
				
				String evalCode = "";
				String scaleCode = "";
				if(bidDtl.size()>0){
					evalCode = (String)((HashMap)bidDtl.get(0)).get("column2");
					scaleCode = (String)((HashMap)bidDtl.get(0)).get("column3");
					
					for(int i=0;i<businessDtlList.size();i++){
						HashMap businessDtlMap = (HashMap)businessDtlList.get(i);
						
						if(scaleCode!=null && scaleCode.equals("002")){
							if(businessDtlMap.get("scale_cd")!=null && ((String)businessDtlMap.get("scale_cd")).equals("003")){
								for(int j= businessList.size()-1; j>0;j--){
									HashMap businessListMap = (HashMap)businessList.get(j);
									if((String.valueOf(businessListMap.get("business_no"))).equals(String.valueOf(businessDtlMap.get("business_no")))){
										businessList.remove(j);
										break;
									}
								}
							}
						}
					}
				}
				
				if(evalCode.length()>0){
					for(int j= businessList.size()-1; j>0;j--){
						HashMap businessListMap = (HashMap)businessList.get(j);
						String business_no = String.valueOf(businessListMap.get("business_no"));
						String result = businessService.getEvalutionValue(business_no, evalCode);
						if(result.indexOf("부적격")!=-1){
							businessList.remove(j);
						}
					}
				}
				
				//지역제한
				String use_area_info = (String)info.get("use_area_info");
				
				if(use_area_info!=null && use_area_info.length()>0){
					String area[] = use_area_info.split(",");
					for(int i=0;i<businessList.size();i++){
						HashMap businessMap = (HashMap)businessList.get(i);
						
						for(int j=0;j<area.length;j++){
							if(businessMap.get("address")!=null){
								if(((String)businessMap.get("address")).contains(area[j])){
									passBussinessNo1.add(String.valueOf(((HashMap)businessList.get(i)).get("business_no")));
									break;
								}
							}
						}
					}
				}else{
					for(int i=0; i<businessList.size();i++){
						passBussinessNo1.add(String.valueOf(((HashMap)businessList.get(i)).get("business_no")));
					}
				}
				
				//제한 업종
				String lic_limit_nm[] = new String[12];
				lic_limit_nm[0] = (String)info.get("lic_limit_nm1");
				lic_limit_nm[1] = (String)info.get("lic_limit_nm2");
				lic_limit_nm[2] = (String)info.get("lic_limit_nm3");
				lic_limit_nm[3] = (String)info.get("lic_limit_nm4");
				lic_limit_nm[4] = (String)info.get("lic_limit_nm5");
				lic_limit_nm[5] = (String)info.get("lic_limit_nm6");
				lic_limit_nm[6] = (String)info.get("lic_limit_nm7");
				lic_limit_nm[7] = (String)info.get("lic_limit_nm8");
				lic_limit_nm[8] = (String)info.get("lic_limit_nm9");
				lic_limit_nm[9] = (String)info.get("lic_limit_nm10");
				lic_limit_nm[10] = (String)info.get("lic_limit_nm11");
				lic_limit_nm[11] = (String)info.get("lic_limit_nm12");
				if(
						lic_limit_nm[0].length() >2  ||
						lic_limit_nm[2].length() >2  ||
						lic_limit_nm[4].length() >2  ||
						lic_limit_nm[6].length() >2  ||
						lic_limit_nm[8].length() >2  ||
						lic_limit_nm[10].length() >2
				){
					for(int x=0; x<passBussinessNo1.size();x++){
						for(int i=0; i < lic_limit_nm.length; i++){
							if(lic_limit_nm[i].length() > 2){
								String company_type1 = lic_limit_nm[i].substring(lic_limit_nm[i].indexOf("/")+1, lic_limit_nm[i].length());
								String company_type2 = "";
								if(lic_limit_nm[i+1].length() > 2){
									company_type2 = lic_limit_nm[i+1].substring(lic_limit_nm[i+1].indexOf("/")+1, lic_limit_nm[i+1].length());
								}
	
								HashMap paramMap = new HashMap();
								paramMap.put("business_no", (String)passBussinessNo1.get(x));
								paramMap.put("company_type1", company_type1);
								paramMap.put("company_type2", company_type2.length()>0?company_type2:null);
								List<HashMap> companyTypeList = bidInfoService.selectBusinessCompanyTypeList(paramMap);
								
								if(companyTypeList.size()>0){
									passBussinessNo2.add((String)passBussinessNo1.get(x));
									break;
								}
							}
							i++;
						}
					}
				}else{
					for(int i=0; i<passBussinessNo1.size();i++){
						passBussinessNo2.add((String)passBussinessNo1.get(i));
					}
				}
				
				//물품분류제한
				String goods_grp_limit_yn = (String)info.get("goods_grp_limit_yn");
				
				if(goods_grp_limit_yn!=null && goods_grp_limit_yn.equals("Y")){
					
					String buy_target_goods_info = (String)info.get("buy_target_goods_info");
					
					String goods[] = buy_target_goods_info.split("##");
					
					String paramGoods[] = new String [goods.length];
					
					for(int i=0; i<goods.length;i++){
						paramGoods[i] = goods[i].split("\\^")[1];
					}
					
					for(int x=0; x<passBussinessNo2.size();x++){
						HashMap paramMap = new HashMap();
						paramMap.put("business_no", (String)passBussinessNo2.get(x));
						paramMap.put("paramGoods", paramGoods);
						
						List<HashMap> goodsTypeList = bidInfoService.selectBusinessGoodsTypeList(paramMap);
						
						if(goodsTypeList.size()>0){
							passBussinessNo3.add((String)passBussinessNo1.get(x));
							break;
						}
					}
				}else{
					for(int i=0; i<passBussinessNo2.size();i++){
						passBussinessNo3.add((String)passBussinessNo2.get(i));
					}
				}
				
				HashMap paramMap = new HashMap();
				paramMap.put("bid_notice_no", map.get("bid_notice_no"));
				paramMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
				
				String business_no_list[] = new String[passBussinessNo3.size()];
				
				if(passBussinessNo3.size()>0){
					for(int i=0;i<business_no_list.length;i++){
						business_no_list[i] = passBussinessNo3.get(i);
					}
				}else{
					business_no_list = new String[1];
					business_no_list[0] = "";
				}
				paramMap.put("business_no_list", business_no_list);
				
				resultList = bidInfoService.selectBusinessRelList(paramMap);
			}
		}
		
		return resultList;
	}
	
	@Override
	public List<HashMap> selectAllBidOpenResultList() throws Exception {
		return bidInfoMapper.selectAllBidOpenResultList();
	}
	
	@Override
	public void updateJoinCntOpengResultListInfo(HashMap map) throws Exception {
		bidInfoMapper.updateJoinCntOpengResultListInfo(map);
	}
	
	@Override
	public void updateImportantYn(HashMap map) throws Exception {
		bidInfoMapper.updateImportantYn(map);
	}
	
}
