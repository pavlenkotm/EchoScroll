import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        'mystic-purple': '#6B46C1',
        'mystic-blue': '#4C1D95',
        'spell-gold': '#F59E0B',
        'ancient-parchment': '#FEF3C7',
      },
      animation: {
        'float': 'float 3s ease-in-out infinite',
        'spell-cast': 'spellCast 0.6s ease-out',
        'disappear': 'disappear 1s ease-in forwards',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        spellCast: {
          '0%': { transform: 'scale(1)', opacity: '1' },
          '50%': { transform: 'scale(1.1)', opacity: '0.8' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
        disappear: {
          '0%': { opacity: '1', transform: 'scale(1) rotate(0deg)' },
          '50%': { opacity: '0.5', transform: 'scale(0.8) rotate(5deg)' },
          '100%': { opacity: '0', transform: 'scale(0) rotate(10deg)' },
        },
      },
    },
  },
  plugins: [],
};
export default config;
