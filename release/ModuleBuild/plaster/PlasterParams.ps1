# Our plaster parameters
$Parameters = @(
    @{
        ParameterName = "ModuleName"
        ParameterType = "text"
        ParameterPrompt = "Enter the name of the module. No space, underscores, or special characters are allowed"
    },
    @{
        ParameterName = "ModuleDescription"
        ParameterType = "text"
        ParameterPrompt = "Enter a description of your module"
    },
    @{
        ParameterName = "ModuleAuthor"
        ParameterType = "text"
        ParameterPrompt = "Enter a module author"
    },
    @{
        ParameterName = "ModuleWebsite"
        ParameterType = "text"
        ParameterPrompt = "Enter a project website (ie. https://www.github.com/<author>/<modulename>)"
    },
    @{
        ParameterName = "ModuleVersion"
        ParameterType = "text"
        ParameterPrompt = "Enter the version number of the module"
        Default = "0.0.1"
    },
    @{
        ParameterName = "ModuleTags"
        ParameterType = "text"
        ParameterPrompt = "Comma separate list of tags that describe this module. This is required for the PowerShell Gallery"
    },
    @{
        ParameterName = "AdditionalModulePaths"
        ParameterType = "text"
        ParameterPrompt = "Comma separate list of paths that will be included with the final module release (ie. .\libs,.\data)"
        Default = ' '
    },
    @{
        ParameterName = "ProjectLicense"
        ParameterType = "choice"
        ParameterPrompt = "What license would you like for this module to have?"
        Default = "0"
        Choices = @(
            @{
                Label = "&Creative Commons"
                Help = "This license lets others distribute, remix, tweak, and build upon your work, even commercially, as long as they credit you for the original creation."
                Value = "CreativeCommons"
            },
            @{
                Label = "&MIT"
                Help = "A short, permissive software license. Basically, you can do whatever you want as long as you include the original copyright and license notice in any copy of the software/source."
                Value = "MIT"
            },
            @{
                Label = "&Apache 2.0"
                Help = "You can do what you like with the software, as long as you include the required notices. This permissive license contains a patent license from the contributors of the code."
                Value = "Apache"
            },
            @{
                Label = "&GPL 3.0"
                Help = "You may copy, distribute and modify the software as long as you track changes/dates in source files. Any modifications to or software including (via compiler) GPL-licensed code must also be made available under the GPL along with build & install instructions."
                Value = "GPL"
            }
        )
    },
    @{
        ParameterName = "OptionAnalyzeCode"
        ParameterType = "choice"
        ParameterPrompt = "Use PSScriptAnalyzer in the module build process (Recommended for Gallery uploading)?"
        Default = "0"
        Choices = @(
            @{
                Label = "&Yes"
                Help = "Enable script analysis"
                Value = "True"
            },
            @{
                Label = "&No"
                Help = "Disable script analysis"
                Value = "False"
            }
        )
    },
    @{
        ParameterName = "OptionCombineFiles"
        ParameterType = "choice"
        ParameterPrompt = "Combine scripts into one psm1 in the module build process (Recommended for Gallery uploading)?"
        Default = "0"
        Choices = @(
            @{
                Label = "&Yes"
                Help = "Combine source files"
                Value = "True"
            },
            @{
                Label = "&No"
                Help = "Do not combine source files"
                Value = "False"
            }
        )
    },
    @{
        ParameterName = "OptionUpdateVersionAfterPublishing"
        ParameterType = "choice"
        ParameterPrompt = "Automatically increase the module patch version after publishing to the gallary?"
        Default = "0"
        Choices = @(
            @{
                Label = "&Yes"
                Help = "Increase the patch version after a successful publish to the gallery"
                Value = "True"
            },
            @{
                Label = "&No"
                Help = "Do not increase the patch version after a successful gallery publish"
                Value = "False"
            }
        )
    },
    @{
        ParameterName = "OptionSanitizeSensitiveTerms"
        ParameterType = "choice"
        ParameterPrompt = "Scan for sensitive terms (like your user id or company domain) in the module build process (Recommended for Gallery uploading)?"
        Default = "0"
        Choices = @(
            @{
                Label = "&Yes"
                Help = "Sanitize sensitive terms"
                Value = "True"
            },
            @{
                Label = "&No"
                Help = "Do not sanitize sensitive terms"
                Value = "False"
            }
        )
    },
    @{
        ParameterName = "OptionGenerateReadTheDocs"
        ParameterType = "choice"
        ParameterPrompt = "Generate YML file in build process for ReadTheDocs.org integration?"
        Default = "0"
        Choices = @(
            @{
                Label = "&Yes"
                Help = "The YML file will get regenerated at every build. This file gets saved in the root folder of your project."
                Value = "True"
            },
            @{
                Label = "&No"
                Help = "No YML file will be generated."
                Value = "False"
            }
        )
    }
)