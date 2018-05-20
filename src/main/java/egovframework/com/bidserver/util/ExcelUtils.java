package egovframework.com.bidserver.util;

import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;

public class ExcelUtils {
	public static Map bind(HttpServletRequest request) throws IllegalArgumentException, IllegalAccessException, InstantiationException, ClassNotFoundException {
		Map map = new HashMap();
		Enumeration headerNames = request.getParameterNames();

		while (headerNames.hasMoreElements()) {
			String name = (String) headerNames.nextElement();
			String value = request.getParameter(name);
			map.put(name, value);
		}

		return map;
	}

	public static String getCellValue(Cell cell) {
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

	public static String getCellValueInt(Cell cell) {
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

	public static String getCellValue(Cell cell, Workbook workbook) {

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
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
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

	public static String getCellValue(Cell cell, Workbook workbook, String str) {

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

	public static JSONObject mapToJson(HashMap<String, String> map) throws Exception {

		JSONObject jo = new JSONObject();

		for (Entry<String, String> entry : map.entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();

			jo.put(key, value);
		}

		return jo;

	}

	public static JSONArray resultListToJsonArray(List<Map<String, String>> resultList) throws Exception {

		JSONArray ja = new JSONArray();

		for (int j = 0; j < resultList.size(); j++) {
			ja.add(mapToJson((HashMap<String, String>) resultList.get(j)));
		}

		return ja;

	}

	public static String nullchange(Object obj) {
		try {
			return obj.toString();
		} catch (Exception e) {
			return "";
		}
	}
}
