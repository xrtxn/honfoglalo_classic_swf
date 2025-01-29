package com.mywebzz.utils.text
{
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.text.TextField;

    public class TextFieldHealer
    {
        public function TextFieldHealer(textField:TextField)
        {
            super();
            if ((this._textField = textField) == null)
            {
                throw new Error("textField can not be null.");
            }
            this._textField.addEventListener(KeyboardEvent.KEY_DOWN, this._keyHandler);
            this._textField.addEventListener(TextEvent.TEXT_INPUT, this._inputHandler);
        }
        private var _textField:TextField = null;
        private var _repair:Boolean = false;
        private var _begin:int = 0;
        private var _end:int = 0;

        public function destroy():void
        {
            this._textField.removeEventListener(KeyboardEvent.KEY_DOWN, this._keyHandler);
            this._textField.removeEventListener(TextEvent.TEXT_INPUT, this._inputHandler);
            this._textField = null;
        }

        internal function _keyHandler(event:KeyboardEvent):void
        {
            if (!(this._repair = event.ctrlKey && event.altKey))
            {
                return;
            }
            this._begin = this._textField.selectionBeginIndex;
            this._end = this._textField.selectionEndIndex;
        }

        internal function _inputHandler(event:TextEvent):void
        {
            if (this._repair)
            {
                this._textField.setSelection(this._begin, this._end);
            }
        }
    }
}
