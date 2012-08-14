package com.chinarewards.report.db.impl;

import com.chinarewards.report.db.DbConnProfileStore;
import com.chinarewards.report.db.DbConnProfileStoreFactory;

/**
 * A hard coded implementation of <code>DbConnProfileStoreFactory</code>
 * 
 * <p>
 * User should change this implementation to return the appropiate concrete
 * instance of <code>DbConnProfileStore</code>.
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public class HardCodedConnProfileStoreFactory extends DbConnProfileStoreFactory {

	/**
	 * Current implementation always return a new instance of
	 * <code>DevDbConnProfileStore</code>.
	 * 
	 * @see DevDbConnProfileStore
	 * @see ProductionDbConnProfileStore
	 */
	@Override
	public DbConnProfileStore getProfileStore() {

		DbConnProfileStore store = null;

		// modify this code to switch between development and production

		// store = new Dev2DbConnProfileStore();
		store = new ProductionDbConnProfileStore();

		return store;
	}

}
