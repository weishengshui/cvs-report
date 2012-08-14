package com.chinarewards.report.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Page {
	private int pageNo = 1; // 当前页
	private int pageSize = 10; // 每页大小
	private int totalPages; // 总页
	private int totalRows; // 总行数
	private List list = new ArrayList(0);
	private int barNumbers = 5; // 几个为一条，默认为5
	private List listNumbers = new ArrayList(); // 数字翻页条

	public int getPageNo() {
		return pageNo > this.getTotalPages() ? this.getTotalPages()
				: (pageNo == 0 ? 1 : pageNo);
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalPages() {
		totalPages = this.getTotalRows() % this.getPageSize() == 0 ? this
				.getTotalRows() / this.getPageSize()
				: (this.getTotalRows() / this.getPageSize()) + 1;
		return totalPages;
	}

	public void setTotalPages(int totalPages) {
		this.totalPages = totalPages;
	}

	public int getTotalRows() {
		return totalRows;
	}

	public void setTotalRows(int totalRows) {
		this.totalRows = totalRows;
	}

	public List getList() {
		return list;
	}

	public void setList(List list) {
		this.list = list;
	}

	public int getBarNumbers() {
		return barNumbers;
	}

	public void setBarNumbers(int barNumbers) {
		this.barNumbers = barNumbers;
	}

	// 分页条 如：1 2 3 4 5 6
	public List getListNumbers() {
		List listn = new ArrayList();
		// 总显示条数
		int totbars = this.getTotalPages() % this.getBarNumbers() == 0 ? this
				.getTotalPages() / this.getBarNumbers() : this.getTotalPages()
				/ this.getBarNumbers() + 1;
		// 当前显示条数
		int currentBar = this.getPageNo() % this.getBarNumbers() == 0 ? this
				.getPageNo() / this.getBarNumbers() : this.getPageNo()
				/ this.getBarNumbers() + 1;
		if (this.getPageNo() == this.getBarNumbers() * currentBar
				&& currentBar != totbars) {
			currentBar++;
		}
		if (this.getPageNo() == (this.getBarNumbers() * currentBar
				- this.getBarNumbers() + 1)
				&& currentBar > 1) {
			currentBar--;
		}
		for (int i = this.getBarNumbers() * currentBar; i > (currentBar == 1 ? 0
				: this.getBarNumbers() * (currentBar - 1)); i--) {
			if (i <= this.getTotalPages()) {
				listn.add(i);
			}
		}
		Collections.sort(listn);
		return listn;
	}
}