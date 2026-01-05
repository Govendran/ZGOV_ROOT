@EndUserText.label: 'New Reason Code Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZI_NewReasonCodeText
  as select from ZGOV_RCODES_T2
  association [1..1] to ZI_NewReasonCode_S as _NewReasonCodeAll on $projection.SingletonID = _NewReasonCodeAll.SingletonID
  association to parent ZI_NewReasonCode as _NewReasonCode on $projection.Rcode = _NewReasonCode.Rcode
  association [0..*] to I_LanguageText as _LanguageText on $projection.Langu = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key LANGU as Langu,
  key RCODE as Rcode,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _NewReasonCodeAll,
  _NewReasonCode,
  _LanguageText
  
}
