P.1. DIAGNOSIS [program: MATERNITY PROGRAM, scope: TODAY, label: Admission Diagnosis, pos: 9, parent: 4]
C.1.1. Given a registered patient, capture their Physical Examination

Q.1.1.1. Select Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, pos: 0, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.2. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, pos: 1, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.3. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, condition: __$("1.1.2").value.trim() != "", pos: 2, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.4. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, condition: __$("1.1.3").value.trim() != "", pos: 3, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.5. Select Next Admission Diagnoses [name: concept[Diagnosis][], allowFreeText: true, condition: __$("1.1.4").value.trim() != "", pos: 4, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.6. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, condition: __$("1.1.5").value.trim() != "", pos: 5, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.7. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, condition: __$("1.1.6").value.trim() != "", pos: 6, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.8. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, condition: __$("1.1.7").value.trim() != "", pos: 7, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.9. Select Next Admission Diagnosis [name: concept[Diagnosis][], allowFreeText: true, condition: __$("1.1.8").value.trim() != "", pos: 8, optional: true, ajaxURL: /encounters/diagnoses?search_string=]

Q.1.1.10. Select Next Admission Diagnosis [name: concept[Diagnosis][], condition: __$("1.1.9").value.trim() != "", allowFreeText: true, pos: 9, optional: true, ajaxURL: /encounters/diagnoses?search_string=]
