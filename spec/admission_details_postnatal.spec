P.1. Observations [program: MATERNITY PROGRAM, scope: TODAY, label: Admission Details2, pos: 6, parent: 3]
C.1.1. Given a registered patient, capture their admission diagnoses

Q.1.1.1. Admission Date [concept: Admission date, field_type: date, pos: 0]

Q.1.1.2. Admission Time [concept: Admission Time, field_type: advancedTime, pos: 1]

Q.1.1.3. Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, field_type: text, pos: 2, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.4. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true,  optional: true, condition: __$("1.1.3").value.trim() != "", field_type: text, pos: 3, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.5. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, optional: true, condition: __$("1.1.4").value.trim() != "", field_type: text, pos: 4, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.6. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true,  optional: true, condition: __$("1.1.5").value.trim() != "", field_type: text, pos: 5, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.7. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true,  optional: true, condition: __$("1.1.6").value.trim() != "", field_type: text, pos: 6, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.8. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true,  optional: true,  condition: __$("1.1.7").value.trim() != "", field_type: text, pos: 7, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.9. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true,  optional: true,  condition: __$("1.1.8").value.trim() != "", field_type: text, pos: 8, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.10. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true,   optional: true, condition: __$("1.1.9").value.trim() != "", field_type: text, pos: 9, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.11. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true,  optional: true, condition: __$("1.1.10").value.trim() != "", field_type: text, pos: 10, ajaxURL: /encounters/diagnoses?search_string=]
