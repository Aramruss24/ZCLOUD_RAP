CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS createTravelByTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Travel~createTravelByTemplate RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateStatus.

    METHODS validationDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validationDates.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_travel_log_0176
    ENTITY Travel
    FIELDS ( travel_id overall_status )
    WITH VALUE #( FOR key_row1 IN keys ( %key = key_row1-%key ) )
    RESULT DATA(lt_travel_result).

    result = VALUE #( FOR ls_travel IN lt_travel_result
    ( %key = ls_travel-%key %field-travel_id = if_abap_behv=>fc-f-read_only
      %field-overall_status = if_abap_behv=>fc-f-read_only
      %action-acceptTravel = cond #( when ls_travel-overall_status = 'A' then if_abap_behv=>fc-o-disabled
                                     else if_abap_behv=>fc-o-enabled )
      %action-rejectTravel = cond #( when ls_travel-overall_status = 'X' then if_abap_behv=>fc-o-disabled
                                     else if_abap_behv=>fc-o-enabled )
    ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD acceptTravel.

*   Modify in local mode - BO - related updates there are not relevant for authorization objects
    MODIFY ENTITIES OF ZI_TRAVEL_LOG_0176 IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( overall_status )
    WITH VALUE #( FOR key_row1 IN keys ( travel_id = key_row1-travel_id overall_status = 'A' ) ) "Accepted
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF ZI_TRAVEL_LOG_0176 IN LOCAL MODE
    ENTITY Travel
    FIELDS ( agency_id customer_id begin_date end_date booking_fee
             total_price currency_code overall_status description
             created_by created_at last_changed_by last_changed_at )
    WITH VALUE #( FOR key_row2 IN keys ( travel_id = key_row2-travel_id ) )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel ( travel_id = ls_travel-travel_id %param = ls_travel ) ).

  ENDMETHOD.

  METHOD createTravelByTemplate.

    READ ENTITIES OF zi_travel_log_0176
    ENTITY Travel
    FIELDS ( travel_id agency_id customer_id booking_fee total_price currency_code )
    WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
    RESULT DATA(lt_entity_travel)
    FAILED failed
    REPORTED reported.


    CHECK failed IS INITIAL.

    DATA lt_create_travel TYPE TABLE FOR CREATE zi_travel_log_0176\\Travel.

    SELECT FROM ztb_travel_0176 FIELDS MAX( travel_id )
        INTO @DATA(lv_travel_id).

    DATA(lv_today) = cl_abap_context_info=>get_system_date(  ).

    lt_create_travel = VALUE #( FOR create_row IN lt_entity_travel INDEX INTO idx
                              ( travel_id      = lv_travel_id + idx
                                agency_id      = create_row-agency_id
                                customer_id    = create_row-customer_id
                                begin_date     = lv_today
                                end_date       = lv_today + 30
                                booking_fee    = create_row-booking_fee
                                total_price    = create_row-total_price
                                currency_code  = create_row-currency_code
                                description    = |Add comments|
                                overall_status = |O| ) ).

    MODIFY ENTITIES OF zi_travel_log_0176
    IN LOCAL MODE ENTITY Travel
    CREATE FIELDS ( travel_id agency_id customer_id begin_date
                    end_date booking_fee total_price currency_code
                    description overall_status )
    WITH lt_create_travel
    MAPPED mapped
    FAILED failed
    REPORTED reported.

    result = VALUE #( FOR result_row IN lt_create_travel INDEX INTO idx
                    ( %cid_ref = keys[ idx ]-%cid_ref
                      %key     = keys[ idx ]-%key
                      %param   = CORRESPONDING #( result_row ) )
                    ).

  ENDMETHOD.

  METHOD rejectTravel.

