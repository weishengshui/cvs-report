package com.chinarewards.report.coastalcity;

import java.util.List;
/**
 * 
 * @author weishengshui
 *
 */

public class QQMeishiActionHistoryShopVO {
	
	private String shopId;
	
	private String shopName;
	
	private double amount;
	
	
	private FunctionCountVo fcv;
	
	private List<EveryPosEveryTypeCount> everyPosEveryTypeCounts; 

	
	

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
	
	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public FunctionCountVo getFcv() {
		return fcv;
	}

	public void setFcv(FunctionCountVo fcv) {
		this.fcv = fcv;
	}

	public List<EveryPosEveryTypeCount> getEveryPosEveryTypeCounts() {
		return everyPosEveryTypeCounts;
	}

	public void setEveryPosEveryTypeCounts(
			List<EveryPosEveryTypeCount> everyPosEveryTypeCounts) {
		this.everyPosEveryTypeCounts = everyPosEveryTypeCounts;
	}


	

}
