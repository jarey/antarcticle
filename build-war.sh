#!/bin/sh

# compile assets
RAILS_ENV=development rake assets:clean && rake assets:precompile && RAILS_RELATIVE_URL_ROOT=/antarcticle RAILS_ENV=development rake assets:precompile

# build war
RAILS_ENV=production warble
