package com.chinarewards.report.qqvipadidas;

public class QQActiveHistoryVO {

	private String merchantName;
	private String id;
	private String memberkey;
	private String aType;
	private double consumeAmt;
	private double rebateAmt;
	private String posId;
	private String time;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getMemberkey() {
		return memberkey;
	}

	public void setMemberkey(String memberkey) {
		this.memberkey = memberkey;
	}

	public String getAType() {
		return aType;
	}

	public void setAType(String type) {
		aType = type;
	}

	public double getConsumeAmt() {
		return consumeAmt;
	}

	public void setConsumeAmt(double consumeAmt) {
		this.consumeAmt = consumeAmt;
	}

	public double getRebateAmt() {
		return rebateAmt;
	}

	public void setRebateAmt(double rebateAmt) {
		this.rebateAmt = rebateAmt;
	}

	public String getPosId() {
		return posId;
	}

	public void setPosId(String posId) {
		this.posId = posId;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getMerchantName() {
		return merchantName;
	}

	public void setMerchantName(String merchantName) {
		this.merchantName = merchantName;
	}

}
