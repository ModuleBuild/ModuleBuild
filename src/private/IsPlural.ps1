function IsPlural {
    [cmdletbinding()]
    Param (
        [String]$Noun
    )
    $null = [reflection.assembly]::LoadWithPartialName('System.Data.Entity.Design')
    $ci = [cultureinfo]::CurrentCulture
    $pluralservice = [System.Data.Entity.Design.PluralizationServices.PluralizationService]::CreateService($ci)
    $pluralservice.IsPlural($Noun)
}