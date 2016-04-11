from marconfparser import MarConfParser
import io
import dropbox

SETTINGS_FILE = "../settings.conf"
CONFIG_SETTINGS = {
    'dropbox': [
        {'name':'token', 'type': str, 'required': True},
    ],
    'hardware': [
        {'name':'bootbin', 'type': str, 'required': True},
    ],
}

if __name__ == '__main__':
    mcp = MarConfParser(SETTINGS_FILE, CONFIG_SETTINGS)
    config = mcp.getConfigDict()

    dbx_client = dropbox.client.DropboxClient(config['dropbox']['token'])

    f = open('../' + config['hardware']['bootbin'], "rb")
    response = dbx_client.put_file(config['dropbox']['position'] + "BOOT.bin", f)
    
