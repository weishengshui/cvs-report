<%--

	SiteMesh decorator for general pages.

	@author cyril
	@since 1.3.0 2010-01-15

--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ include file="/include/global.inc.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><decorator:title /> - Report System - China Rewards</title>
<link rel="stylesheet" type="text/css" media="screen" href="<%=ctxRootPath%>/css/base.css" />
<link rel="stylesheet" type="text/css" media="screen" href="<%=ctxRootPath%>/css/main.css" />
<style>
	div#div1 {
	position: fixed;
	top: 0;
	left: 0;
	bottom: 0;
	right: 0;
	z-index: -1;
}
div#div1 > img{
	height: 100%;
	width: 100%;
	border: 0;
</style>
<decorator:head />
</head>

<body style="background-image: url('./images/report_background.jpg');
		background-position:center;
		background-repeat:no-repeat;">
<div id="div1">
<img src="./images/report_background.jpg"/>
</div>
<div id="wrapper">

<div id="topmenu">
<%
    SysUserObj user = (SysUserObj) session.getAttribute("User");
	if (user != null) {
		out.println("Hello " + user.getUsername() + " Welcome Report System");
	} else {
		out.println(" Welcome Report System");
	}
%></div>
<!-- Top Menu ends -->

<!-- Body starts -->
<div id="mainbody">

</div>
<!-- Body ends -->

<!-- Footer starts -->
<div id="footer">
Report System | China Rewards
</div>
<!-- Footer ends -->
<!---->
</div>


<decorator:body />
</body>
</html>