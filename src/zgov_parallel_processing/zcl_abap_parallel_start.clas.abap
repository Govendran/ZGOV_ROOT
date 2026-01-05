CLASS zcl_abap_parallel_start DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_abap_parallel_start IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* Input for ABAP Parallel
    DATA lt_processes TYPE cl_abap_parallel=>t_in_inst_tab.
    DATA lt_result    TYPE zcl_abap_parallel=>_tty_results.

* Preparing data for processing
    DATA(lt_ebeln) = VALUE zcl_abap_parallel=>tt_ebeln(
                                     ( '4500000010' )
                                     ( '4500000011' )
                                     ( '4500000012' ) ).

*Data Packets are the individual Instances of the Class
    LOOP AT lt_ebeln INTO DATA(ls_ebeln).
      INSERT NEW zcl_abap_parallel( ls_ebeln ) INTO TABLE lt_processes.
    ENDLOOP.

* Parallelization using the RUN_INST method and result in the variable lt_finished
    NEW cl_abap_parallel( p_num_tasks = 3 )->run_inst( EXPORTING p_in_tab  = lt_processes
                                                       IMPORTING p_out_tab = DATA(lt_finished) ).

    LOOP AT lt_finished INTO DATA(ls_finished).
      INSERT CAST zcl_abap_parallel( ls_finished-inst )->get_result( ) INTO TABLE lt_result.
    ENDLOOP.

    out->write( lt_result ).

  ENDMETHOD.

ENDCLASS.
