package syscode
{
    import flash.events.Event;

    public class CustomEvent extends Event
    {
        public function CustomEvent(type:String, params:Object, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.params = params;
        }
        public var params:Object;

        override public function clone():Event
        {
            return new CustomEvent(type, this.params, bubbles, cancelable);
        }

        override public function toString():String
        {
            return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable", "eventPhase");
        }
    }
}
