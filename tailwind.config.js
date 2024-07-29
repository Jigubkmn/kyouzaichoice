module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        'blue': '#1E91E4', 
        'header-orange': '#FFDB7D',
        'pale-orange': '#FFCD4C',
        'dark-orange': '#FFB800',
        'pale-green': '#25E04E',
        'dark-green': '#26B441',
        'pale-blue': '#27CBFF',
        'dark-blue': '#00B6EF',
        'gray': '#D9D9D9',
      },
      margin: {
        '5px': '5px',
        '15px': '15px',
        '20px': '20px',
        '30px': '30px',
        '50px': '50px',
        '72px': '72px',
      },
      maxWidth: {
        '200px': '200px',
      },
      height: {
        '72px': '72px',
      },
    },
    backgroundImage: {
      'my-image': "url('/top.jpg')",
    }
  },
  plugins: [require("daisyui")],
}