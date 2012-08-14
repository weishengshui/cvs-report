package com.chinarewards.report.data.pos;

import java.util.Date;

public class POSVO {

	String id;
	String posno;
	String simcard;
	String installstatus;
	Date finishdate;
	String custocommtype;
	Date lastupdatetime;
	String activeflag;
	String shipid;
	String postype;
	String executeVersion;
	String setupVersion;
	long lastUnuseDays;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPosno() {
		return posno;
	}

	public void setPosno(String posno) {
		this.posno = posno;
	}

	public String getSimcard() {
		return simcard;
	}

	public void setSimcard(String simcard) {
		this.simcard = simcard;
	}

	public String getInstallstatus() {
		return installstatus;
	}

	public void setInstallstatus(String installstatus) {
		this.installstatus = installstatus;
	}

	public Date getFinishdate() {
		return finishdate;
	}

	public void setFinishdate(Date finishdate) {
		this.finishdate = finishdate;
	}

	public String getCustocommtype() {
		return custocommtype;
	}

	public void setCustocommtype(String custocommtype) {
		this.custocommtype = custocommtype;
	}

	public Date getLastupdatetime() {
		return lastupdatetime;
	}

	public void setLastupdatetime(Date lastupdatetime) {
		this.lastupdatetime = lastupdatetime;
	}

	public String getActiveflag() {
		return activeflag;
	}

	public void setActiveflag(String activeflag) {
		this.activeflag = activeflag;
	}

	public String getShipid() {
		return shipid;
	}

	public void setShipid(String shipid) {
		this.shipid = shipid;
	}

	public String getPostype() {
		return postype;
	}

	public void setPostype(String postype) {
		this.postype = postype;
	}

	public long getLastUnuseDays() {
		return lastUnuseDays;
	}

	public void setLastUnuseDays(long lastUnuseDays) {
		this.lastUnuseDays = lastUnuseDays;
	}

	public String getExecuteVersion() {
		return executeVersion;
	}

	public void setExecuteVersion(String executeVersion) {
		this.executeVersion = executeVersion;
	}

	public String getSetupVersion() {
		return setupVersion;
	}

	public void setSetupVersion(String setupVersion) {
		this.setupVersion = setupVersion;
	}

}
