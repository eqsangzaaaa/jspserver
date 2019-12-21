<%@ page import="java.sql.ResultSet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<html>
<head>
	<title>ThaiCreate.Com JSP Tutorial</title>
</head>
<body>
	
	<%
	Connection connect = null;
	Statement s = null;
	
	try {
		Class.forName("org.postgresql.Driver");

		connect =  DriverManager
            .getConnection("jdbc:postgresql://localhost:5432/alldata",
            "q", "");
		
		s = connect.createStatement();
		
		String sql = "SELECT * FROM teacher";
		
		ResultSet rec = s.executeQuery(sql);
		%>
		<table width="600" border="1">
		  <tr>
		    <th width="91"> <div align="center">id </div></th>
		    <th width="98"> <div align="center">Name </div></th>
		    <th width="198"> <div align="center">Surname </div></th>
		    <th width="97"> <div align="center">email </div></th>
		  
		  </tr>	
			<%while((rec!=null) && (rec.next())) { %>
				  <tr>
				    <td><div align="center"><%=rec.getString("id_teacher")%></div></td>
				    <td><%=rec.getString("Name")%></td>
				    <td><%=rec.getString("Surname")%></td>
				    <td><div align="center"><%=rec.getString("Email")%></div></td>
				    
                                    
				  </tr>
	       	<%}%>
	  	</table>      
	    <%	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			out.println(e.getMessage());
			e.printStackTrace();
		}
	
		try {
			if(s!=null){
				s.close();
				connect.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			out.println(e.getMessage());
			e.printStackTrace();
		}
	%>
</body>
</html>