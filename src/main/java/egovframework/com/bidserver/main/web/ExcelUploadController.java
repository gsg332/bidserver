package egovframework.com.bidserver.main.web;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.bidserver.bid.entity.BidInfo2;
import egovframework.com.bidserver.bid.service.BidInfoService;
import egovframework.com.bidserver.main.service.ExcelUploadService;
import egovframework.rte.fdl.property.EgovPropertyService;

@Controller
@RequestMapping("/excelUploadController.do")
public class ExcelUploadController {

	public String PROPERTIES_FILE;
	public static HashMap<String, Object> stackGroup = new HashMap<String, Object>();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "excelUploadService")
	public ExcelUploadService excelUploadService;

	@Resource(name = "bidInfoService")
	public BidInfoService bidInfoService;

	private String fileuploadpath;
	private String repositoryPath;

	@RequestMapping(params = "method=upload_notice_info")
	public void updateDD_BOP_PART_MASTER(MultipartHttpServletRequest request, HttpServletResponse response, SessionStatus status, HttpSession session)
			throws Exception {
		try {
			MultipartFile file = request.getFile("excelfile");
			String modify = nullchange(request.getParameter("modify"));
			try {

				String fileName = file.getOriginalFilename();
				if (!"".equals(fileName)) {
					Workbook workbook = WorkbookFactory.create(file.getInputStream());
					Sheet sheet = workbook.getSheetAt(0);
					int rows = sheet.getPhysicalNumberOfRows();
					Row row = null;
					Row row1 = null;
					Row row2 = null;
					String sendQuery = "";
					Map map = new HashMap<String, String>();

					if (!"Y".equals(modify)) { // 새로 넣기 제거

						BidInfo2 info = null;
						for (int r = 1; r < rows; r++) {
							row1 = sheet.getRow(r - 1);
							row = sheet.getRow(r);

							System.out.println("===================== row " + r + " ==================================");

							if (this.getCellValue(row.getCell(0)).length() > 0) {
								info = new BidInfo2();
								for (int c = 0; c < 32; c++) {

									System.out.print(this.getCellValue(row.getCell(c), workbook) + " /");

									String cellValue = this.getCellValue(row.getCell(c), workbook);

									switch (c) {
									case 2:
										String value[] = cellValue.split("-");
										info.setBid_cha_no(value[value.length - 1]);
										String bid_no = "";
										for (int i = 0; i < value.length - 1; i++) {
											if (i > 0) {
												bid_no += "-" + value[i];
											} else {
												bid_no += value[i];
											}
										}
										info.setBid_no(bid_no);
										break;
									case 3:
										info.setBid_title_nm(cellValue);
										break;
									case 4:
										info.setDirt_prct(cellValue);
										break;
									case 5:
										info.setDemand_nm(cellValue);
										break;
									case 6:
										info.setBid_method(cellValue);
										break;
									case 7:
										info.setBid_price_type(cellValue);
										break;
									case 8:
										info.setCont_method(cellValue);
										break;
									case 9:
										info.setBudget_val(cellValue);
										break;
									case 10:
										info.setPre_price_val(cellValue);
										break;
									case 11:
										info.setBase_price_val(cellValue);
										break;
									case 12:
										info.setGoods_type_nm(cellValue);
										break;
									case 13:
										info.setGoods_type_biz_nm(cellValue);
										break;
									case 14:
										info.setArea_nm(cellValue);
										break;
									case 15:
										info.setBid_ent_std_dt(cellValue);
										break;
									case 16:
										info.setBid_ent_end_dt(cellValue);
										break;
									case 17:
										info.setPublic_sup_type(cellValue);
										break;
									case 18:
										info.setArea_percent(cellValue);
										break;
									case 19:
										info.setPub_sup_agr_end_dt(cellValue);
										break;
									case 20:
										info.setBid_notice_dt(cellValue);
										break;
									case 21:
										info.setBid_std_dt(cellValue);
										break;
									case 22:
										info.setBid_end_dt(cellValue);
										break;
									case 23:
										info.setBid_open_dt(cellValue);
										break;
									case 24:
										info.setBid_price_choice(cellValue);
										break;
									case 25:
										info.setBid_price_range(cellValue);
										break;
									case 26:
										info.setBid_price_open_yn(cellValue);
										break;
									case 27:
										info.setBid_lot_num(cellValue);
										break;
									case 28:
										info.setBid_success(this.getCellValue(row.getCell(c)));
										break;
									case 29:
										info.setBid_user_nm(cellValue);
										break;
									case 30:
										info.setBid_user_tel(cellValue);
										break;
									case 31:
										info.setBid_step_nm(cellValue);
										break;

									default:
										break;
									}

								}
							} else {
								String cellValue = this.getCellValue(row.getCell(12), workbook);
								String cellValue2 = this.getCellValue(row.getCell(13), workbook);
								if (cellValue.length() > 0) {
									if (info.getGoods_type_nm().length() > 0) {
										info.setGoods_type_nm(info.getGoods_type_nm() + "," + cellValue);
									} else {
										info.setGoods_type_nm(cellValue);
									}
								}
								if (cellValue2.length() > 0) {
									if (info.getGoods_type_biz_nm().length() > 0) {
										info.setGoods_type_biz_nm(info.getGoods_type_biz_nm() + "," + cellValue2);
									} else {
										info.setGoods_type_biz_nm(cellValue2);
									}
								}
							}

							bidInfoService.updateBidInfo(info);

							System.out.println("");
						}

					}

				}

			} catch (Exception e) {

				response.setContentType("text/html; charset=UTF-8");
				response.setHeader("Cache-Control", "no-cache");
				response.getWriter().write(e.getMessage());
			}

			status.setComplete();
			JSONObject obj = new JSONObject();

			response.setContentType("text/html; charset=UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(JSONObject.fromObject(obj).toString());

		} catch (Exception e) {
			response.setContentType("text/html; charset=UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(e.getMessage());
		}

	}
	
	@RequestMapping(params = "method=updateTable1")
	public void updateTable1(MultipartHttpServletRequest request, HttpServletResponse response, SessionStatus status, HttpSession session)
			throws Exception {
		try {
			String modify = nullchange(request.getParameter("modify"));
			try {

				
					Workbook workbook = WorkbookFactory.create(new File("c:\\table1.xlsx"));
					
					Sheet sheet = workbook.getSheetAt(2);
					int rows = sheet.getPhysicalNumberOfRows();
					Row row = null;
					Row row1 = null;
					Row row2 = null;
					String sendQuery = "";
					Map map = new HashMap<String, String>();

						HashMap paramMap = new HashMap();
						for (int r = 1; r < rows; r++) {
							row1 = sheet.getRow(r - 1);
							row = sheet.getRow(r);

							System.out.println("===================== row " + r + " ==================================");

							if (this.getCellValue(row.getCell(0)).length() > 0) {
								paramMap = new HashMap();
								for (int c = 0; c < 6; c++) {

									System.out.print(this.getCellValue(row.getCell(c), workbook) + " /");

									String cellValue = this.getCellValue(row.getCell(c), workbook);

									switch (c) {
									case 0:
										paramMap.put("column0", cellValue);
										break;
									case 1:
										paramMap.put("column1", cellValue);
										break;
									case 2:
										paramMap.put("column2", cellValue);
										break;
									case 3:
										paramMap.put("column3", cellValue);
										break;
									case 4:
										paramMap.put("column4", cellValue);
										break;
									case 5:
										paramMap.put("column5", cellValue);
										break;

									default:
										break;
									}

								}
							}

							bidInfoService.updateTable1(paramMap);

							System.out.println("");
						}



			} catch (Exception e) {

				response.setContentType("text/html; charset=UTF-8");
				response.setHeader("Cache-Control", "no-cache");
				response.getWriter().write(e.getMessage());
			}

			status.setComplete();
			JSONObject obj = new JSONObject();

			response.setContentType("text/html; charset=UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(JSONObject.fromObject(obj).toString());

		} catch (Exception e) {
			response.setContentType("text/html; charset=UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(e.getMessage());
		}

	}
	@RequestMapping(params = "method=updateTable4")
	public void updateTable4(MultipartHttpServletRequest request, HttpServletResponse response, SessionStatus status, HttpSession session)
			throws Exception {
		try {
			String modify = nullchange(request.getParameter("modify"));
			try {
				
				
				Workbook workbook = WorkbookFactory.create(new File("c:\\table2.xls"));
				
				Sheet sheet = workbook.getSheetAt(0);
				int rows = sheet.getPhysicalNumberOfRows();
				Row row = null;
				Row row1 = null;
				Row row2 = null;
				String sendQuery = "";
				Map map = new HashMap<String, String>();
				
				HashMap paramMap = new HashMap();
				for (int r = 1; r < rows; r++) {
					row1 = sheet.getRow(r - 1);
					row = sheet.getRow(r);
					
					System.out.println("===================== row " + r + " ==================================");
					
					if (this.getCellValue(row.getCell(0)).length() > 0) {
						paramMap = new HashMap();
						for (int c = 0; c < 6; c++) {
							
							System.out.print(this.getCellValue(row.getCell(c), workbook) + " /");
							
							String cellValue = this.getCellValue(row.getCell(c), workbook);
							
							switch (c) {
							case 0:
								paramMap.put("column0", cellValue);
								break;
							case 1:
								paramMap.put("column1", cellValue);
								break;
							case 2:
								paramMap.put("column2", cellValue);
								break;
							case 3:
								paramMap.put("column3", cellValue);
								break;
							case 4:
								paramMap.put("column4", cellValue);
								break;
							case 5:
								paramMap.put("column5", cellValue);
								break;
								
							default:
								break;
							}
							
						}
					}
					
					int key = bidInfoService.updateTable4(paramMap);
					System.out.println("key ===============>"+paramMap.get("business_no"));
					System.out.println("colum2 ===============>"+paramMap.get("column2"));
					
					String goods[] = ((String)paramMap.get("column2")).split("\\;");
					
					for(int x=0;x<goods.length;x++){
						try{
							HashMap subMap = new HashMap();
							subMap.put("business_no", paramMap.get("business_no"));
							subMap.put("goods_nm", goods[x]);
							
							bidInfoService.updateTable5(subMap);
						}catch(Exception e){
							e.printStackTrace();
						}
						
					}
				}
				
				
				
			} catch (Exception e) {
				e.printStackTrace();
				response.setContentType("text/html; charset=UTF-8");
				response.setHeader("Cache-Control", "no-cache");
				response.getWriter().write(e.getMessage());
			}
			
			status.setComplete();
			JSONObject obj = new JSONObject();
			
			response.setContentType("text/html; charset=UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(JSONObject.fromObject(obj).toString());
			
		} catch (Exception e) {
			e.printStackTrace();
			response.setContentType("text/html; charset=UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(e.getMessage());
		}
		
	}

	public Map bind(HttpServletRequest request) throws IllegalArgumentException, IllegalAccessException, InstantiationException, ClassNotFoundException {
		Map map = new HashMap();
		Enumeration headerNames = request.getParameterNames();

		while (headerNames.hasMoreElements()) {
			String name = (String) headerNames.nextElement();
			String value = request.getParameter(name);
			map.put(name, value);
		}

		return map;
	}

	public String getCellValue(Cell cell) {
		String str = "";
		try {
			if (cell != null) {
				int i = cell.getCellType();
				switch (i) {

				case Cell.CELL_TYPE_NUMERIC:
					str = Double.toString((double) cell.getNumericCellValue());
					break;
				case Cell.CELL_TYPE_STRING:
					str = cell.getStringCellValue();
					break;
				case Cell.CELL_TYPE_BLANK:
					break;
				case Cell.CELL_TYPE_BOOLEAN:
					break;
				case Cell.CELL_TYPE_FORMULA:
					try {
						str = cell.getStringCellValue();
					} catch (Exception e) {
						str = Integer.toString((int) cell.getNumericCellValue());
					}
					break;
				default:
					break;
				}
			}
		} catch (Exception e) {
		}
		return str;
	}

	public String getCellValueInt(Cell cell) {
		String str = "";
		try {
			if (cell != null) {
				int i = cell.getCellType();
				switch (i) {

				case Cell.CELL_TYPE_NUMERIC:
					str = Integer.toString((int) cell.getNumericCellValue());
					break;
				case Cell.CELL_TYPE_STRING:
					str = cell.getStringCellValue();
					break;
				case Cell.CELL_TYPE_BLANK:
					break;
				case Cell.CELL_TYPE_BOOLEAN:
					break;
				case Cell.CELL_TYPE_FORMULA:
					try {
						str = cell.getStringCellValue();
					} catch (Exception e) {
						str = Integer.toString((int) cell.getNumericCellValue());
					}
					break;
				default:
					break;
				}
			}
		} catch (Exception e) {
		}
		return str;
	}

	public String getCellValue(Cell cell, Workbook workbook) {

		FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
		String data = "";

		if (cell != null) {

			switch (cell.getCellType()) {
			case XSSFCell.CELL_TYPE_BOOLEAN:
				boolean bdata = cell.getBooleanCellValue();
				data = String.valueOf(bdata);
				break;
			case XSSFCell.CELL_TYPE_NUMERIC:
				if (HSSFDateUtil.isCellDateFormatted(cell)) {
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					data = formatter.format(cell.getDateCellValue());
				} else {
					// double ddata = cell.getNumericCellValue();
					// data = String.valueOf(ddata);
					data = Integer.toString((int) cell.getNumericCellValue());
				}
				break;
			case XSSFCell.CELL_TYPE_STRING:
				data = cell.toString();
				break;
			case XSSFCell.CELL_TYPE_BLANK:
			case XSSFCell.CELL_TYPE_ERROR:
			case HSSFCell.CELL_TYPE_FORMULA:
				if (!(cell.toString() == "")) {
					if (evaluator.evaluateFormulaCell(cell) == 0) {
						double fddata = cell.getNumericCellValue();
						data = String.valueOf(fddata);
					} else if (evaluator.evaluateFormulaCell(cell) == 1) {
						data = cell.getStringCellValue();
					} else if (evaluator.evaluateFormulaCell(cell) == 4) {
						boolean fbdata = cell.getBooleanCellValue();
						data = String.valueOf(fbdata);
					}
					break;
				}

			}
		}

		return data;
	}

	public String getCellValue(Cell cell, Workbook workbook, String str) {

		FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
		String data = str;

		if (cell != null) {

			switch (cell.getCellType()) {
			case XSSFCell.CELL_TYPE_BOOLEAN:
				boolean bdata = cell.getBooleanCellValue();
				data = String.valueOf(bdata);
				break;
			case XSSFCell.CELL_TYPE_NUMERIC:
				if (HSSFDateUtil.isCellDateFormatted(cell)) {
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
					data = formatter.format(cell.getDateCellValue());
				} else {
					// double ddata = cell.getNumericCellValue();
					// data = String.valueOf(ddata);
					data = Double.toString((double) cell.getNumericCellValue());

				}
				break;
			case XSSFCell.CELL_TYPE_STRING:
				data = cell.toString();
				break;
			case XSSFCell.CELL_TYPE_BLANK:
			case XSSFCell.CELL_TYPE_ERROR:
			case HSSFCell.CELL_TYPE_FORMULA:
				if (!(cell.toString() == "")) {
					if (evaluator.evaluateFormulaCell(cell) == 0) {
						double fddata = cell.getNumericCellValue();
						data = String.valueOf(fddata);
					} else if (evaluator.evaluateFormulaCell(cell) == 1) {
						data = cell.getStringCellValue();
					} else if (evaluator.evaluateFormulaCell(cell) == 4) {
						boolean fbdata = cell.getBooleanCellValue();
						data = String.valueOf(fbdata);
					}
					break;
				}

			}
		}

		if ("".equals(data.trim()))
			return str;

		return data.trim();
	}

	public JSONObject mapToJson(HashMap<String, String> map) throws Exception {

		JSONObject jo = new JSONObject();

		for (Entry<String, String> entry : map.entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();

			jo.put(key, value);
		}

		return jo;

	}

	public JSONArray resultListToJsonArray(List<Map<String, String>> resultList) throws Exception {

		JSONArray ja = new JSONArray();

		for (int j = 0; j < resultList.size(); j++) {
			ja.add(mapToJson((HashMap<String, String>) resultList.get(j)));
		}

		return ja;

	}

	public String nullchange(Object obj) {
		try {
			return obj.toString();
		} catch (Exception e) {
			return "";
		}
	}

	private Connection conn = null;

	public Connection getConnection(HttpServletRequest request) throws Exception {
		PROPERTIES_FILE = request.getSession().getServletContext().getRealPath("//WEB-INF//context.properties");
		Properties contextProperties = new Properties();
		FileInputStream fis = new FileInputStream(PROPERTIES_FILE);
		contextProperties.load(fis);

		try {
			Class.forName(contextProperties.getProperty("driver"));
		} catch (ClassNotFoundException e) {
		}
		// DB와 연결한다.
		try {

			conn = DriverManager.getConnection(contextProperties.getProperty("url"), contextProperties.getProperty("username"),
					contextProperties.getProperty("password"));
			// conn =
			// DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SAIT","SAIT");
			// System.out.println("GET Connection 시작=======================");

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return conn;
	}

}
