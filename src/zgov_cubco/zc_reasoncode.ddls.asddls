@EndUserText.label: 'Maintain Reason Code'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_ReasonCode
  as projection on ZI_ReasonCode
{
  key Rcode,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _ReasonCodeAll : redirected to parent ZC_ReasonCode_S,
  _ReasonCodeText : redirected to composition child ZC_ReasonCodeText,
  _ReasonCodeText.Description : localized
  
}
