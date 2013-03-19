P.1. PHYSICAL EXAMINATION BABY [program: MATERNITY PROGRAM, scope: TODAY, includejs: vitals, label: Baby Exam, ignore: true, pos: 16]
C.1.1. Given a registered patient, capture each babies physical examination

Q.1.1.1. Condition at Admission [pos: 0, name: concept[Condition of baby at admission], field_type: text, concept: Condition of baby at admission, helpText: Condition of at admission <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby]
O.1.1.1.1. Dead
O.1.1.1.2. Critical
O.1.1.1.3. Stable

Q.1.1.2. Temperature [concept: TEMPERATURE, field_type: number, tt_onLoad: attribute("1.1.2*validationRule*([0-9]+\\.[0-9])|Unknown$"), min: 20, max: 45, tt_pageStyleClass: Numeric NumbersOnlyWithDecimal, pos: 1, absoluteMin: 0, absoluteMax: 100, helpText: Temperature <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"]

Q.1.1.3. Respiratory Rate [concept: RESPIRATORY RATE, field_type: number, min: 0, max: 80, tt_pageStyleClass: Numeric NumbersOnlyWithDecimal, pos: 2, units: bpm, helpText: Respiratory Rate <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"]

Q.1.1.4. Heart Rate [concept: HEART RATE, field_type: number, min: 0, max: 200, tt_pageStyleClass: Numeric NumbersOnlyWithDecimal, pos: 3, units: bpm, helpText: Heart Rate<%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"]

Q.1.1.5. Weight [concept: WEIGHT, field_type: number, tt_onLoad: attribute("1.1.5*validationRule*([0-9]+\\.[0-9])|Unknown$"), min: 2.5, max: 5, tt_pageStyleClass: Numeric NumbersOnlyWithDecimal, pos: 4, absoluteMin: 0, absoluteMax: 10, helpText: Weight <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"]

Q.1.1.6. Abdomen [concept: ABDOMEN, field_type: text, pos: 5, helpText: Abdomen <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"]
O.1.1.6.1. Soft
O.1.1.6.2. Distended

Q.1.1.7. Cord Tied [concept: CORD TIED, field_type: text, pos: 6, helpText: Cord Tied <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"]
O.1.1.7.1. No
O.1.1.7.2. Yes

Q.1.1.8. Any Abnormalities [concept: Any abnormalities, field_type: text, pos: 7, helpText: Any Abnormalities <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"]
O.1.1.8.1. No
O.1.1.8.2. Yes

Q.1.1.9. Specify Abnormalities [concept: SPECIFY, field_type: text, pos: 8, helpText: Specify Abnormality(s) <%= params["baby"] + ((params["baby"].to_i == 1) ? "<sup>st</sup>" | ((params["baby"].to_i == 2) ? "<sup>nd</sup>" | ((params["baby"].to_i == 3) ? "<sup>rd</sup>" | "<sup>th</sup>" ))) %> baby, condition: __$("1.1.1").value.trim().toUpperCase() != "DEAD"; __$("1.1.8").value.trim().toUpperCase() == "YES"]


Q.1.1.10. Next URL [pos: 9, name: next_url, value: /protocol_patients/baby_exam?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>&baby=<%= params["baby"].to_i + 1 %>&baby_total=<%= params["baby_total"]%>, type: hidden, ruby: <%= (params["baby"].to_i >= params["baby_total"].to_i ? "disabled" | "") %>]



