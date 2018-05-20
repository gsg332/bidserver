package egovframework.com.bidserver.main.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.main.service.FileService;


@Service("fileService")
public class FileServiceImpl implements FileService {

	
	@Resource(name = "fileMapper")
	private FileMapper fileMapper; 
	
	
	@Override
	public HashMap detail(HashMap map) throws Exception {
		// TODO Auto-generated method stub
		return fileMapper.detail(map);
	}
	
	public void insert(HashMap map)throws Exception{
		fileMapper.insert(map);
	}
	

}
