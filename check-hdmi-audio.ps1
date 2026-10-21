# Read-only check for HDMI audio: decodes monitor EDID audio data and lists audio endpoints.
# Run as administrator (WmiMonitorDescriptorMethods needs elevation).

$names = @{ 1 = 'Audio'; 2 = 'Video'; 3 = 'VendorSpecific'; 4 = 'SpeakerAlloc'; 7 = 'Extended' }
$tech = @{ '5' = 'HDMI'; '10' = 'DisplayPort'; '2147483648' = 'Internal' }

$conn = @{}
Get-CimInstance -Namespace root\wmi WmiMonitorConnectionParams | ForEach-Object {
    $conn[$_.InstanceName] = $tech["$($_.VideoOutputTechnology)"]
}

Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorDescriptorMethods | ForEach-Object {
    $inst = $_.InstanceName
    "== $inst ($($conn[$inst]))"
    for ($blk = 1; $blk -lt 4; $blk++) {
        try {
            $r = Invoke-CimMethod -InputObject $_ -MethodName WmiGetMonitorRawEEdidV1Block -Arguments @{ BlockId = [byte]$blk } -ErrorAction Stop
        } catch { break }
        $b = $r.BlockContent
        if ($b[0] -ne 0x02) { continue }   # not a CTA-861 block
        "  CTA-861 block $blk : basicAudio={0}" -f (($b[3] -band 0x40) -ne 0)
        $i = 4
        while ($i -lt $b[2]) {
            $tag = $b[$i] -shr 5
            $len = $b[$i] -band 0x1F
            $payload = ($b[($i + 1)..($i + $len)] | ForEach-Object { $_.ToString('X2') }) -join ' '
            "    {0} len={1}: {2}" -f $names[[int]$tag], $len, $payload
            $i += 1 + $len
        }
    }
}

"== Audio endpoints"
Get-PnpDevice -Class AudioEndpoint -Status OK | ForEach-Object { "  $($_.FriendlyName)" }
