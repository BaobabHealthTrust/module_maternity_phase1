P.1. Baby Delivery [program: MATERNITY PROGRAM, includejs: apgar, includecss: apgar, ignore: true, label: Bba Delivery, pos: 12]
C.1.1. Given a mother that has delivered, for each selected baby

Q.1.1.1.  Time of delivery [pos: 0, name: concept[Time of delivery], field_type: advancedTime, concept: Time of delivery, helpText: Time of delivery <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.2. Date of delivery [pos: 1, name: concept[Date of delivery], field_type: date, tt_onLoad: __$("Unknown").style.display = "none", concept: Date of delivery, helpText: Date of delivery <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.3. Presentation [pos: 2, name: concept[Presentation], ajaxURL: /encounters/presentation?search_string=, field_type: text, concept: Presentation, helpText: Presentation <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.4. Delivery Outcome [pos: 3, name: concept[BABY OUTCOME], ajaxURL: /encounters/concept_set_options?set=baby_outcome&search_string=, field_type: text, concept: BABY OUTCOME, helpText: Delivery Outcome <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]


Q.1.1.5. Gender [pos: 4, name: concept[Gender of contact], concept: Gender of contact, helpText: Gender <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]
O.1.1.5.1. Male
O.1.1.5.2. Female

Q.1.1.6. Weight (KG) [concept: WEIGHT (KG), field_type: number, tt_onLoad: weightAlert("1.1.6*1.1.5"); attribute("1.1.6*validationRule*([0-9]+\\.[0-9])|Unknown$"), tt_onUnLoad: window.clearInterval(timedEvent), min: 2.5, max: 4.5, tt_pageStyleClass: Numeric NumbersOnlyWithDecimal, pos: 5, absoluteMin: 0, absoluteMax: 10, helpText: Weight <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.7. Height (CM) [concept: HEIGHT (CM), field_type: number, min: 15.0, max: 60.0, tt_pageStyleClass: Numeric NumbersOnlyWithUnknown, pos: 6, absoluteMin: 0, absoluteMax: 100, helpText: Height <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.8. APGAR [concept: Apgar, field_type: number, min: 0, tt_onLoad: showApgarControl(); __$("keyboard").style.display = "none", max: 10, pos: 7, tt_pageStyleClass: NoKeyboard, absoluteMin: 0, absoluteMax: 10, helpText: APGAR <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.9. Delivery Mode [pos: 8, name: concept[Delivery Mode], ajaxURL: /encounters/concept_set_options?set=delivery_mode&search_string=, field_type: text, concept: DELIVERY MODE, helpText: Delivery Mode <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]

Q.1.1.10. Next URL [pos: 9, name: next_url, value: /protocol_patients/bba_delivery?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>&baby=<%= params["baby"].to_i + 1 %>&baby_total=<%= params["baby_total"]%>, type: hidden, ruby: <%= (params["baby"].to_i >= params["baby_total"].to_i ? "disabled" | "") %>]

Q.1.1.11. Next URL [pos: 10, name: next_url, value: /protocol_patients/mother_delivery_details?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>, type: hidden, ruby: <%= (params["baby"].to_i < params["baby_total"].to_i ? "disabled" | "") %>]

