package com.chinarewards.report.db.impl;

import com.chinarewards.report.db.ValueBeanDbConnProfile;

/**
 * Concrete implementation of database connection profile for production
 * environment.
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public class ProductionDbConnProfileStore extends HardCodedDbConnProfileStore {

	/**
	 * The default connection string.
	 */
	private String connectionString;

	/**
	 * Constructors.
	 */
	public ProductionDbConnProfileStore() {
		super();

		connectionString = "jdbc:oracle:thin:@10.1.1.105:1521:CR";
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
		p = new ValueBeanDbConnProfile(connectionString, "tx", "tx");
		this.addProfile("tx", p);

		// szair
		p = new ValueBeanDbConnProfile(connectionString, "szair", "szair");
		this.addProfile("szair", p);

		// auth
		p = new ValueBeanDbConnProfile(connectionString, "auth", "auth");
		this.addProfile("auth", p);
		
		p = new ValueBeanDbConnProfile(connectionString, "tiger2", "tiger2");
		this.addProfile("tiger2", p);
		
		// finance
		p = new ValueBeanDbConnProfile(connectionString, "finance", "finance");
		this.addProfile("finance", p);
	}

}
