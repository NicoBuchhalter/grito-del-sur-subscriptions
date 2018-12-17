$(document).ready ->

	mercado_pago_token = $('#mp_token').attr('data')

	Mercadopago.setPublishableKey(mercado_pago_token);

	Mercadopago.getIdentificationTypes()


	addEvent = (el, eventName, handler) ->
	  if el.addEventListener
	    el.addEventListener eventName, handler
	  else
	    el.attachEvent 'on' + eventName, ->
	      handler.call el
	      return
	  return

	getBin = ->
	  ccNumber = document.querySelector('input[data-checkout="cardNumber"]')
	  ccNumber.value.replace(/[ .-]/g, '').slice 0, 6

	guessingPaymentMethod = (event) ->
	  bin = getBin()
	  if event.type == 'keyup'
	    if bin.length >= 6
	      Mercadopago.getPaymentMethod { 'bin': bin }, setPaymentMethodInfo
	  else
	    setTimeout (->
	      if bin.length >= 6
	        Mercadopago.getPaymentMethod { 'bin': bin }, setPaymentMethodInfo
	      return
	    ), 100
	  return

	setPaymentMethodInfo = (status, response) ->
	  if status == 200
	    # do somethings ex: show logo of the payment method
	    form = document.querySelector('#pay')
	    if document.querySelector('input[name=paymentMethodId]') == null
	      paymentMethod = document.createElement('input')
	      paymentMethod.setAttribute 'name', 'paymentMethodId'
	      paymentMethod.setAttribute 'type', 'hidden'
	      paymentMethod.setAttribute 'value', response[0].id
	      form.appendChild paymentMethod
	    else
	      document.querySelector('input[name=paymentMethodId]').value = response[0].id
	  return

  doPay = (event) ->
	  event.preventDefault()
	  if !doSubmit
	    $form = document.querySelector('#pay')
	    console.log($form)
	    Mercadopago.createToken $form, sdkResponseHandler
	    # The function "sdkResponseHandler" is defined below
	    return false
	  return

	sdkResponseHandler = (status, response) ->
	  if status != 200 and status != 201
	    alert 'Hubo un error con su tarjeta. Verifique que haya ingresado los datos correctamente'
	  else
	    form = document.querySelector('#pay')
	    card = document.createElement('input')
	    card.setAttribute 'name', 'token'
	    card.setAttribute 'type', 'hidden'
	    card.setAttribute 'value', response.id
	    form.appendChild card
	    doSubmit = true
	    form.submit()
	  return 


	addEvent document.querySelector('input[data-checkout="cardNumber"]'), 'keyup', guessingPaymentMethod
	addEvent document.querySelector('input[data-checkout="cardNumber"]'), 'change', guessingPaymentMethod

	doSubmit = false
	addEvent document.querySelector('#pay'), 'submit', doPay
