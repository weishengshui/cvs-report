package com.chinarewards.report.data.activity;

import java.util.List;
import java.util.Map;

import com.chinarewards.report.data.crm.ConsumeData;

public class ZhongXinQinZiYouDIYReportVo {

	private List<ConsumeData> data;

	private Map<String, Integer> datasum;

	public List<ConsumeData> getData() {
		return data;
	}

	public void setData(List<ConsumeData> data) {
		this.data = data;
	}

	public Map<String, Integer> getDatasum() {
		return datasum;
	}

	public void setDatasum(Map<String, Integer> datasum) {
		this.datasum = datasum;
	}

}
