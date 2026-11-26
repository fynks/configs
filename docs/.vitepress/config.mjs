import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: "en-US",
  title: "Knowledge Base",
  description: "A comprehensive personal knowledge base with guides, configurations, and technical documentation",
  ignoreDeadLinks: true,
  cleanUrls: true,
  lastUpdated: true,
  
  // SEO and metadata improvements
  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/favicon.svg' }],
    ['link', { rel: 'shortcut icon', href: '/favicon.ico' }],
    ['link', { rel: 'manifest', href: '/site.webmanifest' }],
    ['meta', { name: 'theme-color', content: '#646cff' }],
    ['meta', { name: 'apple-mobile-web-app-title', content: 'KnowledgeBase' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'Knowledge Base' }],
    ['meta', { property: 'og:description', content: 'A comprehensive personal knowledge base with guides, configurations, and technical documentation' }],
    ['meta', { name: 'twitter:card', content: 'summary' }],
    ['meta', { name: 'viewport', content: 'width=device-width, initial-scale=1.0' }],
  ],

  themeConfig: {
    logo: '/images/logo.svg',
    
    // Enhanced search configuration
    search: {
      provider: 'local',
      options: {
        detailedView: true,
        miniSearch: {
          searchOptions: {
            combineWith: 'AND',
            fuzzy: 0.2,
            prefix: true,
            boost: { title: 4, text: 2, titles: 1 }
          },
          options: {
            fields: ['title', 'titles', 'text']
          }
        }
      }
    },

    // Enhanced navigation with better organization
    nav: [
      {
        text: 'Linux',
        items: [
          { text: 'Setup', link: '/linux/Setup' },
          { text: 'Grub', link: '/linux/grub' },
          { text: 'Fish Shell', link: '/linux/fish' }
        ]
      },
      { text: 'Browsers', link: '/browsers' },
      { text: 'Windows', link: '/windows' },
      {
        text: 'Tools',
        items: [
          { text: 'Android', link: '/android' },
          { text: 'Git', link: '/git' },
          { text: 'JDownloader', link: '/jdownloader2' },
          {text: 'VLC', link: '/linux/vlc' }
        ]
      }
    ],

    // Enhanced sidebar with better structure and descriptions
    sidebar: [
      {
        text: 'Linux',
        collapsed: false,
        items: [
          { text: 'System Setup', link: '/linux/Setup' },
          { text: 'GRUB Bootloader', link: '/linux/grub' },
          { text: 'Fish Shell Configuration', link: '/linux/fish' }
        ]
      },
      { text: 'Browsers', link: '/browsers' },
      { text: 'Windows', link: '/windows' },
      { text: 'Android', link: '/android' }, 
      {
        text: 'Tools & Apps',
        items: [
          { text: 'Git', link: '/git' },
          { text: 'JDownloader', link: '/jdownloader2' },
          {text: 'VLC', link: '/linux/vlc' }
        ]
      }
    ],
    
    // Enhanced outline configuration
    outline: {
      level: [2, 4],
      label: 'Table of Contents'
    },
    
    
    // Enhanced footer with more information
    footer: {
      message: 'Personal Knowledge Base',
      copyright: 'Copyright © 2024-present Ali (Fynks)'
    },
    
    // Last updated configuration
    lastUpdated: {
      text: 'Last updated',
      formatOptions: {
        dateStyle: 'short',
        timeStyle: 'medium'
      }
    },
    
    // Return to top button
    returnToTopLabel: 'Return to top',
    
    // Dark mode toggle
    darkModeSwitchLabel: 'Appearance',
    lightModeSwitchTitle: 'Switch to light theme',
    darkModeSwitchTitle: 'Switch to dark theme'
  }
})