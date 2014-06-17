# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
window.Hlp = {}
@Hlp.Load =
  confirm_existing_user: (contact_id, user_id, attach_contact)->
    bootbox.confirm "This email is already registered in the system and we do not allow duplicate email addresses. Would you like to add the existing contact?", (result) ->
      if result
        true
      else
         window.location = "/transactions/#{contact_id}/remove_contact?user_id=#{user_id}&attach_contact=#{attach_contact}"
  confirm_existing_contact: (contact_id, user_id, attach_contact)->
    bootbox.confirm "An existing user has been found with this email address, would you like to add them to your Contacts?", (result) ->
      if result
        window.location = "/contacts"
      else
        window.location = "/transactions/#{contact_id}/remove_contact?user_id=#{user_id}&attach_contact=#{attach_contact}"

  
  checklists_sortable: ->
    $('#checklist_items_sort').sortable
      axis: 'y'
      items: '.sortable_item'
      connectWith: '#checklist_items_sort'
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))
    $('#checklists_position').sortable
      axis: 'y'
      items: '.sortable_item'
      connectWith: '#checklists_position'
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))
        
  dashboard_sortable: ->
        
    $("#dashboards").unbind()
    $('#dashboards').sortable
      axis: 'y'
      items: '.sortable_item'
      connectWith: '#dashboards'
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))  
          
  drag_color: ->
    $(".drag").on "dragenter", ->
      $(this).css("background-color", "#0088cc")
    $(".drag").on "drop", ->
      $(this).css("background-color", "#FFFFFF")
  load_checklist_items: ->
    $(".show_hide_all_details").click ->
      $("##{$(this).data("child-id")}").toggle()
      #$(".show_hide_details_well").toggle()
      false
    
    $(".add_checklist_item").click ->
      $('.add_checklist_item_well').toggle()
      return false
    $(".close_checklist_item").click ->
      $('.add_checklist_item_well').hide()
      return false

  uploader_init_with_id: (objid) ->
    
    if $('#pdf_only').length then pdf_only = true else pdf_only = false
    Tools.Utils.uploader($(objid).attr('upload_path'), $(objid).attr('id'), $(objid).attr('upload_container'), $(objid).attr('process_view'), $(objid).attr('after_view'), pdf_only)  
    
  uploader_init: ->
    if $('#pdf_only').length then pdf_only = true else pdf_only = false
    $('.uploader_button').each ->
      Tools.Utils.uploader($(@).attr('upload_path'), $(@).attr('id'), $(@).attr('upload_container'), $(@).attr('process_view'), $(@).attr('after_view'), pdf_only)  

  assign_url_to_move_files: ->
    $("#assign_files").on "hidden", (event) ->
      $(this).removeData('modal')
    $("#assign_files").on "show", (event) ->
      console.log $(this).data("modal").options.moveurl
      url = $(this).data("modal").options.moveurl
      $("#move_files_form").attr("action", url)
  
  toggle_contacts: ->
    $(".seller_well").toggle()
      
  create_multi_select: ->
    $('.multicheck').unbind('click')
    $('.multicheck').click -> 
      $(this).toggleClass("checked")
      $(this).find("span").toggleClass("icon-ok")
      return false
    $('.singlecheck').unbind('click')
    $('.singlecheck').click ->
      $('.singlecheck').removeClass("checked")
      $('.singlecheck').find("span").removeClass("icon-ok")
      $(this).addClass("checked")
      $(this).find("span").addClass("icon-ok")
      return false
  
  assign_files_to: ->
    $('.assign_files_to').unbind('click')
    $(".close_assign_files").unbind('click')
    
    $(".close_assign_files").click ->
      $(".open").removeClass("open")
      return false
    
    $('.assign_files_to').click ->
      file_arr = []
      $(this).parent("div").parent("li").parent("ul").find(".multicheck").each ->
        file_arr.push $(this).data("fileid") if $(this).hasClass("checked")
      
      $.ajax
        type: "put"
        dataType: 'script'
        data: {file_ids: file_arr}
        url: $(this).data('url')
        success: (data, textStatus, jqXHR) ->
      
      return false
      
      
  check_checklist_item: ->
    $('.check_checklist_item').click ->
      ptr = $(this).parent('td').parent('.locked_checklist')
      if $(this).is(':checked') 
        $(ptr).find('a').attr('disabled', 'disabled')
        $(ptr).find('button').attr('disabled', 'disabled')
      else
        $(ptr).find('a').removeAttr("disabled")
        $(ptr).find('button').removeAttr("disabled")
         
      $.ajax
        type: "put"
        dataType: 'script'
        url: $(this).data('url')
        
  show_after_get_pdf: (obj_id) ->
    $('.file_iframe').each ->
      unless $(this).attr('id') is "show_pdf_#{obj_id}"
        $(this).hide()
    $.scrollTo( "#show_pdf_#{obj_id}", 800, {offset: {top:-70, left:0}})
  
    
  show_doc_embed_file: ->
    $(".show_hide_rename_form").unbind('click')
    $(".show_hide_rename_form").click ->
      form_id = $(this).data("formid")
      $(form_id).toggleClass("hidden_item")
      false
    
    $(".not_pdf").unbind('click')
    $(".not_pdf").click ->
      Hlp.Load.growl_alert "Preview isn't available for this document, because it is not a PDF file.", 'error'
      
    $('.show_doc_embed_file').unbind('click')
    $('.show_doc_embed_file').click ->
      
      iframe = $(this).data("iframe")
      sid = $(this).data("id")
      $('.file_iframe').each -> 
        unless $(this).attr('id') is sid
          $(this).hide()
      key_url = $(this).data("key")
      $.ajax
        type: "GET"
        dataType: 'script'
        url: key_url
        success: (data, textStatus, jqXHR) ->
          #$("##{iframe}").attr("src", "http://docs.google.com/gview?url=http://app.piratetesternow.com/docs/#{data}/show_file&embedded=true")
          #$("##{iframe}").load("http://app.piratetesternow.com/docs/#{data}/show_png")
          $.ajax
            #url: "http://localhost:3000/docs/230/show_png"
            url: "http://app.piratetesternow.com/docs/#{data}/show_png"
            cache: false
            success: (html) ->
              $("##{iframe}").html html
              Hlp.Load.doc_viewer()
              $('#loader').hide()
          $("##{sid}").toggle()
          $('#loader').hide()
          Hlp.Load.on_resize()
          #$.scrollTo( "#scroll_#{sid}", 800, {offset: {top:-46, left:0}})
      return false
  
  close_assign_files: ->
    
  
    
  popover: ->
    $('.show_popover').clickover({ html: true, placement: 'left', width: '300px'})
    $('.show_transaction_info').clickover(
      html: true
      placement: 'right'
      width: '500px'
      global_close: false
      onShown: ->
        $('.popover').css("z-index", "1000000002")
        $('.popover').css("max-width", "500px")
        
    )

    $('.show_popover_contact').clickover({ html: true, placement: 'right', width: '300px'})
    $('.show_as').clickover(
      html: true
      placement: 'bottom'
      width: '500px'
      global_close: false
      container: 'body'
      tip_id: 'as_form'
      onShown: ->
        $(".datepicker").datepicker({format: "mm-dd-yyyy"})
        $('.popover').css("z-index", "10000")
        #$('.popover').css("max-width", "500px")
        $('#as_form').css("margin-left", "-120px")
      onHidden: ->
        $('#as_form').hide()
        $('#as_form').css("margin-left", "0")
        
    )
    
    
   
    #$('body').click ->
      #$('.show_popover').popover('hide')
   
    
  new_checklist_input: ->
    $('.new_checklist_input').keyup ->
      button = $(this).parents('form').find('.btn')
      if $(this).val().length > 1
        button.removeAttr("disabled")
      else
        button.attr("disabled", "false")

  change_td_example: ->
    $('.change_td_example').click ->
      text = $(this).data("ex")
      $('.change_td_example_well').html("Example: #{text}")
  
  doc_viewer: ->
    $(".docviewerButton").click ->
      direction = $(this).data("d")
      current = parseInt($(".docviewer").data("current"))
      total = parseInt($(".docviewer").data("total"))
      next = 1
      if direction == "right"
        next = current + 1
        if current == total
          next = 1
      if direction == "left"
        next = current - 1
        if current == 1
          next = total
      $(".docviewer").data("current", next)
      $(".docviewerImage").hide()
      $("img[data-n='#{next}']").show()
      false
      
  chack_td_form: ->
    $('#transaction_form').submit (e) ->
      valid = true
      $('.char_valid').each ->
        t_val = $(this).val()
        if (t_val.indexOf("/") >= 0) or (t_val.indexOf("\\") >= 0) or (t_val.indexOf("<") >= 0) or (t_val.indexOf(">") >= 0) or (t_val.indexOf(":") >= 0) or (t_val.indexOf('"') >= 0) or (t_val.indexOf("|") >= 0) or (t_val.indexOf("?") >= 0) or (t_val.indexOf("*") >= 0) 
          $(this).addClass("error")
          $('.alert').html = 'Incompatible character(s) used in transaction. Do not use / < > : ” | ? * in your descriptions.'
          Hlp.Load.growl_alert('Incompatible character(s) used in transaction. Do not use / < > : ” | ? * in your descriptions.', 'error')
          e.preventDefault()
          valid = false
      $('.tdvalid').each ->
        if $(this).val().length < 1
          $(this).addClass("error")
      $('.tdvalid').each ->
        if $(this).val().length < 1
          $('.alert').html = 'Please fill required fields marked with (*) to proceed'
          Hlp.Load.growl_alert('Please fill required fields marked with (*) to proceed', 'error')
          
          #alert 'Please fill required fields marked with (*) to proceed'
          e.preventDefault()
          valid = false
      return valid
      
  createAutoClosingAlert: ->
    i = 0
    $('.flash_notice').each ->
      i += 1
      obj = this
      if i is 1
        Hlp.Load.growl_alert $(this).html(), $(obj).data("type")
      
    #alert = $('.alert').alert()
    #window.setTimeout (->
    #  alert.alert "close"
    #), 1200
  
  welcome_template_save: ->
    $("#welcome_template_save").click (e) ->
      e.preventDefault()
      if $("#welcome_template_name").val().length > 1
        name = $("#welcome_template_name").val()
        subject = $("#user_welcome_subject").val()
        message = $("#user_welcome_message").val()
        $.post("/settings_users/save_welcome_template", "welcome_template[name]=#{name}&welcome_template[subject]=#{subject}&welcome_template[message]=#{message}")
        
  welcome_template_change: ->
    $(".welcome_template").click (e) ->
      e.preventDefault()
      $("#user_welcome_subject").val( $(this).data("subject") )
      $("#user_welcome_message").val( $(this).data("message") )
      
  delete_contact_item: ->
    $('.delete_contact_item').click (e) ->
      e.preventDefault()
      nurl = $(this).data("nurl")
      $.get(nurl)
      user_id = $(this).data("user")
      #$("#attach_contact_user_#{user_id}").next('input[type=hidden]').remove()
      $("#contact_item_#{user_id}").remove()
      if $("#attach_contact_destroy_#{user_id}").length
        $("#attach_contact_destroy_#{user_id}").val("1")
      else
        $("#attach_contact_user_#{user_id}").remove()

  checklist_item_doc: (obj_id, self_id) ->
    sid = $(obj_id).attr("intid")
    $(obj_id).attr("intid", self_id)
    if sid is self_id
      $(obj_id).toggle()
    else
      $(obj_id).show()
    
  docs_inside: ->
    $(".docs_inside").click ->
      Hlp.Load.growl_alert "This category can't be deleted because it has documents associated with it.", 'error'
  
  growl_alert: (msg, type)->
    
    text = "<button type='button' class='close close_super_alert'>&times;</button>#{msg}"
    if $('.main_nav_b').length > 0
      $('#super_alert').css("margin-top", "2px")
      $('#super_alert').css("margin-bottom", "-2px")
    else
      $('#super_alert').css("margin-top", "2px")
      $('#super_alert').css("margin-bottom", "-2px")
    $.scrollTo( 0, 800 )
    $('#super_alert').removeClass("alert-success")
    $('#super_alert').removeClass("alert-danger")
    $('#super_alert').addClass("alert-#{if type is 'error' then 'danger' else type}")
    $('#super_alert').html(text)
    #if type is 'success'
    #  $('#super_alert').slideDown('slow').delay(2500).slideUp('slow')
    #else
    #  $('#super_alert').slideDown('slow')
    $('#super_alert').slideDown('slow')
    $(".close_super_alert").click ->
      $("#super_alert").hide()
   
    
  old_growl_alert: (text, type)->
    $.bootstrapGrowl text,
      ele: "body" # which element to append to
      type: type # (null, 'info', 'error', 'success')
      offset: # 'top', or 'bottom'
        from: "top"
        amount: 40

      align: "center" # ('left', 'right', or 'center')
      width: 1220 # (integer, or 'auto')
      delay: 4000
      allow_dismiss: true
      stackup_spacing: 10 # spacing between consecutively stacked growls.
      
  clear_contacts_form: ->
    $("#new_user").find("input:text").val("")
  
  on_resize: ->
    if $('.docviewerImage').length > 0
      ww = $(window).width()
      iw = $('.docviewerImage').width()
      
      if iw > ww 
        $('.docviewerImage').width(ww)
      else
        $('.docviewerImage').width('100%')
      
    if $(window).width() < 769
      $(".small_no_display").hide()
      $(".small_display").show()
    else
      $(".small_no_display").show()
      $(".small_display").hide()
    if $(window).width() < 769
      $('.left_container').css("margin-left", "40px")
      $('.right_container').css("margin-right", "40px")
      
    else
      $('.right_container').css("margin-right", "0")
      $('.left_container').css("margin-left", "0")
  super_tooltip: ->
    $(".super_tooltip").tooltip(
      html: true
      placement: 'left'
    )
      
