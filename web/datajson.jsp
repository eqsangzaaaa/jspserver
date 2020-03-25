<%-- 
    Document   : datajson
    Created on : Dec 20, 2019, 2:04:43 PM
    Author     : q
--%>

<%@page import="java.nio.charset.StandardCharsets"%>

<%@page import="java.io.*"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.concurrent.TimeUnit"%>


<!DOCTYPE html>
<html>
    <head>
        
        <title> JSON </title>
    </head>
     <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <body>
     
        
        <% 
        Connection connect = null;
        Statement st = null;
        

try {
    
	Class.forName("org.postgresql.Driver");

	connect =  DriverManager
            .getConnection("jdbc:postgresql://localhost:5432/alldata",
            "q", "");
	if(connect != null){
		
                System.out.println("Database Connected");
	} else {
		out.println("Database Connect Failed.");
	}
        st = connect.createStatement();
		
		String sql = "SELECT name,aka,email FROM Teacher";
		
		ResultSet rs = st.executeQuery(sql);
                 int i=0;
            JSONArray jArray = new JSONArray();
            while(rs.next()){

        String name = rs.getString("name");
        String aka = rs.getString("aka");
        String email = rs.getString("email");
       
        
        JSONObject arrayObj = new JSONObject();

        arrayObj.put("aka",aka);
        arrayObj.put("name",name);
        arrayObj.put("email", email);
        
        jArray.add(i,arrayObj);
        i++;
        //out.println(jArray);
        
        }
            rs.close ();
            
        Writer outx = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File("/Users/q/NetBeansProjects/WebApplication/web/teacherjsondata.json")),  StandardCharsets.UTF_8));
        
        outx.write(jArray.toJSONString());
        outx.flush();
        outx.close();
  //----------------------------------------------------------------------------
  //out.print(jArray);
  TimeUnit.SECONDS.sleep(2);
  response.sendRedirect("teacherjsondata.json");
    
        
		} catch (Exception e) {
			// TODO Auto-generated catch block
			out.println(e.getMessage());
			e.printStackTrace();
		}
	
		try {
                    
			if(st!=null){
                            System.out.println("2");
				st.close();
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
