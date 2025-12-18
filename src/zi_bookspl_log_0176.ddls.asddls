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
  association [1..1] to ZI_TRAVEL_LOG_0176 as _Travel on $projection.travel_id = _Travel.travel_id
  association [1..1] to /DMO/I_Supplement as _Product on $projection.supplement_id = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText as _SupplementText on $projection.supplement_id = _SupplementText.SupplementID
{
  key travel_id,
  key booking_id,
  key booking_suplement_id,
      supplement_id,
      @Semantics.amount.currencyCode: 'currency_code'
      price,
      @Semantics.currencyCode: true
      currency_code,
      @Semantics.systemDateTime.lastChangedAt: true
      _Travel.last_changed_at,
      _Booking,
      _Travel,
      _Product,
      _SupplementText
}
