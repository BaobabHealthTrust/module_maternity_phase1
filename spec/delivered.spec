P.1. Update Outcome [program: MATERNITY PROGRAM, scope: TODAY, label: Delivered, pos: 5, parent: 2]

Q.1.1.1. Delivered [pos: 0, name: concept[Outcome], concept: Outcome, type: hidden, value: Delivered]

Q.1.1.2. Number of babies [pos: 1, concept: NUMBER OF BABIES, field_type: number, tt_pageStyleclass: NumbersOnly, absoluteMin: 1, max: 5, absoluteMax: 10, tt_onUnLoad: __$("1.1.3").value = __$("1.1.3").value + __$("touchscreenInput" + tstCurrentPage).value]

Q.1.1.3. Next URL [pos: 2, name: next_url, type: hidden, value: /protocol_patients/bba_delivery?user_id=<%= @user.id %>&patient_id=<%= @patient.id %>&baby=1&baby_total=]
