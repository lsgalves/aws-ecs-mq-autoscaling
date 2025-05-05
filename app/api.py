from flask import Flask, request, jsonify
from tasks import add

app = Flask(__name__)

@app.route('/add-task', methods=['POST'])
def add_task():
  data = request.get_json()
  x = data.get('x')
  y = data.get('y')

  if x is None or y is None:
    return jsonify({'error': 'Missing parameters x or y'}), 400

  task = add.delay(x, y)
  return jsonify({'task_id': task.id}), 202
