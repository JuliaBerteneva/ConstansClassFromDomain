@AbapCatalog.sqlViewName: 'ZCCIDOMPACK'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain package'
@Metadata.ignorePropagatedAnnotations: true
define view zcc_i_domain_package
  as select from tadir
{
  key obj_name,
  devclass
}
where
  object = 'DOMA'
