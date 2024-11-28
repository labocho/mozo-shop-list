#!/bin/bash
curl 'https://tts.ejwcloud.jp/api/012' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  --data-raw 'facility_id=8&auth_key=mozo1&is_shop_ancly_info=1&floor_seq=9&sorted_by_section_no=true' > public/shop_list.json
