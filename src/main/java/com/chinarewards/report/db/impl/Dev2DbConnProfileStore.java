package com.chinarewards.report.db.impl;

import com.chinarewards.report.db.ValueBeanDbConnProfile;

/**
 * Concrete implementation of database connection profile for development
 * environment since 2.0.0.
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public class Dev2DbConnProfileStore extends HardCodedDbConnProfileStore {

	/**
	 * The default connection string.
	 */
	private String connectionString;

	/**
	 * Constructors.
	 */
	public Dev2DbConnProfileStore() {
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
		p = new ValueBeanDbConnProfile(connectionString, "crm2", "crm2");
		this.addProfile("crm", p);

		// Procurement
		p = new ValueBeanDbConnProfile(connectionString, "supply2", "supply2");
		this.addProfile("supply", p);

		// app
		p = new ValueBeanDbConnProfile(connectionString, "posapp2", "posapp2");
		this.addProfile("posapp", p);

		// tx
		p = new ValueBeanDbConnProfile(connectionString, "tx2", "tx2");
		this.addProfile("tx", p);

		// szair
		p = new ValueBeanDbConnProfile(connectionString, "szair2", "szair2");
		this.addProfile("szair", p);

		// auth
		p = new ValueBeanDbConnProfile(connectionString, "auth2", "auth2");
		this.addProfile("auth", p);
		
		// finance
		p = new ValueBeanDbConnProfile(connectionString, "finance2", "finance2");
		this.addProfile("finance", p);

	}

}
