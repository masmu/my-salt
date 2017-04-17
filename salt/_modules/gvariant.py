import json
import re

P = re.compile(ur'^-?[0-9]+$')

def quote(s):
    return s.replace('"', '\\"')

def _parse_bool(string):
    if string == 'true':
        return True
    if string == 'false':
        return False
    return None

def _parse_list(string):
    if string.startswith('@as [') and string.endswith(']'):
        chopped = string[4:]
        chopped = chopped.replace('\'', '"')
        return json.loads(chopped)
    if string.startswith('[') and string.endswith(']'):
        if string == '[\'\']':
            return ['']
        if string == '[]':
            return []
        chopped = string.replace('\'', '"')
        return json.loads(chopped)
    return None

def _parse_string(string):
    if string.startswith('\'') and string.endswith('\''):
        chopped = string[1:-1]
        return chopped
    if len(string) == 0:
        return ''
    return string

def _parse_int(string):
    if string.startswith('uint32'):
        string = string[7:]
    if re.search(P, string):
        return int(string)
    return None

def loads(string, _type=None):
    if not _type:
        for func in [_parse_bool, _parse_list, _parse_int, _parse_string]:
            value = func(string)
            if value is not None:
                return value
    elif _type == 'type b':
        value = _parse_bool(string)
        if type(value) is not bool:
            raise ValueError()
        return value
    elif _type == 'type as' or _type.startswith('flags\n'):
        value = _parse_list(string)
        if type(value) is not list:
            return []
        return value
    elif _type == 'type s' or _type.startswith('enum'):
        value = _parse_string(string)
        if type(value) is not str:
            return ''
        return value
    elif _type in ['type u', 'type i'] or _type.startswith('range i'):
        value = _parse_int(string)
        if type(value) is not int:
            raise ValueError()
        return value

    raise NotImplementedError()

def dumps(obj):
    if type(obj) is None:
        raise NotImplementedError()
    if type(obj) is bool:
        return 'true' if obj else 'false'
    if type(obj) is list:
        obj = map(lambda x: quote(x.encode('ascii','ignore')), obj)
        return '@as {}'.format(obj)
    if type(obj) is str:
        return '"{}"'.format(quote(obj.encode('ascii','ignore')))
    if type(obj) is int:
        return str(obj)
    raise NotImplementedError()