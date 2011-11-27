/**********************************************************************
 * Copyright 2011 Sanjeev Visvanatha
 *
 * This file is part of MaeFlight.
 *
 * MaeFlight is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * MaeFlight is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MaeFlight.  If not, see <http://www.gnu.org/licenses/>
 *
 ***********************************************************************/
import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage{id: mainPage}

    function loadAboutDialog() {
        return instantiateComponent("AboutDialog.qml", {})
    }

    function instantiateComponent(file, properties) {
        console.log("createComponent", file)
        var component = Qt.createComponent(file)
        console.log("/createComponent", file)

        if (component.status == Component.Ready) {
            console.log("createObject", file)
            var comp = component.createObject(mainPage, properties)
            console.log("/createObject", file)
            return comp
        }
        else
            console.log("Error loading component:", component.errorString());

    }


    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon { platformIconId: "toolbar-view-menu";
             anchors.right: parent===undefined ? undefined : parent.right
             onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: "About MaeFlight"; onClicked: loadAboutDialog().open() }
        }
    }
}
