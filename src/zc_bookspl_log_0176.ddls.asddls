@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BOOKSPL_LOG_0176
  as projection on ZI_BOOKSPL_LOG_0176
{
  key travel_id                   as TravelID,
  key booking_id                  as BookingID,
  key booking_suplement_id        as BookingSupplementID,
      @ObjectModel.text.element: [ 'SupplementDescription' ]
      supplement_id               as SupplemnteID,
      _SupplementText.Description as SupplementDescription : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                       as Price,
      @Semantics.currencyCode: true
      currency_code               as CurrencyCode,
      last_changed_at             as LastChangedAt,
      /* Associations */
      _Travel  : redirected to ZC_TRAVEL_LOG_0176,
      _Booking : redirected to parent ZC_BOOKING_0176,
      _Product,
      _SupplementText

}
