<%-- 
    Document   : get
    Created on : Nov 7, 2019, 4:52:08 PM
    Author     : q
--%>

<%@page import="java.text.DecimalFormat"%>
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
            String strRssi = "0";
            int rssi = 0;
            double direct = 0;
            ;

            String temp = "0";

            String sql;
            ResultSet rs;
            ResultSet temprs;
            ResultSet results;
            int locate;
            String temptime_start;
            String temptime_stop;
            String temproom;
            String finalroom = "There are no rooms you are looking for";
            String result = "none";
            
           
            



        %>

        <%
            
            if (strtext == "none") {
                System.out.println("start server");
            }
            //String strtext = "ลือพล";
            //String strday = "Monday";
            //String starttime = "15:00";
            int type = 0;
            if (strtext == "wait") {
                strtext = request.getParameter("text");
                strday = request.getParameter("day");
                starttime = request.getParameter("timestart");
                strRssi = request.getParameter("rssi");
                temp = request.getParameter("type");
                direct = Double.parseDouble(request.getParameter("dir"));
            }
            type = Integer.parseInt(temp);
            rssi = Integer.parseInt(strRssi);

            out.println("<br>");
            String[] fulltimestart = starttime.split(":");
            System.out.println("fulltime= " + fulltimestart[0]);
            System.out.println("fulltime= " + fulltimestart[1]);
            System.out.println("day= " + strday);
            System.out.println("zone= " + rssi);
            System.out.println("direct = " + direct);
            int Hrs = Integer.parseInt(fulltimestart[0]);
            int Mins = Integer.parseInt(fulltimestart[1]);


        %>

        <%            Connection connect = null;
            Statement st = null;

            try {
                Class.forName("org.postgresql.Driver");

                connect = DriverManager.getConnection("jdbc:postgresql://localhost:5432/alldata", "q", "");
                if (connect != null) {

                } else {
                    System.out.println("Database Connect Failed.");
                    out.println("Database Connect Failed.");
                }

                st = connect.createStatement();

                if (type == 1) {
                    System.out.println("type=" + type);
                    sql = "SELECT id_room FROM  room WHERE id_room like '%" + strtext + "%' ";
                    rs = st.executeQuery(sql);

                    while ((rs != null) && (rs.next())) {
                        finalroom = rs.getString("id_room");

                    }

                } else if (type == 2) {
                    System.out.println("type=" + type);
                    sql = "SELECT * FROM Timetable WHERE day like'%" + strday + "%' AND id_teacher IN (SELECT id_teacher FROM teacher WHERE aka like '%" + strtext + "%')";
                    temprs = st.executeQuery(sql);

                    int status = 0;

                    while ((temprs != null) && (temprs.next())) {

                        status = 1;
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
                        } else if (Hrs == start_hr) {
                            if (Mins >= start_min) {

                                finalroom = temproom;
                            }
                        } else if (Hrs == stop_hr) {
                            if (Mins <= stop_min) {

                                finalroom = temproom;
                            }

                        } else if (Hrs < 8 || Hrs > 15) {

                            finalroom = "0000";
                        } else if (Hrs >= 8 || Hrs <= 15) {
                            finalroom = "1111";
                        }

                    }
                    if (status == 0) {
                        if (Hrs < 8 || Hrs > 15) {

                            finalroom = "0000";
                        } else if (Hrs >= 8 || Hrs <= 15) {
                            finalroom = "1111";
                        }
                    }

                }
                System.out.println("roomfind =  " + finalroom);
                if (rssi == 2) {
                    sql = "SELECT locate_2 FROM  room WHERE id_room like '%" + finalroom + "%' ";
                    results = st.executeQuery(sql);
                    while ((results != null) && (results.next())) {
                        locate = Integer.parseInt(results.getString("locate_2"));
                    }
                } else {
                    sql = "SELECT locate_1 FROM  room WHERE id_room like '%" + finalroom + "%' ";
                    results = st.executeQuery(sql);
                    while ((results != null) && (results.next())) {
                        locate = Integer.parseInt(results.getString("locate_1"));
                    }
                }

                System.out.println("locate=" + locate);

                //mark arrow
                int r = 0;
                double x = 0;
                double y = -1;
                //double z=0;
                double[] array_x = new double[1000];
                double[] array_y = new double[1000];
                double[] array_z = new double[1000];                
                double ac, as;
                //double[] x1 = new double[100];
                double[] x1 = {0,-0.25,-8,-28};
                double[] x2 = {0,-7,-27,-29.75};
                double[] z1 = {0,-16,-43.4,-47.6};
                double[] z2 = {-15,-43,-47.2,-54.6};
                double[] dircng = {0,18,80,18};
                int startdir = 132;
                double diruse;
                int str = 1, i = 0;
                if(rssi == 3){
                     double[] x1t = {0,-1,-15,-14.75};
                     double[] x2t = {0,-15,-15,-7.25};
                     double[] z1t = {0,-4.5,-12.5,-41};
                     double[] z2t = {-4,-11.5,-39,-60};
                     double[] dircngt = {0,58,0,-12};
                    int startdirt = 350;
                    
                    x1 = x1t;
                    x2 = x2t;
                    z1 = z1t;
                    z2 = z2t;
                    dircng = dircngt;
                    startdir = startdirt;
                    
                }
                   System.out.println("x1="+x1[0]);
                for (int g = 0; g < 4; g++){
                    diruse = direct;
                    System.out.println("g = "+(g+1));
                    diruse = direct+startdir+dircng[g];
                    if(diruse >= 360){
                        diruse = diruse - 360;
                    }
                    System.out.println("drict2 = "+diruse);
                    double angle = diruse;

                    double an = Math.toRadians(angle);
                    System.out.println("an=" + an + " cos " + Math.round(Math.cos(an)) + " cos" + Math.cos(an));
                    System.out.println("an=" + an + " sin " + Math.round(Math.sin(an)) + " sin" + Math.sin(an));
                    double ra = Math.sqrt(Math.pow((x1[g]-x2[g]),2) + Math.pow(z1[g]-z2[g],2));
                    

                    if (angle == 0 || angle == 180 || angle == 90 || angle == 270 || angle == 360) {
                        ac = Math.round(Math.cos(an));
                        as = Math.round(Math.sin(an));
                    } else {
                        ac = (Math.cos(an));
                        as = (Math.sin(an));
                    }


                    double xi = ra * ac;
                    double zi = ra * as * (-1);

                    System.out.println(xi + "," + zi);
                 
                    xi = xi + array_x[str-1] ;
                    zi = zi + array_z[str-1] ;
                    double xn = (xi -  array_x[str-1]) / ra;
                    double zn = (zi -  array_z[str-1])/ ra;
                    System.out.println("xz = "+xi + "," + zi);
                     ra = Math.round(ra);
                     System.out.println("r"+(g+1)+"="+ra);
                     array_x[0] = x1[0];
                     array_z[0] = z1[0];
                     array_y[0] = y;
                     
                    for (int j = 0 ; j < ra; j++) {
                    
                        array_x[str] = array_x[str-1] + xn;
                        array_z[str] = array_z[str-1] + zn;
                        array_y[str] = y;
                        System.out.print(array_x[str]);
                        System.out.print(" == ");
                        System.out.print(array_z[str]);
                        System.out.println("");
                       
                        str++;
                        i++;
                    }
                    
                    System.out.println(i+1);
                    array_x[0] = x1[0];
                    array_z[0] = z1[0];
                }

        %>
        <%            //System.out.println("r="+r);
            int k = 0;
            JSONArray jArray = new JSONArray();
            while (k < i) {
                JSONObject arrayObj = new JSONObject();
                arrayObj.put("x", array_x[k]);
                arrayObj.put("y", array_y[k]);
                arrayObj.put("z", array_z[k]);
                jArray.add(arrayObj);
                k++;

            }

            Writer outx = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File("/Users/q/NetBeansProjects/WebApplication/web/output.json")), StandardCharsets.UTF_8));
            outx.write(jArray.toJSONString());
            outx.flush();
            outx.close();
            //out.println("result" +result);
            strtext = "wait";
            finalroom = "There are no rooms you are looking for";
            TimeUnit.SECONDS.sleep(3);
            response.sendRedirect("output.json");

            System.out.println("-----------------------------");
        %>
        <%            } catch (Exception e) {
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
