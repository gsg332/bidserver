package egovframework.com.bidserver.sever.company.bidCompany.entity;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

import com.fasterxml.jackson.annotation.JsonRootName;


@XmlRootElement(name="bidcompany")
@JsonRootName("bidcompany")
public class Bidcompany implements Serializable{


	private static final long serialVersionUID = -1086651375831396547L;

	
	
	private String  id                           ;	//ID
	private String  password                     ;	//비밀번호
	private String  businessNo                   ;	//사업자번호
	private String  companyNm                    ;	//회사명칭
	private String  delegate                     ;	//대표자명
	private String  delegateExplain              ;	//대표자설명
	private String  companyType                  ;	//기업구분
	private String  companyRegistrationDay       ;	//사업자등록일
	private String  address                      ;	//기본주소
	private String  addressDetail                ;	//주소상세
	private String  phoneNo                      ;	//전화번호
	private String  mobileNo                     ;	//휴대전화
	private String  faxNo                        ;	//FAX번호
	private String  department                   ;	//담당부서
	private String  position                     ;	//직위
	private String  bidmanager                   ;	//입찰당당자
	private String  email                        ;	//EMAIL
	private String  businessCondition            ;	//업태
	private String  businessConditionDetail      ;  //종명
	private String  zipNo      					 ;  //우편번호
		
	
	public String getZipNo() {
		return zipNo;
	}
	public void setZipNo(String zipNo) {
		this.zipNo = zipNo;
	}
	public String getId() {                        
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getBusinessNo() {
		return businessNo;
	}
	public void setBusinessNo(String businessNo) {
		this.businessNo = businessNo;
	}
	public String getCompanyNm() {
		return companyNm;
	}
	public void setCompanyNm(String companyNm) {
		this.companyNm = companyNm;
	}
	public String getDelegate() {
		return delegate;
	}
	public void setDelegate(String delegate) {
		this.delegate = delegate;
	}
	public String getDelegateExplain() {
		return delegateExplain;
	}
	public void setDelegateExplain(String delegateExplain) {
		this.delegateExplain = delegateExplain;
	}
	public String getCompanyType() {
		return companyType;
	}
	public void setCompanyType(String companyType) {
		this.companyType = companyType;
	}
	public String getCompanyRegistrationDay() {
		return companyRegistrationDay;
	}
	public void setCompanyRegistrationDay(String companyRegistrationDay) {
		this.companyRegistrationDay = companyRegistrationDay;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getAddressDetail() {
		return addressDetail;
	}
	public void setAddressDetail(String addressDetail) {
		this.addressDetail = addressDetail;
	}
	public String getPhoneNo() {
		return phoneNo;
	}
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}
	public String getMobileNo() {
		return mobileNo;
	}
	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}
	public String getFaxNo() {
		return faxNo;
	}
	public void setFaxNo(String faxNo) {
		this.faxNo = faxNo;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getBidmanager() {
		return bidmanager;
	}
	public void setBidmanager(String bidmanager) {
		this.bidmanager = bidmanager;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getBusinessCondition() {
		return businessCondition;
	}
	public void setBusinessCondition(String businessCondition) {
		this.businessCondition = businessCondition;
	}
	public String getBusinessConditionDetail() {
		return businessConditionDetail;
	}
	public void setBusinessConditionDetail(String businessConditionDetail) {
		this.businessConditionDetail = businessConditionDetail;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}



	



	









}
