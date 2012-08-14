package com.chinarewards.report.data.tiger2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class B2BService {

	Logger log = Logger.getLogger("B2BService");

	public List<ShopAccountApplication> getAllShopAccountApplication()
			throws Exception {

		log.info("Enter B2BService getAllShopAccountApplication");
		List<ShopAccountApplication> list = new ArrayList<ShopAccountApplication>();

		Connection tiger2conn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");

			tiger2conn = DbConnectionFactory.getInstance().getConnection(
					"tiger2");

			String sql = "select sap.id,sap.shopname,sap.status,sap.businesslicensecode,sap.contactpersonname,sap.contactemail,sap.contactphone,to_char(sap.createat,'yyyy-mm-dd hh24:mi:ss') from shopaccountapplication sap order by sap.createat desc";

			pstmt = tiger2conn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				ShopAccountApplication data = new ShopAccountApplication();
				data.setId(rs.getString(1));
				data.setShopName(rs.getString(2));
				data.setStatus(rs.getString(3));
				data.setBusinessLicenseCode(rs.getString(4));
				data.setContactPersonName(rs.getString(5));
				data.setContactEmail(rs.getString(6));
				data.setContactPhone(rs.getString(7));
				data.setCreateAt(rs.getString(8));
				list.add(data);
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			if (rs != null) {
				rs.close();
				rs = null;
			}

			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}

			if (tiger2conn != null) {
				SqlUtil.close(tiger2conn);
				tiger2conn = null;
			}

		}
		log.info("Enter B2BService getAllShopAccountApplication");
		return list;
	}

}
