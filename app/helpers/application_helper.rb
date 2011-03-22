module ApplicationHelper

  def ajax_content_tag(object, attrib, options = {}, escape = true)
    content_tag_string("span", object[attrib], {"data-property",attrib.to_s}.merge(options), escape)
  end
  
end
