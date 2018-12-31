#!/bin/bash

crontab<<EOF
*/5 * * * * stress --cpu 1 --timeout 300'
EOF

