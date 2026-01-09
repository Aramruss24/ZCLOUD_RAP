CLASS lhc_Supplement DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalSupplPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Supplement~calculateTotalSupplPrice.

ENDCLASS.

CLASS lhc_Supplement IMPLEMENTATION.

  METHOD calculateTotalSupplPrice.

    IF NOT keys IS INITIAL.
      zcl_aux_travel_del_0176=>calculate_price( it_travel_id = VALUE #( FOR GROUPS <booking_suppl> OF booking_keys IN keys
                                                                        GROUP BY booking_keys-travel_id WITHOUT MEMBERS ( <booking_suppl> )
                                                                          ) ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_supplement DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

  PRIVATE SECTION.

    CONSTANTS: BEGIN OF lcs_events,
                 create TYPE c LENGTH 1 VALUE 'C',
                 update TYPE c LENGTH 1 VALUE 'U',
                 delete TYPE c LENGTH 1 VALUE 'D',
               END OF lcs_events.

ENDCLASS.

CLASS lsc_supplement IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_supplements TYPE TABLE OF ztb_bsuppl_0176,
          lv_op_type     TYPE zde_flag_0176,
          lv_update      TYPE zde_flag_0176.

    IF NOT create-supplement IS INITIAL.
      lt_supplements = CORRESPONDING #( create-supplement ).
      lv_op_type = lcs_events-create.
    ENDIF.

    IF NOT update-supplement IS INITIAL.
      lt_supplements = CORRESPONDING #( update-supplement ).
      lv_op_type = lcs_events-update.
    ENDIF.

    IF NOT delete-supplement IS INITIAL.
      lt_supplements = CORRESPONDING #( delete-supplement ).
      lv_op_type = lcs_events-delete.
    ENDIF.


    IF NOT lt_supplements IS INITIAL.

      CALL FUNCTION 'ZFM_SUPPL_0176'
        EXPORTING
          it_supplements = lt_supplements
          iv_op_type     = lv_op_type
        IMPORTING
          ev_update      = lv_update.

      IF lv_update EQ abap_true.

*        reported-supplement[ 1 ]-

      ENDIF.

    ENDIF.
  ENDMETHOD.

ENDCLASS.
