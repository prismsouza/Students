#!/usr/bin/env bash

if [[ -d laravel ]]
then
    docker-compose up -d
else
  composer create-project --prefer-dist laravel/laravel laravel
fi
