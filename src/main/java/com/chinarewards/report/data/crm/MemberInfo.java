package com.chinarewards.report.data.crm;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.chinarewards.report.data.auth.AuthUserInfo;
import com.chinarewards.report.data.tx.AccountInfo;

public class MemberInfo {

	private String id;

	private String name;

	private Date registdate;

	private String workaddress;

	private String mobile;

	private String email;

	private String qqnum;

	private String accountId;

	private List<MemberShipInfo> memberShipInfos;

	private AuthUserInfo authUserInfo;

	private List<AccountInfo> accountInfos;

	private List<String> accountIds = new ArrayList<String>();

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getRegistdate() {
		return registdate;
	}

	public void setRegistdate(Date registdate) {
		this.registdate = registdate;
	}

	public String getWorkaddress() {
		return workaddress;
	}

	public void setWorkaddress(String workaddress) {
		this.workaddress = workaddress;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public List<MemberShipInfo> getMemberShipInfos() {
		return memberShipInfos;
	}

	public void setMemberShipInfos(List<MemberShipInfo> memberShipInfos) {
		this.memberShipInfos = memberShipInfos;
	}

	public String getQqnum() {
		return qqnum;
	}

	public void setQqnum(String qqnum) {
		this.qqnum = qqnum;
	}

	public AuthUserInfo getAuthUserInfo() {
		return authUserInfo;
	}

	public void setAuthUserInfo(AuthUserInfo authUserInfo) {
		this.authUserInfo = authUserInfo;
	}

	public void setAccountIds(String accountId) {
		if (!accountIds.contains(accountId)) {
			accountIds.add(accountId);
		}
	}

	public List<String> getAccountIds() {
		return accountIds;
	}

	public String getAccountIdsAsString() {
		StringBuffer sb = new StringBuffer();
		int size = accountIds.size();
		for (int i = 0; i < size; i++) {
			sb.append(accountIds.get(i));
			if (i < size)
				sb.append(",");
		}

		return sb.toString();
	}

	public void setAccountInfos(List<AccountInfo> accountInfos) {
		this.accountInfos = accountInfos;
	}

	public List<AccountInfo> getAccountInfos() {
		return accountInfos;
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

}
