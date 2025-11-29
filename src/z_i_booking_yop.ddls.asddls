@AbapCatalog.sqlViewName: 'ZVBOOKYOP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Booking'
@Metadata.ignorePropagatedAnnotations: true
define view z_i_booking_yop
  as select from zbooking_yop as Booking
  composition [0..*] of z_i_booksuppl_yop as _BookingSuppl
  association        to parent z_i_travel_yop    as _Travel on $projection.travel_id = _Travel.travel_id
  association [1..1] to /DMO/I_Customer   as _Customer      on $projection.customer_id = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier    as _Carrier       on $projection.carrier_id = _Carrier.AirlineID
  association [1..*] to /DMO/I_Connection as _Connection    on $projection.connection_id = _Connection.ConnectionID
{
  key travel_id,
  key booking_id,
      booking_date,
      customer_id,
      @ObjectModel.text.element: [ '_Carrier.Name' ]
      carrier_id,
      _Carrier.Name,
      connection_id,
      flight_date,
      @Semantics.amount.currencyCode: 'Currency_Code'
      flight_price,
      @Semantics.currencyCode: true
      currency_code,
      booking_status,
      last_change_at,
      _Travel,
      _BookingSuppl,
      _Customer,
      _Carrier,
      _Connection
}
