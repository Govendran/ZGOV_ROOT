CLASS zcl_abap_bgpf_start DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abap_bgpf_start IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA lo_operation TYPE REF TO zcl_abap_bgmc_operation.
    DATA lo_process TYPE REF TO if_bgmc_process_single_op.
    DATA lx_bgmc TYPE REF TO cx_bgmc.

    TRY.
        lo_operation = NEW #( iv_mail_address = 'govendran.annadurai@cardinalhealth.com' ).

        lo_process = cl_bgmc_process_factory=>get_default( )->create( ).

        lo_process->set_name('bgPF Demo')->set_operation( lo_operation ).

        lo_process->save_for_execution( ).

        COMMIT WORK.
        out->write('Background process triggered successfully').

      CATCH cx_bgmc INTO lx_bgmc.
        out->write( lx_bgmc->get_text( ) ).

        ROLLBACK WORK.

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
