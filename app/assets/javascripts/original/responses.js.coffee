window.Rsp = {}
@Rsp.Load =
  new_transaction_contacts: ->
    $(".new_transaction_contact").bind "ajax:success", (evt, xhr, status) ->
      $form = $(this)
      contact = undefined
      errors = undefined
      try
        contact = $.parseJSON(xhr.responseText)
      catch err
        alert "Please reload the page and try again"
  
      #for error of errors
      #  errorText += error + ": " + errors[error] + "\n "
  
      # Insert error list into form
      #$("#new-contact-tmpl").tmpl(xhr).appendTo("#new-contact-tbody").hide().fadeIn "fast"
      

$ -> 
  Rsp.Load.new_transaction_contacts()