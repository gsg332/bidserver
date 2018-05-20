package egovframework.com.bidserver.enterprise.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.bidserver.enterprise.service.EnterpriseService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("enterpriseService")
public class EnterpriseServiceImpl extends EgovAbstractServiceImpl implements EnterpriseService {

	@Resource(name = "enterpriseMapper")
	private EnterpriseMapper enterpriseMapper;
	
	@Resource(name = "enterpriseService")
	private EnterpriseService enterpriseService;
	
	@Override
	public List<HashMap> selectManufactureList(HashMap map) throws Exception {
		return enterpriseMapper.selectManufactureList(map);
	}
	
	@Override
	public int getManufactureListCnt(HashMap map) throws Exception {
		return enterpriseMapper.getManufactureListCnt(map);
	}
	
	@Override
	public void insertManufacture(HashMap map) throws Exception {
		enterpriseMapper.insertManufacture(map);
	}
	
	@Override
	public void updateManufacture(HashMap map) throws Exception {
		enterpriseMapper.updateManufacture(map);
	}
	
	@Override
	public void deleteManufacture(HashMap map) throws Exception {
		enterpriseMapper.deleteManufacture(map);
	}
	
	@Override
	public void deleteBusiness(HashMap map) throws Exception {
		enterpriseMapper.deleteBusiness(map);
	}
	
	@Override
	public List<HashMap> selectBizHisList(HashMap map) throws Exception {
		return enterpriseMapper.selectBizHisList(map);
	}
	
	@Override
	public List<HashMap> selectBizNotiHisList(HashMap map) throws Exception {
		return enterpriseMapper.selectBizNotiHisList(map);
	}
	
	@Override
	public void insertBizNotiHisList(HashMap map) throws Exception {
		enterpriseMapper.insertBizNotiHisList(map);
	}
	
	@Override
	public void updateBizNotiHisList(HashMap map) throws Exception {
		enterpriseMapper.updateBizNotiHisList(map);
	}
	
	@Override
	public void deleteBizNotiHisList(HashMap map) throws Exception {
		enterpriseMapper.deleteBizNotiHisList(map);
	}
	
	@Override
	public List<HashMap> selectBidReportList(HashMap map) throws Exception {
		return enterpriseMapper.selectBidReportList(map);
	}
	
	@Override
	public int insertBusiness(HashMap map) throws Exception {
		return (Integer)enterpriseMapper.insertBusiness(map);
	}
	
	@Override
	public void deleteCompanyType(HashMap map) throws Exception {
		enterpriseMapper.deleteCompanyType(map);
	}
	
	@Override
	public void insertCompanyType(HashMap map) throws Exception {
		enterpriseMapper.insertCompanyType(map);
	}
	
	@Override
	public void deleteGoodsType(HashMap map) throws Exception {
		enterpriseMapper.deleteGoodsType(map);
	}
	
	@Override
	public void insertGoodsType(HashMap map) throws Exception {
		enterpriseMapper.insertGoodsType(map);
	}
	
	@Override
	public void deleteGoodsDirectType(HashMap map) throws Exception {
		enterpriseMapper.deleteGoodsDirectType(map);
	}
	
	@Override
	public void insertGoodsDirectType(HashMap map) throws Exception {
		enterpriseMapper.insertGoodsDirectType(map);
	}
	
	@Override
	public void insertBusinessDetail(HashMap map) throws Exception {
		enterpriseMapper.insertBusinessDetail(map);
	}
	
	@Override
	public void insertCompanylicense(HashMap map) throws Exception {
		enterpriseMapper.insertCompanylicense(map);
	}
	
