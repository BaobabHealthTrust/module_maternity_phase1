
class ApplicationController < ActionController::Base
  helper :all

 def get_global_property_value(global_property)
		property_value = Settings[global_property]
		if property_value.nil?
			property_value = GlobalProperty.find(:first, :conditions => {:property => "#{global_property}"}
      ).property_value rescue nil
		end
		return property_value
	end

  def create_from_dde_server
    get_global_property_value('create.from.dde.server').to_s == "true" rescue false
  end

  def print_and_redirect(print_url, redirect_url, message = "Printing, please wait...", show_next_button = false, patient_id = nil)
    @print_url = print_url
    @redirect_url = redirect_url
    @message = message
    @show_next_button = show_next_button
    @patient_id = patient_id
    render :template => 'print/print', :layout => nil
  end

  protected

  def check_user
		
		internal = ""
		
    link = get_global_property_value("user.management.url").to_s rescue nil
		
    if link.nil?
      flash[:error] = "Missing configuration for <br/>user management connection!"

      redirect_to "/no_user" and return
    end
    
    host = request.raw_host_with_port.gsub("localhost", "0.0.0.0").gsub("127.0.0.1", "0.0.0.0")
    ref_host = request.referrer.gsub("localhost", "0.0.0.0").gsub("127.0.0.1", "0.0.0.0") 
    
    if (ref_host.match("#{host}") || ref_host.length < 4)
    	internal = "true"		
		else
			internal = "false"
			#systems running as independent applications
			@user = JSON.parse(RestClient.get("#{link}/verify/#{(params[:user_id])}")) if @user.blank? #rescue {}		
		end

		if internal == "true" || @user.blank?
			
			if params[:user_id].blank? || (params[:user_id] && User.find(params[:user_id]).blank?)

				# Track final destination
				file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/current.path.yml"

				f = File.open(file, "w")

				f.write("#{Rails.env}:\n    current.path: #{request.referrer}")

				f.close
		
				if (@user.empty? rescue true)	    
				  redirect_to "/user_login?internal=true" and return
				end 

				if @user["token"].blank?
				  redirect_to "/user_login?internal=true" and return
				end
						
				@location = CoreLocation.find(params[:location_id]) rescue nil
				
			end
			
			@user = User.find(params[:user_id]) rescue nil
		
    end
  
  end

end
