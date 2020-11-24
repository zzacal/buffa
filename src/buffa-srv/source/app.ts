import * as express from 'express';
import MemoryStore from './Storage/memoryStore';
import Store from './Storage/istore';

class App {
  public express;
  records: Store;

  constructor () {
    this.express = express()
    // Parse URL-encoded bodies (as sent by HTML forms)
    this.express.use(express.urlencoded({extended: true}));
    // Parse JSON bodies (as sent by API clients)
    this.express.use(express.json());

    this.mountRoutes();
    this.records = new MemoryStore()
  }

  private mountRoutes (): void {
    const router = express.Router()
    router.get('/', (req, res) => {
      res.json({
        message: 'Hello World!'
      })
    })

    router.get('/pop', (req, res) => {
      const key = req.query.key as string;
      const [success, value] = this.records.pop(key);
      if (success) {
        res.send(value);
      } else {
        res.sendStatus(404);
      }
    })

    router.post('/push', (req, res) => {
      const key = req.query.key as string;
      const val = req.body.message as string;
      this.records.push(key, val);
      res.sendStatus(200);
    })

    this.express.use('/', router)
  }
}

export default new App().express
