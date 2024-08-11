<%@page import="com.r3sys.services.GetterSetter"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@page import ="com.r3sys.db.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookChef</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }
        .header {
            background-color: #333;
            color: #fff;
            padding: 20px;
            text-align: right;
            position: relative;
            z-index: 3;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header a {
            color: #fff;
            text-decoration: none;
        }
        .header a:hover {
            color: #ccc;
        }
        .menu-icon {
            cursor: pointer;
            float: left;
            margin-right: 10px;
        }
        .company-name {
            font-size: 1.5rem;
            margin-left: 20px;
        }
        .menu {
            background-color: #444;
            padding: 20px;
            width: 250px;
            position: fixed;
            top: 0;
            left: -250px;
            height: 100vh;
            overflow-y: auto;
            transition: left 0.3s ease-in-out;
            z-index: 1;
        }
        .menu ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .menu li {
            margin-bottom: 10px;
            width: 100%;
        }
        .menu li:first-child a {
            margin-top: 70px;
        }
        .menu a {
            display: block;
            padding: 10px 20px;
            color: #fff;
            text-decoration: none;
            background-color: #555;
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        .menu a:hover {
            background-color: #666;
        }
        .menu a.active {
            background-color: #007bff;
        }
        .main-content {
            flex: 1;
            padding: 20px;
            transition: margin-left 0.3s ease-in-out;
            z-index: 2;
            background-color: rgb(112, 112, 112);
            color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .main-content.menu-open {
            margin-left: 250px;
        }
        .footer {
            background-color: #333;
            color: #fff;
            padding: 10px;
            text-align: center;
            width: 100%;
            margin-top: auto;
            position: relative;
            z-index: 3;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .footer .logout-btn {
            margin-left: 20px;
            color: #fff;
            text-decoration: none;
            padding: 5px 10px;
            background-color: #dc3545;
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        .footer .logout-btn:hover {
            background-color: #c82333;
        }
        .form-container {
            background-color: #fff;
            color: #000;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .btn-back {
            background-color: #6c757d;
            color: #fff;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s ease;
            display: inline-block;
            margin-top: 10px;
        }
        .btn-back:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
<header class="header">
        <button class="btn btn-primary menu-icon" onclick="toggleMenu()">Menu</button>
        <div class="company-name">BookChef</div>
    </header>
    <nav class="menu">
        <ul>
            <li><a href="view_all_chefs.jsp">View All Chefs</a></li>
            <li><a href="search_by_chef_speciality.jsp">Search by Chef Speciality</a></li>
            <li><a href="view_bookings_status.jsp">View Bookings Status</a></li>
            <li><a href="users_change_password.html">Change Password</a></li>
        </ul>
    </nav>
    <main class="main-content">
        <div class="form-container">
            <h2>Booking Form</h2>
            <%
    try {
        String cid = request.getParameter("cid");
        String uidParam = request.getParameter("uid");
        String uemail = request.getParameter("uemail");

        int uid = Integer.parseInt(uidParam);
        String bookingDetails = request.getParameter("bookingDetails");
        String bookingDate = request.getParameter("bookingDate");
        String bookingTimeParam = request.getParameter("bookingTime");
        
        // Convert bookingTime to java.sql.Time
        java.sql.Time bookingTime = java.sql.Time.valueOf(bookingTimeParam + ":00");

        Connection con = ConnectDB.dbCon();
        String query = "INSERT INTO bookings (cid, uid, bookingDetails, bookingDate, bookingTime, bstatus, uemail) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(query);
        pstmt.setString(1, cid);
        pstmt.setInt(2, uid);
        pstmt.setString(3, bookingDetails);
        pstmt.setString(4, bookingDate);
        pstmt.setTime(5, bookingTime); // Use the converted time
        pstmt.setString(6, "Pending");
        pstmt.setString(7, uemail);
        int rowsAffected = pstmt.executeUpdate();
        if (rowsAffected > 0) {
            GetterSetter.setUid(uid);
            GetterSetter.setUemail(uemail);  // Set the email in GetterSetter
            response.sendRedirect("search_by_chef_speciality.jsp"); 
        } else {
            response.sendRedirect("error.html");
        }
    } catch (NumberFormatException e) {
        out.println("<div class='alert alert-danger'>Invalid User ID: " + e.getMessage() + "</div>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    }
%>
            
            <form action="book.jsp" method="post">
                <div class="form-group">
                    <label for="cid">Chef ID</label>
                    <input type="text" class="form-control" id="cid" name="cid" value="<%= request.getParameter("cid") %>" readonly>
                </div>
                <div class="form-group">
                    <label for="uid">User ID</label>
                    <input type="text" class="form-control" id="uid" name="uid" placeholder="Enter User ID" required>
                </div>
                <div class="form-group">
                    <label for="bookingDetails">Booking Details</label>
                    <input type="text" class="form-control" id="bookingDetails" name="bookingDetails" placeholder="Enter Booking Details" required>
                </div>
                <div class="form-group">
                    <label for="bookingDate">Booking Date</label>
                    <input type="date" class="form-control" id="bookingDate" name="bookingDate" required>
                </div>
                <div class="form-group">
                    <label for="bookingTime">Booking Time</label>
                    <input type="time" class="form-control" id="bookingTime" name="bookingTime" required>
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
                <a href="search_by_chef_speciality.jsp" class="btn-back">Go Back</a>
            </form>
        </div>
    </main>
    <footer class="footer">
        <a href="index.html" class="logout-btn">Logout</a>
        <div>
            Made with love | Shravani Patil &copy; 2024 BookChef
        </div>
    </footer>

    <script>
        function toggleMenu() {
            var menu = document.querySelector('.menu');
            var mainContent = document.querySelector('.main-content');
            if (menu.style.left === '0px') {
                menu.style.left = '-250px';
                mainContent.classList.remove('menu-open');
            } else {
                menu.style.left = '0px';
                mainContent.classList.add('menu-open');
            }
        }
    </script>
</body>
</html>