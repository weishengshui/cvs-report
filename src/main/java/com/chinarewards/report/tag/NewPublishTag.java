/**
 * 
 */
package com.chinarewards.report.tag;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * 
 * @author Cyril
 * @since 1.2.2 2010-05-13
 */
public class NewPublishTag extends TagSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 282681583657620415L;

	private Logger logger = LoggerFactory.getLogger(getClass());

	private String date;
	
	private String dateFormat = "yyyyMMdd";
	
	private int threshold = 14;

	/**
	 * Returns the date set to this tag.
	 * 
	 * @return the date
	 */
	public String getDate() {
		return date;
	}

	/**
	 * Sets the date set to this tag.
	 * 
	 * @param date
	 *            the date to set
	 */
	public void setDate(String date) {
		this.date = date;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	@Override
	public int doEndTag() throws JspException {
		
		JspWriter out = pageContext.getOut();
		boolean expired = false;
		Date d = null;
		
		if (date != null) {
			SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
			try {
				d = sdf.parse(date);
				Date now = new Date();
				
				// calculate the threshold
				Calendar cal = Calendar.getInstance();
				cal.setTime(d);
				cal.add(Calendar.DATE, threshold);
				if (!cal.getTime().after(now)) {
					expired = true;
				}
				
			} catch (ParseException e) {
				throw new JspException("Invalid date format '" + date + "'", e);
			}
		}
		
		if (!expired) {
			HttpServletRequest req = (HttpServletRequest)pageContext.getRequest();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			StringBuffer content = new StringBuffer();
			String ds = null;
			// XXX hard-coded UTF-8?
			try {
				ds = URLEncoder.encode(sdf.format(d), "UTF-8");
			} catch (UnsupportedEncodingException e) {
				throw new JspException("Error formatting date " + d, e);
			}
			
			content.append("<img src=\"" + getContextPath() + "/images/updated.gif\"");
			content.append(" title=\"Last update: ");
			content.append(ds);
			content.append("\"/>");
			
			try {
				out.print(content);
			} catch (IOException e) {
				throw new JspException(e);
			}
		}
		
		
		return super.doEndTag();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.jsp.tagext.TagSupport#setValue(java.lang.String,
	 * java.lang.Object)
	 */
	@Override
	public void setValue(String k, Object o) {
		super.setValue(k, o);
		logger.trace("k={}, o={}", new String[] { k,
				(o == null) ? "null" : o.toString() });
	}
	
	private String getContextPath() {
		HttpServletRequest req = (HttpServletRequest)pageContext.getRequest();
		String path = req.getContextPath();
		return path;
	}

}
