CLASS zcl_process_orders DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_process_orders IMPLEMENTATION.

  METHOD if_apj_dt_exec_object~get_parameters.

* Providing the GET_PARAMETERS method to define the parameters of the job.
    et_parameter_def = VALUE #(
   (  selname        = 'P_UUID'
      kind           = if_apj_dt_exec_object=>parameter
      datatype       = 'C'
      length         = 32
      mandatory_ind  = abap_true
      param_text     = 'UUID'
      changeable_ind = abap_true
      hidden_ind     = abap_false )

       (  selname        = 'P_EBELN'
      kind           = if_apj_dt_exec_object=>parameter
      datatype       = 'C'
      length         = 32
      mandatory_ind  = abap_false
      param_text     = 'Purchase Order'
      changeable_ind = abap_true
      hidden_ind     = abap_false )

      ).

* Default Values
*    et_parameter_val = VALUE #( sign   = 'I'
*                                option = 'EQ'
*                                ( selname = 'P_UUID' low = 'XXXXXXXXXXXXXXXXXXX' ) ).

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    TRY.

        if_apj_rt_exec_object~execute(
        VALUE if_apj_rt_exec_object=>tt_templ_val(
        ( selname = 'P_UUID'
          kind   = if_apj_dt_exec_object=>parameter
          sign   = 'I'
          option = 'EQ'
          low    = '' ) )
      ).

        out->write( |Job Finished| ).

      CATCH cx_root INTO DATA(lo_cx_root).
        out->write( |{ lo_cx_root->get_text(  ) }| ).
    ENDTRY.

  ENDMETHOD.

  METHOD if_apj_rt_exec_object~execute.

    DATA: lv_uuid             TYPE sysuuid_x16.

    "Getting the actual parameter values
    LOOP AT it_parameters ASSIGNING FIELD-SYMBOL(<ls_parameter>).
      "UUID
      lv_uuid = SWITCH #( <ls_parameter>-selname
                          WHEN 'P_UUID' THEN <ls_parameter>-low ).
*      MESSAGE
    ENDLOOP.


***<START   -- OF -- PROCESSING LOGIC>
***<END     -- OF -- PROCESSING LOGIC>

  ENDMETHOD.



ENDCLASS.
