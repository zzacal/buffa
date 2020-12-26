export interface User {
    name: string;
    hash: string;
    salt: string;
    key: string;
}

export interface AuthedUser {
    name: string;
    key: string;
}