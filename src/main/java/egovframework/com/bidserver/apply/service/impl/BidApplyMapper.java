package egovframework.com.bidserver.apply.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 입찰관리
 * 
 * @author 정진고
 * @since 2016.03.14
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * 
 * </pre>
 */

@Mapper("bidApplyMapper")
public interface BidApplyMapper {

	/**
	 * 요청공고 리스트
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
	 * 요청공고 총갯수
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
