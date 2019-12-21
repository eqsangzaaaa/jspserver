<%-- 
    Document   : main
    Created on : Nov 7, 2019, 4:15:00 PM
    Author     : q
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.io.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<html>
<head>
	<title>search</title>
</head>
<body>

        <%  
            String strtext = String.valueOf(session.getAttribute("text"));
            String strday = String.valueOf(session.getAttribute("day"));
            String starttime = String.valueOf(session.getAttribute("time_start"));
            String stoptime = String.valueOf(session.getAttribute("time_stop"));
            String rssi1 = String.valueOf(session.getAttribute("rssi1"));
            String rssi2 = String.valueOf(session.getAttribute("rssi2"));
            String rssi3 = String.valueOf(session.getAttribute("rssi3"));
            String temp = String.valueOf(session.getAttribute("temp"));
            System.out.println("temp "+temp);
                String [] fulltimestart = starttime.split(":");
                String [] fulltimestop = stoptime.split(":");
                System.out.println("fulltime"+ fulltimestart[0]);
                String tHrs="1" ;
                String tMins="1" ;
                tHrs = fulltimestart[0];
                tMins = fulltimestart[1];
                int Hrs = Integer.parseInt(tHrs);
                int Mins = Integer.parseInt(tMins);

                
               
                    
                
               
        %>
       
        
          
        <% 
        Connection connect = null;
        Statement st = null;
        

try {
	Class.forName("org.postgresql.Driver");

	connect =  DriverManager
            .getConnection("jdbc:postgresql://localhost:5432/alldata",
            "q", "");
	if(connect != null){
                
	} else {
                System.out.println("Database Connect Failed.");
		out.println("Database Connect Failed.");
	}
        
         st = connect.createStatement();
		String sql;
                ResultSet rs;
                ResultSet temprs;
                String temptime_start;
                String temptime_stop;
                String temproom ;
                String finalroom = "a";
                String roomnumber="no";
                String local_y="no";
                String local_z="no";
                
		
                 System.out.println("tempasd"+temp);
                if(temp == "0"){
                    sql = "SELECT * FROM  room WHERE id_room like '%" +  strtext + "%' " ;
                    rs = st.executeQuery(sql);
                    System.out.println("tempasd");
                    while((rs!=null) && (rs.next())) { 
                            roomnumber = rs.getString("id_room");
                           
                            
                        }
                }
                
                else{
                    sql= "SELECT * FROM Timetable WHERE day like'%"+ strday +"%' AND id_teacher IN (SELECT id_teacher FROM teacher WHERE name like '%"+ strtext +"%')";
                    temprs = st.executeQuery(sql);
                        int i=0;
                       while((temprs!=null) && (temprs.next())) { 
                         
                          temproom = temprs.getString("id_room");
                          temptime_start = temprs.getString("time_start");
                          temptime_stop = temprs.getString("time_stop");
                          String [] temptimestart = temptime_start.split(":");
                          String tstart_hr = temptimestart[0];
                          String tstart_min = temptimestart[1];
                         
                          
                          String [] temptimestop = temptime_stop.split(":");
                          String tstop_hr = temptimestop[0];
                          String tstop_min = temptimestop[1];
                          int start_hr = Integer.parseInt(tstart_hr);
                          int start_min = Integer.parseInt(tstart_min);
                          int stop_hr = Integer.parseInt(tstop_hr);
                          int stop_min = Integer.parseInt(tstop_min);
                         
                           if(Hrs > start_hr && Hrs < stop_hr){
                                   
                                  
                                  finalroom = temproom;
                            }else if(Hrs == start_hr ){
                                if(Mins >= start_min){
                                  
                                  finalroom = temproom;
                                }
                            }
                            else if(Hrs == stop_hr){
                                if(Mins <= stop_min){
                                  
                                  finalroom = temproom;
                                }
                            } 
                        }
                       sql = "SELECT * FROM  room WHERE id_room like '%" +  finalroom + "%' ";
                       rs = st.executeQuery(sql);
                        
                            while((rs!=null) && (rs.next())) { 
                                roomnumber = rs.getString("id_room");
                                
                             }
                       
                }
                    
                
                
                %>
                
			<%
                      out.println("x="+roomnumber);
                     
                        
                        %>
				 
	    <%	
                
    } catch (Exception e) {
			// TODO Auto-generated catch block
			out.println(e.getMessage());
			e.printStackTrace();
		}
	
		try {
                    
			if(st!=null){
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
