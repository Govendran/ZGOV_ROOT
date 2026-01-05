@EndUserText.label: 'Reason Code'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_ReasonCode
  as select from ZGOV_RCODES
  association to parent ZI_ReasonCode_S as _ReasonCodeAll on $projection.SingletonID = _ReasonCodeAll.SingletonID
  composition [0..*] of ZI_ReasonCodeText as _ReasonCodeText
{
  key RCODE as Rcode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _ReasonCodeAll,
  _ReasonCodeText
  
}
