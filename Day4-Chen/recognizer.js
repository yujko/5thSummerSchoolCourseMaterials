//
//  a recognizer
//
//  xac@ucla.edu, 7/14/2019
//

var GEXTURES = GEXTURES || {};

GEXTURES.CIRCLE = 'o';
GEXTURES.LESSTHAN = '<';
GEXTURES.GREATERTHAN = '>';

//
//  recognize three gestures: o, < and >
//
GEXTURES.recognize = function (coords) {
    if (coords.length < 3) return undefined;

    let step = 1; // step used to compute a vector betwee coords at i and i+step
    let numSignSwitches = 0; // the # of times the tangent of a vector changes the sign
    let signedIndexSum = 0; // sum(i * sign)--a metric to quantify the distribution of signs
    for (let i = 0, sign = Math.NaN; i < coords.length - step; i++) {
        let vector = GEXTURES.getVector(coords[i + step], coords[i]);

        if (vector.y == 0) continue; // two coords too close, continue

        let signCurrent = Math.sign(vector.x / vector.y);

        // initializing the first sign value
        if (isNaN(sign) && signCurrent != 0) {
            sign = signCurrent;
        } 
        // detecting a sign change
        else if (sign * signCurrent == -1) {
            numSignSwitches++;
            sign = signCurrent;
        }

        // compute the metric that quantifies the distribution of signs
        signedIndexSum += signCurrent * i;
    }

    // console.log(numSignSwitches + ', ' + signedIndexSum);

    // a o has more than 1 sign changes
    if (numSignSwitches > 1) {
        return GEXTURES.CIRCLE;
    } 
    // a < or > have 1 sign change
    else if (numSignSwitches == 1) {
        // classify < and > based on distribution of sign
        if (signedIndexSum > 0) {
            return GEXTURES.LESSTHAN;
        } else if (signedIndexSum < 0) {
            return GEXTURES.GREATERTHAN;
        } else {
            return undefined;
        }
    } 
    // undefined cases
    else {
        return undefined;
    }
}

//
//  return the vector based on two coordinates
//
GEXTURES.getVector = function (c1, c2) {
    return {
        x: c2.x - c1.x,
        y: c2.y - c1.y
    };
}