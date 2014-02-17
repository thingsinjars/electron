AutoUpdater = process.atomBinding('auto_updater').AutoUpdater
EventEmitter = require('events').EventEmitter

AutoUpdater::__proto__ = EventEmitter.prototype

autoUpdater = new AutoUpdater
autoUpdater.on 'update-downloaded-raw', (args...) ->
  args[3] = new Date(args[3])  # releaseDate
  @emit 'update-downloaded', args..., => @quitAndInstall()

autoUpdater.quitAndInstall = ->
  # If we don't have any window then quitAndInstall immediately.
  BrowserWindow = require 'browser-window'
  windows = BrowserWindow.getAllWindows()
  if windows.length is 0
    AutoUpdater::quitAndInstall.call this
    return

  # Do the restart after all windows have been closed.
  app = require 'app'
  app.removeAllListeners 'window-all-closed'
  app.once 'window-all-closed', AutoUpdater::quitAndInstall.bind(this)
  win.close() for win in windows

module.exports = autoUpdater
