<%--

	The main menu. Entry point of the whole application.
	
	@author yudy
	@author cyril

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ taglib uri="/report-tags" prefix="rp"%>
<html>
<head>
<title>主菜单</title>
<%@ include file="/include/stdhtmlhead.inc.jsp"%>
</head>

<body>

<script>
	if (parent.document.getElementById('mainframe').cols != "20%,80%") {
		parent.document.getElementById('mainframe').cols = "20%,80%";
	}
</script>

<div align="center">
<div class="box_001 edge_001">
<table width="400" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="286" align="left" valign="top" class="brd_001 edge_002">
		<div id="nav">
		<ul>

			<a href="<%=ctxRootPath%>/datereport.jsp" target=right>Daily
			Report</a>
			<rp:np date="20100407" />
			<br />
			<a href="<%=ctxRootPath%>/memberReport.jsp" target=right>Member
			Report</a>
			<rp:np date="20100501" />


			<li class="edge_003" onMouseOver="showMenu('Layer1');"
				onMouseOut="hideMenu('Layer1');">
			<h2>会员与商户信息资料</h2>

			<div id="Layer1" class="list" style="display: none"><a
				href="<%=ctxRootPath%>/searchMemberByParam.jsp" target="right">会员信息资料报表</a><rp:np
				date="20100524" /><br />
			<a href="<%=ctxRootPath%>/searchShopByParam.jsp" target="right">商户信息资料报表</a><rp:np
				date="20100524" /><br />
			<a href="<%=ctxRootPath%>/onceConsumeShopReport.jsp" target="right">2个月内交易只有1-10笔的商户的最后一次会员的消费记录报表</a><rp:np
				date="20100709" /></div>
			</li>


			<li class="edge_003" onMouseOver="showMenu('Layer2');"
				onMouseOut="hideMenu('Layer2');">
			<h2>会员积分消费信息</h2>

			<div id="Layer2" class="list" style="display: none"><a
				href="<%=ctxRootPath%>/member/accredited_point.jsp" target="right">会员积分情况报告</a><br />
			<a href="<%=ctxRootPath%>/member/unused_point_list.jsp"
				target="right">最多未使用积分之会员列表</a><br />
			<a href="<%=ctxRootPath%>/index1.jsp" target="right">会员消费信息报表</a><br />
			<a href="<%=ctxRootPath%>/index2.jsp" target="right">会员信息报表</a><br />
			<a href="<%=ctxRootPath%>/supply.jsp" target="right">会员兑换报表</a><br />
			<a href="<%=ctxRootPath%>/top_merchant.jsp" target="right">最高收益商户</a><rp:np
				date="20100429" /><br />
			<a href="<%=ctxRootPath%>/datereport_sh.jsp" target="right">上海每日消费报表</a><br />

			<a href="<%=ctxRootPath%>/pos_maintenance.jsp" target="right">POS机管理报表(新)</a>
			<img src="images/updated.gif" title="最后更新: 2010-04-27" /><br />
			<a href="http://posm.china-rewards.com:10086/list.asp" target="right">POS机管理报表(旧)</a><br />


			<%--<a href="./huodong.jsp"> 海岸城活动报表</a> // removed on 2010-01-13 per request of Michael at Product Development department  --%>

			<a href="./posdatereport.jsp" target="right"> posdatereport</a><br />
			<a href="./operation.jsp" target="right"> operation.jsp</a><br />
			<a href="./update3.jsp" target="right"> operation
			member(update3.jsp)</a> <%--<a href="./onetime.jsp"> 一次消费，按会员分类</a> // removed on 2010-01-13 per request of Michael at Product Development department  --%>
			</div>
			</li>

			<li class="edge_003" onMouseOver="showMenu('Layer3');"
				onMouseOut="hideMenu('Layer3');">
			<h2>深航</h2>

			<div id="Layer3" class="list" style="display: none"><a
				href="<%=ctxRootPath%>/szair/reg_shbackend.jsp" target="right">深航客服推荐申请结果概览</a>
			<rp:np date="20100412" /><br />
			<a href="<%=ctxRootPath%>/szair/reg_jxt.jsp" target="right">积享通方尊鹏-缤分联盟卡申请文件报表结果概览</a>
			<rp:np date="20100512" /> <br />

			<a href="<%=ctxRootPath%>/szair/sunny-20100127.jsp" target="right">积享通深航会员注册报表20100127</a>
			<br />
			<%--<a href="./szair.jsp"> 积享通深航会员注册报表</a>
             <br>
             <a href="./szairresult.jsp"> 积享通深航会员注册结果报表</a>
             <br> --%> <a href="./szairpoint.jsp" target="right">
			积享通深航会员消费报表</a> <rp:np date="20100407" /> <br />
			<a href="./szairpointjifen.jsp" target="right">
			积享通深航会员消费报表(只累积缤分)</a> <rp:np date="20100407" /> <br />
			<a href="./szairnoregister.jsp" target="right">
			积享通深航会员已经消费未注册会员报表</a></div>
			</li>

			<li class="edge_003" onMouseOver="showMenu('Layer4');"
				onMouseOut="hideMenu('Layer4');">
			<h2>搜房</h2>
			<div id="Layer4" class="list" style="display: none"><a
				href="./soufun.jsp" target="right"> 搜房会员注册报表</a> <br />
			<a href="./soufunpoint.jsp" target="right"> 搜房会员消费报表</a></div>
			</li>

			<li class="edge_003" onMouseOver="showMenu('Layer5');"
				onMouseOut="hideMenu('Layer5');">
			<h2>国寿</h2>
			<div id="Layer5" class="list" style="display: none"><a
				href="./guoshou.jsp" target="right"> 国寿会员注册报表</a> <br>
			<a href="./guoshoupoint.jsp" target="right"> 国寿会员消费报表</a></div>
			</li>

			<li class="edge_003" onMouseOver="showMenu('Layer6');"
				onMouseOut="hideMenu('Layer6');">
			<h2>青岛</h2>
			<div id="Layer6" class="list" style="display: none"><a
				href="./qingdao_noregister_card.jsp" target="right"> 青岛未发卡报表</a></div>
			</li>
			<!--
	Integration Report STARTS 
 -->
			<li class="edge_003" onMouseOver="showMenu('Layer7');"
				onMouseOut="hideMenu('Layer7');">
			<h2>外部对接报表</h2>
			<div id="Layer7" class="list" style="display: none"><a
				href="./cococ_merchants.jsp" target="right">可可西 - 商户</a> <br />
			<a href="./cococ_products.jsp" target="right">可可西 - 商品</a></div>
			</li>

			<!--
	活动支持报表 STARTS 
 -->
			<li class="edge_003" onMouseOver="showMenu('Layer8');"
				onMouseOut="hideMenu('Layer8');">
			<h1>活动支持报表</h1>
			<div id="Layer8" class="list" style="display: none">
			<table>
				<thead>
					<tr>
						<th>日期</th>
						<th>内容</th>
						<th>连结</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>2010-08-08 2010-08-14 2010-08-15</td>
						<td>中信亲子游DIY<rp:np date="20100816" /></td>
						<td><a href="activity/20100806_zhongxinqinziyoudiy.jsp"
							target="right">中信亲子游DIY-国寿</a></td>
					</tr>
					<tr>
						<td>2010-08-01 至 2010-08-31</td>
						<td>番禺亲子游<rp:np date="20100816" /></td>
						<td><a href="activity/20100806_panyuqinziyou.jsp"
							target="right">番禺亲子游-国寿</a></td>
					</tr>

					<tr>
						<td>2010-06-22</td>
						<td>CocoPark商圈活动报表<rp:np date="20100622" /></td>
						<td><a href="activity/20100618_0731_cocopark_new.jsp"
							target="right">CocoPark(6.18-7.31)商圈活动消费者记录</a></td>
					</tr>
					<tr>
						<td>2010-06-22</td>
						<td>酷党三期活动报表<rp:np date="20100622" /></td>
						<td><a href="activity/20100618_coolparty_3.jsp"
							target="right">酷党三期活动消费者记录</a></td>
					</tr>
					<tr>
						<td>2010-06-01</td>
						<td>太平洋影院活动报表<rp:np date="20100601" /></td>
						<td><a href="activity/20100601_pacificfilm.jsp"
							target="right">太平洋影院活动消费者记录</a></td>
					</tr>

					<tr>
						<td>2010-03-16</td>
						<td>10元唱翻天<rp:np date="20100415" /></td>
						<td><a href="activity/20100316_coolparty_10_karaoke.jsp"
							target="right">10元唱翻天消费者记录</a></td>
					</tr>

					<tr>
						<td>2010-01-23</td>
						<td>跨商户消费电影票赠送活动</td>
						<td><a href="activity/20100122_unique_shop_spending.jsp"
							target="right">跨商户消费电影票赠送活动</a></td>
					</tr>

					<tr>
						<td>2010-01-16</td>
						<td>CoCo Park</td>
						<td><a href="activity/20100115_cocopark.jsp" target="right">CoCo
						Park 2010-01-16活动支持</a></td>
					</tr>

					<tr>
						<td>?</td>
						<td>网站电子电影票</td>
						<td><a href="sdb_filmticket_order_report.jsp" target="right">网站电子电影票兑换订单记录</a></td>
					</tr>

					<tr>
						<td>2010-01-16</td>
						<td>BNK现场活动支持</td>
						<td><a href="bnk_member_spending_record.jsp" target="right">BNK现场活动支持--电子电影票兑换订单记录</a></td>
					</tr>

				</tbody>
			</table>
			</div>
			</li>
			<!--
	活动支持报表 ENDS 
 -->

			<li class="edge_003" onMouseOver="showMenu('Layer9');"
				onMouseOut="hideMenu('Layer9');">
			<h2>QQ</h2>
			<div id="Layer9" class="list" style="display: none"><a
				href="./qqregister.jsp" target="right"> QQ会员注册信息报表</a> <br />
			<a href="./qqpointreport.jsp" target="right"> QQ会员消费信息报表</a></div>
			</li>

			<!--
	Key Business Indices STARTS 
 -->
			<li class="edge_003" onMouseOver="showMenu('Layer100');"
				onMouseOut="hideMenu('Layer100');">
			<h2>Key Business Indices</h2>
			<div id="Layer100" class="list" style="display: none">See <a
				href="https://redmine.dev.china-rewards.com/projects/general/wiki/Key_Business_Indices"
				target="right">Key Business Indices</a> <br />
			有交易的门店 <br />
			最高消费会员 <br />
			门店POS机上/下线时间概要 <br />
			(TBC) <br />
			</div>
			</li>
		</ul>
		</div>
		</td>

	</tr>
</table>
</div>
</div>

<script>
	function showMenu(param) {
		document.getElementById(param).style.display = "";
		document.getElementById(param).focus();
	}
	function hideMenu(param) {
		document.getElementById(param).style.display = "none";
	}
</script>
</body>
</html>