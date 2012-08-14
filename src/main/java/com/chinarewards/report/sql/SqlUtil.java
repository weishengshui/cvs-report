/**
 * 
 */
package com.chinarewards.report.sql;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Collection;

/**
 * SQL utility functions
 * 
 * @author cyril
 * @since 1.3.0 2010-01-13
 */
public class SqlUtil {

	/**
	 * Gracefully close a connection and mute all error.
	 * 
	 * @param conn
	 */
	public static final void close(Connection conn) {
		if (conn == null)
			return;
		try {
			conn.close();
			System.out.println("Closed connection " + conn);
		} catch (Throwable t) {
		}
	}

	/**
	 * Gracefully close a statement and mute all error.
	 * 
	 * @param stmt
	 */
	public static final void close(Statement stmt) {
		if (stmt == null)
			return;
		try {
			stmt.close();
		} catch (Throwable t) {
		}
	}

	/**
	 * Gracefully close a resultset and mute all error.
	 * 
	 * @param rs
	 */
	public static final void close(ResultSet rs) {
		if (rs == null)
			return;
		try {
			rs.close();
		} catch (Throwable t) {
		}
	}

	/**
	 * Builds a string which suits the need of delimited value list used for a a
	 * WHERE clause. For example, the output is
	 * 
	 * <pre>
	 *  A, B, C, D
	 * </pre>
	 * 
	 * If the list is empty, an empty string will be returned.
	 * 
	 * @param list
	 * @param isString
	 *            set <code>true</code> to specify the values are string and
	 *            therefore single quotes will be added.
	 * @return
	 */
	public static final String buildDelimitedValueList(Collection<String> list,
			boolean isString) {

		StringBuffer sb = new StringBuffer();
		String delim = ",";

		for (String s : list) {
			// add delimiter
			if (sb.length() > 0) {
				sb.append(delim);
			}
			// add the value
			if (isString) sb.append("'");
			sb.append(s);
			if (isString) sb.append("'");
		}

		return sb.toString();
	}
	
}