	@Override
	public List<HashMap> selectComboEvalList(HashMap map) throws Exception {
		return enterpriseMapper.selectComboEvalList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessList(HashMap map) throws Exception {
		return enterpriseMapper.selectBusinessList(map);
	}
	
	@Override
	public List<HashMap> selectBusinessDtlList(HashMap map) throws Exception {
		return enterpriseMapper.selectBusinessDtlList(map);
	}
	
	@Override
	public int getBusinessListCnt(HashMap map) throws Exception {
		return enterpriseMapper.getBusinessListCnt(map);
	}
	
	@Override
	public List<HashMap> selectLicenseList(HashMap map) throws Exception {
		return enterpriseMapper.selectLicenseList(map);
	}
	
	@Override
	public void removeLicenseList(HashMap map) throws Exception {
		enterpriseMapper.removeLicenseList(map);
	}
	
	@Override
	public List<HashMap> selectLicenseTotalList(HashMap map) throws Exception {
		return enterpriseMapper.selectLicenseTotalList(map);
	}
	
	@Override
	public void updateLicenseList(HashMap map) throws Exception {
		enterpriseMapper.updateLicenseList(map);
	}
	
	@Override
	public List<HashMap> selectCompanyTypeList(HashMap map) throws Exception {
		return enterpriseMapper.selectCompanyTypeList(map);
	}
	
	@Override
	public void removeBizCompanyTypeList(HashMap map) throws Exception {
		enterpriseMapper.removeBizCompanyTypeList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsTypeList(HashMap map) throws Exception {
		return enterpriseMapper.selectGoodsTypeList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsTypeTotalList(HashMap map) throws Exception {
		return enterpriseMapper.selectGoodsTypeTotalList(map);
	}
	
	@Override
	public int getGoodsTypeTotalCnt(HashMap map) throws Exception {
		return enterpriseMapper.getGoodsTypeTotalCnt(map);
	}
	
	@Override
	public void updateBizGoodsTypeList(HashMap map) throws Exception {
		enterpriseMapper.updateBizGoodsTypeList(map);
	}
	
	@Override
	public void removeBizGoodsTypeList(HashMap map) throws Exception {
		enterpriseMapper.removeBizGoodsTypeList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsDirectList(HashMap map) throws Exception {
		return enterpriseMapper.selectGoodsDirectList(map);
	}
	
	@Override
	public List<HashMap> selectGoodsDirectTotalList(HashMap map) throws Exception {
		return enterpriseMapper.selectGoodsDirectTotalList(map);
	}
	
	@Override
	public int getGoodsDirectTotalCnt(HashMap map) throws Exception {
		return enterpriseMapper.getGoodsDirectTotalCnt(map);
	}
	
	@Override
	public void updateBizGoodsDirectList(HashMap map) throws Exception {
		enterpriseMapper.updateBizGoodsDirectList(map);
	}
	
	@Override
	public void removeBizGoodsDirectList(HashMap map) throws Exception {
		enterpriseMapper.removeBizGoodsDirectList(map);
	}
	
	@Override
	public List<HashMap> selectCompanyTypeTotalList(HashMap map) throws Exception {
		return enterpriseMapper.selectCompanyTypeTotalList(map);
	}
	
	@Override
	public List<HashMap> selectLicenseTypeTotalList(HashMap map) throws Exception {
		return enterpriseMapper.selectLicenseTypeTotalList(map);
	}
	
	@Override
	public int getCompanyTypeTotalCnt(HashMap map) throws Exception {
		return enterpriseMapper.getCompanyTypeTotalCnt(map);
	}
	
	@Override
	public void updateBizCompanyTypeList(HashMap map) throws Exception {
		enterpriseMapper.updateBizCompanyTypeList(map);
	}
	
	@Override
	public void updateCompanyFileList(HashMap map) throws Exception {
		enterpriseMapper.updateCompanyFileList(map);
	}
	
	@Override
	public List<HashMap> selectFileDtl(HashMap map) throws Exception {
		return enterpriseMapper.selectFileDtl(map);
	}
	
	@Override
	public void updateBusinessList(HashMap map) throws Exception {
		enterpriseMapper.updateBusinessList(map);
	}
	
	@Override
	public void updateBusinessList2(HashMap map) throws Exception {
		enterpriseMapper.updateBusinessList2(map);
	}
	
	@Override
	public List<HashMap> selectBusinessExcelList(HashMap map) throws Exception {
		return enterpriseMapper.selectBusinessExcelList(map);
	}
	
	@Override
	public int updateGoodsDirectType(HashMap map) throws Exception {
		return enterpriseMapper.updateGoodsDirectType(map);
	}
	
	@Override
	public int updateBusinessLicense(HashMap map) throws Exception {
		return enterpriseMapper.updateBusinessLicense(map);
	}
	
	@Override
	public int deleteBusinessDetail(HashMap map) throws Exception {
		return enterpriseMapper.deleteBusinessDetail(map);
	}
	
	@Override
	public int deleteBusinessGoods(HashMap map) throws Exception {
		return enterpriseMapper.deleteBusinessGoods(map);
	}
	
	@Override
	public int deleteBusinessGoodsDirect(HashMap map) throws Exception {
		return enterpriseMapper.deleteBusinessGoodsDirect(map);
	}
	
	@Override
	public int deleteBusinessLicense(HashMap map) throws Exception {
		return enterpriseMapper.deleteBusinessLicense(map);
	}
	
	@Override
	public int deleteBusinessType(HashMap map) throws Exception {
		return enterpriseMapper.deleteBusinessType(map);
	}
	
	@Override
	public int deleteBusinessCreditDegree(HashMap map) throws Exception {
		return enterpriseMapper.deleteBusinessCreditDegree(map);
	}
	
}
