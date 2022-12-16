enum handShape {
  Rock = 1,
  Paper = 2,
  Scissors = 3,
}

const enum RPSResult {
  Lost = 0,
  Draw = 3,
  Win = 6,
}

const opponentHand: { [key: string]: number } = {
  A: handShape.Rock,
  B: handShape.Paper,
  C: handShape.Scissors,
};

const myHand: { [key: string]: number } = {
  X: handShape.Rock,
  Y: handShape.Paper,
  Z: handShape.Scissors,
};

const RPSRequiredResult: { [key: string]: RPSResult } = {
  X: RPSResult.Lost,
  Y: RPSResult.Draw,
  Z: RPSResult.Win,
};

/**
 * Play a game of Rock-Paper-Scissors
 *
 * @param myHand The player's hand
 * @param opponentHand The opponent's hand
 * @returns Game Result
 */
const playRPS = (myHand: handShape, opponentHand: handShape): RPSResult => {
  if (myHand === opponentHand) {
    return RPSResult.Draw;
  }

  if (myHand === handShape.Rock) {
    if (opponentHand === handShape.Paper) {
      return RPSResult.Lost;
    } else {
      return RPSResult.Win;
    }
  }

  if (myHand === handShape.Paper) {
    if (opponentHand === handShape.Scissors) {
      return RPSResult.Lost;
    } else {
      return RPSResult.Win;
    }
  }

  if (myHand === handShape.Scissors) {
    if (opponentHand === handShape.Rock) {
      return RPSResult.Lost;
    } else {
      return RPSResult.Win;
    }
  }

  return RPSResult.Lost;
};

/**
 * Find the required hand to achieve the expected game result.
 *
 * @param opponentHand The opponent's hand
 * @param gameResult The expected game result
 * @returns The player's hand
 */
const findRequiredHand = (
  opponentHand: handShape,
  gameResult: RPSResult
): handShape => {
  if (gameResult === RPSResult.Draw) {
    return opponentHand;
  } else if (gameResult === RPSResult.Lost) {
    if (opponentHand === handShape.Rock) {
      return handShape.Scissors;
    } else if (opponentHand === handShape.Paper) {
      return handShape.Rock;
    } else {
      return handShape.Paper;
    }
  } else {
    if (opponentHand === handShape.Rock) {
      return handShape.Paper;
    } else if (opponentHand === handShape.Paper) {
      return handShape.Scissors;
    } else return handShape.Rock;
  }
};

import * as fs from "fs";

// Read file
const inputFilename: string = "./data/input.dat";
let fileContent = fs.readFileSync(inputFilename, "utf8");
let lines = fileContent.trim().split("\n");

let totalScore = 0;
lines.forEach((line) => {
  totalScore += myHand[line[2]];
  totalScore += playRPS(myHand[line[2]], opponentHand[line[0]]);
});
console.log("PART 1 | My total score is: " + totalScore);

// PART 2
totalScore = 0;
lines.forEach((line) => {
  let myHandShape = findRequiredHand(
    opponentHand[line[0]],
    RPSRequiredResult[line[2]]
  );
  totalScore += myHandShape;
  totalScore += RPSRequiredResult[line[2]];
});
console.log("PART 2 | My total score is: " + totalScore);
