const express = require('express')
const app = express()
const port = 3000
const HashTable = require('./hashTable.js')

var records = new HashTable()
records.add('test', ['hey','you'])

app.get('/pop', (req, res) => {
  const key = req.query.key;
  const notes = records.search(key);
  const line = notes.pop();
  res.send(line);
})

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
