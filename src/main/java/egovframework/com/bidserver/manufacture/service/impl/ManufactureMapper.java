package egovframework.com.bidserver.manufacture.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 제조사관리
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

@Mapper("manufactureMapper")
public interface ManufactureMapper {
	/**
	 * 제조업체 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectManufactureList(HashMap map) throws Exception; 
	
	/**
	 * 제조업체 총갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getManufactureListCnt(HashMap map) throws Exception; 
	
	/**
	 * 제조업체 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteManufactureList(HashMap map) throws Exception; 
	
	
	/**
	 * 제조업체 등록 및 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateManufactureList(HashMap map) throws Exception; 
	
	/**
	 * 제조사 등록 업종 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectCompanyTypeList(HashMap map) throws Exception; 
	
	/**
	 * 업종 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectCompanyTypeTotalList(HashMap map) throws Exception; 
	
	/**
	 * 업종 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getCompanyTypeTotalCnt(HashMap map) throws Exception; 
	
	/**
	 * 제조사 업종 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateBizCompanyTypeList(HashMap map) throws Exception; 
	
	/**
	 * 제조사 업종 삭제
	 * @param map
	 * @throws Exception
	 */
	public void removeBizCompanyTypeList(HashMap map) throws Exception; 

	/**
	 * 제조사 등록 물품 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectGoodsTypeList(HashMap map) throws Exception; 
	
	/**
	 * 물품 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectGoodsTypeTotalList(HashMap map) throws Exception; 
	
	/**
	 * 물품 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getGoodsTypeTotalCnt(HashMap map) throws Exception; 
	
	/**
	 * 제조사 물품 리스트 등록
	 * @param map
	 * @throws Exception
	 */
	public void updateBizGoodsTypeList(HashMap map) throws Exception; 
	
	/**
	 * 제조사 물품 리스트 삭제
	 * @param map
	 * @throws Exception
	 */
	public void removeBizGoodsTypeList(HashMap map) throws Exception; 
	
	/**
	 * 제조사 등록 직생물품 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectGoodsDirectList(HashMap map) throws Exception; 
	
	/**
	 * 직생물품 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectGoodsDirectTotalList(HashMap map) throws Exception; 
	
	/**
	 * 직생물품 리스트 갯수
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int getGoodsDirectTotalCnt(HashMap map) throws Exception; 
	
	/**
	 * 제조사 직생물품 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateBizGoodsDirectList(HashMap map) throws Exception; 
	
	/**
	 * 제조사 직생물품 삭제
	 * @param map
	 * @throws Exception
	 */
	public void removeBizGoodsDirectList(HashMap map) throws Exception; 
	
	/**
	 * 견적이력 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBizHisList(HashMap map) throws Exception; 
	
	/**
	 * 견적보고서 리스트 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectBidReportList(HashMap map) throws Exception; 
	
	/**
	 * 공공구매정보망 기업 제조물품 리스트
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectGoodsTypeList2(HashMap map) throws Exception; 
	
	/**
	 * 제조사 의견 저장
	 * @param map
	 * @throws Exception
	 */
	public void updateManufactureBigo(HashMap map)  throws Exception; 
}
