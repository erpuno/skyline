#!/bin/bash

# npm install uglify-js -g

# keep the order
declare -a sc=(
  bootstrap-affix.js.min
  bootstrap-alert.js.min
  bootstrap-button.js.min
  bootstrap-carousel.js.min
  bootstrap-collapse.js.min
  bootstrap-dropdown.js.min
  bootstrap-modal.js.min
  bootstrap-tooltip.js.min
  bootstrap-scrollspy.js.min
  bootstrap-tab.js.min
  bootstrap-transition.js.min
  bootstrap-typeahead.js.min
  bootstrap-popover.js.min
);

cd deps/bootstrap/js
for i in `ls -d * | grep js`; do
  echo -n 'process' $i'...'
  uglifyjs $i -o $i.min;
  echo 'done'
done

rm -f bootstrap.min.js
cat ${sc[@]} > bootstrap.min.js
rm -r *.min
cp bootstrap.min.js ../../../apps/web/priv/static/js/
rm -f bootstrap.min.js
cd ../../..




