import time

from utils import get_broker_url
from celery import shared_task

get_broker_url()

@shared_task
def add(x, y):
  time.sleep(x + y)
  return x + y
