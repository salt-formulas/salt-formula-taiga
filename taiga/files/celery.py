{%- from "taiga/map.jinja" import server with context -%}
# -*- coding: utf-8 -*-

from kombu import Queue

broker_url = 'amqp{% if server.message_queue.get('ssl', False) %}s{% endif %}://{{ server.message_queue.user }}:{{ server.message_queue.password }}@{{ server.message_queue.host }}:{{ server.message_queue.get('port', 5672) }}/{{ server.message_queue.get('virtual_host', '/') }}'
result_backend = 'redis://localhost:6379/0'

accept_content = ['pickle',] # Values are 'pickle', 'json', 'msgpack' and 'yaml'
task_serializer = "pickle"
result_serializer = "pickle"

timezone = '{{ pillar.linux.system.timezone|default("UTC") }}'

task_default_queue = 'tasks'
task_queues = (
    Queue('tasks', routing_key='task.#'),
    Queue('transient', routing_key='transient.#', delivery_mode=1)
)
task_default_exchange = 'tasks'
task_default_exchange_type = 'topic'
task_default_routing_key = 'task.default'

{#-
vim: syntax=jinja
-#}
