
{%- if pillar.taiga is defined %}
include:
{%- if pillar.taiga.server is defined %}
- taiga.server
{%- endif %}
{%- endif %}
