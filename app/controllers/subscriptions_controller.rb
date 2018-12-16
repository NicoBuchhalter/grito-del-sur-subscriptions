class SubscriptionsController < ApplicationController
	def new
		@user = User.new
		render :new
	end
end