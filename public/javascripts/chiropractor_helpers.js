function updateComplete(model){
	model.display.effect("highlight", {}, 1000);	
	model.editor.effect("highlight", {}, 1000);	
}

function createComplete(model){
	model.editor.effect("highlight", {}, 1000);	
}

function saveError(model,response){
	alert("Error!")
}

function newFormText(model){
	model.editor.find('h2').html("Create a new" + model.model_name);
	model.editor.find(':submit').val("Create" + model.model_name);
}

function editFormText(model){
	model.editor.find('h2').html("Edit " + model.model_name);
	model.editor.find(':submit').val("Update " + model.model_name);
}
