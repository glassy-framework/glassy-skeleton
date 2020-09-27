#!/bin/sh
watchexec -r -w src --signal SIGTERM -- "make app_dev && bin/app server:run"
