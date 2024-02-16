-- Enable the `hs` interactive prompt.
require("hs.ipc")

-- Delete events from mouse buttons 5 and 6 (the "programmable" side buttons of
-- the Kensington Pro Fit Ergo Vertical Wireless Trackball, whose first-party
-- software merely does the equivalent this instead of actually programming
-- the device)
MouseSilencer = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown }, function(e)
  local buttonNumber = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
  return buttonNumber == 5 or buttonNumber == 6
end):start()
