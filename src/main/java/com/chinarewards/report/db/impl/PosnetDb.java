package com.chinarewards.report.db.impl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PosnetDb {

	private Statement stmt = null;
	private ResultSet rs = null;
	private Connection conn = null;
	String sql;
	String strurl;

	/**
	 * 缺省的构造函数
	 */
	public PosnetDb() {
	}

	/**
	 * 连接数据库
	 */
	public void OpenConn() {
		try {
			// 驱动的名称
			Class.forName("com.mysql.jdbc.Driver");
			// test system
			 String user = "root";
			 String passwd = "123456";
			 String ip = "192.168.4.240";
			 String strDBname = "mock_test_1";
			 
			// production system
//			String user = "report";
//			String passwd = "posnet";
//			//String ip = "10.1.1.99";
//			String ip = "119.146.223.2";
//			String strDBname = "posnet";
			conn = DriverManager.getConnection("jdbc:mysql://" + ip + "/"
					+ strDBname + "?user=" + user + "&password=" + passwd + "");// 访问的数据库的帐号密码
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("OpenConnection:" + e.getMessage());
		}
	}

	public ResultSet executeQuery(String sql) {
		stmt = null;
		rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
		} catch (SQLException e) {
			System.err.println("executeQuery:" + e.getMessage());
		}
		return rs;
	}

	public void executeUpdate(String sql) {
		stmt = null;
		try {
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			System.out.println("executeUpdate:" + e.getMessage());
		}
	}

	public void closeStmt() {
		try {
			stmt.close();
		} catch (SQLException e) {
			System.err.println("closeStmt:" + e.getMessage());
		}
	}

	public void closeConn() {
		try {
			conn.close();
		} catch (SQLException ex) {
			System.err.println("aq.closeConn:" + ex.getMessage());
		}
	}
}
