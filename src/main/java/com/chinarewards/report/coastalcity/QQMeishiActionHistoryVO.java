package com.chinarewards.report.coastalcity;


/**
 * 
 * @author weishengshui
 *
 */
public class QQMeishiActionHistoryVO {

	private String shopName;//商家名称
	private String id;
	private String qqUserToken;//二维码
	private String aType;//优惠类型
	private double consumeAmt;//消费金额
	private double rebateAmt;//返回优惠额
	private String posId;
	private String time;//交易时间

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getQqUserToken() {
		return qqUserToken;
	}

	public void setQqUserToken(String qqUserToken) {
		this.qqUserToken = qqUserToken;
	}

	public String getAType() {
		return aType;
	}

	public void setAType(String aType) {
		this.aType = aType;
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


	
}
