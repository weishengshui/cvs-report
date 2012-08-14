package com.chinarewards.report.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;

import com.chinarewards.report.data.crm.ShopInfo;
import com.chinarewards.report.data.posapp.OnceConsumeShopReportVO;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class OnceConsumeShopService {
	Logger log = Logger.getLogger("OnceConsumeShopService");

	public List<OnceConsumeShopReportVO> getOnceConsumeShopReportList()
			throws Exception {
		log.info("Enter OnceConsumeShopService getOnceConsumeShopReportList");

		List<OnceConsumeShopReportVO> list = null;

		Connection appconn = null;

		Connection crmconn = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			Map<String, ShopInfo> shopMap = getAllShopInfo(crmconn);

			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			list = queryOnceConsumeShopReportVOList(appconn, crmconn, shopMap);
			

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			SqlUtil.close(crmconn);
			SqlUtil.close(appconn);
		}

		log
				.info("Exit OnceConsumeShopService getOnceConsumeShopReportList list size is "
						+ list.size());

		return list;
	}

	private Map<String, ShopInfo> getAllShopInfo(Connection conn)
			throws ClassNotFoundException, SQLException {

		log.info("Enter OnceConsumeShopService getAllShopInfo");

		Map<String, ShopInfo> shopMap = new HashMap<String, ShopInfo>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "select DISTINCT s.id,s.name,s.contactaddress "
				+ "FROM MERCHANT m,CONTRACT c, COOPERATIONDETAIL cd ,SHOP s "
				+ "WHERE m.id = s.merchant_id "
				+ "and s.activeflag = 'effective' "
				+ "AND m.activeflag = 'effective' "
				+ "AND m.id = cd.merchant_id "
				+ "AND c.cooperationdetail_id = cd.id "
				+ "AND c.activeflag = 'effective' " + "AND c.status = '生效' "
				+ "AND c.P_TYPE = 'PointContract' "
				+ "AND (sysdate BETWEEN c.effectivebegin AND c.effectiveend) "
				+ "AND m.merchanttype_id <> '5'";

		log.info("query getAllShopInfo sql is " + sql);

		pstmt = conn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
				ResultSet.CONCUR_READ_ONLY);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			ShopInfo shopInfo = new ShopInfo();
			String shopId = rs.getString(1);
			shopInfo.setShoId(shopId);
			shopInfo.setShopName(rs.getString(2));
			shopInfo.setShopAddress(rs.getString(3));
			shopMap.put(shopId, shopInfo);
		}

		if (rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();

		log.info("Exit OnceConsumeShopService getAllShopInfo shopMap.size is "
				+ shopMap.size());

		return shopMap;

	}

	private List<OnceConsumeShopReportVO> queryOnceConsumeShopReportVOList(
			Connection appconn, Connection crmconn,
			Map<String, ShopInfo> shopMap) throws SQLException {

		log
				.info("Enter OnceConsumeShopService queryOnceConsumeShopReportVOList");

		List<OnceConsumeShopReportVO> list = new ArrayList<OnceConsumeShopReportVO>();

		Set<String> shopIds = shopMap.keySet();

		// StringBuffer sql = new StringBuffer(
		// "select shopid,count(*) as maxcount,MAX(cp.transdate) as maxdate from clubpoint cp "
		// + "where transdate > ? "
		// + "and cp.clubid = '00' and cp.shopid in (");
		// int shopIdsLen = shopIds.size();
		// int i = 0;
		// for (String shopId : shopIds) {
		// sql.append("'").append(shopId).append("'");
		// i++;
		// if (i < shopIdsLen)
		// sql.append(",");
		// }
		//
		// sql.append(") and shopid is not null ");
		// sql.append("group by shopid having count(*) >=1 and count(*) <=150");

		Calendar cal = new GregorianCalendar();
		cal.set(Calendar.MONTH, cal.get(Calendar.MONTH) - 2);

		for (String shopId : shopIds) {

			ResultSet rs = null;

			String sql = "select count(id) from clubpoint cp where transdate > ? and cp.clubid = '00' and cp.shopid = ?";

			log.info("query getAllShopInfo sql is " + sql.toString());

			PreparedStatement pstmt = appconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			pstmt.setDate(1, new java.sql.Date(cal.getTime().getTime()));
			pstmt.setString(2, shopId);
			rs = pstmt.executeQuery();
			int count = 0;
			boolean invalidSum = false;
			if (rs.next()) {
				count = rs.getInt(1);
				if (count <= 10) {
					invalidSum = true;
				}
			}

			log.info("queryOnceConsumeShopReportVOList shopId is " + shopId
					+ " invalidSum " + invalidSum);

			rs.close();
			rs = null;
			pstmt.close();
			pstmt = null;

			if (invalidSum) {
				sql = "select cp.membercardid,cp.shopname,cp.amountcurrency,cp.point,cp.transdate,cp.memeberid from clubpoint cp where transdate > ? and cp.clubid = '00' and cp.shopid = ? order by transdate desc";
				pstmt = appconn
						.prepareStatement(sql.toString(),
								ResultSet.TYPE_FORWARD_ONLY,
								ResultSet.CONCUR_READ_ONLY);
				pstmt.setDate(1, new java.sql.Date(cal.getTime().getTime()));
				pstmt.setString(2, shopId);
				rs = pstmt.executeQuery();

				PreparedStatement crmpstmt = crmconn.prepareStatement(sql
						.toString(), ResultSet.TYPE_FORWARD_ONLY,
						ResultSet.CONCUR_READ_ONLY);

				if (rs.next()) {

					log.info("queryOnceConsumeShopReportVOList shopId is "
							+ shopId + " find validate record ");
					/**
					 * 会员卡号
					 */
					String memberCardNo = rs.getString(1);

					/**
					 * 消费门市名称
					 */
					String shopName = rs.getString(2);

					/**
					 * 消费金额
					 */
					String consumeMoney = String.valueOf(rs.getFloat(3));

					/**
					 * 获取的积分
					 */
					String point = String.valueOf(rs.getFloat(4));

					/**
					 * 消费时间
					 */
					Date date = rs.getDate(5);

					String memberId = rs.getString(6);

					OnceConsumeShopReportVO vo = new OnceConsumeShopReportVO();
					if (memberId != null) {
						String findmember = "select chisurname, chilastname, mobiletelephone from member where id = ?";

						crmpstmt = crmconn.prepareStatement(findmember,
								ResultSet.TYPE_FORWARD_ONLY,
								ResultSet.CONCUR_READ_ONLY);

						crmpstmt.setString(1, memberId);

						ResultSet rsmem = crmpstmt.executeQuery();

						if (rsmem.next()) {
							String chisurname = rsmem.getString(1);
							String chilastname = rsmem.getString(2);
							String memberMobile = rsmem.getString(3);
							String memberName = chisurname.concat(chilastname);
							vo.setMemberName(memberName);
							vo.setMemberMobile(memberMobile);
						} else {
							vo.setMemberName("系统无信息");
							vo.setMemberMobile("系统无信息");
						}

						rsmem.close();
						rsmem = null;
						crmpstmt.close();
						crmpstmt = null;
					} else {
						vo.setMemberName("临时会员");
						vo.setMemberMobile("");
					}

					ShopInfo shopInfo = shopMap.get(shopId);

					vo.setConsumeMoney(consumeMoney);
					vo.setDate(date);
					vo.setMemberCardNo(memberCardNo);
					vo.setShopName(shopName);
					vo.setPoint(point);
					vo.setShopAddress(shopInfo.getShopAddress());
					vo.setConsumeNum(count);
					list.add(vo);
				}
			}

			if (rs != null) {
				rs.close();
				rs = null;
			}

			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
		}

		log
				.info("Exit OnceConsumeShopService queryOnceConsumeShopReportVOList list size is "
						+ list.size());
		return list;
	}
}
