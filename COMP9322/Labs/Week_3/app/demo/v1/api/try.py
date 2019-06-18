import json
from flask import jsonify

path = "/Users/mlx/Desktop/PGlife/COMP9322/labs/week_3/app/demo/v1/api/students.json"
with open(path) as f:
    students = json.load(f)

print(students)