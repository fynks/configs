module.exports = {
  runtimeCaching: [
    {
      urlPattern: /\.(?:css|js|svg|ico)$/,
      handler: 'CacheFirst',
      options: {
        cacheName: 'cache',
        expiration: {
          maxEntries: 10,
          maxAgeSeconds: 60 * 60 * 24 * 7, // 7 Days
        },
      },
    },
    {
      urlPattern: /\.(?:html)$/,
      handler: 'StaleWhileRevalidate',
      options: {
        cacheName: 'htmlCache',
        expiration: {
          maxEntries: 15,
          maxAgeSeconds: 60 * 60, // 1 Hour
        },
      },
    },
    {
      urlPattern: /^https?:\/\/fynks\.netlify\.app\/.*$/,
      handler: 'StaleWhileRevalidate',
      options: {
        cacheName: 'externalHtmlCache',
        expiration: {
          maxEntries: 15,
          maxAgeSeconds: 60 * 60, // 1 Hour
        },
      },
    },
  ],
  swDest: "./dist/sw.js",
  sourcemap: false
};