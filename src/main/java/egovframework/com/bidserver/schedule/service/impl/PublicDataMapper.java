package egovframework.com.bidserver.schedule.service.impl;

import java.util.HashMap;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : PublicDataMapper.java
 */

/**
 * 나라장터 DB 스케줄러
 * 
 * @author jjg
 * @since 2016.03.04
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2016.03.04  jjg          최초 생성
 * 
 * </pre>
 */

@Mapper("publicDataMapper")
public interface PublicDataMapper {

	/**
	 * 입찰공고서비스
	 * 나라장터 입찰공고 물품 목록을 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateBidPblancListInfoThng(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고서비스
	 * 나라장터 입찰공고 물품 목록을 조회 파일목록
	 * @param map
	 * @throws Exception
	 */
	public void updateBidPblancListInfoThngFile(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고서비스
	 * 입찰공고목록 정보에 대한 참가가능 지역 정보조회
	 * @param map
	 * @throws Exception
	 */
	public void updateBidPblancListInfoPrtcptPsblRgn(HashMap map) throws Exception; 

	/**
	 * 입찰공고서비스
	 * 나라장터 입찰공고 물품 목록을 기초금액 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateBidPblancListInfoThngBsisAmount(HashMap map) throws Exception; 
	
	/**
	 * 입찰공고서비스
	 * 나라장터 입찰공고 물품 목록을 기초금액 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateBidPblancListInfoThngBsisAmountCopy(HashMap map) throws Exception; 
	
	/**
	 * 물품분류체계서비스
	 * 나라장터 세부품명찾기 목록을 조회 할 수 있다.
	 * @param map
	 * @throws Exception
	 */
	public void updateDetailPrdnmFndThngClSystmStrdInfo(HashMap map) throws Exception; 

	/**
	 * 낙찰정보서비스
	 * 나라장터 최종낙찰자 물품 목록을 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateScsbidListSttusThng(HashMap map) throws Exception; 
	
	/**
	 * 낙찰정보서비스
	 * 나라장터 개찰결과 물품 목록을 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateOpengResultListInfoThng(HashMap map) throws Exception; 
	
	/**
	 * 낙찰정보서비스
	 * 나라장터 개찰결과 물품 예비가격상세 목록을 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateOpengResultListInfoThngPreparPcDetail(HashMap map) throws Exception; 
	
	/**
	 * 낙찰정보서비스
	 * 나라장터 개찰결과 개찰완료 목록을 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateOpengResultListInfoOpengCompt(HashMap map) throws Exception; 
	
	/**
	 * 낙찰정보서비스
	 * 나라장터 개찰결과 유찰 목록을 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateOpengResultListInfoFailinb(HashMap map) throws Exception; 
	
	/**
	 * 낙찰정보서비스
	 * 나라장터 개찰결과 재입찰 목록을 조회
	 * @param map
	 * @throws Exception
	 */
	public void updateOpengResultListInfoRebid(HashMap map) throws Exception;
	
	public void removeBizGoodsDirectPastLimitDt(HashMap map) throws Exception;
	
	public void removeBizLicensePastLimitDt(HashMap map) throws Exception;
	
	public void updateScaleCdPastLimitDt(HashMap map) throws Exception;
	
	public void updateCreditCdPastLimitDt(HashMap map) throws Exception;
	
}




