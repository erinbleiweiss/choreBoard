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
				response.success(newGroup);
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

	       response.success("fb info updated");
	   },function(error){
	       response.error(error);
	   });


});

