package com.chinarewards.report.data.auth;

import java.util.Date;

public class AuthUserInfo {

	private String id;

	private String username;

	private String password;

	private String userType;

	private String validateNumber;

	/**
	 * Last login time
	 * 
	 * @author kmtong
	 */
	private Date lastLogin;

	/**
	 * create date
	 */
	private Date createDate;

	/**
	 * expiry date (if not null) will be checked with the current date
	 */
	private Date expiry;

	/**
	 * True to allow login if and only if lastLogin is not null
	 */
	private boolean loginOnce;

	/**
	 * allow login degree in appointed time.
	 */
	private int reverieDegree;

	/**
	 * 从指定时间开始登陆失败的次数
	 */
	private int failDegree = 0;

	/**
	 * 指定统计登陆失败次数的开始标记
	 */
	private Date flag;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getValidateNumber() {
		return validateNumber;
	}

	public void setValidateNumber(String validateNumber) {
		this.validateNumber = validateNumber;
	}

	public Date getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public Date getExpiry() {
		return expiry;
	}

	public void setExpiry(Date expiry) {
		this.expiry = expiry;
	}

	public boolean isLoginOnce() {
		return loginOnce;
	}

	public void setLoginOnce(boolean loginOnce) {
		this.loginOnce = loginOnce;
	}

	public int getReverieDegree() {
		return reverieDegree;
	}

	public void setReverieDegree(int reverieDegree) {
		this.reverieDegree = reverieDegree;
	}

	public int getFailDegree() {
		return failDegree;
	}

	public void setFailDegree(int failDegree) {
		this.failDegree = failDegree;
	}

	public Date getFlag() {
		return flag;
	}

	public void setFlag(Date flag) {
		this.flag = flag;
	}

}
