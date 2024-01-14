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

namespace Timer {

[GtkTemplate (ui = "/com/github/ashkanarabim/gtktimer/window.ui")]
public class Window : Adw.ApplicationWindow {
    //  private Item[] timers;
    private Gee.ArrayList<Item> timers = new Gee.ArrayList<Item>();

    // UI elements from template
    [GtkChild]
    private unowned Gtk.ListBox timer_UI_list;
    [GtkChild]
    private unowned Adw.NavigationView nav_view;
    [GtkChild]
    private unowned Standalone timer_standalone;

    // constructors
    public Window (Gtk.Application app) {
        Object (application: app);

        // remove after adding GSettings support vv
        Item default_timer = new Item.from_hms(10, 0, 0, "default timer");
        add_timer(default_timer);
        //  this.timer_standalone.item = default_timer;
        // remove after adding GSettings support ^^

        // DEBUG
        //  Standalone s = new Standalone();
        //  message ("standalone was created.");

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

    public void open_edit_timer_dialog (Item old_timer) {
        var edit_window = new NewTimerDialog.edit(old_timer);
        edit_window.done.connect((new_timer) => {
            this.delete_timer(old_timer.index);
            this.add_timer(new_timer);
        });
        edit_window.present();
    }

    public void open_standalone(Item t) {
        this.timer_standalone.item = t;
        this.nav_view.push(this.timer_standalone);
    }

    public void add_timer (Item t) {
        t.deleted.connect((idx) => this.delete_timer(idx));
        t.edit.connect(() => this.open_edit_timer_dialog(t));
        t.show_standalone.connect(this.open_standalone);
        t.index = timers.size;
        this.timers.add(t);
        this.timer_UI_list.append(t);
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
