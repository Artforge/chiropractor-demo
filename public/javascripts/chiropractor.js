/* Returns the class name of the argument or undefined if
   it's not a valid JavaScript object.
*/
function getObjectClass(obj) {
    if (obj && obj.constructor && obj.constructor.toString) {
        var arr = obj.constructor.toString().match(
            /function\s*(\w+)/);

        if (arr && arr.length == 2) {
            return arr[1];
        }
    }
    return undefined;
}

function dumpProps(obj, parent) {
   // Go through all the properties of the passed-in object
   for (var i in obj) {
      // if a parent (2nd parameter) was passed in, then use that to
      // build the message. Message includes i (the object's property name)
      // then the object's property value on a new line
      if (parent) { var msg = parent + "." + i + "\n" + obj[i]; } else { var msg = i + "\n" + obj[i]; }
      // Display the message. If the user clicks "OK", then continue. If they
      // click "CANCEL" then quit this level of recursion
      if (!confirm(msg)) { return; }
      // If this property (i) is an object, then recursively process the object
      if (typeof obj[i] == "object") {
         if (parent) { dumpProps(obj[i], parent + "." + i); } else { dumpProps(obj[i], i); }
      }
   }
}
// (function(){

	// Initial Setup
	// -------------
	// The top-level namespace. All public Chiropractor classes and modules will be attached to this.
	var Chiropractor;
	if (typeof exports !== 'undefined') {
		Chiropractor = exports;
	} else {
		Chiropractor = this.Chiropractor = {};
	}

	// Current version of the library. Keep in sync with `package.json`.
	Chiropractor.VERSION = '0.0.1';

	// Chiropractor.Model
	// --------------

	// Create a new model, with defined attributes. Extends Backbone.Model
	Chiropractor.Model = Backbone.Model.extend({
		initialize: function(attributes, options){
			this.display = options.display || this.fetchDisplay();
			this.editor = options.editor;
			this.url = options.url || (this.editor ? this.editor.attr("action") : false) ;
			this.disableUnchangedForm = options.disableUnchangedForm || false;
		},
		dirty: function(attr){
			if (attr) {
				return this.hasKey(this.changedAttributes(),attr);
			}else{
				return (this.getKeys(this.changedAttributes()).length == 0);
			}
		},
		getKeys: function(h) {
			keys = new Array();
			for (var key in h){keys.push(key)}
			return keys;
		},
		hasKey: function(hash,key){
			return (this.getKeys(hash).indexOf(key) >= 0)
		},
		fetchDisplay: function(){
			// console.log("fetchDisplay",$('[data-model="' + this.class_name + '"][data-id="' + this.id + '"]'))
			return $('[data-model="' + this.class_name + '"][data-id="' + this.id + '"]');
		},
		refresh: function(){
			if (this.display){
				if (this.display.data("id")){this.display.data("id",this.id)};
				if (this.dirty()){
					if (this.disableUnchangedForm){
						this.editor.find(':submit').addClass("disabled");
					}
					this.display.removeClass("dirty");
				}else{
					this.editor.find(':submit').removeClass("disabled");
					this.display.addClass("dirty");
				}
				self = this;
				$.each(this.attributes,function(key,value){
					if (value){
						element = self.display.find('[data-property="' + key + '"]');
						// console.log(key + ":" + getObjectClass(value),element)
						if (getObjectClass(value) == "Object"){
							self.refreshDeep(key, value)
						}
						element.removeClass("changed");
						if (self.dirty(key)){
							element.addClass("changed");
						}
						if ((value.toString().indexOf(".jpg") != -1) || (value.toString().indexOf(".png") != -1) || (value.toString().indexOf(".gif") != -1)){
							element.find("img").attr("src",value);
						}else{
							element.html(value);
						}
					}
				})
			}
		},
		refreshDeep: function(obj_class,obj, parent) {
			// Go through all the properties of the passed-in object
			for (var i in obj) {
				if (parent) {obj_class = parent + "." + objClass}				
				element = self.display.find('[data-property="' + obj_class + '.' +  i + '"]');
				element.html(obj[i]);
				// If this property (i) is an object, then recursively process the object
				if (typeof obj[i] == "object") {
					if (parent) { 
						this.refreshDeep(obj_class, obj[i], parent + "." + i); 
					} else { 
						this.refreshDeep(obj_class,obj[i], i); 
					}
				}
			}
		},
		loadForm: function(editor){
			if (editor) {
				this.editor = editor;
			}
			self = this;
			$.each(this.attributes,function(key,value){
				element = self.editor.find('[data-property="' + key + '"]');
				// console.log(key,element);
				element.val(value);
			});
			this.watchForm();
		},
		watchForm: function(){
			this.refresh();
			self = this;
			$.each(this.attributes,function(key,value){
				element = self.editor.find('[data-property="' + key + '"]');
				element.live('change', function(event) {
					eval("self.set({" + key + ": this.value},{silent: true})");
					self.refresh();
				});
			})
		}
	});
	
	// Chiropractor.Collection
	// --------------

	// Provides a standard collection class for our sets of models, ordered
	// or unordered. If a `comparator` is specified, the Collection will maintain
	// its models in sort order, as they're added and removed.
	
	Chiropractor.Collection = Backbone.Collection.extend({
	  	model: Chiropractor.Model,
		initialize: function(attributes, options){
			this.display = options.display // || this.fetchDisplay();
			this.sortAttribute
			this.sortOrder
			this.url_base = options.url_base || (this.editor ? this.editor.attr("action") : false) ;
		},
		sortView: function(attribute){
			this_collection = this;
			
			$('[data-action="sort"]').removeClass("sort_asc");
			$('[data-action="sort"]').removeClass("sort_desc");
			
			this.sortAttribute = attribute;
			this.sortOrder = (this.sortOrder == "asc") ? "desc" : "asc"
			this.comparator = function(model) {
				attr = model.get(attribute);
				if (Date.parse(attr)){
					return Date.parse(attr)
				}else{
					return model.get(attribute);
				}
			};
			
			$('[data-action="sort"][data-attribute="' + this.sortAttribute + '"]').addClass("sort_" + this.sortOrder)
			
			this.sort();
			this.each(function(model){
				if (this_collection.sortOrder == "asc"){
					this_collection.display.append(model.display);
				}else{
					this_collection.display.prepend(model.display);
				}
			})
		}
	});
	
	
	// Chiropractor.ResponseController
	// --------------
	Chiropractor.ResponseController = function(collection, options) {
		options || (options = {});
		this.collection = collection;
		// if (options && options.collection) this.collection = options.collection;
	    this.initialize(collection,options);
	};
	
	_.extend(Chiropractor.ResponseController.prototype, {
		
		initialize: function(collection,options){
			// console.log("**",'[data-model="' + collection.model.class_name + '"][data-id="0"]')
			this.template = $('[data-model="' + collection.model.prototype.class_name + '"][data-id="0"]');
			this.before_new = options.before_new;
			this.after_create = options.after_create;
			this.before_edit = options.before_edit;
			this.after_update = options.after_update;
			this.on_error = options.on_error;
			
		},
		// template: function(element){
		// 			element || this.template;
		// 		},
		show: function(id,view){
			model = this.collection.get(id);
			model.url = this.collection.url_base + "/" + model.id;
			dataView = view ? view : "show";
			// console.log(view,dataView);
			model.display = $('[data-model="' + model.class_name + '"][data-view="' + dataView + '"]');
			model.refresh();
		},
		destroy: function(id){
			model = this.collection.get(id);
			model.display = model.fetchDisplay();
			model.display.hide('slow', function(){
				$(this).remove();
			});
			this.collection.remove(model);
		},
		edit: function(id,view){
			this_controller = this;
			dataView = view ? view : "edit";
			model = this.collection.get(id);
			model.editor = $('[data-model="' + model.class_name + '"][data-view="' + dataView + '"]');
			model.loadForm();
			model.url = this.collection.url_base + "/" + model.id;
			submitButton = model.editor.find(':submit');
			submitButton.unbind(); // REQUIRED in order to avoid multiple bindings building up
			// this.before_edit(model);
			submitButton.click(function(){
				if (submitButton.hasClass("disabled")){return false}
				model.save(model.attributes,{
					error:this.on_error,
					success:function(model,response){
						this_controller.update(model)
					}
				});
				return false
			});
		},
		update: function(model){
			model.refresh();
			this.after_update(model);
		},
		new: function(model,view){
			this_controller = this;
			dataView = view ? view : "edit";
			model.editor = $('[data-model="' + model.class_name + '"][data-view="' + dataView + '"]');
			model.loadForm();
			submitButton = model.editor.find(':submit');
			submitButton.unbind(); // REQUIRED in order to avoid multiple bindings building up
			// this.before_new(model);
			submitButton.click(function(){
				if (submitButton.hasClass("disabled")){return false}
				model.url = this_controller.collection.url; // Shouldn't Backbone handle this?
				model.save(model.attributes,{
					error:this.on_error,
					success:function(model,response){
						this_controller.create(model)
					}
				});
				return false;
			});
		},
		create: function(model){
			model.display = this.template.clone(false).removeClass("template");
			model.refresh();
			this.collection.display.append(model.display);
			this.after_create(model);
		}
	});

// });