import app from './app'

const port = 5501;

app.listen(port, (err) => {
  const msg = err ?? `now serving on port ${port}`
  console.log(msg);
});
