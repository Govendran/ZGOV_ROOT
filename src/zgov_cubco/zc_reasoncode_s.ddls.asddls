@EndUserText.label: 'Maintain Reason Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_ReasonCode_S
  provider contract transactional_query
  as projection on ZI_ReasonCode_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _ReasonCode : redirected to composition child ZC_ReasonCode
  
}
