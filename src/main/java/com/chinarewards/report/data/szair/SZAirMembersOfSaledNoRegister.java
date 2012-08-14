package com.chinarewards.report.data.szair;

import java.util.Date;

public class SZAirMembersOfSaledNoRegister {

	private String memberCardNo;

	private Date lastSalesDate;

	private String shopName;

	public String getMemberCardNo() {
		return memberCardNo;
	}

	public void setMemberCardNo(String memberCardNo) {
		this.memberCardNo = memberCardNo;
	}

	public Date getLastSalesDate() {
		return lastSalesDate;
	}

	public void setLastSalesDate(Date lastSalesDate) {
		this.lastSalesDate = lastSalesDate;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

}
