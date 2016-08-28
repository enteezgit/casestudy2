package com.devops.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.devops.BO.Employee;
import com.devops.DAO.DBClass;

@SuppressWarnings("serial")
public class EmpListServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		Employee[] emp_list=new DBClass().getLateStayList();
		PrintWriter out = response.getWriter();
		String str="<tr><th>Employee ID</th><th>Employee Name</th><th>Drop Point</th></tr>";
		if(emp_list!=null){
			for(int i=0;i<emp_list.length;i++)
				str+="<tr><td>"+emp_list[i].getEmp_id()+"</td><td>"+emp_list[i].getEmp_name()+"</td><td>"+emp_list[i].getEmp_location()+"</td></tr>";	
		}
		out.println(str);
		out.close();
	}

}
