package com.chinarewards.report.db.impl;

import com.chinarewards.report.db.ValueBeanDbConnProfile;

/**
 * Concrete implementation of database connection profile for development
 * environment.
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public class DevDbConnProfileStore extends HardCodedDbConnProfileStore {

	/**
	 * The default connection string.
	 */
	private String connectionString;

	/**
	 * Constructors.
	 */
	public DevDbConnProfileStore() {
		super();

		connectionString = "jdbc:oracle:thin:@db.dev.china-rewards.com:1521:dev";
		initProfiles();
	}

	/**
	 * Initializes all profiles.
	 */
	private void initProfiles() {
		ValueBeanDbConnProfile p = null;

		// CRM
		p = new ValueBeanDbConnProfile(connectionString, "crm", "crm");
		this.addProfile("crm", p);

		// Procurement
		p = new ValueBeanDbConnProfile(connectionString, "supply", "supply");
		this.addProfile("supply", p);

		// app
		p = new ValueBeanDbConnProfile(connectionString, "posapp", "posapp");
		this.addProfile("posapp", p);

		// tx
		p = new ValueBeanDbConnProfile(connectionString, "tx_dev", "tx_dev");
		this.addProfile("tx", p);

		// szair
		p = new ValueBeanDbConnProfile(connectionString, "crmszair", "crmszair");
		this.addProfile("szair", p);

		// auth
		p = new ValueBeanDbConnProfile(connectionString, "auth", "auth");
		this.addProfile("auth", p);
		
		// finance
		p = new ValueBeanDbConnProfile(connectionString, "finance", "finance");
		this.addProfile("finance", p);
	}

}
