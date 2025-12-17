@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_BOOKSPL_LOG_0176
  as projection on ZI_BOOKSPL_LOG_0176
{
  key travel_id            as TravelID,
  key booking_id           as BookingID,
  key booking_suplement_id as BookingSupplementID,
      supplement_id        as SupplemnteID,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                as Price,
      @Semantics.currencyCode: true
      currency_code        as CurrencyCode,
      /* Associations */
      _Booking,
      _Product,
      _SupplementText,
      _Travel
}
