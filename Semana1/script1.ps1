==========================================Script de Administración del SO - Windows==========================================Nombre del archivo de salida con marca de tiempo$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFile = "reporte_sistema_$Timestamp.txt"Usar Start-Transcript para redirigir toda la salida de pantalla al archivoStart-Transcript -Path $OutputFile -NoClobberWrite-Host ""
Write-Host "        REPORTE DEL SISTEMA WINDOWS       " -ForegroundColor Cyan
Write-Host "Fecha de generación: $(Get-Date)"
Write-Host ""1. BLOQUE CPUWrite-Host "------------------------------------------" -ForegroundColor Yellow
Write-Host "$$1$$ INFORMACIÓN DE LA CPU" -ForegroundColor Yellow
Write-Host "------------------------------------------"
Get-CimInstance Win32_Processor | Select-Object Name, DeviceID, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed | Format-List
Write-Host ""2. BLOQUE MEMORIAWrite-Host "------------------------------------------" -ForegroundColor Yellow
Write-Host "$$2$$ INFORMACIÓN DE LA MEMORIA RAM" -ForegroundColor Yellow
Write-Host "------------------------------------------"
Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed, DeviceLocator | Format-Table -AutoSize
Write-Host ""3. BLOQUE ALMACENAMIENTOWrite-Host "------------------------------------------" -ForegroundColor Yellow
Write-Host "$$3$$ ALMACENAMIENTO Y VOLÚMENES" -ForegroundColor Yellow
Write-Host "------------------------------------------"
Write-Host "--- Discos Físicos ---" -ForegroundColor Green
Get-PhysicalDisk | Select-Object FriendlyName, MediaType, OperationalStatus, Size | Format-Table -AutoSizeWrite-Host "--- Volúmenes y Particiones ---" -ForegroundColor Green
Get-Volume | Select-Object DriveLetter, FileSystemLabel, FileSystem, DriveType, @{Name="SizeRemaining(GB)";Expression={$$math$$::round($_.SizeRemaining/1GB,2)}}, @{Name="Size(GB)";Expression={[math]::round($_.Size/1GB,2)}} | Format-Table -AutoSize
Write-Host ""4. BLOQUE BUSES Y ENTRADA/SALIDAWrite-Host "------------------------------------------" -ForegroundColor Yellow
Write-Host "$$4$$ BUSES Y DISPOSITIVOS E/S (Presentes)" -ForegroundColor Yellow
Write-Host "------------------------------------------"
Get-PnpDevice -PresentOnly | Where-Object { $_.Status -eq "OK" } | Select-Object FriendlyName, Class | Select-Object -First 20 | Format-Table -AutoSize
Write-Host ""5. BLOQUE RESUMENWrite-Host "------------------------------------------" -ForegroundColor Yellow
Write-Host "$$5$$ RESUMEN GENERAL DEL SISTEMA" -ForegroundColor Yellow
Write-Host "------------------------------------------"
systeminfo | Select-Object -First 30
Write-Host ""
Write-Host "Nota: Para un resumen detallado con interfaz gráfica, ejecuta el comando 'msinfo32'." -ForegroundColor GrayWrite-Host ""
Write-Host "         FIN DEL REPORTE DE SISTEMA       " -ForegroundColor Cyan
Write-Host ""Finalizar la grabación de salidaStop-TranscriptWrite-Host ""
Write-Host "$$i$$ El reporte ha sido guardado exitosamente en: $OutputFile" -ForegroundColor Gree