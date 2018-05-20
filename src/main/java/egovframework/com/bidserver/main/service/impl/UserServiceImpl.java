package egovframework.com.bidserver.main.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.main.service.UserService;


@Service("userService")
public class UserServiceImpl implements UserService {

	
	@Resource(name = "userInfoMapper")
	private UserInfoMapper userInfoMapper; 
	
	
	@Override
	public Map get(Map map) throws Exception {
		// TODO Auto-generated method stub
		return userInfoMapper.get(map);
	}
	
	public void update(Map map)throws Exception{
		userInfoMapper.update(map);
	}

}
