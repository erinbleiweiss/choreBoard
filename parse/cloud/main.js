// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("addGroup", function(request, response){

	var Group = Parse.Object.extend("Group");
	var newGroup = new Group();

	var groupName = request.params.groupName;
	newGroup.set("groupName", groupName);
	newGroup.save(null, {
			success: function(newGroup){
				var currentUser = Parse.User.current();
				currentUser.set("group", newGroup);
				currentUser.save();
				response.success();
			},
			error: function(error){
				response.error(error)
			}
	});

});

Parse.Cloud.define("addChore", function(request, response){

	var ChoreClass = Parse.Object.extend("Chore");
	var chore = new ChoreClass();

	var currentUser = Parse.User.current();
	currentUser.fetch({
	  success: function(currentUser) {
	  	var groupObj = currentUser.get("group");
	    chore.set("group", groupObj);
	  	chore.save(null, {
	  		success: function(chore){
	  			var choreName = request.params.choreName;
	  			chore.set("choreName", choreName);
	  			chore.set("completed", false);
	  			chore.save(null, {
	  				success: function(chore){
	  					response.success(chore);
	  				},
	  				error: function(error){
	  					response.error(error);
	  				}
	  			});
	  		},
	  		error: function(error){
	  			response.error(error)
	  		}

	  	});
	  }
	});


});


Parse.Cloud.define("getCurrentGroupOld", function(request, response){

	var currentUser = Parse.User.current();
	currentUser.fetch({
		success: function(currentUser){
			var currentGroup = currentUser.get("group");	
			response.success(currentGroup);
		},
		error: function(error) {
			response.error(error);
		}

	});

});

Parse.Cloud.define("getCurrentGroup", function(request, response){

	var currentUser = Parse.User.current();
	currentUser.fetch({
		success: function(currentUser){
			var currentGroup = currentUser.get("group");	
			var Group = Parse.Object.extend("Group");
	    var query = new Parse.Query(Group);
	    query.equalTo("objectId", currentGroup.id);
	    query.find({
	      success: function(queryGroup) {
	        var theObject = queryGroup[0];
	        response.success(theObject);
	      }
	    });
		},
		error: function(error) {
			response.error(error);
		}

	});

});


Parse.Cloud.define("getMyGroupId", function(request, response){

	var currentUser = Parse.User.current();
	var groupPointer = currentUser.get("group");
	var Group = Parse.Object.extend("Group");
  var query = new Parse.Query(Group);
  query.equalTo("objectId", groupPointer.id);
  query.find({
  	success: function(queryGroup){
  		var currentGroup = queryGroup[0];
  		response.success(currentGroup.id);
  	},
  	error: function(error){
  		response.error(error);
  	}
  });


});




Parse.Cloud.define("getCurrentGroupName", function(request, response){

	var currentUser = Parse.User.current();
	currentUser.fetch({
		success: function(currentUser){
			var currentGroup = currentUser.get("group");
			if (currentGroup != null) {
			var Group = Parse.Object.extend("Group");
	    var query = new Parse.Query(Group);
	    query.equalTo("objectId", currentGroup.id);
	    query.find({
	      success: function(queryGroup) {
	        var theObject = queryGroup[0];
	        response.success(theObject.get("groupName"));
	      },
	      error: function(error){
	      	response.error(error);
	      }
	    }); }
	    else{
	    	currentUser.save({
	    		success: function(){
	    			response.success(null);
	    		},
	    		error: function(error){
	    			response.error(error);
	    		}
	    	});
	    }
		},
		error: function(error) {
			response.error(error);
		}

	});

});


Parse.Cloud.define("getUserInfo", function(request, response){

	var currentUser = Parse.User.current();
	var firstName = currentUser.get("firstName");
	var lastName = currentUser.get("lastName");
	var username = currentUser.get("username");
	var groupPointer = currentUser.get("group");

	var Group = Parse.Object.extend("Group");
	var query = new Parse.Query(Group);
	query.equalTo("objectId", groupPointer.id);
	query.find({
		success: function(result){
			var groupObj = result[0];
			var groupName = groupObj.get("groupName");
			response.success({"firstName" : firstName,
											"lastName" : lastName,
											"username" : username,
											"groupName" : groupName}
				);
		},
		error: function(error){
			response.error(error);
		}

	});


});

