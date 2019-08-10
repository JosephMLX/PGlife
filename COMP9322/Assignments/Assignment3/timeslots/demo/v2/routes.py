# -*- coding: utf-8 -*-

###
### DO NOT CHANGE THIS FILE
### 
### The code is auto generated, your change will be overwritten by 
### code generating.
###
from __future__ import absolute_import

from .api.timeslots_name import TimeslotsName
from .api.timeslots_book import TimeslotsBook
from .api.timeslots_cancle import TimeslotsCancle


routes = [
    dict(resource=TimeslotsName, urls=['/timeslots/<name>'], endpoint='timeslots_name'),
    dict(resource=TimeslotsBook, urls=['/timeslots/book'], endpoint='timeslots_book'),
    dict(resource=TimeslotsCancle, urls=['/timeslots/cancle'], endpoint='timeslots_cancle'),
]