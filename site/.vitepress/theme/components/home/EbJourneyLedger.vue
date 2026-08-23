<script setup lang="ts">
import { withBase } from 'vitepress'
import { STAGES } from './journey-data'
</script>

<template>
  <section class="eb-ledger eb-wrap">
    <header id="beats" class="eb-sec">
      <span class="eb-sec__label">CONTENTS · 历程目录</span>
      <span class="eb-sec__rule" />
      <span class="eb-sec__hint">
        <b class="ok">✓</b> CI 逐字重放&nbsp;&nbsp;·&nbsp;&nbsp;<b class="man">◦</b> manual 人工走查
      </span>
    </header>

    <nav class="eb-ledger__list">
      <a v-for="s in STAGES" :key="s.link" class="stage" :href="withBase(s.link)">
        <span class="stage__label" :class="s.tier === 'manual' ? 'stage__label--manual' : ''">{{ s.label }}</span>
        <span class="stage__title">{{ s.title }}</span>
        <span class="stage__dots" />
        <span class="stage__story">{{ s.story }}</span>
        <span class="stage__badge" :class="s.tier === 'manual' ? 'stage__badge--manual' : ''">
          <template v-if="s.tier === 'ci'">✓ 已验证</template>
          <template v-else>◦ 需硬件</template>
        </span>
      </a>
    </nav>
  </section>
</template>

<style scoped>
.eb-wrap {
  max-width: 1120px;
  margin: 0 auto;
  padding-inline: 24px;
}

.eb-ledger {
  padding-top: 44px;
}

/* 小节头:mono 眉题 + 延伸规线 */
.eb-sec {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 28px;
}

.eb-sec__label {
  font-family: var(--eb-mono);
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.14em;
  color: var(--vp-c-text-2);
  white-space: nowrap;
}

.eb-sec__rule {
  flex: 1;
  height: 1px;
  background: var(--vp-c-divider);
}

.eb-sec__hint {
  font-size: 12px;
  color: var(--vp-c-text-3);
  white-space: nowrap;
}

.eb-sec__hint .ok { color: var(--vp-c-brand-1); font-weight: 600; }
.eb-sec__hint .man { color: var(--vp-c-text-2); font-weight: 600; }

.stage {
  display: grid;
  grid-template-columns: 6.4rem minmax(0, auto) 1fr minmax(0, 22rem) auto;
  align-items: baseline;
  gap: 12px;
  padding: 11px 12px 11px 10px;
  border-left: 2px solid transparent;
  text-decoration: none !important;
  transition: border-color 0.18s ease, background-color 0.18s ease;
}

/* 卷宗纪律:hover 只亮左色条与点线,不位移 */
.stage:hover {
  border-left-color: var(--vp-c-brand-1);
  background: var(--vp-c-bg-soft);
}

.stage__label {
  font-family: var(--eb-mono);
  font-size: 12.5px;
  font-weight: 600;
  color: var(--vp-c-brand-1);
  white-space: nowrap;
}

.stage__label--manual { color: var(--vp-c-text-3); }

.stage__title {
  font-size: 15.5px;
  font-weight: 600;
  color: var(--vp-c-text-1);
  white-space: nowrap;
}

.stage:hover .stage__title { color: var(--vp-c-brand-1); }

.stage__dots {
  align-self: center;
  height: 1px;
  min-width: 24px;
  border-bottom: 1.5px dotted var(--vp-c-divider);
  transition: border-color 0.18s ease;
}

.stage:hover .stage__dots { border-color: var(--vp-c-brand-2); }

.stage__story {
  font-size: 13px;
  color: var(--vp-c-text-2);
  line-height: 1.6;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
}

.stage__badge {
  font-family: var(--eb-mono);
  font-size: 11px;
  letter-spacing: 0.04em;
  color: var(--vp-c-brand-1);
  white-space: nowrap;
}

.stage__badge--manual { color: var(--vp-c-text-3); }

@media (max-width: 900px) {
  .stage {
    grid-template-columns: 1fr auto;
    grid-template-areas:
      'label badge'
      'title title';
    row-gap: 3px;
  }

  .stage__label { grid-area: label; }
  .stage__badge { grid-area: badge; }
  .stage__title { grid-area: title; }

  .stage__dots,
  .stage__story {
    display: none;
  }
}
</style>
