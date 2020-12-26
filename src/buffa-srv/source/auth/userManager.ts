
import hash from 'pbkdf2-password';
import User from './User';

class UserManager {
    users: User[];

    constructor() {}

    createUser(name: string, password: string): void {
        hash({ password }, function (err, pass, salt, hashed) {
            if (err) throw err;
            // store the salt & hash in the "db"
            const user: User = {
                name,
                salt,
                hash: hashed,
                key: hashed
            };

            this.users.push(user);
          });
    }

    authenticate(name, pass, fn) {
        const matches = this.users.filter(x => x.name === name)
        // query the db for the given username
        if (!matches) return fn(new Error('cannot find user'));

        const user = matches[0]
        // apply the same algorithm to the POSTed password, applying
        // the hash against the pass / salt, if there is a match we
        // found the user
        hash({ password: pass, salt: user.salt }, (err, password, salt, hashed) => {
          if (err) return fn(err);
          if (hashed === user.hash) return fn(null, user)
          fn(new Error('invalid password'));
        });
      }
}

export default UserManager;
