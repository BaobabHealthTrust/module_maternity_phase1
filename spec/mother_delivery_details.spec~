P.1. Update Outcome [program: MATERNITY PROGRAM, ignore: true, label: Mother Delivery Details, pos: 13]

Q.1.1.1. Perineum [concept: Perineum, pos: 0, field_type: text]
O.1.1.1.1. Laceration
O.1.1.1.2. Episiotomy
O.1.1.1.3. Tear
O.1.1.1.4. Intact

Q.1.1.2. Tear Extent [concept: TEAR, pos: 1, field_type: text, condition: __$("1.1.1").value.trim().toUpperCase() == "TEAR"]
O.1.1.2.1. 4 Degrees
O.1.1.2.2. 3 Degrees
O.1.1.2.3. 2 Degrees
O.1.1.2.4. 1 Degree

Q.1.1.3. Next URL [pos: 2, name: next_url, value: /protocol_patients/delivery_procedures?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>, type: hidden]
