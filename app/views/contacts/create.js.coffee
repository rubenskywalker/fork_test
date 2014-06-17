'<%- if @existing_user == true && !@my_user == true %>'
Hlp.Load.confirm_existing_contact('<%= @contact.id %>', '<%= current_user.id %>', '')
'<%- elsif @my_user == true %>'
Hlp.Load.growl_alert "This contact is already in your contacts.", 'error'
'<%- else %>'
window.location.href = '/contacts'
'<% end %>'
