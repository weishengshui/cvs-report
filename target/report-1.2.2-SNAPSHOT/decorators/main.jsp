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
<decorator:head />
</head>

<body  style="background-image: url('./images/report_background.jpg');
		background-repeat:repeat-y; ;
		background-attachment: fixed;">
<div id="wrapper">

<!-- Top Menu starts -->
<div id="topmenu">
<a href="<%=ctxRootPath%>/index.jsp"><img src="<%=ctxRootPath%>/images/home_16x16.gif" border="0" />主页</a> | <a href="<%=ctxRootPath%>/logout.jsp">登出</a>&nbsp;<font color='red'>请点击菜单</font>
</div>
<!-- Top Menu ends -->

<!-- Body starts -->
<div id="mainbody">
<decorator:body />
</div>
<!-- Body ends -->

<!-- Footer starts -->
<div id="footer">
Report System | China Rewards
</div>
<!-- Footer ends -->

</div>



</body>
</html>