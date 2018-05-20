package egovframework.com.bidserver.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.bidserver.main.service.ExcelUploadService;




@Service("excelUploadService")
@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
public class ExcelUploadServiceImpl implements ExcelUploadService  {

//	@Resource(name = "excelUploadDao")
//	private ExcelUploadDao excelUploadDao;
//
//	public List getList(Map map) throws Exception {
//		// TODO Auto-generated method stub
//		return excelUploadDao.getList(map);
//	}
//
//	public Map get(Map map) throws Exception {
//		// TODO Auto-generated method stub
//		return excelUploadDao.get(map);
//	}
//
//	public void create(Map map) throws Exception {
//		// TODO Auto-generated method stub
//		excelUploadDao.create(map);
//	}
//
//	public int update(Map map) throws Exception {
//		// TODO Auto-generated method stub
//		return excelUploadDao.update(map);
//	}
//
//	public void remove(Map map) throws Exception {
//		// TODO Auto-generated method stub
//		excelUploadDao.remove(map);
//	}
//
// 
//	public void startTransaction( ) throws Exception {
//		// TODO Auto-generated method stub
//		excelUploadDao.startTransaction();
//	}
//	
//	public void endTransaction( ) throws Exception {
//		// TODO Auto-generated method stub
//		excelUploadDao.endTransaction();
//	}

	
	

}
