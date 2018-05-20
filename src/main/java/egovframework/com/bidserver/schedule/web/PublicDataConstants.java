package egovframework.com.bidserver.schedule.web;

public class PublicDataConstants {

	/**
	 * 데이터 베이스 SERVICE_KEY
	 */
//	public final String SERVICE_KEY = "TbkO4ZfpbfBtXIHtSLx8FWho7zanWEQMf0S%2FSSeGVAxvnVCq14pkt1%2BUR9hae9MNsvCqKhljr5U%2F3C8IiRQ1JA%3D%3D";
	public final String SERVICE_KEY = "15YE03CE4FeXLVbr780xBblRwV%2BNC3u22tO1XD1lQZbks85NBnmqLw9FT%2Bi5IzC91qdPp1hCcXFgJLCALkuN4w%3D%3D";

	/**
	 * 조달청 API 주소(REST)
	 */
	//public final String G2B = "http://openapi.g2b.go.kr/openapi/service/rest"; //1일 트래픽 1000건까지 가능.
	public final String APISData = "http://apis.data.go.kr/1230000"; //1일 트래픽 10만건까지 가능.

	/**
	 * 조달청 서비스 목록
	 */
	//public final String HrcspSsstndrdInfoService = "HrcspSsstndrdInfoService"; // 사전규격서비스
	public final String BidPublicInfoService = "BidPublicInfoService"; // 입찰공고정보서비스
	public final String ScsbidInfoService = "ScsbidInfoService"; // 낙찰정보조회서비스
	//public final String CntrctInfoService = "CntrctInfoService"; // 계약정보조회서비스
	//public final String DetailPrdnmFndThngClSystmService = "DetailPrdnmFndThngClSystmService"; // 물품분류체계서비스 => ThngListInfoService로 변경
	public final String ThngListInfoService = "ThngListInfoService"; // 물품목록정보서비스
	

	/**
	 * 조달청 서비스 상세
	 */
	//public final String getPublicPrcureThngInfoThng = "getPublicPrcureThngInfoThng"; // 나라장터_사전규격_물품_목록을_조회
//	public final String getPublicPrcureThngInfoFrgcpt = "getPublicPrcureThngInfoFrgcpt"; // 나라장터 사전규격 외자 목록을 조회

	public final String getBidPblancListInfoThng = "getBidPblancListInfoThng"; // 나라장터_입찰공고_물품_목록을_조회
	public final String getBidPblancListInfoPrtcptPsblRgn = "getBidPblancListInfoPrtcptPsblRgn"; //입찰공고목록 정보에 대한 참가가능 지역 정보조회
	public final String getBidPblancListInfoThngBsisAmount = "getBidPblancListInfoThngBsisAmount"; // 나라장터_입찰공고_물품_기초금액을_조회
	//public final String getBidRepblancListInfoThng = "getBidRepblancListInfoThng"; // 나라장터재입찰공고 물품 목록을 조회
	//public final String getBidRepblancListInfoThngBsisAmount = "getBidRepblancListInfoThngBsisAmount"; // 나라장터재입찰공고 물품 기초금액을 조회

//	public final String getBidPblancListInfoFclty = "getBidPblancListInfoFclty"; // 나라장터 입찰공고 시설 목록을 조회
//	public final String getBidPblancListInfoFcltyBsisAmount = "getBidPblancListInfoFcltyBsisAmount"; // 나라장터 입찰공고 시설 기초금액을 조회
//	public final String getBidPblancListInfoServc = "getBidPblancListInfoServc"; // 나라장터 입찰공고 용역 목록을 조회
//	public final String getBidPblancListInfoServcBsisAmount = "getBidPblancListInfoServcBsisAmount"; // 나라장터 입찰공고 용역 기초금액을 조회
//	public final String getBidPblancListInfoFrgcpt = "getBidPblancListInfoFrgcpt"; // 나라장터 입찰공고 외자 목록을 조회
//	public final String getBidPblancListInfoFrgcptBsisAmount = "getBidPblancListInfoFrgcptBsisAmount"; // 나라장터 입찰공고 외자 기초금액을 조회

	
//	public final String getScsbidListSttusThng = "getScsbidListSttusThng"; // 나라장터 최종낙찰자 물품 목록을 조회
//	public final String getScsbidListSttusFclty = "getScsbidListSttusFclty"; // 나라장터 최종낙찰자 시설 목록을 조회
//	public final String getScsbidListSttusServc = "getScsbidListSttusServc"; // 나라장터 최종낙찰자 용역 목록을 조회
//	public final String getScsbidListSttusFrgcpt = "getScsbidListSttusFrgcpt"; // 나라장터 최종낙찰자 외자 목록을 조회
//	public final String getScsbidListSttusSvemrg = "getScsbidListSttusSvemrg"; // 나라장터 최종낙찰자 리스 목록을 조회
//	public final String getScsbidListSttusSvemrg = "getScsbidListSttusSvemrg"; // 나라장터 최종낙찰자 비축 목록을 조회

