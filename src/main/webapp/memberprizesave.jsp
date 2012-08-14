<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 
<%
String posid=request.getParameter("posid");
String mp=request.getParameter("mp");
String money=request.getParameter("money");
String address=request.getParameter("address");
String name=request.getParameter("name");
String prize=request.getParameter("prize");
String ren=request.getParameter("ren");
String remark=request.getParameter("remark");

out.println("the fieldes are : "+posid+mp+money+address+name+prize+ren+remark);


%>
<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@192.168.4.12:1521:chinarewards"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 

/*
select count(*) from clubpoint where transdate >'15-MAY-09'
and clubid='00';

//the summay payment in each shop
select sum(amountcurrency),shopname from clubpoint where transdate >'15-MAY-09'
and clubid='00' GROUP by shopname;

//the auction count for each gift
select sum(version) ,auctionprizename from auctionrecord where 1=1 group by auctionprizename;


//lucky draw summary
select count(*) from luckydrawticket ;

#finish the luck draw summary
select count(*) from luckydrawticket where isluckydraw ='1';

// not finish the luck draw summary
select count(*) from luckydrawticket where isluckydraw ='0';

//get the paster 
select distinct memberid from pasterofmember where time >'01-MAY-09';

//get the paster not creating the lucky chance
select distinct memberid from pasterofmember where time >'01-MAY-09' and luckydrawticket_id =null;
*/
//商户消费总额
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 


stmt = conn.createStatement(); 
String insertString1 ="INSERT into cocoparkprize values('"+posid+"','"+mp+"','"+money+"','"+address+"','"+name+"','"+prize+"','"+ren+"','"+remark+"')";
//rs = stmt.executeQuery("select shopname, amountcurrency,point, unitcode, transdate,membercardid,txnid from clubpoint where  membercardid='"+username+"'"); 
stmt.executeUpdate(insertString1);


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

out.println("save ok!");
out.println("<br/>");
out.println("<a href='member_cocopark.jsp'>录入会员获奖信息</a>");
out.println("<br/>");
out.println("<a href='listprize.jsp'>获奖信息列表</a>");


%>

