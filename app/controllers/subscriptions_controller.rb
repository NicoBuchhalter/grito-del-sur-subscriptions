class SubscriptionsController < ApplicationController
	include HTTParty

	base_uri 'https://api.mercadopago.com/v1'

	MERCADO_PAGO_ACCESS_TOKEN = Rails.application.secrets.mercado_pago[:access_token]

	def new
		render :new
	end

	def create
		user = User.find_or_create_by(email: params[:email])
		if user.mp_id.nil?
			User.update(mp_id: create_customer)
		end
		customer_id = user.mp_id
		assign_card_to_customer(customer_id)
		plan = Plan.find_by_description("Monthly premium package")
		subscription_id = subscribe_to_plan(customer_id, plan.mp_id)
		return render_error if subscription_id.nil?
		Subscription.create(user: user, plan: plan, mp_id: subscription_id)
		flash[:success] = 'Gracias por registrarse en El Grito del Sur!'
		render :new
	end

	private

	def render_error
		flash[:danger] = 'Sucedió un inconveniente. Por favor contacte a algún integrante del equipo del Grito del Sur'
		render :new
	end

	def create_customer
		options = { query: { access_token: MERCADO_PAGO_ACCESS_TOKEN }, body: { email: params[:email] }.to_json }
		self.class.post('/customers', options)['id']
	end

	def assign_card_to_customer(customer_id)
		options = { query: { access_token: MERCADO_PAGO_ACCESS_TOKEN}, body: { token: params[:token] }.to_json }
		self.class.post("/customers/#{customer_id}/cards", options)
	end

	def subscribe_to_plan(customer_id, plan_id)
		options = { query: { access_token: MERCADO_PAGO_ACCESS_TOKEN}, body: { plan_id: plan_id, payer: { id: customer_id }}.to_json }
		self.class.post('/subscriptions', options)['id']
	end
end