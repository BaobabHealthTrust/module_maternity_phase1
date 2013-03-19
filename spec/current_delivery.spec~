P.1. Current bba delivery [program: MATERNITY PROGRAM, ignore: true, label: Current delivery baby, pos: 12]
C.1.1. Given a mother that has delivered, for each selected baby

Q.1.1.1. Status of Baby [pos: 0, name: concept[Status of Baby], field_type: text, concept: Status of Baby, helpText: Status <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]
O.1.1.1.1. No Cry
O.1.1.1.2. Cried

Q.1.1.2. Date of delivery [pos: 1, name: concept[Date of delivery], field_type: date, concept: Date of delivery, helpText: Date of delivery <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.3. Time of delivery [pos: 2, name: concept[Time of delivery], field_type: advancedTime, concept: Time of delivery, helpText: Time of delivery <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.4. Gender of Contact [pos: 3, name: concept[Gender of contact], concept: Gender of contact, helpText: Gender <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]
O.1.1.4.1. Male
O.1.1.4.2. Female

Q.1.1.5. Delivery mode [pos: 4, name: concept[Delivery mode], concept: Delivery mode, helpText: Delivery mode <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]
O.1.1.5.1. Spontaneous vaginal delivery
O.1.1.5.2. Vacuum extraction delivery
O.1.1.5.3. Breech delivery
O.1.1.5.4. Caesarean section

Q.1.1.10. Next URL [pos: 5, name: next_url, value: /protocol_patients/current_delivery_baby?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>&baby=<%= params["baby"].to_i + 1 %>&baby_total=<%= params["baby_total"]%>, type: hidden, ruby: <%= (params["baby"].to_i >= params["baby_total"].to_i ? "disabled" | "") %>]

