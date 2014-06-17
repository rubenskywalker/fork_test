module ApplicationHelper
  def edit_button i, text, size = "mini", css_class = "", link = "", method = ""
    link_to icon(i, text), link, :method => method, :class => "btn btn-info btn-#{size} #{css_class}", :remote => true
  end
  
  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block)}
    uri = URI.parse("http://app.piratetesternow.com:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
  
  def menu_active (controller)
    controller == params[:controller] ? "active" : ""
  end
  
  def icon icon, text
    "<i class='glyphicon glyphicon-#{icon}'></i> #{text}".html_safe
  end
  
  def icon_fa icon, text
    "<i class='icon-#{icon}'></i> #{text}".html_safe
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def transaction_role transaction
    if (transaction.user_status_1? && transaction.user_status_2?) || transaction.user_status_3?
      "Dual Agency"
    elsif transaction.user_status_1?
      "Buyer's Agent"
    elsif transaction.user_status_2?
      "Listing Agent"
    end
      
  end
  
  def ms_link_items text, only, obj=nil, doc=nil
    css_class = !obj.nil? && doc.doc_accesses.send(only).map(&:docable_id).include?(obj.id) ? "glyphicon glyphicon-ok" : ""
    content_tag(:span, text, :class => css_class).html_safe
  end
  
  
  def ms_link_users text, user, users
    "<span class='#{'glyphicon glyphicon-ok' if !users.nil? && users.map(&:id).include?(user.id)}'></span> #{text}".html_safe
  end
  
  def ms_link_users_shared text, user, super_user, transaction
    "<span class='#{'glyphicon glyphicon-ok' if !super_user.nil? && user.contact_accesses.where(:transaction_id => transaction.id).map(&:contact_id).include?(super_user.id)}'></span> #{text}".html_safe
  end
  
  def ms_link_dashboard text, item
    "<span class='#{'glyphicon glyphicon-ok' if item}'></span> #{text}".html_safe
  end
  
  def vnv item
    item == 1 ? "(*)" : ""
  end
  
  def disable_access can_action, can_object
     can?(can_action, can_object) ? false : true
  end
  
  
  def tname t, tr
    "#{tr.address_1}, #{tr.address_2}, #{tr.city}, #{tr.state}"
  end
  
  def vnv_css item
    'tdvalid' if item == 1
  end
  
  def doc_assigned_checklist_items doc
    ids = doc.doc_accesses.only_ci.map(&:docable_id)
    ChecklistItem.where(:id => ids).map(&:name).join(", ")
  end
  
  def recent_activity_color message
    case 
      when message.include?('file')
        "label-info"
      when message.include?('checked')
        "label-success"
      when message.include?('note')
        "label-warning"
       when message.include?('sent an email titled')
         "label-danger"
      end
  end
  
  def widget_title widget
    widget.myself? ? "Myself" : (widget.location_id == 0 ? "All Locations" : "#{widget.location.name}")
  end
  
  def bar_width all, checked
    (checked.to_f / all.to_f ) * 100
  end
  
end