	public final String getOpengResultListInfoThng = "getOpengResultListInfoThng"; // 나라장터 개찰결과 물품 목록을 조회
	public final String getOpengResultListInfoThngPreparPcDetail = "getOpengResultListInfoThngPreparPcDetail"; // 나라장터 개찰결과 물품 예비가격상세 목록을 조회

//	public final String getOpengResultListInfoFclty = "getOpengResultListInfoFclty"; // 나라장터 개찰결과 시설 목록을 조회
//	public final String getOpengResultListInfoFcltyPreparPcDetail = "getOpengResultListInfoFcltyPreparPcDetail"; // 나라장터 개찰결과 시설 예비가격상세 목록을 조회
//	public final String getOpengResultListInfoServc = "getOpengResultListInfoServc"; // 나라장터 개찰결과 용역 목록을 조회
//	public final String getOpengResultListInfoServcPreparPcDetail = "getOpengResultListInfoServcPreparPcDetail"; // 나라장터 개찰결과 용역 예비가격상세 목록을 조회
//	public final String getOpengResultListInfoFrgcpt = "getOpengResultListInfoFrgcpt"; // 나라장터 개찰결과 외자 목록을 조회
//	public final String getOpengResultListInfoFrgcptPreparPcDetail = "getOpengResultListInfoFrgcptPreparPcDetail"; // 나라장터 개찰결과 외자 예비가격상세 목록을 조회
//	public final String getOpengResultListInfoLease = "getOpengResultListInfoLease"; // 나라장터 개찰결과 리스 목록을 조회
//	public final String getOpengResultListInfoSvemrg = "getOpengResultListInfoSvemrg"; // 나라장터 개찰결과 비축 목록을 조회
	
	public final String getOpengResultListInfoOpengCompt = "getOpengResultListInfoOpengCompt"; // 나라장터 개찰결과 개찰완료 목록을 조회
	public final String getOpengResultListInfoFailing = "getOpengResultListInfoFailing"; // 나라장터 개찰결과 유찰 목록을 조회
	public final String getOpengResultListInfoRebid = "getOpengResultListInfoRebid"; // 나라장터 개찰결과 재입찰 목록을 조회

	//public final String getCntrctInfoListThngCntrctSttus = "getCntrctInfoListThngCntrctSttus"; // 나라장터 계약현황 물품 목록을 조회
	//public final String getCntrctInfoListThngCntrctSttusDetail = "getCntrctInfoListThngCntrctSttusDetail"; // 나라장터 계약현황 물품 계약물품 정보 목록을 조회

	//public final String getDetailPrdnmFndThngClSystmStrdInfo  = "getDetailPrdnmFndThngClSystmStrdInfo"; // 세부품명 물품분류체계기준정보조회 => getThngPrdnmLocplcAccotListInfoInfoPrdlstSearch로 변경
	public final String getThngPrdnmLocplcAccotListInfoInfoPrdlstSearch  = "getThngPrdnmLocplcAccotListInfoInfoPrdlstSearch"; // 목록정보(일반검색) 품목 목록 조회
	
	/**
	 * 나라장터 사전규격 물품 목록 엘리먼트
	 */
	public final String[] PUBLIC_PRCURE_THNG_INFO_THNG_ELEMENT = { 
			"물품",
			"참조번호", 
			"품목명", 
			"발주기관", 
			"실수요기관", 
			"배정예산액", 
			"접수일시", 
			"의견등록마감일시",
			"담당자전화번호", 
			"담당자명", 
			"sw사업대상여부", 
			"납품기한일시", 
			"납품일수", 
			"사전규격등록번호",
			"규격서화일1", 
			"규격서화일2", 
			"규격서화일3", 
			"규격서화일4", 
			"규격서화일5" 
	};

