
class EncountersController < ApplicationController

  def create

    if params["proc_check"] && (params["concept"]["Procedure Done"].blank? || params["concept"]["Procedure Done"].downcase == "none")

      redirect_to "/patients/show/#{params[:patient_id]}?user_id=#{params[:user_id]}" and return
    end
   
    patient = Patient.find(params[:patient_id]) rescue nil

    if !patient.nil?
      if params[:baby_check].blank?
        type = EncounterType.find_by_name(params[:encounter_type]).id rescue nil

        if !type.nil?
          @encounter = Encounter.create(
            :patient_id => patient.id,
            :provider_id => (params[:user_id]),
            :encounter_type => type,
            :location_id => (session[:location_id] || params[:location_id])
          )

          @current = nil
        
          if !params[:program].blank?

            @program = Program.find_by_concept_id(ConceptName.find_by_name(params[:program]).concept_id) rescue nil

            if !@program.nil?

              @program_encounter = ProgramEncounter.find_by_program_id(@program.id,
                :conditions => ["patient_id = ? AND DATE(date_time) = ?",
                  patient.id, Date.today.strftime("%Y-%m-%d")])

              if @program_encounter.blank?

                @program_encounter = ProgramEncounter.create(
                  :patient_id => patient.id,
                  :date_time => Time.now,
                  :program_id => @program.id
                )

              end

              ProgramEncounterDetail.create(
                :encounter_id => @encounter.id.to_i,
                :program_encounter_id => @program_encounter.id,
                :program_id => @program.id
              )

              @current = PatientProgram.find_by_program_id(@program.id,
                :conditions => ["patient_id = ? AND COALESCE(date_completed, '') = ''", patient.id])

              if @current.blank?

                @current = PatientProgram.create(
                  :patient_id => patient.id,
                  :program_id => @program.id,
                  :date_enrolled => Time.now
                )

              end

            else
            
              redirect_to "/encounters/missing_program?program=#{params[:program]}" and return

            end

          end

          (params[:concept] || []).each do |key, value|

            if value.blank?
              next
            end

            if value.class.to_s.downcase != "array"

              concept = ConceptName.find_by_name(key.strip).concept_id rescue nil

              if !concept.nil? and !value.blank?

                if !@program.nil? and !@current.nil?
                
                  selected_state = @program.program_workflows.map(&:program_workflow_states).flatten.select{|pws|
                    pws.concept.fullname.upcase() == value.upcase()
                  }.first rescue nil
                
                  @current.transition({
                      :state => "#{value}",
                      :start_date => Time.now,
                      :end_date => Time.now
                    }) if !selected_state.nil?
                end
              
                concept_type = nil
                if value.strip.match(/^\d+$/)

                  concept_type = "number"

                elsif value.strip.match(/^\d{4}-\d{2}-\d{2}$/)

                  concept_type = "date"

                elsif value.strip.match(/^\d{2}\:\d{2}\:\d{2}$/)

                  concept_type = "time"

                else

                  value_coded = ConceptName.find_by_name(value.strip) rescue nil

                  if !value_coded.nil?

                    concept_type = "value_coded"

                  else

                    concept_type = "text"

                  end

                end
              
                obs = Observation.create(
                  :person_id => @encounter.patient_id,
                  :concept_id => concept,
                  :location_id => @encounter.location_id,
                  :obs_datetime => @encounter.encounter_datetime,
                  :encounter_id => @encounter.id
                )

                case concept_type
                when "date"

                  obs.update_attribute("value_datetime", value)

                when "time"

                  obs.update_attribute("value_datetime", "#{Date.today.strftime("%Y-%m-%d")} " + value)

                when "number"

                  obs.update_attribute("value_numeric", value)

                when "value_coded"

                  obs.update_attribute("value_coded", value_coded.concept_id)
                  obs.update_attribute("value_coded_name_id", value_coded.concept_name_id)

                else

                  obs.update_attribute("value_text", value)
                
                end

              else

                redirect_to "/encounters/missing_concept?concept=#{key}" and return if !value.blank?

              end

            else

              value.each do |item|

                concept = ConceptName.find_by_name(key.strip).concept_id rescue nil

                if !concept.nil? and !item.blank?

                  if !@program.nil? and !@current.nil?
                    selected_state = @program.program_workflows.map(&:program_workflow_states).flatten.select{|pws|
                      pws.concept.fullname.upcase() == item.upcase()
                    }.first rescue nil

                    @current.transition({
                        :state => "#{item}",
                        :start_date => Time.now,
                        :end_date => Time.now
                      }) if !selected_state.nil?
                  end
              
                  concept_type = nil
                  if item.strip.match(/^\d+$/)

                    concept_type = "number"

                  elsif item.strip.match(/^\d{4}-\d{2}-\d{2}$/)

                    concept_type = "date"

                  elsif item.strip.match(/^\d{2}\:\d{2}\:\d{2}$/)

                    concept_type = "time"

                  else

                    value_coded = ConceptName.find_by_name(item.strip) rescue nil

                    if !value_coded.nil?

                      concept_type = "value_coded"

                    else

                      concept_type = "text"

                    end

                  end

                  obs = Observation.create(
                    :person_id => @encounter.patient_id,
                    :concept_id => concept,
                    :location_id => @encounter.location_id,
                    :obs_datetime => @encounter.encounter_datetime,
                    :encounter_id => @encounter.id
                  )

                  case concept_type
                  when "date"

                    obs.update_attribute("value_datetime", item)

                  when "time"

                    obs.update_attribute("value_datetime", "#{Date.today.strftime("%Y-%m-%d")} " + item)

                  when "number"

                    obs.update_attribute("value_numeric", item)

                  when "value_coded"

                    obs.update_attribute("value_coded", value_coded.concept_id)
                    obs.update_attribute("value_coded_name_id", value_coded.concept_name_id)

                  else

                    obs.update_attribute("value_text", item)

                  end

                else

                  redirect_to "/encounters/missing_concept?concept=#{item}" and return if !item.blank?

                end

              end

            end

          end

        else

          redirect_to "/encounters/missing_encounter_type?encounter_type=#{params[:encounter_type]}" and return

        end
      end
      if params[:encounter_type].downcase.strip == "baby delivery" && !params["concept"]["Time of delivery"].nil?

        baby = Baby.new(params[:user_id], params[:patient_id], session[:location_id], (session[:datetime] || Date.today))

        mother = Person.find(params[:patient_id]) rescue nil

        link = get_global_property_value("patient.registration.url").to_s rescue nil
			
        children = Relationship.find(:all, :conditions => ["person_a = ? AND relationship = ?", params[:patient_id], RelationshipType.find_by_a_is_to_b("Parent").id])

				first_name = "Baby-" + (children.length + 1).to_s
				
				#Check for duplicate names
				child_names = PersonName.find(:all, :conditions => ["person_id IN (?)", children.collect{|child| child.person_a}]).collect{|name|
					name.given_name rescue nil}.uniq
				
				if child_names.include?(first_name)
					first_name = first_name +"_"+ Date.today.year.to_s + "/" 
				end

        baby_id = baby.associate_with_mother("#{link}", first_name,
          "#{(!mother.nil? ? (mother.names.first.family_name rescue "Unknown") : 
          "Unknown")}", params["concept"]["Gender of contact"], params["concept"]["Date of delivery]"]).to_s # rescue nil
        # Baby identifier
        concept = ConceptName.find_by_name("Baby outcome").concept_id rescue nil      

        #create baby obs

        baby_sys_id = PatientIdentifier.find_by_sql("SELECT * FROM patient_identifier WHERE identifier = #{baby_id.to_s}")

        params.delete("baby_check")
        params[:mother_id] = params[:patient_id]
        params[:patient_id] = baby_sys_id.last.patient_id
          
        create_baby_obs(params) 
        
      end
     
      params[:patient_id] = params[:mother_id] if !params[:mother_id].blank?     
      params.delete(:mother_id)
      @task = TaskFlow.new(params[:user_id] || User.first.id, patient.id)

      redirect_to params[:next_url] and return rescue nil if !params[:next_url].nil?

      redirect_to @task.next_task.url and return

    end
    
  end

  def create_baby_obs(params = params)

    if params["proc_check"] && (params["concept"]["Procedure Done"].blank? || params["concept"]["Procedure Done"].downcase == "none")

      redirect_to "/patients/show/#{params[:patient_id]}?user_id=#{params[:user_id]}" and return
    end

    patient = Patient.find(params[:patient_id]) rescue nil

    if !patient.nil?

      type = EncounterType.find_by_name(params[:encounter_type]).id rescue nil

      if !type.nil?
        @encounter = Encounter.create(
          :patient_id => patient.id,
          :provider_id => (params[:user_id]),
          :encounter_type => type,
          :location_id => (session[:location_id] || params[:location_id])
        )

        @current = nil

        if !params[:program].blank?

          @program = Program.find_by_concept_id(ConceptName.find_by_name(params[:program]).concept_id) rescue nil

          if !@program.nil?

            @program_encounter = ProgramEncounter.find_by_program_id(@program.id,
              :conditions => ["patient_id = ? AND DATE(date_time) = ?",
                patient.id, Date.today.strftime("%Y-%m-%d")])

            if @program_encounter.blank?

              @program_encounter = ProgramEncounter.create(
                :patient_id => patient.id,
                :date_time => Time.now,
                :program_id => @program.id
              )

            end

            ProgramEncounterDetail.create(
              :encounter_id => @encounter.id.to_i,
              :program_encounter_id => @program_encounter.id,
              :program_id => @program.id
            )

            @current = PatientProgram.find_by_program_id(@program.id,
              :conditions => ["patient_id = ? AND COALESCE(date_completed, '') = ''", patient.id])

            if @current.blank?

              @current = PatientProgram.create(
                :patient_id => patient.id,
                :program_id => @program.id,
                :date_enrolled => Time.now
              )

            end

          else

            redirect_to "/encounters/missing_program?program=#{params[:program]}" and return

          end

        end

        (params[:concept] || []).each do |key, value|

          if value.blank?
            next
          end

          if value.class.to_s.downcase != "array"

            concept = ConceptName.find_by_name(key.strip).concept_id rescue nil

            if !concept.nil? and !value.blank?

              if !@program.nil? and !@current.nil?

                selected_state = @program.program_workflows.map(&:program_workflow_states).flatten.select{|pws|
                  pws.concept.fullname.upcase() == value.upcase()
                }.first rescue nil

                @current.transition({
                    :state => "#{value}",
                    :start_date => Time.now,
                    :end_date => Time.now
                  }) if !selected_state.nil?
              end

              concept_type = nil
              if value.strip.match(/^\d+$/)

                concept_type = "number"

              elsif value.strip.match(/^\d{4}-\d{2}-\d{2}$/)

                concept_type = "date"

              elsif value.strip.match(/^\d{2}\:\d{2}\:\d{2}$/)

                concept_type = "time"

              else

                value_coded = ConceptName.find_by_name(value.strip) rescue nil

                if !value_coded.nil?

                  concept_type = "value_coded"

                else

                  concept_type = "text"

                end

              end

              obs = Observation.create(
                :person_id => @encounter.patient_id,
                :concept_id => concept,
                :location_id => @encounter.location_id,
                :obs_datetime => @encounter.encounter_datetime,
                :encounter_id => @encounter.id
              )

              case concept_type
              when "date"

                obs.update_attribute("value_datetime", value)

              when "time"

                obs.update_attribute("value_datetime", "#{Date.today.strftime("%Y-%m-%d")} " + value)

              when "number"

                obs.update_attribute("value_numeric", value)

              when "value_coded"

                obs.update_attribute("value_coded", value_coded.concept_id)
                obs.update_attribute("value_coded_name_id", value_coded.concept_name_id)

              else

                obs.update_attribute("value_text", value)

              end

            else

              redirect_to "/encounters/missing_concept?concept=#{key}" and return if !value.blank?

            end

          else

            value.each do |item|

              concept = ConceptName.find_by_name(key.strip).concept_id rescue nil

              if !concept.nil? and !item.blank?

                if !@program.nil? and !@current.nil?
                  selected_state = @program.program_workflows.map(&:program_workflow_states).flatten.select{|pws|
                    pws.concept.fullname.upcase() == item.upcase()
                  }.first rescue nil

                  @current.transition({
                      :state => "#{item}",
                      :start_date => Time.now,
                      :end_date => Time.now
                    }) if !selected_state.nil?
                end

                concept_type = nil
                if item.strip.match(/^\d+$/)

                  concept_type = "number"

                elsif item.strip.match(/^\d{4}-\d{2}-\d{2}$/)

                  concept_type = "date"

                elsif item.strip.match(/^\d{2}\:\d{2}\:\d{2}$/)

                  concept_type = "time"

                else

                  value_coded = ConceptName.find_by_name(item.strip) rescue nil

                  if !value_coded.nil?

                    concept_type = "value_coded"

                  else

                    concept_type = "text"

                  end

                end

                obs = Observation.create(
                  :person_id => @encounter.patient_id,
                  :concept_id => concept,
                  :location_id => @encounter.location_id,
                  :obs_datetime => @encounter.encounter_datetime,
                  :encounter_id => @encounter.id
                )

                case concept_type
                when "date"

                  obs.update_attribute("value_datetime", item)

                when "time"

                  obs.update_attribute("value_datetime", "#{Date.today.strftime("%Y-%m-%d")} " + item)

                when "number"

                  obs.update_attribute("value_numeric", item)

                when "value_coded"

                  obs.update_attribute("value_coded", value_coded.concept_id)
                  obs.update_attribute("value_coded_name_id", value_coded.concept_name_id)

                else

                  obs.update_attribute("value_text", item)

                end

              else

                redirect_to "/encounters/missing_concept?concept=#{item}" and return if !item.blank?

              end

            end

          end

        end

      else

        redirect_to "/encounters/missing_encounter_type?encounter_type=#{params[:encounter_type]}" and return

      end

    end

  end

  def list_observations
    obs = []

    obs = Encounter.find(params[:encounter_id]).observations.collect{|o|
      [o.id, o.to_piped_s] rescue nil
    }.compact 

    render :text => obs.to_json
  end

  def void
    prog = ProgramEncounterDetails.find_by_encounter_id(params[:encounter_id]) rescue nil

    unless prog.nil?
      prog.void

      encounter = Encounter.find(params[:encounter_id]) rescue nil

      unless encounter.nil?
        encounter.void
      end
      
    end

    
    render :text => [].to_json
  end

  def list_encounters
    result = []
    
    program = ProgramEncounter.find(params[:program_id]) rescue nil

    unless program.nil?
      result = program.program_encounter_types.find(:all, :joins => [:encounter],
        :order => ["encounter_datetime DESC"]).collect{|e|
        [
          e.encounter_id, e.encounter.type.name.titleize,
          e.encounter.encounter_datetime.strftime("%H:%M"),
          e.encounter.creator,
          e.encounter.encounter_datetime.strftime("%d-%b-%Y")
        ]
      }
    end

    render :text => result.to_json
  end

  def static_locations
    search_string = (params[:search_string] || "").upcase
    extras = ["Health Facility", "Home", "TBA", "Other"]

    locations = []

    File.open(RAILS_ROOT + "/public/data/locations.txt", "r").each{ |loc|
      locations << loc if loc.upcase.strip.match(search_string)
    }

    if params[:extras]
      extras.each{|loc| locations << loc if loc.upcase.strip.match(search_string)}
    end

    render :text => "<li></li><li " + locations.uniq.map{|location| "value=\"#{location.strip}\">#{location.strip}" }.join("</li><li ") + "</li>"

  end
  def relation_type
    search_string = params[:search_string]
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
  def religion
    search_string = params[:search_string]
    religions = ["Jehovahs Witness",
      "Roman Catholic",
      "Presbyterian (C.C.A.P.)",
      "Seventh Day Adventist",
      "Baptist",
      "Moslem",
      "Other"]

    @religions = Observation.find(:all, :joins => [:concept, :encounter],
      :conditions => ["obs.concept_id = ? AND NOT value_text IN (?) AND " +
          "encounter_type = ?",
        ConceptName.find_by_name("Other").concept_id, religions,
        EncounterType.find_by_name("SOCIAL HISTORY").id]).collect{|o| o.value_text}

    @religions = religions + @religions
    @religions = @religions.collect{|rel| rel.gsub('-', ' ').gsub('_', ' ').squish.titleize}.uniq
    @religions = @religions.collect{|rel| rel if rel.downcase.include?(search_string.downcase)}
    render :text => "<li></li><li>" + @religions.join("</li><li>") + "</li>"
  end
  def diagnoses
		search_string = (params[:search_string] || '').upcase
		filter_list = params[:filter_list].split(/, */) rescue []
		outpatient_diagnosis = ConceptName.find_by_name("DIAGNOSIS").concept
		
		diagnosis_concept_set = ConceptName.find_by_name("MATERNITY DIAGNOSIS LIST").concept
		diagnosis_concepts = Concept.find(:all, :joins => :concept_sets,
      :conditions => ['concept_set = ?', diagnosis_concept_set.id])

		valid_answers = diagnosis_concepts.map{|concept|
			name = concept.fullname rescue nil
			name.upcase.include?(search_string) ? name : nil rescue nil
		}.compact
		previous_answers = []
		# TODO Need to check global property to find out if we want previous answers or not (right now we)
		previous_answers = Observation.find_most_common(outpatient_diagnosis, search_string)
		@suggested_answers = (previous_answers + valid_answers.sort!).reject{|answer| filter_list.include?(answer) }.uniq[0..10]
		@suggested_answers = @suggested_answers - params[:search_filter].split(',') rescue @suggested_answers

		render :text => "<li></li>" + "<li>" + @suggested_answers.join("</li><li>") + "</li>"
	end

	def current_baby_exam
	
		children = Encounter.find(:all, :joins =>[:observations],
      :conditions => ["person_id = ? AND encounter_type = ? AND encounter_datetime > ? AND concept_id = ? AND value_text = ?",
        params[:patient_id], EncounterType.find_by_name("OUTCOME"), 9.months.ago.strftime("%Y-%m-%d"),
        Concept.find_by_name("BABY OUTCOME"),
        "ALIVE"
      ]).length rescue 0
		redirect to "/protocol_patients/current_baby_exam_baby?baby=#{params[:baby]}&patient_id=#{params[:patient_id]}&baby_total=#{children}"
	end

	def baby_delivery_mode
    search_string = params[:search_string]
    @options = Concept.find_by_name("BABY OUTCOME").concept_answers.collect{|c| c.name}
    @options = @options.collect{|rel| rel if rel.downcase.include?(search_string.downcase)}
    render :text => "<li></li><li>" + @options.join("</li><li>") + "</li>"
 	end
	def presentation
    search_string = params[:search_string]
    @options = Concept.find_by_name("PRESENTATION").concept_answers.collect{|c| c.name}
    @options = @options.collect{|rel| rel if rel.downcase.include?(search_string.downcase)}
    render :text => "<li></li><li>" + @options.join("</li><li>") + "</li>"
 	end
	def concept_set_options
		search_string = params[:search_string]
		set = params[:set].gsub("_", " ").strip.upcase
    @options = Concept.find_by_name(set).concept_answers.collect{|c| c.name}
    @options = @options.collect{|rel| rel if rel.downcase.include?(search_string.downcase)}
    @options.delete_if{|opt| opt.match(/Intrauterine death/i) and set.downcase == "baby outcome"}
    render :text => "<li></li><li>" + @options.join("</li><li>") + "</li>"
	end
	def procedure_diagnoses
   
    procedure = params[:procedure].upcase.gsub("_", " ")
    procedure ="Exploratory laparatomy +/- adnexectomy".upcase  if params[:procedure] == "laparatomy"
    procedure ="Evacuation/Manual Vacuum Aspiration".upcase  if params[:procedure] == "evacuation"
    search_string         = (params[:search_string] || '').upcase

    diagnosis_concept_set = ConceptName.find_by_name(procedure).concept
		diagnosis_concepts = Concept.find(:all, :joins => :concept_sets,
      :conditions => ['concept_set = ?', diagnosis_concept_set.id])
		valid_answers = diagnosis_concepts.map{|concept|
			name = concept.fullname rescue nil
			name.upcase.include?(search_string) ? name : nil rescue nil
		}.compact

    @results = valid_answers.collect{|e| e if e.downcase.include?(search_string.downcase)}
    
    render :text => "<li></li>" + "<li>" + @results.join("</li><li>") + "</li>"
  end
end
