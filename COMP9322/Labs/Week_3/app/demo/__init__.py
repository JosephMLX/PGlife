# -*- coding: utf-8 -*-
from __future__ import absolute_import

from flask import Flask

import sys
import v1


def create_app():
    app = Flask(__name__, static_folder='static')
    app.register_blueprint(
        v1.bp,
        url_prefix='/v1')
    return app

if __name__ == '__main__':
    print("all arguments: {}".format(sys.argv))
    create_app().run("0.0.0.0", debug=True)