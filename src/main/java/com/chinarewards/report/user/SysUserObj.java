package com.chinarewards.report.user;

public class SysUserObj {

	private String username;

	private String password;

	private UserLimits limits = new UserLimits();

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

	public UserLimits getLimits() {
		return limits;
	}

	public void setLimits(UserLimits limits) {
		this.limits = limits;
	}

	public boolean equals(SysUserObj user) {

		boolean result = false;
		if (this.username.equals(user.getUsername())
				&& this.password.equals(user.password)) {
			result = true;
		}
		return result;
	}

}
