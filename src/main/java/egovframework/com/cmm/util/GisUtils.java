package egovframework.com.cmm.util;




/**
 * GIS 좌표 변환 및 응용처리
 * @author 윤해석
 * @since 2015.08.18
 * @version 1.0
 * @see 
 */

public class GisUtils {
	
	/**
     * lpad 함수
    *
     * @param str   대상문자열, len 길이, addStr 대체문자
    * @return      문자열
    */

    public static String lpad(String str, String addStr, int len) {
        String result = str;
        int templen   = len - result.length();

       for (int i = 0; i < templen; i++){
              result = addStr + result;
        }
        
        return result;
    }

	
	//degree-min-sec ... convert to decimal-degree-value.
	public static Double getToDegree(String degree,String  min,String  secnd1,String  secnd2) {
		return Double.parseDouble(degree)+(Double.parseDouble(min)/60)+(Double.parseDouble(secnd1+'.'+secnd2)/3600);
	}
	
	// degree-value ... convert to degree-min-sec.(format: 'DDDmmss.nnnnnnnnn..')
	public static String getToDms(double degree){
		String [] dms = new String[4]; // 0:degree, 1:min, 2:secnd1, 3:secnd2
		
		int dms0 = (int)degree; //정수부
		int dms1 = (int)((degree-dms0)*60); //소수부에 60을 곱한 후 정수부

		double tmp = (((degree-dms0)*60)-dms1)*60 ;
		
		int dms2 = (int)tmp;
		String dm3 = String.valueOf(tmp-dms2).substring(0,2) ; // 소수점이후..
		
		dms[0]=String.valueOf(dms0);
		
		if ( String.valueOf(dms1).length() < 2) { 
			dms[1] = lpad( String.valueOf(dms1),"0",2 );
		} else {
			dms[1] = String.valueOf(dms1);
		}
		
		if ( String.valueOf(dms2).length() < 2)  {
			dms[2] = lpad(String.valueOf(dms2),"0",2 );
		} else {
			dms[2] = String.valueOf(dms2);
		}
		
		return dms[0]+dms[1]+dms[2]+'.'+dms[3]; // returns 'DDDmmss.nnnnnnnnnn..'
	}
	
	// 반경(radius) 값에 따른 위/경도의 위상차를 취득.
	public static String getMeterToDegree(String flg, int radius){
		String str="";
		switch (radius)
		{
			case   500 :  if ("la".equals(flg)){ str = "0.005671231089428"; }else{ str = "0.004504982121142"; } break;
			case  1000 :  if ("la".equals(flg)){ str = "0.011342462178856"; }else{ str = "0.009009964242285"; } break;
			case  3000 :  if ("la".equals(flg)){ str = "0.034027386536569"; }else{ str = "0.027029892726854"; } break;
			case  5000 :  if ("la".equals(flg)){ str = "0.056712310894282"; }else{ str = "0.045049821211424"; } break;
			case 10000 :  if ("la".equals(flg)){ str = "0.113424621788564"; }else{ str = "0.090099642422847"; } break;
			case 20000 :  if ("la".equals(flg)){ str = "0.226849243577129"; }else{ str = "0.180199284845694"; } break;
			default : str= null; break;
		}
		return str;
	}
	
	// 반경(radius) 에 따른 위/경도의 실제 GIS위치를 취득.
	// returns dms-value
	public static String [] getCalcNearPos(double lng, double lat, int radius){
		String[] nearpos = new String[4]; 
		String incVal = getMeterToDegree("lo", radius);
		nearpos[0]=getToDms(lng + Double.parseDouble(incVal)); // east position's longitude. (latitude==기준점과 동일)
		nearpos[1]=getToDms(lng - Double.parseDouble(incVal)); // west position's longitude.

		incVal = getMeterToDegree("la", radius);
		nearpos[2]=getToDms(lat + Double.parseDouble(incVal)); // north position's latitude. (longitude==기준점과 동일)
		nearpos[3]=getToDms(lat - Double.parseDouble(incVal)); // south position's latitude.
		return nearpos;
	}
	
