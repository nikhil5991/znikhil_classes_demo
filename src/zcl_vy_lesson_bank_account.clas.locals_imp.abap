*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_bank_account DEFINITION.

  PUBLIC SECTION.
    "-----------TYPES (nice for clean signature)
    TYPES: ty_amount TYPE decfloat34,
           ty_curr   TYPE c LENGTH 3.


    "----------- Constructor (create a valid object right away)

    METHODS:
      constructor
        IMPORTING
          iv_owner TYPE string
          iv_currency type ty_curr default 'INR'
          iv_initial_depo type ty_amount default 0.


    "----------- Behavior (public methods)

    METHODS:
        deposit
            IMPORTING iv_amount TYPE ty_amount,

        withdraw
            IMPORTING iv_amount TYPE ty_amount
            RETURNING VALUE(rv_success) TYPE abap_bool,


        transfer_to
            IMPORTING
            io_target TYPE REF TO lcl_bank_account
            iv_amount TYPE ty_amount
            RETURNING VALUE(rv_success) TYPE abap_bool,

        get_balance
            RETURNING VALUE(rv_balance) TYPE ty_amount,


        get_owner
            RETURNING VALUE(rv_owner) TYPE string,

        get_currency
            RETURNING VALUE(rv_curr) TYPE ty_curr,


        get_account_id
            RETURNING VALUE(rv_id) TYPE i.


*  PROTECTED SECTION.

  PRIVATE SECTION.

    "--------------Encapsulated state(No direct external access!)

    DATA:
        mv_owner TYPE string,
        mv_currency TYPE ty_curr,
        mv_balance TYPE ty_amount,
        mv_id TYPE i.


    CLASS-DATA:
              gv_next_id TYPE i.


    "------------- Private Helpers for validation and consistency

    METHODS:
        validate_amount
        IMPORTING iv_amount TYPE ty_amount
        RETURNING VALUE(rv_ok) TYPE abap_bool,

        has_sufficient_funds
            IMPORTING iv_amount TYPE ty_amount
            RETURNING VALUE(rv_ok) TYPE abap_bool.




ENDCLASS.

CLASS lcl_bank_account IMPLEMENTATION.

  METHOD constructor.
        "Generate Unique ID
        gv_next_id = gv_next_id + 1.
        mv_id = gv_next_id.


        "Set Base Fields
        mv_owner = iv_owner.
        mv_currency = iv_currency.
        mv_balance = 0.

        "Initial deposit (only via method -> consistent rules)
        IF iv_initial_depo > 0.
        deposit( iv_initial_depo ).
        ENDIF.

  ENDMETHOD.

   METHOD validate_amount.
    rv_ok = abap_true.

    "No negatives or zero
    IF iv_amount <= 0.
        rv_ok = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD deposit.

    IF validate_amount( iv_amount ) = abap_false.
        RETURN.
    ENDIF.
    mv_balance = mv_balance + iv_amount.

  ENDMETHOD.

  METHOD get_account_id.
    rv_id = mv_id.
  ENDMETHOD.

  METHOD get_balance.
    rv_balance = mv_balance.

  ENDMETHOD.

  METHOD get_currency.
    rv_curr = mv_currency.

  ENDMETHOD.

  METHOD get_owner.
    rv_owner = mv_owner.

  ENDMETHOD.

  METHOD has_sufficient_funds.
    rv_ok = abap_true.

    IF mv_balance < iv_amount.
    rv_ok = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD transfer_to.
    rv_success = abap_false.

        "basic checks

        IF io_target IS INITIAL.
            RETURN.
        ENDIF.


        IF validate_amount( iv_amount ) = abap_false.
            RETURN.
        ENDIF.

         "Ensure same currency
         IF io_target->get_currency(  ) <> mv_currency.
            RETURN.
         ENDIF.

          "Withdraw from sender, then deposit to the target
          IF withdraw( iv_amount ) = abap_true.
          io_target->deposit( iv_amount ).
          rv_success = abap_true.
          ENDIF.

  ENDMETHOD.


  METHOD withdraw.
    rv_success = abap_false.

    IF has_sufficient_funds( iv_amount ) = abap_false.
        RETURN.
    ENDIF.

    mv_balance = mv_balance - iv_amount.
    rv_success = abap_true.

  ENDMETHOD.

ENDCLASS.
