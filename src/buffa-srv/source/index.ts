import app from './app'

const port = 5501;

app.listen(port, (err) => {
    if (err) {
      return console.log(err)
    }});