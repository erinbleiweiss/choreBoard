var moment = require('moment');
var _ = require('underscore');

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

	var objId = request.params.objId;

	var User = Parse.Object.extend("_User");
	var query = new Parse.Query(User);
	query.equalTo("objectId", objId);
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
	var firstName = currentUser.get("firstName");
	var lastName = currentUser.get("lastName");

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
			newRequest.set("fromUserName", (firstName + " " + lastName));
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

	var type = request.params.kind;
	var rule = []

	if (type == "weekly") {
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
	}
	else if (type == "monthly"){
		var repeat = request.params.repeat;
		var frequency = request.params.frequency;

		switch (frequency){
			case "Every Month":
				frequency = 1; break;
			case "Every 2 Months":
				frequency = 2; break;
			case "Every 3 Months":
				frequency = 3; break;
			case "Every 4 Months":
				frequency = 4; break;
			case "Every 5 Months":
				frequency = 5; break;
			case "Every 6 Months":
				frequency = 6; break;
			default: break;
		}

		switch (repeat){
			case "1st of the Month":
				repeat = 1; break;
			case "5th of the Month":
				repeat = 5; break;
			case "10th of the Month":
				repeat = 10; break;
			case "15th of the Month":
				repeat = 15; break;
			case "20th of the Month":
				repeat = 20; break;
			case "25th of the Month":
				repeat = 25; break;
			case "Last Day of the Month":
				repeat = 30; break;
			default:
				break;
		}

		console.log(frequency);
		console.log(repeat);

		var dict = {}
		dict["type"] = "Monthly"
		dict["repeat"] = request.params.repeat;
		dict["frequency"] = request.params.frequency;


		if (repeat != 30) {
			dict["nextDue"] = moment().date(1).add("months", (moment().date() > repeat ? frequency - 1 : frequency)).add("days", repeat - 1);
		}
		else {
			dict["nextDue"] = moment().date(1).add("months", (moment().date() > repeat ? frequency - 1 : frequency)).endOf("month");
		}

		rule.push(dict);

	}	


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
	  			if (request.params.kind == "weekly" && request.params.days.length > 0){
		  			chore.set("rule", rule);
	  			}
	  			else if (request.params.kind == "monthly"){
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

	var objId = request.params.objId;
	var kind = request.params.kind;


	var Class = Parse.Object.extend(kind);
	var query = new Parse.Query(Class);
	query.equalTo("objectId", objId);
	query.find({
		success: function(result){
			var theObject = result[0];
			var ruleData = theObject.get("rule");

			var dict = {}

			if (ruleData[0]["type"] == "Weekly"){
				var frequency = ruleData[0]["frequency"];
				var repeat = [];
				for (var i=0; i<ruleData.length; i++){
					repeat.push(ruleData[i]["day"]);
				}

				dict["type"] = "Weekly";
				dict["frequency"] = frequency;
				dict["repeat"] = repeat;

			}
			else if (ruleData[0]["type"] == "Monthly"){
				var frequency = ruleData[0]["frequency"];
				var repeat = ruleData[0]["repeat"];

				dict["type"] = "Monthly";
				dict["frequency"] = frequency;
				dict["repeat"] = [repeat];

			}



			response.success(dict);
		},
		error: function(error){
			response.error(error);
		}

	});



});





Parse.Cloud.define("setCompleted_DEVELOPMENT", function(request, response){

	var objId = request.params.objectId;
	var kind = request.params.kind;

	var currentUser = Parse.User.current();
	var firstName = currentUser.get("firstName");
	var lastName = currentUser.get("lastName");
	var fullName = firstName + " " + lastName;

	var Class = Parse.Object.extend(kind);
	var query = new Parse.Query(Class);
	query.equalTo("objectId", objId);
	query.find({
		success: function(queryUser){
			var theObject = queryUser[0];
			theObject.set("completed", true);
			theObject.set("completedBy", fullName);
			theObject.set("completedAt", new Date());

			theObject.save();

			response.success({"fullName": fullName, "completedAt": new Date()});
		},
		error: function(error){
			response.error(error);
		}

	});


});



