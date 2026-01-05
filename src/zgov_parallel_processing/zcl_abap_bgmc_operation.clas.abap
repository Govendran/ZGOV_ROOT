CLASS zcl_abap_bgmc_operation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_bgmc_op_single.

    METHODS constructor
      IMPORTING iv_mail_address TYPE cl_bcs_mail_message=>ty_address.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_mail_address TYPE cl_bcs_mail_message=>ty_address.
ENDCLASS.



CLASS zcl_abap_bgmc_operation IMPLEMENTATION.
  METHOD if_bgmc_op_single~execute.

    DATA: lo_mail          TYPE REF TO cl_bcs_mail_message,
          lo_mail_document TYPE REF TO cl_bcs_mail_bodypart.

    WAIT UP TO 5 SECONDS.

*<<< Begin of Processing logics >>>

*<<< End of Processing logics >>>

    TRY.

        lo_mail = cl_bcs_mail_message=>create_instance(  ).

        lo_mail->set_sender( 'do.no.reply@cardinalhealth.com' ).

        lo_mail->add_recipient( mv_mail_address ).

        lo_mail_document = cl_bcs_mail_textpart=>create_text_plain('Backgrond processing Completed successfully').

        lo_mail->set_main( lo_mail_document  ).

        lo_mail->send_async( ).

      CATCH cx_bcs_mail.

*If email sending fails, then program returns
        RETURN.

      CATCH cx_bgmc_operation.

* If the background operation fails, it raises a retry exception:
* Background process operations can fail due to temporary issues, like a current lock in the database.
* A retry can be attempted up to three times.

        RAISE EXCEPTION NEW cx_bgmc_operation( retry_settings = VALUE #(
                                                   delay_time = 2
                                                   do_retry   = abap_true ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD constructor.
    mv_mail_address = iv_mail_address.
  ENDMETHOD.

ENDCLASS.
