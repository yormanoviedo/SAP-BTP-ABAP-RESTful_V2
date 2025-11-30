CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS createTravelByTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Travel~createTravelByTemplate RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateStatus.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD acceptTravel.
  ENDMETHOD.

  METHOD createTravelByTemplate.

    "Parametros que tengo disponible en este metodo
    "keys[ 1 ]    Entradas
    "result[ 1 ]  Salidas
    "mapped
    "failed       para fallos
    "reported     para reportar los fallos


    "Usaremos EML para copiar el registro seleccionado
    "opcion 1 - RECOMENDADA
    " 1- Leemos la entidad de negocio
    READ ENTITIES OF z_i_travel_yop
             ENTITY Travel
             FIELDS ( travel_id agency_id customer_id booking_fee total_price currency_code )
             WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
             RESULT DATA(lt_entity_travel)
             FAILED failed
             REPORTED reported.

    "opcion 2
*    READ ENTITY z_i_travel_yop
*             FIELDS ( travel_id agency_id customer_id booking_fee total_price currency_code )
*             WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
*             RESULT lt_entity_travel
*             FAILED failed
*             REPORTED reported.

    CHECK failed IS INITIAL.


    " 2- Creamos los datos del nuevo viaje
    DATA lt_create_travel TYPE TABLE FOR CREATE z_i_travel_yop\\Travel.

    SELECT MAX( travel_id ) FROM ztravel_yop INTO @DATA(lv_max_id).

    DATA(lv_today) = cl_abap_context_info=>get_system_date(  ).

    lt_create_travel = VALUE #( FOR cr IN lt_entity_travel INDEX INTO idx
                                (
                                  travel_id         = lv_max_id + idx  "El siguiente valor de id
                                  agency_id         = cr-agency_id
                                  customer_id       = cr-customer_id
                                  begin_date        = lv_today
                                  end_date          = lv_today + 30
                                  booking_fee       = cr-booking_fee
                                  total_price       = cr-total_price
                                  currency_code     = cr-currency_code
                                  description       = 'Add commenst...'
                                  overall_status    = 'O'
                                )
                            ).


    " 3- Modificar la entidad hasta la capa de persistencia
    MODIFY ENTITIES OF z_i_travel_yop
        IN LOCAL MODE ENTITY Travel
        CREATE FIELDS (
                      travel_id
                      agency_id
                      customer_id
                      begin_date
                      end_date
                      booking_fee
                      total_price
                      currency_code
                      description
                      overall_status
                      )
        WITH lt_create_travel
        MAPPED mapped
        FAILED failed
        REPORTED reported.

    " 4- Devolvemos a la capa de interfaz de usuario los datos correspondientes
    result = VALUE #( FOR rr IN lt_create_travel INDEX INTO idx
                        (
                             %cid_ref = keys[ idx ]-%cid_ref
                             %key     = keys[ idx ]-%key
                             %param   =  CORRESPONDING #( rr )
                        )
                    ).


  ENDMETHOD.

  METHOD rejectTravel.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_TRAVEL_YOP DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_TRAVEL_YOP IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