Parse.Cloud.define("updateChoreSettings", function(request, response){

	var objId = request.params.objectId;
	var type = request.params.kind;
	if (type == "weekly") {
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
	}
	else if (type == "monthly"){
		var repeat = request.params.repeat;
		var frequency = request.params.frequency;

		switch (frequency){
			case "Every Month":
				frequency = 1; break;
			case "Every 2 Months":
				frequency = 2; break;
			case "Every 3 Months":
				frequency = 3; break;
			case "Every 4 Months":
				frequency = 4; break;
			case "Every 5 Months":
				frequency = 5; break;
			case "Every 6 Months":
				frequency = 6; break;
			default: break;
		}

		switch (repeat){
			case "1st of the Month":
				repeat = 1; break;
			case "5th of the Month":
				repeat = 5; break;
			case "10th of the Month":
				repeat = 10; break;
			case "15th of the Month":
				repeat = 15; break;
			case "20th of the Month":
				repeat = 20; break;
			case "25th of the Month":
				repeat = 25; break;
			case "Last Day of the Month":
				repeat = 30; break;
			default:
				break;
		}

		var dict = {}
		dict["type"] = "Monthly"
		dict["repeat"] = request.params.repeat;
		dict["frequency"] = request.params.frequency;


		if (repeat != 30) {
			dict["nextDue"] = moment().date(1).add("months", (moment().date() > repeat ? frequency - 1 : frequency)).add("days", repeat - 1);
		}
		else {
			dict["nextDue"] = moment().date(1).add("months", (moment().date() > repeat ? frequency - 1 : frequency)).endOf("month");
		}

		rule.push(dict);

	}	



	var Class = Parse.Object.extend(kind);
	var query = new Parse.Query(Class);
	query.equalTo("objectId", objId);
	query.find({
		success: function(result){
			var theObject = result[0];

			if (request.params.kind == "weekly" && request.params.days.length > 0){
  			theObject.set("rule", rule);
			}
			else if (request.params.kind == "monthly"){
				theObject.set("rule", rule);
			}
			theObject.save(null, {
				success: function(chore){
					response.success(chore);
				},
				error: function(error){
					response.error(error);
				}
			});


			response.success();
		},
		error: function(error){
			response.error(error);
		}

	});


});



Parse.Cloud.define("getGroupRequests", function(request, response){

	var currentUser = Parse.User.current();
	var groupPointer = currentUser.get("group");

	var JoinGroupRequest = Parse.Object.extend("JoinGroupRequest");
	var query = new Parse.Query(JoinGroupRequest);
	query.equalTo("toGroup", groupPointer);
	query.find({
		success: function(result){
			response.success(result);
		},
		error: function(error){
			response.error(error);
		}

	});


});


Parse.Cloud.define("getAddToGroupRequests", function(request, response){

	var currentUser = Parse.User.current();
	var groupPointer = currentUser.get("group");

	var AddToGroupRequest = Parse.Object.extend("AddToGroupRequest");
	var query = new Parse.Query(AddToGroupRequest);
	query.equalTo("toUser", currentUser);
	query.find({
		success: function(result){
			response.success(result);
		},
		error: function(error){
			response.error(error);
		}

	});


});





