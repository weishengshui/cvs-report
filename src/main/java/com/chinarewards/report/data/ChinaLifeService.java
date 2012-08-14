package com.chinarewards.report.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.chinarewards.report.data.crm.ChinaLifeMemberExchangeReportVO;
import com.chinarewards.report.data.crm.ConsumeData;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class ChinaLifeService {

	Logger log = Logger.getLogger("ChinaLifeService");

	public List<ConsumeData> getAllConsumeData() throws Exception {

		log.info("Enter ChinaLifeService getAllConsumeData");

		List<ConsumeData> list = new ArrayList<ConsumeData>();

		Connection appconn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");

			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			String sql = "select cp.membercardid,cp.shopname,cp.producttypename, cp.amountcurrency,cp.point, TO_CHAR(cp.transdate, 'yyyy-mm-dd hh24:mm:ss'),cp.merchantname from   clubpoint cp where cp.clubid='00' and cp.membercardid like '95519%' and isrollback = 0 ORDER by cp.transdate desc,cp.producttypename";

			pstmt = appconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				ConsumeData data = new ConsumeData();
				data.setMemberCardNo(rs.getString(1));
				data.setShopName(rs.getString(2));
				data.setConsumeType(rs.getString(3));
				data.setConsumeMoney(rs.getFloat(4));
				data.setPoint(rs.getFloat(5));
				data.setTransDataStr(rs.getString(6));
				data.setMerchantName(rs.getString(7));
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

			if (appconn != null) {
				SqlUtil.close(appconn);
				appconn = null;
			}

		}

		log.info("Exit ChinaLifeService getAllConsumeData list size is "
				+ (list == null ? "0" : list.size()));

		return list;
	}

	public List<ChinaLifeMemberExchangeReportVO> getAllExcnangeRecordOfChinaLife()
			throws Exception {

		log.info("Enter ChinaLifeService getAllExcnangeRecordOfChinaLife");

		List<ChinaLifeMemberExchangeReportVO> list = new ArrayList<ChinaLifeMemberExchangeReportVO>();

		Connection supplyconn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			Map<String, String> mapkey = new HashMap<String, String>();
			List<MemberIdAndCard> memberIds = getAllChinaLifeMember();
			StringBuffer mid = new StringBuffer();
			int z = 0;
			int size = memberIds.size();
			for (MemberIdAndCard memberIdAndCard : memberIds) {

				String memberId = memberIdAndCard.getMemberid();
				String chinalifecardno = memberIdAndCard.getChinalifeCardno();
				++z;
				if (z != size) {
					mid.append("'").append(memberIdAndCard.getMemberid())
							.append("'").append(",");
				} else {
					mid.append("'").append(memberIdAndCard.getMemberid())
							.append("'");
				}

				mapkey.put(memberId, chinalifecardno);

			}

			Class.forName("oracle.jdbc.driver.OracleDriver");

			supplyconn = DbConnectionFactory.getInstance().getConnection(
					"supply");

			String head = "select l.membercardcode, l.membername,l.nickname, m.mchnm ,l.applyamount, ma.applydt,ma.memberid from applydetail l, merchandise m, memberapply  ma where l.memberapply_id = ma.id and l.merchandise_id = m.id and  l.memberapply_id in( select id from memberapply where memberid in(";
			String tail = "))";

			String sql = head.concat(mid.toString()).concat(tail);

			log.info("hinaLifeService getAllExcnangeRecordOfChinaLife sql is "
					+ sql);

			pstmt = supplyconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				ChinaLifeMemberExchangeReportVO data = new ChinaLifeMemberExchangeReportVO();
				data.setExchangeCardno(rs.getString(1));
				data.setMembername(rs.getString(2));
				data.setSex(rs.getString(3));
				data.setMchName(rs.getString(4));
				data.setExchangeNum(rs.getInt(5));
				data.setExchangeTime(rs.getDate(6));
				data.setMemberId(rs.getString(7));

				String chinalifecardno = mapkey.get(data.getMemberId().trim());
				data.setChinalifeCardno(chinalifecardno);
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

			if (supplyconn != null) {
				SqlUtil.close(supplyconn);
				supplyconn = null;
			}

		}

		log
				.info("Exit ChinaLifeService getAllExcnangeRecordOfChinaLife list size is "
						+ (list == null ? "0" : list.size()));

		return list;

	}

	private List<MemberIdAndCard> getAllChinaLifeMember() throws Exception {

		log.info("Enter ChinaLifeService getAllChinaLifeMember");

		List<MemberIdAndCard> list = new ArrayList<MemberIdAndCard>();

		Connection crmconn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");

			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			String sql = "select memberid,cardno from tempcard where cardno like '95519%' and memberid is not null";

			pstmt = crmconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				MemberIdAndCard vo = new MemberIdAndCard();
				vo.setMemberid(rs.getString(1));
				vo.setChinalifeCardno(rs.getString(2));
				list.add(vo);
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

		}

		log.info("Exit ChinaLifeService getAllConsumeData list size is "
				+ (list == null ? "0" : list.size()));

		return list;
	}

	private class MemberIdAndCard {
		private String memberid;

		private String chinalifeCardno;

		public String getMemberid() {
			return memberid;
		}

		public void setMemberid(String memberid) {
			this.memberid = memberid;
		}

		public String getChinalifeCardno() {
			return chinalifeCardno;
		}

		public void setChinalifeCardno(String chinalifeCardno) {
			this.chinalifeCardno = chinalifeCardno;
		}

	}
}
