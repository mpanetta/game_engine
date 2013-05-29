package com.util
{
  import flash.utils.describeType;

  public function eventTypesFor(eventClass:Class):Array {
    var result:Array = [];

    for each(var constant:XML in describeType(eventClass).constant)
      result.push(constant.@name.toString());

    return result;
  }
}