Parse.Cloud.define('getUserIds', function(request, response) {

 var allItems = request.params.allItems; // what is this an array of?
 var objIdArray = [];
 console.log(allItems);

  return Parse.Promise.as().then(function() { // this just gets the ball rolling
    var promise = Parse.Promise.as(); // define a promise

    _.each(allItems, function(item) { // use underscore, its better :)
      promise = promise.then(function() { // each time this loops the promise gets reassigned to the function below

				var User = Parse.Object.extend("_User");
        var query = new Parse.Query(User);
        query.equalTo("facebookId", item); // is this the right query syntax?
        return query.find().then(function(results) { // the code will wait (run async) before looping again knowing that this query (all parse queries) returns a promise. If there wasn't something returning a promise, it wouldn't wait.

					var theId = results[0].id;

					if (theId != null) {
						objIdArray.push(theId);
					}

          return Parse.Promise.as(); // the code will wait again for the above to complete because there is another promise returning here (this is just a default promise, but you could also run something like return object.save() which would also return a promise)

        }, function (error) {
          response.error("score lookup failed with error.code: " + error.code + " error.message: " + error.message);
        });
      }); // edit: missing these guys
    });
    return promise; // this will not be triggered until the whole loop above runs and all promises above are resolved

  }).then(function() {
    response.success(objIdArray); // edit: changed to a capital A
  }, function (error) {
    response.error("script failed with error.code: " + error.code + " error.message: " + error.message);
  });

});

















Parse.Cloud.define("getInvitationRequests", function(request, response){

	var currentUser = Parse.User.current();

	var AddToGroupRequest = Parse.Object.extend("AddToGroupRequest");
	var query = new Parse.Query(AddToGroupRequest);
	query.equalTo("toUser", currentUser);
	query.find({
		success: function(result){
			console.log(result);
			response.success(result);
		},
		error: function(error){
			response.error(error);
		}

	});


});


Parse.Cloud.define("groupNameFromUserID", function(request, response){

	var userId = request.params.userId;
	
	var User = Parse.Object.extend("_User");
	var userQuery = new Parse.Query(User);
	userQuery.equalTo("objectId", userId);
	userQuery.find({
		success: function(queryUser){
			var theUser = queryUser[0];
			var groupId = theUser.get("group").id;

			var Group = Parse.Object.extend("Group");
			var groupQuery = new Parse.Query(Group);
			groupQuery.equalTo("objectId", groupId);
			groupQuery.find({
				success: function(queryGroup){
					var theGroup = queryGroup[0];
					response.success(theGroup.get("groupName"));

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


Parse.Cloud.define('getSnark', function(request, response) {

 var allItems = request.params.allItems; // what is this an array of?
 var snarkArray = [];
 console.log(allItems);

  return Parse.Promise.as().then(function() { // this just gets the ball rolling
    var promise = Parse.Promise.as(); // define a promise

    _.each(allItems, function(item) { // use underscore, its better :)
      promise = promise.then(function() { // each time this loops the promise gets reassigned to the function below

				var Chore = Parse.Object.extend("PresetChore");
        var query = new Parse.Query(Chore);
        query.equalTo("name", item); // is this the right query syntax?
        return query.find().then(function(results) { // the code will wait (run async) before looping again knowing that this query (all parse queries) returns a promise. If there wasn't something returning a promise, it wouldn't wait.

					var theSnark = results[0].get("snark");
					// var theSnark = results[0];

					if (theSnark != null) {
						snarkArray.push(theSnark);
					}

          return Parse.Promise.as(); // the code will wait again for the above to complete because there is another promise returning here (this is just a default promise, but you could also run something like return object.save() which would also return a promise)

        }, function (error) {
          response.error("score lookup failed with error.code: " + error.code + " error.message: " + error.message);
        });
      }); // edit: missing these guys
    });
    return promise; // this will not be triggered until the whole loop above runs and all promises above are resolved

  }).then(function() {
    response.success(snarkArray); // edit: changed to a capital A
  }, function (error) {
    response.error("script failed with error.code: " + error.code + " error.message: " + error.message);
  });

});


Parse.Cloud.define('getOneSnark', function(request, response) {
	var theChore = request.params.choreName;

	var Chore = Parse.Object.extend("PresetChore");
  var query = new Parse.Query(Chore);
  query.equalTo("name", theChore);
  query.find({
  	success: function(result){
  		var theSnark = result[0].get("snark");
  		response.success(theSnark);
  	},
  	error: function(error){
  		response.error(error);
  	}

  });

});



