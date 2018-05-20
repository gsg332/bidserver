package egovframework.com.bidserver.notice.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import egovframework.com.bidserver.main.service.FileService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.notice.service.NoticeService;
import egovframework.com.bidserver.util.FileUtil;
import egovframework.com.cmm.message.ResultStatus;

/**
 * 공지관리 클래스를 정의 한다
 * 
 * @author 정진고
 ** @since 2016.04.25
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2016.06.22  정진고          최초 생성
 * 
 * </pre>
 */
@Controller
public class NoticeController extends CommonController{

	@Autowired private FileSystemResource fsResource;
	
	@Resource(name = "noticeService")
	private NoticeService noticeService;

	@Resource(name = "fileService")
	private FileService fileService;
	
	@Autowired
	private View jSonView;
	

	/**
	 * 공지관리 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/notice/main.do")
	public String mainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/notice/main";
	}
	
	/**
	 * 공지사항 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/notice/selectNoticeList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectUserList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = noticeService.selectNoticeList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", noticeService.getNoticeListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}

		return jSonView;
	}
	
	/**
	 * 프로젝트 저장
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/notice/updateNoticeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateNoticeList(MultipartHttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			
			HashMap paramMap = this.bindEncoding(request,"utf-8");
					
			int key = 0;
			if(paramMap.get("notice_id")!=null && String.valueOf(paramMap.get("notice_id")).length()>0){
				noticeService.updateNoticeList(paramMap);
				
				key = Integer.parseInt(String.valueOf(paramMap.get("notice_id")));
			}else{
				noticeService.insertNoticeList(paramMap);
				
				key = (Integer)paramMap.get("notice_id");
			}
			
			//이전 목록 불러오기
			List<HashMap> beforeList = null;
			HashMap beforeMap = new HashMap();
			beforeMap.put("notice_id", key);
			beforeList = noticeService.selectNoticeList2(beforeMap);
			
			String fileId1 = null;
			String fileId2 = null;
			
			HashMap fileMap = new HashMap();
			fileMap.put("notice_id", key);

			if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()>0){
				if(request.getFile("file1")==null || request.getFile("file1").getBytes().length==0){
					fileMap.put("file_id1", (String)beforeList.get(0).get("file_id1"));
				}else{
					fileId1 = uploadFile1(request.getFile("file1"), "notice/"+key+"/", URLDecoder.decode(request.getParameter("file_id1"), "UTF-8"));
					fileMap.put("file_id1", fileId1);
				}
			}else{
				fileMap.put("file_id1", fileId1);
			}
			if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()>0){
				if(request.getFile("file2")==null || request.getFile("file2").getBytes().length==0){
					fileMap.put("file_id2", (String)beforeList.get(0).get("file_id2"));
				}else{
					fileId2 = uploadFile1(request.getFile("file2"), "notice/"+key+"/", URLDecoder.decode(request.getParameter("file_id2"), "UTF-8"));
					fileMap.put("file_id2", fileId2);
				}
			}else{
				fileMap.put("file_id2", fileId2);
			}
			noticeService.updateNoticeFileList(fileMap);
			
			//이전파일 삭제
			if(fileId1!=null){
				removeFile((String)beforeList.get(0).get("file_id1"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id1"), "UTF-8").length()==0){
					removeFile((String)beforeList.get(0).get("file_id1"));
				}
			}
			if(fileId2!=null){
				removeFile((String)beforeList.get(0).get("file_id2"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id2"), "UTF-8").length()==0){
					removeFile((String)beforeList.get(0).get("file_id2"));
				}
			}
			
			

			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;

	}
	
	/**
	 * 공지사항 삭제
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/notice/deleteNoticeList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteUserList(HttpServletRequest request, Model model, Map<String, Object> data) {
		try {
			HashMap map = this.bind(request);
			
			noticeService.deleteNoticeList(map);
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			model.addAttribute("status", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			model.addAttribute("status", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
		}
		return jSonView;

	}
	
	
	/**
	 * 이전 저장파일 삭제
	 * @param beforeId
	 */
	public void removeFile(String beforeId){
		try{
			if(beforeId!=null && beforeId.length()>0){
				HashMap fileMap = new HashMap();
				fileMap.put("file_id", beforeId);
				HashMap fileInfo = fileService.detail(fileMap);
				
				File removeFile = new File((String)fileInfo.get("real_file_path"));
				if(removeFile.exists()){
					removeFile.delete();
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public String uploadFile1(MultipartFile mpf, String folderPath, String realFileName) throws Exception{
        
        try {
            System.out.println("file length : " + mpf.getBytes().length);
            System.out.println("file name : " + realFileName);
            
            
            if(mpf.getBytes().length==0){
            	return "";
            }

            String fileId = UUID.randomUUID().toString();
            
            try {

            	File dir = new File(fsResource.getPath()+folderPath);  // 폴더경로지정
            	
            	if(!dir.isDirectory()){
            		dir.mkdirs();
            	}
            	
            	 HashMap map = new HashMap();
            	 
            	 map.put("file_id", fileId);
            	 map.put("org_file_name", realFileName);
            	 map.put("file_path", folderPath);
            	 map.put("real_file_path", fsResource.getPath() + folderPath + fileId +"."+FileUtil.getFileType(realFileName));
            	 map.put("real_file_name", fileId +"."+FileUtil.getFileType(realFileName));
            	 map.put("file_size", mpf.getBytes().length);
            	 map.put("file_ext", FileUtil.getFileType(realFileName));
            	 
                 fileService.insert(map);
            	
                File outFileName = new File(fsResource.getPath() + folderPath + fileId +"."+FileUtil.getFileType(realFileName));

                FileOutputStream fileoutputStream = new FileOutputStream(outFileName);

                fileoutputStream.write(mpf.getBytes());

                fileoutputStream.close();
                
               
                

           } catch (IOException ie) {

                System.err.println("File writing error! ");

           }
            return fileId;

        } catch (IOException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        return "";
	}
	
	@RequestMapping(value = "/notice/selectSendMsgList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View selectSendMsgList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = noticeService.selectSendMsgList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", noticeService.getSendMsgListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}

}
