# -*- coding: utf-8 -*-

###
### DO NOT CHANGE THIS FILE
### 
### The code is auto generated, your change will be overwritten by 
### code generating.
###
from __future__ import absolute_import

from .api.dentist import Dentist
from .api.dentist_name import DentistName


routes = [
    dict(resource=Dentist, urls=['/dentists/'], endpoint='dentist'),
    dict(resource=DentistName, urls=['/dentists/<name>'], endpoint='dentist_name'),
]