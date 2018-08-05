*&---------------------------------------------------------------------*
*& Report zorderexport
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zorderexport.

*&---------------------------------------------------------------------*
*&      Data Declaration
*&---------------------------------------------------------------------*
DATA ls_orderexport TYPE zorderexport_type.
DATA lv_exportxml   TYPE string.

FIELD-SYMBOLS <ls_order> TYPE zorder_type.

DATA: gcl_xml TYPE REF TO cl_xml_document.
DATA: gv_xml  TYPE string.
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      start-of-selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

PERFORM generate_xml_string.

PERFORM display_xml.
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      subroutine generate_xml_string
*&---------------------------------------------------------------------*
FORM generate_xml_string.

  ls_orderexport-exportdate = sy-datum.
  ls_orderexport-exporttime = sy-uzeit.
  ls_orderexport-exportuser = sy-uname.

  SELECT * FROM zorder
    INTO CORRESPONDING FIELDS OF TABLE ls_orderexport-orders.

  LOOP AT ls_orderexport-orders ASSIGNING <ls_order>.
    SELECT * FROM zorderitem
      INTO CORRESPONDING FIELDS OF TABLE <ls_order>-orderitems
      WHERE orderid = <ls_order>-orderid.
  ENDLOOP.

  CALL TRANSFORMATION zorderexport
    SOURCE orderexport = ls_orderexport
    RESULT XML lv_exportxml.

ENDFORM.
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      subroutine display_xml
*&---------------------------------------------------------------------*
FORM display_xml.

  CREATE OBJECT gcl_xml.

*  Parses XML String to DOM
  CALL METHOD gcl_xml->parse_string
    EXPORTING
      stream = lv_exportxml.

*  Display XML
  CALL METHOD gcl_xml->display.

ENDFORM.
*&---------------------------------------------------------------------*
