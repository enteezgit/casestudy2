$(document).ready(function(){
	$("#location").hide();
	$("#delete_late_stay").hide();
	id=sessionStorage.getItem('id');	
	
	$("#late_stay").hide();
	$.post("../LSCheckServlet", {'id':id}, function(result){
		if(result==1){
			$("#update_late_stay").show();
			$("#apply_late_stay").hide();
		}else{
			$("#apply_late_stay").show();
			$("#update_late_stay").hide();
		}
    });
	
	
	$("#update_late_stay").click(function(e){
		e.preventDefault();
		$("#msg").html("");
		$("#location").show();
		$("#late_stay").html("Update");
		$("#late_stay").show();
		$("#delete_late_stay").show();
		
		$("#late_stay").click(function(e){
			var val=$("#location").val();
			$.post("../LateStayServlet", {'id':id,'location':val,'action':'update'}, function(result){
				$("#msg").html("Updated successfully");
				$("#location").hide();
				$("#late_stay").hide();
				$("#delete_late_stay").hide();
		    });
		});
		$("#delete_late_stay").click(function(){
			$.post("../LSDeleteServlet", {'id':id}, function(result){
				$("#msg").html("Deleted successfully");
				$("#location").hide();
				$("#late_stay").hide();
				$("#delete_late_stay").hide();
				$("#apply_late_stay").show();
				$("#update_late_stay").hide();
		    });
		});
	});
	
	$("#apply_late_stay").click(function(e){
		e.preventDefault();
		$("#msg").html("");
		$("#location").show();
		$("#late_stay").html("Apply");
		$("#late_stay").show();
		$("#late_stay").click(function(e){
			var val=$("#location").val();
			$.post("../LateStayServlet", {'id':id,'location':val,'action':'apply'}, function(result){
				$("#msg").html("Applied successfully");
				$("#location").hide();
				$("#late_stay").hide();
				$("#update_late_stay").show();
				$("#apply_late_stay").hide();
		    });
		});
	});
	
	$("#logout").click(function(e){
		sessionStorage.removeItem('id');
		window.location.href="homepage.html";
		
	});
});
