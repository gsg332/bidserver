package egovframework.com.cmm.util;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.apache.commons.fileupload.FileItem;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

public class MultiFileSupportCommonsMultipartResolver extends CommonsMultipartResolver {
	public MultiFileSupportCommonsMultipartResolver() {}
	

	public MultiFileSupportCommonsMultipartResolver(ServletContext servletContext) {
		super(servletContext);
	}


	/**
     * file의 파라미터 이름이 동일할 경우 에러가 나는 부분을 처리하였다.
     * <xmp>
     * 예)
     * <input type="file" name="fileName"/>
     * <input type="file" name="fileName"/>
     * 위와같이 파라미터 이름을 'fileName'과 같이 동일하게 주었을때 올바르게 동작하도록 처리해준다.
     * </xmp>
     */

	@Override

    @SuppressWarnings("unchecked")
    protected MultipartParsingResult parseFileItems(List fileItems, String encoding) {
		MultiValueMap<String, MultipartFile> multipartFiles = new LinkedMultiValueMap<String,MultipartFile>();
        //Map multipartFiles = new HashMap();
        Map multipartParameters = new HashMap();
        
        Map<String, String> multipartParameterContentTypes = new HashMap<String, String>();
        

        // Extract multipart files and multipart parameters.
        for (Iterator it = fileItems.iterator(); it.hasNext();) {

            FileItem fileItem = (FileItem) it.next();
            multipartParameterContentTypes.put(fileItem.getFieldName(), fileItem.getContentType());

            if (fileItem.isFormField()) {

                String value = null;

                if (encoding != null) {

                    try {

                        value = fileItem.getString(encoding);

                    } catch (UnsupportedEncodingException ex) {

                        if (logger.isWarnEnabled()) {
                            logger.warn("Could not decode multipart item '" + fileItem.getFieldName()
                                    + "' with encoding '" + encoding + "': using platform default");
                        }

                        value = fileItem.getString();
                    }
                } else {
                    value = fileItem.getString();
                }

                String[] curParam = (String[]) multipartParameters.get(fileItem.getFieldName());

                if (curParam == null) {
                    // simple form field
                    multipartParameters.put(fileItem.getFieldName(), new String[] { value });
                } else {
                    // array of simple form fields
                    String[] newParam = StringUtils.addStringToArray(curParam, value);
                    multipartParameters.put(fileItem.getFieldName(), newParam);
                }

            } else {

                // multipart file field

                CommonsMultipartFile file = new CommonsMultipartFile(fileItem);
                //if (multipartFiles.putput(fileItem.getName(), file) != null) {
                //    throw new MultipartException("Multiple files for field name [" + file.getName()
                //            + "] found - not supported by MultipartResolver");
                //}
                
                if( fileItem != null && fileItem.getName() != null && !"".equals(fileItem.getName()) ){ 
                	multipartFiles.add(fileItem.getFieldName(),file);

                }

                if (logger.isDebugEnabled()) {
                    logger.debug("Found multipart file [" + file.getName() + "] of size " + file.getSize()
                            + " bytes with original filename [" + file.getOriginalFilename() + "], stored "
                            + file.getStorageDescription());
                }
            }
        }

        return new MultipartParsingResult(multipartFiles, multipartParameters,multipartParameterContentTypes);

    }
}
