package com.chinarewards.report.qqvipadidas;

public class FunctionCountVo {
	
	//QQVIP传入积享通的memberKey的数量
	int memberKeyCount;
	
	//已经领取的礼品数量
	int giftCount;
	
	//已经获取优惠的数量
	int privilegeCount;
	
	//微信签到的数量
	int weixinCount;

	public int getMemberKeyCount() {
		return memberKeyCount;
	}

	public void setMemberKeyCount(int memberKeyCount) {
		this.memberKeyCount = memberKeyCount;
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

}
