@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Travel Approval'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_ATRAV_LOG_0176
  as projection on ZI_TRAVEL_LOG_0176
{
  key travel_id       as TravelID,
      @ObjectModel.text.element: [ 'AgencyName' ]
      agency_id       as AgencyID,
      _Agency.Name    as AgencyName,
      @ObjectModel.text.element: [ 'CustomerName' ]
      customer_id     as CustomerID,
      _Customer.LastName as CustomerName,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      @Semantics.currencyCode: true
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,
      last_changed_at as LastChangedAt,
      /* Associations */
      _Booking : redirected to composition child ZC_ABOOK_LOG_0176,
      _Customer
}
