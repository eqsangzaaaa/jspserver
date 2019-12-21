<%-- 
    Document   : roomdatajson
    Created on : Dec 20, 2019, 2:32:24 PM
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Room</title>
    </head>
    <body>


        <%
            Connection connect = null;
            Statement st = null;
            //String id_room = "";
            // String local_x = "";

            try {

                Class.forName("org.postgresql.Driver");

                connect = DriverManager
                        .getConnection("jdbc:postgresql://localhost:5432/alldata",
                                "q", "");
                if (connect != null) {

                } else {
                    out.println("Database Connect Failed.");
                }
                st = connect.createStatement();

                String sql = "SELECT id_room FROM Room";

                ResultSet rs = st.executeQuery(sql);
                int i = 0;
                JSONArray jArray = new JSONArray();
                while (rs.next()) {

                    String id = rs.getString("id_room");

                    JSONObject arrayObj = new JSONObject();

                    arrayObj.put("room", id);

                    jArray.add(i, arrayObj);
                    i++;

                }
                rs.close();

                Writer outx = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File("/Users/q/NetBeansProjects/WebApplication/web/roomjsondata.json")), StandardCharsets.UTF_8));

                outx.write(jArray.toJSONString());
                outx.flush();
                outx.close();
                //----------------------------------------------------------------------------
                out.print(jArray);
                TimeUnit.SECONDS.sleep(2);
                response.sendRedirect("roomjsondata.json");

            } catch (Exception e) {
                // TODO Auto-generated catch block
                out.println(e.getMessage());
                e.printStackTrace();
            }

            try {

                if (st != null) {

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
