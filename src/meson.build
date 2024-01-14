gtk_timer_sources = [
  'timer-standalone.vala',
  'new-timer-dialog.vala',
  'item.vala',
  'window.vala',
  'application.vala',
  'main.vala',
]

gtk_timer_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('gee-0.8'),
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gmodule-2.0'), #useless
]

gtk_timer_sources += gnome.compile_resources(
  'gtk-timer-resources',
  'gtk-timer.gresource.xml',
  c_name: 'gtk_timer'
)

executable('gtk-timer', gtk_timer_sources,
  dependencies: gtk_timer_deps,
  install: true,
)
