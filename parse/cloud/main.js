
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("createNewChore", function(request, response)){

	var ChoreClass = Parse.Object.extend("Chore");
	var chore = new ChoreClass();

	var username = request.params.username;
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

}