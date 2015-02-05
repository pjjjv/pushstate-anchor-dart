/*
 *  Pushstate Anchor - dart
 *  Copyright (c) 2015 pjv
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert';

  // Extend the <a> tag with history.pushState()
  //
  // <a is="pushstate-anchor" href="/path" [title="New Page Title"] [state="{'message':'New State!'}"]>title</a>

@CustomTag('pushstate-anchor')
class PushstateAnchor extends AnchorElement with Polymer, Observable {

  @published String state;
  //@published String title;
  //@published String href;

  PushstateAnchor.created() : super.created() {
    polymerCreated();
    this.addEventListener('click', pushStateAnchorEventListener, false);
  }

  void pushStateAnchorEventListener(Event event) {
    // open in new tab
    if ((event is MouseEvent && (event.ctrlKey || event.metaKey || event.which == 2)) ||
        (event is KeyboardEvent && (event.ctrlKey || event.metaKey || event.which == 2))) {
      return;
    }

    Map stateMap = {};
    if (this.state != null){
      stateMap = JSON.decode(this.state);
    }

    window.history.pushState(stateMap, this.title, this.href);

    try {
      PopStateEvent popstateEvent = new Event.eventType('PopStateEvent', 'popstate', canBubble: false, cancelable: false);
      //popstateEvent.state = window.history.state;

      /*if (window.dispatchEvent_ != null) {
        // FireFox with polyfill
        window.dispatchEvent_(popstateEvent);
      } else {*/ //TODO
        // normal
        window.dispatchEvent(popstateEvent);
      /*}*/
    } catch(error) {
      // Internet Exploder
      /*var fallbackEvent = document.createEvent('CustomEvent');
      fallbackEvent.initCustomEvent('popstate', false, false, { state: {} });
      window.dispatchEvent(fallbackEvent);*/ //TODO
    }

    event.preventDefault();
  }
}