/*
  Copyright (C) 2013, 2014 Martin Grimme  <martin.grimme _AT_ gmail.com>

  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow
{
    property alias feedName: sourcesModel.names
    property alias feedColor: sourcesModel.colors

    SourcesModel {
        id: sourcesModel

        onModelChanged: {
            var sources = [];
            for (var i = 0; i < count; i++) {
                sources.push(get(i));
            }
            newsBlendModel.sources = sources;
        }

        Component.onCompleted: {
            if (count === 0) {
                // add example feeds
                addSource("Engadget",
                          "http://www.engadget.com/rss.xml",
                          "#ff0000");
                addSource("JollaUsers.com",
                          "http://jollausers.com/feed/",
                          "#ffa000");
            }
        }
    }

    NewsBlendModel {
        id: newsBlendModel

        onError: {
            console.log("Error: " + details);
            notification.show(details);
        }
    }

    QtObject {
        id: navigationState

        signal openedItem(int index)
    }

    QtObject {
        id: coverAdaptor

        property string feedName
        property string title
        property string thumbnail
        property string page
        property string currentPage: (pageStack.depth > 0)
                                     ? pageStack.currentPage.objectName
                                     : ""
        property variant lastRefresh: newsBlendModel.lastRefresh
        property int totalCount: newsBlendModel.count
        property bool busy: newsBlendModel.busy

        property bool hasPrevious
        property bool hasNext

        signal refresh
        signal abort
        signal firstItem
        signal previousItem
        signal nextItem
    }

    ConfigValue {
        id: configFeedSorter
        key: "feed-sort-by"
        value: "latestFirst"
    }

    ConfigValue {
        id: configShowPreviewImages
        key: "feed-preview-images"
        value: "1"
    }

    ConfigValue {
        id: configTintedItems
        key: "feed-tinted"
        value: "1"
    }

    ConfigValue {
        id: configFontScale
        key: "font-scale"
        value: "100"
    }

    Timer {
        id: initTimer
        interval: 500
        running: true

        onTriggered: {
            newsBlendModel.loadPersistedItems();
            pageStack.replace(sourcesPage);
        }
    }

    Timer {
        id: minuteTimer

        property bool tick: true

        triggeredOnStart: true
        running: Qt.application.active
        interval: 60000
        repeat: true

        onTriggered: {
            tickChanged();
        }
    }

    Notification {
        id: notification
    }

    initialPage: splashPage
    cover: coverPage

    Component {
        id: splashPage

        SplashPage { }
    }

    Component {
        id: sourcesPage

        SourcesPage { }
    }

    Component {
        id: coverPage

        CoverPage { }
    }
}
