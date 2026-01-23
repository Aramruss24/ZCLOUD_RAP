CLASS lcl_buffer DEFINITION.

  PUBLIC SECTION.

    CONSTANTS: BEGIN OF gsc_operation,
                 create TYPE c LENGTH 1 VALUE 'C',
                 update TYPE c LENGTH 1 VALUE 'U',
                 delete TYPE c LENGTH 1 VALUE 'D',
               END OF gsc_operation.

    TYPES: BEGIN OF ty_buffer_master.
             INCLUDE TYPE zhcm_master_0176 AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer_master.

    TYPES: tt_master TYPE SORTED TABLE OF ty_buffer_master WITH UNIQUE KEY e_number.

    CLASS-DATA: mt_buffer_master TYPE tt_master.

ENDCLASS.

CLASS lhc_HCMMaster DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR HCMMaster RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR HCMMaster RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE HCMMaster.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE HCMMaster.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE HCMMaster.

    METHODS read FOR READ
      IMPORTING keys FOR READ HCMMaster RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK HCMMaster.

ENDCLASS.

CLASS lhc_HCMMaster IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

    GET TIME STAMP FIELD DATA(lv_time_stamp).
    DATA(lv_uname) = cl_abap_context_info=>get_user_technical_name( ).

    SELECT FROM zhcm_master_0176 FIELDS MAX( e_number )
        INTO @DATA(lv_max_employee_number).

    LOOP AT entities INTO DATA(ls_entities).

      ls_entities-%data-crea_date_time = lv_time_stamp.
      ls_entities-%data-crea_uname     = lv_uname.
      ls_entities-%data-e_number       = lv_max_employee_number + 1.

      INSERT VALUE #( flag = lcl_buffer=>gsc_operation-create
                      data = CORRESPONDING #( ls_entities-%data ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

      IF NOT ls_entities-%cid IS INITIAL.

        INSERT VALUE #( %cid     = ls_entities-%cid
                        e_number = ls_entities-e_number
                        ) INTO TABLE mapped-hcmmaster.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    GET TIME STAMP FIELD DATA(lv_time_stamp).
    DATA(lv_uname) = cl_abap_context_info=>get_user_technical_name( ).

    SELECT FROM zhcm_master_0176 FIELDS *
        FOR ALL ENTRIES IN @entities
        WHERE e_number EQ @entities-e_number
        INTO TABLE @DATA(lt_data_db_update).

    LOOP AT entities INTO DATA(ls_entities).

      ls_entities-%data-lchg_date_time = lv_time_stamp.
      ls_entities-%data-lchg_uname     = lv_uname.

      DATA(ls_data_db_update) = lt_data_db_update[ e_number = ls_entities-e_number ].

      INSERT VALUE #( flag = lcl_buffer=>gsc_operation-update
                      data = VALUE #( e_number     = ls_data_db_update-e_number
                                      e_name       = COND #( WHEN ls_entities-%control-e_name = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-e_name
                                                             ELSE ls_data_db_update-e_name )
                                      e_department = COND #( WHEN ls_entities-%control-e_department = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-e_department
                                                             ELSE ls_data_db_update-e_department )
                                      status       = COND #( WHEN ls_entities-%control-status = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-status
                                                             ELSE ls_data_db_update-status )
                                      job_title    = COND #( WHEN ls_entities-%control-job_title = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-job_title
                                                             ELSE ls_data_db_update-job_title )
                                      start_date   = COND #( WHEN ls_entities-%control-start_date = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-start_date
                                                             ELSE ls_data_db_update-start_date )
                                      end_date     = COND #( WHEN ls_entities-%control-end_date = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-end_date
                                                             ELSE ls_data_db_update-end_date )
                                      email        = COND #( WHEN ls_entities-%control-email = if_abap_behv=>mk-on
                                                            THEN ls_entities-%data-email
                                                            ELSE ls_data_db_update-email )
                                      m_number     = COND #( WHEN ls_entities-%control-m_number = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-m_number
                                                             ELSE ls_data_db_update-m_number )
                                      m_name       = COND #( WHEN ls_entities-%control-m_name = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-m_name
                                                             ELSE ls_data_db_update-m_name )
                                      m_department = COND #( WHEN ls_entities-%control-m_department = if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-m_department
                                                             ELSE ls_data_db_update-m_department )
                                      crea_date_time = ls_data_db_update-crea_date_time
                                      crea_uname     = ls_data_db_update-crea_uname
                                                 ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

      IF NOT ls_entities-e_number IS INITIAL.

        INSERT VALUE #( %cid     = ls_entities-e_number
                        e_number = ls_entities-e_number
                        ) INTO TABLE mapped-hcmmaster.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    LOOP AT keys INTO DATA(ls_keys).

       INSERT VALUE #( flag = lcl_buffer=>gsc_operation-delete
                       data = VALUE #( e_number = ls_keys-e_number )
                       ) INTO TABLE lcl_buffer=>mt_buffer_master.

       IF NOT ls_keys-e_number IS INITIAL.
        INSERT VALUE #( %cid = ls_keys-%key-e_number
                        e_number = ls_keys-%key-e_number ) INTO TABLE mapped-hcmmaster.
       ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_HCM_MASTER_0176 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_HCM_MASTER_0176 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA: lt_data_created TYPE TABLE OF zhcm_master_0176,
          lt_data_updated  TYPE TABLE OF zhcm_master_0176,
          lt_data_deleted  TYPE TABLE OF zhcm_master_0176.

    lt_data_created = VALUE #( FOR <fs_row> IN lcl_buffer=>mt_buffer_master
                       WHERE ( flag = lcl_buffer=>gsc_operation-create ) ( <fs_row>-data ) ).

    IF NOT lt_data_created IS INITIAL.

      INSERT zhcm_master_0176 FROM TABLE @lt_data_created.

    ENDIF.

    lt_data_updated = VALUE #( FOR <fs_row> IN lcl_buffer=>mt_buffer_master
                       WHERE ( flag = lcl_buffer=>gsc_operation-update ) ( <fs_row>-data ) ).

    IF NOT lt_data_updated IS INITIAL.

      UPDATE zhcm_master_0176 FROM TABLE @lt_data_updated.

    ENDIF.

     lt_data_deleted = VALUE #( FOR <fs_row> IN lcl_buffer=>mt_buffer_master
                       WHERE ( flag = lcl_buffer=>gsc_operation-delete ) ( <fs_row>-data ) ).

    IF NOT lt_data_deleted IS INITIAL.

      DELETE zhcm_master_0176 FROM TABLE @lt_data_deleted.

    ENDIF.

    CLEAR lcl_buffer=>mt_buffer_master.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
