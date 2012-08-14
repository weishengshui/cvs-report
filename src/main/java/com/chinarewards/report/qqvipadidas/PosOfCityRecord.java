package com.chinarewards.report.qqvipadidas;

import java.util.LinkedList;
import java.util.List;

public class PosOfCityRecord implements Comparable<PosOfCityRecord> {

	private int cityId;
	private String cityName;
	private List<PosCount> posCountList = new LinkedList<PosCount>();
	private int giftCount;
	private int privilegeCount;
	private int weixinCount;

	public String getCityName() {
		return cityName;
	}

	public void setCityName(String cityName) {
		this.cityName = cityName;
	}

	public List<PosCount> getPosCountList() {
		return posCountList;
	}

	public void setPosCountList(List<PosCount> posCountList) {
		this.posCountList = posCountList;
	}

	public int getGiftCount() {
		return giftCount;
	}

	public void setGiftCount(int giftCount) {
		this.giftCount = giftCount;
	}

	public int getPrivilegeCount() {
		return privilegeCount;
	}

	public void setPrivilegeCount(int privilegeCount) {
		this.privilegeCount = privilegeCount;
	}

	public int getWeixinCount() {
		return weixinCount;
	}

	public void setWeixinCount(int weixinCount) {
		this.weixinCount = weixinCount;
	}

	public int getCityId() {
		return cityId;
	}

	public void setCityId(int cityId) {
		this.cityId = cityId;
	}

	public int compareTo(PosOfCityRecord o) {
		return this.getCityId() - o.getCityId();
	}

}
