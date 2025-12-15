const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Blue-Green Deployment Demo</title>
      <style>
        body { font-family: Arial, sans-serif; background-color: #e3f2fd; color: #1565c0; text-align: center; padding: 50px; }
        h1 { color: #0d47a1; }
        .badge { background-color: #1976d2; color: white; padding: 10px; border-radius: 5px; display: inline-block; }
      </style>
    </head>
    <body>
      <h1>Welcome to Version 1.0</h1>
      <div class="badge">PRODUCTION</div>
      <p>Blue Environment - Running Application v1.0</p>
      <ul style="text-align: left; display: inline-block;">
        <li>Basic feature set</li>
        <li>Stable and tested</li>
        <li>Current production version</li>
      </ul>
    </body>
    </html>
  `);
});

app.listen(port, () => {
  console.log(`App v1.0 listening on port ${port}`);
});