package egovframework.com.bidserver.mobile.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 모바일 관리
 * 
 * @author 정진고
 * @since 2016.06.01
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * 
 * </pre>
 */

@Mapper("mobileWebMapper")
public interface MobileWebMapper {
	
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
	 * 모바일 버전
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
