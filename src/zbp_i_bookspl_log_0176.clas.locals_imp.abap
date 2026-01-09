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
