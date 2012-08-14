package com.chinarewards.report.data.posapp;

import java.util.Date;

public class OnceConsumeShopReportVO {

	/**
	 * 会员卡号
	 */
	private String memberCardNo;

	/**
	 * 会员手机号
	 */
	private String memberMobile;

	/**
	 * 会员姓名
	 */
	private String memberName;

	/**
	 * 消费门市名称
	 */
	private String shopName;

	/**
	 * 门市地址
	 */
	private String shopAddress;

	/**
	 * 消费金额
	 */
	private String consumeMoney;

	/**
	 * 获取的积分
	 */
	private String point;

	/**
	 * 消费时间
	 */
	private Date date;

	private int consumeNum;

	public String getMemberCardNo() {
		return memberCardNo;
	}

	public void setMemberCardNo(String memberCardNo) {
		this.memberCardNo = memberCardNo;
	}

	public String getMemberMobile() {
		return memberMobile;
	}

	public void setMemberMobile(String memberMobile) {
		this.memberMobile = memberMobile;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public String getShopAddress() {
		return shopAddress;
	}

	public void setShopAddress(String shopAddress) {
		this.shopAddress = shopAddress;
	}

	public String getConsumeMoney() {
		return consumeMoney;
	}

	public void setConsumeMoney(String consumeMoney) {
		this.consumeMoney = consumeMoney;
	}

	public String getPoint() {
		return point;
	}

	public void setPoint(String point) {
		this.point = point;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public int getConsumeNum() {
		return consumeNum;
	}

	public void setConsumeNum(int consumeNum) {
		this.consumeNum = consumeNum;
	}
}
