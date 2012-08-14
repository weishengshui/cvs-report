package com.chinarewards.report.db;

/**
 * Defines the interface of a database connection profile. A profile contains
 * configuration information for establishing a database connection.
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public interface DbConnProfile {

	public String getConnectionString();

	public String getUsername();

	public String getPassword();

}
