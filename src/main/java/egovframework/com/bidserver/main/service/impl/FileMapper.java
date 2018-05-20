package egovframework.com.bidserver.main.service.impl;

import java.util.HashMap;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("fileMapper")
public interface FileMapper {
	
	public void insert(HashMap map)throws Exception;
	
	public HashMap detail(HashMap map)throws Exception;

}
