package egovframework.com.bidserver.schedule.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import egovframework.com.bidserver.distribution.service.DistributionService;
import egovframework.com.bidserver.schedule.service.PublicDataService;

public class ScheduleController{    
	
	@Autowired(required=true)
	private PublicDataService publicDataService;
	
	@Resource(name = "distributionService")
	private DistributionService distributionService;
	
	public void dataBackUp() throws Exception{
		System.out.println(nowTime() + ": 데이터 백업 생성");
		publicDataService.getData();
        System.out.println(nowTime() + ": 데이터 백업 완료");
	}
	
	public void dataBackUp2() throws Exception{
		System.out.println(nowTime() + ": 데이터 백업 생성2");
		publicDataService.getData2();
		System.out.println(nowTime() + ": 데이터 백업 완료2");
	}
	
	public void disDrop() throws Exception{
		System.out.println(nowTime() + ": 공고분배 자동드랍 스케쥴러");
		HashMap map = null;
		distributionService.scheduleDrop(map);
	}
	
	public void joinCnt() throws Exception{
		System.out.println(nowTime() + ": 투찰업체수 스케쥴러");
		HashMap map = null;
		distributionService.scheduleJoinCnt(map);	
	}
	
	public String nowTime() throws Exception{
		Calendar nowTime = Calendar.getInstance();
        SimpleDateFormat sd = new SimpleDateFormat("[ yyyy-MM-dd hh:mm:ss ]");
        String strNowTime = sd.format(nowTime.getTime());
        
        return strNowTime;
	}
	
	public void limitCheck() throws Exception{
		System.out.println(nowTime() + ": 만료일 체크 및 정보 변경(또는 삭제)");
		HashMap map = null;
		publicDataService.removeBizGoodsDirectPastLimitDt(map);
		publicDataService.removeBizLicensePastLimitDt(map);
		publicDataService.updateScaleCdPastLimitDt(map);
		publicDataService.updateCreditCdPastLimitDt(map);
	}
	
}



