package egovframework.com.bidserver.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import egovframework.rte.fdl.property.EgovPropertyService;

public class DownloadUtil {
	EgovPropertyService egovPropertyService;
	public DownloadUtil(EgovPropertyService egovPropertyService){
		this.egovPropertyService = egovPropertyService;
	}
	
	/**
	 * 일반 다운로드 처리.
	 *
	 * @param request HttpServletRequest
	 * @param response HttpServletResponse
	 * @param dnFilePath String
	 * @param dnFileName String
	 * @throws UnsupportedEncodingException unsupported encoding exception
	 * @throws Exception exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 * @throws NotExistException not exist exception
	 */
	public void download(HttpServletRequest request, HttpServletResponse response, 
			String dnFilePath, String dnFileName)throws UnsupportedEncodingException, Exception, IOException{
		System.out.println("dnFilePath=====>"+dnFilePath);
		File file = new File(dnFilePath.replaceAll("\\\\", "/"));
		
		System.out.println(file.getPath()+"\n"+file.getCanonicalPath());
		if (file.exists() && file.isFile() && !file.isDirectory() && !file.isHidden()) {

			long fileLen = file.length();
			setHeaderForDownload(request, response, dnFileName, fileLen);

			BufferedInputStream bin = null;
			BufferedOutputStream bos = null;
			try {
				bin = new BufferedInputStream(new FileInputStream(file));
				bos = new BufferedOutputStream(response.getOutputStream());

				byte[] buf = new byte[4096]; // buffer size 2K.
				int read = 0;
				while ((read = bin.read(buf)) != -1)
					bos.write(buf, 0, read);

			} catch (Exception sube) {
				throw sube;
			} finally {
				if (bos != null)
					try {
						bos.close();
					} catch (Exception e) {
					}
				if (bin != null)
					try {
						bin.close();
					} catch (Exception e) {
					}
			}
		} else {
			throw new Exception();
		}
	}


	/**
	 * 다운로드 request,response 헤더정보 셋팅.
	 *
	 * @param request HttpServletRequest
	 * @param response HttpServletResponse
	 * @param dnFileName String
	 * @param fileLen long
	 * @throws UnsupportedEncodingException unsupported encoding exception
	 */
	private void setHeaderForDownload(HttpServletRequest request,
			HttpServletResponse response, String dnFileName, long fileLen)
			throws UnsupportedEncodingException {
		String convFileName = null;
		String strClient = request.getHeader("user-agent");
		int extIdx = dnFileName.lastIndexOf(".");
		String ext = new String();
		if(extIdx > -1){
			ext = dnFileName.substring(extIdx+1);
		}
		
		String mime = (String)StringUtil.nvl(ext, egovPropertyService.getString("mimeType"));
		String resCharset = StringUtils.defaultIfEmpty(egovPropertyService.getString("CHARSET"), "iso-8859-1");

		if (strClient !=null && strClient.indexOf("MSIE 5.5") > -1 || strClient !=null && strClient.indexOf("MSIE") > -1) {
			if(! "utf-8".equalsIgnoreCase(resCharset) && isMsOfficeFile(dnFileName)){
				Pattern kp = Pattern.compile("[\uac00-\ud7af\u1100-\u11ff]");
				Pattern cp = Pattern.compile("[\u3040-\u318f\u3100-\u312f\u3040-\u309F\u30A0-\u30FF\u31F0-\u31FF\u3300-\u337f\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff65-\uff9f]");
				Matcher km = kp.matcher(dnFileName);
				Matcher cm = cp.matcher(dnFileName);

				if (km.find() && !  cm.find()){
					request.setCharacterEncoding("euc-kr");
					//response.setCharacterEncoding(resCharset);
					convFileName = new String(dnFileName.getBytes("euc-kr"), resCharset); //iso-8859-1,MS949,8859_1,Cp970
				}else{
					request.setCharacterEncoding("utf-8");
					//response.setCharacterEncoding("utf-8");
					convFileName = java.net.URLEncoder.encode(dnFileName, "utf-8").replace('+',' ');
				}
			}else{
				request.setCharacterEncoding("utf-8");
				//response.setCharacterEncoding("utf-8");
				convFileName = java.net.URLEncoder.encode(dnFileName, "utf-8").replace('+',' ');
			}
		}else{ //모질라나 오페라
			request.setCharacterEncoding("utf-8");
			//response.setCharacterEncoding("utf-8");
			convFileName = java.net.URLEncoder.encode(dnFileName, "utf-8").replace('+',' ');
//			convFileName = new String(dnFileName.getBytes("UTF-8"), "latin1");
		}

		response.setContentType(mime);
		//response.setContentLength(fileLen);
		response.setHeader("Content-Length", String.valueOf(fileLen));
		//response.setHeader("Content-Type", mime+"; name="+convFileName);

		response.setHeader("Pragma", "public");
		response.setHeader("Cache-Control", "no-store, max-age=0, no-cache, must-revalidate");
		response.setHeader("Cache-Control", "post-check=0, pre-check=0");
		response.setHeader("Cache-Control", "private");
		response.setHeader("P3P", "CP='ALL IND DSP COR ADM CONo CUR CUSo IVAo IVDo PSA PSD TAI TELo OUR SAMo CNT COM INT NAV ONL PHY PRE PUR UNI'");

		if (strClient !=null && strClient.indexOf("MSIE 5.5") != -1) {
			//response.setHeader("Content-Type", "doesn/matter;");
			response.setHeader("Content-Disposition", "filename="
					+ convFileName);
			response.setHeader("Content-Type", mime+"; name="+convFileName);
		} else {
			//response.setHeader("Content-Type", "application/octet-stream;");
			response.setHeader("Content-Disposition", "attachment; filename=\""
					+ convFileName + "\"");
			response.setHeader("Content-Type", mime+"; name=\""+convFileName+"\"");
		}

		response.setHeader("Content-Transfer-Encoding", "binary");
	}

	/**
	 * MS Office 파일 여부. 파일 확장자로 판단.
	 *
	 * @param dnFileName String
	 * @return true, if is ms office file
	 */
	private boolean isMsOfficeFile(String dnFileName){
		if(dnFileName==null) return false;
		String fileName = dnFileName.toLowerCase();
		return fileName.endsWith(".doc") || fileName.endsWith(".xls") || fileName.endsWith(".ppt") ||
		fileName.endsWith(".docx") || fileName.endsWith(".xlsx") || fileName.endsWith(".pptx");
	}

	/**
	 * 당일 날짜 스트링 구하기.
	 *
	 * @return yyyyMMdd_HHmmss
	 */
	public String getFilePrefix(){
		return "";//DateUtil.getDate("yyyyMMdd_HHmmss");
	}
}
