@EndUserText.label: 'New Reason Code'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_NewReasonCode
  as select from ZGOV_RCODES2
  association to parent ZI_NewReasonCode_S as _NewReasonCodeAll on $projection.SingletonID = _NewReasonCodeAll.SingletonID
  composition [0..*] of ZI_NewReasonCodeText as _NewReasonCodeText
{
  key RCODE as Rcode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _NewReasonCodeAll,
  _NewReasonCodeText
  
}
