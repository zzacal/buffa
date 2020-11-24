interface Store {
    push(key: string, value: string): boolean
    pop(key: string): [boolean, string]
}

export default Store;
