module.exports = {
  runtimeCaching: [
    {
      urlPattern: /\.(?:css|js|svg|ico)$/,
      handler: 'CacheFirst',
      options: {
        cacheName: 'cache',
        expiration: {
          maxEntries: 10,
          maxAgeSeconds: 60 * 60 * 24 , //  24 hours
        },
      },
    },
  ],
  swDest: "./dist/sw.js",
  sourcemap: false
};
