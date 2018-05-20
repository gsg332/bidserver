package egovframework.com.bidserver.project.service;

import java.util.HashMap;
import java.util.List;

public interface ProjectService {

	/**
	 * 프로젝트 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectProjectList(HashMap map) throws Exception; 

	/**
	 * 프로젝트 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectProjectList2(HashMap map) throws Exception; 
	
	/**
	 * 프로젝트 총갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getProjectListCnt(HashMap map) throws Exception; 
	
	/**
	 * 프로젝트 제조업체 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectProjectDtlList(HashMap map) throws Exception; 
	
	/**
	 * 프로젝트 진행현황 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectProjectScheduleList(HashMap map) throws Exception; 
	
	/**
	 * 프로젝트 매입매출 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectProjectTaxList(HashMap map) throws Exception; 
	
	
	public int insertProjectList(HashMap map) throws Exception;
	public void updateProjectList(HashMap map) throws Exception;
	public void updateProjectFileList(HashMap map) throws Exception;
	
	
	public void updateProjectDtlList(HashMap map) throws Exception;
	public void deleteProjectDtlList(HashMap map) throws Exception;
	public void insertProjectDtlList(HashMap map) throws Exception;

	public void updateProjectScheduleList(HashMap map) throws Exception;
	public void deleteProjectScheduleList(HashMap map) throws Exception;
	public void insertProjectScheduleList(HashMap map) throws Exception;
	
	public void updateProjectTaxList(HashMap map) throws Exception;
	public void deleteProjectTaxList(HashMap map) throws Exception;
	public void insertProjectTaxList(HashMap map) throws Exception;
	

	public void deleteProjectList(HashMap map) throws Exception;
	public void deleteProjectDtlAll(HashMap map) throws Exception;
	public void deleteProjectScheduleAll(HashMap map) throws Exception;
	public void deleteProjectTaxAll(HashMap map) throws Exception;
	
	/**
	 * 프로젝트 스케쥴 정보
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> getUserProjectScheduleList(HashMap map) throws Exception; 
	
	/**
	 * 프로젝트 성과 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectProjectList3(HashMap map) throws Exception; 
}

