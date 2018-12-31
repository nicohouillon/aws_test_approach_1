#!/bin/bash

crontab<<EOF
@reboot stress --cpu 1 --timeout 300
*/5 * * * * stress --cpu 1 --timeout 300
EOF

