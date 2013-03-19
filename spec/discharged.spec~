P.1. Update Outcome [program: MATERNITY PROGRAM, scope: TODAY, label: Discharged, pos: 11, parent: 2]

Q.1.1.1. Discharged to Where? [concept: DISCHARGED, pos: 0, fieldtype: text]
O.1.1.1.1. Another Health Facility
O.1.1.1.2. Home - Waiting
O.1.1.1.3. Home

Q.1.1.3. Which Health Facility [concept: HEALTH FACILITY, pos: 1, fieldtype: text, ajaxURL: /encounters/static_locations?search_string=, allowFreeText: true, condition: __$("1.1.1").value.trim().toUpperCase() == "ANOTHER HEALTH FACILITY"]

Q.1.1.4. Select Discharge Diagnosis [name: concept[Diagnosis][], concept: DIAGNOSIS, pos: 2, fieldtype: text, ajaxURL: /encounters/diagnoses?search_string=, allowFreeText: true]

Q.1.1.5. Select Next Discharge Diagnosis [name: concept[Diagnosis][], concept: DIAGNOSIS, pos: 3, optional: true, fieldtype: text, ajaxURL: /encounters/diagnoses?search_string=, allowFreeText: true, condition: __$("1.1.4").value != ""]

Q.1.1.6. Number of babies [pos: 4, concept: NUMBER OF BABIES, tt_pageStyleClass: NumbersOnly, field_type: number, absoluteMin: 1, max: 5, absoluteMax: 10,  tt_onUnLoad: __$("1.1.7").value = __$("1.1.7").value + __$("touchscreenInput" + tstCurrentPage).value]

Q.1.1.7. Next URL [pos: 5, name: next_url, type: hidden, value: /protocol_patients/delivery_mode?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>&baby=1&baby_total=]
