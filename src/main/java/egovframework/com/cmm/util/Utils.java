package egovframework.com.cmm.util;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;



/**
 * parameter check를 위한 Util
 * @author 윤해석
 * @since 2015.08.18
 * @version 1.0
 * @see 
 */

public class Utils {
	
	public static boolean checkNull(Object param) {
		if (param != null) {
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean isCompare(String srcParam,String targetParam) {
		if(srcParam==null || srcParam.equals("") ) {
			if(targetParam == null || targetParam.equals("")) {
				return true;
			} else {
				return false;
			}
		} else {
			if(srcParam.equals(targetParam)) {
				return true;
			} else {
				return false;
			}
		}
	}
	
	public static Map ConverObjectToMap(Object obj){
        try {
            //Field[] fields = obj.getClass().getFields(); //private field는 나오지 않음.
            Field[] fields = obj.getClass().getDeclaredFields();
            Map resultMap = new HashMap();
            for(int i=0; i<=fields.length-1;i++){
                fields[i].setAccessible(true);
                resultMap.put(fields[i].getName(), fields[i].get(obj));
            }
            return resultMap;
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return null;
    }

	public static Object convertMapToObject(Map map, Object objClass) {
        String keyAttribute = null;
        String setMethodString = "set";
        String methodString = null;
        Iterator itr = map.keySet().iterator();
        while(itr.hasNext()){
            keyAttribute = (String) itr.next();
            methodString = setMethodString+keyAttribute.substring(0,1).toUpperCase()+keyAttribute.substring(1);
            try {
                java.lang.reflect.Method[] methods = objClass.getClass().getDeclaredMethods();
                for(int i=0;i<=methods.length-1;i++){
                    if(methodString.equals(methods[i].getName())){
                        //System.out.println("invoke : "+methodString);
                        methods[i].invoke(objClass, map.get(keyAttribute));
                    }
                }
            } catch (SecurityException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        return objClass;
    }
	
	public static List<Object> convertMapsToList(List<Map<String,Object>> list,List<Object> objList) throws Exception {

        List<Object> targetList = new ArrayList<Object>();
        
		for(int i=0;i<list.size();i++) {
			Map map = (Map)list.get(i);
			Object objClass = (Object)objList.get(i);
			
			Object targetObj = convertMapToObject(map, objClass);    	
			targetList.add(targetObj);
    	}
    
        return targetList;
	}
}
