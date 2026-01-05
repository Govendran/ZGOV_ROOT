@EndUserText.label: 'Maintain New Reason Code Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_NewReasonCodeText
  as projection on ZI_NewReasonCodeText
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Langu,
  key Rcode,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _NewReasonCode : redirected to parent ZC_NewReasonCode,
  _NewReasonCodeAll : redirected to ZC_NewReasonCode_S
  
}
