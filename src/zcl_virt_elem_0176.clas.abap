CLASS zcl_virt_elem_0176 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_virt_elem_0176 IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE TABLE OF zc_travel_log_0176.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<ls_original_data>).

        <ls_original_data>-DiscountPrice = <ls_original_data>-TotalPrice - ( <ls_original_data>-TotalPrice * ( 1 / 10 ) ).

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    IF iv_entity EQ 'ZC_TRAVEL_LOG_0176'.

        LOOP AT it_requested_calc_elements INTO DATA(ls_calc_elements).

            IF ls_calc_elements = 'DISCOUNTPRICE'.
                APPEND 'TOTALPRICE' TO et_requested_orig_elements.
            ENDIF.

        ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
