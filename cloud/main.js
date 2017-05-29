// send push notification after song playing by other users
Parse.Cloud.define("sendNotificaionAfterSongPlayedByOthers", function(request, response) {
  // request has 2 parameters: params passed by the client and the authorized user                                                                                                                               
  var params = request.params;
  var user = request.user;

  var subscriberDisplayName = params.subscriberDisplayName;  
  var subscriberUsername = params.subscriberUsername;                                                                                                                       
  var receiverUsername = params.receiverUsername;  
  var playlistPostId = params.playlistPostId; 
  var spotName = params.spotName;
  var playlistName = params.playlistName;
  
  var alertMessage = subscriberDisplayName + " is playing your playlist: " + playlistName +  " at " + spotName;
    var pushQuery = new Parse.Query(Parse.Installation);

	var userQuery = new Parse.Query(Parse.User);
	userQuery.equalTo("username", receiverUsername);
	pushQuery.matchesQuery("user", userQuery);
   
   console.log("The push query is the following: ");
   console.log(pushQuery);
	  Parse.Push.send({
		where: pushQuery, // Set our Installation query                                                                                                                                                              
		data: {
		  alert: alertMessage,
		  data: {
		  		subscriberUsername: subscriberUsername,
		  		playlistPostId: playlistPostId
		  },
		  badge: "Increment",
      	  sound: 'default'
		}
	  }, { success: function() {
		  console.log("#### PUSH OK");
		  response.success('success');
	  }, error: function(error) {
		  console.log("#### PUSH ERROR" + error.message);
	  }, useMasterKey: true});
});
