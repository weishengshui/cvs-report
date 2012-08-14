package com.chinarewards.report.data.crm;

import java.util.Date;

public class ChinaLifeMemberExchangeReportVO {

	private String memberId;

	private String exchangeCardno;

	private String chinalifeCardno;

	private String membername;

	private String sex;

	private String mchName;

	private int exchangeNum;

	private Date exchangeTime;

	public String getMembername() {
		return membername;
	}

	public void setMembername(String membername) {
		this.membername = membername;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getMchName() {
		return mchName;
	}

	public void setMchName(String mchName) {
		this.mchName = mchName;
	}

	public int getExchangeNum() {
		return exchangeNum;
	}

	public void setExchangeNum(int exchangeNum) {
		this.exchangeNum = exchangeNum;
	}

	public Date getExchangeTime() {
		return exchangeTime;
	}

	public void setExchangeTime(Date exchangeTime) {
		this.exchangeTime = exchangeTime;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getExchangeCardno() {
		return exchangeCardno;
	}

	public void setExchangeCardno(String exchangeCardno) {
		this.exchangeCardno = exchangeCardno;
	}

	public String getChinalifeCardno() {
		return chinalifeCardno;
	}

	public void setChinalifeCardno(String chinalifeCardno) {
		this.chinalifeCardno = chinalifeCardno;
	}

}
