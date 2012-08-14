package com.chinarewards.report.db.impl;

import java.util.Hashtable;

import com.chinarewards.report.db.DbConnProfile;
import com.chinarewards.report.db.DbConnProfileStore;

/**
 * Defines the interface of a database connection profile store which stores a
 * pool of database connection profile.
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public abstract class HardCodedDbConnProfileStore implements DbConnProfileStore {
	
	/**
	 * Stores a map of profile name to profile object.
	 */
	protected Hashtable<String, DbConnProfile> profiles = new Hashtable<String, DbConnProfile>();

	/**
	 * Add a profile to the profile map with specified profile name.
	 */
	protected void addProfile(String profileName, DbConnProfile profile) {
		profiles.put(profileName, profile);
	}

	public DbConnProfile getProfile(String profileName) {
		DbConnProfile profile = this.profiles.get(profileName);
		return profile;
	}

}
