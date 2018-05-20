package egovframework.com.bidserver.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

public class StringUtil extends StringUtils{

	public static String nvl(String str) {
		if (str == null || str.equals("null")) {
			return "";
		} else {
			return str;
		}

	}

	public static String nvlInt(String str) {
		if (str == null || str.equals("null") || str.equals("")) {
			return "0";
		} else {
			return str;
		}

	}

	/**
	 * 대상값의 NULL 여부를 체크 하여, NULL 일경우 변경값으로 돌려준다. 
	 *
	 * @param target 대상값
	 * @param changeVal 변경값
	 * @return
	 **/
	public static Object nvl(Object target, Object changeVal) {
		if(target == null) {
			return changeVal;
		}
		return target;
	}
	
	/**
	 * 날짜형 문자열 포맷처리
	 * 
	 * @param dateStr
	 *            20150101
	 * @param formatStr
	 *            yyyy-MM-dd
	 * @return
	 */
	public static String formatDate(String dateStr, String formatStr) {

		try {
			if (dateStr != null && dateStr.length() >= 8) {

				SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
				Calendar date = Calendar.getInstance();

				date.setTime(new SimpleDateFormat("yyyyMMdd").parse(dateStr));

				return sdf.format(date.getTime());
			}
		} catch (ParseException e) {
//			Log.e("mlhca","예외발생: util");
		}
		return "";
	}

	/**
	 * 날짜형 문자열 포맷처리
	 * 
	 * @param dateStr
	 *            20150101
	 * @param formatStr
	 *            yyyy-MM-dd
	 * @return
	 */
	public static String formatTime(String timeStr, String formatStr) {

		try {
			if (timeStr != null && timeStr.length() >= 4) {

				SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
				Calendar date = Calendar.getInstance();

				date.setTime(new SimpleDateFormat("HHmm").parse(timeStr));

				return sdf.format(date.getTime());
			}
		} catch (ParseException e) {
//			Log.e("mlhca","예외발생: util");
		}
		return "";
	}

	public static String formatDateAndTime(String dateStr, String formatStr) {

		try {
			if (dateStr != null && dateStr.length() >= 8) {

				SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
				Calendar date = Calendar.getInstance();

				date.setTime(new SimpleDateFormat("yyyyMMddHHmmss").parse(dateStr));

				return sdf.format(date.getTime());
			}
		} catch (ParseException e) {
//			Log.e("mlhca","예외발생: util");
		}
		return "";
	}

	/**
	 * 정규표현식을 이용해서 천단위 콤마 찍기
	 * 
	 * @param num
	 *            숫자형태의 문자열
	 * @return
	 */
	public static String setComma(String num) {

		// Null 체크
		if (num == null || num.isEmpty())
			return "0";

		// 숫자형태가 아닌 문자열일경우 디폴트 0으로 반환
		String numberExpr = "^[-+]?(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][-+]?[0-9]+)?$";
		boolean isNumber = num.matches(numberExpr);
		if (!isNumber)
			return "0";

		String strResult = num; // 출력할 결과를 저장할 변수
		Pattern p = Pattern.compile("(^[+-]?\\d+)(\\d{3})"); // 정규표현식
		Matcher regexMatcher = p.matcher(num);

		int cnt = 0;
		while (regexMatcher.find()) {
			strResult = regexMatcher.replaceAll("$1,$2"); // 치환 : 그룹1 + "," +
															// 그룹2

			// 치환된 문자열로 다시 matcher객체 얻기
			// regexMatcher = p.matcher(strResult);
			regexMatcher.reset(strResult);
		}
		return strResult;
	}

	public static String setComma(int num) {
		return setComma(String.valueOf(num));
	}
	
	public static String setDegree(String str, int num) {

		String returnStr="";
		if (str != null && str.length() > 0) {
			returnStr = str;
			while(returnStr.length() < num){
				returnStr = "0"+returnStr;
			}
		}
		return returnStr;
	}

}
