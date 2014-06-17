jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#upgrade_form').submit (e)->
      e.preventDefault()
      $('input[type=submit]').attr('disabled', true)
      subscription.processCard()
  
  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#user_stripe_card_token').val(response.id)
      card = $('#card_number').val()
      $("#user_card_four").val("#{card[card.length-4]}#{card[card.length-3]}#{card[card.length-2]}#{card[card.length-1]}")
      $('#upgrade_form')[0].submit()
    else
      alert(response.error.message)
      $('input[type=submit]').attr('disabled', false)
