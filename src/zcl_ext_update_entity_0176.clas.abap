CLASS zcl_ext_update_entity_0176 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ext_update_entity_0176 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    MODIFY ENTITIES OF ZI_TRAVEL_LOG_0176
        ENTITY Travel
        UPDATE FIELDS ( agency_id description )
        WITH VALUE #( ( travel_id = '00000001'
                        agency_id = '070017'
                        description = 'New external Update'
                         ) )
        FAILED DATA(failed)
        REPORTED DATA(reported).

    READ ENTITIES OF ZI_TRAVEL_LOG_0176
        ENTITY Travel
        FIELDS ( agency_id description )
        WITH VALUE #( ( travel_id = '00000001' ) )
        RESULT DATA(lt_travel_data)
        FAILED failed
        REPORTED reported.

   COMMIT ENTITIES.

   IF failed IS INITIAL.
    out->write( 'Commit successfull' ).
   ELSE.
    out->write( 'Commit failed' ).
   ENDIF.

  ENDMETHOD.
ENDCLASS.
