class Patient < ActiveRecord::Base
  set_table_name "patient"
  set_primary_key "patient_id"
  include Openmrs

  has_one :person, :foreign_key => :person_id, :conditions => {:voided => 0}
  has_many :patient_identifiers, :foreign_key => :patient_id, :dependent => :destroy, :conditions => {:voided => 0}
  has_many :patient_programs, :conditions => {:voided => 0}
  has_many :programs, :through => :patient_programs
  has_many :relationships, :foreign_key => :person_a, :dependent => :destroy, :conditions => {:voided => 0}
  has_many :orders, :conditions => {:voided => 0}

  has_many :program_encounters, :class_name => 'ProgramEncounter',
    :foreign_key => :patient_id, :dependent => :destroy

  has_one :mother, :class_name => "Relationship", :foreign_key => :person_b, :dependent => :destroy,
    :conditions => {:voided => 0, :relationship => RelationshipType.find_by_a_is_to_b("Parent").id}
  
  has_many :encounters, :conditions => {:voided => 0} do 
    def find_by_date(encounter_date)
      encounter_date = Date.today unless encounter_date
      find(:all, :conditions => ["encounter_datetime BETWEEN ? AND ?", 
          encounter_date.to_date.strftime('%Y-%m-%d 00:00:00'),
          encounter_date.to_date.strftime('%Y-%m-%d 23:59:59')
        ]) # Use the SQL DATE function to compare just the date part
    end
  end

  def after_void(reason = nil)
    self.person.void(reason) rescue nil
    self.patient_identifiers.each {|row| row.void(reason) }
    self.patient_programs.each {|row| row.void(reason) }
    self.orders.each {|row| row.void(reason) }
    self.encounters.each {|row| row.void(reason) }
  end

  def name
    "#{self.person.names.first.given_name} #{self.person.names.first.family_name}"
  end

  
  def national_id
    self.patient_identifiers.find_by_identifier_type(PatientIdentifierType.find_by_name("National id").id).identifier rescue nil
  end

  def address
    "#{self.person.addresses.first.city_village}" rescue nil
  end

  def age(today = Date.today)
    return nil if self.person.birthdate.nil?

    # This code which better accounts for leap years
    patient_age = (today.year - self.person.birthdate.year) + ((today.month -
          self.person.birthdate.month) + ((today.day - self.person.birthdate.day) < 0 ? -1 : 0) < 0 ? -1 : 0)

    # If the birthdate was estimated this year, we round up the age, that way if
    # it is March and the patient says they are 25, they stay 25 (not become 24)
    birth_date=self.person.birthdate
    estimate=self.person.birthdate_estimated==1
    patient_age += (estimate && birth_date.month == 7 && birth_date.day == 1  &&
        today.month < birth_date.month && self.person.date_created.year == today.year) ? 1 : 0
  end

  def gender
    self.person.gender rescue nil
  end

  def hiv_status
    test_status = Observation.find(
      :last, :conditions => ["person_id = ? AND concept_id = ?", self.id,
        ConceptName.find_by_name("HIV status").concept_id]).answer_string rescue "UNKNOWN"
    
    return test_status
  end

  def current_babies(session_date = Date.today)
    ProgramEncounterDetail.find(:all, :joins => [:program_encounter],
      :conditions => ["patient_id = ? AND (DATE(date_time) >= ? AND DATE(date_time) <= ?)",
        self.id, (session_date.to_date - 1.year).strftime("%Y-%m-%d"), 
        (session_date.to_date).strftime("%Y-%m-%d")]).collect{|e|

      e.encounter.observations.collect{|o|
        o.name.strip if o.concept.concept_names.first.name.downcase == "baby outcome"
      } if e.encounter.type.name.downcase == "baby delivery"

    }.flatten.delete_if{|x| x.nil?}
  end

  def current_procedures(session_date = Date.today)
    ProgramEncounterDetail.find(:all, :joins => [:program_encounter],
      :conditions => ["patient_id = ? AND (DATE(date_time) >= ? AND DATE(date_time) <= ?)",
        self.id, (session_date.to_date - 1.year).strftime("%Y-%m-%d"),
        (session_date.to_date).strftime("%Y-%m-%d")]).collect{|e|

      e.encounter.observations.collect{|o|
        o.name.strip.downcase if o.concept.concept_names.first.name.downcase == "delivery mode"
      } if e.encounter.type.name.downcase == "baby delivery"

    }.flatten.delete_if{|x| x.nil?}
  end

end
