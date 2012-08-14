package com.chinarewards.report.data.pos;

public class PosReportVO {

	private String merchangName;

	private String merchantBusinessName;

	private String shopName;

	private POSVO pos;

	public String getMerchangName() {
		return merchangName;
	}

	public void setMerchangName(String merchangName) {
		this.merchangName = merchangName;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public POSVO getPos() {
		return pos;
	}

	public void setPos(POSVO pos) {
		this.pos = pos;
	}

	public String getMerchantBusinessName() {
		return merchantBusinessName;
	}

	public void setMerchantBusinessName(String merchantBusinessName) {
		this.merchantBusinessName = merchantBusinessName;
	}

}
