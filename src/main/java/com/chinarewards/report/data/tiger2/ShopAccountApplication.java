package com.chinarewards.report.data.tiger2;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class ShopAccountApplication {

	static Map<String, String> statusMap = new HashMap<String, String>();

	//NEW("新增"),PROCESSING("处理中"),DENIED("已否决"),APPROVED("已审核"),COMPLETED("已批准")
	// ;
	static {
		statusMap.put("NEW", "新增");
		statusMap.put("PROCESSING", "处理中");
		statusMap.put("DENIED", "已否决");
		statusMap.put("APPROVED", "已审核");
		statusMap.put("COMPLETED", "已批准");
	}

	private String id;

	private String shopName;

	private String businessLicenseCode;

	private String contactPersonName;

	private String contactPersonTitle;

	private String contactEmail;

	private String contactPhone;

	private String loginUserName;

	private String sourceIp;

	private String shopDescription;

	private String shopFeature;

	// private ShopAccountApplicationStatus status;

	// private ShopAccountApplicationSource source;

	private String createAt; // 申请日期

	// private SysUser createdBy; // 申请人

	// private Date lastModifiedAt; // 最后修改日期

	// private SysUser lastModifiedBy; // 最后修改人

	private Date closedAt; // 否决日期

	// private SysUser closedBy; // 否决人

	// private Date processSince; // 处理时间段，处理中--》批准或处理中--》否决。

	// private SysUser processBy; // 处理人

	private Date processAt; // 处理时间

	// private SysUser approvedBy; // 审核人

	private Date approvedAt;// 审核日期

	// private SysUser completeBy; // 批准人

	private Date completeAt; // 批准时间

	private String denyReason; // 否决原因

	private String status; // 状态

	public Date getProcessAt() {
		return processAt;
	}

	public void setProcessAt(Date processAt) {
		this.processAt = processAt;
	}

	public Date getApprovedAt() {
		return approvedAt;
	}

	public void setApprovedAt(Date approvedAt) {
		this.approvedAt = approvedAt;
	}

	public Date getCompleteAt() {
		return completeAt;
	}

	public void setCompleteAt(Date completeAt) {
		this.completeAt = completeAt;
	}

	private String remark;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the shopName
	 */
	public String getShopName() {
		return shopName;
	}

	/**
	 * @param shopName
	 *            the shopName to set
	 */
	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	/**
	 * @return the businessLicenseCode
	 */
	public String getBusinessLicenseCode() {
		return businessLicenseCode;
	}

	/**
	 * @param businessLicenseCode
	 *            the businessLicenseCode to set
	 */
	public void setBusinessLicenseCode(String businessLicenseCode) {
		this.businessLicenseCode = businessLicenseCode;
	}

	/**
	 * @return the contactPersonName
	 */
	public String getContactPersonName() {
		return contactPersonName;
	}

	/**
	 * @param contactPersonName
	 *            the contactPersonName to set
	 */
	public void setContactPersonName(String contactPersonName) {
		this.contactPersonName = contactPersonName;
	}

	/**
	 * @return the contactPersonTitle
	 */
	public String getContactPersonTitle() {
		return contactPersonTitle;
	}

	/**
	 * @param contactPersonTitle
	 *            the contactPersonTitle to set
	 */
	public void setContactPersonTitle(String contactPersonTitle) {
		this.contactPersonTitle = contactPersonTitle;
	}

	/**
	 * @return the contactEmail
	 */
	public String getContactEmail() {
		return contactEmail;
	}

	/**
	 * @param contactEmail
	 *            the contactEmail to set
	 */
	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}

	/**
	 * @return the contafctPhone
	 */
	public String getContactPhone() {
		return contactPhone;
	}

	/**
	 * @param contafctPhone
	 *            the contafctPhone to set
	 */
	public void setContactPhone(String contafctPhone) {
		this.contactPhone = contafctPhone;
	}

	/**
	 * @return the loginUserName
	 */
	public String getLoginUserName() {
		return loginUserName;
	}

	/**
	 * @param loginUserName
	 *            the loginUserName to set
	 */
	public void setLoginUserName(String loginUserName) {
		this.loginUserName = loginUserName;
	}

	/**
	 * @return the shopDescription
	 */
	public String getShopDescription() {
		return shopDescription;
	}

	/**
	 * @param shopDescription
	 *            the shopDescription to set
	 */
	public void setShopDescription(String shopDescription) {
		this.shopDescription = shopDescription;
	}

	/**
	 * @return the shopFeature
	 */
	public String getShopFeature() {
		return shopFeature;
	}

	/**
	 * @param shopFeature
	 *            the shopFeature to set
	 */
	public void setShopFeature(String shopFeature) {
		this.shopFeature = shopFeature;
	}

	public String getCreateAt() {
		return createAt;
	}

	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}

	/**
	 * @return the closedAt
	 */
	public Date getClosedAt() {
		return closedAt;
	}

	/**
	 * @param closedAt
	 *            the closedAt to set
	 */
	public void setClosedAt(Date closedAt) {
		this.closedAt = closedAt;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	/**
	 * @return the sourceIp
	 */
	public String getSourceIp() {
		return sourceIp;
	}

	/**
	 * @param sourceIp
	 *            the sourceIp to set
	 */
	public void setSourceIp(String sourceIp) {
		this.sourceIp = sourceIp;
	}

	public String getDenyReason() {
		return denyReason;
	}

	public void setDenyReason(String denyReason) {
		this.denyReason = denyReason;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = statusMap.get(status.trim());
	}

}
