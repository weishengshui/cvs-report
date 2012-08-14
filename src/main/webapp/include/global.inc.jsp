<%--

	Global page which should be included by every JSP pages.

 --%>
<%--
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
--%>
<%@ page import="com.chinarewards.report.user.*"%>
<%@ include file="/include/ctxroot.inc.jsp" %>

<%
// load the Oracle 10g JDBC driver.
Class.forName("oracle.jdbc.driver.OracleDriver");
%>