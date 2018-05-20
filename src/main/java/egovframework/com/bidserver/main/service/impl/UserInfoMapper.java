package egovframework.com.bidserver.main.service.impl;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("userInfoMapper")
public interface UserInfoMapper {
	
	public Map get(Map map) throws Exception; //
	
	public void update(Map map)throws Exception;

}
