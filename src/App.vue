<script setup lang="ts">
import { onMounted, ref, computed } from 'vue'
import type { Ref } from 'vue'

interface FloorMap {
  facility_floor_name: string
  floor_count: number
  floor_title_list: []
  id: string
  img: string
  shop_list: Shop[]
}

interface Shop {
  facility_floor_name: string // "1F"
  id: string // "10311"
  logo_img: string // "/contents/shopinfo/mozo1/a8548a408003d0ef6676d5a3aabccacb_01_04.jpg"
  main_img: string // "/contents/shopinfo/mozo1/36b4ff85698c8efefabfdd9bccd90677_01_01.jpg"
  shop_ancly_info: string // "スポーツ棟1F"
  shop_ancly_info_list: {
    facility_incdl_display_seq: string // "5"
    shop_ancly_info: string // "【月～水・金】9:30～23:15\n..."
  }[]
  shop_category_name: string // "アミューズ＆スクール"
  shop_category_seq: string // "630"
  shop_introduce_flag: number // 1
  shop_introduce_text1: string // "あなたにはまる、あなたのためのフィットネスクラブが誕生しました。"
  shop_kana_name: string // "アイレクス　マイフィットネス　モゾ"
  shop_name: string // "アイレクス マイフィットネス mozo"
  shop_sub_category: {
    id: string // "2470"
    shop_category_name: string // "スポーツクラブ／ジュニアスクール"
  }[]
}
const shopList: Ref<{floor_map: FloorMap}[]> = ref([])
const query = ref("")

onMounted(() => {
  fetch("/shop_list.json").then((resp) => {
    if (resp.body === null) return;

    resp.body.getReader().read().then((result) => {
      const s = new TextDecoder().decode(result.value);
      shopList.value = JSON.parse(s);
    })
  })
})


const shops = computed(() => {
  return shopList.value.flatMap((o) => {
    return o.floor_map.shop_list
  })
})

const filtered = computed(() => {
  const q = query.value.toLowerCase();
  return shops.value.filter((shop) => {
    return shop.shop_name.toLowerCase().includes(q) || shop.shop_kana_name.toLowerCase().includes(q)
  })
})

function floorForShop(shop: Shop) {
  const o = shopList.value.find((o) => {
    return o.floor_map.shop_list.find((s) => {
      return s.id === shop.id
    })
  })

  return o?.floor_map
}

</script>

<template>
  <div class="container">
    <h1>mozo ショップリスト</h1>
    <form action="/">
      <input type="text" class="form-control mb-4 mt-4" placeholder="キーワード" v-model="query">
    </form>
    <table class="table">
      <thead>
        <tr>
          <th>名前</th>
          <th>フロア</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="shop in filtered" :key="shop.id">
          <td>{{ shop.shop_name }}</td>
          <td>
            <a :href="'https://img.tts.ejwcloud.jp' + floorForShop(shop)?.img" target="_blank">
              {{ shop.facility_floor_name }} ({{ shop.shop_ancly_info }})
            </a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