Parse.Cloud.define("fillFBInfo", function (request, response){

	Parse.Cloud.useMasterKey();

	var user = Parse.User.current();
	var authData = user.get("authData");
	var facebookInfo = authData.facebook;
	var fbtoken = facebookInfo.access_token;
	var facebookId = facebookInfo.id;

	console.log("FB User Id: " + facebookId);

	var infoURL = "https://graph.facebook.com/v2.3/me?fields=first_name,last_name,gender&access_token=" + fbtoken;

	Parse.Cloud.httpRequest({
	       url: infoURL,
	       method: "GET"
	   }).then(function(response){

	       var responseData = response.data;
	       user.set("firstName", responseData.first_name);
	       user.set("lastName", responseData.last_name);
	       user.set("gender", responseData.gender);
	       user.set("facebookId", facebookInfo.id);
	       user.save();

	       response.success();
	   },function(error){
	       response.error(error);
	   });


});


Parse.Cloud.define("getGroupChores", function (request, response){

	var user = Parse.User.current()
	var groupPointer = user.get("group");

	var Chore = Parse.Object.extend("Chore");
	var query = new Parse.Query(Chore);
	query.equalTo("group", groupPointer)
	query.find({
		success: function(allChores){
			for (var i=0; i < allChores.length; i++){
				console.log(allChores[i])
			}
			response.success(allChores);
		},
		error: function(error){
			response.error(error);
		}
	});


});



Parse.Cloud.define("getFriends", function (request, response){

	Parse.Cloud.useMasterKey();

	var user = Parse.User.current();
	var authData = user.get("authData");
	var facebookInfo = authData.facebook;
	var fbtoken = facebookInfo.access_token;
	var facebookId = facebookInfo.id;

	console.log("access token: ");
	console.log(fbtoken);

	console.log("FB User Id: " + facebookId);

	var infoURL = "https://graph.facebook.com/v2.3/me?fields=friends.fields(name)&access_token=" + fbtoken;

	Parse.Cloud.httpRequest({
	       url: infoURL,
	       success: function(httpResponse){
	       	var responseData = httpResponse.data;
	       	console.log("getFriends response: ");
	       	response.success(responseData.friends.data);
	       },
	       error: function(error){
	       	response.error(error);
	       }
	 });

});



Parse.Cloud.define("groupNameFromFBID", function(request, response){

	var fbId = request.params.fbId;

	var User = Parse.Object.extend("_User");
	var query = new Parse.Query(User);
	query.equalTo("facebookId", fbId);
	query.find({
		success: function(queryUser){
			var theUser = queryUser[0];
			var groupPointer = theUser.get("group");
			if (groupPointer != null)
			{
				var Group = Parse.Object.extend("Group");
				var innerquery = new Parse.Query(Group);
				innerquery.equalTo("objectId", groupPointer.id);
				innerquery.find({
					success: function(queryGroup){
						var theGroup = queryGroup[0];
						response.success(theGroup.get("groupName"));
					},
					error: function(error){
						response.error(error);
					}
				});

			}
			else{
				console.log("not in a group");
				response.success(null);
			}


			
		},
		error: function(error){
			response.error(error);
		}

	});


});



Parse.Cloud.define("addUserToMyGroup", function(request, response){

	Parse.Cloud.useMasterKey()

	var currentUser = Parse.User.current();
	var currentGroup = currentUser.get("group");	

	var userId = request.params.userId;

	var User = Parse.Object.extend("_User");
	var query = new Parse.Query(User);
	query.equalTo("objectId", userId);
	query.find({
		success: function(queryUser){
			var theUser = queryUser[0];

			theUser.set("group", currentGroup);
			theUser.save();

			response.success();
		},
		error: function(error){
			response.error(error);
		}

	});


});



