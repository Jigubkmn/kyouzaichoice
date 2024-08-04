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
        'thin-orange': '#FFDB7D',
        'pale-orange': '#FFCD4C',
        'dark-orange': '#FFB800',
        'pale-green': '#25E04E',
        'dark-green': '#26B441',
        'flash-messages-green': '#64D57D',
        'flash-messages-red': '#EA8585',
        'flash-messages-yellow': '#F3F65D',
        'pale-blue': '#27CBFF',
        'dark-blue': '#00B6EF',
        'pale-gray': '#D9D9D9',
        'dark-gray': '#9B9393',
        'pale-pink': '#FCC2C2',
        'dark-pink': '#FF9A9A',
      },
      margin: {
        '5px': '5px',
        '15px': '15px',
        '20px': '20px',
        '25px': '25px',
        '30px': '30px',
        '40px': '40px',
        '50px': '50px',
        '72px': '72px',
        '100px': '100px',
      },
      padding: {
        '10px': '10px',
        '15px': '15px',
        '20px': '20px',
        '30px': '30px',
      },
      maxWidth: {
        '200px': '200px',
        '700px': '700px',
      },
      minWidth: {
        '250px': '250px',
        '700px': '700px',
      },
      height: {
        '48px': '48px',
        '72px': '72px',
      },
      minHeight: {
        '600px': '600px',
      },
      fontSize: {
        '28px': '28px',
      },
      spacing: {
        '50px': '50px',
      },
    },
    backgroundImage: {
    }
  },
  plugins: [require("daisyui")],
}