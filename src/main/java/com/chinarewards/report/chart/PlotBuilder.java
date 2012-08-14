/**
 * 
 */
package com.chinarewards.report.chart;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import org.jfree.chart.plot.XYPlot;

/**
 * 
 * 
 * @author Cyril
 * @since 1.3.0 2010-01-17
 */
public interface PlotBuilder {

	/**
	 * Add a statistics to this builder.
	 * 
	 * @param date
	 * @param value
	 */
	public void addValue(Date date, double value);

	/**
	 * Build the plot.
	 * 
	 * @return
	 */
	public XYPlot buildPlot();

	/**
	 * Sets the weight of the plot's height.
	 * 
	 * @param weight
	 */
	public void setPlotWeight(int weight);

	/**
	 * Returns the weight of the plot's height.
	 * 
	 * @return
	 */
	public int getPlotWeight();

	/**
	 * 
	 * 
	 * @param rs
	 * @return
	 * @throws SQLException
	 */
	public double getDoubleValue(ResultSet rs) throws SQLException;

}
