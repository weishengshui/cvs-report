package com.chinarewards.report.qqvipadidas;

public class PosCount {

	private int count;
	private String posId;
	private String aType;

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getPosId() {
		return posId;
	}

	public void setPosId(String posId) {
		this.posId = posId;
	}

	public String getAType() {
		String type = "";
		if(aType.equals("GIFT"))
			type = "领取礼品";
		else if(aType.equals("PRIVILEGE"))
			type = "获取优惠";
		else if(aType.equals("WEIXIN"))
			type = "微信签到";
		return type;
	}

	public void setAType(String type) {
		aType = type;
	}

}
