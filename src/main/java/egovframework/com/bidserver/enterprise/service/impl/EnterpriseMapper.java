package egovframework.com.bidserver.enterprise.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 입찰관리
 * 
 * @author 정진고
 * @since 2016.03.01
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * 
 * </pre>
 */

@Mapper("enterpriseMapper")
public interface EnterpriseMapper {

	public List<HashMap> selectManufactureList(HashMap map) throws Exception; 

	public int getManufactureListCnt(HashMap map) throws Exception;
	
	public void insertManufacture(HashMap map) throws Exception;
	
	public void updateManufacture(HashMap map) throws Exception; 
	
	public void deleteManufacture(HashMap map) throws Exception; 
	
	public void deleteBusiness(HashMap map) throws Exception; 
	
	public List<HashMap> selectBizHisList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBizNotiHisList(HashMap map) throws Exception; 
	
	public void insertBizNotiHisList(HashMap map) throws Exception; 
	
	public void updateBizNotiHisList(HashMap map) throws Exception; 
	
	public void deleteBizNotiHisList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBidReportList(HashMap map) throws Exception; 
	
	public int insertBusiness(HashMap map) throws Exception;
	
	public void deleteCompanyType(HashMap map) throws Exception; 
	
	public void insertCompanyType(HashMap map) throws Exception; 
	
	public void deleteGoodsType(HashMap map) throws Exception; 
	
	public void insertGoodsType(HashMap map) throws Exception; 
	
	public void deleteGoodsDirectType(HashMap map) throws Exception; 
	
	public void insertGoodsDirectType(HashMap map) throws Exception; 
	
	public int insertBusinessDetail(HashMap map) throws Exception;
	
	public int insertCompanylicense(HashMap map) throws Exception;
	
	public List<HashMap> selectComboEvalList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBusinessList(HashMap map) throws Exception; 
	
	public List<HashMap> selectBusinessDtlList(HashMap map) throws Exception; 
	
	public int getBusinessListCnt(HashMap map) throws Exception; 
	
	public List<HashMap> selectLicenseList(HashMap map) throws Exception; 
	
	public void removeLicenseList(HashMap map) throws Exception; 
	
	public List<HashMap> selectLicenseTotalList(HashMap map) throws Exception; 
	
	public void updateLicenseList(HashMap map) throws Exception;
	
	public List<HashMap> selectCompanyTypeList(HashMap map) throws Exception; 
	
	public void removeBizCompanyTypeList(HashMap map) throws Exception; 
	
	public List<HashMap> selectGoodsTypeList(HashMap map) throws Exception; 
	
	public List<HashMap> selectGoodsTypeTotalList(HashMap map) throws Exception; 
	
	public int getGoodsTypeTotalCnt(HashMap map) throws Exception; 
	
	public void updateBizGoodsTypeList(HashMap map) throws Exception;
	
	public void removeBizGoodsTypeList(HashMap map) throws Exception; 
	
	public List<HashMap> selectGoodsDirectList(HashMap map) throws Exception; 
	
	public List<HashMap> selectGoodsDirectTotalList(HashMap map) throws Exception; 
	
	public int getGoodsDirectTotalCnt(HashMap map) throws Exception; 
	
	public void updateBizGoodsDirectList(HashMap map) throws Exception; 

	public void removeBizGoodsDirectList(HashMap map) throws Exception; 
	
	public List<HashMap> selectCompanyTypeTotalList(HashMap map) throws Exception; 
	
	public List<HashMap> selectLicenseTypeTotalList(HashMap map) throws Exception; 
	
	public int getCompanyTypeTotalCnt(HashMap map) throws Exception; 
	
	public void updateBizCompanyTypeList(HashMap map) throws Exception; 
	
	public void updateCompanyFileList(HashMap map) throws Exception;
	
	public List<HashMap> selectFileDtl(HashMap map) throws Exception; 
	
	/**
	 * 투찰사 등록 및 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateBusinessList(HashMap map) throws Exception; 
	
	public void updateBusinessList2(HashMap map) throws Exception;
	
	public List<HashMap> selectBusinessExcelList(HashMap map) throws Exception;
	
	public int updateGoodsDirectType(HashMap map) throws Exception; 
	
	public int updateBusinessLicense(HashMap map) throws Exception;
	
	public int deleteBusinessDetail(HashMap map) throws Exception;
	
	public int deleteBusinessGoods(HashMap map) throws Exception;
	
	public int deleteBusinessGoodsDirect(HashMap map) throws Exception;
	
	public int deleteBusinessLicense(HashMap map) throws Exception;
	
	public int deleteBusinessType(HashMap map) throws Exception;
	
	public int deleteBusinessCreditDegree(HashMap map) throws Exception;
}
