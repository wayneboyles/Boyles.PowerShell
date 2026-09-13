function Disconnect-Hudu {
    [CmdletBinding()]
    [OutputType([void])]
    param ()

    try {
        if (Test-BPSClient -Key 'hudu') {
            Remove-BPSClient -Key 'hudu'
            Write-Verbose 'Hudu is now disconnected.'
        } else {
            Write-Verbose 'Hudu is not connected, nothing to disconnect.'
        }
    } catch {
        Write-Error 'Unable to fully clean up the session.  The session may still be active.'
    }
}
