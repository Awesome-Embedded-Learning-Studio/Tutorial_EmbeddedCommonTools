<script setup lang="ts">
// 卷宗终端:hero 右侧的「刚发生的真实会话」。
// 逐行上屏(非逐字打字机 —— 与姊妹站的复古 CRT 语义取反:现代 CI 审计)。
// 内容来自 journey-data.ts,每行都有真实出处;明暗模式下都是同一块深色实物。
import { SESSION } from './journey-data'
</script>

<template>
  <figure class="term" aria-label="第 7 个历程的 CI 真实会话:裸机构建、QEMU 运行、串口证据比对">
    <figcaption class="term__bar">
      <span class="term__status"><i class="term__dot" />passed</span>
      <span class="term__name">journey/06-qemu-uart</span>
      <span class="term__tier">ci-linux</span>
    </figcaption>
    <div class="term__body">
      <div
        v-for="(l, i) in SESSION"
        :key="i"
        class="term__line"
        :class="[`term__line--${l.kind}`, { 'term__line--cont': l.cont }]"
        :style="{ '--i': i }"
      >
        <template v-if="l.kind === 'cmd' && !l.cont"><span class="term__ps">$&nbsp;</span>{{ l.text }}</template>
        <template v-else>{{ l.text }}</template>
      </div>
      <span class="term__cursor" :style="{ '--i': SESSION.length }" />
    </div>
  </figure>
</template>

<style scoped>
.term {
  margin: 0;
  background: var(--eb-term-bg);
  border: 1px solid var(--eb-term-border);
  border-radius: 10px;
  overflow: hidden;
  text-align: left;
  box-shadow: 0 12px 32px rgba(10, 15, 22, 0.18), 0 4px 8px rgba(10, 15, 22, 0.1);
}

/* runner 风格窗口头(刻意不用 mac 红绿灯圆点) */
.term__bar {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 9px 14px;
  font-family: var(--eb-mono);
  font-size: 11px;
  letter-spacing: 0.04em;
  border-bottom: 1px solid var(--eb-term-border);
  background: rgba(255, 255, 255, 0.02);
}

.term__status {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--eb-term-green);
}

.term__dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--eb-term-green);
}

.term__name { color: var(--eb-term-dim); }

.term__tier {
  margin-left: auto;
  color: var(--eb-term-dim);
  border: 1px solid var(--eb-term-border);
  border-radius: 4px;
  padding: 1px 6px;
  font-size: 10px;
}

.term__body {
  padding: 16px 18px 18px;
  font-family: var(--eb-mono);
  font-size: 12.5px;
  line-height: 1.95;
  min-height: 224px;
}

.term__line {
  color: var(--eb-term-text);
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  animation: eb-line-in 0.3s ease both;
  animation-delay: calc(0.35s + var(--i) * 0.16s);
}

.term__ps { color: var(--eb-term-green); user-select: none; }
.term__line--cont { animation-delay: calc(0.35s + (var(--i) - 1) * 0.16s); }

.term__line--out { color: var(--eb-term-green); }
.term__line--dim { color: var(--eb-term-dim); }

/* 落章:全页唯一「大声」的时刻 */
.term__line--stamp {
  display: inline-block;
  margin-top: 6px;
  padding: 2px 10px;
  color: var(--eb-term-green);
  border: 1px solid var(--eb-term-green);
  border-radius: 4px;
  animation: eb-stamp-in 0.34s cubic-bezier(0.2, 1.4, 0.4, 1) both;
  animation-delay: calc(0.35s + var(--i) * 0.16s);
}

.term__cursor {
  display: inline-block;
  width: 7px;
  height: 14px;
  margin-left: 2px;
  vertical-align: -2px;
  background: var(--eb-term-text);
  opacity: 0;
  animation: eb-cursor-in 0s ease forwards, eb-blink 1.05s steps(1) infinite;
  animation-delay: calc(0.35s + var(--i) * 0.16s), calc(0.35s + var(--i) * 0.16s);
}

@keyframes eb-line-in {
  from { opacity: 0; transform: translateY(3px); }
  to { opacity: 1; transform: none; }
}

@keyframes eb-stamp-in {
  0% { opacity: 0; transform: scale(1.08); }
  100% { opacity: 1; transform: scale(1); }
}

@keyframes eb-cursor-in { to { opacity: 1; } }
@keyframes eb-blink { 50% { opacity: 0; } }

@media (prefers-reduced-motion: reduce) {
  .term__line,
  .term__line--stamp,
  .term__cursor {
    animation: none;
    opacity: 1;
    transform: none;
  }
  .term__cursor { animation: none; }
}
</style>
