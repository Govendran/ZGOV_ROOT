@EndUserText.label: 'Reason Code Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZI_ReasonCodeText
  as select from ZGOV_RCODES_T
  association [1..1] to ZI_ReasonCode_S as _ReasonCodeAll on $projection.SingletonID = _ReasonCodeAll.SingletonID
  association to parent ZI_ReasonCode as _ReasonCode on $projection.Rcode = _ReasonCode.Rcode
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
  _ReasonCodeAll,
  _ReasonCode,
  _LanguageText
  
}
