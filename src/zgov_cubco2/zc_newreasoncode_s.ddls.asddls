@EndUserText.label: 'Maintain New Reason Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_NewReasonCode_S
  provider contract transactional_query
  as projection on ZI_NewReasonCode_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _NewReasonCode : redirected to composition child ZC_NewReasonCode
  
}
