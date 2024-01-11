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
    //  private Timer[] timers;
    private Gee.ArrayList<Timer> timers = new Gee.ArrayList<Timer>();

    // UI elements from template
    [GtkChild]
    private unowned Gtk.ListBox timer_UI_list;

    // constructors
    public Window (Gtk.Application app) {
        Object (application: app);

        // remove after adding GSettings support vv
        Timer default_timer = new Timer.from_hms(10, 0, 0, "default timer");
        add_timer(default_timer);
        // remove after adding GSettings support ^^

        // add timers
        redraw_timers();
    }

    // internal logic
    [GtkCallback]
    public void open_new_timer_dialog () {
        var new_window = new NewTimerDialog();
        new_window.done.connect(add_timer);
        new_window.present();
    }

    public void add_timer (Timer r) {
        r.deleted.connect((idx) => delete_timer(idx));
        r.index = timers.size;
        this.timers.add(r);
        this.timer_UI_list.append(r);
    }

    public void redraw_timers() {
        timer_UI_list.remove_all();
        for (int i = 0; i < timers.size; i++) {
            timer_UI_list.append(timers[i]);
        }
    }

    public void reindex_timers(int deleted_idx) {
        for (int i = deleted_idx; i < timers.size; i++) {
            timers[i].index = i;
        }
    }

    //  note: the whole delete operation can be re-written to not use indices
    public void delete_timer (int idx) {
        timer_UI_list.remove(timers[idx]);
        timers.remove_at(idx);
        //  timers.remove(timers[idx]); // worked!
        redraw_timers();
        reindex_timers(idx);
    }
}

}
