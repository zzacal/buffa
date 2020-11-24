import Store from './istore';
import StringkeyDict from './hashTable';

class MemoryStore implements Store {
    records: StringkeyDict;

    constructor() {
        this.records = new StringkeyDict();
    }

    push(key: string, value: string) {
        let notes = this.records.search(key);
        if (!notes) {
          notes = []
          this.records.add(key, notes);
        }
        notes.push(value);

        return true;
    }

    pop(key: string): [boolean, string] {
        const notes = this.records.search(key) as string[];
        if (notes) {
          const value = notes.pop();
          return [true, value];
        } else {
          return [false, ''];
        }
    }
}

export default MemoryStore;
