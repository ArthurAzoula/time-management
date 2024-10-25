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
                    400: '#ffd4a2'
                },
                background: {
                    100: '#FEFFEE',
                },
                'text-color': {
                    100: '#544407',
                    purple: '#86198F',
                },
                card: {
                    100: '#544407',
                    200: '#FAE8FF',
                    date: '#FAE8FF',
                },
                workingHeader: {
                    100: '#54440712',
                },
                menu: {
                    100: '#FFD4A2',
                },
                primary: {
                    100: '#C026D3',
                },
            },
        },
    },
    plugins: [],
}
