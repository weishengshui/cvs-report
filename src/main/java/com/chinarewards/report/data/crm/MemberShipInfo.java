package com.chinarewards.report.data.crm;

import java.util.Date;

public class MemberShipInfo {

	public static final String MEMBERSHIP = "membership";
	public static final String TEMPCARD = "tempcard";

	private String id;

	private String memberId;

	private String memberCardNo;

	private String cardId;

	private String cardName;

	private Date startDate;

	private String accountId;

	/**
	 * 卡的位置 membership 来自membership表 ，tempcard 来自tempcard 表
	 */
	private String cardLocation;

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getMemberCardNo() {
		return memberCardNo;
	}

	public void setMemberCardNo(String memberCardNo) {
		this.memberCardNo = memberCardNo;
	}

	public String getCardId() {
		return cardId;
	}

	public void setCardId(String cardId) {
		this.cardId = cardId;
	}

	public String getCardName() {
		return cardName;
	}

	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCardLocation() {
		return cardLocation;
	}

	public void setCardLocation(String cardLocation) {
		this.cardLocation = cardLocation;
	}

}