@Hlp.Auto =
  after_upload: ->
    Hlp.Load.close_assign_files()
    Hlp.Load.create_multi_select()
    Hlp.Load.assign_files_to()
    

    
    
  checklist_item_create: ->
    Hlp.Load.drag_color()
    Hlp.Load.create_multi_select()
    Hlp.Load.assign_files_to()
    Hlp.Load.check_checklist_item()
  


$ ->
  
  $(document).ajaxStart ->
    $('#loader').show()
  $(document).ajaxStop ->
    $('#loader').hide()
    
  $('.collapse').collapse({toggle: false})
  
  Hlp.Load.assign_files_to()
  Hlp.Load.new_checklist_input()    
  Hlp.Load.load_checklist_items()
  Hlp.Load.uploader_init()
  Hlp.Load.drag_color()
  Hlp.Load.assign_url_to_move_files()
  Hlp.Load.create_multi_select()
  Hlp.Load.check_checklist_item()
  Hlp.Load.show_doc_embed_file()
  Hlp.Load.change_td_example()
  Hlp.Load.chack_td_form()
  Hlp.Load.popover()
  Hlp.Load.createAutoClosingAlert()
  Hlp.Load.welcome_template_save()
  Hlp.Load.welcome_template_change()
  Hlp.Load.delete_contact_item()
  Hlp.Load.super_tooltip()
  Hlp.Load.checklists_sortable()
  #Hlp.Load.dashboard_sortable()
  
  $('.strip:visible:nth-child(3n)').addClass('newStrip')
  
  if $('.super_editable').length > 0
    $.fn.editable.defaults.mode = 'inline'
    $('.super_editable').editable()
  
  if $('.under_editable').length > 0
    $.fn.editable.defaults.mode = 'inline'
    $('.under_editable').editable()
  
  $("form").validate()
  $(".documentViewer").FlexPaperViewer config:
    PDFFile: "pdf/t5.pdf"
    RenderingOrder: "html5"
  
  $("#new_note").submit ->
    r = false
    $('.one_contact').each ->
      if $(this).is(':checked')
        r = true
    if r is true
      return true
    else
      Hlp.Load.growl_alert "Please check one or more contacts.", 'error'
      return false
    
  $("#user_user_id").change ->
    id = $(this).val()
    if id.length is 0
      false
    else
      url = "/users/switch_user?user_id=" + $(this).val()
      window.location = url
      
  $(".json_validate").bind "ajax:error", (evt, xhr, status, error) ->
    $form = $(this)
    errors = undefined
    errorText = undefined
    try
    
      # Populate errorText with the comment errors
      errors = $.parseJSON(xhr.responseText)
    catch err
    
      # If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
      errors = message: "Please reload the page and try again"
  
    # Build an unordered list from the list of errors
    errorText = "Error in \n"
    for error of errors
      errorText += error + ": " + errors[error] + "\n "
  
    # Insert error list into form
    Hlp.Load.growl_alert errorText, 'error'

    
  
  $(".datepicker").datepicker({format: "mm-dd-yyyy"})
  $(".transactions_inside").click ->
    Hlp.Load.growl_alert "This #{$(this).data('name')} can't be deleted because it has transactions associated with it.", 'error'
  Hlp.Load.docs_inside()
  
  
    
 
  $("[rel='tooltip']").tooltip()
  $(".add_an_note").click ->
    $(".add_an_note_well").toggle()
  $(".add_an_contact").click ->
    $(".add_an_contact_well").toggle()
  $(".add_an_note_hide").click ->
    $(".add_an_note_well").hide()
    return false

  $(window).resize ->
    Hlp.Load.on_resize()
  
  Hlp.Load.on_resize()

        
  $(".add_an_checklist").click ->
    $(".add_an_checklist_well").toggle()
    false
  $(".toggle_on").click ->
    $(".toggle_well").toggle()
    false
    
  $(".toggle_on_plans").click ->
    $(".toggle_well_plans").toggle()
    $(".toggle_well_plans").find(".upgrade_title").html($(this).data("title"))
    $("#user_company_plan").val($(this).data("plan"))
    $.scrollTo( "#card_well", 800, {offset: {top:-70, left:0}})
    
    false
  
  $(".create_contact_well_on").click ->
    $(".create_contact_well").toggle()
  
  $(".dashboard_edit_mode_on").click ->
    $(".dashboard_edit_mode_well").toggle()
    $(".create_contact_well").hide()
    $(".panel").toggleClass("nosortable_item")
    $(".panel").toggleClass("sortable_item")
    Hlp.Load.dashboard_sortable()
  
  $(".show_hide_details_a").click ->
    $(this).parents('tr').next().toggle()
    #$(".show_hide_details_well").toggle()
  $(".show_hide_details").click ->
    $(this).parents('table').find('.show_hide_details_well').toggle()
    #$(".show_hide_details_well").toggle()
    false
  $(".add_widget").click ->
    $(".add_widget_well").toggle()
    
  $(".add_dropbox").click ->
    $(".add_dropbox_well").toggle()
  
  $(".add_avatar").click ->
    $(".add_avatar_well").toggle()
  
  
  $(".all_contacts").click ->
    if $(this).is(':checked')
      $(".one_contact").prop('checked', true)
    else
      $(".one_contact").prop('checked', false)
      
  $(".all_docs").click ->
    if $(this).is(':checked')
      $(".one_doc").prop('checked', true)
    else
      $(".one_doc").prop('checked', false)
      
  $(".all_items").click ->
    if $(this).is(':checked')
      $(".one_item").prop('checked', true)
    else
      $(".one_item").prop('checked', false)
  
  
  $(".new_contact").click ->
    $(".new_contact_well").show()
  $(".outside_agents_btn").click ->
    $(".outside_agents_well").toggle()
    #$.scrollTo( '#contact_pluss_button', 800)
    
    
    return false
    
  $(".outside_agents").click ->
    $(".outside_agents_well").toggle()
    $.scrollTo( '#add_contact_id', 800)
    return false
    
  $(".well-light").mouseover ->
    #$(this).css("background-color", "#f3fbfe")
  $(".well-light").mouseout ->
    #$(this).css("background-color", "#FFFFFF")
  
  $(".contact_hidden_well_on").click ->
    $(".contact_hidden_well").toggle()
    $(".sc").toggle()
    Hlp.Load.toggle_contacts()
 
  $(".show_extended").click ->
    data_extended = $(this).data("extended")
    url = $(this).data("url")
    if $("##{data_extended}").length
      $("##{data_extended}").remove()
    else
      $.get(url)
  
  $(".contact_sort > th").click ->
    $(".contact_extended").remove()    
  
  $(".toggle_library_well").each ->
    $(this).css("cursor", "pointer")
    
  $(".calculator_transaction").slider().on 'slide', ->
    count_val = $(".calculator_transaction").slider('getValue').val()
    per_month = $(".calculator_transaction").data("month")
    included = $(".calculator_transaction").data("included")
    
    p = $(".calculator_transaction").data("price")
    price = per_month
    if (parseInt(count_val) is parseInt(included)) then price = per_month else price = (((count_val - included) * p) + per_month)
    $(".calculator_transaction_fee").html("$#{price}")

  $(".calculator_user").slider().on 'slide', ->
    count_val = $(".calculator_user").slider('getValue').val()
    included = $(".calculator_user").data("included")
    per_month = $(".calculator_user").data("month")
    p = $(".calculator_user").data("price")
    price = per_month
    if (parseInt(count_val) is parseInt(included)) then price = per_month else price = (((count_val - included) * p) + per_month)
    $(".calculator_user_fee").html("$#{price}")
  
  $(".toggle_library_well").click ->
    data_id = $(this).data("librarywell")
    $("##{data_id}").toggle()
   
  
  if $('#lock-transaction').length > 0
    $('a').attr("disabled", "disabled")
    $('button').attr("disabled", "disabled")
    $('input').attr("disabled", "disabled")
  
  $(".icon-arrow-down").click ->
    $(this).toggleClass("icon-arrow-down")
    $(this).toggleClass("icon-arrow-right")
  $(".icon-arrow-right").click ->
    $(this).toggleClass("icon-arrow-down")
    $(this).toggleClass("icon-arrow-right")
  $(".buyer_well_on").mouseover ->
    $(".buyer_well").show()
  $(".buyer_well_on").mouseout ->
    $(".buyer_well").hide()
  
  $('.save_transaction').click ->
    $('#transaction_form').submit()
    
  $('.open_subject').click ->
    subject = $(this).data('subject')
    $("#subject-message-#{subject}").toggle()
    return false

  #TRANSACTION STATUSES BEHAVIORS
  $("#transaction_transaction_status_id").change ->
    status_category = $("#transaction_transaction_status_id option:selected").text()
    if (status_category.indexOf("Pending") >= 0) or (status_category.indexOf("Closed") >= 0)
      $("#bhv_closing_date").text("Closing Date # (*) :")
      $("#transaction_close_sate").addClass("tdvalid")
    else
      $("#bhv_closing_date").text("Closing Date # :")
      $("#transaction_close_sate").removeClass("tdvalid")
      
  #DOCVIEWER
  

  #DYNAMIC TABLES
  if $("#dynamic_tables").length
    tr_a = $("#dynamic_tables").find("#table_a").find("tr").length
    tr_b = $("#dynamic_tables").find("#table_b").find("tr").length
    total_tr = tr_a + tr_b
    total_div = total_tr / 2
    
    if tr_a > tr_b
      total_a = tr_a - total_div
      $("#dynamic_tables").find("#table_a").find("tr").each (index) ->
        if index < total_a
          $("#table_b").find("tbody").prepend $(this)
          #$(this).hide()
    else
      total_b = tr_b - total_div
      $("#dynamic_tables").find("#table_b").find("tr").each (index) ->
         if index < total_b
           $("#table_a").find("tbody").append $(this)
           #$(this).hide()
      
    
      

  #ORDER WIDGETS
  

