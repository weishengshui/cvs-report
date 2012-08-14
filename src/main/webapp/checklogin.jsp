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

		// login page URL
		String loginUrl = request.getContextPath() + "/login.jsp";
		int timeout = 3;
		
		/**
		String requestUrl = request.getRequestURL().toString();
		if (request.getQueryString() != null) {
			requestUrl += "?" + request.getQueryString();
		}
		**/

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