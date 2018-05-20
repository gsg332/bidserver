package egovframework.com.bidserver.bid.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.bidserver.bid.entity.BidInfo2;

public interface BidInfoService {

	/**
	 * 입찰공고 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getBidListCnt(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteBidList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateBidList(HashMap map) throws Exception; 
	
	/**
	 * 담당자 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectUserList(HashMap map) throws Exception; 
	
	/**
	 * 공통코드 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectComboList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 과업정보 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap selectBidSubj(HashMap map) throws Exception; 
	/**
	 * 입찰공고 리스크 정보 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap selectBidRisk(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 사용자 데이터 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidDtl(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 사용자 데이터 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateBidDtl(HashMap map) throws Exception;
	
	/**
	 * 입찰공고에 대한 제조사 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBizRelList(HashMap map) throws Exception; 
	
	/**
	 * 제조사 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBizList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고에 대한 제조사 견적요청
	 * @param map
	 * @throws Exception
	 */
	public void updateManufactureRelList(HashMap map) throws Exception;
	

	/**
	 * 업종리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectCompanyTypeList(HashMap map) throws Exception; 
	
	
	/**
	 * 입찰공고 업종 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteCompanyTypeList(HashMap map) throws Exception; 

	/**
	 * 입찰공고 업종 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateCompanyTypeList(HashMap map) throws Exception; 
	
	/**
	 * 제조업체 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> manufactureList(HashMap map) throws Exception; 
	
	
	/**
	 * 투찰업체 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> businessList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 제조업체 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateManufactureList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 승인 상태
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap selectApplyInfo(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고에 대한 견적요청 제조사 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectEstimateList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 제조사 견적내용 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateEstimateList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 투찰사 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고 투찰사 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateBusinessRelList(HashMap map) throws Exception; 
	
	/**
	 * 프로젝트관리 금일 진행 건수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getProjectCnt(HashMap map) throws Exception; 
	
	/**
	 * 나의 견적승인요청건수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getApplyCnt(HashMap map) throws Exception; 
	
	/**
	 * 과업정보 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateSubject(HashMap map) throws Exception;
	
	/**
	 * 리스크 분석 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateRisk(HashMap map) throws Exception;
	
	/**
	 * 견적승인 요청
	 * @param map
	 * @throws Exception
	 */
	public void updateApply(HashMap map) throws Exception;
	
	/**
	 * 투찰결정 공고 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidConfirmList(HashMap map) throws Exception; 
	
	/**
	 * 투찰결정 공고 총갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getBidConfirmListCnt(HashMap map) throws Exception; 
	

	/**
	 * 투찰사 업종 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessCompanyTypeList(HashMap map) throws Exception; 
	
	/**
	 *  투찰사 물품 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessGoodsTypeList(HashMap map) throws Exception; 
	
	/**
	 * 투찰결정 공고 투찰사 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessRelList(HashMap map) throws Exception; 
	
	/**
	 * 투찰업체 물품등록 및 참가신청 업체 목록 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessRelList2(HashMap map) throws Exception; 

	/**
	 * 엑셀업로드
	 * @param bidInfo2
	 * @throws Exception
	 */
	public void updateBidInfo(BidInfo2 bidInfo2) throws Exception;
	
	public void updateTable1(HashMap map) throws Exception;
	public int updateTable4(HashMap map) throws Exception;
	public void updateTable5(HashMap map) throws Exception;
	
	/**
	 * 입찰공고에 대한 제조업체 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteManufactureList(HashMap map) throws Exception;
	
	/**
	 * 입찰공고에 대한 투찰업체 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteBusinessList(HashMap map) throws Exception;
	
	/**
	 * 발신메세지 저장
	 * @param map
	 * @throws Exception
	 */
	public void insertBidMessage(HashMap map) throws Exception;
	

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
	 * 개찰완료 목록  투찰사 순위 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidOpenResultComptBy(HashMap map) throws Exception;
	
	/**
	 * 개찰완료 목록  투찰사 순위 리스트 수 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int selectBidOpenResultComptByCnt(HashMap map) throws Exception;
	
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
	 * 개찰공고 복수예가 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidOpenResultPriceDetailList(HashMap map) throws Exception; 
	
	/**
	 * 발신메세지 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectSendMsgList(HashMap map) throws Exception; 
	
	/**
	 * 발신메세지 총갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getSendMsgListCnt(HashMap map) throws Exception; 
	
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
	 * 
	 * @param 
	 * @return 
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessList(HashMap map)throws Exception;
	
	/**
	 * 모든 개찰결과 목록을 가져온다. 
	 * @param 
	 * @return 
	 * @throws Exception
	 */
	public List<HashMap> selectAllBidOpenResultList()throws Exception;
	
	/**
	 * 참여시킨 업체수 및 실제참여한 업체수 정보 등록 및 수정.
	 *
	 * @param map
	 * @throws Exception
	 */
	public void updateJoinCntOpengResultListInfo(HashMap map)throws Exception;
	
	/**
	 * 중요목록 체크
	 * @param map
	 * @throws Exception
	 */
	public void updateImportantYn(HashMap map) throws Exception; 
	
}
