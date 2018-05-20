<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="
org.apache.poi.hssf.usermodel.HSSFCell,
org.apache.poi.hssf.usermodel.HSSFRow,
org.apache.poi.hssf.usermodel.HSSFSheet,
org.apache.poi.hssf.usermodel.HSSFWorkbook ,
org.apache.poi.hssf.util.Region,
java.io.FileOutputStream,
java.util.List,
org.apache.poi.hssf.usermodel.HSSFCellStyle ,
org.apache.poi.hssf.usermodel.HSSFFont,
org.apache.poi.hssf.util.HSSFColor,
java.util.*,
    java.io.*
"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>엑셀 POI 테스트 완료</title>
</head>
<body>
	<%
		String sFileName = "투찰사정보_" + new Date().getTime() + ".xls";

		out.clear();
		out = pageContext.pushBody();
// 		response.reset(); // 이 문장이 없으면 excel 등의 파일에서 한글이 깨지는 문제 발생.

		String strClient = request.getHeader("User-Agent");
		String fileName = sFileName;
		if (strClient.indexOf("MSIE 5.5") > -1) {
			//response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-Disposition", "filename=" + fileName + ";");
		} else {
			response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
		}
// 		OutputStream fileOut = null;

// 		HSSFWorkbook objWorkBook = (HSSFWorkbook) request.getAttribute("workbook");

// 		out.clear();
// 		out = pageContext.pushBody();
// 		fileOut = response.getOutputStream();
// 		objWorkBook.write(fileOut);
// 		fileOut.close();
	%>
</body>
</html>