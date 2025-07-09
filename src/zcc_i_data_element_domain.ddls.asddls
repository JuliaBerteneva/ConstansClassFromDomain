@AbapCatalog.sqlViewName: 'ZCCIDEDOM'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain for data element'
@Metadata.ignorePropagatedAnnotations: true
define view zcc_i_data_element_domain 
    as select from dd04l
{
    key rollname,
    domname
}
