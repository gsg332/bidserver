package egovframework.com.bidserver.opening.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 입찰관리
 * 
 * @author 정진고
 * @since 2016.03.01
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * 
 * </pre>
 */

@Mapper("openingMapper")
public interface OpeningMapper {
	
	public List<HashMap> selectBidConfirmList(HashMap map) throws Exception; 

	public int getBidConfirmListCnt(HashMap map) throws Exception; 
	
	public List<HashMap> businessList(HashMap map) throws Exception; 
	
	public int getBidListCnt(HashMap map) throws Exception; 
	
	public List<HashMap> selectBidList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBusinessDtlList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBidDtl(HashMap map) throws Exception; 
	
	public List<HashMap> selectBusinessCompanyTypeList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBusinessGoodsTypeList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBusinessRelList(HashMap map) throws Exception;
	
	public void insertBusinessRelList(HashMap map) throws Exception;
	
	public List<HashMap> evalutionList(HashMap map) throws Exception; 
	
	public int selectBusinessDtlCnt(HashMap map) throws Exception;
	
	public List<HashMap> selectBusinessDtl(HashMap map) throws Exception;
	
	/**
	 * 개찰공고 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidOpenResultList(HashMap map) throws Exception; 
	
	/**
	 * 개찰공고 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getBidOpenResultListCnt(HashMap map) throws Exception; 
	
	/**
	 * 개찰완료 목록 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidOpenResultCompt(HashMap map) throws Exception; 
	
	/**
	 * 유찰 목록 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidOpenResultFail(HashMap map) throws Exception;
	
	/**
	 * 재입찰 목록 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidOpenResultRebid(HashMap map) throws Exception; 
	
	/**
	 * 개찰완료 목록  투찰사 순위 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidOpenResultComptBy(HashMap map) throws Exception;
	
	/**
	 * 발신메세지 저장
	 * @param map
	 * @throws Exception
	 */
	public void insertBidMessage(HashMap map) throws Exception;
	
	/**
	 * 입찰공고 투찰사 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateBusinessRelList(HashMap map) throws Exception; 
	
	public void updateBusinessRelList2(HashMap map) throws Exception; 
	
	public void updateBusinessRelList3(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 투찰사 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고에 대한 투찰업체 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteBusinessList(HashMap map) throws Exception;
	
	/**
	 * 메세지 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteMessage(HashMap map) throws Exception;
	
	/**
	 * 투찰사 메세지 총수
	 * @param map
	 * @throws Exception
	 */
	public int selectMessageTotalCnt(HashMap map) throws Exception;
	
	public List<HashMap> selectLicenseList(HashMap map) throws Exception;
	
	public int businessChk(HashMap map) throws Exception; 
	
	public List<HashMap> selectBusinessList2(HashMap map) throws Exception;
	
	public List<HashMap> selectBusinessList3(HashMap map) throws Exception;
	
	public void updateBusinessList2(HashMap map) throws Exception; 
	
	public void updateBusinessSendYn(HashMap map) throws Exception; 
	
	/**
	 * 추천구간 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidRangeList(HashMap map) throws Exception; 
	
	/**
	 * 추천구간 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteBidRangeList(HashMap map)throws Exception;
	
	/**
	 * 추천구간 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertBidRangeList(HashMap map)throws Exception;
	
	/**
	 * 견적보고서 정보
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap selectEstimateReportInfo(HashMap map)throws Exception;
	
}
