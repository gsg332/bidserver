package egovframework.com.bidserver.analysis.service;

import java.util.HashMap;
import java.util.List;

public interface AnalysisService {	

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
