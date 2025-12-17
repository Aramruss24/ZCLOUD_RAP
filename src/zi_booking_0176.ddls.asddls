@AbapCatalog.sqlViewName: 'ZV_BOOKING_0176'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Booking'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BOOKING_0176
  as select from ztb_booking_0176 as Booking
  composition [0..*] of ZI_BOOKSPL_LOG_0176 as _BookingSupplement
  association to parent ZI_TRAVEL_LOG_0176 as _Travel on $projection.travel_id = _Travel.TravelId

{
  key travel_id,
  key booking_id,
      booking_date,
      customer_id,
      carrier_id,
      connection_id,
      flight_date,
      flight_price,
      currency_code,
      booking_status,
      last_changed_at,
      _Travel,
      _BookingSupplement
}
