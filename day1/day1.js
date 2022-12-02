const fs = require('fs');

fs.readFile('./day1/input', 'utf8', function(err, data) {
    if (err) {
        return console.log(err);
    }
    console.log('Reading data');

    var lines = data.split('\n');
    console.log('Found ' + lines.length + ' lines');

    var maxCaloriesForAnElf = 0;
    var elfCarryingMostCalories = -1;
    var currentCalories = 0;
    var currentElfIndex = 1;
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        if (line.trim().length === 0 || i === lines.length - 1) {
            if (currentCalories > maxCaloriesForAnElf) {
                maxCaloriesForAnElf = currentCalories;
                elfCarryingMostCalories = currentElfIndex;
            }
            currentCalories = 0;
            currentElfIndex++;
        } else {
            currentCalories += parseInt(line);
        }
    }

    console.log('The Elf ' + elfCarryingMostCalories + ' is carrying the most calories (' + maxCaloriesForAnElf + ' calories)');
});