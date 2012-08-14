package com.chinarewards.report.data.crm;

import java.util.Date;

public class ConsumeData {

	private String clubpointId;

	private String memberCardNo;

	private String shopName;

	private String merchantName;

	private float consumeMoney;

	private float point;

	private String consumeType;

	private Date transDate;

	private String transDataStr;

	private String memberTxId;

	private String posNo;

	private String contractNo;

	public String getMemberCardNo() {
		return memberCardNo;
	}

	public void setMemberCardNo(String memberCardNo) {
		this.memberCardNo = "'".concat(memberCardNo);
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public float getConsumeMoney() {
		return consumeMoney;
	}

	public void setConsumeMoney(float consumeMoney) {
		this.consumeMoney = consumeMoney;
	}

	public float getPoint() {
		return point;
	}

	public void setPoint(float point) {
		this.point = point;
	}

	public String getConsumeType() {
		return consumeType;
	}

	public void setConsumeType(String consumeType) {
		this.consumeType = consumeType;
	}

	public Date getTransDate() {
		return transDate;
	}

	public void setTransDate(Date transDate) {
		this.transDate = transDate;
	}

	public String getMemberTxId() {
		return memberTxId;
	}

	public void setMemberTxId(String memberTxId) {
		this.memberTxId = memberTxId;
	}

	public String getClubpointId() {
		return clubpointId;
	}

	public void setClubpointId(String clubpointId) {
		this.clubpointId = clubpointId;
	}

	public String getTransDataStr() {
		return transDataStr;
	}

	public void setTransDataStr(String transDataStr) {
		this.transDataStr = transDataStr;
	}

	public String getMerchantName() {
		return merchantName;
	}

	public void setMerchantName(String merchantName) {
		this.merchantName = merchantName;
	}

	public String getPosNo() {
		return posNo;
	}

	public void setPosNo(String posNo) {
		this.posNo = posNo;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

}
