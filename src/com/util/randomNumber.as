package com.util {
  public function randomNumber(begin:int, end:int):int {
    return Math.floor(begin + (Math.random() * (end - begin + 1)));
  }
}

