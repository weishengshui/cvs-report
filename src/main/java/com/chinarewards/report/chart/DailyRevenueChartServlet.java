package com.chinarewards.report.chart;

import java.awt.Color;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.labels.StandardCategoryToolTipGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.CombinedDomainCategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.CategoryItemRenderer;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.data.category.DefaultCategoryDataset;

import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;
import com.chinarewards.report.util.DateUtil;

/**
 * Servlet implementation class DailyRevenueChartServlet
 * 
 * @author cyril
 * @since 1.3.0 2010-01-15
 */
public class DailyRevenueChartServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 805587260082859598L;

	/**
	 * Query object.
	 * 
	 * @author Cyril
	 */
	private class QueryCriteria {

		public Date transactionDateFrom;

		public Date transactionDateTo;

	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DailyRevenueChartServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		long imgWidth = this.getImageWidth(request);
		long imgHeight = this.getImageHeight(request);
		QueryCriteria criteria = this.getQueryCriteria(request);
		OutputStream out = response.getOutputStream();
		JFreeChart chart = null;
		Connection conn = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DbConnectionFactory.getInstance().getConnection("posapp");

			// get the chart
			chart = this.createChart2(conn, criteria);
			SqlUtil.close(conn);

			// output the chart to HTTP response
			response.setContentType("image/jpg");
			ChartUtilities.writeChartAsJPEG(out, chart, (int) imgWidth,
					(int) imgHeight);

		} catch (ClassNotFoundException e) {
			throw new ServletException(e);
		} catch (SQLException e) {
			throw new ServletException(e);
		} finally {
			SqlUtil.close(conn);
			if (out != null) {
				try {
					out.close();
				} catch (Throwable t) {
				}
			}
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	/**
	 * Create a complete, full featured daily chart.
	 * 
	 * @param conn
	 * @param criteria
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 * @deprecated use {@link #createChart2(Connection, QueryCriteria)}
	 */
	private JFreeChart createChart(Connection conn, QueryCriteria criteria)
			throws ServletException, IOException {

		// connection
		ResultSet rs = null;

		// formatting
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

		try {
			// query database
			rs = this.getDailyResultSet(conn, criteria);

			//
			// Stores the list of plots and dataset series.
			//
			// amount spending
			DefaultCategoryDataset amtSpendDataSet = new DefaultCategoryDataset();
			// transaction count
			DefaultCategoryDataset txCountDataSet = new DefaultCategoryDataset();
			// point given
			DefaultCategoryDataset pointDataSet = new DefaultCategoryDataset();

			// iterate result and build datasets for JFreeChart
			while (rs.next()) {

				// the chart's axis (horizontal label)
				String sAxis = dateFormat.format(rs.getDate("transdate_str"));

				// create a number of plots for the chart.

				// Dataset: Spending amount.
				amtSpendDataSet.addValue(rs.getDouble("amountcurrency_sum"),
						"Amount", sAxis);

				// Dataset: Transaction count
				txCountDataSet
						.addValue(rs.getDouble("tx_count"), "TX Count", sAxis);

				// Dataset: Point given
				pointDataSet
						.addValue(rs.getDouble("point_sum"), "Point", sAxis);

			}

			// build the plots
			
			// amount spending plot
			ValueAxis amtSpendAxis = new NumberAxis("RMB");
			amtSpendAxis.setStandardTickUnits(NumberAxis
					.createIntegerTickUnits());
			CategoryItemRenderer amtSpendingRenderer = new LineAndShapeRenderer(true, false);
			amtSpendingRenderer.setSeriesPaint(0, Color.RED);
			amtSpendingRenderer.setBaseToolTipGenerator(new StandardCategoryToolTipGenerator());
			CategoryPlot amtSpendingSubplot = new CategoryPlot(amtSpendDataSet,
					null, amtSpendAxis, amtSpendingRenderer);
			amtSpendingSubplot.setDomainGridlinesVisible(true);
			amtSpendingSubplot.setRenderer(0, amtSpendingRenderer);

			// tx count plot
			ValueAxis txCountAxis = new NumberAxis("Count");
			txCountAxis.setStandardTickUnits(NumberAxis
					.createIntegerTickUnits());
			CategoryItemRenderer txCountRenderer = new LineAndShapeRenderer(true, false);
			txCountRenderer.setSeriesPaint(0, Color.RED);
			txCountRenderer.setBaseToolTipGenerator(new StandardCategoryToolTipGenerator());
			CategoryPlot txCountSubplot = new CategoryPlot(txCountDataSet,
					null, txCountAxis, txCountRenderer);
			txCountSubplot.setDomainGridlinesVisible(true);
			txCountSubplot.setRenderer(0, txCountRenderer);

			// point plot
			ValueAxis pointAxis = new NumberAxis("Point");
			pointAxis.setStandardTickUnits(NumberAxis
					.createIntegerTickUnits());
			CategoryItemRenderer pointRenderer = new LineAndShapeRenderer(true, false);
			pointRenderer.setSeriesPaint(0, Color.RED);
			pointRenderer.setBaseToolTipGenerator(new StandardCategoryToolTipGenerator());
			CategoryPlot pointSubplot = new CategoryPlot(pointDataSet,
					null, pointAxis, pointRenderer);
			pointSubplot.setDomainGridlinesVisible(true);
			pointSubplot.setRenderer(0, pointRenderer);

			
			// domain axis
			CategoryAxis domainAxis = new CategoryAxis("Date");
			domainAxis.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(0.6));
			CombinedDomainCategoryPlot plot = new CombinedDomainCategoryPlot(
					domainAxis);


			// add subplots to the plot.
			plot.add(amtSpendingSubplot, 10);
			plot.add(txCountSubplot, 8);
			plot.add(pointSubplot, 10);

			
			// create chart
			JFreeChart chart = new JFreeChart("Daily Transaction Report", 
					null, plot, true);

			return chart;

		} catch (SQLException e) {
			throw new ServletException(e);
		} finally {
			// release resources
			SqlUtil.close(rs);
		}

	}
	
	/**
	 * Create a complete, full featured daily chart.
	 * 
	 * @param conn
	 * @param criteria
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */
	private JFreeChart createChart2(Connection conn, QueryCriteria criteria)
			throws ServletException, IOException {

		// connection
		ResultSet rs = null;

		// formatting
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

		try {
			// query database
			rs = this.getDailyResultSet(conn, criteria);
			
			DailyRevenueChartBuilder builder = new DailyRevenueChartBuilder();
			JFreeChart chart = builder.buildChart(rs);

			return chart;

		} catch (SQLException e) {
			throw new ServletException(e);
		} finally {
			// release resources
			SqlUtil.close(rs);
		}

	}
	

	/**
	 * Query the database using a daily basis result using the given criteria
	 * and return the result set.
	 * 
	 * @param conn
	 * @param criteria
	 * @return
	 * @throws SQLException
	 */
	private ResultSet getDailyResultSet(Connection conn, QueryCriteria criteria)
			throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// build SQL
		String sql = "SELECT TO_DATE(TO_CHAR(transdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS transdate_str, count(*) AS tx_count, SUM(amountcurrency) AS amountcurrency_sum, sum(point) AS point_sum FROM clubpoint WHERE clubid = '00' AND amountcurrency > 2  AND clubpoint.merchantname NOT LIKE '%积享通%' AND clubpoint.producttypename <> 'T测试'";
		if (criteria.transactionDateFrom != null) {
			sql += " AND transdate >= ?";
		}
		if (criteria.transactionDateTo != null) {
			sql += " AND transdate < ?";
		}
		sql += " GROUP BY TO_CHAR(transdate, 'yyyy-mm-dd') ORDER BY TO_CHAR(transdate, 'yyyy-mm-dd')";

		// add one date to end date to do a less than comparison.
		java.util.Date queryDateTo = null;
		if (criteria.transactionDateTo != null) {
			queryDateTo = DateUtil.add(criteria.transactionDateTo,
					Calendar.DATE, 1);
		}

		// prepare statement and set parameters
		pstmt = conn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
				ResultSet.CONCUR_READ_ONLY);
		int paramIdx = 1;
		if (criteria.transactionDateFrom != null) {
			pstmt.setDate(paramIdx++, new java.sql.Date(
					criteria.transactionDateFrom.getTime()));
		}
		if (criteria.transactionDateTo != null) {
			pstmt.setDate(paramIdx++, new java.sql.Date(
					criteria.transactionDateTo.getTime()));
		}

		// execute query
		rs = pstmt.executeQuery();

		return rs;
	}

	private Date getDateFrom(HttpServletRequest request) {
		String s = request.getParameter("df");
		if (s == null)
			return null;
		return parseDate(s);
	}

	private Date getDateTo(HttpServletRequest request) {
		String s = request.getParameter("dt");
		if (s == null)
			return null;
		return parseDate(s);
	}

	private long getImageWidth(ServletRequest request) {
		String s = request.getParameter("w");
		return parseLong(s, 800, 3000);
	}

	private long getImageHeight(ServletRequest request) {
		String s = request.getParameter("h");
		return parseLong(s, 500, 800);
	}

	/**
	 * Parse the string to a date. The default format is yyyy-MM-dd.
	 * 
	 * @param s
	 * @return
	 */
	private Date parseDate(String s) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sdf.setLenient(false);
		try {
			return sdf.parse(s);
		} catch (ParseException e) {
			// failed
		}
		return null;
	}

	/**
	 * Parse the given string to a long value with default value and maximum
	 * value constraint.
	 * 
	 * @param s
	 * @param defaultValue
	 * @param max
	 * @return
	 */
	private long parseLong(String s, long defaultValue, long max) {
		long n = defaultValue;
		try {
			n = Long.parseLong(s);
		} catch (NumberFormatException e) {
			n = defaultValue;
		}
		// sanitize value. apply min and max value.
		if (n < 0) {
			n = defaultValue;
		} else if (n > max) {
			n = max;
		}
		return n;
	}

	private void defaultHandleRequest(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		OutputStream out = response.getOutputStream();

		//
		// Get request parameter
		//
		java.util.Date dateFrom = null;
		java.util.Date dateTo = null;
		long imgWidth = 800;
		long imgHeight = 300;

		// get request parameters
		{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			sdf.setLenient(false);
			String sDateFrom = request.getParameter("df");
			String sDateTo = request.getParameter("dt");
			if (sDateFrom != null) {
				try {
					dateFrom = sdf.parse(sDateFrom);
				} catch (ParseException e) {
				}
			}
			if (sDateTo != null) {
				try {
					dateTo = sdf.parse(sDateTo);
				} catch (ParseException e) {
				}
			}

			// image height and width
			imgWidth = getImageWidth(request);
			imgHeight = getImageHeight(request);

		}

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {

			// common SQL
			String txSql = "SELECT TO_CHAR(transdate, 'yyyy-mm-dd') AS transdate_str, count(*) AS tx_count, SUM(amountcurrency) AS amountcurrency_sum, sum(point) AS point_sum FROM clubpoint WHERE clubid = '00' AND amountcurrency > 2";
			if (dateFrom != null) {
				txSql += " AND transdate >= ?";
			}
			if (dateTo != null) {
				txSql += " AND transdate < ?";
			}
			txSql += " GROUP BY TO_CHAR(transdate, 'yyyy-mm-dd') ORDER BY TO_CHAR(transdate, 'yyyy-mm-dd')";

			java.util.Date queryDateTo = null;
			if (dateTo != null) {
				queryDateTo = DateUtil.add(dateTo, Calendar.DATE, 1);
			}

			// execute SQL
			// TODO extract this to common code.
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DbConnectionFactory.getInstance().getConnection("posapp");
			pstmt = conn.prepareStatement(txSql, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_READ_ONLY);
			int paramIdx = 1;
			if (dateFrom != null) {
				pstmt.setTimestamp(paramIdx++,
						new Timestamp(dateFrom.getTime()));
			}
			if (queryDateTo != null) {
				pstmt.setTimestamp(paramIdx++, new Timestamp(queryDateTo
						.getTime()));
			}
			// execute query
			rs = pstmt.executeQuery();

			DefaultCategoryDataset dataset = new DefaultCategoryDataset();
			while (rs.next()) {
				// tx
				dataset.addValue(rs.getDouble("tx_count"), "TX", rs
						.getString("transdate_str"));
				// amount currency
				dataset.addValue(rs.getDouble("amountcurrency_sum"), "Amount",
						rs.getString("transdate_str"));
				// point
				dataset.addValue(rs.getDouble("point_sum"), "Point", rs
						.getString("transdate_str"));
			}
			SqlUtil.close(rs);
			SqlUtil.close(conn);

			// build the chart
			JFreeChart chart = ChartFactory.createLineChart(
					"Daily Transaction Report", "Amount", "Category", dataset,
					PlotOrientation.VERTICAL, true, true, false);
			CategoryPlot plot = (CategoryPlot) chart.getPlot();
			CategoryAxis xAxis = (CategoryAxis) plot.getDomainAxis();
			xAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_90);

			// output the chart to HTTP response
			response.setContentType("image/jpg");
			ChartUtilities.writeChartAsJPEG(out, chart, (int) imgWidth,
					(int) imgHeight);

		} catch (Exception e) {
			System.out.println(e.toString());
		} finally {
			out.close();
			SqlUtil.close(rs);
			SqlUtil.close(pstmt);
			SqlUtil.close(conn);
		}

	}

	private QueryCriteria getQueryCriteria(HttpServletRequest request) {
		QueryCriteria c = new QueryCriteria();
		c.transactionDateFrom = this.getDateFrom(request);
		c.transactionDateTo = this.getDateTo(request);
		return c;
	}

}
