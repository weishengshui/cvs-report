package com.chinarewards.report.data.superpri;

/**
 * Contains some statistic data.
 * 
 * @author yanxin
 * 
 */
public class StatisticDataForSuperPri {

	private String productItemId;
	private int times = 0;
	private double points = 0;
	private double money = 0;

	public String getProductItemId() {
		return productItemId;
	}

	public void setProductItemId(String productItemId) {
		this.productItemId = productItemId;
	}

	public int getTimes() {
		return times;
	}

	public void setTimes(int times) {
		this.times = times;
	}

	public double getPoints() {
		return points;
	}

	public void setPoints(double points) {
		this.points = points;
	}

	public double getMoney() {
		return money;
	}

	public void setMoney(double money) {
		this.money = money;
	}

}
