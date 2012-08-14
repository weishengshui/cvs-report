/**
 * 
 */
package com.chinarewards.report.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 
 * 
 * @author cyril
 * @since 0.1.0 2010-03-25
 */
public class DbUtil {

	/**
	 * Checks whether the table name in the given connection does exist. This
	 * method is tested on Oracle 11.
	 * 
	 * @param conn
	 * @param tableName
	 * @return
	 */
	public static boolean isTableExists(Connection conn, String tableName) throws SQLException {

		String sql = "SELECT COUNT(*) FROM user_objects WHERE object_type = 'TABLE' AND object_name = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, tableName);
		ResultSet rs = stmt.executeQuery();
		rs.next();
		System.out.println("table count for " + tableName + ": " + rs.getLong(1));
		return rs.getLong(1) != 0;
		
	}
}
