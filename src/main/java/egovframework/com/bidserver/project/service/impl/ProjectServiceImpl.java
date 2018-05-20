package egovframework.com.bidserver.project.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.project.service.ProjectService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("projectService")
public class ProjectServiceImpl extends EgovAbstractServiceImpl implements ProjectService {

	@Resource(name = "projectMapper")
	private ProjectMapper projectMapper;

	@Override
	public List<HashMap> selectProjectList(HashMap map) throws Exception {
		return projectMapper.selectProjectList(map);
	}
	
	@Override
	public List<HashMap> selectProjectList2(HashMap map) throws Exception {
		return projectMapper.selectProjectList2(map);
	}
	
	@Override
	public int getProjectListCnt(HashMap map) throws Exception {
		return projectMapper.getProjectListCnt(map);
	}
	
	@Override
	public List<HashMap> selectProjectDtlList(HashMap map) throws Exception {
		return projectMapper.selectProjectDtlList(map);
	}
	
	@Override
	public List<HashMap> selectProjectScheduleList(HashMap map) throws Exception {
		return projectMapper.selectProjectScheduleList(map);
	}
	
	@Override
	public List<HashMap> selectProjectTaxList(HashMap map) throws Exception {
		return projectMapper.selectProjectTaxList(map);
	}
	
	
	@Override
	public void updateProjectList(HashMap map) throws Exception {
		projectMapper.updateProjectList(map);
	}
	@Override
	public void updateProjectFileList(HashMap map) throws Exception {
		projectMapper.updateProjectFileList(map);
	}
	@Override
	public int insertProjectList(HashMap map) throws Exception {
		return projectMapper.insertProjectList(map);
	}

	@Override
	public void updateProjectDtlList(HashMap map) throws Exception {
		projectMapper.updateProjectDtlList(map);
	}
	@Override
	public void deleteProjectDtlList(HashMap map) throws Exception {
		projectMapper.deleteProjectDtlList(map);
	}
	@Override
	public void insertProjectDtlList(HashMap map) throws Exception {
		projectMapper.insertProjectDtlList(map);
	}
	
	@Override
	public void updateProjectScheduleList(HashMap map) throws Exception {
		projectMapper.updateProjectScheduleList(map);
	}
	@Override
	public void deleteProjectScheduleList(HashMap map) throws Exception {
		projectMapper.deleteProjectScheduleList(map);
	}
	@Override
	public void insertProjectScheduleList(HashMap map) throws Exception {
		projectMapper.insertProjectScheduleList(map);
	}
	
	@Override
	public void updateProjectTaxList(HashMap map) throws Exception {
		projectMapper.updateProjectTaxList(map);
	}
	@Override
	public void deleteProjectTaxList(HashMap map) throws Exception {
		projectMapper.deleteProjectTaxList(map);
	}
	@Override
	public void insertProjectTaxList(HashMap map) throws Exception {
		projectMapper.insertProjectTaxList(map);
	}

	@Override
	public void deleteProjectList(HashMap map) throws Exception {
		projectMapper.deleteProjectList(map);
	}
	@Override
	public void deleteProjectDtlAll(HashMap map) throws Exception {
		projectMapper.deleteProjectDtlAll(map);
	}
	@Override
	public void deleteProjectScheduleAll(HashMap map) throws Exception {
		projectMapper.deleteProjectScheduleAll(map);
	}
	@Override
	public void deleteProjectTaxAll(HashMap map) throws Exception {
		projectMapper.deleteProjectTaxAll(map);
	}
	
	
	@Override
	public List<HashMap> getUserProjectScheduleList(HashMap map) throws Exception {
		return projectMapper.getUserProjectScheduleList(map);
	}
	
	@Override
	public List<HashMap> selectProjectList3(HashMap map) throws Exception {
		return projectMapper.selectProjectList3(map);
	}
}
