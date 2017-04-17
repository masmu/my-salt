import os
import urllib
import subprocess
from gi.repository import Nautilus, GObject

DEFAULT_FILE_NAME = 'Unbenannte Datei'


def location(file_info):
    return urllib.unquote(file_info.get_uri()[7:])


class NewFileProvider(GObject.GObject, Nautilus.MenuProvider):

    def __get_menu_item(self):
        return Nautilus.MenuItem(
            name="NewFileExtension::NewFile",
            label="Neue Textdatei",
            tip="Neue Textdatei anlegen")

    def menu_activate_cb(self, menu, target):
        path = os.path.join(location(target), DEFAULT_FILE_NAME)
        if not os.path.exists(path):
            subprocess.Popen(['touch', path])

    def get_background_items(self, window, current_directory):
        item = self.__get_menu_item()
        item.connect('activate', self.menu_activate_cb, current_directory)
        return [item]