#  $("#widget_widget_type").change ->
#    widget_type = $(this).val()
#    $(".widget_hidden").hide()
#    if widget_type == "listings" || widget_type == "transactions_summary" || widget_type == "transactions_alosing" || widget_type == "transaction_added" || widget_type == "transactions_past"
#      $(".widget_hidden_0").show()
#    if widget_type == "transactions_alosing"
#      $(".widget_hidden_2").show()
#    if widget_type == "transaction_added" || widget_type == "transactions_past"
#      $(".widget_hidden_1").show()
#    if widget_type == "recent_activity"
#       $(".widget_hidden_3").show()
      
  $(document).on 'click', 'form .remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $(document).on 'click', 'form .add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
  $('.locked_checklist').each ->
    if $(this).find('input[type="checkbox"]').is(':checked') 
      $(this).find('a').attr('disabled', 'disabled')
      $(this).find('button').attr('disabled', 'disabled')
      #then alert 'Checked items are locked for this checklist type. You can uncheck it to make changes'
    return false
  $('.all_permissions').click ->
    if $(this).is(':checked')
      $(this).parent("li").parent("ul").find('input[type="checkbox"]').prop('checked', true)
    else
       $(this).parent("li").parent("ul").find('input[type="checkbox"]').prop('checked', false)
  
  $('.add_location_on').click ->
    $('.add_location_on_well').toggle() 
  $("#profile_slider").find(".slider").slider
    range: "min"
    min: 1
    max: 6
    value: 4
    animate: "slow"
    create: ->
      $('.ui-slider-handle').attr('title', '100 transactions per month')
      $('.ui-slider-handle').tooltip({trigger: 'manual', placement: 'top'})
      $('.ui-slider-handle').click -> 
        $('.ui-slider-handle').tooltip('show')
      $('.ui-slider-handle').tooltip('show')
    start: ->
      $('.ui-slider-handle').tooltip('hide')
    change: ->
      $('.ui-slider-handle').tooltip('show')
    stop: ->
      $('.ui-slider-handle').tooltip('show')
    slide: (event, ui) ->
      $('.plans').hide()
      
      $("#plan#{ui.value}").show()
      #$.post($('#user_tap_slider').data('update-url'), "user_tap[party_level]="+ui.value)
      
