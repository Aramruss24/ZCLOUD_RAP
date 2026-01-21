@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM - Master Consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_HCM_MASTER_0176
  as projection on ZI_HCM_MASTER_0176
{
      @ObjectModel.text.element: [ 'EmployeeName' ]
  key e_number       as EmployeeNumber,
      e_name         as EmployeeName,
      e_department   as EmployeeDepartment,
      status         as EmployeeStatus,
      job_title      as JobTitle,
      start_date     as StartDate,
      end_date       as EndDate,
      email          as Email,
      @ObjectModel.text.element: [ 'ManagerName' ]
      m_number       as ManagerNumber,
      m_name         as ManagerName,
      m_department   as ManagerDeparment,
      @Semantics.systemDateTime.createdAt: true
      crea_date_time as CreateOn,
      @Semantics.user.createdBy: true
      crea_uname     as CreateBy,
      @Semantics.systemDateTime.lastChangedAt: true
      lchg_date_time as ChangedOn,
      @Semantics.user.lastChangedBy: true
      lchg_uname     as ChangedBy
}
