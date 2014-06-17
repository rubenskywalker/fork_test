<% broadcast "/messages/action" do %>
$('#bar_<%= dom_id(@checklist_item.checklist) %>').html('<%= escape_javascript(render("checklists/bar", :checklist => @checklist_item.checklist))%>')
'<%- if @checklist_item.checked? %>'
$('#check_checklist_item_<%= dom_id(@checklist_item)%>').prop('checked', true)
'<%- else %>'
$('#check_checklist_item_<%= dom_id(@checklist_item)%>').prop('checked', false)
'<% end %>'
<% end %>
$('#recent_activities').html('<%= escape_javascript(render("transactions/recent_activities")) %>')
