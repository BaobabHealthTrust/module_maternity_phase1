
class ClinicController < ApplicationController

	before_filter :check_user, :except => [:user_login, :user_logout, :missing_program, :static_locations,
    :missing_concept, :no_user, :no_patient, :project_users_list, :show_selected_fields, :check_role_activities,
    :missing_encounter_type, :diagnoses]

  def index

    User.current = User.find(@user["user_id"]) rescue nil

    Location.current = Location.find(params[:location_id] || session[:location_id]) rescue nil

    @location = Location.find(params[:location_id] || session[:location_id]) rescue nil

    session[:location_id] = @location.id if !@location.nil?
    
    redirect_to "/patients/show/#{params[:ext_patient_id]}?user_id=#{params[:user_id]}&location_id=#{
    params[:location_id]}" if !params[:ext_patient_id].nil?

    @project = get_global_property_value("project.name") rescue "Unknown"

    @facility = get_global_property_value("facility.name") rescue "Unknown"

    @patient_registration = get_global_property_value("patient.registration.url") rescue ""

    @link = get_global_property_value("user.management.url").to_s rescue nil

    if @link.nil?
      flash[:error] = "Missing configuration for <br/>user management connection!"

      redirect_to "/no_user" and return
    end

    @selected = YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env
        }"]["demographic.fields"].split(",") rescue []

  end

  def user_login

    link = get_global_property_value("user.management.url").to_s rescue nil

    if link.nil?
      flash[:error] = "Missing configuration for <br/>user management connection!"

      redirect_to "/no_user" and return
    end

    host = request.host_with_port rescue ""

    redirect_to "#{link}/login?ext=true&src=#{host}" and return if params[:ext_user_id].nil?

  end

  def user_logout

    link = get_global_property_value("user.management.url").to_s rescue nil


    if link.nil?
      flash[:error] = "Missing configuration for <br/>user management connection!"

      redirect_to "/no_user" and return
    end

    session[:datetime] = nil
    session[:location_id] = nil

    host = request.host_with_port rescue ""

    redirect_to "#{link}/logout/#{params[:id]}?ext=true&src=#{host}" and return if params[:ext_user_id].nil?

  end

  def set_datetime
  end

  def update_datetime
    unless params[:set_day]== "" or params[:set_month]== "" or params[:set_year]== ""
      # set for 1 second after midnight to designate it as a retrospective date
      date_of_encounter = Time.mktime(params[:set_year].to_i,
        params[:set_month].to_i,
        params[:set_day].to_i,0,0,1)
      session[:datetime] = date_of_encounter #if date_of_encounter.to_date != Date.today
    end

    redirect_to "/clinic?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}"
  end

  def reset_datetime
    session[:datetime] = nil
    redirect_to "/clinic?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}" and return
  end

  def administration

    @link = get_global_property_value("user.management.url").to_s rescue nil

    if @link.nil?
      flash[:error] = "Missing configuration for <br/>user management connection!"

      redirect_to "/no_user" and return
    end

    @host = request.host_with_port rescue ""

    render :layout => false
  end

  def my_account

    @link = get_global_property_value("user.management.url").to_s rescue nil

    if @link.nil?
      flash[:error] = "Missing configuration for <br/>user management connection!"

      redirect_to "/no_user" and return
    end
    
    @host = request.host_with_port rescue ""

    render :layout => false
  end

  def overview
    render :layout => false
  end

  def reports
    render :layout => false
  end

  def project_users
    render :layout => false
  end

  def project_users_list
    users = User.find(:all, :conditions => ["username LIKE ? AND user_id IN (?)", "#{params[:username]}%",
        UserProperty.find(:all, :conditions => ["property = 'Status' AND property_value = 'ACTIVE'"]
        ).map{|user| user.user_id}], :limit => 50)

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    result = users.collect { |user|
      [
        user.id,
        (user.user_properties.find_by_property("#{@project}.activities").property_value.split(",") rescue nil),
        (user.user_properties.find_by_property("Last Name").property_value rescue nil),
        (user.user_properties.find_by_property("First Name").property_value rescue nil),
        user.username
      ]
    }

    render :text => result.to_json
  end

  def add_to_project

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    unless params[:target].nil? || @project.nil?
      user = User.find(params[:target]) rescue nil

      unless user.nil?
        UserProperty.create(
          :user_id => user.id,
          :property => "#{@project}.activities",
          :property_value => ""
        )
      end
    end
    
    redirect_to "/project_users_list" and return
  end

  def remove_from_project

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    unless params[:target].nil? || @project.nil?
      user = User.find(params[:target]) rescue nil

      unless user.nil?
        user.user_properties.find_by_property("#{@project}.activities").delete
      end
    end
    
    redirect_to "/project_users_list" and return
  end

  def manage_activities

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    unless @project.nil?
      @users = UserProperty.find_all_by_property("#{@project}.activities").collect { |user| user.user_id }
    
      @roles = UserRole.find(:all, :conditions => ["user_id IN (?)", @users]).collect { |role| role.role }.sort.uniq

    end

  end

  def check_role_activities
    activities = {}

    if File.exists?("#{Rails.root}/config/protocol_task_flow.yml")
      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["clinical.encounters.sequential.list"].split(",").each{|activity|
        
        activities[activity.titleize] = 0

      } rescue nil
    end
      
    role = params[:role].downcase.gsub(/\s/,".") rescue nil

    unless File.exists?("#{Rails.root}/config/roles")
      Dir.mkdir("#{Rails.root}/config/roles")
    end

    unless role.nil?
      if File.exists?("#{Rails.root}/config/roles/#{role}.yml")
        YAML.load_file("#{Rails.root}/config/roles/#{role}.yml")["#{Rails.env
        }"]["activities.list"].split(",").compact.each{|activity|

          activities[activity.titleize] = 1

        } rescue nil
      end
    end

    render :text => activities.to_json
  end

  def create_role_activities
    activities = []
    
    role = params[:role].downcase.gsub(/\s/,".") rescue nil
    activity = params[:activity] rescue nil

    unless File.exists?("#{Rails.root}/config/roles")
      Dir.mkdir("#{Rails.root}/config/roles")
    end

    unless role.nil? || activity.nil?

      file = "#{Rails.root}/config/roles/#{role}.yml"

      activities = YAML.load_file(file)["#{Rails.env
        }"]["activities.list"].split(",") rescue []

      activities << activity

      activities = activities.map{|a| a.upcase}.uniq

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    activities.list: #{activities.uniq.join(",")}")

      f.close

    end
    
    activities = {}

    if File.exists?("#{Rails.root}/config/protocol_task_flow.yml")
      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["clinical.encounters.sequential.list"].split(",").each{|activity|

        activities[activity.titleize] = 0

      } rescue nil
    end

    YAML.load_file("#{Rails.root}/config/roles/#{role}.yml")["#{Rails.env
        }"]["activities.list"].split(",").each{|activity|

      activities[activity.titleize] = 1

    } rescue nil

    render :text => activities.to_json
  end

  def remove_role_activities
    activities = []

    role = params[:role].downcase.gsub(/\s/,".") rescue nil
    activity = params[:activity] rescue nil

    unless File.exists?("#{Rails.root}/config/roles")
      Dir.mkdir("#{Rails.root}/config/roles")
    end

    unless role.nil? || activity.nil?

      file = "#{Rails.root}/config/roles/#{role}.yml"

      activities = YAML.load_file(file)["#{Rails.env
        }"]["activities.list"].split(",").map{|a| a.upcase} rescue []

      activities = activities - [activity.upcase]

      activities = activities.map{|a| a.titleize}.uniq

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    activities.list: #{activities.uniq.join(",")}")

      f.close

    end

    activities = {}

    if File.exists?("#{Rails.root}/config/protocol_task_flow.yml")
      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["clinical.encounters.sequential.list"].split(",").each{|activity|

        activities[activity.titleize] = 0

      } rescue nil
    end

    YAML.load_file("#{Rails.root}/config/roles/#{role}.yml")["#{Rails.env
        }"]["activities.list"].split(",").each{|activity|

      activities[activity.titleize] = 1

    } rescue nil

    render :text => activities.to_json
  end

  def project_members    
  end

  def my_activities    
  end

  def check_user_activities
    activities = {}

    @user["roles"].each do |role|

      role = role.downcase.gsub(/\s/,".") rescue nil

      if File.exists?("#{Rails.root}/config/roles/#{role}.yml")

        YAML.load_file("#{Rails.root}/config/roles/#{role}.yml")["#{Rails.env
        }"]["activities.list"].split(",").each{|activity|

          activities[activity.titleize] = 0 if activity.downcase.match("^" +
              (!params[:search].nil? ? params[:search].downcase : ""))

        } rescue nil

      end
    
    end

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    unless @project.nil?
      
      UserProperty.find_by_user_id_and_property(@user["user_id"],
        "#{@project}.activities").property_value.split(",").each{|activity|
        
        activities[activity.titleize] = 1 if activity.downcase.match("^" +
            (!params[:search].nil? ? params[:search].downcase : "")) and !activities[activity.titleize].nil?

      }

    end
    
    render :text => activities.to_json
  end

  def create_user_activity

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    unless @project.nil? || params[:activity].nil?

      user = UserProperty.find_by_user_id_and_property(@user["user_id"],
        "#{@project}.activities")

      unless user.nil?
        properties = user.property_value.split(",")

        properties << params[:activity]

        properties = properties.map{|p| p.upcase}.uniq

        user.update_attribute("property_value", properties.join(","))

      else

        UserProperty.create(
          :user_id => @user["user_id"],
          :property => "#{@project}.activities",
          :property_value => params[:activity]
        )

      end

    end
    
    activities = {}

    @user["roles"].each do |role|

      role = role.downcase.gsub(/\s/,".") rescue nil

      if File.exists?("#{Rails.root}/config/roles/#{role}.yml")

        YAML.load_file("#{Rails.root}/config/roles/#{role}.yml")["#{Rails.env
        }"]["activities.list"].split(",").each{|activity|

          activities[activity.titleize] = 0 if activity.downcase.match("^" +
              (!params[:search].nil? ? params[:search].downcase : ""))

        } rescue nil

      end

    end

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    unless @project.nil?

      UserProperty.find_by_user_id_and_property(@user["user_id"],
        "#{@project}.activities").property_value.split(",").each{|activity|

        activities[activity.titleize] = 1

      }

    end

    render :text => activities.to_json
  end

  def remove_user_activity

    @project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    unless @project.nil? || params[:activity].nil?

      user = UserProperty.find_by_user_id_and_property(@user["user_id"],
        "#{@project}.activities")

      unless user.nil?
        properties = user.property_value.split(",").map{|p| p.upcase}.uniq

        properties = properties - [params[:activity].upcase]

        user.update_attribute("property_value", properties.join(","))
      end

    end

    activities = {}

    @user["roles"].each do |role|

      role = role.downcase.gsub(/\s/,".") rescue nil

      if File.exists?("#{Rails.root}/config/roles/#{role}.yml")

        YAML.load_file("#{Rails.root}/config/roles/#{role}.yml")["#{Rails.env
        }"]["activities.list"].split(",").each{|activity|

          activities[activity.titleize] = 0 if activity.downcase.match("^" +
              (!params[:search].nil? ? params[:search].downcase : ""))

        } rescue nil

      end

    end

    unless @project.nil?

      UserProperty.find_by_user_id_and_property(@user["user_id"],
        "#{@project}.activities").property_value.split(",").each{|activity|

        activities[activity.titleize] = 1

      }

    end

    render :text => activities.to_json
  end

  def demographics_fields
  end

  def show_selected_fields
    fields = ["Middle Name", "Maiden Name", "Home of Origin", "Current District",
      "Current T/A", "Current Village", "Landmark or Plot", "Cell Phone Number",
      "Office Phone Number", "Home Phone Number", "Occupation", "Nationality"]

    selected = YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env
        }"]["demographic.fields"].split(",") rescue []

    @fields = {}

    fields.each{|field|
      if selected.include?(field)
        @fields[field] = 1
      else
        @fields[field] = 0
      end
    }
    
    render :text => @fields.to_json
  end

  def remove_field
    initial = YAML.load_file("#{Rails.root}/config/application.yml").to_hash rescue {}

    demographics = initial["#{Rails.env}"]["demographic.fields"].split(",") rescue []

    demographics = demographics - [params[:target]]

    initial["#{Rails.env}"]["demographic.fields"] = demographics.join(",")

    File.open("#{Rails.root}/config/application.yml", "w+") { |f| f.write(initial.to_yaml) }

    fields = ["Middle Name", "Maiden Name", "Home of Origin", "Current District",
      "Current T/A", "Current Village", "Landmark or Plot", "Cell Phone Number",
      "Office Phone Number", "Home Phone Number", "Occupation", "Nationality"]

    selected = YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env
        }"]["demographic.fields"].split(",") rescue []

    @fields = {}

    fields.each{|field|
      if selected.include?(field)
        @fields[field] = 1
      else
        @fields[field] = 0
      end
    }

    render :text => @fields.to_json
  end

  def add_field
    initial = YAML.load_file("#{Rails.root}/config/application.yml").to_hash rescue {}

    demographics = initial["#{Rails.env}"]["demographic.fields"].split(",") rescue []

    demographics = demographics + [params[:target]]

    initial["#{Rails.env}"]["demographic.fields"] = demographics.join(",")

    File.open("#{Rails.root}/config/application.yml", "w+") { |f| f.write(initial.to_yaml) }

    fields = ["Middle Name", "Maiden Name", "Home of Origin", "Current District",
      "Current T/A", "Current Village", "Landmark or Plot", "Cell Phone Number",
      "Office Phone Number", "Home Phone Number", "Occupation", "Nationality"]

    selected = YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env
        }"]["demographic.fields"].split(",") rescue []

    @fields = {}

    fields.each{|field|
      if selected.include?(field)
        @fields[field] = 1
      else
        @fields[field] = 0
      end
    }

    render :text => @fields.to_json
  end

end
