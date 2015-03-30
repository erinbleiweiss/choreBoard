
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
	newGroup.save();

	var currentUser = Parse.User.current();
	currentUser.set("group", newGroup);
	currentUser.save();

});

Parse.Cloud.define("createNewChore", function(request, response){

	var ChoreClass = Parse.Object.extend("Chore");
	var chore = new ChoreClass();

	var currentUser = Parse.User.current();
	currentUser.fetch({
	  success: function(currentUser) {
	  	var groupObj = currentUser.get("group");
	    chore.set("group", groupObj);
	  	chore.save();
	  }
	});

	var choreName = request.params.choreName;
	chore.set("choreName", choreName);

	chore.save(null,{
	  success:function(chore) { 
	    response.success(chore);
	  },
	  error:function(error) {
	    response.error(error);
	  }
	});

});