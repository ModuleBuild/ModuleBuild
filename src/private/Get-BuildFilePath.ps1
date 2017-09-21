function Get-BuildFilePath {
    $BuildPath = (Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' -ErrorAction:SilentlyContinue | select -First 1).FullName
}