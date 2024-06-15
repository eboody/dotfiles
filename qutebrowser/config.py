config.load_autoconfig()

# Bind Ctrl+O to go back
config.bind('<Ctrl-o>', 'back')

# Bind Ctrl+I to go forward
config.bind('<Ctrl-i>', 'forward')

# Bind H to switch to the previous tab
config.bind('H', 'tab-prev')

# Bind L to switch to the next tab
config.bind('L', 'tab-next')

# Bind J to page down
config.bind('J', 'scroll-page 0 1')

# Bind K to page up
config.bind('K', 'scroll-page 0 -1')

c.fonts.hints = 'bold 12pt FantasqueSansM Nerd Font Mono'
config.bind('D', 'config-cycle colors.webpage.darkmode.enabled')
