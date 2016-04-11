import os
import configparser

class MarConfParser:
    def __init__(self, file_path, config_settings):
        self._config_settings = config_settings
        self._FILE_PATH = file_path
        self._config = None
        try:
            self._config = self._configParse()
        except IOError as e:
            print('File \"{0}\" is not found'.format(e))
            quit()
        except KeyError as e:
            print('Key \"{0}\" is not found'.format(e))
            quit()
        except Exception as e:
            print('Exception occurred: {0}'.format(e))
            quit()

    def getConfigDict(self):
        return self._config


    def _configParse(self):
        if not os.path.exists(self._FILE_PATH):
            raise IOError(self._FILE_PATH)

        parser = configparser.ConfigParser()
        parser.read(self._FILE_PATH)

        config = {}
        for sect in parser.sections():
            config[sect] = {}
            for opt in parser.options(sect):
                config[sect][opt] = parser.get(sect, opt)

        for sect in self._config_settings.keys():
            if not sect in config:
                raise KeyError(sect)

            for opt_attr in self._config_settings[sect]:
                if opt_attr['required'] and (not opt_attr['name'] in config[sect]):
                    raise KeyError(opt_attr['name'])

                if config[sect][opt_attr['name']] == 'None':
                    config[sect][opt_attr['name']] = None
                else:
                    config[sect][opt_attr['name']] = opt_attr['type'](config[sect][opt_attr['name']])
        
        return config

    def _str_list(self, v):
        return [x for x in v.split('\n') if len(x) != 0]


