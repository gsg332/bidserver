package egovframework.com.bidserver.notice.service;

import java.util.HashMap;
import java.util.List;

public interface NoticeService {

	/**
	 * 공지사항 정보 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectNoticeList(HashMap map) throws Exception;
	
	/**
	 * 공지사항 정보 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectNoticeList2(HashMap map) throws Exception;
	
	/**
	 * 공지사항 정보 총 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getNoticeListCnt(HashMap map) throws Exception;
	
	/**
	 * 공지사항 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertNoticeList(HashMap map) throws Exception;
	
	/**
	 * 공지사항 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateNoticeList(HashMap map) throws Exception;
	
	/**
	 * 공지사항 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteNoticeList(HashMap map) throws Exception;
	
	/**
	 * 공지사항 파일 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateNoticeFileList(HashMap map) throws Exception;
	
	/**
	 * 발신메세지 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectSendMsgList(HashMap map) throws Exception; 
	
	/**
	 * 발신메세지 총갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getSendMsgListCnt(HashMap map) throws Exception; 
	
}
