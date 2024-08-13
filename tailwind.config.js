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

        'pale-pink': '#FCC2C2',
        'dark-pink': '#FF9A9A',
        'thin-orange': '#FFDB7D',
        'pale-orange': '#FFCD4C',
        'dark-orange': '#FFB800',
        'pale-green': '#25E04E',
        'dark-green': '#26B441',
        'pale-blue': '#27CBFF',
        'dark-blue': '#00B6EF', 
        'thin-gray': '#CECECE',
        'pale-gray': '#BEBEBE',
        'dark-gray': '#9B9393',
        'flash-messages-green': '#64D57D',
        'flash-messages-red': '#EA8585',
        'flash-messages-yellow': '#F3F65D',
      },
      margin: {
        '5px': '5px',
        '10px': '10px',
        '15px': '15px',
        '20px': '20px',
        '25px': '25px',
        '30px': '30px',
        '40px': '40px',
        '50px': '50px',
        '72px': '72px',
        '75px': '75px',
        '100px': '100px',
      },
      padding: {
        '10px': '10px',
        '15px': '15px',
        '20px': '20px',
        '25px': '25px',
        '30px': '30px',
      },
      width: {
        '100px': '100px',
        '300px': '300px',
      },
      maxWidth: {
        '120px': '120px',
        '200px': '200px',
        '610px': '610px',
        '940px': '940px',
      },
      minWidth: {
        '100px': '100px',
        '150px': '150px',
        '200px': '200px',
        '300px': '300px',
        '610px': '610px',
        '700px': '700px',
      },
      height: {
        '30px': '30px',
        '48px': '48px',
        '72px': '72px',
        '170px': '170px',
      },
      minHeight: {
        '170px': '170px',
        '600px': '600px',
      },
      lineHeight: {
        '30px': '30px',
      },
      fontSize: {
        '16px': '16px',
        '28px': '28px',
      },
      spacing: {
        '50px': '50px',
      },
    },
  }, 
  plugins: [require("daisyui")],
}