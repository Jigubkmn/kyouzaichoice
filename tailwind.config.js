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
        'like-pink': '#FF5FB5',
        'pale-yellow': '#FCE29E',
        'thin-orange': '#FFDB7D',
        'pale-orange': '#FFCD4C',
        'dark-orange': '#FFB800',
        'pale-green': '#25E04E',
        'dark-green': '#26B441',
        'pale-blue': '#27CBFF',
        'dark-blue': '#00B6EF',
        'darkest-blue': '#1E91E4',
        'purple': '#AF1CC6',
        'gray': '#D9D9D9',
        'ultra_thin_gray': '#F8FAFC',
        'thin-gray': '#CECECE',
        'pale-gray': '#BEBEBE',
        'dark-gray': '#9B9393',
        'flash-messages-green': '#64D57D',
        'flash-messages-red': '#EA8585',
        'flash-messages-yellow': '#F3F65D',
      },
      borderColor: { 
        'pale-gray': '#BEBEBE',
        'darkest-blue': '#1E91E4',
      },
      backgroundSize: {
        '50px': '50px',
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
        '80px': '80px',
        '100px': '100px',
        '130px': '130px',
      },
      padding: {
        '10px': '10px',
        '15px': '15px',
        '20px': '20px',
        '25px': '25px',
        '30px': '30px',
        '40px': '40px',
        '60px': '60px',
      },
      width: {
        '200px': '200px',
        '250px': '250px',
        '400px': '400px',
        '600px': '600px',
        '800px': '800px',
      },
      maxWidth: {
        '600px': '600px',
        '800px': '800px',
        '1220px': '1220px',
        '1250px': '1250px',
      },
      minWidth: {
        '75px': '75px',
        '100px': '100px',
        '150px': '150px',
        '200px': '200px',
        '300px': '300px',
        '600px': '600px',
        '700px': '700px',
      },
      height: {
        '30px': '30px',
        '38px': '38px',
        '48px': '48px',
        '72px': '72px',
        '170px': '170px',
        '274px': '274px',
        '600px': '600px',
      },
      minHeight: {
        '30px': '30px',
        '170px': '170px',
        '600px': '600px',
      },
      lineHeight: {
        '30px': '30px',
      },
      fontSize: {
        '12px': '12px',
        '14px': '14px',
        '16px': '16px',
        '18px': '18px',
        '20px': '20px',
        '28px': '28px',
        '30px': '30px',
      },
      spacing: {
        '40px': '40px',
      },
    },
  }, 
  plugins: [require("daisyui")],
}