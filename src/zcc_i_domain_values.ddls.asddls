@AbapCatalog.sqlViewName: 'ZCCIDOMVAL'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain values'
@VDM.viewType: #BASIC
define view zcc_i_domain_values
  with parameters
    i_domname : domname
  as select from dd07l as l
    inner join   dd07t as t on  t.domname  = l.domname
                            and t.as4local = l.as4local
                            and t.valpos   = l.valpos
                            and t.as4vers  = l.as4vers
{
  key l.domvalue_l as Value,
      @Semantics.text: true
      t.ddtext     as Description
}
where
      l.domname    = :i_domname
  and t.ddlanguage = $session.system_language
