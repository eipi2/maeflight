import QtQuick 1.1
import com.meego 1.0
import QtWebKit 1.0
import com.nokia.extras 1.0


Page {
    id: mainPage
    tools: commonTools


        TextField {
               id: airlineBox
               anchors {left: parent.left; right: parent.right; topMargin: 10}
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
               anchors {left: parent.left; right: parent.right; top: airlineBox.bottom; topMargin: 10}
               platformSipAttributes: SipAttributes { actionKeyHighlighted: true }
               placeholderText: "Flight Number"
               platformStyle: TextFieldStyle { paddingRight: clearButton.width }
               validator: IntValidator{bottom: 0; top: 10000000;}
               inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText

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
     anchors {left: parent.left; right: parent.right; top: flightBox.bottom; topMargin:10; bottom: search.top; bottomMargin:10}
     width: parent.width; height:parent.height
     contentWidth: parent.width
     contentHeight: 1200//parent.height
     WebView {
         id: webView
         preferredWidth: parent.width
         preferredHeight: parent.height
         anchors {left: mainPage.left; right: mainPage.right; top: flightBox.bottom; topMargin:10}
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
        anchors.topMargin: 10
        text: qsTr("Search")
        onClicked: {
             busy1.visible= true;
             busy1.running= true;
             var doc = new XMLHttpRequest();
             doc.onreadystatechange = function() {
                 var b=doc.responseText;
                 console.log(b);
                 var result;
//                if ((result = b.match(/select flight/i)) || (result = b.match(/landed/i)) || (result = b.match(/departed/i)) || (result = b.match(/scheduled/i)) || (result = b.match(/redirected/i)))
                if ((result = b.match(/select flight/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text
                     banner1.show();

                }
                else if ((result = b.match(/landed/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text
                     banner2.show();

                }
                else if ((result = b.match(/departed/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text
                     banner3.show();

                }
                else if ((result = b.match(/scheduled/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text
                     banner4.show();

                }
                else if ((result = b.match(/redirected/i)))
                {
                     console.log(result);
                     webView.settings.autoLoadImages= false
                     webView.url= 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text
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

            doc.open("GET", 'http://www.flightstats.com/go/Mobile/flightStatusByFlightProcess.do?&airlineCode='+airlineBox.text+'&flightNumber='+flightBox.text);
            doc.send();


        }
 }



}
