package egovframework.com.bidserver.analysis.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.analysis.service.AnalysisService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("analysisService")
public class AnalysisServiceImpl extends EgovAbstractServiceImpl implements AnalysisService {
	
	List<HashMap> resultList;
	
	@Resource(name = "analysisMapper")
	private AnalysisMapper analysisMapper;
	
	@Resource(name = "analysisService")
	private AnalysisService analysisService;
	
	@Override
	public List<HashMap> selectBusinessBidInfoList(HashMap map) throws Exception {
		return analysisMapper.selectBusinessBidInfoList(map);
	}
	
	@Override
	public int getBusinessBidInfoListCnt(HashMap map) throws Exception {
		return analysisMapper.getBusinessBidInfoListCnt(map);
	}

	@Override
	public List<HashMap> selectBusinessBidInfoDtlList(HashMap map) throws Exception {
		return analysisMapper.selectBusinessBidInfoDtlList(map);
	}
	
	@Override
	public List<HashMap> selectKpiList(HashMap map) throws Exception {
		return analysisMapper.selectKpiList(map);
	}
	
	/**
	 * 이벤트 누적 투찰 개수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public int selectBusinessBidCnt(HashMap map) throws Exception{
		return analysisMapper.selectBusinessBidCnt(map);
	}
	
	/**
	 * 최근 이벤트 정보
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public HashMap selectLastEventInfo(HashMap map) throws Exception{
		return analysisMapper.selectLastEventInfo(map);
	}
}
