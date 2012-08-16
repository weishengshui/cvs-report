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

		// init coastalCity
		SysUserObj coastalCity = initUser("coast", "coast");
		UserLimits coastalCityLimits = new UserLimits();
		coastalCityLimits.setAccessPage("/coastalCity201207.jsp");
		coastalCity.setLimits(coastalCityLimits);

		users.add(coastalCity);
		
		try {
			// init template test
			String url = "/templateReport/reportTemplate.jsp?startDate=2012/07/23&endDate=2012/09/30&activity_id=01&activity_name="+URLEncoder.encode("成都站七月活动","UTF-8");
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
