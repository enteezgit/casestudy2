package com.devops.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.devops.DAO.DBClass;


@SuppressWarnings("serial")
public class LSDeleteServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
			
		new DBClass().deleteLateStay(Integer.parseInt(request.getParameter("id")));
	}

}
