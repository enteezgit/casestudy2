package com.devops.DAO;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

import com.devops.BO.Employee;


public class DBClass {
	
	Connection conn = null;
	Statement stmt = null;
	String dbHost,dbPort,dbName,dbUser,dbPasswd;
	
	public DBClass(){
		
    	Properties prop = new Properties();
		InputStream input = null;
		try {
		      input = getClass().getClassLoader().getResourceAsStream("config.properties");
		      prop.load(input);
		      dbHost=prop.getProperty("dbhost");
		      dbPort=prop.getProperty("dbport");
		      dbName=prop.getProperty("dbname");
		      dbUser=prop.getProperty("dbuser");
		      dbPasswd=prop.getProperty("dbpasswd");
		      
		} catch (IOException ex) {
		    ex.printStackTrace();
		} finally {
		    if (input != null) {
		        try {
		            input.close();
		        } catch (IOException e) {
		            e.printStackTrace();
		        }
		    }
		}
		
		try {
        	Class.forName("com.mysql.jdbc.Driver");
    		//conn = DriverManager.getConnection("jdbc:mysql://10.244.54.78:3306/devopsdb", "root", "Pspl@123");
    		conn = DriverManager.getConnection("jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName, dbUser, dbPasswd);

			stmt = conn.createStatement();
        }catch(SQLException se){
			   se.printStackTrace();
	    }catch(Exception e){
		   e.printStackTrace();
	    }
	}
	
	public Employee[] getLateStayList(){
		   
		   Employee[] emp_list=null;
		   try{
			  
			  String sql = "SELECT l.emp_id as id,l.emp_location as location,e.emp_name as name FROM LATE_STAY_LIST as l,EMPLOYEE_LIST as e WHERE l.emp_id=e.emp_id";
			  ResultSet rs=stmt.executeQuery(sql);
			  
			  rs.last();
			  int row_count=rs.getRow();
			  rs.beforeFirst();
			  emp_list=new Employee[row_count];
			  int i=0;
			  while (rs.next()) {
				  emp_list[i]=new Employee();
				  emp_list[i].setEmp_id(rs.getInt("id"));
				  emp_list[i].setEmp_location(rs.getString("location"));
				  emp_list[i].setEmp_passwd(null);
				  emp_list[i++].setEmp_name(rs.getString("name"));
			  }
		   }catch(SQLException se){
			   se.printStackTrace();
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			  try{
				 if(stmt!=null)
					conn.close();
			  }catch(SQLException se){
				se.printStackTrace();
			  }
		   }
		   return emp_list;
	}
	public int register(Employee emp) {
		// TODO Auto-generated method stub
		   int ret_status=0;
		   try{
			  String sql = "SELECT * from EMPLOYEE_LIST where emp_id="+emp.getEmp_id();
			  ResultSet rs=stmt.executeQuery(sql);
			  if(!rs.first()){
				  sql = "INSERT into EMPLOYEE_LIST (EMP_ID,EMP_NAME,EMP_PASSWD) values (?,?,?)";
				  PreparedStatement ps = conn.prepareStatement(sql);
				  ps.setInt(1, emp.getEmp_id());
				  ps.setString(2,emp.getEmp_name());
				  ps.setString(3,emp.getEmp_passwd());
				  int rows=ps.executeUpdate();
				  if(rows>0){
					  ret_status=1;
				  }
			  }
		   }catch(SQLException se){
			   se.printStackTrace();
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			  try{
				 if(stmt!=null)
					conn.close();
			  }catch(SQLException se){
				se.printStackTrace();
			  }
		   }
		return ret_status;
	}
	public int authenticate(Integer id, String passwd) {
		// TODO Auto-generated method stub
		   int ret_status=0;
		   try{
			  String sql = "SELECT * from EMPLOYEE_LIST where emp_id="+id+" and emp_passwd='"+passwd+"'";
			  ResultSet rs=stmt.executeQuery(sql);
			  if(rs.first()){
					  ret_status=1;
			  }
		   }catch(SQLException se){
			   se.printStackTrace();
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			  try{
				 if(stmt!=null)
					conn.close();
			  }catch(SQLException se){
				se.printStackTrace();
			  }
		   }
		return ret_status;
	}
	public int lsCheck(Integer id) {
		// TODO Auto-generated method stub
		   int ret_status=0;
		   try{
			  String sql = "SELECT * from LATE_STAY_LIST where emp_id="+id;
			  ResultSet rs=stmt.executeQuery(sql);
			  if(rs.first()){
					  ret_status=1;
			  }
		   }catch(SQLException se){
			   se.printStackTrace();
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			  try{
				 if(stmt!=null)
					conn.close();
			  }catch(SQLException se){
				se.printStackTrace();
			  }
		   }
		return ret_status;
	}

	public void updateLateStay(Integer id, String location, String action) {
		// TODO Auto-generated method stub
		try{
			  String sql="";
			  if(action.equalsIgnoreCase("apply")){
				  sql = "INSERT into LATE_STAY_LIST (EMP_LOCATION,EMP_ID) values (?,?)";
			  }else if(action.equalsIgnoreCase("update")){
				  sql = "UPDATE LATE_STAY_LIST set EMP_LOCATION = ? where EMP_ID = ?";
			  }
			  PreparedStatement ps=conn.prepareStatement(sql);
			  ps.setString(1,location);
			  ps.setInt(2,id);
			  ps.executeUpdate();

		   }catch(SQLException se){
			   se.printStackTrace();
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			  try{
				 if(stmt!=null)
					conn.close();
			  }catch(SQLException se){
				se.printStackTrace();
			  }
		   }
	}
public void closeConnection() {
		// TODO Auto-generated method stub
		try{
			if(stmt!=null)
				conn.close();
		   }catch(Exception e){
			   e.printStackTrace();
		   }
	}


	public void deleteLateStay(Integer id) {
		// TODO Auto-generated method stub
		try{
			  String sql="DELETE FROM LATE_STAY_LIST where EMP_ID = ?";
			  PreparedStatement ps=conn.prepareStatement(sql);
			  ps.setInt(1,id);
			  ps.executeUpdate();

		   }catch(SQLException se){
			   se.printStackTrace();
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			  try{
				 if(stmt!=null)
					conn.close();
			  }catch(SQLException se){
				se.printStackTrace();
			  }
		   }
	}
	
}
