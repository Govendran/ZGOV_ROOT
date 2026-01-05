@EndUserText.label: 'New Reason Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_NewReasonCode_S
  as select from I_Language
    left outer join ZGOV_RCODES2 on 0 = 0
  composition [0..*] of ZI_NewReasonCode as _NewReasonCode
{
  key 1 as SingletonID,
  _NewReasonCode,
  max( ZGOV_RCODES2.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
