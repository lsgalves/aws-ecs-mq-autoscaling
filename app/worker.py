import os

from celery import Celery


app = Celery('worker', broker=os.environ.get('CELERY_BROKER_URL', 'pyamqp://'), backend='rpc://')

import tasks

if __name__ == '__main__':
  app.start()
