# Writing Pester tests with ModuleBuild

We wont go deep into how to write pester tests, just how they are integrated into ModuleBuild.

ModuleBuild sorts Pester tests in 3 flavours. Meta, Unit and Intergration tests.

- Meta are very basics tests such as file encoding or Tabs vs Spaces
- Unit testing is a type of testing to check if the small piece of code is doing what it is suppose to do
- Integration testing is a type of testing to check if different pieces of the modules are working together

You will most likely only write Unit tests for your powershell module.

## Matching the folder structure

When writing tests you are expected to match the folder structure of the src folder.
For example, if you want to unit test `src\public\Write-SomeTestModule.ps1` you are expected to create the following test file at `tests\unit\public\Write-SomeTestModule.Tests.ps1`.

The  `tests\unit\public\Write-SomeTestModule.Tests.ps1` would look something like this.
The first 8 lines do some 'magic' to replace the path of the current file and match it to the correct source file.

```powershell
#Requires -Modules Pester
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests stucture we can use this to dotsource the function.
$here = $here -replace 'tests\\unit', 'src'

. "$here\$sut"

Describe "Testing Write-SomeTestModule" -Tags @('UnitTest') {
    it "Should return a specific string: (Yerp. This is a function.)" {
        $result = Write-SomeTestModule
        $result | Should -Be "Yerp. This is a function."
    }
}
```

## Tagging your tests

To support different kind of tests ModuleBuild uses Tags in the pester files. These are specified in `Describe` as following:

```powershell
Describe "Testing Write-SomeTestModule" -Tags @('UnitTest') {
    ...
}
```

During the build process pester is started multiple times and told to run tests with tag X. This ensure only specific type of tests are ran when we want them to.

Possible tags:

- UnitTest
- MetaTest
- IntergrationTest
