const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Hello CI/CD! author :=>+++++++++Richardslifer+++++++ 09/10/25'));

app.listen(3000, () => console.log('App running on port 3000'));

