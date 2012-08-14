/**
 * 
 */
package com.chinarewards.report.data.crm;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Hashtable;

import com.chinarewards.report.sql.SqlUtil;

/**
 * Province, city, region data.
 * 
 * @author cyril
 * @since 1.3.0 2010-01-27
 */
public class PCRData {

	/**
	 * Returns all cities in the CRM. The key/value maps to the city ID and city
	 * name.
	 * 
	 * @param conn
	 * @return
	 */
	public Hashtable<String, String> getCitiesAsMap(Connection conn)
			throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT * FROM city ORDER BY id");
			Hashtable<String, String> list = new Hashtable<String, String>();
			while (rs.next()) {
				list.put(rs.getString("id"), rs.getString("name"));
			}
			return list;
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
		}
	}

	/**
	 * Returns all provinces in the CRM. The key/value maps to the province ID
	 * and province name.
	 * 
	 * @param conn
	 * @return
	 */
	public Hashtable<String, String> getProvincesAsMap(Connection conn)
			throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT * FROM province ORDER BY id");
			Hashtable<String, String> list = new Hashtable<String, String>();
			while (rs.next()) {
				list.put(rs.getString("id"), rs.getString("name"));
			}
			return list;
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
		}
	}

	/**
	 * Returns all regions in the CRM. The key/value maps to the region ID
	 * and region name.
	 * 
	 * @param conn
	 * @return
	 */
	public Hashtable<String, String> getRegionsAsMap(Connection conn)
			throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT * FROM region ORDER BY id");
			Hashtable<String, String> list = new Hashtable<String, String>();
			while (rs.next()) {
				list.put(rs.getString("id"), rs.getString("regionnm"));
			}
			return list;
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
		}
	}

}
