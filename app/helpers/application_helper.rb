module ApplicationHelper

  def ajax_content_tag(object, attrib, options = {}, escape = true)
    content_tag_string("span", object[attrib], {"data-property",attrib.to_s}.merge(options), escape)
  end
  
  
  def chiropractor_scripts(klass,collection_json, options={})
    newline = "\n"
    sOut = "" + newline
    sOut = ""
    sOut << "var #{klass.name} = Chiropractor.Model.extend({model_name: '#{klass.name}', collection_name: '#{klass.name.pluralize}',class_name: '#{klass.name.underscore}'});" + newline
  	sOut << "var #{klass.name.pluralize} = Chiropractor.Collection.extend({url_base: '#{klass.name.pluralize.underscore}', url: '#{klass.name.pluralize.underscore}_url',model: #{klass.name}});" + newline
  	sOut << "var #{klass.name.pluralize.underscore}_controller;" + newline + newline
  	return sOut.html_safe + chripractor_script_init(klass, collection_json,options).html_safe
  end
  
  def chripractor_script_init(klass, collection_json,options={})
    klass_name = klass.name
    kollection_name = klass.name.pluralize
    kontroller_name = "#{klass.name.pluralize.underscore}_controller"
    post_route = "#{klass.name.pluralize.underscore}_url"
    newline = "\n"

    sOut = "" + newline
    
    sOut << "function new#{klass_name}(){"
    sOut << "#{klass_name.underscore} = new #{klass_name}(JSON.parse('#{raw(klass.new.to_json)}'),{});" + newline
    sOut << "#{kontroller_name}.new(#{klass_name.underscore});" + newline
    sOut << "#{options[:before_new]}(#{klass_name.underscore});" if options[:before_new]
    sOut << "}" + newline + newline
    
    sOut << "$(document).ready(function() {" + newline

    sOut << "var #{kollection_name.underscore} = new #{kollection_name}(#{raw(collection_json)},{url_base: '#{klass.name.pluralize.underscore}', url:'#{post_route}',display: $('[data-collection=\"#{kollection_name.underscore}\"]')});" + newline
    sOut << "#{kontroller_name} = new Chiropractor.ResponseController(#{kollection_name.underscore});" + newline
    sOut << "$('[data-action=\"sort\"]').click(function(){#{kollection_name.underscore}.sortView($(this).data(\"attribute\"));})" + newline
    sOut << "$('#new_#{klass_name.underscore}').click(function(){new#{klass_name}();return false;});" + newline

    sOut << "$('a[data-action=\"edit\"]').click(function(){" + newline
    sOut << "#{klass_name.underscore} = #{kollection_name.underscore}.get($(this).data(\"id\"));" + newline
    sOut << "#{kontroller_name}.edit(#{klass_name.underscore}.id);" + newline
    sOut << "#{options[:before_edit]}(#{klass_name.underscore});" if options[:before_edit]
    sOut << "return false;});" + newline
    sOut << "$('a[data-action=\"show\"]').click(function(){#{kontroller_name}.show($(this).data(\"id\"));return false;});" + newline
    sOut << "$('input[type=\"date\"]').datepicker({showOtherMonths: true, selectOtherMonths: true});" + newline
    sOut << "new#{klass_name}();" + newline
    sOut << "});" + newline
    return sOut
  end
  
end
