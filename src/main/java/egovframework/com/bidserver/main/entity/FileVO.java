package egovframework.com.bidserver.main.entity;

import java.util.Date;

public class FileVO {

	/** 파일ID */
	private String fileId;
	
	/** 파일ID 배열형*/
	private String[] fileIdArr;
	
	/** 원본파일명*/ 
	private String orgFileName;
	
	/** 파일 URL 상대경로*/	
	private String filePath;
	
	/** 실제 파일 경로 **/
	private String realFilePath;
	
	/** 파일명*/
	private String realFileName;
	
	/** 파일사이즈(byte)*/
	private long fileSize;
	
	/** 파일확장자*/
	private String fileExt;
	
	/** 파일순서*/
	private int fileOrder;
	
	/** 등록일시*/
	private Date regDate;
	
	/** 파일정보 */
	private String fileInfo;
	
	/** 모듈명*/
	private String moduleName;
	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	public String[] getFileIdArr() {
		return fileIdArr;
	}

	public void setFileIdArr(String[] fileIdArr) {
		this.fileIdArr = fileIdArr;
	}

	public String getOrgFileName() {
		return orgFileName;
	}

	public void setOrgFileName(String orgFileName) {
		this.orgFileName = orgFileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getRealFilePath() {
		return realFilePath;
	}

	public void setRealFilePath(String realFilePath) {
		this.realFilePath = realFilePath;
	}

	public String getRealFileName() {
		return realFileName;
	}

	public void setRealFileName(String realFileName) {
		this.realFileName = realFileName;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public int getFileOrder() {
		return fileOrder;
	}

	public void setFileOrder(int fileOrder) {
		this.fileOrder = fileOrder;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	public String getFileInfo() {
		return fileInfo;
	}

	public void setFileInfo(String fileInfo) {
		this.fileInfo = fileInfo;
	}
	
	public String getModuleName() {
		return moduleName;
	}

	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}

	@Override
	public String toString() {
		return "FileVO [fileId=" + fileId + ", orgFileName=" + orgFileName
				+ ", filePath=" + filePath + ", realFilePath=" + realFilePath
				+ ", realFileName=" + realFileName + ", fileSize=" + fileSize
				+ ", fileExt=" + fileExt + ", fileOrder=" + fileOrder
				+ ", regDate=" + regDate + ", fileInfo=" + fileInfo
				+ ", moduleName=" + moduleName + "]";
	}

}
