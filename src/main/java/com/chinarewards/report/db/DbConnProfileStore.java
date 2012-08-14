package com.chinarewards.report.db;


/**
 * Defines the interface of a database connection profile store which stores 
 * a pool of database connection profile.
 *
 * @author cyril
 * @since 1.3.0 2010-01-14
 */
public interface DbConnProfileStore {

	/**
	 * Returns the database connection profile with matching profile name.
	 *
	 * @param profileName the name of the profile.
	 */
	public DbConnProfile getProfile(String profileName);

}
