from flask import Flask, request, jsonify
from tasks import add

app = Flask(__name__)

@app.post('/sum')
def sum():
  x = int(request.args.get('x'))
  y = int(request.args.get('y'))

  if x is None or y is None:
    return jsonify({'error': 'Missing args x or y'}), 400

  task = add.delay(x, y)
  return jsonify({'task_id': task.id}), 202
