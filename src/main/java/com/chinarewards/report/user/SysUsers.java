package com.chinarewards.report.user;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

public class SysUsers {

	private static SysUsers sysUsers = null;

	public List<SysUserObj> users = null;

	private SysUsers() {
		initUsers();
	}

	public synchronized static SysUsers getInstance() {
		if (sysUsers == null) {
			sysUsers = new SysUsers();
		}

		return sysUsers;
	}

	private void initUsers() {
		
		
		users = new ArrayList<SysUserObj>();
		String url="";
		// init chinawards
		SysUserObj chinarewards = initUser("china-rewards", "123456");
		UserLimits crlimits = new UserLimits();
		crlimits.setAccessPage("/generalreportmenu.jsp");
		chinarewards.setLimits(crlimits);

		users.add(chinarewards);

		// init pc

		SysUserObj pc = initUser("pc", "123456");
		UserLimits pclimits = new UserLimits();
		pclimits.setAccessPage("/itreportmenu.jsp");
		pc.setLimits(pclimits);

		users.add(pc);

		// init it

		SysUserObj it = initUser("it", "123456");
		UserLimits itlimits = new UserLimits();
		itlimits.setAccessPage("/itreportmenu.jsp");
		it.setLimits(itlimits);

		users.add(it);

		// init adidas

		SysUserObj adidas = initUser("adidas", "adidas");
		UserLimits adidaslimits = new UserLimits();
		adidaslimits.setAccessPage("/itreportmenu.jsp");
		adidas.setLimits(itlimits);

		users.add(adidas);

//		 init coastalCity
//		SysUserObj coastalCity = initUser("coast", "coast");
//		UserLimits coastalCityLimits = new UserLimits();
//		coastalCityLimits.setAccessPage(url);
//		coastalCity.setLimits(coastalCityLimits);
//
//		users.add(coastalCity);
		
		
		try {
			// init coastalCity
			url = "/templateReport/reportTemplate.jsp?startDate=2012/07/26&endDate=2012/10/25&activity_id=01&activity_name="+URLEncoder.encode("海岸城七月活动","UTF-8")+"&username=coast";
			SysUserObj coastalCity = initUser("coast", "coast");
			UserLimits coastalCityLimits = new UserLimits();
			coastalCityLimits.setAccessPage(url);
			coastalCity.setLimits(coastalCityLimits);

			users.add(coastalCity);
			
			// init chengdu
			url = "/templateReport/reportTemplate.jsp?startDate=2012/08/30&endDate=2012/09/30&activity_id=02&activity_name="+URLEncoder.encode("成都站七月活动","UTF-8")+"&username=chengdu";
			SysUserObj chengDu = initUser("chengdu", "chengdu");
			UserLimits chengDuLimits = new UserLimits();
			chengDuLimits.setAccessPage(url);
			chengDu.setLimits(chengDuLimits);

			users.add(chengDu);
			// init template test
			url = "/templateReport/reportTemplate.jsp?startDate=2012/07/23&endDate=2012/09/30&activity_id=01&activity_name="+URLEncoder.encode("用于测试","UTF-8")+"&username=test";
			SysUserObj templateTest = initUser("test", "test");
			UserLimits templateTestLimits = new UserLimits();
			templateTestLimits.setAccessPage(url);
			templateTest.setLimits(templateTestLimits);

			users.add(templateTest);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public SysUserObj initUser(String username, String password) {
		SysUserObj sysUser = new SysUserObj();
		sysUser.setUsername(username);
		sysUser.setPassword(password);

		return sysUser;

	}

	public SysUserObj chickingUser(String username, String password)
			throws InvalidUserException {

		SysUserObj result = null;

		SysUserObj chechuser = new SysUserObj();
		chechuser.setUsername(username);
		chechuser.setPassword(password);

		for (SysUserObj user : users) {
			if (user.equals(chechuser)) {
				result = user;
			}
		}

		if (result == null) {
			throw new InvalidUserException("invalid username or password");
		}

		return result;
	}
}
