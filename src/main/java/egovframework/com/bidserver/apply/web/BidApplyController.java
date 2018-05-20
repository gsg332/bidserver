package egovframework.com.bidserver.apply.web;

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

import egovframework.com.bidserver.apply.service.BidApplyService;
import egovframework.com.bidserver.bid.service.BidInfoService;
import egovframework.com.bidserver.main.service.FileService;
import egovframework.com.bidserver.main.web.CommonController;
import egovframework.com.bidserver.util.FileUtil;
import egovframework.com.cmm.message.ResultStatus;

/**
 * 요청공고 클래스를 정의 한다
 * 
 * @author 정진고
 ** @since 2016.03.14
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * 
 * </pre>
 */
@Controller
public class BidApplyController extends CommonController{

	@Resource(name = "bidApplyService")
	private BidApplyService bidApplyService;
	
	@Resource(name = "bidInfoService")
	private BidInfoService bidInfoService;
	
	@Autowired private FileSystemResource fsResource;
	
	@Resource(name = "fileService")
	private FileService fileService;

	@Autowired
	private View jSonView;

	/**
	 * 요청공고 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/apply/main.do")
	public String getBidNoticeMainPage(HttpServletRequest request, ModelMap model) throws Exception {

		return "/admin/apply/main";
	}
	
	/**
	 * 결재요청 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/apply/bidMyApplyList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidList(HttpServletRequest request, Model model) {

		List<HashMap> resultList = null;

		try {
			HashMap map = this.bind(request);

			int startIndex = (Integer.valueOf((String) map.get("page")) - 1) * Integer.parseInt((String) map.get("rows"));
			map.put("pageNo", startIndex);
			map.put("rows", Integer.parseInt((String) map.get("rows")));

			resultList = bidApplyService.selectBidMyApplyList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("total", bidApplyService.getBidMyApplyListCnt(map));

			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}

		return jSonView;
	}
	/**
	 * 결재요청 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/apply/bidApplyList.do", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public View bidApplyList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			resultList = bidApplyService.selectBidApplyList(map);
			
			model.addAttribute("resultCode", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			model.addAttribute("rows", resultList);
		} catch (Exception e) {
			model.addAttribute("resultCode", ResultStatus.FAIL.value());
			model.addAttribute("resultMessage", ResultStatus.FAIL.getReasonPhrase());
			e.printStackTrace();
		}
		
		return jSonView;
	}
	
	/**
	 * 요청공고 처리
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/apply/deleteBidApplyList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View deleteBidApplyList(HttpServletRequest request, Model model) {
		
		List<HashMap> resultList = null;
		
		try {
			HashMap map = this.bind(request);
			
			
			//이전 목록 불러오기
			List<HashMap> beforeList = null;
			HashMap beforeMap = new HashMap();
			beforeMap.put("bid_notice_no", map.get("bid_notice_no"));
			beforeMap.put("bid_notice_cha_no", map.get("bid_notice_cha_no"));
			beforeMap.put("user", map.get("user"));
			beforeList = bidApplyService.selectBidMyApplyList(beforeMap);
			
			//이전파일 삭제
			if(beforeList.size()>0){
				removeFile((String)beforeList.get(0).get("file_id"));
			}
			
			bidApplyService.deleteBidApplyList(map);
			
			
			
			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jSonView;
		
	}
	
	/**
	 * 요청공고 처리
	 * @param request
	 * @param model
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/apply/updateBidMyApplyList.do", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public View updateBidMyApplyList(MultipartHttpServletRequest request, Model model, Map<String, Object> data) {
	
		try {
			
			HashMap paramMap = this.bindEncoding(request,"utf-8");
			
			
			//이전 목록 불러오기
			List<HashMap> beforeList = null;
			HashMap beforeMap = new HashMap();
			beforeMap.put("bid_notice_no", paramMap.get("bid_notice_no"));
			beforeMap.put("bid_notice_cha_no", paramMap.get("bid_notice_cha_no"));
			//beforeMap.put("user", paramMap.get("user"));
			beforeMap.put("user", paramMap.get("user_id"));
			beforeList = bidApplyService.selectBidMyApplyList(beforeMap);
			
			

			bidInfoService.updateSubject(paramMap);
			bidInfoService.updateRisk(paramMap);
			
			
			bidApplyService.updateBidMyApplyList(paramMap);
			
			
			String fileId1 = null;
			
			HashMap fileMap = new HashMap();
			fileMap.put("bid_notice_no", paramMap.get("bid_notice_no"));
			fileMap.put("bid_notice_cha_no", paramMap.get("bid_notice_cha_no"));

			if(URLDecoder.decode(request.getParameter("file_id"), "UTF-8").length()>0){
				if(request.getFile("file")==null || request.getFile("file").getBytes().length==0){
					fileMap.put("file_id", (String)beforeList.get(0).get("file_id"));
				}else{
					fileId1 = uploadFile1(request.getFile("file"), "apply/"+paramMap.get("bid_notice_no")+"/", URLDecoder.decode(request.getParameter("file_id"), "UTF-8"));
					fileMap.put("file_id", fileId1);
				}
			}else{
				fileMap.put("file_id", fileId1);
			}
			
			bidApplyService.updateBidMyApplyFileList(fileMap);
			
			//이전파일 삭제
			if(fileId1!=null){
				removeFile((String)beforeList.get(0).get("file_id"));
			}else{
				if(URLDecoder.decode(request.getParameter("file_id"), "UTF-8").length()==0){
					if(beforeList.size() > 0){
						removeFile((String)beforeList.get(0).get("file_id"));
					}
				}
			}


			model.addAttribute("status", ResultStatus.OK.value());
			model.addAttribute("resultMessage", ResultStatus.OK.getReasonPhrase());

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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

}
