
class Baby

  attr_accessor :mother, :person, :user, :current_date, :location_id

  def initialize(user_id, patient_id, location_id, session_date = Date.today)
    self.mother = Patient.find(patient_id)
    self.user = User.find(user_id)
    self.current_date = session_date
    self.location_id = location_id
  end

  def associate_with_mother(destination, first_name, last_name, gender, birthdate = Date.today)
    params = {
      "person[names][given_name]" => "#{first_name}",
      "person[names][family_name]" => "#{last_name}",
      "person[gender]" => "#{gender}",
      "person[birth_year]" => "#{birthdate.to_date.year rescue Date.today.year}",
      "person[birth_month]" => "#{birthdate.to_date.month rescue Date.today.month}",
      "person[birth_day]" => "#{birthdate.to_date.day rescue Date.today.day}",
      "person[patient]" => "",
      "mother_id" => self.mother.id
    }

    url = "#{destination}/create_baby?user_id=#{self.user.id}&location_id=#{self.location_id}"

    result = RestClient.post(url, params)

    result
  end

end
