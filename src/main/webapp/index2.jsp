<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page contentType="text/html;charset=utf-8" %> 
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>会员信息报表 (index2)</title>
</head>

<body>


<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 

Connection conn = null;
ResultSet rs = null; 
Statement stmt = null; 


try 
{ 

Class.forName(sDBDriver); 
conn = DbConnectionFactory.getInstance().getConnection("crm");

/*
select mobiletelephone, regsource, memberstatus,registdate from member 
where 1=1
and registdate >'11-MAY-09'
order by regsource , memberstatus
*/


out.println("<h1>海岸城活动</h1>");
stmt = conn.createStatement(); 
out.println("海岸城活动起会员的激活会员注册人数(from 2009-09-05)");
out.println("<br>"); 
rs = stmt.executeQuery("select  count(*),regsource from member m where 1=1 and registdate >= {d '2009-09-05'} group by regsource"); 
while (rs.next()){ 


out.println("" + rs.getString(2) +    ""); 
out.println("" + rs.getString(1) +    ""); 


out.println("<br>"); 

} 
rs.close(); 


out.println("<br>");
out.println("<br>");




//
// POS
//
out.println("<h1>POS机手机注册</h1>");
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("<br/>"); 
rs = stmt.executeQuery("select count(*), status from tempcard t where type='1' GROUP BY status"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 
String tt = rs.getString(2);
String lable = "已经注册成为临时卡会员";
if(tt.equals("used")){
  lable = "已经从临时卡会员成为正式会员";
}
out.println("" + lable +    ""); 

out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 



//pos机 temp card
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("<h1>申请表临时卡或折页</h1>");
out.println("<br>");
out.println("申请表临时卡或折页<br/>");
rs = stmt.executeQuery("select count(*), status from tempcard t where type!='1' GROUP BY status"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 
String tt = rs.getString(2);
String lable = "";

if(tt.equals("used")){
  lable = "已经从临时卡会员成为正式会员";
}

if (tt.equals("activated")){
  lable = "已经注册成为临时卡会员";
}
out.println("" + lable +    ""); 

out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 


//
// POS 机手机汇总报表
//
out.println("<h1>POS 机手机汇总报表</h1>");
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("<br>"); 
rs = stmt.executeQuery("select count(*), s.name from tempcard t, shop s where type='1'and s.id = t.shop_id group by s.name"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ": "); 
out.println("" + rs.getString(2) +    ""); 

out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 





//Member summary report: 
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("Member summary report: ");
out.println("<br>"); 
rs = stmt.executeQuery("select count(*), regsource from member where 1=1 GROUP by regsource"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 
out.println("" + rs.getString(2) +    ""); 


out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 






//template member be Member: 
stmt = conn.createStatement(); 
out.println("template member be Member:");
out.println("<br>"); 
rs = stmt.executeQuery("select  COUNT(*) from tempcard t, member m  where t.id = m.mobiletelephone"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 



out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 


stmt = conn.createStatement(); 
out.println("Pos机注册激活会员总数:");
out.println("<br>"); 
rs = stmt.executeQuery("select  COUNT(*) from tempcard t, member m  where t.id = m.mobiletelephone"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 



out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 


//member status report: 
stmt = conn.createStatement(); 
out.println("member status report:");
out.println("<br>"); 
rs = stmt.executeQuery("select  count(*),memberstatus from member m where 1=1 group by memberstatus"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 
out.println("" + rs.getString(2) +    ""); 


out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 


//pos机 临时卡注册
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("pos机临时卡注册");
out.println("<br>"); 
rs = stmt.executeQuery("select count(*) from tempcard t where (status = 'activated' or status = 'used') " ); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 


out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 


//发卡数量报表
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("发卡数量报表：：：");
out.println("<br>"); 
rs = stmt.executeQuery("select cardno, registerdate, printdate from carddb where registerdate > {d '2009-05-15'} order by registerdate"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 
out.println("" + rs.getString(2) +    ""); 
out.println("" + rs.getString(3) +    ""); 

out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 




/*
//Commented out on 2010-01-13 per request by Michael and June of Product Development department

//
//竞拍的竞拍人数
//
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("竞拍品当前竞拍情况：：");
out.println("<br>"); 
out.println("名称  人数  当前价格");
out.println("<br>"); 
rs = stmt.executeQuery("select e.prizename, i.auctiondegree, i.currentprice from auctioninfo i,auctionprize a , prizebase e where a.auctioninfo_id = i.id and e.id=a.a_id"); 
while (rs.next()){ 


out.println("" + rs.getString(1) +    ""); 
out.println("" + rs.getString(2) +    ""); 
out.println("" + rs.getString(3) +    ""); 

out.println("<br>"); 

} 
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 
*/


/*

// Commented out on 2010-01-13 per request by Michael and June of Product Development department

//竞拍的竞拍人数
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("活动抽奖report：：");
out.println("<br>"); 
out.println("名称  人数  当前价格");
out.println("<br>"); 
rs = stmt.executeQuery("select w.id , w.time , m.chilastname , m.chisurname ,p.prizeName from winprizeinfo w , member m , drawoutprize d,PrizeBase p where w.member_id =m.id and w.drawoutprize_a_id=d.a_id and p.id = d.a_id"); 
while (rs.next()){ 


out.println("" + rs.getString(2) +    ""); 
out.println("" + rs.getString(4) +    ""); 
out.println("" + rs.getString(3) +    "");
out.println("" + rs.getString(5) +    ""); 

out.println("<br>"); 

} 
rs.close();
*/


out.println("<br>"); 
out.println("<br>"); 





/*

// Commented out on 2010-01-13 per request by Michael and June of Product Development department

//竞拍的竞拍人数
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("活动竞拍report：：");
out.println("<br>"); 
out.println("名称  人数  当前价格");
out.println("<br>"); 
rs = stmt.executeQuery("select DISTINCT(w.id)  ,w.cardno, m.chilastname , m.chisurname ,pb.prizeName from AuctionInfo w, auctionprize p, member m,PrizeBase pb where w.member_id = m.id  and pb.id= p.a_id and p.auctioninfo_id=w.id"); 
while (rs.next()){ 


out.println("" + rs.getString(2) +    ""); 
out.println("" + rs.getString(4) +    ""); 
out.println("" + rs.getString(3) +    "");
out.println("" + rs.getString(5) +    ""); 

out.println("<br>"); 

} 
rs.close(); 
*/

out.println("<br>"); 
out.println("<br>"); 
out.println("<br>"); 
out.println("<br>"); 





} 
catch(Exception e) 
{ 
  out.println(e); 
}finally{
	if(conn!=null){
	    conn.close();
	    System.out.println("connection close....");
   }	
	if(stmt!=null){
	    stmt.close();
   }
	if(rs!=null){
	    rs.close();
   }
}


%>

