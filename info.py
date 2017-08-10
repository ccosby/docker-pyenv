#!/usr/bin/env python

from __future__ import print_function
import platform
import os

print('Platform:      ', platform.platform())
print('Python version:', platform.python_version())
print('UID:           ', os.getuid())
