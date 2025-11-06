const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Hello CI/CD! author :=>+++++++++Richardslifer+++++++ 10/10/25 thanks'));

app.listen(3000, () => console.log('App running on port 3000'));

