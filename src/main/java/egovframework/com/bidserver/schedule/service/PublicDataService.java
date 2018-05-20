package egovframework.com.bidserver.schedule.service;

import java.util.HashMap;


public interface PublicDataService {
	public void getData() throws Exception;

	public void getData2() throws Exception;

	public void getData(String startDt) throws Exception;

	public void getResultData(String startDt) throws Exception;
	
	public void getData(String serviceName, String seviceDetailName, HashMap paramMap);
	
	public void getData2(String serviceName, String seviceDetailName, HashMap paramMap);
	
	public void removeBizGoodsDirectPastLimitDt(HashMap map) throws Exception;
	
	public void removeBizLicensePastLimitDt(HashMap map) throws Exception;
	
	public void updateScaleCdPastLimitDt(HashMap map) throws Exception;
	
	public void updateCreditCdPastLimitDt(HashMap map) throws Exception;
	
}