*   Modify in local mode - BO - related updates there are not relevant for authorization objects
    MODIFY ENTITIES OF ZI_TRAVEL_LOG_0176 IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( overall_status )
    WITH VALUE #( FOR key_row1 IN keys ( travel_id = key_row1-travel_id overall_status = 'X' ) ) "Accepted
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF ZI_TRAVEL_LOG_0176 IN LOCAL MODE
    ENTITY Travel
    FIELDS ( agency_id customer_id begin_date end_date booking_fee
             total_price currency_code overall_status description
             created_by created_at last_changed_by last_changed_at )
    WITH VALUE #( FOR key_row2 IN keys ( travel_id = key_row2-travel_id ) )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel ( travel_id = ls_travel-travel_id %param = ls_travel ) ).


  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITIES OF zi_travel_log_0176 IN LOCAL MODE
    ENTITY Travel
    FIELDS ( customer_id )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DATA lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = customer_id EXCEPT * ).

    DELETE lt_customer WHERE customer_id IS INITIAL.

    SELECT FROM /dmo/customer FIELDS customer_id
        FOR ALL ENTRIES IN @lt_customer
        WHERE customer_id = @lt_customer-customer_id
        INTO TABLE @DATA(lt_customer_db).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).

        IF <fs_travel>-customer_id IS INITIAL OR NOT line_exists( lt_customer_db[ customer_id = <fs_travel>-customer_id ] ).

         APPEND VALUE #( travel_id = <fs_travel>-travel_id ) TO failed-travel.

         APPEND VALUE #( travel_id = <fs_travel>-travel_id %msg = new_message( id = 'ZMC_TRAVEL_0176'
                                                                               number = '001'
                                                                               v1 = <fs_travel>-travel_id
                                                                               severity = if_abap_behv_message=>severity-error )
                                                                               %element-customer_id = if_abap_behv=>mk-on
                                                                                ) TO reported-travel.

        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateStatus.

    READ ENTITIES OF zi_travel_log_0176 IN LOCAL MODE
    ENTITY Travel
    FIELDS ( overall_status )
    WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
    RESULT DATA(lt_travel).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).

        IF <fs_travel>-overall_status NE 'O'.

        APPEND VALUE #( %key = <fs_travel>-%key ) TO failed-travel.

        APPEND VALUE #( %key = <fs_travel>-%key %msg = new_message( id = 'ZMC_TRAVEL_0176'
                                                                    number = '004'
                                                                    v1 = <fs_travel>-overall_status
                                                                    severity = if_abap_behv_message=>severity-error )
                                                                    %element-overall_status = if_abap_behv=>mk-on
                                                                     ) TO reported-travel.

        ENDIF.


    ENDLOOP.

  ENDMETHOD.

  METHOD validationDates.

    READ ENTITIES OF zi_travel_log_0176 IN LOCAL MODE
    ENTITY Travel
    FIELDS ( begin_date end_date )
    WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
    RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result ASSIGNING FIELD-SYMBOL(<fs_travel>).

        IF <fs_travel>-end_date LT <fs_travel>-begin_date.

            APPEND VALUE #( %key = <fs_travel>-%key ) TO failed-travel.

            APPEND VALUE #( %key = <fs_travel>-%key
                            %msg = new_message( id = 'ZMC_TRAVEL_0176'
                                                number = '003'
                                                v1 = <fs_travel>-begin_date
                                                v2 = <fs_travel>-end_date
                                                v3 = <fs_travel>-travel_id
                                                severity = if_abap_behv_message=>severity-error
                                                 )
                                                %element-begin_date = if_abap_behv=>mk-on
                                                %element-end_date = if_abap_behv=>mk-on )
                                                 TO reported-travel.

        ELSEIF <fs_travel>-begin_date < cl_abap_context_info=>get_system_date( ).

           APPEND VALUE #( %key = <fs_travel>-%key ) TO failed-travel.

            APPEND VALUE #( %key = <fs_travel>-%key
                            %msg = new_message( id = 'ZMC_TRAVEL_0176'
                                                number = '002'
                                                severity = if_abap_behv_message=>severity-error
                                                 )
                                                %element-begin_date = if_abap_behv=>mk-on
                                                %element-end_date = if_abap_behv=>mk-on )
                                                TO reported-travel.

        ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_LOG_0176 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_LOG_0176 IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
