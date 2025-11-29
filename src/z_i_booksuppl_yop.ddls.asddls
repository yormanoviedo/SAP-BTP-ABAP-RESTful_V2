@AbapCatalog.sqlViewName: 'ZVBOSUYOP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
define view z_i_booksuppl_yop
  as select from zbooksuppl_yop as _BookingSupplement
  association        to parent z_i_booking_yop as _Booking        on  $projection.travel_id  = _Booking.travel_id
                                                                  and $projection.booking_id = _Booking.booking_id
  association [1..1] to z_i_travel_yop         as _Travel         on  $projection.travel_id = _Travel.travel_id
  association [1..1] to /DMO/I_Supplement      as _Supplement     on  $projection.supplement_id = _Supplement.SupplementID
  association [1..*] to /DMO/I_SupplementText  as _SupplementText on  $projection.supplement_id = _SupplementText.SupplementID
{
  key travel_id,
  key booking_id,
  key booking_supplement_id,
      supplement_id,
      @Semantics.amount.currencyCode : 'currency'
      price,
      @Semantics.currencyCode : true
      currency,
      last_changed_at,
      _Booking,
      _Travel,
      _Supplement,
      _SupplementText
}
