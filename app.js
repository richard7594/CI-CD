const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Hello CI/CD! author :=>+++++++++Richardslifer+++++++'));

app.listen(3000, () => console.log('App running on port 3000'));

