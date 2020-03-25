<%-- 
    Document   : get
    Created on : Nov 7, 2019, 4:52:08 PM
    Author     : q
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
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
        <h1>CSNav</h1>
        <%!
            String keyword = "none";
            String strtext = "none";
            String strday = "none";
            String starttime = "00:00";
            String strRssi = "0";
            String strzone = "0";
            double rssi = 0;
            int zone = 0;
            double direct = 0;
            String temp = "0";
            String sql;
            ResultSet rs;
            ResultSet temprs;
            ResultSet results;
            int locate = -1;
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
            int type = 0;
            if (strtext == "wait") {
                strtext = request.getParameter("text");
                strday = request.getParameter("day");
                starttime = request.getParameter("timestart");
                strzone = request.getParameter("zone");
                strRssi = request.getParameter("rssi");
                temp = request.getParameter("type");
                direct = Double.parseDouble(request.getParameter("dir"));
            }
            type = Integer.parseInt(temp);
            zone = Integer.parseInt(strzone);
            rssi = Double.parseDouble(strRssi);
            out.println("<br>");
            String[] fulltimestart = starttime.split(":");
            System.out.println("fulltime= " + fulltimestart[0]);
            System.out.println("fulltime= " + fulltimestart[1]);
            System.out.println("day= " + strday);
            System.out.println("zone= " + zone);
            System.out.println("rssi= " + rssi);
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
                switch (zone) {
                    case 1://ห้องแลป
                        sql = "SELECT locate1 FROM  room WHERE id_room like '%" + finalroom + "%' ";
                        results = st.executeQuery(sql);
                        while ((results != null) && (results.next())) {
                            locate = Integer.parseInt(results.getString("locate1"));
                        }
                        break;
                    case 2://ทางเดิน
                        sql = "SELECT locate2 FROM  room WHERE id_room like '%" + finalroom + "%' ";
                        results = st.executeQuery(sql);
                        while ((results != null) && (results.next())) {
                            locate = Integer.parseInt(results.getString("locate2"));
                        }
                        break;
                    case 3://ห้องอาจารย์
                        sql = "SELECT locate3 FROM  room WHERE id_room like '%" + finalroom + "%' ";
                        results = st.executeQuery(sql);
                        while ((results != null) && (results.next())) {
                            locate = Integer.parseInt(results.getString("locate3"));
                        }
                        break;
                    default:
                        System.out.println("Can't search");
                }

                System.out.println("locate=" + locate);

                //mark arrow
                int r = 0;
                double x = 0;
                double y = -2;
                double[] array_x = new double[1000];
                double[] array_y = new double[1000];
                double[] array_z = new double[1000];
                double[] a = new double[1000];
                double[] b = new double[1000];
                double[] c = new double[1000];
                double ac, as;
                double inx = 0;
                int cg = 0;

                if (zone == 1) {
                    cg = 4;
                    if (rssi > 75) {
                        rssi = rssi - 75;
                        rssi = rssi / 4;
                        inx = inx + rssi;
                    } else if (rssi < 75) {
                        rssi = rssi - 75;
                        rssi = (rssi / 4) * (-1);
                        inx = inx - rssi;
                    } else {
                        inx = 0;
                    }
                }
                double[] x1 = {0 + inx, -0.25 + inx, -8 + inx, -28 + inx};
                double[] x2 = {0 + inx, -7 + inx, -27 + inx, -29.75 + inx};
                double[] z1 = {0, -16, -43.4, -47.6};
                double[] z2 = {-15, -43, -47.2, -54.6};
                double[] dircng = {0, 18, 80, 18};
                int startdir = 132;
                double diruse;
                int str = 1, i = 0;

                if (zone == 2) {
                    String[] roomleft = {"625", "6181", "619", "6182", "621"};
                    cg = 3;
                    // Convert String Array to List
                    List<String> list = Arrays.asList(roomleft);
                    if (list.contains(finalroom)) {
                        cg = 2;
                        double[] x1t = {0, 1};
                        double[] x2t = {0, 7.5};
                        double[] z1t = {0, -16 + inx};
                        double[] z2t = {-15 + inx, -30 + inx};
                        double[] dircngt = {0, -17};
                        int startdirt = 340;
                        x1 = x1t;
                        x2 = x2t;
                        z1 = z1t;
                        z2 = z2t;
                        dircng = dircngt;
                        startdir = startdirt;
                    } else {
                        double[] x1t = {0, -0.25, -24.25};
                        double[] x2t = {0, -19.25, -24.25};
                        double[] z1t = {0 + inx, -19.2 + inx, -25.2 + inx};
                        double[] z2t = {-19 + inx, -23.2 + inx, -30.2 + inx};
                        double[] dircngt = {0, 60, 0};
                        int startdirt = 160;

                        x1 = x1t;
                        x2 = x2t;
                        z1 = z1t;
                        z2 = z2t;
                        dircng = dircngt;
                        startdir = startdirt;
                    }

                }

                if (zone == 3) {
                    cg = 4;
                    if (rssi > 75) {
                        rssi = rssi - 75;
                        rssi = rssi / 4;
                        //System.out.println("rssis=" + rssi);
                        inx = inx + rssi;
                    } else if (rssi < 75) {
                        rssi = rssi - 75;
                        rssi = (rssi / 4) * (-1);
                        //System.out.println("rssis=" + rssi);
                        inx = inx - rssi;
                    } else {
                        inx = 0;
                    }
                    // System.out.println("inxzone3=" + inx);

                    //บวกแกนx เลื่อนนไปข้างหน้า
                    double[] x1t = {0 + inx, -1 + inx, -15 + inx, -14.75 + inx};
                    double[] x2t = {0 + inx, -15 + inx, -15 + inx, -7.25 + inx};
                    double[] z1t = {0, -4.5, -12.5, -41};
                    double[] z2t = {-4, -11.5, -39, -60};
                    double[] dircngt = {0, 58, 0, -12};
                    int startdirt = 350;

                    x1 = x1t;
                    x2 = x2t;
                    z1 = z1t;
                    z2 = z2t;
                    dircng = dircngt;
                    startdir = startdirt;

                }

                for (int g = 0; g < cg; g++) {
                    diruse = direct;
                    System.out.println("g = " + (g + 1));
                    diruse = direct + startdir + dircng[g];
                    if (diruse >= 360) {
                        diruse = diruse - 360;
                    }
                    System.out.println("drict2 = " + diruse);
                    double angle = diruse;
                    System.out.println("angle = " + angle);

                    double an = Math.toRadians(angle);
                    double ra = Math.sqrt(Math.pow((x1[g] - x2[g]), 2) + Math.pow(z1[g] - z2[g], 2));

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

                    xi = xi + array_x[str - 1];
                    zi = zi + array_z[str - 1];
                    double xn = (xi - array_x[str - 1]) / ra;
                    double zn = (zi - array_z[str - 1]) / ra;
                    System.out.println("xz = " + xi + "," + zi);
                    ra = Math.round(ra);
                    System.out.println("r" + (g + 1) + "=" + ra);
                    array_x[0] = x1[0];
                    array_z[0] = z1[0];
                    array_y[0] = y;
                    if (g == 0) {
                        b[0] = (Math.PI / 180) * (angle);
                        System.out.println("***** b =  " + angle + " B[0] =" + b[0]);
                    }
                    a[0] = 0;
                    c[0] = 0;
                    for (int j = 1; j < ra; j++) {

                        array_x[str] = array_x[str - 1] + xn;
                        array_z[str] = array_z[str - 1] + zn;
                        array_y[str] = y;
                        a[str] = 0;
                        b[str] = (Math.PI / 180) * (angle);
                        c[str] = 0;
                        /*System.out.print(j + 1 + " | ");
                        System.out.print(array_x[str]);
                        System.out.print(" == ");
                        System.out.print(array_z[str]);
                        System.out.print("\n");*/
                        str++;
                        i++;
                    }

                    System.out.println(i);
                    array_x[0] = x1[0];
                    array_z[0] = z1[0];

                }
                switch (zone) {

                    case 1:
                        String s1 = "1111";
                        if (finalroom.equals(s1)) {
                            locate = i;
                        } else if (locate == 0) {
                            array_x[0] = 0;
                            array_y[0] = -1;
                            array_z[0] = -1;
                            locate = 1;
                        }
                        break;
                    case 2:
                        String s2 = "1111";
                        String s22 = "625";
                        if (finalroom.equals(s2) || finalroom.equals(s22)) {
                            locate = i;
                        } else if (locate == 0) {
                            array_x[0] = 0;
                            array_y[0] = -1;
                            array_z[0] = -1;
                            locate = 1;
                        }
                        break;
                    case 3:
                        String s3 = "625";
                        if (finalroom.equals(s3)) {
                            locate = i;
                        } else if (locate == 0) {
                            array_x[0] = 0;
                            array_y[0] = -1;
                            array_z[0] = -1;
                            locate = 1;
                        }
                        break;
                }
        %>
        <%            System.out.println("total node=" + locate);

            int k = 0;
            JSONArray jArray = new JSONArray();
            while (k < locate) {
                JSONObject arrayObj = new JSONObject();
                if (k + 1 == locate) {
                    arrayObj.put("r", finalroom);
                } else if (locate == 1) {
                    arrayObj.put("r", "0000");
                } else {
                    arrayObj.put("r", "0");
                }

                arrayObj.put("x", array_x[k]);
                arrayObj.put("y", array_y[k]);
                arrayObj.put("z", array_z[k]);
                arrayObj.put("a", a[k]);
                arrayObj.put("b", b[k]);
                arrayObj.put("c", c[k]);
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
