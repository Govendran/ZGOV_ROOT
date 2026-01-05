CLASS LHC_ZI_REASONCODE_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      AUGMENT FOR MODIFY
        IMPORTING
          ENTITIES_CREATE FOR CREATE ReasonCodeAll\_ReasonCode
          ENTITIES_UPDATE FOR UPDATE ReasonCode.
ENDCLASS.

CLASS LHC_ZI_REASONCODE_S IMPLEMENTATION.
  METHOD AUGMENT.
    DATA: text_for_new_entity      TYPE TABLE FOR CREATE ZI_ReasonCode\_ReasonCodeText,
          text_for_existing_entity TYPE TABLE FOR CREATE ZI_ReasonCode\_ReasonCodeText,
          text_update              TYPE TABLE FOR UPDATE ZI_ReasonCodeText.
    DATA: relates_create TYPE abp_behv_relating_tab,
          relates_update TYPE abp_behv_relating_tab,
          relates_cba    TYPE abp_behv_relating_tab.
    DATA: text_tky_link  TYPE STRUCTURE FOR READ LINK ZI_ReasonCode\_ReasonCodeText,
          text_tky       LIKE text_tky_link-target.

    READ TABLE entities_create INDEX 1 INTO DATA(entity).
    LOOP AT entity-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
      APPEND 1 TO relates_create.
      INSERT VALUE #( %CID_REF = <target>-%CID
                      %IS_DRAFT = <target>-%IS_DRAFT
                        %KEY-Rcode = <target>-%KEY-Rcode
                      %TARGET = VALUE #( (
                        %CID = |CREATETEXTCID{ sy-tabix }|
                        %IS_DRAFT = <target>-%IS_DRAFT
                        Langu = sy-langu
                        Description = <target>-Description
                        %CONTROL-Langu = if_abap_behv=>mk-on
                        %CONTROL-Description = <target>-%CONTROL-Description ) ) )
                   INTO TABLE text_for_new_entity.
    ENDLOOP.
    MODIFY AUGMENTING ENTITIES OF ZI_ReasonCode_S
      ENTITY ReasonCode
        CREATE BY \_ReasonCodeText
        FROM text_for_new_entity
        RELATING TO entities_create BY relates_create.

    IF entities_update IS NOT INITIAL.
      READ ENTITIES OF ZI_ReasonCode_S
        ENTITY ReasonCode BY \_ReasonCodeText
          FROM CORRESPONDING #( entities_update )
          LINK DATA(link).
      LOOP AT entities_update INTO DATA(update) WHERE %CONTROL-Description = if_abap_behv=>mk-on.
        DATA(tabix) = sy-tabix.
        text_tky = CORRESPONDING #( update-%TKY MAPPING
                                                        Rcode = Rcode
                                    ).
        text_tky-Langu = sy-langu.
        IF line_exists( link[ KEY draft source-%TKY  = CORRESPONDING #( update-%TKY )
                                        target-%TKY  = CORRESPONDING #( text_tky ) ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %TKY = text_tky
                          %CID_REF = update-%CID_REF
                          Description = update-Description
                          %CONTROL = VALUE #( Description = update-%CONTROL-Description )
          ) TO text_update.
        ELSEIF line_exists(  text_for_new_entity[ KEY cid %IS_DRAFT = update-%IS_DRAFT
                                                          %CID_REF  = update-%CID_REF ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %TKY = text_tky
                          %CID_REF = text_for_new_entity[ %IS_DRAFT = update-%IS_DRAFT
                          %CID_REF = update-%CID_REF ]-%TARGET[ 1 ]-%CID
                          Description = update-Description
                          %CONTROL = VALUE #( Description = update-%CONTROL-Description )
          ) TO text_update.
        ELSE.
          APPEND tabix TO relates_cba.
          APPEND VALUE #( %TKY = CORRESPONDING #( update-%TKY )
                          %CID_REF = update-%CID_REF
                          %TARGET  = VALUE #( (
                            %CID = |UPDATETEXTCID{ tabix }|
                            Langu = sy-langu
                            %IS_DRAFT = text_tky-%IS_DRAFT
                            Description = update-Description
                            %CONTROL-Langu = if_abap_behv=>mk-on
                            %CONTROL-Description = update-%CONTROL-Description
                          ) )
          ) TO text_for_existing_entity.
        ENDIF.
      ENDLOOP.
      IF text_update IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF ZI_ReasonCode_S
          ENTITY ReasonCodeText
            UPDATE FROM text_update
            RELATING TO entities_update BY relates_update.
      ENDIF.
      IF text_for_existing_entity IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF ZI_ReasonCode_S
          ENTITY ReasonCode
            CREATE BY \_ReasonCodeText
            FROM text_for_existing_entity
            RELATING TO entities_update BY relates_cba.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
