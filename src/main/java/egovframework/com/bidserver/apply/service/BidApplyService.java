package egovframework.com.bidserver.apply.service;

import java.util.HashMap;
import java.util.List;

public interface BidApplyService {

	/**
	 * 요청공고 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidMyApplyList(HashMap map) throws Exception; 

	/**
	 * 요청공고 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidApplyList(HashMap map) throws Exception; 
	
	/**
	 * 요청공고 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getBidMyApplyListCnt(HashMap map) throws Exception; 
	
	/**
	 * 요청공고 처리
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public void updateBidMyApplyList(HashMap map) throws Exception; 
	
	/**
	 * 요청공고 삭제
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public void deleteBidApplyList(HashMap map) throws Exception; 
	

	public void updateBidMyApplyFileList(HashMap map) throws Exception;
}
