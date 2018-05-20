package egovframework.com.bidserver.manufacture.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.manufacture.service.ManufactureService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("manufactureService")
public class ManufactureServiceImpl extends EgovAbstractServiceImpl implements ManufactureService {

	@Resource(name = "manufactureMapper")
	private ManufactureMapper manufactureMapper;

	@Override
	public List<HashMap> selectManufactureList(HashMap map) throws Exception {
		return manufactureMapper.selectManufactureList(map);
	}
	
	@Override
	public int getManufactureListCnt(HashMap map) throws Exception {
		return manufactureMapper.getManufactureListCnt(map);
	}
	
	@Override
	public void deleteManufactureList(HashMap map) throws Exception {
		manufactureMapper.deleteManufactureList(map);
	}
	
	@Override
	public void updateManufactureList(HashMap map) throws Exception {
		manufactureMapper.updateManufactureList(map);
	}

	@Override
	public List<HashMap> selectCompanyTypeList(HashMap map) throws Exception {
		return manufactureMapper.selectCompanyTypeList(map);
	}
	
	@Override
	public List<HashMap> selectCompanyTypeTotalList(HashMap map) throws Exception {
		return manufactureMapper.selectCompanyTypeTotalList(map);
	}

	@Override
	public int getCompanyTypeTotalCnt(HashMap map) throws Exception {
		return manufactureMapper.getCompanyTypeTotalCnt(map);
	}
	
	@Override
	public void updateBizCompanyTypeList(HashMap map) throws Exception {
		manufactureMapper.updateBizCompanyTypeList(map);
	}
	
	@Override
	public void removeBizCompanyTypeList(HashMap map) throws Exception {
		manufactureMapper.removeBizCompanyTypeList(map);
	}

	@Override
	public List<HashMap> selectGoodsTypeList(HashMap map) throws Exception {
		return manufactureMapper.selectGoodsTypeList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsTypeTotalList(HashMap map) throws Exception {
		return manufactureMapper.selectGoodsTypeTotalList(map);
	}

	@Override
	public int getGoodsTypeTotalCnt(HashMap map) throws Exception {
		return manufactureMapper.getGoodsTypeTotalCnt(map);
	}
	
	@Override
	public void updateBizGoodsTypeList(HashMap map) throws Exception {
		manufactureMapper.updateBizGoodsTypeList(map);
	}
	
	@Override
	public void removeBizGoodsTypeList(HashMap map) throws Exception {
		manufactureMapper.removeBizGoodsTypeList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsDirectList(HashMap map) throws Exception {
		return manufactureMapper.selectGoodsDirectList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsDirectTotalList(HashMap map) throws Exception {
		return manufactureMapper.selectGoodsDirectTotalList(map);
	}
	
	@Override
	public int getGoodsDirectTotalCnt(HashMap map) throws Exception {
		return manufactureMapper.getGoodsDirectTotalCnt(map);
	}
	
	@Override
	public void updateBizGoodsDirectList(HashMap map) throws Exception {
		manufactureMapper.updateBizGoodsDirectList(map);
	}
	
	@Override
	public void removeBizGoodsDirectList(HashMap map) throws Exception {
		manufactureMapper.removeBizGoodsDirectList(map);
	}
	
	@Override
	public List<HashMap> selectBizHisList(HashMap map) throws Exception {
		return manufactureMapper.selectBizHisList(map);
	}
	
	@Override
	public List<HashMap> selectBidReportList(HashMap map) throws Exception {
		return manufactureMapper.selectBidReportList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsTypeList2(HashMap map) throws Exception {
		return manufactureMapper.selectGoodsTypeList2(map);
	}
	
	@Override
	public void updateManufactureBigo(HashMap map) throws Exception {
		manufactureMapper.updateManufactureBigo(map);
	}
}
