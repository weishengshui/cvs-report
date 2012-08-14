/**
 * 
 */
package com.chinarewards.report.data.crm;

/**
 * 
 * 
 * @author cyril
 * @since 1.2.2 2010-04-27
 */
public abstract class PosUtil {

	public static final String installStatusToText(String status) {
		
		if ("1".equals(status)) {
			return "已完成";
		} else if ("0".equals(status)) {
			return "未安装";
		} else {
			return "未知(代码:" + status + ")";
		}
		
	}
	
	public static final String activeFlagToText(String flag) {
		
		if ("invalid".equals(flag)) {
			return "失效";
		} else if ("effective".equals(flag)) {
			return "有效";
		} else {
			return "未知(代码:" + flag + ")";
		}
		
	}

	public static final String customCommTypeToText(String commType) {
		
		if ("1".equals(commType)) {
			return "拨号";
		} else if ("2".equals(commType)) {
			return "乙太网";
		} else if ("3".equals(commType)) {
			return "无线方式";
		} else {
			return "未知(代码:" + commType + ")";
		}
		
	}
}
