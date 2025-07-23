module.exports = {
  content: [
    './app/views/**/*.{erb,haml,html,slim,rb}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*.{erb,haml,html,slim,rb}',
    './test/dummy/app/views/**/*.{erb,haml,html,slim}',
    './test/dummy/app/helpers/**/*.rb',
    './test/dummy/app/javascript/**/*.js',
    './test/dummy/app/components/**/*.{erb,haml,html,slim,rb}'
  ],
  theme: {
    extend: {},
  },
  plugins: []
}