@EndUserText.label: 'Maintain Reason Code Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_ReasonCodeText
  as projection on ZI_ReasonCodeText
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
  _ReasonCode : redirected to parent ZC_ReasonCode,
  _ReasonCodeAll : redirected to ZC_ReasonCode_S
  
}
