P.1. Update Outcome [program: MATERNITY PROGRAM, scope: TODAY, ignore: true, label: Delivery Mode, pos: 12]
C.1.1. Given a mother who has delivered, capture her baby delivery mode

Q.1.1.1. Delivery Mode [pos: 0, concept: STATUS OF BABY, field_type: text, ajaxURL: /encounters/baby_delivery_mode?search_string=, helpText: Delivery Mode <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.2. Next URL [pos: 1, name: next_url, value: /protocol_patients/delivery_mode?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>&baby=<%= params["baby"].to_i + 1 %>&baby_total=<%= params["baby_total"]%>, type: hidden, ruby: <%= (params["baby"].to_i >= params["baby_total"].to_i ? "disabled" | "") %>]
