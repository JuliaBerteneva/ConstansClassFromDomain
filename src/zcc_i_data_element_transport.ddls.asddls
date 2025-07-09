@AbapCatalog.sqlViewName: 'ZCCIDETRANS'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Element current transport'
@Metadata.ignorePropagatedAnnotations: true
define view zcc_i_data_element_transport as select from e071
{
    key obj_name,
    trkorr
}
where object = 'DTEL'
