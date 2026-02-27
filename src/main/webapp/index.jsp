<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World | The Experience</title>
    <style>
        :root {
            --primary-color: #00d2ff;
            --secondary-color: #3a7bd5;
            --bg-dark: #0f0c29;
        }

        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            overflow: hidden;
            color: white;
        }

        /* Arka plan ışık oyunları */
        .glow {
            position: absolute;
            width: 300px;
            height: 300px;
            background: var(--primary-color);
            filter: blur(150px);
            border-radius: 50%;
            z-index: 0;
            opacity: 0.4;
            animation: pulse 8s infinite alternate;
        }

        /* Ana Kart */
        .container {
            position: relative;
            z-index: 1;
            text-align: center;
            padding: 3rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        h1 {
            font-size: 5rem;
            margin: 0;
            background: linear-gradient(to right, #00d2ff, #92fe9d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -2px;
            animation: fadeInDown 1.5s ease-out;
        }

        p {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 1rem;
            text-transform: uppercase;
            letter-spacing: 4px;
            animation: fadeInUp 2s ease-out;
        }

        /* Animasyonlar */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); filter: blur(10px); }
            to { opacity: 1; transform: translateY(0); filter: blur(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 0.3; }
            100% { transform: scale(1.5); opacity: 0.6; }
        }

        /* Küçük bir etkileşim: Buton */
        .btn {
            margin-top: 2rem;
            padding: 12px 30px;
            background: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: bold;
            text-transform: uppercase;
        }

        .btn:hover {
            background: var(--primary-color);
            color: var(--bg-dark);
            box-shadow: 0 0 20px var(--primary-color);
        }
    </style>
</head>
<body>
    <div class="glow"></div>
    
    <div class="container">
        <p>System Status: Online</p>
        <h1>Hello World</h1>
        <button class="btn" onclick="exportToPDF()">Export to PDF</button>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        function exportToPDF() {
            const element = document.body;
            const opt = {
                margin:       0,
                filename:     'page-export.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2 },
                jsPDF:        { unit: 'in', format: 'a4', orientation: 'portrait' }
            };
            html2pdf().set(opt).from(element).save();
        }
    </script>
</body>
</html>