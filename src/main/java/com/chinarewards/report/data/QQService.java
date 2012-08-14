package com.chinarewards.report.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.data.crm.ConsumeData;
import com.chinarewards.report.data.crm.MemberInfo;
import com.chinarewards.report.data.crm.MemberShipInfo;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class QQService {

	Logger log = Logger.getLogger("QQService");

	private static String qqflag = "QQ-";

	public List<ConsumeData> getAllQQConsumeData() throws Exception {

		log.info("Enter QQService getAllQQConsumeData");

		List<ConsumeData> list = new ArrayList<ConsumeData>();

		CommonService comms = new CommonService();

		Connection crmconn = null;
		Connection appconn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String organizationno = "qq";

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			String sql = "select cp.membercardid,cp.shopname,cp.amountcurrency,cp.point,cp.producttypename,cp.transdate from clubpoint cp where cp.transdate >= to_date('2010-07-01 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.clubid = '00' and cp.amountcurrency > 1 order by cp.transdate desc";

			pstmt = appconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				String memberCardNo = rs.getString(1);

				boolean bool = comms.checkOrgOfMemberCardNo(crmconn,
						organizationno, memberCardNo);

				if (bool) {
					String shopName = rs.getString(2);
					float consumeMoney = rs.getFloat(3);
					float point = rs.getFloat(4);
					String consumeType = rs.getString(5);
					Date transDate = rs.getDate(6);

					ConsumeData data = new ConsumeData();
					data.setMemberCardNo(memberCardNo);
					data.setConsumeMoney(consumeMoney);
					data.setConsumeType(consumeType);
					data.setPoint(point);
					data.setShopName(shopName);
					data.setTransDate(transDate);

					list.add(data);
				}

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
			if (crmconn != null) {
				SqlUtil.close(crmconn);
				crmconn = null;
			}

			if (appconn != null) {
				SqlUtil.close(appconn);
				appconn = null;
			}

		}

		log.info("Exit QQService getAllQQConsumeData list size is "
				+ (list == null ? "0" : list.size()));

		return list;
	}

	public List<MemberInfo> getAllQQRegiaterMemberInfo() throws Exception {
		List<MemberInfo> memberList = null;

		log.info("Enter QQService getAllQQRegiaterMemberInfo");

		Connection crmconn = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			memberList = getAllQQmember(crmconn);

			if (memberList != null) {
				for (MemberInfo minfo : memberList) {
					String memberId = minfo.getId();
					List<MemberShipInfo> msinfo = getCardInfoListOfMember(
							memberId, crmconn);
					minfo.setMemberShipInfos(msinfo);
					String qqnum = parseQQnum(msinfo);
					minfo.setQqnum(qqnum);
				}
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			if (crmconn != null) {
				SqlUtil.close(crmconn);
				crmconn = null;
			}

		}

		log.info("Exit QQService getAllQQRegiaterMemberInfo list size is "
				+ (memberList == null ? "0" : memberList.size()));

		return memberList;
	}

	public List<MemberShipInfo> getCardInfoListOfMember(String memberId)
			throws Exception {
		return getCardInfoListOfMember(memberId, null);
	}

	public List<MemberShipInfo> getCardInfoListOfMember(String memberId,
			Connection crmconn) throws Exception {

		log.info("Enter QQService getCardInfoListOfMember memberId is "
				+ memberId);

		List<MemberShipInfo> list = new ArrayList<MemberShipInfo>();

		boolean isCreateConn = false;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {

			if (crmconn == null) {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				crmconn = DbConnectionFactory.getInstance()
						.getConnection("crm");
				isCreateConn = true;
			}

			String sql = "select ms.membercardno,ms.startdate, car.cardname,car.id from membership ms INNER JOIN card car on ms.card_id = car.id and ms.activeflag in('effective','invalidate') and ms.member_id = ? ";

			pstmt = crmconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, memberId);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				MemberShipInfo info = new MemberShipInfo();
				info.setMemberId(memberId);
				info.setMemberCardNo(rs.getString(1));
				info.setStartDate(rs.getDate(2));
				info.setCardName(rs.getString(3));
				info.setCardId(rs.getString(4));

				list.add(info);

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
			if (isCreateConn && crmconn != null) {
				SqlUtil.close(crmconn);
				crmconn = null;
			}

		}

		log.info("Exit QQService getCardInfoListOfMember Cardlist size is "
				+ list.size());

		return list;
	}

	private List<MemberInfo> getAllQQmember(Connection crmconn)
			throws SQLException {
		log.info("Enter QQService getAllQQmember");

		List<MemberInfo> memberList = new ArrayList<MemberInfo>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "select DISTINCT(mem.id),mem.chisurname,mem.chilastname, mem.registdate,mem.workaddress,mem.mobiletelephone,mem.email from member mem inner join membership ms "
				.concat("on mem.id = ms.member_id ")
				.concat("and ms.id in( ")
				.concat("select id from membership ms where ms.card_id in( ")
				.concat(
						"select id from card car where car.organization_id = ( ")
				.concat(
						"select id from organization org where org.organizationno = 'qq' and org.activeflag = 'effective') ")
				.concat("and car.activeflag = 'effective') ")
				.concat(
						"and ms.activeflag = 'effective') order by mem.registdate desc");

		log.info("getAllQQmember sql is" + sql);

		pstmt = crmconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
				ResultSet.CONCUR_READ_ONLY);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			MemberInfo memInfo = new MemberInfo();
			memInfo.setId(rs.getString(1));
			String firstname = rs.getString(2);
			String lastname = rs.getString(3);
			memInfo.setName(firstname.concat(lastname));
			memInfo.setRegistdate(rs.getDate(4));
			memInfo.setWorkaddress(rs.getString(5));
			memInfo.setMobile(rs.getString(6));
			memInfo.setEmail(rs.getString(7));

			memberList.add(memInfo);
		}

		if (rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();

		log.info("Exit QQService getAllQQmember list size is "
				+ memberList.size());
		return memberList;
	}

	private static String parseQQnum(List<MemberShipInfo> msinfos) {

		String qq = "";

		for (MemberShipInfo msinfo : msinfos) {
			String cardno = msinfo.getMemberCardNo();
			if (cardno.startsWith(qqflag)) {
				qq = cardno.substring(qqflag.length());
				break;
			}
		}
		return qq;
	}

}