	public final String[] PUBLIC_PRCURE_THNG_INFO_THNG_METHOD = { 
			"bidType"
			,"refNo"
			,"titleNm"
			,"orderAgencyNm"
			,"demandNm"
			,"budget"
			,"regDt"
			,"regEndDt"
			,"regUserTel"
			,"regNm"
			,"swBizTargetYn"
			,"devLimitDt"
			,"devDtNum"
			,"stadRegNo"
			,"specFormFileNm1"
			,"specFormFileNm2"
			,"specFormFileNm3"
			,"specFormFileNm4"
			,"specFormFileNm5"
	};

	/**
	 * 나라장터 입찰공고 물품 목록 엘리먼트
	 */
	public final String[] BID_PBLANC_LIST_INFO_THNG_ELEMENT = { 
			"bidNtceNo", //입찰공고번호
			"bidNtceOrd", //입찰공고차수
			"reNtceYn", //재공고여부
			"rgstTyNm", //등록유형명 
			"ntceKindNm", //공고종류명 
			"intrbidYn", //국제입찰여부 
			"bidNtceDt", //입찰공고일시 
			"refNo", //참조번호 
			"bidNtceNm", //입찰공고명
			"ntceInsttCd", //공고기관코드 
			"ntceInsttNm", //공고기관명 
			"dminsttCd", //수요기관코드 
			"dminsttNm", //수요기관명 
			"bidMethdNm", //입찰방식명 
			"cntrctCnclsMthdNm", //계약체결방법명 
			"ntceInsttOfclNm", //공고기관담당자명
			"ntceInsttOfclTelNo", //공고기관담당자전화번호 
			"ntceInsttOfclEmailAdrs", //공고기관담당자이메일주소 
			"exctvNm", //집행관명 
			"bidQlfctRgstDt", //입찰참가자격등록마감일시 
			"cmmnSpldmdAgrmntRcptdocMethd", //공동수급협정서접수방식 
			"cmmnSpldmdAgrmntClseDt", //공동수급협정마감일시
			"cmmnSpldmdCorpRgnLmtYn", //공동수급업체지역제한여부 
			"bidBeginDt", //입찰개시일시 
			"bidClseDt", //입찰마감일시 
			"opengDt", //개찰일시 
			"ntceSpecDocUrl1", //공고규격서URL1
			"ntceSpecDocUrl2", //공고규격서URL2
			"ntceSpecDocUrl3", //공고규격서URL3
			"ntceSpecDocUrl4", //공고규격서URL4
			"ntceSpecDocUrl5", //공고규격서URL5
			"ntceSpecDocUrl6", //공고규격서URL6
			"ntceSpecDocUrl7", //공고규격서URL7
			"ntceSpecDocUrl8", //공고규격서URL8
			"ntceSpecDocUrl9", //공고규격서URL9
			"ntceSpecDocUrl10", //공고규격서URL10
			"ntceSpecFileNm1", //공고규격파일명1
			"ntceSpecFileNm2", //공고규격파일명2
			"ntceSpecFileNm3", //공고규격파일명3
			"ntceSpecFileNm4", //공고규격파일명4
			"ntceSpecFileNm5", //공고규격파일명5
			"ntceSpecFileNm6", //공고규격파일명6
			"ntceSpecFileNm7", //공고규격파일명7
			"ntceSpecFileNm8", //공고규격파일명8
			"ntceSpecFileNm9", //공고규격파일명9
			"ntceSpecFileNm10", //공고규격파일명10
			"rbidPermsnYn", //재입찰허용여부
			"prdctClsfcLmtYn", //물품분류제한여부
			"mnfctYn", //제조여부
			"prearngPrceDcsnMthdNm", //예정가격결정방법명 
			"totPrdprcNum", //총예가건수 
			"drwtPrdprcNum", //추첨예가건수 
			"asignBdgtAmt", //배정예산금액
			"presmptPrce", //추정가격 
			"opengPlce", //개찰장소 
			"bidNtceDtlUrl", //입찰공고상세URL 
			"bidNtceUrl", //입찰공고URL 
			"bidPrtcptFeePaymntYn", //입찰참가수수료납부여부 
			"bidPrtcptFee", //입찰참가수수료
			"bidGrntymnyPaymntYn", //입찰보증금납부여부
			"crdtrNm", //채권자명 
			"dtilPrdctClsfcNo", //세부품명번호 
			"dtilPrdctClsfcNoNm", //세부품명 
			"prdctSpecNm", //물품규격명
			"prdctQty", //물품수량
			"prdctUnit", //물품단위 
			"prdctUprc", //물품단가 
			"dlvrTmlmtDt", //납품기한일시 
			"dlvrDaynum", //납품일수 
			"dlvryCndtnNm", //인도조건명 
			"purchsObjPrdctList", //구매대상물품목록 
			"untyNtceNo", //통합공고번호
			"cmmnSpldmdMethdCd", //공동수급방식코드
			"cmmnSpldmdMethdNm", //공동수급방식명
			"stdNtceDocUrl", //표준공고서URL
			"brffcBidprcPermsnYn", //지사투찰허용여부
			"dsgntCmptYn", //지명경쟁여부
			"rsrvtnPrceReMkngMthdNm", //예비가격재작성방법명
			"arsltApplDocRcptMthdNm", //실적신청서접수방법명
			"arsltApplDocRcptDt", //실적신청서접수일시
			"orderPlanUntyNo", //발주계획통합번호
			"sucsfbidLwltRate", //낙찰하한율
			"rgstDt", //등록일시
			"bfSpecRgstNo", //사전규격등록번호
			"infoBizYn" //정보화사업여부
	};
	public final String[] BID_PBLANC_LIST_INFO_THNG_METHOD = { 
			"bid_notice_no"
			,"bid_notice_cha_no"
			,"re_ntce_yn"
			,"reg_type"
			,"notice_type"
			,"nation_bid_yn"
			,"noti_dt"
			,"ref_no"
			,"bid_notice_nm"
			,"order_agency_cd"
			,"order_agency_nm"
			,"demand_no"
			,"demand_nm"
			,"bid_method"
			,"contract_type_nm"
			,"reg_user_nm"
			,"reg_user_tel"
			,"reg_user_mail"
			,"executor_nm"
			,"bid_lic_reg_dt"
			,"part_sup_yn"
			,"part_sup_agree_form_reg_dt"
			,"part_sup_area_limit_yn"
			,"bid_start_dt"
			,"bid_end_dt"
			,"bid_open_dt"
			,"notice_spec_form1"
			,"notice_spec_form2"
			,"notice_spec_form3"
			,"notice_spec_form4"
			,"notice_spec_form5"
			,"notice_spec_form6"
			,"notice_spec_form7"
			,"notice_spec_form8"
			,"notice_spec_form9"
			,"notice_spec_form10"
			,"notice_spec_file_nm1"
			,"notice_spec_file_nm2"
			,"notice_spec_file_nm3"
			,"notice_spec_file_nm4"
			,"notice_spec_file_nm5"
			,"notice_spec_file_nm6"
			,"notice_spec_file_nm7"
			,"notice_spec_file_nm8"
			,"notice_spec_file_nm9"
			,"notice_spec_file_nm10"
			,"re_bid_permit_yn"
			,"goods_grp_limit_yn"
			,"product_yn"
			,"bid_price_type"
			,"bid_total_sch_price_num"
			,"bid_draw_sch_price_num"
			,"asgn_bugt_price"
			,"pre_price"
			,"open_place"
			,"notice_detail_link"
			,"notice_detail_link_url"
			,"bid_use_com_pay_yn"
			,"bid_use_com_val"
			,"bid_dept_com_pay_yn"
			,"creditor_nm"
			,"detail_goods_no"
			,"detail_goods_nm"
			,"stad_nm"
			,"quantity"
			,"unit"
			,"unit_price"
			,"dev_limit_dt"
			,"dev_dt_num"
			,"trans_cond_nm"
			,"buy_target_goods_info"
			,"main_notice_no"
			,"part_sup_comp_type"
			,"part_sup_comp_type_nm"
			,"stad_notice_form"
			,"branch_bid_use_yn"
			,"nomi_comp"
			,"bid_sch_price_upt_yn"
			,"result_apply_form_reg_type"
			,"result_apply_form_reg_dt"
			,"order_plan_unty_no"
			,"sucsfbidLwlt_rate"
			,"rgst_dt"
			,"bf_spec_rgst_no"
			,"info_biz_yn"
	};
	
