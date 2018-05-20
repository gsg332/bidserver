package egovframework.com.bidserver.notice.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.notice.service.NoticeService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("noticeService")
public class NoticeServiceImpl extends EgovAbstractServiceImpl implements NoticeService {

	@Resource(name = "noticeMapper")
	private NoticeMapper noticeMapper;

	@Override
	public List<HashMap> selectNoticeList(HashMap map) throws Exception {
		return noticeMapper.selectNoticeList(map);
	}

	@Override
	public List<HashMap> selectNoticeList2(HashMap map) throws Exception {
		return noticeMapper.selectNoticeList2(map);
	}
	
	@Override
	public int getNoticeListCnt(HashMap map) throws Exception {
		return noticeMapper.getNoticeListCnt(map);
	}
	
	@Override
	public void insertNoticeList(HashMap map) throws Exception {
		noticeMapper.insertNoticeList(map);
	}
	
	@Override
	public void updateNoticeList(HashMap map) throws Exception {
		noticeMapper.updateNoticeList(map);
	}
	
	@Override
	public void deleteNoticeList(HashMap map) throws Exception {
		noticeMapper.deleteNoticeList(map);
	}
	
	@Override
	public void updateNoticeFileList(HashMap map) throws Exception {
		noticeMapper.updateNoticeFileList(map);
	}
	
	@Override
	public List<HashMap> selectSendMsgList(HashMap map) throws Exception {
		return noticeMapper.selectSendMsgList(map);
	}
	
	@Override
	public int getSendMsgListCnt(HashMap map) throws Exception {
		return noticeMapper.getSendMsgListCnt(map);
	}
}
