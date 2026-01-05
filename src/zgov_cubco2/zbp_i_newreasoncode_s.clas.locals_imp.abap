CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZNEWREASONCODE'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'NewReasonCode' table = 'ZGOV_RCODES2' )
                                         ( entity = 'NewReasonCodeText' table = 'ZGOV_RCODES_T2' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_NEWREASONCODE_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR NewReasonCodeAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION NewReasonCodeAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR NewReasonCodeAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_NEWREASONCODE_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_NewReasonCode_S IN LOCAL MODE
    ENTITY NewReasonCodeAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_NewReasonCode = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_NewReasonCode_S IN LOCAL MODE
      ENTITY NewReasonCodeAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_NewReasonCode_S IN LOCAL MODE
      ENTITY NewReasonCodeAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_NEWREASONCODE' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_NEWREASONCODE_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_NEWREASONCODE_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-NewReasonCodeAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_NEWREASONCODE DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR NewReasonCode~ValidateTransportRequest,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR NewReasonCode
        RESULT result,
      COPYNEWREASONCODE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION NewReasonCode~CopyNewReasonCode,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR NewReasonCode
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR NewReasonCode
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_NEWREASONCODE IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_NewReasonCode_S.
    SELECT SINGLE TransportRequestID
      FROM ZGOV_RCODES2_D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZGOV_RCODES2'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-NewReasonCode ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
    result-%ASSOC-_NewReasonCodeText = edit_flag.
  ENDMETHOD.
  METHOD COPYNEWREASONCODE.
    DATA new_NewReasonCode TYPE TABLE FOR CREATE ZI_NewReasonCode_S\_NewReasonCode.
    DATA new_NewReasonCodeText TYPE TABLE FOR CREATE ZI_NewReasonCode_S\\NewReasonCode\_NewReasonCodeText.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-NewReasonCode = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_NewReasonCode_S IN LOCAL MODE
      ENTITY NewReasonCode
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_NewReasonCode)
      FAILED DATA(read_failed).
    READ ENTITIES OF ZI_NewReasonCode_S IN LOCAL MODE
      ENTITY NewReasonCode BY \_NewReasonCodeText
      ALL FIELDS WITH CORRESPONDING #( ref_NewReasonCode )
      RESULT DATA(ref_NewReasonCodeText).

    LOOP AT ref_NewReasonCode ASSIGNING FIELD-SYMBOL(<ref_NewReasonCode>).
      DATA(key) = keys[ KEY draft %TKY = <ref_NewReasonCode>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_NewReasonCode>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_NewReasonCode>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_NewReasonCode> EXCEPT
            LastChangedAt
            LocalLastChangedAt
            Rcode
            SingletonID
        ) ) )
      ) TO new_NewReasonCode ASSIGNING FIELD-SYMBOL(<new_NewReasonCode>).
      <new_NewReasonCode>-%TARGET[ 1 ]-Rcode = key-%PARAM-Rcode.
      FIELD-SYMBOLS <new_NewReasonCodeText> LIKE LINE OF new_NewReasonCodeText.
      UNASSIGN <new_NewReasonCodeText>.
      LOOP AT ref_NewReasonCodeText ASSIGNING FIELD-SYMBOL(<ref_NewReasonCodeText>) USING KEY draft WHERE %TKY-%IS_DRAFT = key-%TKY-%IS_DRAFT
              AND %TKY-Rcode = key-%TKY-Rcode.
        IF <new_NewReasonCodeText> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = key_cid
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_NewReasonCodeText ASSIGNING <new_NewReasonCodeText>.
        ENDIF.
        INSERT VALUE #( %CID = key_cid && <ref_NewReasonCodeText>-Langu
                        %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_NewReasonCodeText> EXCEPT
                                                 LocalLastChangedAt
                                                 Rcode
                                                 SingletonID
        ) ) INTO TABLE <new_NewReasonCodeText>-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
        <target>-%KEY-Rcode = key-%PARAM-Rcode.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_NewReasonCode_S IN LOCAL MODE
      ENTITY NewReasonCodeAll CREATE BY \_NewReasonCode
      FIELDS (
               Rcode
             ) WITH new_NewReasonCode
      ENTITY NewReasonCode CREATE BY \_NewReasonCodeText
      FIELDS (
               Langu
               Rcode
               Description
             ) WITH new_NewReasonCodeText
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-NewReasonCode = mapped_create-NewReasonCode.
    INSERT LINES OF read_failed-NewReasonCode INTO TABLE failed-NewReasonCode.

    IF failed-NewReasonCode IS INITIAL.
      reported-NewReasonCode = VALUE #( FOR created IN mapped-NewReasonCode (
                                                 %CID = created-%CID
                                                 %ACTION-CopyNewReasonCode = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-NewReasonCodeAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-NewReasonCodeAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_NEWREASONCODE' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyNewReasonCode = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyNewReasonCode = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_NEWREASONCODETEXT DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR NewReasonCodeText~ValidateTransportRequest,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR NewReasonCodeText
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_NEWREASONCODETEXT IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_NewReasonCode_S.
    SELECT SINGLE TransportRequestID
      FROM ZGOV_RCODES2_D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZGOV_RCODES_T2'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-NewReasonCodeText ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.
