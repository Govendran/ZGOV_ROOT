@EndUserText.label: 'Reason Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_ReasonCode_S
  as select from I_Language
    left outer join ZGOV_RCODES on 0 = 0
  composition [0..*] of ZI_ReasonCode as _ReasonCode
{
  key 1 as SingletonID,
  _ReasonCode,
  max( ZGOV_RCODES.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
