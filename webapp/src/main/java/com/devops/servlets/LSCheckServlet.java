package com.devops.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.devops.DAO.DBClass;

@SuppressWarnings("serial")
public class LSCheckServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// TODO Auto-generated method stub
		int ret_status=new DBClass().lsCheck(Integer.parseInt(request.getParameter("id")));
		PrintWriter out=response.getWriter();
		out.println(ret_status);
		out.close();
	}

}
