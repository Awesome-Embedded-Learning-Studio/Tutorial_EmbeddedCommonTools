<script setup lang="ts">
// EmbedBox 品牌 mark(芯片说 hello)。currentColor 驱动,明暗模式随文。
// 几何与 public/embedbox-mark.svg 同源,改动需两处同步。
</script>

<template>
  <svg class="eb-mark" viewBox="0 0 24 24" fill="none" aria-hidden="true">
    <rect x="3" y="6.8" width="10.4" height="10.4" rx="2" stroke="currentColor" stroke-width="1.6" />
    <path d="M0.8 9.2H3M0.8 12H3M0.8 14.8H3" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" />
    <path d="M13.4 9.2H15.4M13.4 14.8H15.4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" />
    <path d="M13.4 12H16.2V9.6H18.8V12H20.4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" />
    <circle cx="22.2" cy="12" r="1.05" fill="currentColor" />
  </svg>
</template>

<style scoped>
.eb-mark {
  display: inline-block;
  width: 1.3em;
  height: 1.3em;
  vertical-align: -0.28em;
}
</style>
