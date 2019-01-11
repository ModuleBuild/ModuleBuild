function Get-BuildFilePath {
    $BuildPath = (Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' -ErrorAction:SilentlyContinue | Select-Object -First 1).FullName
}