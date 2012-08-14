package com.chinarewards.report.data.superpri;

import java.util.Date;

public class ProductItemCountForSuperPri {

	private String shopId;

	private String shopName;

	private String productItemId;

	private String productItemName;

	private Date beginTime;

	private Date endTime;

	private boolean isValid;

	private int totalDegree = 0;

	private double totalPoint = 0;

	private double totalMoney = 0;

	// add by yanxin 2011-03-16
	private int paidedTotalTime = 0;
	private double paidedTotalPoint = 0;
	private double paidedTotalMoney = 0;

	public String getShopId() {
		return shopId;
	}

	public void setShopId(String shopId) {
		this.shopId = shopId;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public String getProductItemName() {
		return productItemName;
	}

	public void setProductItemName(String productItemName) {
		this.productItemName = productItemName;
	}

	public Date getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(Date beginTime) {
		this.beginTime = beginTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public boolean isValid() {
		Date now = new Date();
		if (this.endTime.before(now)) {
			isValid = true;
		} else {
			isValid = false;
		}
		return isValid;
	}

	public int getTotalDegree() {
		return totalDegree;
	}

	public void setTotalDegree(int totalDegree) {
		this.totalDegree = totalDegree;
	}

	public double getTotalPoint() {
		return totalPoint;
	}

	public void setTotalPoint(double totalPoint) {
		this.totalPoint = totalPoint;
	}

	public double getTotalMoney() {
		return totalMoney;
	}

	public void setTotalMoney(double totalMoney) {
		this.totalMoney = totalMoney;
	}

	public String getProductItemId() {
		return productItemId;
	}

	public void setProductItemId(String productItemId) {
		this.productItemId = productItemId;
	}

	public int getPaidedTotalTime() {
		return paidedTotalTime;
	}

	public void setPaidedTotalTime(int paidedTotalTime) {
		this.paidedTotalTime = paidedTotalTime;
	}

	public double getPaidedTotalPoint() {
		return paidedTotalPoint;
	}

	public void setPaidedTotalPoint(double paidedTotalPoint) {
		this.paidedTotalPoint = paidedTotalPoint;
	}

	public double getPaidedTotalMoney() {
		return paidedTotalMoney;
	}

	public void setPaidedTotalMoney(double paidedTotalMoney) {
		this.paidedTotalMoney = paidedTotalMoney;
	}

}
