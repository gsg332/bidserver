package egovframework.com.bidserver.admin.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.admin.service.AdminService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("adminService")
public class AdminServiceImpl extends EgovAbstractServiceImpl implements AdminService {

	@Resource(name = "adminMapper")
	private AdminMapper adminMapper;

	@Override
	public List<HashMap> selectUserList(HashMap map) throws Exception {
		return adminMapper.selectUserList(map);
	}
	
	@Override
	public int getUserListCnt(HashMap map) throws Exception {
		return adminMapper.getUserListCnt(map);
	}
	
	@Override
	public void insertUserList(HashMap map) throws Exception {
		adminMapper.insertUserList(map);
	}
	
	@Override
	public void updateUserList(HashMap map) throws Exception {
		adminMapper.updateUserList(map);
	}
	
	@Override
	public int chkUserId(HashMap map) throws Exception {
		return adminMapper.chkUserId(map);
	}
	
	@Override
	public int chkUserRole(HashMap map) throws Exception {
		return adminMapper.chkUserRole(map);
	}
	
	@Override
	public int isUser(HashMap map) throws Exception {
		return adminMapper.isUser(map);
	}
	
	@Override
	public int chgUserPwd(HashMap map) throws Exception {
		return adminMapper.chgUserPwd(map);
	}

	@Override
	public void deleteUserList(HashMap map) throws Exception {
		adminMapper.deleteUserList(map);
	}
	
	@Override
	public List<HashMap> selectCodeList(HashMap map) throws Exception {
		return adminMapper.selectCodeList(map);
	}
	
	@Override
	public int getCodeListCnt(HashMap map) throws Exception {
		return adminMapper.getCodeListCnt(map);
	}
	
	@Override
	public List<HashMap> selectCodeSubList(HashMap map) throws Exception {
		return adminMapper.selectCodeSubList(map);
	}
	
	@Override
	public List<HashMap> selectEvalList(HashMap map) throws Exception {
		return adminMapper.selectEvalList(map);
	}
	
	@Override
	public void updateEvalList(HashMap map) throws Exception {
		adminMapper.updateEvalList(map);
	}

	
	@Override
	public void insertCodeGrp(HashMap map) throws Exception {
		adminMapper.insertCodeGrp(map);
	}
	
	@Override
	public void updateCodeGrp(HashMap map) throws Exception {
		adminMapper.updateCodeGrp(map);
	}
	
	@Override
	public void deleteCodeGrp(HashMap map) throws Exception {
		adminMapper.deleteCodeGrp(map);
	}
	
	@Override
	public void insertCodeSub(HashMap map) throws Exception {
		adminMapper.insertCodeSub(map);
	}

	@Override
	public void updateCodeSub(HashMap map) throws Exception {
		adminMapper.updateCodeSub(map);
	}
	
	@Override
	public void deleteCodeSub(HashMap map) throws Exception {
		adminMapper.deleteCodeSub(map);
	}
	
	@Override
	public void deleteCodeSubAll(HashMap map) throws Exception {
		adminMapper.deleteCodeSubAll(map);
	}
	
	@Override
	public int chkCodeGrp(HashMap map) throws Exception {
		return adminMapper.chkCodeGrp(map);
	}
	
	@Override
	public int chkCodeSub(HashMap map) throws Exception {
		return adminMapper.chkCodeSub(map);
	}
	
	@Override
	public List<HashMap> selectBizTypeList(HashMap map) throws Exception {
		return adminMapper.selectBizTypeList(map);
	}
	
}
