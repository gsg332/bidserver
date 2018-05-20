package egovframework.com.bidserver.analysis.service.impl;

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

@Mapper("analysisMapper")
public interface AnalysisMapper {
	
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
	
	public List<HashMap> selectKpiList(HashMap map) throws Exception; 

	/**
	 * 이벤트 누적 투찰 개수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int selectBusinessBidCnt(HashMap map) throws Exception;
	
	/**
	 * 최근 이벤트 정보
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap selectLastEventInfo(HashMap map) throws Exception;
}
