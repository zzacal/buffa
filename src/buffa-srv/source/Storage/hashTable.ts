class HashTable {
  values: Dictionary<any>;
  length: number;
  size: number;
  constructor() {
    this.values = {};
    this.length =  0;
    this.size =  0;
  }

  calculateHash(key:  string): number {
    return key.toString().length % this.size;
  }

  add(key: string, value: any) {
    if (!this.values.hasOwnProperty(key)) {
      this.values[key] = [];
    }
    this.values[key] = value;
  }

  search(key: string): any {
     if (this.values.hasOwnProperty(key)) {
       return this.values[key];
     } else {
       return null;
     }
  }
}

interface Dictionary<T> {
  [Key: string]: T;
}

export default HashTable

// module.exports = HashTable
