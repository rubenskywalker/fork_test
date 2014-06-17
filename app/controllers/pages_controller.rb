class PagesController < ApplicationController
	
	skip_before_filter :authenticate_user!
	
	layout "marketing"
	
	def index
		
	end
	
end
