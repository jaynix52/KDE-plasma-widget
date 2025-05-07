import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: "utilities-system-monitor"
    }
    
    Plasmoid.fullRepresentation: PlasmaCore.Label {
        text: "Minimal Monitor"
    }
}

