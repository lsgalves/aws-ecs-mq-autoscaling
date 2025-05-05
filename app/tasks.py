import time
from datetime import datetime

from celery import shared_task


@shared_task
def add(x, y):
  time.sleep(x + y)
  return x + y
