import * as express from 'express';
import MemoryStore from './storage/memoryStore';
import Store from './storage/istore';
import UserManager from './auth/userManager';
import { userInfo } from 'os';

class App {
  public service
  records: Store;
  users = new UserManager();

  constructor () {
    this.service = express()
    // Parse URL-encoded bodies (as sent by HTML forms)
    this.service.use(express.urlencoded({extended: true}));
    // Parse JSON bodies (as sent by API clients)
    this.service.use(express.json());

    this.mountRoutes();
    this.records = new MemoryStore()
  }

  private mountRoutes (): void {
    const router = express.Router()
    router.get('/', (req, res) => {
      res.json({
        message: 'Hello World!'
      });
    });

    router.get('/pop', (req, res) => {
      const key = req.query.key as string;
      const [success, value] = this.records.pop(key);
      if (success) {
        res.send(value);
      } else {
        res.status(404).send('unpoppable');
      }
    });

    router.post('/push', (req, res) => {
      const key = req.query.key as string;
      const val = req.body.message as string;
      this.records.push(key, val);
      res.sendStatus(200);
    });

    router.post('/user', (req, res) => {
      const name = req.body.name as string;
      const password = req.body.password as string;

      const key = this.users.createUser(name, password);
      res.send(key);
    });

    router.get('/user', (req,res) => {
      const name = req.query.name as string;
      const password = req.query.password as string;

      this.users.authenticate(name, password, (error, user) => {
        if (user) {
          res.send(user);
        } else {
          res.status(401).send(error.message);
        }
      })
    });

    this.service.use('/', router);
  }
}

export default new App().service
