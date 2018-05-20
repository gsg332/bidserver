package egovframework.com.bidserver.util;


import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.bidserver.main.entity.FileVO;
import egovframework.rte.fdl.property.EgovPropertyService;

public class FileUtil {
	public final String[] UPLOADABLE_IMAGE_TYPES = new String[]{"gif", "jpg", "jpeg", "png"};
	public final String[] UPLOADABLE_DOC_TYPE = new String[]{"doc","docx","hwp","xls","xlsx","ppt","pptx","ods","zip"};
	
	private String UPLOAD_URL;// = egovPropertyService.getString("Globals.fileStorePath");
	
	private String SEPARATOR;// = File.separator;
	
	public FileUtil(EgovPropertyService egovPropertyService){
		UPLOAD_URL = egovPropertyService.getString("Globals.fileStorePath");
		SEPARATOR = File.separator;
	}
	
	/**
	 * bean에 담겨진 데이터를 기준으로 하여 uploadDir를 기준으로 하여 하단의 모듈별 디렉토리에 날짜별로 디렉토리를 생성하여
	 * 랜덤한 파일명으로 파일을 생성한후 해당경로를 반환한다.
	 * @return FileBean의 목록
	 */
	public ArrayList<FileVO> transferFile(List<MultipartFile> files,String moduleName) throws Throwable{		
		
		ArrayList<FileVO> fileList = new ArrayList<FileVO>();
		for(int i =0 ;i < files.size() ; i++){
			MultipartFile mFile = files.get(i);			
			FileVO fileBean = transferFile(mFile, moduleName);
			
			if(fileBean != null){
				fileBean.setFileOrder(i);
				fileList.add(fileBean);
			}
		}
		
		return fileList;
	}
	
	/**
	 * transferFile 함수와 같으나 단일 작업을 실행 한다.
	 * @param mFile
	 * @param moduleName
	 */
	public FileVO transferFile(MultipartFile mFile,String moduleName) throws Throwable{
		
		String uploadDir = createFolderByMakingRule(UPLOAD_URL, moduleName);
		
		if(!mFile.isEmpty()){
			FileVO fileBean = new FileVO();
			
			fileBean.setOrgFileName(mFile.getOriginalFilename());
			fileBean.setFileExt(getFileType(mFile.getOriginalFilename()));
			fileBean.setRealFilePath(uploadDir);
			fileBean.setFilePath(StringUtil.replace(uploadDir, UPLOAD_URL, ""));
			fileBean.setRealFileName(UUID.randomUUID().toString());
			fileBean.setFileSize(mFile.getSize());
			
			File file = new File(uploadDir+fileBean.getRealFileName());
			
			mFile.transferTo(file);
			
			return fileBean;
		}else{
			return null;
		}
		
	}
	
	/**
	 * 입력받은 파일 이름에서 파일 확장자를 추출한다.
	 *
	 * @param fileName
	 *            파일 명
	 * @return String 입력받은 파일 명에서 파일 확장자를 추출하여 반환 하거나 입력받은 파일 명이 null이라면 null을
	 *         확장자를 추출할수 없다면 빈문자열을 반환한다.
	 */
	public static String getFileType(String fileName) {
		String fileExt = null;
		if (fileName != null) {
			int offset = fileName.lastIndexOf(".");
			if ((offset != -1) && (offset != fileName.length())) {
				fileExt = fileName.substring(offset + 1);
			} else {
				fileExt = "";
			}
		}

		return fileExt;
	}
	
	/**
	 * 파일 업로드용 폴더 만들기(baseDir + mode + yyyy + m + dd).
	 *
	 * @param baseDir String
	 * @param mode String
	 * @param year int
	 * @param month int
	 * @param date int
	 */
	public void makeFolder(String baseDir, String mode, int year, int month, int date) {
		makeFolder(baseDir, mode, String.valueOf(year), String.valueOf(month), String.valueOf(date), null);
	}
	
