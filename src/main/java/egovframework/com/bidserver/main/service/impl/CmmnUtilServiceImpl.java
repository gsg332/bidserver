package egovframework.com.bidserver.main.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.com.bidserver.main.service.CmmnUtilService;
import egovframework.com.bidserver.util.DownloadUtil;
import egovframework.com.cmm.util.Utils;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 공토 구현체클래스를 정의한다.
 * @author 윤해석
 * @since 2015.08.07
 * @version 1.0
 * @see 
 * <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2015.08.07  윤해석          최초 생성
 * 
 * </pre>
 */

@Service("cmmnUtilService")
public class CmmnUtilServiceImpl extends EgovAbstractServiceImpl implements CmmnUtilService {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Resource(name="propertiesService")
	EgovPropertyService egovPropertyService;
	
	@Resource(name = "fileMapper")
	private FileMapper fileMapper; 
	
	@Override
	public Object getMapToSearchVO(Map<String,Object> map,String className) throws Exception {
		
		Class clazz = Class.forName(className);
		Object theObject = clazz.newInstance();
		Object target = Utils.convertMapToObject(map,theObject);
		return target;
	}
	
	@Override
	public Object getMapToObject(Map<String,Object> map,String className,Map<String,Object> data) throws Exception {
		
		String loginKey = (String)data.get("loginKey");
		
		Class clazz = Class.forName(className);
		Class[] paramTypes = new Class[] {String.class};
		
		java.lang.reflect.Method dyMethod1 = null;
		try {
			dyMethod1 = clazz.getMethod("setRegisterSn",paramTypes);
		} catch (NoSuchMethodException ne) {
			logger.debug("setRegisterSn이 존재하지 않습니다.");
		}
		
		java.lang.reflect.Method dyMethod2 = null;
		try {
			dyMethod2 = clazz.getMethod("setUpdusrSn",paramTypes);
		} catch (NoSuchMethodException ne) {
			logger.debug("setUpdusrSn이 존재하지 않습니다.");
		}
		
        
		Object theObject = clazz.newInstance();
		
	    Object[] parameters = { loginKey };
	      
	    dyMethod1.invoke(theObject, parameters);
	    dyMethod2.invoke(theObject, parameters);

		Object target = Utils.convertMapToObject(map,theObject);
		return target;
	}
	
	@Override
	public List getMapsToList(List<Map<String,Object>> list,String className,Map<String,Object> data) throws Exception {
		
		List arrayList = new ArrayList(); 
		
		
		String loginKey = (String)data.get("loginKey");
		
		if(list!=null) {
	        int listCnt = list.size();
	        
			for(int i=0;i<list.size();i++) {
				Map map =(HashMap)list.get(i);
				
				Class clazz = Class.forName(className);
				Class[] paramTypes = new Class[] {String.class};
				
				java.lang.reflect.Method dyMethod1 = null;
				try {
					dyMethod1 = clazz.getMethod("setRegisterSn",paramTypes);
				} catch (NoSuchMethodException ne) {
					logger.debug("setRegisterSn이 존재하지 않습니다.");
				}
				
				java.lang.reflect.Method dyMethod2 = null;
				try {
					dyMethod2 = clazz.getMethod("setUpdusrSn",paramTypes);
				} catch (NoSuchMethodException ne) {
					logger.debug("setUpdusrSn이 존재하지 않습니다.");
				}
				
	            
				Object theObject = clazz.newInstance();
				
			    Object[] parameters = { loginKey };
			      
			    dyMethod1.invoke(theObject, parameters);
			    dyMethod2.invoke(theObject, parameters);
	
				Object target = Utils.convertMapToObject(map,theObject);
				
				arrayList.add(target);
			}
		}
		
		return arrayList;
	}
	
	@Override
	public void download(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{
			HashMap map = new HashMap();
			map.put("file_id", request.getParameter("file_id"));
			
			HashMap fileMap = fileMapper.detail(map);
			if(fileMap !=null){
				DownloadUtil downloadUtil = new DownloadUtil(egovPropertyService);
				String fileStorePath = egovPropertyService.getString("Globals.fileStorePath");
				//fileStorePath += fileStorePath.indexOf("\\\\")>=0?((String)fileMap.get("filePath")).replaceAll("/", "\\\\\\\\"):((String)fileMap.get("filePath")).replaceAll("\\", "/");
				fileStorePath += (String)fileMap.get("file_path");
				System.out.println(fileStorePath);
				downloadUtil.download(request, response, fileStorePath+(String)fileMap.get("real_file_name"), (String)fileMap.get("org_file_name"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
}
