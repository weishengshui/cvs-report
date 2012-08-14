package com.chinarewards.report.qqvipadidas;

import java.util.List;

public class QQActiveHistoryVOOfShop implements
		Comparable<QQActiveHistoryVOOfShop> {

	private int shopId;
	private String shopName;

	List<QQActiveHistoryVO> voList;

	public int getShopId() {
		return shopId;
	}

	public void setShopId(int shopId) {
		this.shopId = shopId;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public List<QQActiveHistoryVO> getVoList() {
		return voList;
	}

	public void setVoList(List<QQActiveHistoryVO> voList) {
		this.voList = voList;
	}

	public int compareTo(QQActiveHistoryVOOfShop o) {
		return getShopId() - o.getShopId();
	}

}
