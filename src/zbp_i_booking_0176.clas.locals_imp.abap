CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalFlightPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalFlightPrice.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateStatus.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD calculateTotalFlightPrice.
  ENDMETHOD.

  METHOD validateStatus.

 DATA: lr_status TYPE RANGE OF /dmo/overall_status.

    lr_status = VALUE #( ( sign = 'I' option = 'EQ' low = 'N' )
                         ( sign = 'I' option = 'EQ' low = 'X' )
                         ( sign = 'I' option = 'EQ' low = 'B' ) ).

    READ ENTITIES OF zi_travel_log_0176 IN LOCAL MODE
    ENTITY Booking
    FIELDS ( booking_status )
    WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
    RESULT DATA(lt_booking).

    LOOP AT lt_booking ASSIGNING FIELD-SYMBOL(<fs_booking>).

        IF <fs_booking>-booking_status NOT IN lr_status.

        APPEND VALUE #( %key = <fs_booking>-%key ) TO failed-booking.

        APPEND VALUE #( %key = <fs_booking>-%key %msg = new_message( id = 'ZMC_TRAVEL_0176'
                                                                    number = '007'
                                                                    v1 = <fs_booking>-booking_status
                                                                    severity = if_abap_behv_message=>severity-error )
                                                                    %element-booking_status = if_abap_behv=>mk-on
                                                                     ) TO reported-booking.

        ENDIF.


    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
