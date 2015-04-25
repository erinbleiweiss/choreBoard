var moment = require('moment');

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


Parse.Cloud.define("addSupply", function(request, response){

	var Supply = Parse.Object.extend("Supply");
	var supply = new Supply();

	var currentUser = Parse.User.current();
	currentUser.fetch({
	  success: function(currentUser) {
	  	var groupObj = currentUser.get("group");
	    supply.set("group", groupObj);
	  	supply.save(null, {
	  		success: function(supply){
	  			var supplyName = request.params.supplyName;
	  			supply.set("supplyName", supplyName);
	  			supply.set("completed", false);
	  			supply.save(null, {
	  				success: function(supply){
	  					response.success(supply);
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


Parse.Cloud.define("addBill", function(request, response){

	var Bill = Parse.Object.extend("Bill");
	var bill = new Bill();

	var currentUser = Parse.User.current();
	currentUser.fetch({
	  success: function(currentUser) {
	  	var groupObj = currentUser.get("group");
	    bill.set("group", groupObj);
	  	bill.save(null, {
	  		success: function(bill){
	  			var billName = request.params.billName;
	  			var billAmount = request.params.billAmount;
	  			bill.set("billName", billName);
	  			bill.set("amount", billAmount)
	  			bill.set("completed", false);
	  			bill.save(null, {
	  				success: function(bill){
	  					response.success(bill);
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
	query.equalTo("group", groupPointer);
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

Parse.Cloud.define("getGroupItems", function (request, response){

	var user = Parse.User.current()
	var groupPointer = user.get("group");

	var Chore = Parse.Object.extend("Chore");
	var choreQuery = new Parse.Query(Chore);
	choreQuery.equalTo("group", groupPointer);
	choreQuery.find({
		success: function(allChores){
			var Supply = Parse.Object.extend("Supply");
			var supplyQuery = new Parse.Query(Supply);
			supplyQuery.equalTo("group", groupPointer);
			supplyQuery.find({
				success: function(allSupplies){
					var Bill = Parse.Object.extend("Bill");
					var billQuery = new Parse.Query(Bill);
					billQuery.equalTo("group", groupPointer);
					billQuery.find({
						success: function(allBills){
							response.success({"chores" : allChores,
																"supplies" : allSupplies,
																"bills" : allBills}
							);
						},
						error: function(error){
							response.error(error);
						}
					});
				},
				error: function(error){
					response.error(error);
				}
			});
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

Parse.Cloud.define("getAllSupplies", function(request, response) {

	var Supply = Parse.Object.extend("PresetSupply");
	var query = new Parse.Query(Supply);
	query.limit(1000);
	query.find({
		success: function(allSupplies){
			response.success(allSupplies);
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



Parse.Cloud.define("setCompleted", function(request, response){

	var objId = request.params.objectId;
	var kind = request.params.kind;


	var Class = Parse.Object.extend(kind);
	var query = new Parse.Query(Class);
	query.equalTo("objectId", objId);
	query.find({
		success: function(queryUser){
			var theObject = queryUser[0];
			theObject.set("completed", true);
			theObject.save();

			response.success();
		},
		error: function(error){
			response.error(error);
		}

	});


});


Parse.Cloud.define("reset", function(request, response){

	var objId = request.params.objectId;
	var kind = request.params.kind;


	var Class = Parse.Object.extend(kind);
	var query = new Parse.Query(Class);
	query.equalTo("objectId", objId);
	query.find({
		success: function(queryUser){
			var theObject = queryUser[0];
			theObject.set("completed", false);
			theObject.save();

			response.success();
		},
		error: function(error){
			response.error(error);
		}

	});


});


Parse.Cloud.define("deleteObject", function(request, response){

	var objId = request.params.objectId;
	var kind = request.params.kind;


	var Class = Parse.Object.extend(kind);
	var query = new Parse.Query(Class);
	query.equalTo("objectId", objId);
	query.find({
		success: function(queryUser){
			var theObject = queryUser[0];
			theObject.destroy();
			response.success();
		},
		error: function(error){
			response.error(error);
		}

	});


});






/////////////////////////////////////////////////////////////////////








Parse.Cloud.define("addChore_DEVELOPMENT", function(request, response){

	var ChoreClass = Parse.Object.extend("Chore");
	var chore = new ChoreClass();

	var days = request.params.days;
	var frequency = request.params.frequency;

	switch (frequency){
		case "Weekly":
			frequency = 1; break;
		case "Every 2 Weeks":
			frequency = 2; break;
		case "Every 3 Weeks":
			frequency = 3; break;
		case "Every 4 Weeks":
			frequency = 4; break;
		default:
			break;
	}

	var rule = []
	for (var i=0; i<days.length; i++){

		var theDay = days[i];

		switch (days[i]){
			case "Sunday":
				days[i] = 0; break;
			case "Monday":
				days[i] = 1; break;
			case "Tuesday":
				days[i] = 2; break;
			case "Wednesday":
				days[i] = 3; break;
			case "Thursday":
				days[i] = 4; break;
			case "Friday":
				days[i] = 5; break;
			case "Saturday":
				days[i] = 6; break;
			default:
				break;
		}

		// check if current day <= days[i]

		var next = days[i] + (7 * frequency);
		console.log(next);

		var dict = {}
		dict["type"] = "Weekly"
		dict["day"] = theDay;
		dict["frequency"] = request.params.frequency;
		dict["nextDue"] = moment().day(next);
		rule.push(dict);

	}	


	console.log(frequency);

	console.log(moment().format('MMMM Do YYYY, h:mm:ss a'));
	console.log(moment().day(10));

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
	  			if (request.params.days.length > 0){
		  			chore.set("rule", rule);
	  			}
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




Parse.Cloud.define("getSettings", function(request, response){

	



});








