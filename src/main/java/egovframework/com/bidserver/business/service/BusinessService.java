package egovframework.com.bidserver.business.service;

import java.util.HashMap;
import java.util.List;

public interface BusinessService {

	/**
	 * 투찰사 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getBusinessListCnt(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 상세 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessDtlList(HashMap map) throws Exception; 
	
	/**
	 * 공통코드 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectComboEvalList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 상세 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateBusinessDtlList(HashMap map) throws Exception; 
	
	
	/**
	 * 적격심사
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public String getEvalutionValue(String business_no, String type) throws Exception;
	
	/**
	 * 공공구매정보망 기업정보 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectOrderBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 중소기업정보 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectOrderBusinessList2(HashMap map) throws Exception; 
	
	/**
	 * 공공구매정보망 기업정보 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getOrderBusinessListCnt(HashMap map) throws Exception; 
	
	/**
	 * 중소기업정보 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getOrderBusinessListCnt2(HashMap map) throws Exception; 
	
	/**
	 * 기업정보 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteOrderBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 기업정보 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateOrderBusinessList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 사용자 등록 이력 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBizNotiHisList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 사용자 등록 이력 추가
	 * @param map
	 * @throws Exception
	 */
	public void insertBizNotiHisList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 사용자 등록 이력 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateBizNotiHisList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 사용자 등록 이력 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteBizNotiHisList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 파일정보 등록 
	 * @param map
	 * @throws Exception
	 */
	public void updateCompanyFileList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 투찰이력 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessBidInfoList(HashMap map) throws Exception; 
	
	/**
	 * 투찰사  투찰이력 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getBusinessBidInfoListCnt(HashMap map) throws Exception; 

	/**
	 * 투찰사 투찰이력 상세 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessBidInfoDtlList(HashMap map) throws Exception; 
}

