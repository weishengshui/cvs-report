/**
 * 
 */
package com.chinarewards.report.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 
 * 
 * @author cyril
 * @since 1.3.0 2010-01-14
 */
public class DbConnectionFactory {

	protected DbConnProfileStore store;

	/**
	 * Returns an new instance of <code>DbConnectionFactory</code> using the
	 * <code>DbConnProfileStore</code> returned by
	 * {@link DbConnProfileStoreFactory#getFactory()#getProfileStore()}
	 * 
	 * @return
	 */
	public static DbConnectionFactory getInstance() {
		return DbConnectionFactory.getInstance(DbConnProfileStoreFactory
				.getFactory().getProfileStore());
	}

	/**
	 * Returns an new instance of <code>DbConnectionFactory</code> using the
	 * given connection profile store.
	 * 
	 * @param store
	 * @return
	 */
	public static DbConnectionFactory getInstance(DbConnProfileStore store) {
		DbConnectionFactory factory = new DbConnectionFactory();
		factory.store = store;
		return factory;
	}

	/**
	 * Obtains a JDBC connection with matching profile name.
	 * 
	 * @param profileName
	 * @return the connection, or <code>null</code> if no profile is matched.
	 * @throws SQLException
	 */
	public Connection getConnection(String profileName) throws SQLException {
		DbConnProfile profile = store.getProfile(profileName);
		if (profile == null)
			return null;
		
		Connection conn = DriverManager.getConnection(profile.getConnectionString(),
				profile.getUsername(), profile.getPassword());
//		System.out.println("The driver is " + conn.getMetaData().getDriverVersion() );
//		System.out.println("The DBMS is " + conn.getMetaData().getDatabaseProductVersion() );		
		return conn;
	}

}
