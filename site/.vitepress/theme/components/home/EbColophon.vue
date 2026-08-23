<script setup lang="ts">
import { withBase } from 'vitepress'
import { LEGACY_LINKS } from './journey-data'
</script>

<template>
  <p class="eb-colophon eb-wrap">
    <span class="eb-colophon__label">补课索引 · 参考篇(建设中)</span>
    <template v-for="(l, i) in LEGACY_LINKS" :key="l.link">
      <a :href="withBase(l.link)">{{ l.text }}</a>
      <span v-if="i < LEGACY_LINKS.length - 1" class="eb-colophon__sep">·</span>
    </template>
  </p>
</template>

<style scoped>
.eb-wrap {
  max-width: 1120px;
  margin: 0 auto;
  padding-inline: 24px;
}

.eb-colophon {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  gap: 10px;
  margin: 0 auto;
  padding-top: 44px;
  padding-bottom: 72px;
  font-size: 13px;
  color: var(--vp-c-text-3);
}

.eb-colophon__label {
  font-family: var(--eb-mono);
  font-size: 11.5px;
  letter-spacing: 0.08em;
}

.eb-colophon a {
  color: var(--vp-c-text-2);
  text-decoration: none;
  border-bottom: 1px dotted var(--vp-c-text-3);
  transition: color 0.18s ease;
}

.eb-colophon a:hover {
  color: var(--vp-c-brand-1);
  border-bottom-color: var(--vp-c-brand-1);
}

.eb-colophon__sep { color: var(--vp-c-divider); }
</style>
