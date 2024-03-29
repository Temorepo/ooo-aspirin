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

package com.threerings.ui {

import flash.events.ContextMenuEvent;
import flash.ui.ContextMenuItem;

import com.threerings.util.CommandEvent;

/**
 */
public class MenuUtil
{
    /**
     * Create a context menu item that will submit a command when selected.
     */
    public static function createCommandContextMenuItem (
        caption :String, cmdOrFn :Object, arg :Object = null,
        separatorBefore :Boolean = false, enabled :Boolean = true) :ContextMenuItem
    {
        var item :ContextMenuItem = new ContextMenuItem(caption, separatorBefore, enabled);
        item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,
            function (event :ContextMenuEvent) :void {
                // mouseTarget may be null due to security reasons
                CommandEvent.dispatch(event.mouseTarget || event.contextMenuOwner, cmdOrFn, arg);
            });
        return item;
    }
}
}
