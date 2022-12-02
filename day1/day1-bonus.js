const fs = require('fs');

function sort(ar) {
    ar.sort(function(a, b){return a - b});
}

function better(ar, candidate) {
    return candidate > ar[0];
}

function insert(ar, candidate) {
    var last = ar[ar.length-1];
    var found = false;
    for (var i = ar.length-1; i >= 0; i--) {
        if (!found && candidate > ar[i]) {
            last = ar[i];
            ar[i] = candidate;
            found = true;
        } else if (found) {
            tmp = ar[i];
            ar[i] = last;
            last = tmp;
        }
    }
}

function sum(ar) {
    var total = 0;
    for (var i = 0; i < ar.length ;i++) {
        total += ar[i];
    }
    return total;
}

fs.readFile('./day1/input', 'utf8', function(err, data) {
    if (err) {
        return console.log(err);
    }
    console.log('Reading data');

    var lines = data.split('\n');
    console.log('Found ' + lines.length + ' lines');

    var best3 = [ 0, 0, 0];
    var currentCalories = 0;

    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        if (line.trim().length === 0 || i === lines.length - 1) {
            if (better(best3, currentCalories)) {
                console.log('Found ' + currentCalories);
                insert(best3, currentCalories)
                console.log(best3);
            }
            currentCalories = 0;
        } else {
            currentCalories += parseInt(line);
        }
    }

    console.log('The three elves carrying the most calories are carrying ' + sum(best3) + ' calories ' + best3);
});