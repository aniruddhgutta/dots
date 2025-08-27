require('vis')

-- plugin manager
-- local plug = (function() if not pcall(require, 'plugins/vis-plug') then
--    os.execute('git clone --quiet https://github.com/erf/vis-plug ' .. 
--        (os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') .. '/.config')
--            .. '/vis/plugins/vis-plug')
-- end return require('plugins/vis-plug') end)()
--
-- plug.init({
--  { 'https://github.com/erf/vis-cursors' },
--  { 'https://github.com/thimc/vis-colorizer' },
--  { 'https://github.com/erf/vis-title' },
--  { 'https://repo.or.cz/vis-pairs' },
--  { 'https://repo.or.cz/vis-surround' },
--  { 'https://gitlab.com/muhq/vis-lockfiles' },
--  { 'https://gitlab.com/muhq/vis-lspc', alias = 'lspc' },
-- }, true)

-- per window configuration options
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  vis:command('set autoindent on')
  vis:command('set tabwidth 2')
  vis:command('set relativenumbers on')
  vis:command('set colorcolumn 80')
  vis:command('set ignorecase on')
end)
