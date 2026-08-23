<script setup lang="ts">
import { withBase } from 'vitepress'
import EbMark from '../brand/EbMark.vue'
import EbEvidenceTerminal from './EbEvidenceTerminal.vue'
</script>

<template>
  <section class="eb-hero eb-wrap">
    <div class="eb-hero__main">
      <p class="eb-hero__eyebrow">
        <EbMark />
        <span>EmbedBox · 嵌入式中的 CSAPP</span>
      </p>
      <h1 class="eb-hero__title">一个程序的一生</h1>
      <p class="eb-hero__tag">
        从一行 <code>hello.c</code>,到一份 CI 背书的串口运行证据。
      </p>
      <div class="eb-hero__actions">
        <a class="eb-btn eb-btn--solid" :href="withBase('/journey/')">走主线</a>
        <a class="eb-btn" :href="withBase('/journey/00-env-check')">从第一个历程开始</a>
      </div>
    </div>
    <div class="eb-hero__side">
      <EbEvidenceTerminal />
    </div>
  </section>
  <p class="eb-titleblock eb-wrap" aria-hidden="true">
    <span>DOC EBOX-JOURNEY-2026</span>
    <span>REV 2026.08</span>
    <span>CHECKED-BY: CI ✓</span>
  </p>
</template>

<style scoped>
.eb-wrap {
  max-width: 1120px;
  margin: 0 auto;
  padding-inline: 24px;
}

.eb-hero {
  display: grid;
  grid-template-columns: 1.02fr 0.98fr;
  gap: 56px;
  align-items: center;
  padding-top: 72px;
  padding-bottom: 48px;
}

.eb-hero__eyebrow {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 0 0 20px;
  font-family: var(--eb-mono);
  font-size: 12.5px;
  font-weight: 500;
  letter-spacing: 0.12em;
  color: var(--vp-c-brand-1);
}

.eb-hero__title {
  margin: 0 0 18px;
  font-size: clamp(2.5rem, 5.2vw, 3.9rem);
  font-weight: 700;
  line-height: 1.22;
  letter-spacing: 0.01em;
  color: var(--vp-c-text-1);
}

.eb-hero__tag {
  margin: 0 0 32px;
  font-size: 1.06rem;
  line-height: 1.85;
  color: var(--vp-c-text-2);
}

.eb-hero__tag code {
  font-family: var(--eb-mono);
  font-size: 0.88em;
  padding: 0.1em 0.4em;
  border-radius: 4px;
  background: var(--vp-c-bg-mute);
  color: var(--vp-c-text-1);
}

.eb-hero__actions {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
}

/* 卷宗按钮:墨色印章,不是品牌绿 —— 信号绿只属于终端与落章 */
.eb-btn {
  display: inline-flex;
  align-items: center;
  height: 44px;
  padding: 0 22px;
  border-radius: 8px;
  border: 1px solid var(--vp-c-border);
  font-size: 14.5px;
  font-weight: 500;
  color: var(--vp-c-text-1);
  text-decoration: none !important;
  transition: border-color 0.2s ease, background-color 0.2s ease;
}

.eb-btn--solid {
  background: var(--vp-c-text-1);
  border-color: var(--vp-c-text-1);
  color: var(--vp-c-bg);
}

.eb-btn:hover {
  border-color: var(--vp-c-brand-1);
}

.eb-btn--solid:hover {
  background: var(--vp-c-brand-1);
  border-color: var(--vp-c-brand-1);
  color: #fff;
}

/* 图签行:hero 与信任带之间的档案边界 */
.eb-titleblock {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  margin: 0 auto 40px;
  padding-top: 12px;
  border-top: 1px solid var(--vp-c-divider);
  font-family: var(--eb-mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  color: var(--vp-c-text-3);
}

@media (max-width: 960px) {
  .eb-hero {
    grid-template-columns: 1fr;
    gap: 40px;
    padding-top: 48px;
  }
}
</style>
