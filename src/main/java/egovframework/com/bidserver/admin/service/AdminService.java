package egovframework.com.bidserver.admin.service;

import java.util.HashMap;
import java.util.List;

public interface AdminService {

	/**
	 * 사용자 정보 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectUserList(HashMap map) throws Exception;
	
	/**
	 * 사용자 정보 총 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getUserListCnt(HashMap map) throws Exception;
	
	/**
	 * 사용자 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertUserList(HashMap map) throws Exception;
	
	/**
	 * 사용자 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateUserList(HashMap map) throws Exception;
	
	/**
	 * 사용자 아이디 체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int chkUserId(HashMap map) throws Exception;
	
	/**
	 * 사용자 룰 중복 체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int chkUserRole(HashMap map) throws Exception;
	
	/**
	 * 사용자 등록 여부 체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int isUser(HashMap map) throws Exception;
	
	/**
	 * 비밀번호 변경
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int chgUserPwd(HashMap map) throws Exception;
	
	/**
	 * 사용자 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteUserList(HashMap map) throws Exception;
	
	/**
	 * 공통코드 그룹 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectCodeList(HashMap map) throws Exception;
	
	/**
	 * 공통코드 그룹 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getCodeListCnt(HashMap map) throws Exception; 
	
	/**
	 * 공통코드 상세 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectCodeSubList(HashMap map) throws Exception;
	
	/**
	 * 적격심사정보 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectEvalList(HashMap map) throws Exception;
	
	/**
	 * 적격심사 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateEvalList(HashMap map) throws Exception;
	
	/**
	 * 공통코드 그룹 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertCodeGrp(HashMap map) throws Exception;
	
	/**
	 * 공통코드 그룹 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateCodeGrp(HashMap map) throws Exception;
	
	/**
	 * 공통코드 그룹 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteCodeGrp(HashMap map) throws Exception;

	/**
	 * 공통코드 상세 코드 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertCodeSub(HashMap map) throws Exception;
	
	/**
	 * 공통코드 상세 코드 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateCodeSub(HashMap map) throws Exception;
	
	/**
	 * 공통코드 상세 코드 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteCodeSub(HashMap map) throws Exception;
	
	/**
	 * 공통코드 상세 코드 그룹 전체 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteCodeSubAll(HashMap map) throws Exception;
	

	/**
	 * 공통코드  중복 체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int chkCodeGrp(HashMap map) throws Exception;
	
	/**
	 * 공통코드 상세 코드 중복 체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int chkCodeSub(HashMap map) throws Exception;
	
	/**
	 * 업종코드 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBizTypeList(HashMap map) throws Exception;
}
