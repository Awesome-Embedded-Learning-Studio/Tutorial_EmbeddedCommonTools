import DefaultTheme from 'vitepress/theme'
import { h } from 'vue'
import type { Theme } from 'vitepress'
import HomeTipBanner from './components/HomeTipBanner.vue'
import ChapterNav from './components/ChapterNav.vue'
import ChapterLink from './components/ChapterLink.vue'
import EbHero from './components/home/EbHero.vue'
import EbJourneyLedger from './components/home/EbJourneyLedger.vue'
import EbAfterword from './components/home/EbAfterword.vue'
import EbColophon from './components/home/EbColophon.vue'
import { setupMermaid } from './mermaid-client'
import './custom.css'

export default {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      // 首页门面(卷宗终端):自绘 hero → 图签 → 历程目录 → 跋 → 补课索引。
      // index.md 不写 hero/features frontmatter,VPHero/VPFeatures 不渲染,零覆盖战。
      'home-hero-before': () => h(EbHero),
      'home-features-before': () => [h(EbJourneyLedger), h(EbAfterword)],
      'home-features-after': () => [h(HomeTipBanner), h(EbColophon)],
    })
  },
  enhanceApp({ app }) {
    app.component('ChapterNav', ChapterNav)
    app.component('ChapterLink', ChapterLink)
  },
  setup() {
    setupMermaid()
  }
} satisfies Theme
