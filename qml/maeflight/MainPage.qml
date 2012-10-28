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
import QtWebKit 1.0
import com.nokia.extras 1.0
import Qt 4.7

Page {
    id: mainPage
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait


        TextField {
               id: airlineBox
               anchors {left: parent.left; right: parent.right; top: parent.top; topMargin: 5}
               platformSipAttributes: SipAttributes { actionKeyHighlighted: true }
               placeholderText: "Airline Code"
               platformStyle: TextFieldStyle { paddingRight: clearButton.width }
               inputMethodHints: Qt.ImhUppercaseOnly | Qt.ImhNoPredictiveText

               Image {
                   id: clearButton
                   anchors.right: parent.right
                   anchors.verticalCenter: parent.verticalCenter
                   source: "image://theme/icon-m-input-clear"
                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           inputContext.reset();
                           airlineBox.text = "";
                           busy1.visible= false;
                           busy1.running= false;
                           webView.url= '/qml/intro.txt'
                       }
                   }
               }
       }

        TextField {
               id: flightBox
               anchors {left: parent.left; right: parent.right; top: airlineBox.bottom; topMargin: 5}
               platformSipAttributes: SipAttributes { actionKeyHighlighted: true }
               placeholderText: "Flight Number"
               platformStyle: TextFieldStyle { paddingRight: clearButton.width }
               validator: IntValidator{bottom: 0; top: 10000000;}
               inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
               focus: false

               Image {
                   id: clearButton2
                   anchors.right: parent.right
                   anchors.verticalCenter: parent.verticalCenter
                   source: "image://theme/icon-m-input-clear"
                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           inputContext.reset();
                           flightBox.text = "";
                           busy1.visible= false;
                           busy1.running= false;
                           webView.url= '/qml/intro.txt'
                       }
                   }
               }
           }

        function getdates (increment) {var t = new Date() ; t.setDate(increment + t.getDate()) ; return t }

        ButtonRow {
            id: dateButtons
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: flightBox.bottom
            anchors.topMargin: 5
            platformStyle: ButtonStyle { inverted: true }

            Button {
                id: yesterday;
                text: Qt.formatDateTime(getdates(-1), "yyyy-MM-dd");
                checked: false
            }

            Button {
                id: today;
                text: Qt.formatDateTime(getdates(0), "yyyy-MM-dd");
                checked: true
            }

            Button {
                id: tomorrow;
                text: Qt.formatDateTime(getdates(1), "yyyy-MM-dd");
                checked: false
            }
        }

        InfoBanner{
            id: banner1
            text: "Multi-Leg Flight"
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        InfoBanner{
            id: banner2
            text: "Flight has Landed"
            anchors.top: parent.top
            anchors.topMargin: 10
        }
        InfoBanner{
            id: banner3
            text: "Flight has Departed"
            anchors.top: parent.top
            anchors.topMargin: 10
        }
        InfoBanner{
            id: banner4
            text: "Flight is Scheduled"
            anchors.top: parent.top
            anchors.topMargin: 10
        }
        InfoBanner{
            id: banner5
            text: "Redirected Flight"
            anchors.top: parent.top
            anchors.topMargin: 10
        }
        InfoBanner{
            id: banner6
            text: "No Flight Found"
            anchors.top: parent.top
            anchors.topMargin: 10
        }
        InfoBanner{
            id: banner7
            text: "Invalid Airline"
            anchors.top: parent.top
            anchors.topMargin: 10
        }

 Flickable{
     id: flick
     clip:  true
     anchors {left: parent.left; right: parent.right; top: dateButtons.bottom; topMargin:5; bottom: search.top; bottomMargin:5}
     width: parent.width; height:parent.height
     contentWidth: parent.width
     contentHeight: 1200//parent.height
     WebView {
         id: webView
         preferredWidth: parent.width
         preferredHeight: parent.height
         anchors {left: parent.left; right: parent.right; top: dateButtons.bottom; topMargin:5}
         url: '/qml/intro.txt'
         onLoadStarted: {busy1.visible= true; busy1.running= true}
         onLoadFinished: {busy1.running= false; busy1.visible= false}
         onLoadFailed: {busy1.running= false; busy1.visible= false}
     }

 }

 ScrollDecorator {
     id: scrollDecorator
     flickableItem: flick
 }

 BusyIndicator {
     id: busy1
     anchors.horizontalCenter: parent.horizontalCenter
     anchors.verticalCenter: parent.verticalCenter
     visible: false
     platformStyle: BusyIndicatorStyle { size: "large" }
     running:  false
 }

 Button{
        id: search
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 5
        text: qsTr("Search")
        onClicked: {
             busy1.visible= true;
             busy1.running= true;
             var doc = new XMLHttpRequest();
             doc.onreadystatechange = function() {
                var b=doc.responseText;
                console.log(b);
                var result;
                if ((result = b.match(/Select a Flight/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text+'&departureDate='+dateButtons.checkedButton.text
                     banner1.show();

                }
                else if ((result = b.match(/landed/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text+'&departureDate='+dateButtons.checkedButton.text
                     banner2.show();

                }
                else if ((result = b.match(/departed/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text+'&departureDate='+dateButtons.checkedButton.text
                     banner3.show();

                }
                else if ((result = b.match(/scheduled/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text+'&departureDate='+dateButtons.checkedButton.text
                     banner4.show();

                }
                else if ((result = b.match(/redirected/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text+'&departureDate='+dateButtons.checkedButton.text
                     banner5.show();

                }
                else if (result = b.match(/No flight found/)){
                     console.log("No Flight Found")
                     webView.settings.autoLoadImages= false
                     webView.url= '/qml/error.txt'
                     banner6.show();
                }

                else if (result = b.match(/Invalid airline/)){
                     console.log("Invalid Airline")
                     webView.settings.autoLoadImages= false
                     webView.url= '/qml/error.txt'
                     banner7.show();

                }

              }

            doc.open("GET", 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text+'&departureDate='+dateButtons.checkedButton.text);
            doc.send();


        }
 }



}
