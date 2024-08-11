<%@page import="com.r3sys.services.GetterSetter"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import ="com.r3sys.db.*" %>
<!DOCTYPE html>
<html lang="en">
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
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: auto; /* Ensure content can scroll if needed */
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
            margin-right: 20px;
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
        .table-container {
            margin-top: 20px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
        }
        .btn-approve {
            background-color: #28a745;
            color: #fff;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 5px; /* Add margin-right for spacing */
        }
        .btn-approve:hover {
            background-color: #218838;
        }
        .btn-disapprove {
            background-color: #dc3545;
            color: #fff;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-left: 5px; /* Add margin-left for spacing */
        }
        .btn-disapprove:hover {
            background-color: #c82333;
        }
        .search-form {
            margin-bottom: 20px;
            display: flex;
            justify-content: flex-end;
        }
        .search-form input[type="date"] {
            padding: 5px;
            border-radius: 4px;
            border: 1px solid #ccc;
            margin-right: 10px;
        }
        .search-form button {
            padding: 5px 10px;
            border-radius: 4px;
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .search-form button:hover {
            background-color: #0056b3;
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
            <li><a href="add_portfolio.html">Add Portfolio</a></li>
            <li><a href="view_pending_bookings.jsp">View Pending Bookings</a></li>
            <li><a href="view_todays_bookings.jsp">View Today's Bookings</a></li>
            <li><a href="view_bookings_by_date.jsp">View Bookings by Date</a></li>
            <li><a href="view_approved_bookings.jsp">View Approved Bookings</a></li>
            <li><a href="view_disapproved_bookings.jsp">View Disapproved Bookings</a></li>
            <li><a href="chef_change_password.html">Change Password</a></li>
        </ul>
    </nav>
    <main class="main-content">
        <div class="table-container">
            <h2>Search Bookings by Date</h2>
            <div class="search-form">
                <form action="view_bookings_by_date.jsp">
                    <input type="date" name="bookingDate" required>
                    <button type="submit">Search</button>
                </form>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Sr. No.</th>
                        <th>Booking Id</th>
                        <th>User Id</th>
                        <th>Booking Date</th>
                        <th>Booking Time</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    try {
                        int cid = GetterSetter.getCid(); // Assuming GetterSetter has a method to retrieve cid as int
                        String bookingDateParam = request.getParameter("bookingDate");
                        LocalDate searchDate = LocalDate.parse(bookingDateParam);
						System.out.println(searchDate);
						System.out.println(cid);
                       
                    
                        Connection con = ConnectDB.dbCon();
                        PreparedStatement ps = con.prepareStatement("SELECT * FROM bookings WHERE cid=? and bookingDate = ?");
                        
                        // Set cid as parameter
                        ps.setInt(1, cid); 
                        
                        // Set search date as parameter
                        ps.setString(2, searchDate.toString()); 

                        ResultSet rs = ps.executeQuery();
                        int srNo = 1;
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= srNo++ %></td>
                        <td><%= rs.getString("bid") %></td>
                        <td><%= rs.getString("uid") %></td>
                        <td><%= rs.getString("bookingDate") %></td>
                        <td><%= rs.getString("bookingTime") %></td>
                    </tr>
                    <% 
                        }
                    
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    %>
                </tbody>
            </table>
        </div>
    </main>
    <footer class="footer">
        <a href="index.html" class="logout-btn">Logout</a>
        <div>
            Made with love | Shravani Patil &copy; 2024
        </div>
    </footer>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script>
        function toggleMenu() {
            let menu = document.querySelector('.menu');
            let mainContent = document.querySelector('.main-content');
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