	/**
	 * 입찰공고목록 정보에 대한 참가가능 지역 목록 엘리먼트
	 */
	public final String[] BID_PBLANC_LIST_INFO_PRTCPT_PSBL_RGN_ELEMENT = { 
			"bidNtceNo", //입찰공고번호
			"bidNtceOrd", //입찰공고차수
			"lmtGrpNo", //제한그룹번호
			"prtcptPsblRgnNm", //참가가능지역명 
			"rgstDt", //등록일시
	};
	public final String[] BID_PBLANC_LIST_INFO_PRTCPT_PSBL_RGN_METHOD = { 
			"bid_notice_no"
			,"bid_notice_cha_no"
			,"lmt_grp_no"
			,"prtcpt_psbl_rgn_nm"
			,"rgst_dt"
	};
	
	public final String[] BID_PBLANC_LIST_INFO_THNG_BSIS_AMOUNT_ELEMENT = { 
		"bidNtceNo" //입찰공고번호
		,"bidNtceOrd" //입찰공고차수
		,"bidClsfcNo" //입찰분류번호
		,"bidNtceNm" //입찰공고명
		,"bssamt" //기초금액
		,"bssamtOpenDt" //기초금액공개일시
		,"rsrvtnPrceRngBgnRate" //예비가격범위시작률
		,"rsrvtnPrceRngEndRate" //예비가격범위종료율
		,"evlBssAmt" //평가기준금액
		,"dfcltydgrCfcnt" //난이도계수
		,"etcGnrlexpnsBssRate" //기타경비기준율
		,"gnrlMngcstBssRate" //일반관리비기준율
		,"prftBssRate" //이윤기준율
		,"lbrcstBssRate" //노무비기준율
		,"industSftyHelthMngcst" //산업안전보건관리비
		,"rtrfundNon" //퇴직공제부금비
		,"envCnsrvcst" //환경보전비
		,"scontrctPayprcePayGrntyFee" //하도급대금지급보증수수료
		,"mrfnHealthInsrprm" //국민건강보험료
		,"npnInsrprm" //국민연금보험료
		,"rmrk1" //비고1
		,"rmrk2" //비고2
		,"usefulAmt" //가용금액
		,"inptDt" //입력일시
	};
	
