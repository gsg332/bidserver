package egovframework.com.bidserver.main.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.ModelMap;


/**
 * 공통 인터페이스클래스를 정의한다.
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

public interface CmmnUtilService {
	
	public Object getMapToSearchVO(Map<String,Object> map,String className) throws Exception;
	
	public Object getMapToObject(Map<String,Object> map,String className,Map<String,Object> data) throws Exception;
	
	public List getMapsToList(List<Map<String,Object>> list,String className,Map<String,Object> data) throws Exception;
		
	public void download(ModelMap model, HttpServletRequest request, HttpServletResponse response)throws Exception;

}
