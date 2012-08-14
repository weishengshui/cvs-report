package com.chinarewards.report.user;

import java.util.ArrayList;
import java.util.List;

public class UserLimits {

	private List<String> menuPageList = new ArrayList<String>();

	public void setAccessPage(String pageName) {
		if (!menuPageList.contains(pageName)) {
			menuPageList.add(pageName);
		}
	}

	public List<String> getPageList() {
		return menuPageList;
	}

}
