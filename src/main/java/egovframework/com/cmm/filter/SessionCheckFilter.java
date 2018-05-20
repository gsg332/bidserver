package egovframework.com.cmm.filter;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SessionCheckFilter implements Filter {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	protected FilterConfig config = null;

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.config = config;
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String reqUrl = getUrl(httpRequest);

		// logger.debug("요청된 URL : " + reqUrl);

		HttpSession session = httpRequest.getSession();

		if (!reqUrl.contains("/login.do")) {
			if (!"true".equals(session.getAttribute("loginOK"))) { // 로그아웃 상태이거나 세션정보가 존재하지 않으면.
				httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?isNotLogin=true");
			}
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
		this.config = null;
	}

	public String getUrl(HttpServletRequest request) {
		String parameterList = "";
		String ret_url = request.getRequestURI(); // No Parameter url

		int k = 0;

		for (Enumeration e = request.getParameterNames(); e.hasMoreElements(); k++) {
			String name = (String) e.nextElement();
			String[] value = request.getParameterValues(name);

			if (k == 0)
				ret_url = ret_url + "?";
			else if (k > 0)
				ret_url = ret_url + "&";
			parameterList = parameterList + "&";

			for (int q = 0; q < value.length; q++) {
				if (q > 0) {
					ret_url = ret_url + "&";
					parameterList = parameterList + "&";
				}
				ret_url = ret_url + name + "=" + value[q];
				parameterList = parameterList + name + "=" + value[q];
			}

		}

		String result = ret_url;
		return result;
	}
}
