function Edit-HostsFile {
    Start-Process -FilePath gvim -ArgumentList "$env:windir\system32\drivers\etc\hosts"
}

