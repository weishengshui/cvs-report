/**
 * 
 */
package com.chinarewards.report.data.szair;

import com.chinarewards.report.jsp.util.JspDisplayUtil;

/**
 * 
 * 
 * @author cyril
 * @since 1.2.2 2010-04-12
 */
public abstract class SzairUtil {

	/**
	 * Converts the enum string of MemberSignup.status to text representation.
	 * 
	 * @param status
	 * @return
	 */
	public static String memberSignupStatusToText(String status) {
		String r = null;
		if ("NEW".equals(status)) {
			r = "新申请";
		} else if ("IN_PROCESS".equals(status)) {
			r = "处理中";
		} else if ("SUCCESS".equals(status)) {
			r = "成功";
		} else if ("FAILED".equals(status)) {
			r = "失败(积享通方)";
		} else if ("FAILED_SH".equals(status)) {
			r = "失败(深航方)";
		} else {
			r = "不知名值(" + JspDisplayUtil.noNull(status) + ")";
		}
		return r;
	}

	/**
	 * Converts the enum string representation of gender field in the
	 * MemberSignup table to text representation.
	 * 
	 * @param gender
	 * @return
	 */
	public static String memberSignupGenderToText(String gender) {
		String r = null;
		if ("MALE".equals(gender)) {
			r = "男";
		} else if ("FEMALE".equals(gender)) {
			r = "女";
		} else {
			r = "不知名性別(" + JspDisplayUtil.noNull(gender) + ")";
		}
		return r;
	}

	/**
	 * Converts the enum string of MemberSignup.status to text representation.
	 * 
	 * @param status
	 * @return
	 */
	public static String dataSourceToText(String status) {
		String r = null;
		if ("PORTAL".equals(status)) {
			r = "Portal";
		} else if ("BACKEND".equals(status)) {
			r = "积享通客服";
		} else if ("SH_BACKEND_IMPORT".equals(status)) {
			r = "深航客服";
		} else if ("BATCH_IMPORT".equals(status)) {
			r = "批量导入";
		} else {
			r = "不知名值(" + JspDisplayUtil.noNull(status) + ")";
		}
		return r;
	}

}
