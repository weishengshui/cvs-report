/**
 * 
 */
package com.chinarewards.report.chart.daily;

import java.awt.Color;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.time.Day;
import org.jfree.data.time.MovingAverage;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;

import com.chinarewards.report.chart.PlotBuilder;

/**
 * Plot for daily report's point given.
 * 
 * @author Cyril
 * @since 1.3.0 2010-01-17
 */
public class PointGivenPlotBuilder extends AbstractPlotBuilder implements PlotBuilder {

	private TimeSeries series = new TimeSeries("Point");

	public void addValue(Date date, double value) {
		series.add(new Day(date), value);
	}

	public XYPlot buildPlot() {

		TimeSeriesCollection dataset = new TimeSeriesCollection();

		dataset.addSeries(series);

		NumberAxis axis = new NumberAxis("Point");
		XYLineAndShapeRenderer renderer = new XYLineAndShapeRenderer(true, false);
		renderer.setSeriesPaint(0, Color.BLACK);

		// add the moving averages
		int mavDays[] = new int[] { 10, 20, 50, 100 };	// the list of days
		Color colors [] = new Color[] { Color.RED, Color.ORANGE, new Color(0x9295F0), new Color(0xE8976E) };
		for (int i = 0; i < mavDays.length; i++) {
			int mavDay = mavDays[i];
			TimeSeries mav = MovingAverage.createMovingAverage(series,
					"Point (" + mavDay + "-Day MA)", mavDay, mavDay);
			dataset.addSeries(mav);
			renderer.setSeriesPaint(i + 1, colors[i]);
		}

		// build the plot
		XYPlot plot = new XYPlot(dataset, null, axis, renderer);

		return plot;

	}

	public double getDoubleValue(ResultSet rs) throws SQLException {
		return rs.getDouble("point_sum");
	}

}
