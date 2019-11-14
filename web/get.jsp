<%-- 
    Document   : get
    Created on : Nov 7, 2019, 4:52:08 PM
    Author     : q
--%>

<%@page import="java.util.regex.Pattern"%>
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
	<title>search text</title>
          
</head>
<body>
    <%! 
        String keyword ="none";
        String [][] arrayteacher ={{"เฉียบวุฒิ","เจี๊ยบวุต","เฉียบวุต","เชียบวุต","เชื่อวุต"},{"เอิญ","เอิน","เอิร์น"}
                ,{"กฤดาภัทร","กฤษฎาพัฒน์","เกดนภัส"},{"คันธารันต์","คันธารัตย์"},{"กอบเกียรติ","กอบเกียรติ์"},{"ปรวัฒน์","ปรวัติ"},{"สถิตย์","สถิต"}
                ,{"สุวัจชัย","สุวัฒชัย"},{"ปรัชญาพร","ปัดชญาภรณ์","ปัดเชียร์พร","ปัดเชียร์ยาก่อน","พัทยาพร","ปรัชยาพร","ปัดเชียร์ยาภรณ์","รัชญาพร"}};
       public boolean stringContainsNumber(String s )
        {
            return Pattern.compile( "[0-9]" ).matcher( s ).find();
        }
       public String findroom(String text){
                
                keyword = text.replaceAll("[^0-9.]","");
                System.out.println(keyword);
                return keyword;
       }
       public String findteacher(String text){
            for(int i=0;i<arrayteacher.length;i++){
                for(int j=0;j<arrayteacher[i].length;j++){               
                    if(text.contains(arrayteacher[i][j])){
                        System.out.println("name = "+arrayteacher[i][0]);
                        keyword = arrayteacher[i][0];
                    }
                }
            }
           return keyword ;
        }
    %>
    
    <%	
            
            
		//String strText = request.getParameter("text");
                String strText = "เอิน อยู่ไหน";
                String strDay = "Monday";
                String starttime = "15:00";
               
               
		//String strDay = request.getParameter("day");
               // String starttime = request.getParameter("time_start");
                
                String strRssi1 = request.getParameter("rssi1");
                String strRssi2 = request.getParameter("rssi2");
                String strRssi3 = request.getParameter("rssi3");
                String temp= "0";
                
                
                
                if( stringContainsNumber(strText) == true){
                      findroom(strText);
                      temp="0";
                      
                      session.setAttribute("text",keyword);
                      session.setAttribute("day", strDay);
                      session.setAttribute("time_start",starttime);
                      session.setAttribute("rssi1",strRssi1);
                      session.setAttribute("rssi2",strRssi2);
                      session.setAttribute("rssi3",strRssi3);
                      session.setAttribute("temp",temp);
                    
                }else{
                    System.out.println("Teacher");
                    findteacher(strText);
                    temp="1";
                    session.setAttribute("text",keyword);
                    session.setAttribute("day", strDay);
                    session.setAttribute("time_start",starttime);
                    
                    session.setAttribute("rssi1",strRssi1);
                    session.setAttribute("rssi2",strRssi2);
                    session.setAttribute("rssi3",strRssi3);
                    session.setAttribute("temp",temp);
                }

		out.println("Text : " + strText);
		out.println("<br>");		
		out.println("Day: " + strDay);
                out.println("<br>");		
		out.println("Time_start " + starttime);
                out.println("<br>");
                
		out.println("Rssi1 " + strRssi1);
                out.println("<br>");
                out.println("Rssi2 " + strRssi2);
                out.println("<br>");
                out.println("Rssi3 " + strRssi3);
                
                //System.out.println("Text:"+strText);
                //System.out.println("Day:"+strDay);
                //System.out.println("Time:"+strTime);
                //System.out.println("Rssi:"+strRssi);
                
	%>
</body>
</html>
