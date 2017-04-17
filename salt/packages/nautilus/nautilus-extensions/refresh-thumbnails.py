import os, urllib, subprocess
from gi.repository import Nautilus, GObject

def location(file_info):
    return urllib.unquote(file_info.get_uri()[7:])

class NautilusRefeshThumbnailProvider(GObject.GObject, Nautilus.MenuProvider):

    def __get_menu_item(self):
        return Nautilus.MenuItem(
            name="NautilusExtension::RefreshThumbnail",
            label="Vorschaubild aktualisieren ...",
            tip="Vorschaubild aktualisieren")

    def __verify_files(self, files):
        if len(files) == 0:
            return False
        for f in files:
            if f.is_directory():
                return False
        return True

    def menu_activate_cb(self, menu, targets):
        binary = os.path.expanduser('~/.bin/refresh-thumbnails')
        process = subprocess.Popen(
            [binary] + map(lambda t: location(t), targets))

    def get_file_items(self, window, files):
        if self.__verify_files(files):
            item = self.__get_menu_item()
            item.connect('activate', self.menu_activate_cb, files)
            return [item]
