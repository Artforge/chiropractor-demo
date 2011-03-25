module ApplicationHelper

  class ChiropractorSimpleFormBuilder < SimpleForm::FormBuilder

    def input(attribute_name, *args, &block)
      options = args.extract_options!
      if options[:input_html]
        options[:input_html].reverse_merge!({"data-property" => attribute_name.to_s })
      else
        options[:input_html] = {"data-property" => attribute_name.to_s }
      end
      super(attribute_name, *(args << options), &block)
    end

  end

  def chiropractor_simple_form_for(object, *args, &block)
    simple_form_for(object, *(args << { :builder => ChiropractorSimpleFormBuilder }), &block)
  end


  class ChirpractorFormBuilder < ActionView::Helpers::FormBuilder

    def text_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def password_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def hidden_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def file_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def text_area(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def check_box(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def radio_button(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def search_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def telephone_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def phone_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def url_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def email_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def number_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def range_field(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def select(method, options = {})
      options.reverse_merge!("data-property" => method.to_s)
      super(method, options)
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      target_method = (options[:key] || method)
      html_options.reverse_merge!(:id => field_id(target_method,options[:index]), "data-property" => target_method)
      super(method, collection, value_method, text_method, options, html_options)
    end

    private

    def field_name(label,index=nil)
      output = index ? "[#{index}]" : ''
      return @object_name + output + "[#{label}]"
    end

    def field_id(label,index=nil)
      output = index ? "_#{index}" : ''
      return @object_name + output + "_#{label}"
    end

  end
  
  def chiropractor_form_for(object, *args, &block)
    form_for(object, *(args << { :builder => ChirpractorFormBuilder }), &block)
  end

  # ActionView::Base.default_form_builder = ChirpractorFormBuilder

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
    sOut << "#{kontroller_name} = new Chiropractor.ResponseController(#{kollection_name.underscore},{"
    sOut << "before_create: #{options[:before_new]}," if options[:before_new]
    sOut << "after_create: #{options[:after_create]}," if options[:after_create]
    sOut << "before_update: #{options[:before_edit]}," if options[:before_edit]
    sOut << "after_update: #{options[:after_update]}," if options[:after_update]
    sOut << "on_error: #{options[:on_error]}," if options[:on_error]
    sOut << "});"
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
