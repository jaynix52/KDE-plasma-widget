import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

Item {
    id: root
    
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    
    // Update every 2 seconds
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: plasmoid.dataUpdated()
    }
    
    // Compact view (panel)
    Plasmoid.compactRepresentation: ColumnLayout {
        spacing: 0
        
        PlasmaComponents.Label {
            text: "🖥 " + cpuPercent + "%"
            font.pointSize: 8
            opacity: 0.8
        }
        
        PlasmaComponents.Label {
            text: "🧠 " + memPercent + "%"
            font.pointSize: 8
            opacity: 0.8
        }
    }
    
    // Expanded view (click to show)
    Plasmoid.fullRepresentation: ColumnLayout {
        spacing: 4
        
        RowLayout {
            PlasmaComponents.Label {
                text: "CPU:"
                font.pointSize: 9
                opacity: 0.7
            }
            PlasmaComponents.Label {
                text: cpuPercent + "%"
                font.pointSize: 9
            }
        }
        
        RowLayout {
            PlasmaComponents.Label {
                text: "RAM:"
                font.pointSize: 9
                opacity: 0.7
            }
            PlasmaComponents.Label {
                text: memPercent + "% (" + (memUsed/1024).toFixed(1) + "G/" + (memTotal/1024).toFixed(0) + "G)"
                font.pointSize: 9
            }
        }
        // For temperature (requires lm_sensors)
    PlasmaCore.DataSource {
                id: tempSource
                    engine: "systemmonitor"
                    interval: 5000
                    connectedSources: ["temp/core0/input"]
            onNewData: tempValue = Math.round(data.value)
}
        // Add more metrics as needed...
    }
    
    // Data sources
    property int cpuPercent: 0
    property int memPercent: 0
    property real memUsed: 0
    property real memTotal: 0
    
    PlasmaCore.DataSource {
        id: cpuSource
        engine: "systemmonitor"
        interval: 2000
        connectedSources: ["cpu/all/usage"]
        onNewData: cpuPercent = Math.round(data.value)
    }
    
    PlasmaCore.DataSource {
        id: memSource
        engine: "systemmonitor"
        interval: 2000
        connectedSources: ["mem/used", "mem/total"]
        onNewData: {
            if (data.sourceName == "mem/used") memUsed = data.value
            if (data.sourceName == "mem/total") memTotal = data.value
            memPercent = Math.round((memUsed/memTotal)*100)
        }
    }
}
