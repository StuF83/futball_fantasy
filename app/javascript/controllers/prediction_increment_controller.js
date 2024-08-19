import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="prediction-increment"
export default class extends Controller {
  static targets = ["homeScore", "awayScore"]

  increaseHome() {
    this.increase(this.homeScoreTarget);
  }

  decreaseHome() {
    this.decrease(this.homeScoreTarget);
  }

  increaseAway() {
    this.increase(this.awayScoreTarget);
  }

  decreaseAway() {
    this.decrease(this.awayScoreTarget);
  }

  increase(input) {
    let value = parseInt(input.value);

    if (isNaN(value)) {
      value = -1;
    }

    if (value < 9) {
      value += 1;
    }
    input.value = value;

    //console.log("increase called")
    //console.log(`Score is ${value}`)
  }

  decrease(input) {
    let value = parseInt(input.value);

    if (isNaN(value)) {
      value = 1;
    }

    if (value > 0) {
      value -= 1;
    }

    input.value = value;

    //console.log("decrease called");
   // console.log(`Score is ${value}`);
  }
}
