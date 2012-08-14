package com.chinarewards.report.data.tx;

import java.util.Date;

public class AccountInfo {

	private String id;

	private String accountId;

	/**
	 * whose this account belongs to
	 * 
	 * @author kmtong
	 */
	private String ownerId;

	/**
	 * Default unitCode for this account
	 * 
	 * @author kmtong
	 */
	private String defaultUnitCode;

	boolean avoidExpiry;

	double creditLimit;

	double usedCredit;

	String status;

	Date settlementDate;

	// 到帐积分
	float validPoint;

	// 冻结积分
	float freezePoint;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public String getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}

	public String getDefaultUnitCode() {
		return defaultUnitCode;
	}

	public void setDefaultUnitCode(String defaultUnitCode) {
		this.defaultUnitCode = defaultUnitCode;
	}

	public boolean isAvoidExpiry() {
		return avoidExpiry;
	}

	public void setAvoidExpiry(boolean avoidExpiry) {
		this.avoidExpiry = avoidExpiry;
	}

	public double getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(double creditLimit) {
		this.creditLimit = creditLimit;
	}

	public double getUsedCredit() {
		return usedCredit;
	}

	public void setUsedCredit(double usedCredit) {
		this.usedCredit = usedCredit;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getSettlementDate() {
		return settlementDate;
	}

	public void setSettlementDate(Date settlementDate) {
		this.settlementDate = settlementDate;
	}

	public float getValidPoint() {
		return validPoint;
	}

	public void setValidPoint(float validPoint) {
		this.validPoint = validPoint;
	}

	public float getFreezePoint() {
		return freezePoint;
	}

	public void setFreezePoint(float freezePoint) {
		this.freezePoint = freezePoint;
	}

}
