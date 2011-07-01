//
// $Id$
//
// aspirin library - Taking some of the pain out of Actionscript development.
// Copyright (C) 2007-2010 Three Rings Design, Inc., All Rights Reserved
// http://code.google.com/p/ooo-aspirin/
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package com.threerings.util {

import flash.events.IEventDispatcher;

public class Controller
{
    /**
     * Set the panel being controlled.
     */
    protected function setControlledPanel (panel :IEventDispatcher) :void
    {
        if (_controlledPanel != null) {
            _controlledPanel.removeEventListener(
                CommandEvent.COMMAND, handleCommandEvent);
        }
        _controlledPanel = panel;
        if (_controlledPanel != null) {
            _controlledPanel.addEventListener(
                CommandEvent.COMMAND, handleCommandEvent);
        }
    }

    /**
     * Post an action so that it can be handled by this controller or
     * another controller above it in the display list.
     */
    public final function postAction (cmd :String, arg :Object = null) :void
    {
        CommandEvent.dispatch(_controlledPanel, cmd, arg);
    }

    /**
     * Handle an action that was generated by our panel or some child.
     *
     * @return true if the specified action was handled, false otherwise.
     *
     * When creating your own controller, override this function and return
     * true for any command handled, and call super for any unknown commands.
     */
    public function handleAction (cmd :String, arg :Object) :Boolean
    {
        // fall back to a method named the cmd
        var fn :Function = null;
        try {
            fn = (this[cmd] as Function);
        } catch (e :Error) {
            // suppress
            //Log.testing("Caught error finding '" + cmd + "()' [" + this + "]");
        }
        if (fn == null) {
            // try the old style with "handle" prepended
            try {
                fn = (this["handle" + cmd] as Function);
            } catch (e :Error) {
                // suppress
                //Log.testing("Caught error finding 'handle" + cmd + "()' [" +
                //    this + "]");
            }
        }
        if (fn == null) {
            // never found it?
            return false;
        }

        // finally, dispatch it
        CommandEvent.dispatch(_controlledPanel, fn, arg);
        return true;
    }

    /**
     * Private function to handle the controller event and call
     * handleAction.
     */
    private function handleCommandEvent (event :CommandEvent) :void
    {
        if (handleAction(event.command, event.arg)) {
            // if we handle the event, stop it from moving outward to another
            // controller
            event.markAsHandled();
        }
    }

    /** The panel currently being controlled. */
    protected var _controlledPanel :IEventDispatcher;
}
}
