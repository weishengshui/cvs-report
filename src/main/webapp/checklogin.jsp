<%@ page import="java.net.URLEncoder"%>
<%@ page language="java" import="javax.servlet.http.*"%>
<%
	/**
	 * This JSP checks if the user has logged in before, and redirect the user
	 * to the login page if not.
	 */

	// check login.
	{
		String _login = (String) session.getAttribute("Login");

		if (_login == null || !"OK".equals(_login)) {

			// send a redirect.

			String newLocn = request.getContextPath()
					//+ "/session_expired.jsp";
					+"/login.jsp";
							/**
							?returnUrl="
					+ URLEncoder.encode(requestUrl, "UTF-8");
**/
			response.sendRedirect(newLocn);

			return;
		}
	}
%>