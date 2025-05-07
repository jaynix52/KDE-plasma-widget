import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root
    
    // Compact view (shown in panel)
    compactRepresentation: RowLayout {
        spacing: Kirigami.Units.smallSpacing
        
        // CPU
        PlasmaComponents.Label {
            text: `${cpuPercent}%`
            font.pointSize: 8
            opacity: 0.9
        }
        
        // GPU (only shown if detected)
        PlasmaComponents.Label {
            text: gpuAvailable ? `${gpuPercent}%` : ""
            font.pointSize: 8
            opacity: 0.9
            color: gpuTemp > 75 ? "#ff6b6b" : PlasmaCore.Theme.textColor
        }
    }
    
    // Expanded view (shown when clicked)
    fullRepresentation: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing
        
        // CPU
        RowLayout {
            PlasmaComponents.Label {
                text: "CPU:"
                font.pointSize: 9
                Layout.minimumWidth: Kirigami.Units.gridUnit * 3
            }
            PlasmaComponents.ProgressBar {
                value: cpuPercent / 100
                Layout.fillWidth: true
            }
            PlasmaComponents.Label {
                text: `${cpuPercent}%`
                font.pointSize: 9
            }
        }
        
        // GPU (if available)
        RowLayout {
            visible: gpuAvailable
            PlasmaComponents.Label {
                text: `${gpuName}:`
                font.pointSize: 9
                Layout.minimumWidth: Kirigami.Units.gridUnit * 3
            }
            PlasmaComponents.ProgressBar {
                value: gpuPercent / 100
                Layout.fillWidth: true
            }
            PlasmaComponents.Label {
                text: `${gpuPercent}% ${gpuTemp}°C`
                font.pointSize: 9
                color: gpuTemp > 75 ? "#ff6b6b" : PlasmaCore.Theme.textColor
            }
        }
        
        // RAM
        RowLayout {
            PlasmaComponents.Label {
                text: "RAM:"
                font.pointSize: 9
                Layout.minimumWidth: Kirigami.Units.gridUnit * 3
            }
            PlasmaComponents.ProgressBar {
                value: memUsed / memTotal
                Layout.fillWidth: true
            }
            PlasmaComponents.Label {
                text: `${Math.round(memPercent)}% (${(memUsed/1024).toFixed(1)}/${(memTotal/1024).toFixed(0)} GB)`
                font.pointSize: 9
            }
        }
    }
    
    // System data properties
    property int cpuPercent: 0
    property int gpuPercent: 0
    property int gpuTemp: 0
    property string gpuName: "GPU"
    property bool gpuAvailable: false
    property real memUsed: 0
    property real memTotal: 0
    property real memPercent: 0
    
    // Update data every 2 seconds
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: updateStats()
    }
    
    // Data collection function
    function updateStats() {
        // CPU Usage
        cpuPercent = parseInt(Plasmoid.executeCommand("top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}'"));
        
        // RAM Usage
        const memInfo = Plasmoid.executeCommand("free -b | grep Mem").trim().split(/\s+/);
        memTotal = parseInt(memInfo[1]);
        memUsed = parseInt(memInfo[2]);
        memPercent = (memUsed / memTotal) * 100;
        
        // GPU Detection (supports NVIDIA/AMD/Intel)
        detectGpu();
    }
    
    // Automatic GPU detection
    function detectGpu() {
        // Try NVIDIA first
        const nvidiaInfo = Plasmoid.executeCommand("nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,name --format=csv,noheader,nounits 2>/dev/null").trim();
        
        if (nvidiaInfo) {
            const parts = nvidiaInfo.split(',');
            gpuPercent = parseInt(parts[0]);
            gpuTemp = parseInt(parts[1]);
            gpuName = parts.slice(2).join(',').trim();
            gpuAvailable = true;
            return;
        }
        
        // Try AMD
        const amdUsage = parseInt(Plasmoid.executeCommand("cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo 0"));
        const amdTemp = parseInt(Plasmoid.executeCommand("cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1")) / 1000;
        
        if (amdUsage > 0) {
            gpuPercent = amdUsage;
            gpuTemp = amdTemp;
            gpuName = "AMD GPU";
            gpuAvailable = true;
            return;
        }
        
        // Try Intel
        const intelUsage = parseInt(Plasmoid.executeCommand("intel_gpu_top -o - -s 1 | awk '/GPU/ {print $4}' | head -1 2>/dev/null || echo 0"));
        const intelTemp = parseInt(Plasmoid.executeCommand("cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -1")) / 1000;
        
        if (intelUsage > 0) {
            gpuPercent = intelUsage;
            gpuTemp = intelTemp;
            gpuName = "Intel GPU";
            gpuAvailable = true;
            return;
        }
        
        gpuAvailable = false;
    }
}
