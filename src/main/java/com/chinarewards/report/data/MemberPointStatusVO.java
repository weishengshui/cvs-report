package com.chinarewards.report.data;

public class MemberPointStatusVO {

	private String memberName;

	private String memberCardno;

	private String mobile;

	private float totalPoint;

	private float validPoint;

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getMemberCardno() {
		return memberCardno;
	}

	public void setMemberCardno(String memberCardno) {
		this.memberCardno = memberCardno;
	}

	public float getTotalPoint() {
		return totalPoint;
	}

	public void setTotalPoint(float totalPoint) {
		this.totalPoint = totalPoint;
	}

	public float getValidPoint() {
		return validPoint;
	}

	public void setValidPoint(float validPoint) {
		this.validPoint = validPoint;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

}
