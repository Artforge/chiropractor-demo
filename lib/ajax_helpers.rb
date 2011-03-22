class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::AssetTagHelper

  # Accepts an int and displays a smiley based on >, <, or = 0
  
  # def ajax_text_field(object_name, method, options = {})
  #     InstanceTag.new(object_name, method, self, {"data-property",method.to_s}.merge(options.delete(:object))).to_input_field_tag("text", options)
  #   end
  
  def ajax_date_field(method, options = {})
    options[:id] = field_id(method,options[:index])
    options["data-property"] = method.to_s
    options["type"] = "date"
    return text_field_tag(field_name(method,options[:index]),nil,options)
  end
  
  def ajax_text_field(method, options = {})
    options[:id] = field_id(method,options[:index])
    options["data-property"] = method.to_s
    return text_field_tag(field_name(method,options[:index]),nil,options)
  end
  
  def ajax_select(method, option_tags = nil, options = {})
    options[:id] = field_id(method,options[:index])
    options["data-property"] = method.to_s
    return select_tag(field_name(method,options[:index]),option_tags,options)
  end
  
  def ajax_text_area(method, options = {})
    options[:id] = field_id(method,options[:index])
    options["data-property"] = method.to_s
    return text_area_tag(field_name(method,options[:index]),nil,options)
  end

  def field_name(label,index=nil)
    output = index ? "[#{index}]" : ''
    return @object_name + output + "[#{label}]"
  end

  def field_id(label,index=nil)
    output = index ? "_#{index}" : ''
    return @object_name + output + "_#{label}"
  end

end