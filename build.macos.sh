#!/usr/bin/env bash

flutter clean
flutter config --enable-web
flutter pub get 
flutter build web
docker-compose -f docker-compose-macos.yml up --build --force-recreate
