package com.chinarewards.report.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import au.com.bytecode.opencsv.CSVWriter;

import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class ReportServletForMemberShop extends HttpServlet {
	
	private static final long serialVersionUID = 2095322342200520440L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String cmd = req.getParameter("cmd");//reportMember,reportShop
		String from = req.getParameter("startDate");
		String to = req.getParameter("endDate");
		String flag = req.getParameter("flag");
//		System.out.println("[cmd]="+cmd);
//		System.out.println("[from]="+from);
//		System.out.println("[to]="+to);
//		System.out.println("[flag]="+flag);
		if (cmd!=null) {
			File tmpdir = new File(System.getProperty("java.io.tmpdir")+ File.separator + "preview");
	        if (!tmpdir.exists()) {
	            tmpdir.mkdir();
	        }
	        File file = null;
			if ("reportMember".equals(cmd)) {
				file = new File(tmpdir,"MemberInfo_Report.csv");
		        if (file.exists()) {
		        	file.delete();
		        }
		        if (from !=null && to!=null) {
		        	from = from+" 00:00";
		        	to = to+" 23:59";
		        	makeMemberReport(file,from,to,flag);
		        }
		        
			}
			if ("reportShop".equals(cmd)) {
				file = new File(tmpdir,"ShopInfo_Report.csv");
		        if (file.exists()) {
		        	file.delete();
		        }
		        if (from !=null && to!=null) {
		        	from = from+" 00:00";
		        	to = to+" 23:59";
		        	makeMerchantShopReport(file,from,to,flag);
		        }
		        
			}
			
			String fileName = URLEncoder.encode(file.getName(),"UTF-8");
			resp.setCharacterEncoding("utf-8");
			resp.setContentType("text/csv;charset=gbk");
			resp.setHeader("Content-Disposition", "attachment;filename=" + utf8ToGBK(fileName));
	        byte[] buf = new byte[1024];
	        int len;
	        OutputStream out = null;
	        BufferedInputStream in = null;
			try {
				 out = new BufferedOutputStream(resp.getOutputStream(), 512);
	             in = new BufferedInputStream(new FileInputStream(file), 256);
	             while ((len = in.read(buf)) != -1) {
	                 if (len > 0) {
	                     out.write(buf, 0, len);
	                 }
	                 out.flush();
	             }
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
	        	if (in!=null) {
	        		in.close();
	        	}
	        	if (out!=null) {
	        		out.close();
	        	}
	        }
		}
	}
	
	/**
	 * 
	 * @param fileName   fileName
	 * @param from       startTime
	 * @param to         endTime
	 * @param flag       1.use memberShip modifyTime
	 *                   2.use member modifyTime
	 * @throws ServletException
	 * @throws IOException
	 */
	private void makeMemberReport(File fileName,String from,String to,String flag) throws ServletException, IOException {
		Connection conn = null;
		ResultSet rs = null; 
		PreparedStatement stmt = null; 
		CSVWriter w = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DbConnectionFactory.getInstance().getConnection("crm");
			StringBuffer sql = new StringBuffer();
			sql.append(" select concat(m.chisurname, m.chilastname) as name, ");
			sql.append(" decode(m.gender,0,'男','女') as gender, ");
			sql.append(" m.mobiletelephone as mobile,m.email as email, ");
			sql.append(" ms.membercardno as card,m.workaddress as address, ");
			sql.append(" m.id as id ");
			sql.append(" from member m, membership ms  ");
			sql.append(" where m.id = ms.member_id  ");
			if ("1".equals(flag)) {
				//按发卡修改时间查
				sql.append(" and ms.lastupdatetime >= to_date('"+from+"','yyyy/mm/dd hh24:mi') ");
				sql.append(" and ms.lastupdatetime <= to_date('"+to+"','yyyy/mm/dd hh24:mi')");
			} else if("2".equals(flag)) {
				//按会员修改时间查
				sql.append(" and m.lastupdatetime >= to_date('"+from+"','yyyy/mm/dd hh24:mi') ");
				sql.append(" and m.lastupdatetime<=to_date('"+to+"','yyyy/mm/dd hh24:mi')");
			}
			
			sql.append(" order by m.lastupdatetime ");
			stmt = conn.prepareStatement(sql.toString());
			rs = stmt.executeQuery();
			w = new CSVWriter(new OutputStreamWriter(new FileOutputStream(fileName), "GB2312"),',','"');
			String[] head = new String[7];
			head[0] = "会员姓名";
			head[1] = "性别";
			head[2] = "电话";
			head[3] = "电邮";
			head[4] = "卡 号";
			head[5] = "地址";
			head[6] = "唯一ID";
			w.writeNext(head);
			while (rs.next()) {				
				String[] arr = new String[7];
				arr[0] = rs.getString("name");
				arr[1] = rs.getString("gender");
				arr[2] = rs.getString("mobile");
				arr[3] = rs.getString("email");
				arr[4] = "'"+rs.getString("card")+"'";
				String address = rs.getString("address");
				arr[5] = address!=null&&!"null".equals(address) ? address : "";
				arr[6] = rs.getString("id");
				w.writeNext(arr);
			}
		} catch (ClassNotFoundException e) {
			throw new ServletException(e);
		} catch (SQLException e) {
			throw new ServletException(e);
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
			SqlUtil.close(conn);
			try {
				w.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	private void makeMerchantShopReport(File fileName,String from,String to,String flag)throws ServletException, IOException  {
		Connection conn = null;
		ResultSet rs = null; 
		PreparedStatement stmt = null; 
		CSVWriter w = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DbConnectionFactory.getInstance().getConnection("crm");
			Map<String,String[]> map = new HashMap<String,String[]>();
			StringBuffer sb = new StringBuffer();
			sb.append(" select DISTINCT cp.name,cp.position,cp.mobile, cp.merchant_id ");
			sb.append(" from contactperson cp,contacttype ct,contacttype_contactperson cc ");
			sb.append(" where cp.id= cc.contactpersons_id and cc.contacttypes_id= ct.id and ct.type='第一联系人' ");
			stmt = conn.prepareStatement(sb.toString());
			rs = stmt.executeQuery();
			String[] d = null;
			while (rs.next()) {
				d = new String[3];
				d[0] = rs.getString("name");
				d[1] = rs.getString("position");
				d[2] = rs.getString("mobile");
				map.put(rs.getString("merchant_id"), d);
			}
			
			StringBuffer sql = new StringBuffer();
			sql.append(" select DISTINCT m.name as merchantname,ind.paravalue as indtype, ");
			sql.append(" s.name as shopname,s.contactperson as person, ");
			sql.append(" s.mobile as mobile,s.contactphone as phone, ");
			sql.append(" s.contactaddress as address,pti.name as producttype,cd.discountrate as rate,  ");
			sql.append(" m.id as id ");
			sql.append(" from merchant m,shop s,industrytype ind,cooperationdetail cdt,   ");
			sql.append(" contract c,contractdetail cd,ProductTypeItem pti  ");
			sql.append(" WHERE m.id = s.merchant_id and m.industrytype_id= ind.id  ");
			sql.append(" and m.id= cdt.merchant_id and cdt.id=c.cooperationdetail_id ");
			sql.append(" and c.id= cd.pointcontract_id and cd.producttypeitem_id= pti.id ");
			
			if ("1".equals(flag)) {
				//按商户修改时间查
				sql.append(" and m.lastupdatetime >= to_date('"+from+"','yyyy/mm/dd hh24:mi') ");
				sql.append(" and m.lastupdatetime<=to_date('"+to+"','yyyy/mm/dd hh24:mi') ");
			} else if("2".equals(flag)) {
				//按门市修改时间查
				sql.append(" and s.lastupdatetime >= to_date('"+from+"','yyyy/mm/dd hh24:mi') ");
				sql.append(" and s.lastupdatetime<=to_date('"+to+"','yyyy/mm/dd hh24:mi') ");
			} else if ("3".equals(flag)) {
				//按合同修改时间查
				sql.append(" and cd.lastupdatetime >= to_date('"+from+"','yyyy/mm/dd hh24:mi') ");
				sql.append(" and cd.lastupdatetime<=to_date('"+to+"','yyyy/mm/dd hh24:mi') ");
			}
			stmt = conn.prepareStatement(sql.toString());
			rs = stmt.executeQuery();
			w = new CSVWriter(new OutputStreamWriter(new FileOutputStream(fileName), "GB2312"),',','"');
			String[] head = new String[13];
			int i = 0;
			head[i++] = "商户名";
			head[i++] = "商户类型";
			head[i++] = "门市名称";
			head[i++] = "第一负责人";
			head[i++] = "职位";
			head[i++] = "联系电话";
			head[i++] = "维护联系人";
			head[i++] = "联系电话";
			head[i++] = "服务热线";
			head[i++] = "分布地址";
			head[i++] = "消费类型";
			head[i++] = "积分回馈率";
			head[i] = "唯一ID";
			w.writeNext(head);
			while (rs.next()) {
				String id = rs.getString("id");
				int k = 0;
				String[] arr = new String[13];
				arr[k++] = rs.getString("merchantname");
				arr[k++] = rs.getString("indtype");
				arr[k++] = rs.getString("shopname");
				if (map.containsKey(id)) {
					String[] da = map.get(id);
					arr[k++] = da[0];
					arr[k++] = da[1];
					arr[k++] = da[2];
				} else {
					arr[k++] = "";
					arr[k++] = "";
					arr[k++] = "";
				}
				arr[k++] = rs.getString("person");
				arr[k++] = rs.getString("mobile");
				arr[k++] = rs.getString("phone");
				String address = rs.getString("address");
				arr[k++] = address!=null&&!"null".equals(address) ? address : "";
				arr[k++] = rs.getString("producttype");
				arr[k++] = formatIt(rs.getString("rate"));
				arr[k] = id;
				w.writeNext(arr);
			}
		} catch (ClassNotFoundException e) {
			throw new ServletException(e);
		} catch (SQLException e) {
			throw new ServletException(e);
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(stmt);
			SqlUtil.close(conn);
			try {
				w.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}

	private String formatIt(String s) {
		String value = "";
		if (s!=null && s.length()>0) {
			String[] arr = s.split("[.]");
			if (arr.length>1) {
				String s1 = arr[0];
				String s2 = arr[1];
				if (s2.length()>2) {
					s2 = "."+ s2.substring(0, 2);
				} else {
					s2 = "."+s2;
				}
				value = s1+s2;
			} else {
				value = arr[0];
			}
			value += "%";
		}
		return value;
	}
	
	private String utf8ToGBK(String s) {
	     if (s==null){
		      return "";
		 } 
	     try {
		       s = new String(s.getBytes("utf-8"),"GBK");
		 } catch(Exception e) {
		       e.printStackTrace();
		 }
		 return s;
	}
	
}