CLASS zcl_vy_lesson_bank_account DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VY_LESSON_BANK_ACCOUNT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  "1. Create Instances (Objects)
  DATA(lo_omkar) = NEW lcl_bank_account(
  iv_owner = 'omkar'
  iv_initial_depo = '20000'

  ).


  DATA(lo_nikhil) = NEW lcl_bank_account(
  iv_owner = 'nikhil'
  iv_initial_depo = '20000'

  ).

  out->write( |Created accounts| ).
  out->write( |- { lo_omkar->get_owner(  ) } ( ID { lo_omkar->get_account_id(  ) } ): { lo_omkar->get_balance(  ) } { lo_omkar->get_currency(  ) } | ).
  out->write( |- { lo_nikhil->get_owner(  ) } ( ID { lo_nikhil->get_account_id(  ) } ): { lo_nikhil->get_balance(  ) } { lo_nikhil->get_currency(  ) } | ).


  "2.Call methods: deposit
  lo_omkar->deposit( 10000 ).
  out->write( |After deposit(10000): omkar balance = { lo_omkar->get_balance(  ) } { lo_omkar->get_currency(  ) } | ).

  "3.Call methods: withdrawal(with success flag)
  IF lo_omkar->withdraw( 1000 ) = abap_true.
     out->write( |Withdrawal Successful| ).
     out->write( |Amount after withdrawal: { lo_omkar->get_balance(  ) } INR| ).
  ELSE.
     out->write( |Withdrawal of 1000 FAILED (Insufficient funds or Invalid amount)| ).
  ENDIF.


  "2.Call methods: Transfer money:  omkar -> nikhil
  IF lo_omkar->transfer_to( io_target = lo_nikhil iv_amount = 9000 ) = abap_true.
     out->write( | Transfer 9000 INR successful| ).
  ELSE.
     out->write( | Trnasfer 9000 INR Failed| ).
  ENDIF.

  out->write( | omkar = { lo_omkar->get_balance(  ) } INR | ).
  out->write( | nikhil = { lo_nikhil->get_balance(  ) } INR | ).
  out->write( '' ).





  ENDMETHOD.
ENDCLASS.
