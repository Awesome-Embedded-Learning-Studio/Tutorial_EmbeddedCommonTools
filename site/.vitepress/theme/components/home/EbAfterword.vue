<script setup lang="ts">
import { ACTIONS_URL } from './journey-data'
</script>

<template>
  <section class="eb-afterword eb-wrap">
    <header class="eb-sec">
      <span class="eb-sec__label">EPILOGUE · 跋 · 证据优先</span>
      <span class="eb-sec__rule" />
    </header>

    <blockquote class="eb-afterword__quote">
      <p>
        这一卷的每章正文命令,都被 <code>scripts/journey/</code> 里的配对脚本在 CI
        中逐字重放——咱们看到的输出是真跑出来的,不是编的。尾声两篇为 manual
        级,由人工走查声明背书。
      </p>
      <footer class="eb-afterword__src">
        — scripts/journey/ · GitHub Actions · 每次构建重新上电
        <a :href="ACTIONS_URL" target="_blank" rel="noopener">查看 CI 运行记录 →</a>
      </footer>
    </blockquote>

    <p class="eb-afterword__org">
      EmbedBox 是
      <a href="https://github.com/Awesome-Embedded-Learning-Studio" target="_blank" rel="noopener">
        Awesome-Embedded-Learning-Studio</a
      >的「嵌入式 CSAPP」与共同实验工作台:承担所有路线共同需要、恰好够用的基础嵌入式开发知识。
    </p>
  </section>
</template>

<style scoped>
.eb-wrap {
  max-width: 1120px;
  margin: 0 auto;
  padding-inline: 24px;
}

.eb-afterword {
  padding-top: 56px;
}

.eb-sec {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
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

.eb-afterword__quote {
  margin: 0;
  padding: 2px 0 2px 22px;
  border-left: 3px solid var(--vp-c-brand-1);
}

.eb-afterword__quote p {
  margin: 0;
  font-size: 15px;
  line-height: 2;
  color: var(--vp-c-text-2);
}

.eb-afterword__quote code {
  font-family: var(--eb-mono);
  font-size: 0.86em;
  padding: 0.1em 0.4em;
  border-radius: 4px;
  background: var(--vp-c-bg-mute);
  color: var(--vp-c-text-1);
}

.eb-afterword__src {
  margin-top: 14px;
  font-family: var(--eb-mono);
  font-size: 12px;
  color: var(--vp-c-text-3);
}

.eb-afterword__src a {
  margin-left: 12px;
  color: var(--vp-c-brand-1);
  text-decoration: none;
}

.eb-afterword__src a:hover {
  text-decoration: underline;
  text-underline-offset: 3px;
}

.eb-afterword__org {
  margin: 22px 0 0;
  font-size: 13px;
  line-height: 1.9;
  color: var(--vp-c-text-3);
}

.eb-afterword__org a {
  color: var(--vp-c-text-2);
  text-decoration: none;
  border-bottom: 1px dotted var(--vp-c-text-3);
}
</style>
