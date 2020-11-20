const express = require('express')
const app = express()
const port = 5501
const HashTable = require('./hashTable.js')

// Parse URL-encoded bodies (as sent by HTML forms)
app.use(express.urlencoded());

// Parse JSON bodies (as sent by API clients)
app.use(express.json());

var records = new HashTable()

app.get('/pop', (req, res) => {
  const key = req.query.key;
  const notes = records.search(key);
  if (notes) {
    const line = notes.pop();
    res.send(line);
  } else {
    res.sendStatus(404);
  }
})

app.post('/push', (req, res) => {
  const key = req.query.key;
  let notes = records.search(key);
  if (!notes) {
    notes = []
    records.add(key, notes);
  }
  const line = req.body.message;
  notes.push(line);
  res.sendStatus(200);
})

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`buffa-srv started`)
})
