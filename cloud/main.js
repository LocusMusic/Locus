// iOS push testing
Parse.Cloud.define("iosPushTest", function(request, response) {
  // request has 2 parameters: params passed by the client and the authorized user                                                                                                                               
  var params = request.params;
  var user = request.user;
  // Our "Message" class has a "text" key with the body of the message itself                                                                                                                                    
  var messageText = params.text;

  var recipientUser = new Parse.User();
  recipientUser.username = "a7AjS6npIV5ZrPlc3zPkdhKRM"
  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo("user", recipientUser);
  

//   userQuery.find({
//     success: function(users) {
//       response.success(users[0]);
//     },
//     error: function(error) {
//     response.success(error);
//       console.error("Error finding related comments " + error.code + ": " + error.message);
//     }
//   }); 
   
	 Parse.Push.send({
		where: pushQuery, // Set our Installation query                                                                                                                                                              
		data: {
		  alert: "Message: " + messageText
		}
	  }, { success: function() {
		  console.log("#### PUSH OK");
		 response.success('success');
	  }, error: function(error) {
		  console.log("#### PUSH ERROR" + error.message);
	  }, useMasterKey: true});
});