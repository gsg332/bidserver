package egovframework.com.bidserver.mobile.service;

import java.util.HashMap;
import java.util.List;


public interface MobileWebService {
	
	/**
	 * 투찰업체 로그인
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> getLogin(HashMap map) throws Exception;

	
	/**
	 * 투찰업체 공고 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBusinessBidList(HashMap map) throws Exception;
	
	/**
	 * 투찰사 푸쉬 알람 reg_id 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateRegId(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 추천가격확인
	 * @param map
	 * @throws Exception
	 */
	public void updateChkDt(HashMap map) throws Exception; 

	/**
	 * 공지사항 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectNotiList(HashMap map) throws Exception;
	
	
	/**
	 * 모바일 버전 정보
	 * @return
	 * @throws Exception
	 */
	public String getVersion(HashMap map) throws Exception;

	/**
	 * 투찰업체 공고 상세1
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> getBidDetailInfo1(HashMap map) throws Exception;
}
