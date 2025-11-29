@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Booking'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity z_c_booksuppl_yop
  as projection on z_i_booksuppl_yop
{
  key travel_id             as TravelID,
  key booking_id            as BookingID,
  key booking_supplement_id as BookingSupplementID,
      //      @ObjectModel.text.element: ['SupplementDescription']
      supplement_id         as SupplementID,
      //      _SupplementText.Description as SupplementDescription : localized,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      price                 as Price,
      currency              as CurrencyCode,
      last_changed_at       as LastChangedAt,
      /* Associations */
      _Travel  : redirected to z_c_travel_yop,
      _Booking : redirected to parent z_c_booking_yop,
      //      _Product,
      _SupplementText

}
