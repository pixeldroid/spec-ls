
package pixeldroid.bdd
{
    static final class Does
    {

        public static function typeMatch(value:Object, type:Type):Boolean
        {
            return (value.getFullTypeName() == type.getFullName());
        }

        public static function subtypeMatch(value:Object, type:Type):Boolean
        {
            return ((value instanceof type) || (value is type) || ((value as type) != null));
        }

        public static function vectorEndWith(vector:Vector.<Object>, item:Object):Boolean
        {
            return (vector[vector.length - 1] == item);
        }

        public static function vectorStartWith(vector:Vector.<Object>, item:Object):Boolean
        {
            return (vector[0] == item);
        }

        public static function stringEndWith(string1:String, string2:String):Boolean
        {
            return (string1.indexOf(string2) == (string1.length - string2.length));
        }

        public static function stringStartWith(string1:String, string2:String):Boolean
        {
            return (string1.indexOf(string2) == 0);
        }

    }
}
