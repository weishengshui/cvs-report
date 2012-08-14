package com.chinarewards.report.data.pos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;
import com.chinarewards.report.util.DateUtil;

public class PosService {

	Log log = LogFactory.getLog(this.getClass());

	private static Map<String, String> setupVersionMap = new HashMap<String, String>();

	static {
		setupVersionMap.put("1.2.2.1", "JXT091130");
		setupVersionMap.put("2.0.0.0", "JXT100226 JXTD100226");
		setupVersionMap.put("2.0.0.1", "JXT100330");
		setupVersionMap.put("2.0.0.2", "JXT100423");
		setupVersionMap.put("2.0.0.3", "JXT100505");
		setupVersionMap.put("2.0.0.4", "JXT100804");
		setupVersionMap.put("2.0.0.5", "???");
	}

	public List<PosReportVO> getPosReport() throws Exception {

		log.info("Enter PosService getPosReport");

		List<PosReportVO> posList = new ArrayList<PosReportVO>();

		Connection crmconn = null;
		Connection appconn = null;

		ResultSet rs = null;
		PreparedStatement stmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			List<String> poslist = getEffectivePosList(crmconn);

			Map<String, Date> posmap = getPosMap(crmconn, appconn, poslist);

			Map<String, String> posVersionMap = getShopVersionMapFromPosstatus(
					appconn, poslist);

			Date now = new Date();

			String sql = "SELECT mer.name as merchant_name,mer.businessname AS merchant_businessname,s.name AS shop_name, pos.* FROM shop s INNER JOIN pos ON s.id=pos.shop_id LEFT JOIN merchant mer ON mer.id=s.merchant_id WHERE pos.activeflag='effective' and mer.activeflag='effective'";

			stmt = crmconn.prepareStatement(sql);
			rs = stmt.executeQuery();

			while (rs.next()) {

				PosReportVO posReportVO = new PosReportVO();
				posReportVO.setMerchangName(rs.getString("merchant_name"));
				posReportVO.setMerchantBusinessName(rs
						.getString("merchant_businessname"));
				posReportVO.setShopName(rs.getString("shop_name"));

				String posno = rs.getString("POSNO").trim();
				POSVO vo = new POSVO();
				vo.setId(rs.getString("ID"));
				vo.setPosno(posno);
				vo.setSimcard(rs.getString("SIMCARD"));
				vo.setInstallstatus(rs.getString("INSTALLSTATUS"));
				vo.setFinishdate(rs.getDate("FINISHDATE"));
				vo.setActiveflag(rs.getString("ACTIVEFLAG"));
				vo.setShipid(rs.getString("SHOP_ID"));
				vo.setPostype(rs.getString("POSTYPE"));
				vo.setCustocommtype(rs.getString("CUSTOMCOMMTYPE"));
				vo.setLastupdatetime(rs.getDate("LASTUPDATETIME"));
				long lastUnuseDays = getLastUnuseDaysByPosno(posmap, now, posno);
				vo.setLastUnuseDays(lastUnuseDays);
				String executeVersion = getPosVersionByPosno(posVersionMap,
						posno);
				vo.setExecuteVersion(executeVersion);
				vo.setSetupVersion(setupVersionMap.get(executeVersion));
				posReportVO.setPos(vo);

				posList.add(posReportVO);
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
			SqlUtil.close(crmconn);
			SqlUtil.close(appconn);
		}

		log.info("Exit PosService getPosReport poslist size is "
				+ posList.size());

		return posList;

	}

	private long getLastUnuseDaysByPosno(Map<String, Date> posmap, Date now,
			String posno) {
		long unUsedDays = -1;

		java.util.Date lastUsedDate = posmap.get(posno);

		if (lastUsedDate != null) {
			unUsedDays = DateUtil.getTwoDaysTimes(now, lastUsedDate);
		}

		return unUsedDays;
	}

	private Map<String, Date> getPosMap(Connection crmconn, Connection appconn,
			List<String> shopList) throws Exception {

		log.info("Enter PosService getPosMap");

		ResultSet rs = null;
		Statement stmt = null;

		Map<String, Date> posMap = new HashMap<String, Date>();

		try {

			String shopIds = getShopIdsForShopMap(shopList);

			String sql = "select DISTINCT(bl.posid),max(logdate) from businesslog bl where bl.posid is not null and ("
					+ shopIds + ") group by bl.posid";

			stmt = appconn.createStatement();

			rs = stmt.executeQuery(sql);

			while (rs.next()) {
				String posId = rs.getString(1).trim();
				java.util.Date date = rs.getDate(2);
				posMap.put(posId, date);
			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
		}

		log.info("Exit PosService getPosMap ");

		return posMap;
	}

	private String getShopIdsForShopMap(List<String> shops) throws Exception {

		log.info("Enter PosService getShopIdsForShopMap");

		StringBuffer shopIdbuf = new StringBuffer();

		for (int i = 0; i < shops.size(); i++) {

			shopIdbuf.append("bl.posid = '").append(shops.get(i).trim())
					.append("'").append(" or ");

		}

		int i = shopIdbuf.lastIndexOf("or");

		String shopIds = shopIdbuf.substring(0, i - 1);

		log.info("Exit PosService getShopIdsForShopMap shipIds is " + shopIds);

		return shopIds;
	}

	private List<String> getEffectivePosList(Connection crmconn)
			throws Exception {
		List<String> posnos = new ArrayList<String>();

		ResultSet rs = null;
		PreparedStatement stmt = null;

		try {

			String sql = "select DISTINCT(p.posno) from pos p where p.activeflag = 'effective' and posno is not null";

			stmt = crmconn.prepareStatement(sql);
			rs = stmt.executeQuery();

			while (rs.next()) {

				posnos.add(rs.getString(1));

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
		}

		return posnos;

	}

	private Map<String, String> getShopVersionMapFromPosstatus(
			Connection appconn, List<String> shopList) throws Exception {
		log.info("Enter PosService getShopVersionMapFromPosstatus");

		ResultSet rs = null;
		Statement stmt = null;

		Map<String, String> shopVersionMap = new HashMap<String, String>();

		try {
			String shopnos = getShopIdsForPosstatus(shopList);
			String sql = "select distinct(posno),max(reqkeyparam),max(lastupdatetime) from posstatus where action = 'LOGIN' and ("
					+ shopnos + ") group by posno";

			stmt = appconn.createStatement();
			rs = stmt.executeQuery(sql);

			while (rs.next()) {
				shopVersionMap.put(rs.getString(1).trim(), rs.getString(2)
						.trim());
			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
		}

		log.info("Exit PosService getShopVersionMapFromPosstatus  ");

		return shopVersionMap;
	}

	private String getShopIdsForPosstatus(List<String> shops) throws Exception {

		log.info("Enter PosService getShopIdsForPosstatus");

		StringBuffer shopIdbuf = new StringBuffer();

		for (int i = 0; i < shops.size(); i++) {

			shopIdbuf.append("posno = '").append(shops.get(i).trim()).append(
					"'").append(" or ");

		}

		int i = shopIdbuf.lastIndexOf("or");

		String shopIds = shopIdbuf.substring(0, i - 1);

		log
				.info("Exit PosService getShopIdsForPosstatus shipIds is "
						+ shopIds);

		return shopIds;
	}

	private String getPosVersionByPosno(Map<String, String> posVersionMap,
			String posno) {

		String version = posVersionMap.get(posno);
		return version;

	}

}
