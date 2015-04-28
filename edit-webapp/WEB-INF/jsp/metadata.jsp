<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%
final WebApplicationContext springContext =
	WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
final String path = springContext.getEnvironment().getProperty("idp.home") + "/metadata/idp-metadata.xml";
try (final java.io.FileInputStream in = new java.io.FileInputStream(path)) {
	int i;
	while ((i = in.read()) != -1) {
	    out.write(i);
	}
} catch (final java.io.IOException e) {
	out.println(e.getMessage());
	return;
}

final String acceptHeader = request.getHeader("Accept");
if (acceptHeader != null && !acceptHeader.contains("application/samlmetadata+xml")) {
    response.setContentType("application/xml");
} else {
    response.setContentType("application/samlmetadata+xml");
}
%>