	public void makeFolder(String baseDir, String mode, int year, int month, int date, String cmpId) {
		makeFolder(baseDir, mode, String.valueOf(year), String.valueOf(month), String.valueOf(date), cmpId);
	}
	/**
	 * 폴더를 생성한다.
	 *
	 * @param dirPath String
	 */
	public void makeFolder(String dirPath) {
		File dir = new File(dirPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
	}


	/**
	 * 파일 업로드용 폴더 만들기(baseDir + mode + yyyy + m + dd).
	 *
	 * @param baseDir String
	 * @param mode String
	 * @param year String
	 * @param month String
	 * @param date String
	 */
	public void makeFolder(String baseDir, String mode, String year, String month, String date, String cmpId) {
		String tMonth = StringUtil.leftPad(month, 2, "0");
		String tDate = StringUtil.leftPad(date, 2, "0");

		String sep = System.getProperty("file.separator");
		StringBuffer sb = new StringBuffer();
		sb.append(baseDir);

		File dir = null;
		if(mode.indexOf("/") != -1){
			String[] modeArr = mode.split("/");
			for(int i=0; i<modeArr.length; i++){
				sb.append(modeArr[i]);
				sb.append(sep);
				makeFolder(sb.toString());
			}
		}else{
			sb.append(sep);
			sb.append(mode);
			makeFolder(sb.toString());
		}
		sb.append(sep);
		sb.append(year);
		makeFolder(sb.toString());

		sb.append(sep);
		sb.append(tMonth);
		makeFolder(sb.toString());

		sb.append(sep);
		sb.append(tDate);
		makeFolder(sb.toString());
	}
	
	/**
	 * 파일생성 규칙에 따라 폴더생성.
	 *
	 * @param baseDir String
	 * @param modeName String
	 * @return the string
	 */
	public String createFolderByMakingRule(String baseDir, String modeName){
		makeFolder(baseDir);
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int date = calendar.get(Calendar.DATE);

		String tMonth = String.valueOf(month);
		if (month < 10) {
			tMonth = "0" + month;
		}

		String tDate = String.valueOf(date);
		if (date < 10) {
			tDate = "0" + date;
		}
		StringBuffer filePathSb = new StringBuffer();
		filePathSb.append(baseDir);

		if(!(baseDir.endsWith(SEPARATOR) || baseDir.endsWith("/") || baseDir.endsWith("\\")) ){
			filePathSb.append(SEPARATOR);
		}
		
		if(modeName.indexOf("/") != -1){
			String[] modeArr = StringUtil.split(modeName, "/");
			for(int i=0; i<modeArr.length; i++){
				System.out.println("modeArr[i]" + modeArr[i]);
				filePathSb.append(modeArr[i]);
				filePathSb.append(SEPARATOR);
				System.out.println("filePathSb ==> " + filePathSb.toString());
			}
		}
		else{
			filePathSb.append(modeName).append(SEPARATOR);
		}
		
		filePathSb.append(year).append(SEPARATOR)
		        .append(tMonth).append(SEPARATOR)
		        .append(tDate).append(SEPARATOR);
		makeFolder(baseDir, modeName, year, month, date);

		return filePathSb.toString();
	}
	
	public String createFolderByMakingRule(String baseDir, String modeName, String cmpId){
		makeFolder(baseDir);
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int date = calendar.get(Calendar.DATE);

		String tMonth = String.valueOf(month);
		if (month < 10) {
			tMonth = "0" + month;
		}

		String tDate = String.valueOf(date);
		if (date < 10) {
			tDate = "0" + date;
		}
		StringBuffer filePathSb = new StringBuffer();
		filePathSb.append(baseDir);

		if(!(baseDir.endsWith(SEPARATOR) || baseDir.endsWith("/") || baseDir.endsWith("\\")) ){
			filePathSb.append(SEPARATOR);
		}
		filePathSb.append(modeName).append(SEPARATOR)
		        .append(year).append(SEPARATOR)
		        .append(tMonth).append(SEPARATOR)
		        .append(tDate).append(SEPARATOR);
		makeFolder(baseDir, modeName, year, month, date, cmpId);

		return filePathSb.toString();
	}
	
	/**
	 * 숫자를 단위로(Byte,KB,MB,GB).
	 *
	 * @param num long
	 * @return the string
	 */
	public String strNumToFileSize(long num) {
		String ret = "";
		int bias = 1024;

		if (num < bias) {
			ret = num + "Byte";
		} else if (num >= bias && num < (bias * bias)) {
			ret = num / bias + "KB";
		} else if (num >= (bias * bias) && num < (bias * bias * bias)) {
			ret = num / (bias * bias) + "MB";
		} else if (num >= (bias * bias * bias) && num < (bias * bias * bias * bias)) {
			ret = num / (bias * bias * bias) + "GB";
		}
		return ret;
	}

	/**
	 * 숫자를 단위(Byte,KB,MB,GB)로 변환.
	 *
	 * @param num int
	 * @return the string
	 */
	public String strNumToFileSize(int num) {
		return strNumToFileSize((long) num);
	}
	
	/**
	 * 파일 삭제.
	 * @param filePath String
	 * @return the boolean
	 */
	public boolean deleteFile(String filePath){
		File file = new File(filePath);
		if(file.exists()){
			return file.delete();
		}else{
			return false;
		}
	}
	
	public boolean deleteFile(String filePath, String realFileName){
		String basePath = UPLOAD_URL;
		filePath = (filePath.startsWith("/")) ? basePath + filePath + realFileName : basePath + "/" + filePath + realFileName;
		File file = new File(filePath);
		if(file.exists()){
			return file.delete();
		}else{
			return false;
		}
	}

	/**
	 * 업로드할수 있는 이미지확장자인지 여부를 리턴한다.
	 * @param type
	 * @return
	 */
	public boolean isUploadableImageExtension(String type) {
		if(StringUtil.isEmpty(type)){
			return false;
		}

		String srcType = type.toLowerCase();
		for(String imageType : UPLOADABLE_IMAGE_TYPES){
			if(imageType.equals(srcType)) return true;
		}
//		for(String imageType : UPLOADABLE_DOC_TYPE){
//			if(imageType.equals(srcType)) return true;
//		}
		return false;
	}
	
	public List<FileVO> uploadFiles(HttpServletRequest request, String fileName, String path) throws Throwable{
		MultipartHttpServletRequest multipartRequest =  (MultipartHttpServletRequest)request;  //다중파일 업로드		
		List<MultipartFile> uploadFiles = multipartRequest.getFiles(fileName);		
		
		List<FileVO> uploadFileList = transferFile(uploadFiles, path);
		return uploadFileList;
	}
	
	
	@Resource(name="propertiesService")
	EgovPropertyService egovPropertyService;
	
//	public String getFileName(GenipsyServletMap commandMap, String type) throws Exception{
//		
//		try{
//			String prev ="";
//			if(type!=null) prev = "thumbnail.";
//
//			EgovMap map = kmeiliComDao.file(commandMap);
//			
//			String path = map.get("filePath").toString();
//			String fileNm = map.get("realFileName").toString();
//			String fileExt = map.get("fileExt").toString();
//			
//			if(type!=null){
//				return UPLOAD_URL+path+prev+fileNm+"."+fileExt;
//			}else{
//				return UPLOAD_URL+path+prev+fileNm;
//			}
//		}catch (Exception e){
//			return "";
//		}
//		
//	}

}