Parse.Cloud.define("joinRoommatesGroup", function(request, response){

	var fbId = request.params.fbId;
	var currentUser = Parse.User.current();

	var User = Parse.Object.extend("_User");
	var query = new Parse.Query(User);
	query.equalTo("facebookId", fbId);
	query.find({
		success: function(queryUser){
			var theUser = queryUser[0];

			var roommateGroup = theUser.get("group");
			currentUser.set("group", roommateGroup);
			currentUser.save();

			response.success();
		},
		error: function(error){
			response.error(error);
		}

	});


});



Parse.Cloud.define("joinGroupRequest", function(request, response){

	Parse.Cloud.useMasterKey()
	var currentUser = Parse.User.current();
	var firstName = currentUser.get("firstName");
	var lastName = currentUser.get("lastName");

	var fbId = request.params.fbId;

	var User = Parse.Object.extend("_User");
	var query = new Parse.Query(User);
	query.equalTo("facebookId", fbId);
	query.find({
		success: function(queryUser){
			var theUser = queryUser[0];
			var roommateGroup = theUser.get("group");

			var JoinGroupRequest = Parse.Object.extend("JoinGroupRequest");
			var newRequest = new JoinGroupRequest();

			newRequest.set("fromUser", currentUser);
			newRequest.set("fromUserName", (firstName + " " + lastName));
			newRequest.set("toGroup", roommateGroup);
			newRequest.set("status", "pending");

			newRequest.save();

			var pushChannel = "CH_" + roommateGroup.id;
			Parse.Push.send({
				channels: [pushChannel],
				data: {
					alert: "New group request from " + firstName + " " + lastName
				}
			}, {
				success: function(){
					console.log("Push sent!");
					response.success();
				},
				error: function(error){
					response.error(error)
				}
			});

		},
		error: function(error){
			response.error(error);
		}
	});
});

Parse.Cloud.define("addToGroupRequest", function(request, response){

	Parse.Cloud.useMasterKey()
	var currentUser = Parse.User.current();

	var fbId = request.params.fbId;

	var User = Parse.Object.extend("_User");
	var query = new Parse.Query(User);
	query.equalTo("facebookId", fbId);
	query.find({
		success: function(queryUser){
			var theUser = queryUser[0];

			var AddToGroupRequest = Parse.Object.extend("AddToGroupRequest");
			var newRequest = new AddToGroupRequest();

			newRequest.set("fromUser", currentUser);
			newRequest.set("toUser", theUser);
			newRequest.set("status", "pending");

			newRequest.save();

			response.success();

		},
		error: function(error){
			response.error(error);
		}
	});
});


Parse.Cloud.define("getPendingRequests", function(request, response){

	var currentUser = Parse.User.current();
	var groupPointer = currentUser.get("group");


	var JoinGroupRequest = Parse.Object.extend("JoinGroupRequest");
	var query = new Parse.Query(JoinGroupRequest);
	query.equalTo("toGroup", groupPointer);
	query.find({
		success: function(queryRequest){
			
			var results = [];

			for (var i=0; i<queryRequest.length; i++){
				var fromUser = queryRequest[i].get("fromUser");
				var fromUserId = fromUser.id;
				var fromUserName = queryRequest[i].get("fromUserName");
				result = {"fromUserId" : fromUserId,
									"fromUserName" : fromUserName}
				results.push(result);
			}

			response.success(results);

		},
		error: function(error){
			response.error(error);
		}
	});


});


Parse.Cloud.define("getAllChores", function(request, response) {

	var Chore = Parse.Object.extend("PresetChore");
	var query = new Parse.Query(Chore);
	query.limit(1000);
	query.find({
		success: function(allChores){
			response.success(allChores);
		},
		error: function(error){
			response.error(error);
		}
	});

});


Parse.Cloud.define("activeChorePush", function(request, response){

	var message = request.params.message;

	var currentUser = Parse.User.current();
	var username = currentUser.get("username");

	var query = new Parse.Query(Parse.Installation);
	query.equalTo("username", username);
	 
	Parse.Push.send({
	  where: query, // Set our Installation query
	  data: {
	    alert: message
	  }
	}, {
	  success: function() {
	    response.success()
	  },
	  error: function(error) {
	    response.error()
	  }
	});


});





