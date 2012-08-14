/**
 * 
 */
package com.chinarewards.report.chart;

import java.awt.Color;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.plot.CombinedDomainXYPlot;
import org.jfree.chart.plot.XYPlot;

import com.chinarewards.report.chart.daily.AmountCurrencyPlotBuilder;
import com.chinarewards.report.chart.daily.PointGivenPlotBuilder;
import com.chinarewards.report.chart.daily.TxCountPlotBuilder;

/**
 * 
 * 
 * @author Cyril
 * @since 1.3.0 2010-01-17
 */
public class DailyRevenueChartBuilder {

	private Date transactionDateFrom;

	private Date transactionDateTo;

	/**
	 * @return the transactionDateFrom
	 */
	public Date getTransactionDateFrom() {
		return transactionDateFrom;
	}

	/**
	 * @param transactionDateFrom
	 *            the transactionDateFrom to set
	 */
	public void setTransactionDateFrom(Date transactionDateFrom) {
		this.transactionDateFrom = transactionDateFrom;
	}

	/**
	 * @return the transactionDateTo
	 */
	public Date getTransactionDateTo() {
		return transactionDateTo;
	}

	/**
	 * @param transactionDateTo
	 *            the transactionDateTo to set
	 */
	public void setTransactionDateTo(Date transactionDateTo) {
		this.transactionDateTo = transactionDateTo;
	}

	public JFreeChart buildChart(ResultSet rs) throws SQLException {

		List<PlotBuilder> plotBuilders = new ArrayList<PlotBuilder>();

		{
			AmountCurrencyPlotBuilder amtCurrencyBuilder = new AmountCurrencyPlotBuilder();
			amtCurrencyBuilder.setPlotWeight(3);
			plotBuilders.add(amtCurrencyBuilder);

			TxCountPlotBuilder txCountBuilder = new TxCountPlotBuilder();
			txCountBuilder.setPlotWeight(2);
			plotBuilders.add(txCountBuilder);

			PointGivenPlotBuilder ptGivenBuilder = new PointGivenPlotBuilder();
			ptGivenBuilder.setPlotWeight(3);
			plotBuilders.add(ptGivenBuilder);
		}

		// add the records to all builders

		while (rs.next()) {

			for (PlotBuilder plotBuilder : plotBuilders) {

				double value = plotBuilder.getDoubleValue(rs);
				Date date = rs.getTimestamp("transdate_str");

				plotBuilder.addValue(date, value);

			}

		}	// has more records

		// create domain axis
		DateAxis domainAxis = new DateAxis("Date");
		domainAxis.setDateFormatOverride(new SimpleDateFormat("yyyy-MM-dd"));

		// create the main plot and add all subplots into it.
		CombinedDomainXYPlot plot = new CombinedDomainXYPlot(domainAxis);
		for (PlotBuilder plotBuilder : plotBuilders) {
			XYPlot subplot = plotBuilder.buildPlot();
			subplot.setNoDataMessage("No Data Available");
			subplot.setNoDataMessagePaint(Color.RED);
			
			plot.add(subplot, plotBuilder.getPlotWeight());
		}

		// create the chart object.
		JFreeChart chart = new JFreeChart("Daily Transaction Report",
				JFreeChart.DEFAULT_TITLE_FONT, plot, true);
		chart.setAntiAlias(true);
		chart.setTextAntiAlias(true);
		
		return chart;

	}

}
