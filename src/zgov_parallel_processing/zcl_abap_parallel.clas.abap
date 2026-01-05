CLASS zcl_abap_parallel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_abap_parallel.

    TYPES:
      ts_ebeln TYPE ebeln,
      tt_ebeln TYPE STANDARD TABLE OF ts_ebeln WITH EMPTY KEY,

      BEGIN OF _ty_results,
        ebeln          TYPE ebeln,
        process_status TYPE sgtxt,
        start_time     TYPE utclong,
        end_time       TYPE utclong,
      END   OF _ty_results.

    TYPES: _tty_results TYPE STANDARD TABLE OF _ty_results WITH EMPTY KEY.

    METHODS constructor
      IMPORTING is_ebeln TYPE ts_ebeln.

    METHODS get_result
      RETURNING VALUE(rt_result) TYPE _ty_results.

  PRIVATE SECTION.

    DATA ms_ebeln   TYPE ts_ebeln.
    DATA mt_result  TYPE _ty_results.

ENDCLASS.

CLASS zcl_abap_parallel IMPLEMENTATION.

  METHOD constructor.
    ms_ebeln = is_ebeln.
  ENDMETHOD.

  METHOD if_abap_parallel~do.

*    WAIT UP TO 2 SECONDS.

    DATA ls_result TYPE _ty_results.

    ls_result-start_time = utclong_current( ).
    ls_result-ebeln      = ms_ebeln.

*<<< Begin of Processing logics >>>
    ls_result-process_status      = abap_true.
*<<< End of Processing logics >>>

    ls_result-end_time     = utclong_current( ).

    mt_result = ls_result.

  ENDMETHOD.

  METHOD get_result.
    RETURN mt_result.
  ENDMETHOD.


ENDCLASS.
