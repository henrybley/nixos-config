import qs.Services
import qs.Config
import qs.Modules.Audio as AudioPanel
import qs.Modules.Workspace as WorkspacePanel
import qs.Modules.Clock as ClockPanel
import qs.Modules.Launcher as Launcher
//import qs.Modules.Notifications as Notifications
/*import qs.modules.session as Session
import qs.modules.dashboard as Dashboard*/
import qs.Modules.Bar.Popouts as BarPopouts
import qs.Modules.Utilities
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Panels panels
    required property Item bar

    anchors.fill: parent
    anchors.margins: Config.style.borderThickness
    anchors.leftMargin: bar.implicitWidth
    preferredRendererType: Shape.CurveRenderer
    opacity: Config.colours.transparency.enabled ? Config.colours.transparency.base : 1


    AudioPanel.Background {
        wrapper: panels.audio

        startX: root.width - panels.session.width
        startY: (root.height - wrapper.height) / 2 - rounding
    }

    WorkspacePanel.Background {
        wrapper: panels.workspace

        startX: root.width / 2 - (wrapper.width / 2) - rounding/3
        startY: 0
    }
    
    ClockPanel.Background {
        wrapper: panels.clock
        
        startX: root.width
        startY: 0
    }
    
    Launcher.Background {
        wrapper: panels.launcher

        startX: (root.width - wrapper.width) / 2 - rounding
        startY: root.height
    }
    
    /*Notifications.Background {
        wrapper: panels.notifications

        startX: root.width
        startY: 0
    }*/

    /*Session.Background {
        wrapper: panels.session

        startX: root.width
        startY: (root.height - audio.height) / 2 - rounding
    }

    

    Dashboard.Background {
        wrapper: panels.dashboard

        startX: (root.width - audio.width) / 2 - rounding
        startY: 0
    }

    BarPopouts.Background {
        wrapper: panels.popouts
        invertBottomRounding: audio.y + audio.height + 1 >= root.height

        startX: audio.x
        startY: audio.y - rounding * sideRounding
    }

    Utilities.Background {
        wrapper: panels.utilities

        startX: root.width
        startY: root.height
    }*/
}
