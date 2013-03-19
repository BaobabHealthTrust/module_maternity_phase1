
class TaskFlow

  attr_accessor :patient, :person, :user, :current_date, :tasks, :current_user_activities,
    :encounter_type, :url, :task_scopes, :task_list, :labels, :display_tasks
    
  def initialize(user_id, patient_id, session_date = Date.today)
    self.patient = Patient.find(patient_id)
    self.user = User.find(user_id)
    self.current_date = session_date

    if File.exists?("#{Rails.root}/config/protocol_task_flow.yml")
      settings = YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["clinical.encounters.sequential.list"] rescue ""

      display_list = YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["clinical.encounters.display.list"].split(";") rescue []

      scopes = YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["scope"] rescue ""

      concepts = {}

      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["concept"].strip.split(",").map{|e| 
        s = e.split("|")
        concepts[s[0].downcase] = s[1]
      } rescue {}

      except_concepts = {}

      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["except_concept"].strip.split(",").map{|e| 
        s = e.split("|")
        except_concepts[s[0].downcase] = s[1]
      } rescue {}

      drug_concepts = {}

      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["drug_concept"].strip.split(",").map{|e| 
        s = e.split("|")
        drug_concepts[s[0].downcase] = s[1]
      } rescue {}

      special_fields = {}

      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["special_fields"].strip.split(",").map{|e| 
        s = e.split("|")
        special_fields[s[0].downcase] = s[1]
      } rescue {}

      self.labels = {}

      YAML.load_file("#{Rails.root}/config/protocol_task_flow.yml")["#{Rails.env
        }"]["label"].strip.split(",").map{|e|
        s = e.split("|")
        self.labels[s[0].downcase] = s[1]
      } rescue {}

      self.tasks = settings.strip.split(",").collect{|i| i.downcase}

      list = scopes.strip.split(",").map{|e| e.split("|") }

      self.task_scopes = {}

      list.each{|item|
        self.task_scopes[item[0].downcase] = {
          :scope => item[1],
          :concept => (concepts[item[0].downcase] rescue nil),
          :except_concept => (except_concepts[item[0].downcase] rescue nil),
          :drug_concept => (drug_concepts[item[0].downcase] rescue nil),
          :special_field => (special_fields[item[0].downcase] rescue nil)
        }
      }
      
      self.display_tasks = []

      display_list.each{|item|
        unless item.match(/\|/).nil?
          parts = item.split("|")
          
          fieldlist = parts[1].split(",")

          self.display_tasks << [parts[0], fieldlist]
        else
          self.display_tasks << item
        end
      }

    end

    project = get_global_property_value("project.name").downcase.gsub(/\s/, ".") rescue nil

    self.current_user_activities = UserProperty.find_by_user_id_and_property(user_id,
      "#{project}.activities").property_value.split(",").collect{|a| a.downcase} rescue {}
      
  end

  def get_global_property_value(param)
    YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env
        }"][param] rescue nil
  end

  def next_task
    
    # scope: [ TODAY | EXISTS | CURRENT PROGRAM | RECENT ]

    normal_flow = self.tasks

    flow = {}

    (0..(normal_flow.length-1)).each{|n|
      flow[normal_flow[n].downcase] = n+1
    }

    if self.current_user_activities.blank?

      self.encounter_type = "NO TASKS SELECTED"
      self.url = "/patients/show/#{self.patient.id}?user_id=#{self.user.id}"

      return self

    end

    @patient = self.patient

    # tasks[task] = [weight, path, encounter_type, concept_id, exception_concept_id, 
    #     scope, drug_concept_id, special_field_or_encounter_present, next_if_NOT_user_does_not_have_this_activity]

    tasks = {}

    normal_flow.each{|tsk|
      
      tasks[tsk.downcase] = [flow[tsk.downcase], "/protocol_patients/#{tsk.downcase.gsub(/\s/, "_")
          }?patient_id=#{self.patient.id}&user_id=#{self.user.id}", "#{tsk.upcase}", 
        "#{self.task_scopes[tsk.downcase][:concept]}", "#{self.task_scopes[tsk.downcase][:except_concept]}",
        "#{self.task_scopes[tsk.downcase][:scope]}", "#{self.task_scopes[tsk.downcase][:drug_concept]}",
        "#{self.task_scopes[tsk.downcase][:special_field]}", 
        (self.current_user_activities.include?(tsk.downcase))
      ]

    }

    sorted_tasks = {}

    tasks.each{|t,v|
      sorted_tasks[v[0]] = t
    }

    self.task_list = tasks

    sorted_tasks = sorted_tasks.sort

    sorted_tasks.each do |pos, tsk|

      # next if tasks[tsk][8] == false
      # If user does not have this activity, goto the patient dashboard
      if tasks[tsk][8] == false        
        self.encounter_type = tsk
        self.url = "/patients/show/#{self.patient.id}?user_id=#{self.user.id}"
        return self
      end

      case tasks[tsk][5]
      when "TODAY"

        checked_already = false

        if !tasks[tsk][3].blank? && checked_already == false    # Check for presence of specific concept_id
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? AND obs.concept_id = ? AND DATE(encounter_datetime) = ?",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]), tasks[tsk][3], self.current_date.to_date]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        if !tasks[tsk][4].blank? && checked_already == false   # Check for concept exclusions from encounter_type group
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? AND NOT obs.concept_id = ? AND DATE(encounter_datetime) = ?",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]), tasks[tsk][4], self.current_date.to_date]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        if !tasks[tsk][6].blank? && checked_already == false   # Check for drug concept if available
          available = self.patient.orders.all(:conditions => ["concept_id = ? AND start_date = ?",
              tasks[tsk][6], self.current_date.to_date]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        # Else check for availability of encounter_type
        if checked_already == false
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? AND DATE(encounter_datetime) = ?",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]), self.current_date.to_date]) rescue []

          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        self.encounter_type = tsk

        if normal_flow[0].downcase == tsk.downcase
          self.url = tasks[tsk][1]
        else
          self.url = "/patients/show/#{self.patient.id}?user_id=#{self.user.id}"
        end
        return self
      when "RECENT"

        checked_already = false

        if !tasks[tsk][3].blank? && checked_already == false    # Check for presence of specific concept_id
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? AND obs.concept_id = ? " +
                "AND (DATE(encounter_datetime) >= ? AND DATE(encounter_datetime) <= ?)",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]), tasks[tsk][3],
              (self.current_date.to_date - 6.month), (self.current_date.to_date + 6.month)]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        if !tasks[tsk][4].blank? && checked_already == false   # Check for concept exclusions from encounter_type group
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? AND NOT obs.concept_id = ? " +
                "AND (DATE(encounter_datetime) >= ? AND DATE(encounter_datetime) <= ?)",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]), tasks[tsk][4],
              (self.current_date.to_date - 6.month), (self.current_date.to_date + 6.month)]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        if !tasks[tsk][6].blank? && checked_already == false   # Check for drug concept if available
          available = self.patient.orders.all(:conditions => ["concept_id = ? AND start_date = ? " +
                "AND (DATE(start_date) >= ? AND DATE(start_date) <= ?)",
              tasks[tsk][6], (self.current_date.to_date - 6.month), (self.current_date.to_date + 6.month)]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        # Else check for availability of encounter_type
        if checked_already == false
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? " +
                "AND (DATE(encounter_datetime) >= ? AND DATE(encounter_datetime) <= ?)",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]),
              (self.current_date.to_date - 6.month), (self.current_date.to_date + 6.month)]) rescue []

          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        self.encounter_type = tsk

        if normal_flow[0].downcase == tsk.downcase
          self.url = tasks[tsk][1]
        else
          self.url = "/patients/show/#{self.patient.id}?user_id=#{self.user.id}"
        end
        return self
      when "EXISTS"

        checked_already = false

        if !tasks[tsk][3].blank? && checked_already == false    # Check for presence of specific concept_id
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? AND obs.concept_id = ?",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]), tasks[tsk][3]]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        if !tasks[tsk][4].blank? && checked_already == false   # Check for concept exclusions from encounter_type group
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ? AND NOT obs.concept_id = ?",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2]), tasks[tsk][4]]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        if !tasks[tsk][6].blank? && checked_already == false   # Check for drug concept if available
          available = self.patient.orders.all(:conditions => ["concept_id = ?",
              tasks[tsk][6]]) rescue []

          checked_already = tasks[tsk][7]
          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        # Else check for availability of encounter_type
        if checked_already == false
          available = Encounter.find(:all, :joins => [:observations], :conditions =>
              ["patient_id = ? AND encounter_type = ?",
              self.patient.id, EncounterType.find_by_name(tasks[tsk][2])]) rescue []

          if available.length > 0
            if normal_flow[0].downcase == tsk.downcase
              normal_flow -= [tsk.downcase]
              next
            end
          end
        end

        self.encounter_type = tsk

        if normal_flow[0].downcase == tsk.downcase
          self.url = tasks[tsk][1]
        else
          self.url = "/patients/show/#{self.patient.id}?user_id=#{self.user.id}"
        end
        return self
      end

    end

    #self.encounter_type = 'Visit complete ...'
    self.encounter_type = 'NONE'
    self.url = "/patients/show/#{self.patient.id}?user_id=#{self.user.id}"
    return self

  end

end

class String

  def to_bool

    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)

    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)

    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")

  end

end