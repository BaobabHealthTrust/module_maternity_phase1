P.1. Observations [program: MATERNITY PROGRAM, scope: TODAY, label: Vaginal Examination, pos: 12, parent: 4]
C.1.1. Given a registered patient, capture their relevenat Vaginal Examinations

Q.1.1.1. Genetalia Inspection [concept: GENETALIA INSPECTION, field_type: text, pos: 0, tt_pageStyleClass: LongSelectList]
O.1.1.1.1. Show
O.1.1.1.2. Nothing Abnormal Detected
O.1.1.1.3. Varicose Veins
O.1.1.1.4. Liqour
O.1.1.1.5. Bleeding
O.1.1.1.6. Warts
O.1.1.1.7. Sores
O.1.1.1.8. Scar
O.1.1.1.9. Not Done

Q.1.1.2. Station [concept: STATION, field_type: text, pos: 1, tt_pageStyleClass: LongSelectList]
O.1.1.2.1. -3
O.1.1.2.2. -2
O.1.1.2.3. -1
O.1.1.2.4. 0
O.1.1.2.5. +1
O.1.1.2.6. +2
O.1.1.2.7. +3
O.1.1.2.8. N/A

Q.1.1.3. Cervical Dilation [concept: CERVICAL DILATION, field_type: text, pos: 2, tt_pageStyleClass: LongSelectList]
O.1.1.3.1. Closed
O.1.1.3.2. Open
O.1.1.3.3. Finger Tip
O.1.1.3.4. Not Done

Q.1.1.4. Caput [concept: CAPUT, field_type: text, pos: 3]
O.1.1.4.1. 0
O.1.1.4.2. +1
O.1.1.4.3. +2
O.1.1.4.4. +3
O.1.1.4.5. N/A

Q.1.1.5. Moulding [concept: MOULDING, field_type: text, pos: 4]
O.1.1.5.1. 0
O.1.1.5.2. +1
O.1.1.5.3. +2
O.1.1.5.4. +3
O.1.1.5.5. N/A

Q.1.1.6. Membranes [concept: MEMBRANES, field_type: text, pos: 5]
O.1.1.6.1. Ruptured
O.1.1.6.2. Intact

Q.1.1.7. Membranes Rupture Time [concept: RUPTURE TIME, field_type: advancedTime, pos: 6, condition: __$("1.1.6").value.trim().toUpperCase() == "RUPTURED" ]

Q.1.1.8. Membranes Rupture Date [concept: RUPTURE DATE, field_type: date, pos: 7, condition: __$("1.1.6").value.trim().toUpperCase() == "RUPTURED"]

Q.1.1.9. Colour of Liqour [concept: COLOUR OF LIQOUR, field_type: text, pos: 8, condition: __$("1.1.6").value.trim().toUpperCase() == "RUPTURED"]
O.1.1.9.1. Pus
O.1.1.9.2. Absent
O.1.1.9.3. Blood
O.1.1.9.4. Meconium Grade 3
O.1.1.9.5. Meconium Grade 2
O.1.1.9.6. Meconium Grade 1
O.1.1.9.7. Clear

Q.1.1.10. Presenting Part [concept: PRESENTING PART, field_type: text, pos: 9]
O.1.1.10.1. Cord
O.1.1.10.2. Shoulder
O.1.1.10.3. Foot
O.1.1.10.4. Hand
O.1.1.10.5. Breech
O.1.1.10.6. Sacrum
O.1.1.10.7. Vertex
O.1.1.10.8. Not Done

