import os, urllib, subprocess
from gi.repository import Nautilus, GObject

def location(file_info):
    return urllib.unquote(file_info.get_uri()[7:])

class SeriatimExtractHereProvider(GObject.GObject, Nautilus.MenuProvider):

    def __get_menu_item(self):
        return Nautilus.MenuItem(
            name="SeriatimExtension::ExtractHere",
            label="Hier Stapelentpacken ...",
            tip="Hier Stapelentpacken")

    def menu_activate_cb(self, menu, target):
        command = subprocess.list2cmdline(
            ['seriatim', '-d', '-s', '-r', '--auto-delete', location(target)])
        process = subprocess.Popen(['gnome-terminal', '-e', command])

    def get_file_items(self, window, files):
        if len(files) == 1 and files[0].is_directory():
            item = self.__get_menu_item()
            item.connect('activate', self.menu_activate_cb, files[0])
            return [item]

    def get_background_items(self, window, current_directory):
        item = self.__get_menu_item()
        item.connect('activate', self.menu_activate_cb, current_directory)
        return [item]

class SeriatimSendToExtractionProvider(GObject.GObject, Nautilus.MenuProvider):

    def __verify_files(self, files):
        if len(files) == 0:
            return False
        for f in files:
            if f.is_directory() or not self.__is_archive(f):
                return False
        return True

    def __is_archive(self, file_info):
        name, extension = os.path.splitext(file_info.get_name())
        return extension in ['.rar', '.zip']

    def __get_menu_item(self):
        return Nautilus.MenuItem(
            name="SeriatimExtension::SendToExtraction",
            label="An Stapelentpacker senden ...",
            tip="An Stapelentpacker senden")

    def menu_activate_cb(self, menu, targets):
        command = subprocess.list2cmdline(
            ['seriatim', '-d'] + map(lambda t: location(t), targets))
        process = subprocess.Popen(['gnome-terminal', '-e', command])

    def get_file_items(self, window, files):
        if self.__verify_files(files):
            item = self.__get_menu_item()
            item.connect('activate', self.menu_activate_cb, files)
            return [item]
