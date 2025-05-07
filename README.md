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

Enter termainal go to directory by typing ``` cd /home/user/.local/share/plasma/plasmoids/```
then when you're inside the directory enter ```git clone https://github.com/jaynix52/KDE-plasma-widget``` 
to download the widget and then restart plasma 

Next make it active using ```kbuildsycoca6 && systemctl --user restart plasma-plasmashell.service```

Now Add to your desktop/Panel 
   - Right-click desktop/panel → "Add Widgets"
   - Find "Minimal Monitor" in the list
    
This creates a widget that shows:

 -  Panel view: Just a system monitor icon
 -  Expanded view: Simple "Minimal Monitor" text
