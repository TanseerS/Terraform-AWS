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
        body { font-family: Arial, sans-serif; background-color: #e8f5e8; color: #2e7d32; text-align: center; padding: 50px; }
        h1 { color: #1b5e20; }
        .badge { background-color: #388e3c; color: white; padding: 10px; border-radius: 5px; display: inline-block; }
      </style>
    </head>
    <body>
      <h1>Welcome to Version 2.0</h1>
      <div class="badge">STAGING</div>
      <p>Green Environment - Running Application v2.0</p>
      <ul style="text-align: left; display: inline-block;">
        <li>Refreshed UI with modern design</li>
        <li>Improved performance</li>
        <li>Enhanced security features</li>
        <li>Better analytics tracking</li>
        <li>Critical bug fixes</li>
      </ul>
    </body>
    </html>
  `);
});

app.listen(port, () => {
  console.log(`App v2.0 listening on port ${port}`);
});