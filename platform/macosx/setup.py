from setuptools import setup

APP = ['restool.py']
DATA_FILES = []
OPTIONS = {
    'packages': ['PIL','yaml'],
    'iconfile': 'zelda3.icns',
    'plist': {
        'CFBundleDevelopmentRegion': 'English',
        'CFBundleIdentifier': "io.github.snesrev.Zelda3",
        'CFBundleVersion': "1.0.0",
        'CFBundleExecutable': "zelda3.sh",
        'NSHumanReadableCopyright': u"Copyright © 2023, snesrev, All Rights Reserved"
    }
}

setup(
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
