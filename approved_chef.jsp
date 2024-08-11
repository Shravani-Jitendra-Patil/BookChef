<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import ="com.r3sys.db.*" %>
<!DOCTYPE html>
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
        .btn-approve, .btn-disapprove {
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            color: #fff;
        }
        .btn-approve {
            background-color: #28a745;
        }
        .btn-approve:hover {
            background-color: #218838;
        }
        .btn-disapprove {
            background-color: #dc3545;
        }
        .btn-disapprove:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
	<% 
	try 
	{
		String cid=request.getParameter("cid");
		Connection con = ConnectDB.dbCon();
        PreparedStatement ps = con.prepareStatement("update chef set cstatus=? where cid=?");
        ps.setString(1, "Approved");
        ps.setInt(2,Integer.parseInt(cid));	
        int i=ps.executeUpdate();
        if(i>0)
        {	out.println("<script>alert('Approved successfully.');</script>");
        	response.sendRedirect("view_pending_chef.jsp");
        }
        else
        {	
        	response.sendRedirect("error.html");
        }
        }
	catch(Exception ex)
	{
		ex.printStackTrace();
	}
	%>
    <header class="header">
        <button class="btn btn-primary menu-icon" onclick="toggleMenu()">Menu</button>
        <div class="company-name">BookChef</div>
    </header>
    <nav class="menu">
        <ul>
            <li><a href="view_pending_chef.jsp">View Pending Chef</a></li>
            <li><a href="view_approved_chef.jsp">View Approved Chef</a></li>
            <li><a href="view_disapproved_chef.jsp">View Disapproved Chef</a></li>
            <li><a href="view_users_chef.jsp">View Users Chef</a></li>
        </ul>
    </nav>
    <main class="main-content">
        <div class="table-container">
            <h2>Pending Chefs</h2>
            <table>
                <thead>
                    <tr>
                        <th>Sr.No.</th>
                        <th>Chef Id</th>
                        <th>Name</th>
                        <th>Speciality</th>
                        <th>City</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        try {
                            Connection con = ConnectDB.dbCon();
                            PreparedStatement ps = con.prepareStatement("select * from chef where cstatus='pending'");
                            ResultSet rs = ps.executeQuery();
                            int srNo = 1;
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= srNo++ %></td>
                        <td><%= rs.getString("cid") %></td>
                        <td><%= rs.getString("cname") %></td>
                        <td><%= rs.getString("cspeciality") %></td>
                        <td><%= rs.getString("ccity") %></td>
                        <td><%= rs.getString("cemail") %></td>
                        <td>
                            <!-- Hyperlink for Approve -->
                            <a href="approved_chef.jsp?cid=<%= rs.getInt("cid") %>" button class="btn btn-approve">Approve</a>
                            <!-- Disapprove button can have functionality if needed -->
                           <a href="disapproved_chef.jsp?cid=<%= rs.getInt("cid") %>"   button class="btn btn-disapprove">Disapprove</button>
                        </td>
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
            if (menu.style.left === '0px' || menu.style.left === '') {
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
