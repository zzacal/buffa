
import * as bkfd from 'pbkdf2-password';
import {User, AuthedUser} from './User';

class UserManager {
    // TODO: Maybe users should be saved in a durable db
    users: User[] = [];
    hasher = bkfd();

    constructor() {}

    createUser(name: string, password: string): string {
        const users = this.users;
        this.hasher({ password }, (err, pass, salt, hashed) => {
            if (err) throw err;
            // store the salt & hash in the "db"
            const user: User = {
                name,
                salt,
                hash: hashed,
                key: name
            };

            users.push(user);
          });

          return name;
    }

    authenticate(name: string, pass: string, fn: (errer: Error, user?: AuthedUser) => void) {
        const matches = this.users.filter(x => x.name === name)
        // query the db for the given username
        if (!matches) return fn(new Error('cannot find user'));

        const user = matches[0]
        // apply the same algorithm to the POSTed password, applying
        // the hash against the pass / salt, if there is a match we
        // found the user
        this.hasher({ password: pass, salt: user.salt }, (err, password, salt, hashed) => {
          if (err) {
            return fn(err);
          }

          if (hashed === user.hash) {
            const authed: AuthedUser = {
              name: user.name,
              key: user.key,

            }
            return fn(null, authed)
          }

          fn(new Error('invalid password'));
        });
      }
}

export default UserManager;
