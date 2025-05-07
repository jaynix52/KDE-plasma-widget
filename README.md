# KDE-plasma-widget
minimal system monitor for KDE plasma widget | arch linux 

Move these files with these names in your home directory:

```bash

~/.local/share/plasma/plasmoids/
└── KDE-plasma-widget.minimalmonitor/
    ├── contents/
    │   ├── ui/
    │   │   └── main.qml
    │   └── config/
    │       └── main.xml
    └── metadata.desktop
```
    
Create the directories:

```mkdir -p ~/.local/share/plasma/plasmoids/KDE-plasma-widget.minimalmonitor/contents/{ui,config}```
  Create each file using text editor kate,nano or vim and copy contents metadata.desktop, main.xml, ui from main.qml and make save

Next make it active using ```kbuildsycoca5 && kquitapp5 plasmashell && kstart5 plasmashell```

Now Add to your desktop/Panel 
    Right-click desktop/panel → "Add Widgets"
    Find "Minimal Monitor" in the list
    
This creates a widget that shows:

   Panel view: Just a system monitor icon
   Expanded view: Simple "Minimal Monitor" text
