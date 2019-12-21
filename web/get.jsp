<%-- 
    Document   : get
    Created on : Nov 7, 2019, 4:52:08 PM
    Author     : q
--%>

<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.regex.Pattern"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.io.*"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>

<!DOCTYPE html>
<html>
    <head>
        <title>search text</title>

    </head>
     <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <body>
        <h1>Result</h1>
        <%!
            String keyword = "none";
            String strtext = "none";
            String strday = "none";
            String starttime = "00:00";
            String strRssi1 = "0";
            String strRssi2 = "0";
            String strRssi3 = "0";
            String type = "0";
           
            String sql;
            ResultSet rs;
            ResultSet temprs;
            String temptime_start;
            String temptime_stop;
            String temproom;
            String finalroom = "There are no rooms you are looking for";
           
        %>

        <%
            //String strtext = "ลือพล";
            //String strday = "Monday";
            //String starttime = "15:00";
            if (strtext == "wait") {
                strtext = request.getParameter("text");
                strday = request.getParameter("day");
                starttime = request.getParameter("timestart");
                strRssi1 = request.getParameter("rssi1");
                strRssi2 = request.getParameter("rssi2");
                strRssi3 = request.getParameter("rssi3");
                type = request.getParameter("type");
            }

            out.println("<br>");
            String[] fulltimestart = starttime.split(":");
            System.out.println("fulltime= " + fulltimestart[0]);
            System.out.println("fulltime= " + fulltimestart[1]);
            int Hrs = Integer.parseInt(fulltimestart[0]);
            int Mins = Integer.parseInt(fulltimestart[1]);
           


        %>
        
        <%  
            Connection connect = null;
            Statement st = null;

            try {
                Class.forName("org.postgresql.Driver");

                connect = DriverManager.getConnection("jdbc:postgresql://localhost:5432/alldata","q", "");
                if (connect != null) {

                } else {
                    System.out.println("Database Connect Failed.");
                    out.println("Database Connect Failed.");
                }

                st = connect.createStatement();

               
                if (type == "1") {
                    sql = "SELECT * FROM  room WHERE id_room like '%" + strtext + "%' ";
                    rs = st.executeQuery(sql);

                    while ((rs != null) && (rs.next())) {
                        finalroom = rs.getString("id_room");

                    }
                    rs.close ();
                } else {
                    sql = "SELECT * FROM Timetable WHERE day like'%" + strday + "%' AND id_teacher IN (SELECT id_teacher FROM teacher WHERE aka like '%" + strtext + "%')";
                    temprs = st.executeQuery(sql);
                    int i = 0;
                    while ((temprs != null) && (temprs.next())) {

                        temproom = temprs.getString("id_room");
                        temptime_start = temprs.getString("time_start");
                        temptime_stop = temprs.getString("time_stop");
                        String[] temptimestart = temptime_start.split(":");
                        String[] temptimestop = temptime_stop.split(":");
                        
                        int start_hr = Integer.parseInt(temptimestart[0]);
                        int start_min = Integer.parseInt(temptimestart[1]);
                        int stop_hr = Integer.parseInt(temptimestop[0]);
                        int stop_min = Integer.parseInt(temptimestop[1]);

                        if (Hrs > start_hr && Hrs < stop_hr) {
                               
                            finalroom = temproom;
                        }else if (Hrs == start_hr) {
                            if (Mins >= start_min) {
                                  
                                finalroom = temproom;
                            }
                        }else if (Hrs == stop_hr) {
                            if (Mins <= stop_min) {
                                
                                finalroom = temproom;
                            }
                            
                        }else if(Hrs < 8 || Hrs > 15){
                            
                            finalroom = "0000";
                        }else if(Hrs>=8 || Hrs <= 15){
                             finalroom = "1111";   
                        }
                            
 
                    }
                   temprs.close();

                }
                
                 System.out.println("roomfind =  " + finalroom);


        %>

        <%  
             JSONArray jArray = new JSONArray();
            JSONObject arrayObj = new JSONObject();
            
            arrayObj.put("room", finalroom);
            
            jArray.add(arrayObj);
            
            Writer outx = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File("/Users/q/NetBeansProjects/WebApplication/web/output.json")), StandardCharsets.UTF_8));

            outx.write(jArray.toJSONString());
            outx.flush();
            outx.close();
            out.println("room=" + finalroom);
            strtext = "wait";
            finalroom = "There are no rooms you are looking for";
            TimeUnit.SECONDS.sleep(2);
            response.sendRedirect("output.json");
            System.out.println("-----------------------------");

            
        %>

        <%
            
            } catch (Exception e) {
                // TODO Auto-generated catch block
                out.println(e.getMessage());
                e.printStackTrace();
            }

            try {

                if (st != null) {
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
