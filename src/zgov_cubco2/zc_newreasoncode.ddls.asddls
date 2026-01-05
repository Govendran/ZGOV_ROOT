@EndUserText.label: 'Maintain New Reason Code'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_NewReasonCode
  as projection on ZI_NewReasonCode
{
  key Rcode,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _NewReasonCodeAll : redirected to parent ZC_NewReasonCode_S,
  _NewReasonCodeText : redirected to composition child ZC_NewReasonCodeText,
  _NewReasonCodeText.Description : localized
  
}
