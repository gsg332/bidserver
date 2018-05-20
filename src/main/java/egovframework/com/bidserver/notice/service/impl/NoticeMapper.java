package egovframework.com.bidserver.notice.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 관리
 * 
 * @author 정진고
 * @since 2016.06.22
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2016.06.22  정진고          최초 생성
 * </pre>
 */

@Mapper("noticeMapper")
public interface NoticeMapper {

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