	public final String[] BID_PBLANC_LIST_INFO_THNG_BSIS_AMOUNT_METHOD = { 
			"bid_notice_no"
			,"bid_notice_cha_no"
			,"bid_detail_num"
			,"bid_notice_nm"
			,"base_sch_price"
			,"base_price_open_dt"
			,"sch_price_term_from"
			,"sch_price_term_to"
			,"base_eval_price"
			,"level_num"
			,"base_order_percent"
			,"base_normal_manage_percent"
			,"base_margin_percent"
			,"base_work_percent"
			,"industry_manage_price"
			,"retire_price"
			,"environment_price"
			,"guarantee_charge"
			,"n_health_price"
			,"n_annuity_price"
			,"note1"
			,"note2"
			,"using_price"
			,"input_dt"
	};
	
	public final String[] SCSBID_LIST_STTUS_THNG_ELEMENT = { 
			"입찰번호"
			,"입찰공고차수"
			,"입찰분류"
			,"재입찰번호"
			,"공고구분"
			,"공고명"
			,"참가업체수"
			,"낙찰업체명"
			,"사업자등록번호"
			,"대표자명"
			,"주소"
			,"전화번호"
			,"낙찰금액"
			,"낙찰율"
	};
	
	public final String[] SCSBID_LIST_STTUS_THNG_METHOD = { 
			"bid_notice_no"
			,"bid_notice_cha_no"
			,"bid_part_type"
			,"bid_biz_re_seq_no"
			,"bid_notice_type"
			,"bid_notice_nm"
			,"cont_biz_num"
			,"cont_biz_nm"
			,"biz_reg_no"
			,"biz_owner_nm"
			,"biz_addr"
			,"biz_tel"
			,"cont_price"
			,"cont_percent"
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_THNG_ELEMENT = { 
			"bidNtceNo" //입찰공고번호
			,"bidNtceOrd" //입찰공고차수
			,"bidClsfcNo" //입찰분류번호
			,"rbidNo" //쟈압철본호
			,"bidNtceNm" //입찰공고명
			,"opengDt" //개찰일시
			,"prtcptCnum" //참가업체수
			,"opengCorpInfo" //개찰업체정보
			,"progrsDivCdNm" //진행구분코드명
			,"inptDt" //입력일시
			,"rsrvtnPrceFileExistnceYn" //예비가격파일존재여부
			,"ntceInsttCd" //공고기관코드
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_THNG_METHOD = { 
			"bid_notice_no"
			,"bid_notice_cha_no"
			,"bid_type"
			,"bid_biz_re_seq_no"
			,"bid_notice_nm"
			,"bid_open_dt"
			,"cont_biz_num"
			,"cont_biz_info"
			,"bid_step_type"
			,"input_dt"
			,"sch_price_use_yn"
			,"ntce_instt_cd"
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_THNG_PREPAR_PC_DETAIL_ELEMENT = { 
			"bidNtceNo" //입찰공고번호
			,"bidNtceOrd" //입찰공고차수
			,"bidClsfcNo" //입찰분류번호
			,"rbidNo" //재입찰번호
			,"bidNtceNm" //입찰공고명
			,"plnprc" //예정가격
			,"bssamt" //기초금액
			,"totRsrvtnPrceNum" //총예가건수
			,"compnoRsrvtnPrceSno" //복수예가순번
			,"bsisPlnprc" //기초예정가격
			,"drwtYn" //추첨여부
			,"drwtNum" //추첨횟수
			,"bidwinrSlctnAplBssCntnts" //최종낙찰자선정적용기준내용
			,"rlOpengDt" //실개찰일시
			,"bssamtBssUpNum" //기초금액기준상위건수
			,"compnoRsrvtnPrceMkngDt" //복수예비가격작성일시
			,"inptDt" //입력일시
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_THNG_PREPAR_PC_DETAIL_METHOD = { 
			"bid_notice_no"
			,"bid_notice_cha_no"
			,"bid_type"
			,"bid_biz_re_seq_no"
			,"bid_notice_nm"
			,"sche_price"
			,"base_price"
			,"bid_sch_total_price_num"
			,"compno_rsrvtn_prce_sno"
			,"base_sche_price"
			,"draw_result_yn"
			,"drwt_num"
			,"bidwinr_slctn_apl_bss_cntnts"
			,"rl_openg_dt"
			,"bssamt_bss_up_num"
			,"compno_rsrvtn_prce_mkng_dt"
			,"input_dt"
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_OPENG_COMPT_ELEMENT = { 
			"opengRsltDivNm" //개찰결과구분명
			,"bidNtceNo" //입찰공고번호
			,"bidNtceOrd" //입찰공고차수
			,"bidClsfcNo" //입찰분류번호
			,"rbidNo" //재입찰번호
			,"opengRank" //개찰순위
			,"prcbdrBizno" //투찰업체사업자등록번호
			,"prcbdrNm" //투찰업체명
			,"prcbdrCeoNm" //투찰업체대표자명
			,"bidprcAmt" //투찰금액
			,"bidprcrt" //투찰률
			,"rmrk" //비고
			,"cnsttyAccotBidAmtUrl" //공종별입찰금액URL
			,"drwtNo1" //추첨번호1
			,"drwtNo2" //추첨번호2
			,"bidprcDt" //투찰일시
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_OPENG_COMPT_METHOD = { 
			"bid_step_type"
			,"bid_notice_no"
			,"bid_notice_cha_no"
			,"bid_type"
			,"bid_biz_re_seq_no"
			,"open_rank"
			,"biz_reg_no"
			,"biz_nm"
			,"biz_owner_nm"
			,"bid_price"
			,"bid_percent"
			,"note"
			,"bid_price_link"
			,"drwt_no1"
			,"drwt_no2"
			,"bidprc_dt"
	};
	

	public final String[] OPENG_RESULT_LIST_INFO_FAILNB_ELEMENT = { 
			"opengRsltDivNm" //개찰결과구분명
			,"bidNtceNo" //입찰공고번호
			,"bidNtceOrd" //입찰공고차수
			,"bidClsfcNo" //입찰분류번호
			,"rbidNo" //재입찰번호
			,"nobidRsn" //유찰사유
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_FAILNB_METHOD = { 
			"bid_step_type"
			,"bid_notice_no"
			,"bid_notice_cha_no"
			,"bid_type"
			,"bid_biz_re_seq_no"
			,"non_cont_reason"
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_REBID_ELEMENT = { 
			"opengRsltDivNm" //개찰결과구분명
			,"bidNtceNo" //입찰공고번호
			,"bidNtceOrd" //입찰공고차수
			,"bidClsfcNo" //입찰분류번호
			,"rbidNo" //재입찰번호
			,"bidClseDt" //입찰마감일시
			,"opengDt" //개찰일시
			,"rbidRsn" //재입찰사유
			,"cmmnSpldmdAgrmntClseDt" //공동수급혐정마감일시
	};
	
	public final String[] OPENG_RESULT_LIST_INFO_REBID_METHOD = {
			"bid_step_type"
			,"bid_notice_no"
			,"bid_notice_cha_no"
			,"bid_type"
			,"bid_biz_re_seq_no"
			,"bid_end_dt"
			,"bid_open_dt"
			,"re_cont_reason"
			,"part_sup_agree_form_reg_dt"
	};
	
	public final String[] CNTRCT_INFO_LIST_THNG_CNTRCT_STTUS_ELEMENT = { 
			"통합계약번호"
			,"계약구분"
			,"확정계약번호"
			,"계약참조번호"
			,"계약건명"
			,"공동계약여부"
			,"장기계속구분"
			,"계약체결일자"
			,"계약기간"
			,"근거법률"
			,"총계약금액"
			,"금차계약금액"
			,"보증금율"
			,"링크URL"
			,"지급구분"
			,"요청번호"
			,"공고번호"
			,"계약기관코드"
			,"계약기관명"
			,"계약기관소관구분"
			,"계약기관담당부서명"
			,"계약기관담당자성명"
			,"계약기관담당자전화번호"
			,"계약기관담당자팩스번호"
			,"수요기관코드"
			,"수요기관명"
			,"수요기관소관구분"
			,"수요기관담당부서명"
			,"수요기관담당자성명"
			,"수요기관담당자전화번호"
			,"업체정보"
			,"대표여부"
			,"업종"
			,"지역"
			,"품목"
			,"금액"
			,"상세링크"
	};
	
	public final String[] CNTRCT_INFO_LIST_THNG_CNTRCT_STTUS_METHOD = { 
			"cont_seq_no"
			,"cont_type"
			,"fix_cont_seq_no"
			,"cont_ref_no"
			,"cont_title_nm"
			,"part_cont_yn"
			,"long_term_type"
			,"cont_dt"
			,"cont_term"
			,"reason_law"
			,"total_cont_price"
			,"this_time_cont_price"
			,"dept_price_percent"
			,"link_url"
			,"pay_type"
			,"req_no"
			,"bid_notice_no"
			,"cont_biz_cd"
			,"cont_biz_nm"
			,"cont_biz_type"
			,"cont_biz_part_nm"
			,"cont_biz_user_nm"
			,"cont_biz_tel"
			,"cont_biz_fax"
			,"demand_no"
			,"demand_nm"
			,"demand_type"
			,"demand_part_nm"
			,"demand_user_nm"
			,"demand_tel"
			,"cont_biz_info"
			,"cont_represent_yn"
			,"cont_biz_type"
			,"cont_biz_area"
			,"cont_goods"
			,"cont_price"
			,"cont_biz_detail_link"
	};

	public final String[] DETAIL_PRDNM_FND_THNG_CL_SYSTM_STRD_INFO_ELEMENT= {
			"sno", //순번
			"prdctImgLrge", //물품이미지(대)
			"prdctClsfcNo", //물품분류번호
			"prdctIdntNo", //물품식별번호
			"dtilPrdctClsfcNo", //세부품명번호
			"prdctClsfcNoNm", //품명
			"prdctClsfcNoEngNm", //영문품명
			"krnPrdctNm", //한글품목명
			"dltYn", //삭제유무
			"useYn", //사용여부
			"prcrmntCorpRgstNo", //조달업체등록번호
			"mnfctCorpNm" //제조업체명
	};
	
	public final String[] DETAIL_PRDNM_FND_THNG_CL_SYSTM_STRD_INFO_METHOD= {
			"no"
			,"prdct_img_lrge"
			,"prdct_clsfc_no"
			,"prdct_idnt_no"
			,"goods_no"
			,"prdct_clsfc_no_nm"
			,"prdct_clsfc_no_eng_nm"
			,"goods_nm"
			,"dlt_yn"
			,"use_yn"
			,"prcrmnt_corp_rgst_no"
			,"mnfct_corp_nm"
	};
}
