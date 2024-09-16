const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  safelist: [
    {
      pattern: /bg-[A-Z]{3}-50/,
    },
    {
      pattern: /text-[A-Z]{3}text-50/,
    },
  ],
  theme: {
    extend: {
      fontFamily: {
        inter: ['Inter', 'sans-serif'],
        nunito: ['Nunito', 'sans-serif'],
        ubuntu: ['Ubuntu', 'sans-serif'],
        sourcesans: ['Source Sans Pro', 'sans-serif'],
        poppins: ['Poppins', 'sans-serif'],
        lato: ['Lato', 'sans-serif'],
        worksans: ['Work Sans', 'sans-serif'],
        merriweathersans: ['Merriweather Sans', 'sans-serif'],
        raleway: ['Raleway', 'sans-serif'],
        dmsans: ['DM Sans', 'sans-serif'],
      },
      colors: {
        gold: '#FFD700',
        silver: '#C0C0C0',
        bronze: '#cd7f32',
        steelblue: '#4682B4',
        cadetblue: '#5F9EA0',
        navy: '#000080',
        powderblue: '#B0E0E6',
        
        MCI: {
          50: "#67e8f9",
        },
        MCItext: {
          50: "#1e40af",
        },
        BUR: {
          50: "#6C1D45",
        },
        BURtext: {
          50: "#FFFFFF",
        },
        ARS: {
          50: "#EF0107",
        },
        ARStext: {
          50: "#FFFFFF",
        },
        NOT: {
          50: "#fca5a5",
        },
        NOTtext: {
          50: "#EF0107",
        },
        BOU: {
          50: "#000000",
        },
        BOUtext: {
          50: "#EF0107",
        },
        WHU: {
          50: "#f9a8d4",
        },
        WHUtext: {
          50: "#7A263A",
        },
        BHA: {
          50: "#60a5fa",
        },
        BHAtext: {
          50: "#FFFFFF",
        },
        LUT: {
          50: "#F78F1E",
        },
        LUTtext: {
          50: "#FFFFFF",
        },
        EVE: {
          50: "#003399",
        },
        EVEtext: {
          50: "#FFFFFF",
        },
        FUL: {
          50: "#FFFFFF",
        },
        FULtext: {
          50: "#CC0000",
        },
        SHE: {
          50: "#EE2737",
        },
        SHEtext: {
          50: "#FFFFFF",
        },
        CRY: {
          50: "#1B458F",
        },
        CRYtext: {
          50: "#C4122E",
        },
        NEW: {
          50: "#000000",
        },
        NEWtext: {
          50: "#FFFFFF",
        },
        AVL: {
          50: "#670e36",
        },
        AVLtext: {
          50: "#95bfe5",
        },
        BRE: {
          50: "#D20000",
        },
        BREtext: {
          50: "#FFB400",
        },
        TOT: {
          50: "#FFFFFF",
        },
        TOTtext: {
          50: "#132257",
        },
        CHE: {
          50: "#034694",
        },
        CHEtext: {
          50: "#dba111",
        },
        LIV: {
          50: "#c8102E",
        },
        LIVtext: {
          50: "#00B2A9",
        },
        MUN: {
          50: "#c8102E",
        },
        MUNtext: {
          50: "#FBE122",
        },
        WOL: {
          50: "#FDB913",
        },
        WOLtext: {
          50: "#231F20",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
