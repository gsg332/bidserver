package egovframework.com.bidserver.bid.entity;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

import com.fasterxml.jackson.annotation.JsonRootName;

@XmlRootElement(name = "bidInfo2")
@JsonRootName("bidInfo2")
public class BidInfo2 implements Serializable {

	private static final long serialVersionUID = -1086651375831396547L;

	private String bid_no;
	private String bid_cha_no;
	private String bid_title_nm;
	private String dirt_prct;
	private String demand_nm;
	private String bid_method;
	private String bid_price_type;
	private String cont_method;
	private String budget_val;
	private String pre_price_val;
	private String base_price_val;
	private String goods_type_nm;
	private String goods_type_biz_nm;
	private String area_nm;
	private String bid_ent_std_dt;
	private String bid_ent_end_dt;
	private String public_sup_type;
	private String area_percent;
	private String pub_sup_agr_end_dt;
	private String bid_notice_dt;
	private String bid_std_dt;
	private String bid_end_dt;
	private String bid_open_dt;
	private String bid_price_choice;
	private String bid_price_range;
	private String bid_price_open_yn;
	private String bid_lot_num;
	private String bid_success;
	private String bid_user_nm;
	private String bid_user_tel;
	private String bid_step_nm;
	private String important_yn;

	public String getBid_no() {
		return bid_no;
	}

	public void setBid_no(String bid_no) {
		this.bid_no = bid_no;
	}

	public String getBid_cha_no() {
		return bid_cha_no;
	}

	public void setBid_cha_no(String bid_cha_no) {
		this.bid_cha_no = bid_cha_no;
	}

	public String getBid_title_nm() {
		return bid_title_nm;
	}

	public void setBid_title_nm(String bid_title_nm) {
		this.bid_title_nm = bid_title_nm;
	}

	public String getDirt_prct() {
		return dirt_prct;
	}

	public void setDirt_prct(String dirt_prct) {
		this.dirt_prct = dirt_prct;
	}

	public String getDemand_nm() {
		return demand_nm;
	}

	public void setDemand_nm(String demand_nm) {
		this.demand_nm = demand_nm;
	}

	public String getBid_method() {
		return bid_method;
	}

	public void setBid_method(String bid_method) {
		this.bid_method = bid_method;
	}

	public String getBid_price_type() {
		return bid_price_type;
	}

	public void setBid_price_type(String bid_price_type) {
		this.bid_price_type = bid_price_type;
	}

	public String getCont_method() {
		return cont_method;
	}

	public void setCont_method(String cont_method) {
		this.cont_method = cont_method;
	}

	public String getBudget_val() {
		return budget_val;
	}

	public void setBudget_val(String budget_val) {
		this.budget_val = budget_val;
	}

	public String getPre_price_val() {
		return pre_price_val;
	}

	public void setPre_price_val(String pre_price_val) {
		this.pre_price_val = pre_price_val;
	}

	public String getBase_price_val() {
		return base_price_val;
	}

	public void setBase_price_val(String base_price_val) {
		this.base_price_val = base_price_val;
	}

	public String getGoods_type_nm() {
		return goods_type_nm;
	}

	public void setGoods_type_nm(String goods_type_nm) {
		this.goods_type_nm = goods_type_nm;
	}

	public String getGoods_type_biz_nm() {
		return goods_type_biz_nm;
	}

	public void setGoods_type_biz_nm(String goods_type_biz_nm) {
		this.goods_type_biz_nm = goods_type_biz_nm;
	}

	public String getArea_nm() {
		return area_nm;
	}

	public void setArea_nm(String area_nm) {
		this.area_nm = area_nm;
	}

	public String getBid_ent_std_dt() {
		return bid_ent_std_dt;
	}

	public void setBid_ent_std_dt(String bid_ent_std_dt) {
		this.bid_ent_std_dt = bid_ent_std_dt;
	}

	public String getBid_ent_end_dt() {
		return bid_ent_end_dt;
	}

	public void setBid_ent_end_dt(String bid_ent_end_dt) {
		this.bid_ent_end_dt = bid_ent_end_dt;
	}

	public String getPublic_sup_type() {
		return public_sup_type;
	}

	public void setPublic_sup_type(String public_sup_type) {
		this.public_sup_type = public_sup_type;
	}

	public String getArea_percent() {
		return area_percent;
	}

	public void setArea_percent(String area_percent) {
		this.area_percent = area_percent;
	}

	public String getPub_sup_agr_end_dt() {
		return pub_sup_agr_end_dt;
	}

	public void setPub_sup_agr_end_dt(String pub_sup_agr_end_dt) {
		this.pub_sup_agr_end_dt = pub_sup_agr_end_dt;
	}

	public String getBid_notice_dt() {
		return bid_notice_dt;
	}

	public void setBid_notice_dt(String bid_notice_dt) {
		this.bid_notice_dt = bid_notice_dt;
	}

	public String getBid_std_dt() {
		return bid_std_dt;
	}

	public void setBid_std_dt(String bid_std_dt) {
		this.bid_std_dt = bid_std_dt;
	}

	public String getBid_end_dt() {
		return bid_end_dt;
	}

	public void setBid_end_dt(String bid_end_dt) {
		this.bid_end_dt = bid_end_dt;
	}

	public String getBid_open_dt() {
		return bid_open_dt;
	}

	public void setBid_open_dt(String bid_open_dt) {
		this.bid_open_dt = bid_open_dt;
	}

	public String getBid_price_choice() {
		return bid_price_choice;
	}

	public void setBid_price_choice(String bid_price_choice) {
		this.bid_price_choice = bid_price_choice;
	}

	public String getBid_price_range() {
		return bid_price_range;
	}

	public void setBid_price_range(String bid_price_range) {
		this.bid_price_range = bid_price_range;
	}

	public String getBid_price_open_yn() {
		return bid_price_open_yn;
	}

	public void setBid_price_open_yn(String bid_price_open_yn) {
		this.bid_price_open_yn = bid_price_open_yn;
	}

	public String getBid_lot_num() {
		return bid_lot_num;
	}

	public void setBid_lot_num(String bid_lot_num) {
		this.bid_lot_num = bid_lot_num;
	}

	public String getBid_success() {
		return bid_success;
	}

	public void setBid_success(String bid_success) {
		this.bid_success = bid_success;
	}

	public String getBid_user_nm() {
		return bid_user_nm;
	}

	public void setBid_user_nm(String bid_user_nm) {
		this.bid_user_nm = bid_user_nm;
	}

	public String getBid_user_tel() {
		return bid_user_tel;
	}

	public void setBid_user_tel(String bid_user_tel) {
		this.bid_user_tel = bid_user_tel;
	}

	public String getBid_step_nm() {
		return bid_step_nm;
	}

	public void setBid_step_nm(String bid_step_nm) {
		this.bid_step_nm = bid_step_nm;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getImportant_yn() {
		return important_yn;
	}

	public void setImportant_yn(String important_yn) {
		this.important_yn = important_yn;
	}
	
}
