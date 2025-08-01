@AbapCatalog.sqlViewName: 'ZCCIDOMATRANS'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Element current transport'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
define view ZCC_I_DOMAIN_TRANSPORT as select from e071
{
    key obj_name,
    trkorr
}
where object = 'DOMA'
