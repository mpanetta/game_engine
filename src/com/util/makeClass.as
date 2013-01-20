package com.util {
  public function makeClass(klass:Class, args:Array):* {
    switch (args.length) {
      case 0:
        return new klass();
        break;
      case 1:
        return new klass(args[0]);
        break;
      case 2:
        return new klass(args[0], args[1]);
        break;
      case 3:
        return new klass(args[0], args[1], args[2]);
        break;
      case 4:
        return new klass(args[0], args[1], args[2], args[3]);
        break;
      case 5:
        return new klass(args[0], args[1], args[2], args[3], args[4]);
        break;
      case 6:
        return new klass(args[0], args[1], args[2], args[3], args[4], args[5]);
        break;
      case 7:
        return new klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
        break;
      default:
        throw new Error("Method does not support " + args.length + " arguments. Trim it down buddy!");
    }
  }
}