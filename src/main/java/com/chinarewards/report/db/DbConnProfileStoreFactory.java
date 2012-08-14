package com.chinarewards.report.db;

import com.chinarewards.report.db.impl.HardCodedConnProfileStoreFactory;

/**
 * 
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public abstract class DbConnProfileStoreFactory {

	/**
	 * Return the default instance of factory used by the whole system. Current
	 * implementation returns the <code>HardCodedConnProfileStoreFactory</code>
	 * instance.
	 * 
	 * @return
	 */
	public static DbConnProfileStoreFactory getFactory() {
		return new HardCodedConnProfileStoreFactory();
	}

	/**
	 * Returns the store.
	 * 
	 * @return
	 */
	public abstract DbConnProfileStore getProfileStore();

}
