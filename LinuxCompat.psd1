@{
    # Core module info
    RootModule        = 'LinuxCompat.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'b7c1c8c1-2f4e-4e2b-9e3a-1f0b9e0a0001'

    Author            = 'TG Tran'
    Copyright         = '(c) 2026'

    Description       = 'LinuxCompat: Linux-style commands and utilities for PowerShell on Windows, Linux, and macOS.'

    # PowerShell compatibility
    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop','Core')

    # Files
    FileList = @(
        'LinuxCompat.psm1'
    )

    # Functions & Aliases are exported automatically by the module
    FunctionsToExport = '*'
    AliasesToExport   = '*'
    CmdletsToExport   = @()
    VariablesToExport = @()

    # Private data (optional)
    PrivateData = @{
        PSData = @{
            Tags = @('linux','compatibility','utilities','commands')
        }
    }
}
