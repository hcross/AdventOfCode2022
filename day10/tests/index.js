import assert from "assert";
import { puzzle1, puzzle2 } from "../build/debug.js";
import { openFile } from "./fsutils.js";

assert.strictEqual(puzzle1(openFile('./tests/example.input')), 13140);
assert.strictEqual(puzzle1(openFile('./tests/input')), 12740);
assert.strictEqual(puzzle2(openFile('./tests/example.input')), 0);
assert.strictEqual(puzzle2(openFile('./tests/input')), 0);
console.log("ok");