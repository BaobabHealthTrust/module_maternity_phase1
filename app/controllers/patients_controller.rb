
class PatientsController < ApplicationController

  def show
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil

    if @patient.nil?
      redirect_to "/encounters/no_patient" and return
    end

    if params[:user_id].nil?
      redirect_to "/encounters/no_user" and return
    end

    @user = User.find(params[:user_id]) rescue nil
    
    redirect_to "/encounters/no_user" and return if @user.nil?

    @task = TaskFlow.new(params[:user_id], @patient.id)

    @links = {}

    @task.display_tasks.each{|task|

      unless task.class.to_s.upcase == "ARRAY"

        next if task.downcase == "update baby outcome" and @patient.current_babies.length == 0

        @links[task.titleize] = "/protocol_patients/#{task.gsub(/\s/, "_").downcase}?patient_id=#{
        @patient.id}&user_id=#{params[:user_id]}" + (task.downcase == "update baby outcome" ?
            "&baby=1&baby_total=#{@patient.current_babies.length}" : "")

      else

        @links[task[0].titleize] = {}

        task[1].each{|t|
          @links[task[0].titleize][t.titleize] = "/protocol_patients/#{t.gsub(/\s/, "_").downcase}?patient_id=#{
          @patient.id}&user_id=#{params[:user_id]}" + (t.downcase == "update baby outcome" ?
              "&baby=1&baby_total=#{@patient.current_babies.length}" : "")
        }

      end
            
    }

    # raise @links.inspect

    @project = get_global_property_value("project.name") rescue "Unknown"

    @demographics_url = get_global_property_value("patient.registration.url") rescue nil

    if !@demographics_url.nil?
      @demographics_url = @demographics_url + "/demographics/#{@patient.id}?user_id=#{@user.id}&ext=true"
    end

    @task.next_task

    @babies = @patient.current_babies rescue []

  end

  def current_visit
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil

    ProgramEncounter.current_date = (session[:date_time] || Time.now)
    
    @programs = @patient.program_encounters.current.collect{|p|

      [
        p.id,
        p.to_s,
        p.program_encounter_types.collect{|e|
          [
            e.encounter_id, e.encounter.type.name,
            e.encounter.encounter_datetime.strftime("%H:%M"),
            e.encounter.creator
          ]
        },
        p.date_time.strftime("%d-%b-%Y")
      ]
    } if !@patient.nil?

    # raise @programs.inspect

    render :layout => false
  end

  def visit_history
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil

    @programs = @patient.program_encounters.find(:all, :order => ["date_time DESC"]).collect{|p|

      [
        p.id,
        p.to_s,
        p.program_encounter_types.collect{|e|
          [
            e.encounter_id, e.encounter.type.name,
            e.encounter.encounter_datetime.strftime("%H:%M"),
            e.encounter.creator
          ]
        },
        p.date_time.strftime("%d-%b-%Y")
      ]
    } if !@patient.nil?

    # raise @programs.inspect

    render :layout => false
  end

  def demographics
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil

    @demographics_url = get_global_property_value("patient.registration.url") rescue nil

    if !@demographics_url.nil?
      @demographics_url = @demographics_url + "/demographics/#{@patient.id}?user_id=#{@user.id}&ext=true"
    end

    if @patient.nil?
      redirect_to "/encounters/no_patient" and return
    end

    if params[:user_id].nil?
      redirect_to "/encounters/no_user" and return
    end

    @user = User.find(params[:user_id]) rescue nil

    redirect_to "/encounters/no_user" and return if @user.nil?

  end

  def number_of_booked_patients
    date = params[:date].to_date
    encounter_type = EncounterType.find_by_name('Kangaroo review visit') rescue nil
    concept_id = ConceptName.find_by_name('APPOINTMENT DATE').concept_id

    count = Observation.count(:all,
      :joins => "INNER JOIN encounter e USING(encounter_id)",:group => "value_datetime",
      :conditions =>["concept_id = ? AND encounter_type = ? AND value_datetime >= ? AND value_datetime <= ?",
        concept_id,encounter_type.id,date.strftime('%Y-%m-%d 00:00:00'),date.strftime('%Y-%m-%d 23:59:59')]) rescue nil

    count = count.values unless count.blank?
    count = '0' if count.blank?

    render :text => (count.first.to_i > 0 ? {params[:date] => count}.to_json : 0)
  end
  def relation_type
    #search_string = params[:search_string]
    relation = ["Mother",
      "Husband",
      "Sister",
      "Friend",
      "Aunt",
      "Neighbour",
      "Mother-in-law",
      "Landlord/Landlady",
      "Other"]

    @relation = Observation.find(:all, :joins => [:concept, :encounter],
      :conditions => ["obs.concept_id = ? AND NOT value_text IN (?) AND " +
          "encounter_type = ?",
        ConceptName.find_by_name("OTHER RELATIVE").concept_id, relation,
        EncounterType.find_by_name("SOCIAL HISTORY").id]).collect{|o| o.value_text}

    @relation = relation + @relation
    @relation = @relation.collect{|rel| rel.gsub('-', ' ').gsub('_', ' ').squish.titleize}.uniq
    @relation = @relation.collect{|rel| rel if rel.downcase.include?(search_string.downcase)}
    render :text => "<li></li><li>" + @relation.join("</li><li>") + "</li>"
  end

  def general_demographics

    @patient = Patient.find(params[:id]) || Patient.find(params[:patient_id])
    @children = @patient.current_babies rescue []
    @anc_patient = ANCService::ANC.new(@patient)
    @maternity_patient = MaternityService::Maternity.new(@patient) rescue nil
    @patient_registration = get_global_property_value("patient.registration.url") rescue ""

    if params[:ext_patient_id]

      relationship = RelationshipType.find_by_b_is_to_a("Spouse/Partner").id

      Relationship.create(
        :person_a => params[:id],
        :person_b => params[:ext_patient_id],
        :relationship => relationship)

    end

    #raise @children.to_yaml
    render :layout => false
  end

  def birth_report
    
    @patient = Patient.find(params[:patient_id]) rescue nil
    
    @person = Patient.find(params[:id] || params[:person_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@person) rescue nil
   
  end

  def birth_report_printable
 
    @patient = Patient.find(params[:patient_id]) rescue nil
    @person = Patient.find(params[:id] || params[:person_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@person) rescue nil	
	    

    mother_id = Relationship.find(:all, :conditions => ["person_a = ? AND relationship = ?", @person.id, RelationshipType.find_by_b_is_to_a("Parent").id]).collect{|r| r.person_b if Person.find(r.person_b).gender.match(/f/i)}.first rescue nil

    @mother = Patient.find(mother_id) rescue nil

    @anc_mother = ANCService::ANC.new(@mother) rescue nil

    @maternity_mother = MaternityService::Maternity.new(@mother) rescue nil

    father_id = @maternity_mother.husband.person_b rescue nil
   
    @father = Patient.find(father_id) rescue nil

    @anc_father = ANCService::ANC.new(@father) rescue nil
    
    @serial_number = PatientIdentifier.find(:first, :conditions => ["patient_id = ? AND identifier_type = ?",
        @person.id,
        PatientIdentifierType.find_by_name("Serial Number").id]).identifier rescue "?"

    #user = PersonName.find_by_person_id(User.find(params[:user_id]).person_id) rescue nil
	
    #@provider_name = user.given_name.split("")[0].upcase + ".  " + user.family_name.humanize if user
    @provider_name = User.find(params[:user_id]).name
  
    @facility = get_global_property_value("facility.name")

    @district = get_global_property_value("current_district") rescue ''

    maternity = MaternityService::Maternity.new(@patient) rescue nil

    data = maternity.export_person((params[:user_id] rescue 1), @facility, @district)

    # data = data.delete_blank

    # Due to space limitation, no father demographics on barcode for now
    # data.delete("father")

    # data_w_father = data

    # @qr = RQRCode::QRCode.new(data_w_father.to_json, :size => 40, :level => :h)

    render :layout => false
  end

  def print_note
    location = request.remote_ip rescue ""
    
    @patient    = Patient.find(params[:patient_id] || params[:id] || session[:patient_id]) rescue nil
    person_id = params[:id] || params[:person_id]
    if @patient
      current_printer = ""

      wards = GlobalProperty.find_by_property("facility.ward.printers").property_value.split(",") rescue []

      printers = wards.each{|ward|
        current_printer = ward.split(":")[1] if ward.split(":")[0].upcase == location
      } rescue []
      ["ORIGINAL FOR:(PARENT)", "DUPLICATE FOR DISTRICT:REGISTRY OF BIRTH", "TRIPLICATE FOR DISTRICT:REGISTRY OF ORIGINAL HOME", "QUADRUPLICATE FOR:THE HOSPITAL", ""].each do |rec|

        @recipient = rec
        name = rec.split(":").last.downcase.gsub("(", "").gsub(")", "") if !rec.blank?
     
        t1 = Thread.new{
          Kernel.system "wkhtmltopdf --zoom 0.8 -s A4 http://" +
            request.env["HTTP_HOST"] + "\"/patients/birth_report_printable/" +
            person_id.to_s + "?patient_id=#{@patient.id}&person_id=#{person_id}&user_id=#{params[:user_id]}&recipient=#{@recipient}" + "\" /tmp/output-#{Regexp.escape(name)}" + ".pdf \n"
        } if !rec.blank?

        t2 = Thread.new{
          sleep(2)
          Kernel.system "lp #{(!current_printer.blank? ? '-d ' + current_printer.to_s : "")} /tmp/output-#{Regexp.escape(name)}" + ".pdf\n"
        } if !rec.blank?

        t3 = Thread.new{
          sleep(3)
          Kernel.system "rm /tmp/output-#{Regexp.escape(name)}"+ ".pdf\n"
        }if !rec.blank?
        sleep(1)
      end
     
    end
    redirect_to "/patients/birth_report/#{person_id}?person_id=#{person_id}&patient_id=#{params[:patient_id]}&user_id=#{params[:user_id]}" and return
  end

  def send_birth_report
    
    facility = get_global_property_value("facility.name") rescue ''

    district = get_global_property_value("current_district") rescue ''

    patient = Patient.find(params[:id]) rescue nil
  
    maternity = MaternityService::Maternity.new(patient) rescue nil
    user = User.find(params[:user_id]).id rescue nil
    
    data = maternity.export_person(user, facility, district)

    uri = get_global_property_value("birth_registration_url") rescue nil

    result = RestClient.post(uri, data) rescue "birth report couldnt be sent"
        
    if ((result.downcase rescue "") == "baby added") and params[:update].nil?
      flash[:error] = "Birth Report Sent"
      BirthReport.create(:person_id => params[:id])
    else
      flash[:error] = "Sending failed. Check configurations and make sure you are not resending"
    end

    redirect_to "/patients/birth_report/#{params[:id]}?person_id=#{params[:id]}&user_id=#{params[:user_id]}&patient_id=#{params[:patient_id]}&today=1" and return
  end

  def void
    @relationship = Relationship.find(params[:id])
    @relationship.void
    head :ok
  end

  def provider_details
    @patient = Patient.find(params[:patient_id])
    @person = Person.find(params[:person_id])
    
    @name = Person.find(User.find(params[:user_id]).id).name rescue " "

    @facility = get_global_property_value("facility.name") rescue ''

    @district = get_global_property_value("current_district") rescue ''

  end

  def create_provider
    @patient = Patient.find(params[:person_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@patient) rescue nil

    if !params[:HospitalDate].nil? && !params[:HospitalDate].blank?
      @anc_patient.set_attribute("Hospital Date", params[:HospitalDate])
    end

    if !params[:Hospital].nil? && !params[:Hospital].blank?
      @anc_patient.set_attribute("Health Center", params[:Hospital])
    end

    if !params[:district].nil? && !params[:district].blank?
      @anc_patient.set_attribute("Health District", get_global_property_value("current_district"))
    end

    if !params[:ProviderTitle].nil? && !params[:ProviderTitle].blank?
      @anc_patient.set_attribute("Provider Title", params[:ProviderTitle])
    end

    if !params[:ProviderName].nil? && !params[:ProviderName].blank?
      @anc_patient.set_attribute("Provider Name", params[:ProviderName])
    end
    redirect_to "/patients/birth_report/#{params[:person_id]}?person_id=#{params[:person_id]}&patient_id=#{params[:patient_id]}&user_id=#{params[:user_id]}"
  end
  
  
end
