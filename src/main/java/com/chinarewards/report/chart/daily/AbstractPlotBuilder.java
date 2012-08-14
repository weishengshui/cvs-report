/**
 * 
 */
package com.chinarewards.report.chart.daily;

/**
 * 
 * 
 * 
 * @author Cyril
 * @since 1.3.0
 */
public class AbstractPlotBuilder {

	private int plotWeight = 1;

	/**
	 * Returns the weight of the height of the plot.
	 * 
	 * @return the plotWeight
	 */
	public int getPlotWeight() {
		return plotWeight;
	}

	/**
	 * Sets the weight of the height of the plot.
	 * 
	 * @param plotWeight
	 *            the plotWeight to set
	 */
	public void setPlotWeight(int plotWeight) {
		this.plotWeight = plotWeight;
	}

}
