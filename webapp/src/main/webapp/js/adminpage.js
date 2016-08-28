$(document).ready(function(){
	$("#list").hide();
	$("#reg_emp_form").hide();
	
	$("#late_stay_list").click(function(e){
		e.preventDefault();
		$("#msg").html("");
		$.post("../EmpListServlet", {}, function(result){
			$("#list").show();
			$("#reg_emp_form").hide();
	        $("#list").html(result);
	    });
	});
	$("#reg_emp").click(function(e){
		e.preventDefault();
		$("#msg").html("");
		$("#list").hide();
		$("#reg_emp_form").show();
	});
	
	$("#reg_emp_form").submit(function(e){
		e.preventDefault();
		var name=$("#name").val();
		var passwd=$("#passwd").val();
		var id=$("#id").val();
		$.post("../RegEmpServlet", {'name':name,'passwd':passwd,'id':id}, function(result){
			if(result == 1){
				$("#list").hide();
				$("#reg_emp_form").hide();
		        $("#msg").html("Employee Successfully Registered");
			}else{
				$("#msg").html("Employee ID already registered");
			}
	    });
	});
	
	$("#logout").click(function(e){
		window.location.href="homepage.html";
		
	});
});
