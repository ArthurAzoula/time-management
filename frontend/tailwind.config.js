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
                background: {
                    100: '#FEFFEE',
                },
                'text-color': {
                    100: '#544407',
                    purple:"#86198F"
                },
                card: {
                    100: '#544407',
                    200: "#FAE8FF",
                    date:"#FAE8FF"
                },
                workingHeader: {

                    100: "#54440712",

                },
            },
        },
        
    },
    plugins: [],
}