	// 거리계산
	// ref: 국토지리원 공개
	public static double getCalcDistance(double P1_longitude, double P1_latitude, double P2_longitude, double P2_latitude) {

		if ((P1_latitude == P2_latitude) && (P1_longitude == P2_longitude)) {
			return 0;
		}
		//double PI = 3.1415926535897932384626433832795;
		
		double e10 = P1_latitude * Math.PI / 180;
		double e11 = P1_longitude * Math.PI / 180;
		double e12 = P2_latitude * Math.PI / 180;
		double e13 = P2_longitude * Math.PI / 180;

		/* 타원체 GRS80 */
		double c16 = 6356752.314140910;
		double c15 = 6378137.000000000;
		double c17 = 0.0033528107;

		double f15 = c17 + c17 * c17;
		double f16 = f15 / 2;
		double f17 = c17 * c17 / 2;
		double f18 = c17 * c17 / 8;
		double f19 = c17 * c17 / 16;

		double c18 = Math.abs(e13 - e11); //e13 - e11
		double c20 = (1 - c17) * Math.tan(e10); // p1_lat
		double c21 = Math.atan(c20);
		double c22 = Math.sin(c21);
		double c23 = Math.cos(c21);
		double c24 = (1 - c17) * Math.tan(e12); // p2_lat
		double c25 = Math.atan(c24);
		double c26 = Math.sin(c25);
		double c27 = Math.cos(c25);

		double c29 = c18;
		double c31 = (c27 * Math.sin(c29) * c27 * Math.sin(c29))
				+ (c23 * c26 - c22 * c27 * Math.cos(c29))
				* (c23 * c26 - c22 * c27 * Math.cos(c29));
		double c33 = (c22 * c26) + (c23 * c27 * Math.cos(c29));
		double c35 = Math.sqrt(c31) / c33;
		double c36 = Math.atan(c35);
		double c38 = 0;
		if (c31 == 0) {
			c38 = 0;
		} else {
			c38 = c23 * c27 * Math.sin(c29) / Math.sqrt(c31);
		}

		double c40 = 0;
		if ((Math.cos(Math.asin(c38)) * Math.cos(Math.asin(c38))) == 0) {
			c40 = 0;
		} else {
			c40 = c33 - 2 * c22 * c26
					/ (Math.cos(Math.asin(c38)) * Math.cos(Math.asin(c38)));
		}

		double c41 = Math.cos(Math.asin(c38)) * Math.cos(Math.asin(c38))
				* (c15 * c15 - c16 * c16) / (c16 * c16);
		double c43 = 1 + c41 / 16384
				* (4096 + c41 * (-768 + c41 * (320 - 175 * c41)));
		double c45 = c41 / 1024 * (256 + c41 * (-128 + c41 * (74 - 47 * c41)));
		double c47 = c45
				* Math.sqrt(c31)
				* (c40 + c45
						/ 4
						* (c33 * (-1 + 2 * c40 * c40) - c45 / 6 * c40
								* (-3 + 4 * c31) * (-3 + 4 * c40 * c40)));
		double c50 = c17
				/ 16
				* Math.cos(Math.asin(c38))
				* Math.cos(Math.asin(c38))
				* (4 + c17
						* (4 - 3 * Math.cos(Math.asin(c38))
								* Math.cos(Math.asin(c38))));
		double c52 = c18
				+ (1 - c50)
				* c17
				* c38
				* (Math.acos(c33) + c50 * Math.sin(Math.acos(c33))
						* (c40 + c50 * c33 * (-1 + 2 * c40 * c40)));

		double c54 = c16 * c43 * (Math.atan(c35) - c47);
		return c54; // return distance in meter
	}
	
	//방위각 구하는 부분
	public static short bearingP1toP2(double P1_latitude, double P1_longitude, double P2_latitude, double P2_longitude) {
		// 현재 위치 : 위도나 경도는 지구 중심을 기반으로 하는 각도이기 때문에 
		//라디안 각도로 변환한다.
		double Cur_Lat_radian = P1_latitude * (3.141592 / 180);
		double Cur_Lon_radian = P1_longitude * (3.141592 / 180);
		// 목표 위치 : 위도나 경도는 지구 중심을 기반으로 하는 각도이기 때문에
		// 라디안 각도로 변환한다.
		double Dest_Lat_radian = P2_latitude * (3.141592 / 180);
		double Dest_Lon_radian = P2_longitude * (3.141592 / 180);
		// radian distance
		double radian_distance = 0;
		radian_distance = Math.acos(Math.sin(Cur_Lat_radian)
		  * Math.sin(Dest_Lat_radian) + Math.cos(Cur_Lat_radian)
		  * Math.cos(Dest_Lat_radian)
		  * Math.cos(Cur_Lon_radian - Dest_Lon_radian));
		// 목적지 이동 방향을 구한다.(현재 좌표에서 다음 좌표로 이동하기 위해서는 
		//방향을 설정해야 한다. 라디안값이다.
		double radian_bearing = Math.acos((Math.sin(Dest_Lat_radian) - Math
		  .sin(Cur_Lat_radian)
		  * Math.cos(radian_distance))
		  / (Math.cos(Cur_Lat_radian) * Math.sin(radian_distance)));
		// acos의 인수로 주어지는 x는 360분법의 각도가 아닌 radian(호도)값이다.
		double true_bearing = 0;
		if (Math.sin(Dest_Lon_radian - Cur_Lon_radian) < 0) {
		 true_bearing = radian_bearing * (180 / 3.141592);
		 true_bearing = 360 - true_bearing;
		} else {
		 true_bearing = radian_bearing * (180 / 3.141592);
		}
		return (short) true_bearing;
	}
	
	//팜스 거리 계산 공식
	public static float getDistanceArc(float sLat, float sLong, float dLat, float dLong){  
        final int radius=6371009;

        double uLat=Math.toRadians(sLat-dLat);
        double uLong=Math.toRadians(sLong-dLong);
        double a = Math.sin(uLat/2) * Math.sin(uLat/2) + Math.cos(Math.toRadians(sLong)) * Math.cos(Math.toRadians(dLong)) * Math.sin(uLong/2) * Math.sin(uLong/2);  
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));  
        double distance = radius * c;

        return Float.parseFloat(String.format("%.3f", distance/1000));
    }
   

	
}
