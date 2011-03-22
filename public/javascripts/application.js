jQuery.ajaxSetup({ 
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
	this.live("submit",function() {
		$.post(this.action, $(this).serialize(), null, "script");
		return false;
	})
	return this;
};


jQuery(document).ready( function(){
	
	$('#flash_notice').ajaxComplete(function(e, xhr, settings) {
		var msg = xhr.getResponseHeader('X-Message');
		var msg_type = xhr.getResponseHeader('X-Message-Type');
		
		if (msg){
			$('#flash_notice').addClass(msg_type).html(msg).show('blind',{},250,function(){
				$(this).delay(3000).hide('blind',{},250).removeClass(msg_type);
			})
		}
	});
	
	
	$('a[rel*=facebox]').live("mousedown", function() { 
	    $(this).facebox();
	});
	
	jQuery('a.remote-delete').live("click",function() {  
		if (confirm("Are you sure you want to delete this item?")){
			jQuery.post(this.href, { _method: 'delete' }, null, "script");  
		}
		return false;  
	});
	
	jQuery('a.remote').live('click',function(event){
		event.preventDefault();
		jQuery.get(this.href,{_method: 'get'},function(response){ 
			eval(response);
		},"script")
	});

});

// EXTEND jQuery AJAX FUNCTIONALITY
function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}

jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});
// EXTEND jQuery AJAX FUNCTIONALITY