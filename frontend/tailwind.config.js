/** @type {import('tailwindcss').Config} */
export default {
    content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
    theme: {
        extend: {
            colors: {
                button: {
                    100: '#544407',
                    200: '#FA9115',
                    300: '#FFEAD2',
                },
            },
        },
    },
    plugins: [],
}
