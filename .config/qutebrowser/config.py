import os
import pywalQute.draw
from pathlib import Path

config.load_autoconfig(False)
c.content.headers.user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36"

STARTPAGE = Path("~/.config/qutebrowser/startpage.html").expanduser().as_uri()
c.url.default_page = STARTPAGE
c.url.start_pages = STARTPAGE
c.url.searchengines = {
    'DEFAULT': 'https://apps.disroot.org/search?q={}'
}

c.tabs.show = 'multiple'
c.tabs.last_close = 'startpage'
c.scrolling.bar = 'when-searching'
# c.statusbar.show = 'in-mode'

c.colors.webpage.preferred_color_scheme = 'dark'
c.completion.height = '30%'
c.completion.open_categories = ['searchengines', 'bookmarks', 'history', 'quickmarks', 'filesystem']

c.content.blocking.method = 'adblock'
c.content.blocking.adblock.lists = [
    'https://easylist.to/easylist/easylist.txt',
    'https://easylist.to/easylist/easyprivacy.txt',
    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt',
]

# c.content.pdfjs = True
c.input.mode_override = 'normal'
c.keyhint.delay = 0
c.content.javascript.clipboard = 'access-paste'
c.downloads.location.prompt = False

pywalQute.draw.color(c, {
    'spacing': {
        'vertical': 1,
        'horizontal': 1
    }
})
