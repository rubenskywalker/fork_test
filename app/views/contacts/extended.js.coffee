$('#parent_<%= dom_id(@contact) %>').after('<%= escape_javascript(render("extended", :contact => @contact))%>')
Hlp.Load.super_tooltip()