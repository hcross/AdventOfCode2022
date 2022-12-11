import fs from 'fs';

export function openFile(path) {
    return fs
        .readFileSync(path, 'utf8')
        .split('\n')
        .filter(l => '' != l);
}