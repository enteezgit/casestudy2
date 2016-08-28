$(document).ready(function(){
	$("#msg").html("");
	$("#login").submit(function(e){
		e.preventDefault();
		var id=$("#id").val();
		var passwd=$("#passwd").val();
		
		if(id == "1" && passwd == "admin"){
			window.location.href="adminpage.html";
		}else{
			$.post("../LoginServlet", {'id':id,'passwd':passwd}, function(result){
				if(result == 1){
					sessionStorage.setItem('id',id);
					window.location.href="emppage.html";
				}else{
					$("#msg").html("Wrong credentials");
				}
		    });
		}
		
	});
	
});
