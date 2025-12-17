@AbapCatalog.sqlViewName: 'ZV_BSPPLLOG_0176'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BOOKSPL_LOG_0176
  as select from ztb_bsuppl_0176 as BookingSuplement
  association to parent ZI_BOOKING_0176 as _Booking on $projection.travel_id = _Booking.travel_id
                                                   and $projection.booking_id = _Booking.booking_id
{
  key travel_id,
  key booking_id,
  key booking_suplement_id,
      supplement_id,
      @Semantics.amount.currencyCode: 'currency_code'
      price,
      @Semantics.currencyCode: true
      currency_code,
      _Booking
}
