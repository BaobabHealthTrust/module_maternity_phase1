P.1. Observations [program: MATERNITY PROGRAM, scope: TODAY, label: Physical Exam, pos: 8, parent: 4]
C.1.1. Given a registered patient, capture their Physical Examination

Q.1.1.1. Fundus(weeks) [concept: FUNDUS, field_type: number, pos: 0, tt_pageStyleClass: NumbersOnly na]

Q.1.1.2. Lie [concept: LIE, field_type: text, pos: 1, condition: __$("1.1.1").value != "N/A"]
O.1.1.2.1. Undefined
O.1.1.2.2. Oblique
O.1.1.2.3. Transverse
O.1.1.2.4. Longitudinal

Q.1.1.3. Contractions [concept: CONTRACTIONS, field_type: text, pos: 2, condition: __$("1.1.1").value != "N/A"]
O.1.1.3.1. No
O.1.1.3.2. Yes

Q.1.1.4. Contractions Intensity [concept: CONTRACTIONS INTENSITY, field_type: text, pos: 3, condition: __$("1.1.3").value.trim().toUpperCase() == "YES"]
O.1.1.4.1. Niggling
O.1.1.4.2. Strong
O.1.1.4.3. Moderate
O.1.1.4.4. Mild

Q.1.1.5. Contractions Level [concept: CONTRACTIONS LEVEL, field_type: number, absoluteMax: 5, absoluteMin: 1, tt_pageStyleClass: NumbersOnly level, tt_onLoad: changeIds(), pos: 4, tt_pageStyleClass: NumbersOnly na, condition: __$("1.1.4").value.trim().toUpperCase() != "NIGGLING"]

Q.1.1.6. Descent [concept: DESCENT, field_type: text, pos: 5, tt_pageStyleClass: NoKeyboard]
O.1.1.6.1. 0/5
O.1.1.6.2. 1/5
O.1.1.6.3. 2/5
O.1.1.6.4. 3/5
O.1.1.6.5. 4/5
O.1.1.6.6. 5/5
O.1.1.6.7. N/A
