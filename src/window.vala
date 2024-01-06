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
    private int original_len = 10 * 60; // 10 mins default
    private int length = 10 * 60;
    private int64 target = 0;
    private int remaining = 0;
    private bool running = false;

    [GtkChild]
    private unowned Gtk.Label display;
    //  [GtkChild]
    //  private unowned Gtk.Button start_button;
    //  [GtkChild]
    //  private unowned Gtk.Button stop_button;
    //  [GtkChild]
    //  private unowned Gtk.Button pause_button;

    public Window (Gtk.Application app) {
        Object (application: app);
    }

    //  temporarily put all logic here. --------
    // UI logic ---
    private void update_display(int s) {
        int h = s / 3600;
        int m = (s / 60) % 60; 
        s = s % 60;
        display.set_text("%02i:%02i:%02i".printf(h, m, s));
    }

    [GtkCallback]
    private void on_start_clicked() {
        start();
    }
    [GtkCallback]
    private void on_stop_clicked() {
        stop();
    }
    [GtkCallback]
    private void on_pause_clicked() {
        pause();
    }

    // button functions ---
    private void start() { 
        this.target = new GLib.DateTime.now_local().to_unix() + this.length;
        this.running = true;
        int? last_remaining = null;
        GLib.Timeout.add(100, () => {
            int64 now = new GLib.DateTime.now_local().to_unix();
            this.remaining = (int) (this.target - now);

            if (last_remaining == null || last_remaining != this.remaining) {
                update_display(this.remaining);
                last_remaining = this.remaining;
            }

            if (this.remaining <= 0) {
                stop();
            }

            return this.running;
        });
    }

    private void stop() {
        this.running = false;
        reset();
    }

    private void pause() {
        // edge case: what if already paused?
        if (!this.running) {return;}
        
        // edge case: what if already past this time?
        int64 now = new GLib.DateTime.now_local().to_unix();
        if (this.target <= now) {return;}

        this.running = false;
        this.length = (int) (target - now);
    }

    private void reset() {
        this.length = this.original_len;
        update_display(this.original_len);
    }
}

}
