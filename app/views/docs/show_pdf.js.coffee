Hlp.Load.checklist_item_doc('#show_pdf_<%= dom_id(@docable) %>', 'ident_pdf_<%= params[:fname] %>')
$('#show_pdf_<%= dom_id(@docable) %> td').html('<%= escape_javascript(render("show_pdf"))%>')
Hlp.Load.show_after_get_pdf('<%= dom_id(@docable) %>')

