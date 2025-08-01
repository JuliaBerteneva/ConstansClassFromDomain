
REPORT zcc_generate_class.

"Input parameter p_rollna is Data Element name. Program checks if there are values inside domain
"(under chosen data element) and generates a class with the values as constants.
"p_rule is a rule for new class naming. It should starts with zcl, [D] - means domain, this part will be replaced
"with the full name of data element. CC means constants class in default value.
"Parameter p_regen needed for cases when domain was changed after class generation. If this flag is set up
"while running the report existing class will be regenerated (new values for example will be added to class)

CONSTANTS: lc_default_rule TYPE tex50 VALUE 'ZCL_CC_[D]'.

PARAMETERS: p_rollna TYPE rollname OBLIGATORY,
            p_rule   TYPE text50 DEFAULT lc_default_rule,
            p_regen  AS CHECKBOX DEFAULT 'X'.

DATA: ls_properties TYPE vseoclass,
      lt_attributes TYPE seoo_attributes_r.

START-OF-SELECTION.
  IF p_rule IS INITIAL OR p_rule(3) <> 'ZCL'.
    p_rule = lc_default_rule.
  ENDIF.

  "get domain for mentioned data element
  SELECT SINGLE domname FROM zcc_i_data_element_domain
  INTO @DATA(lv_domname)
  WHERE rollname = @p_rollna.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e004(zcc_const_class).
  ENDIF.

  DATA(lv_classname) = p_rule.
  REPLACE ALL OCCURRENCES OF '[D]' IN lv_classname WITH lv_domname.

  IF p_regen IS INITIAL.
    "check if class doesn't exist
    SELECT COUNT( * ) FROM seoclass
    WHERE clsname = @lv_classname.
    IF sy-dbcnt IS NOT INITIAL.
      MESSAGE e007(zcc_const_class).
    ENDIF.
  ENDIF.

  "get domain values
  SELECT * FROM zcc_i_domain_values( i_domname = @lv_domname )
  INTO TABLE @DATA(lt_domain_values).
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e001(zcc_const_class).
    RETURN.
  ENDIF.

  "get package
  SELECT SINGLE devclass FROM zcc_i_domain_package
    INTO @DATA(lv_domain_package)
    WHERE obj_name = @lv_domname.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e002(zcc_const_class).
  ENDIF.

  "get transport request
  SELECT SINGLE trkorr FROM zcc_i_domain_transport
      INTO @DATA(lv_transport)
      WHERE obj_name = @lv_domname.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e005(zcc_const_class).
  ENDIF.

  ls_properties = VALUE #( descript = |Constants from { lv_domname } domain|
                           clsname = lv_classname
                           author = sy-uname
                           clsfinal = abap_true
                           exposure = seoc_exposure_public ).
  LOOP AT lt_domain_values ASSIGNING FIELD-SYMBOL(<ls_domain_values>).
    lt_attributes = VALUE #( BASE lt_attributes ( clsname = lv_classname
                                                  cmpname = condense( val = |GC_{ <ls_domain_values>-Value }| to = `` )
                                                  descript = <ls_domain_values>-Description
                                                  typtype = 1 "type
                                                  type = p_rollna " data element
                                                  attvalue = |`{ <ls_domain_values>-Value }`|
                                                  exposure = seoc_exposure_public
                                                  state = 1 "implemented
                                                  attdecltyp = 2 ) "constant
                           ).
  ENDLOOP.
  CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
    EXPORTING
      corrnr          = lv_transport
      devclass        = lv_domain_package
      overwrite       = abap_true
      version         = seoc_version_active
      suppress_dialog = abap_true " Parameter missing in 702
    CHANGING
      class           = ls_properties
      attributes      = lt_attributes
    EXCEPTIONS
      existing        = 1
      is_interface    = 2
      db_error        = 3
      component_error = 4
      no_access       = 5
      other           = 6
      OTHERS          = 7.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e003(zcc_const_class).
  ELSE.
    MESSAGE s006(zcc_const_class) WITH lv_classname lv_domain_package lv_transport.
  ENDIF.
