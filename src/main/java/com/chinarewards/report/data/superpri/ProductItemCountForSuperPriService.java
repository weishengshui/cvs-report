package com.chinarewards.report.data.superpri;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.logging.Logger;

import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class ProductItemCountForSuperPriService {

	Logger log = Logger.getLogger("ProductItemCountForSuperPriService");

	public List<ProductItemCountForSuperPri> getAllProductItemcountForSupperPriby(
			String contractStartDateFromStr, String contractStartDateToStr,
			String contractStatus, String contractEndDateFromStr,
			String contractEndDateToStr) throws Exception {
		log.info("Enter ProductItemCountForSuperPriService getAllProductItemcountForSupperPriby contractStatus is "
				+ contractStatus);

		log.info("DEBUG PARAMETER: contractStartDateFromStr : "
				+ contractStartDateFromStr + " contractStartTostr :"
				+ contractStartDateToStr + " contractEndDateFromStr :"
				+ contractEndDateFromStr + " contractEndDateToStr :"
				+ contractEndDateToStr);

		List<ProductItemCountForSuperPri> result = new LinkedList<ProductItemCountForSuperPri>();

		/**
		 * select supercon.id,supercon.effectivebegin
		 * begintime,supercon.effectiveend from contract supercon where
		 * supercon.p_type = 'SuperPrivilegePointContract' and supercon.status =
		 * '生效' and supercon.activeflag = 'effective'
		 * 
		 * select id as productid,name as productname from producttypeitem where
		 * id in( select pcd.producttypeitem_id from privilegecontractdetail pcd
		 * where pcd.activeflag = 'effective' and pcd.privilegecontract_id =
		 * 'ff8080812bcdc720012c3efc38a20063')
		 * 
		 * 
		 * 
		 * select id as shopid,name as shopname from shop shop where id in(
		 * select shop_id from shopprivilegecontractrelation shoppri where
		 * shoppri.privilegecontract_id = 'ff8080812bcdc720012c3efc38a20063')
		 * and shop.activeflag = 'effective'
		 **/

		Connection crmconn = null;
		// Connection appconn = null;
		Connection financeConn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String conStr = null;

		int n = Integer.valueOf(contractStatus);

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			// appconn =
			// DbConnectionFactory.getInstance().getConnection("posapp");
			financeConn = DbConnectionFactory.getInstance().getConnection(
					"finance");

			String start = "select supercon.id,supercon.effectivebegin begintime,supercon.effectiveend from contract supercon where supercon.p_type = 'SuperPrivilegePointContract' and supercon.status = '生效' and supercon.activeflag = 'effective' ";

			StringBuffer mid = new StringBuffer();

			switch (n) {
			case 1: // 进行中
			{
				mid.append(" and supercon.effectivebegin < sysdate");
				conStr = " and supercon.effectiveend > sysdate ";
				mid.append(conStr);
				break;
			}
			case 2: // 全部
			{
				break;

			}
			case 3: // 未开始
			{
				conStr = " and supercon.effectivebegin > sysdate";
				mid.append(conStr);
				break;
			}
			case 4: // 已结束
			{
				conStr = " and supercon.effectiveend < sysdate";
				mid.append(conStr);
				break;
			}
			default:
				log.info("invalidation contract Status " + n);
			}

			Map<Integer, String> eqlParameters = new HashMap<Integer, String>();
			int count = 0;

			SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
			if (contractStartDateFromStr != null
					&& !contractStartDateFromStr.isEmpty()) {
				conStr = " and supercon.effectivebegin >= ?";
				mid.append(conStr);
				eqlParameters.put(++count, contractStartDateFromStr);
			}

			if (contractStartDateToStr != null
					&& !contractStartDateToStr.isEmpty()) {
				conStr = " and supercon.effectivebegin < ?";
				mid.append(conStr);
				eqlParameters.put(++count, contractStartDateToStr);
			}

			if (contractEndDateFromStr != null
					&& !contractEndDateToStr.isEmpty()) {
				conStr = " and supercon.effectiveend >= ?";
				mid.append(conStr);
				eqlParameters.put(++count, contractEndDateFromStr);
			}

			if (contractEndDateToStr != null && !contractEndDateToStr.isEmpty()) {
				conStr = " and supercon.effectiveend < ?";
				mid.append(conStr);
				eqlParameters.put(++count, contractEndDateToStr);
			}

			String tail = " order by supercon.effectivebegin desc";

			String sql = start.concat(mid.toString()).concat(tail);

			log.info("in ProductItemCountForSuperPriService getAllProductItemcountForSupperPriby sql is "
					+ sql);

			pstmt = crmconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			Set<Entry<Integer, String>> set = eqlParameters.entrySet();
			for (Entry<Integer, String> obj : set) {
				log.info("Set data key:" + obj.getKey() + " value :"
						+ obj.getValue());
				pstmt.setDate(obj.getKey().intValue(), new java.sql.Date(format
						.parse(obj.getValue()).getTime()));
			}

			rs = pstmt.executeQuery();

			Map<String, SuperContract> superContractMap = new HashMap<String, SuperContract>();
			List<SuperContract> contracts = new ArrayList<SuperContract>();

			while (rs.next()) {
				SuperContract vo = new SuperContract();
				String superPriContractId = rs.getString(1);

				Date begintime = rs.getDate(2);
				Date endtime = rs.getDate(3);

				vo.setId(superPriContractId);
				vo.setBegintime(begintime);
				vo.setEndtime(endtime);

				contracts.add(vo);

				superContractMap.put(superPriContractId, vo);

			}

			log.info("super contract size is " + contracts.size());

			Map<String, List<Shop>> shopMap = new HashMap<String, List<Shop>>();

			List<ProductItem> allProductItems = new ArrayList<ProductItem>();

			for (SuperContract supercon : contracts) {
				String contractId = supercon.getId();

				List<Shop> shops = this.getShopsBycontractId(contractId,
						crmconn);
				shopMap.put(contractId, shops);

				List<ProductItem> productItems = this
						.getProductItemsBycontractId(contractId, crmconn);

				allProductItems.addAll(productItems);

			}

			log.info("all product item size is " + allProductItems.size());

			for (ProductItem productItem : allProductItems) {
				String contractId = productItem.getSuperContractId();
				List<Shop> shops = shopMap.get(contractId);
				SuperContract contract = superContractMap.get(contractId);
				for (Shop shop : shops) {
					ProductItemCountForSuperPri value = new ProductItemCountForSuperPri();
					value.setBeginTime(contract.getBegintime());
					value.setEndTime(contract.getEndtime());
					value.setProductItemId(productItem.getProductItemId());
					value.setProductItemName(productItem.getProductItemName());
					value.setShopId(shop.getShopId());
					value.setShopName(shop.getShopName());
					result.add(value);
				}

			}

			result = this.fillStatisticData(result, financeConn);

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

			if (financeConn != null) {
				SqlUtil.close(financeConn);
				financeConn = null;
			}

		}

		log.info("Exit ProductItemCountForSuperPriService getAllProductItemcountForSupperPriby");

		return result;
	}

	public List<ProductItemCountForSuperPri> getAllProductItemcountForSupperPri()
			throws Exception {

		log.info("Enter ProductItemCountForSuperPriService getAllProductItemcountForSupperPri");

		List<ProductItemCountForSuperPri> result = new LinkedList<ProductItemCountForSuperPri>();

		/**
		 * select supercon.id,supercon.effectivebegin
		 * begintime,supercon.effectiveend from contract supercon where
		 * supercon.p_type = 'SuperPrivilegePointContract' and supercon.status =
		 * '生效' and supercon.activeflag = 'effective'
		 * 
		 * select id as productid,name as productname from producttypeitem where
		 * id in( select pcd.producttypeitem_id from privilegecontractdetail pcd
		 * where pcd.activeflag = 'effective' and pcd.privilegecontract_id =
		 * 'ff8080812bcdc720012c3efc38a20063')
		 * 
		 * 
		 * 
		 * select id as shopid,name as shopname from shop shop where id in(
		 * select shop_id from shopprivilegecontractrelation shoppri where
		 * shoppri.privilegecontract_id = 'ff8080812bcdc720012c3efc38a20063')
		 * and shop.activeflag = 'effective'
		 **/

		Connection crmconn = null;
		// Connection appconn = null;
		Connection financeConn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			// appconn =
			// DbConnectionFactory.getInstance().getConnection("posapp");
			financeConn = DbConnectionFactory.getInstance().getConnection(
					"finance");

			String sql = "select supercon.id,supercon.effectivebegin begintime,supercon.effectiveend from contract supercon where supercon.p_type = 'SuperPrivilegePointContract' and supercon.status = '生效' and supercon.activeflag = 'effective' order by supercon.effectivebegin desc";

			pstmt = crmconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			Map<String, SuperContract> superContractMap = new HashMap<String, SuperContract>();
			List<SuperContract> contracts = new ArrayList<SuperContract>();

			while (rs.next()) {
				SuperContract vo = new SuperContract();
				String superPriContractId = rs.getString(1);

				Date begintime = rs.getDate(2);
				Date endtime = rs.getDate(3);

				vo.setId(superPriContractId);
				vo.setBegintime(begintime);
				vo.setEndtime(endtime);

				contracts.add(vo);

				superContractMap.put(superPriContractId, vo);

			}

			log.info("super contract size is " + contracts.size());

			Map<String, List<Shop>> shopMap = new HashMap<String, List<Shop>>();

			List<ProductItem> allProductItems = new ArrayList<ProductItem>();

			for (SuperContract supercon : contracts) {
				String contractId = supercon.getId();

				List<Shop> shops = this.getShopsBycontractId(contractId,
						crmconn);
				shopMap.put(contractId, shops);

				List<ProductItem> productItems = this
						.getProductItemsBycontractId(contractId, crmconn);

				allProductItems.addAll(productItems);

			}

			log.info("all product item size is " + allProductItems.size());

			for (ProductItem productItem : allProductItems) {
				String contractId = productItem.getSuperContractId();
				List<Shop> shops = shopMap.get(contractId);
				SuperContract contract = superContractMap.get(contractId);

				for (Shop shop : shops) {
					ProductItemCountForSuperPri value = new ProductItemCountForSuperPri();
					value.setBeginTime(contract.getBegintime());
					value.setEndTime(contract.getEndtime());
					value.setProductItemId(productItem.getProductItemId());
					value.setProductItemName(productItem.getProductItemName());
					value.setShopId(shop.getShopId());
					value.setShopName(shop.getShopName());

					result.add(value);
				}

			}

			result = this.fillStatisticData(result, financeConn);

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

			if (financeConn != null) {
				SqlUtil.close(financeConn);
				financeConn = null;
			}

		}

		log.info("Exit ProductItemCountForSuperPriService getAllProductItemcountForSupperPri");

		return result;
	}

	private List<ProductItemCountForSuperPri> fillStatisticData(
			List<ProductItemCountForSuperPri> list, Connection finaceApp)
			throws Exception {
		List<String> productItemIds = new ArrayList<String>();
		Map<String, ProductItemCountForSuperPri> map = new HashMap<String, ProductItemCountForSuperPri>();
		for (ProductItemCountForSuperPri product : list) {
			productItemIds.add(product.getProductItemId());
			map.put(product.getProductItemId(), product);
		}

		List<StatisticDataForSuperPri> datas = queryStatisticDataByProductItemId(
				false, finaceApp, productItemIds);
		for (StatisticDataForSuperPri data : datas) {
			ProductItemCountForSuperPri product = map.get(data
					.getProductItemId());
			product.setTotalDegree(data.getTimes());
			product.setTotalMoney(data.getMoney());
			product.setTotalPoint(data.getPoints());
		}

		List<StatisticDataForSuperPri> paidedDatas = queryStatisticDataByProductItemId(
				true, finaceApp, productItemIds);
		for (StatisticDataForSuperPri data : paidedDatas) {
			ProductItemCountForSuperPri product = map.get(data
					.getProductItemId());
			product.setPaidedTotalTime(data.getTimes());
			product.setPaidedTotalMoney(data.getMoney());
			product.setPaidedTotalPoint(data.getPoints());
		}

		return list;
	}

	/**
	 * Just for assemble sql about In(?,?,?,?,?...)
	 * 
	 * @param length
	 * @return
	 */
	private static String preparePlaceHolders(int length) {
		StringBuilder builder = new StringBuilder();
		for (int i = 0; i < length;) {
			builder.append("?");
			if (++i < length) {
				builder.append(",");
			}
		}
		return builder.toString();
	}

	private static void setValues(PreparedStatement preparedStatement,
			Object... values) throws SQLException {
		for (int i = 0; i < values.length; i++) {
			preparedStatement.setObject(i + 1, values[i]);
		}
	}

	private List<StatisticDataForSuperPri> queryStatisticDataByProductItemId(
			boolean isPaided, Connection finaceApp, List<String> productItemIds)
			throws Exception {
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		try {

			String sql = "select md.consumetypeid,count(md.id),sum(md.consumptionamount),sum(md.units) from merchantdetail md WHERE 1=1";
			StringBuffer sb = new StringBuffer(sql);
			sb.append(" AND md.consumetypeid IN ( ");
			sb.append(preparePlaceHolders(productItemIds.size()));
			sb.append(" )");
			sb.append(" AND md.merchantbill_id IN (SELECT id FROM merchantbill WHERE merchantbill.createflag = 'NEW' AND merchantbill.billtype  = 'Privilege')");
			// Whether to statistic only paided part.
			if (isPaided) {
				sb.append(" AND md.paystatus IN ('full','half')");
			}
			sb.append("GROUP BY md.consumetypeid");

			log.info("at directlyQueryStatisticDataFromFinance  sb is " + sb.toString());
			pstmt = finaceApp.prepareStatement(sb.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			log.info("productItemIds size " + productItemIds.size());
			setValues(pstmt, productItemIds.toArray());
			// pstmt.setString(2, shopId);

			rs = pstmt.executeQuery();
			List<StatisticDataForSuperPri> datas = new ArrayList<StatisticDataForSuperPri>();
			if (rs.next()) {
				StatisticDataForSuperPri data = new StatisticDataForSuperPri();
				String productItemId = rs.getString(1);
				int count = rs.getInt(2);
				float totalmoney = rs.getFloat(3);
				float totalpoint = rs.getFloat(4);
				data.setProductItemId(productItemId);
				data.setTimes(count);
				data.setMoney(totalmoney);
				data.setPoints(totalpoint);
				datas.add(data);
			}

			if (rs != null) {
				rs.close();
				rs = null;
			}

			return datas;
		} catch (Exception e) {
			throw e;
		} finally {
			if (rs != null) {
				rs.close();
				rs = null;
			}

			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
		}

	}

	// private List<ProductItemCountForSuperPri> getLastResult(
	// List<ProductItemCountForSuperPri> list, Connection finaceApp,
	// boolean isPaided) throws Exception {
	//
	// log.info("Enter ProductItemCountForSuperPriService getlastResult");
	//
	// ResultSet rs = null;
	// PreparedStatement pstmt = null;
	// try {
	// // String sql =
	// //
	// "select count(sd.id),sum(sd.consumemoney),sum(sd.point) from clubpoint cp ,salesdetail sd where  cp.id = sd.clubpoint_id and sd.consumetypeid = ? and cp.shopid = ? and cp.isrollback = 0 and cp.clubid = '00'";
	// // modify by yanxin 2011-03-15 Change the datasource from app to
	// // finance.
	// String sql =
	// "select count(md.id),sum(md.consumptionamount),sum(md.units) from merchantdetail md WHERE  md.consumetypeid=? AND md.merchantbill_id IN (SELECT id FROM merchantbill WHERE merchantbill.createflag = 'NEW' AND merchantbill.billtype  = 'Privilege')";
	// // Whether to statistic only paided part.
	// if (isPaided) {
	// sql += " AND md.paystatus IN ('full','half')";
	// }
	// // If distinguish pay or not pay. Need to add eg. AND md.paystatus
	// // IN ('full','half')
	// // empty("未结账"),full("已结账"),half("部分结账"),inchoate("付款未结束")
	//
	// log.info("at getlastresult  sql is " + sql);
	// pstmt = finaceApp.prepareStatement(sql,
	// ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
	//
	// for (ProductItemCountForSuperPri product : list) {
	// String productItemId = product.getProductItemId();
	// String shopId = product.getShopId();
	//
	// log.info("shopId is " + shopId + " and productItemId is "
	// + productItemId);
	// pstmt.setString(1, productItemId);
	// // pstmt.setString(2, shopId);
	//
	// rs = pstmt.executeQuery();
	//
	// if (rs.next()) {
	// int count = rs.getInt(1);
	// float totalmoney = rs.getFloat(2);
	// float totalpoint = rs.getFloat(3);
	// product.setTotalDegree(count);
	// product.setTotalMoney(totalmoney);
	// product.setTotalPoint(totalpoint);
	// }
	//
	// if (rs != null) {
	// rs.close();
	// rs = null;
	// }
	// }
	// } catch (Exception e) {
	// throw e;
	// } finally {
	//
	// if (rs != null) {
	// rs.close();
	// rs = null;
	// }
	//
	// if (pstmt != null) {
	// pstmt.close();
	// pstmt = null;
	// }
	//
	// }
	//
	// log.info("Exit ProductItemCountForSuperPriService getlastResult");
	//
	// return list;
	// }

	private List<ProductItem> getProductItemsBycontractId(String contractId,
			Connection crmconn) throws SQLException {

		log.info("Enter ProductItemCountForSuperPriService getProductItemsBycontractId");

		List<ProductItem> productItems = new ArrayList<ProductItem>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			String sql = "select id as productid,name as productname from producttypeitem where id in(select pcd.producttypeitem_id from privilegecontractdetail pcd where pcd.activeflag = 'effective' and pcd.privilegecontract_id = ?)";

			pstmt = crmconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, contractId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				String productId = rs.getString(1);
				String productName = rs.getString(2);
				ProductItem productItem = new ProductItem();
				productItem.setProductItemId(productId);
				productItem.setProductItemName(productName);
				productItem.setSuperContractId(contractId);
				productItems.add(productItem);
			}

		} catch (Exception e) {

		} finally {
			if (rs != null) {
				rs.close();
				rs = null;
			}

			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
		}

		log.info("Exit ProductItemCountForSuperPriService getProductItemsBycontractId  contractid is "
				+ contractId
				+ " and productitem size is "
				+ productItems.size());

		return productItems;
	}

	private List<Shop> getShopsBycontractId(String contractId,
			Connection crmconn) throws SQLException {

		log.info("Enter ProductItemCountForSuperPriService getShopsBycontractId contractId is "
				+ contractId);

		List<Shop> shops = new ArrayList<Shop>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			String sql = "select id as shopid,name as shopname from shop shop where id in(select shop_id from shopprivilegecontractrelation shoppri where shoppri.privilegecontract_id = ?) and shop.activeflag = 'effective'";

			pstmt = crmconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, contractId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				String shopId = rs.getString(1);
				String shopName = rs.getString(2);
				Shop shop = new Shop();
				shop.setShopId(shopId);
				shop.setShopName(shopName);
				shop.setSuperContractId(contractId);
				shops.add(shop);
			}

		} catch (Exception e) {

		} finally {
			if (rs != null) {
				rs.close();
				rs = null;
			}

			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
		}

		if (shops.size() < 1) {
			log.info("Exit ProductItemCountForSuperPriService getShopsBycontractId  contractid is "
					+ contractId + " and shop  is null");
		} else {
			log.info("Exit ProductItemCountForSuperPriService getShopsBycontractId  contractid is "
					+ contractId + " and shops size is " + shops.size());
		}

		return shops;
	}

	private class ProductItem {
		private String productItemId;
		private String productItemName;
		private String superContractId;

		public String getProductItemId() {
			return productItemId;
		}

		public void setProductItemId(String productItemId) {
			this.productItemId = productItemId;
		}

		public String getProductItemName() {
			return productItemName;
		}

		public void setProductItemName(String productItemName) {
			this.productItemName = productItemName;
		}

		public String getSuperContractId() {
			return superContractId;
		}

		public void setSuperContractId(String superContractId) {
			this.superContractId = superContractId;
		}

	}

	private class SuperContract {

		private String id;
		private Date begintime;
		private Date endtime;

		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}

		public Date getBegintime() {
			return begintime;
		}

		public void setBegintime(Date begintime) {
			this.begintime = begintime;
		}

		public Date getEndtime() {
			return endtime;
		}

		public void setEndtime(Date endtime) {
			this.endtime = endtime;
		}

	}

}
