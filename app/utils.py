import os
from urllib.parse import urlparse


def get_broker_url():
  url = os.environ.get('BROKER_URL', 'pyamqp://')
  parsed = urlparse(url)

  broker_scheme = os.environ.get('BROKER_SCHEME', parsed.scheme)
  broker_username = os.environ.get('BROKER_USERNAME', parsed.username)
  broker_password = os.environ.get('BROKER_PASSWORD', parsed.password)
  broker_host = os.environ.get('BROKER_HOST', parsed.hostname)
  broker_port = os.environ.get('BROKER_PORT', parsed.port)

  broker_auth = f'{broker_username}:{broker_password}@' if broker_username and broker_password else ''

  broker_url =  f'{broker_scheme}://{broker_auth}{broker_host}:{broker_port}//'
  os.environ['CELERY_BROKER_URL'] = broker_url
  return broker_url
