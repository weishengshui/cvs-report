package com.chinarewards.report.db;


/**
 * Simple implementation of <code>DbConnProfile</code> which is a simple 
 * value bean.
 *
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public class ValueBeanDbConnProfile implements DbConnProfile {

	private String connectionString;

	private String username;

	private String password;

	public ValueBeanDbConnProfile(String connString, String username,
			String password) {
		this.connectionString = connString;
		this.username = username;
		this.password = password;
	}

	public String getConnectionString() {
		return this.connectionString;
	}

	public String getUsername() {
		return this.username;
	}

	public String getPassword() {
		return this.password;
	}

}
