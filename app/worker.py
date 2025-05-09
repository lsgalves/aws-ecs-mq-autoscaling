from utils import get_broker_url
from celery import Celery


app = Celery('worker', broker=get_broker_url(), backend='rpc://')

import tasks

if __name__ == '__main__':
  app.start()