# ADMIN LOGIN
  users = $('#user_user_id').html()
  $('#user_company_id').change ->
    company = $('#user_company_id :selected').text()
    options = $(users).filter("optgroup[label='#{company}']").html()
    if options
      
      $('#user_user_id').html("<option>Select User</option>"+options)
    else
      $('#user_user_id').empty()
  $(".delete_account").click ->
    id = $(this).data("id")
    url = $(this).data("url")
    user_id = $(this).data("user_id")
    bootbox.prompt "Are you sure? Please confirm admin password", (result) ->
      if result is null
        true
      else
        window.location = "/users/#{id}/destroy_company?user_id=#{user_id}&password=#{result}"
        
      
window.onload = ->
  allowUnload = true
  if $(".cancel_after_close").length > 0
    window.onbeforeunload = (e) ->
    
      #allowUnload will allow us to see if user recently clicked something if so we wont allow the beforeunload.
      if allowUnload
      
        $(".cancel_after_close").each ->
          url = $(this).data('url')
          $.ajax
            type: "delete"
            dataType: 'script'
            url: url
            success: (data, textStatus, jqXHR) ->
      
        #message to be returned to the popup box.
        message = "You have uploaded one or more duplicate files. If you leave the page, the new upload will be canceled. Would you like to stay and overwrite the former file(-s) or cancel new upload?"
        e = e or window.event
        e.returnValue = message  if e # IE
        message # Safari

  
  # We need this to allow us to see if user has clicked anywhere if user has clicked we wont allow beforeunload to run.
  document.getElementsByTagName("body")[0].onclick = ->
    allowUnload = false
    
    #setTimeout so we can reset allowUnload incase user didn't leave the page but randomly clicked.
    setTimeout (->
      allowUnload = true
    ), 100
  
  $('[data-toggle="html-tooltip"]').tooltip({ html: true })
  
  $('[data-toggle="tooltip"]').tooltip()


  