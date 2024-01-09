/* window.vala
 *
 * Copyright 2024 Unknown
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GtkTimer {

[GtkTemplate (ui = "/com/github/ashkanarabim/gtktimer/window.ui")]
public class Window : Adw.ApplicationWindow {
    private Row[] timers;

    // UI elements from template
    [GtkChild]
    private unowned Gtk.ListBox timer_list;

    // constructors
    public Window (Gtk.Application app) {
        Object (application: app);

        // add hardcoded timer for 10 mins
        timers += new Row.from_hms(10, 0, 0);

        // add timers
        for (int i = 0; i < timers.length; i++) {
            timer_list.append(timers[i]);
        }
    }

    // internal logic
    [GtkCallback]
    public void open_new_timer_dialog () {
        var new_window = new NewTimerDialog();
        new_window.done.connect(add_new_timer);
        new_window.present();
    }

    //  public void update_UI () {
    //      // TODO: finish this

    //      // remove all children
    //      // ques: how?

    //      // append children
    //      for (int i = 0; i < timers.length; i++) {
    //          timer_list.append(timers[i]);
    //      }
    //  }

    public void add_new_timer (Row r) {
        this.timers += r;
        this.timer_list.append(r);
    }
}

}
