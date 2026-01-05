CLASS zcl_triigger_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_triigger_job IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TRY.

        cl_apj_rt_api=>schedule_job(
        EXPORTING
          iv_job_template_name   = 'Z_JT_PROCESS_ORDERS'
          iv_job_text            = 'Process Orders'
          is_start_info          = VALUE cl_apj_rt_api=>ty_start_info( start_immediately = abap_true )
          it_job_parameter_value = VALUE #( ( name = 'P_UUID'
                                              t_value = VALUE #( ( sign   = 'I'      "I
                                                                   option = 'EQ'
                                                                   low    = '42010A3120EB1FD082C229BC80A143CA' ) ) ) )
        IMPORTING
          ev_jobname             = DATA(lv_jobname)
          ev_jobcount            = DATA(lv_jobcount) ).

      CATCH cx_apj_rt cx_root INTO DATA(lo_exc).
        "Exception message

    ENDTRY.

    out->write('Job Triggered successfully').
  ENDMETHOD.

ENDCLASS.
