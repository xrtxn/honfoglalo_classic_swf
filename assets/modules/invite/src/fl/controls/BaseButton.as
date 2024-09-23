package fl.controls {
		import fl.core.InvalidationType;
		import fl.core.UIComponent;
		import fl.events.ComponentEvent;
		import flash.display.DisplayObject;
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		public class BaseButton extends UIComponent {
				private static var defaultStyles:Object = {
						"upSkin":"Button_upSkin",
						"downSkin":"Button_downSkin",
						"overSkin":"Button_overSkin",
						"disabledSkin":"Button_disabledSkin",
						"selectedDisabledSkin":"Button_selectedDisabledSkin",
						"selectedUpSkin":"Button_selectedUpSkin",
						"selectedDownSkin":"Button_selectedDownSkin",
						"selectedOverSkin":"Button_selectedOverSkin",
						"focusRectSkin":null,
						"focusRectPadding":null,
						"repeatDelay":500,
						"repeatInterval":35
				};
				
				protected var background:DisplayObject;
				
				protected var mouseState:String;
				
				protected var _selected:Boolean = false;
				
				protected var _autoRepeat:Boolean = false;
				
				protected var pressTimer:Timer;
				
				private var _mouseStateLocked:Boolean = false;
				
				private var unlockedMouseState:String;
				
				public function BaseButton() {
						super();
						buttonMode = true;
						mouseChildren = false;
						useHandCursor = false;
						this.setupMouseEvents();
						this.setMouseState("up");
						this.pressTimer = new Timer(1,0);
						this.pressTimer.addEventListener(TimerEvent.TIMER,this.buttonDown,false,0,true);
				}
				
				public static function getStyleDefinition() : Object {
						return defaultStyles;
				}
				
				override public function get enabled() : Boolean {
						return super.enabled;
				}
				
				override public function set enabled(value:Boolean) : void {
						super.enabled = value;
						mouseEnabled = value;
				}
				
				public function get selected() : Boolean {
						return this._selected;
				}
				
				public function set selected(value:Boolean) : void {
						if(this._selected == value) {
								return;
						}
						this._selected = value;
						invalidate(InvalidationType.STATE);
				}
				
				public function get autoRepeat() : Boolean {
						return this._autoRepeat;
				}
				
				public function set autoRepeat(value:Boolean) : void {
						this._autoRepeat = value;
				}
				
				public function set mouseStateLocked(value:Boolean) : void {
						this._mouseStateLocked = value;
						if(value == false) {
								this.setMouseState(this.unlockedMouseState);
						} else {
								this.unlockedMouseState = this.mouseState;
						}
				}
				
				public function setMouseState(state:String) : void {
						if(this._mouseStateLocked) {
								this.unlockedMouseState = state;
								return;
						}
						if(this.mouseState == state) {
								return;
						}
						this.mouseState = state;
						invalidate(InvalidationType.STATE);
				}
				
				protected function setupMouseEvents() : void {
						addEventListener(MouseEvent.ROLL_OVER,this.mouseEventHandler,false,0,true);
						addEventListener(MouseEvent.MOUSE_DOWN,this.mouseEventHandler,false,0,true);
						addEventListener(MouseEvent.MOUSE_UP,this.mouseEventHandler,false,0,true);
						addEventListener(MouseEvent.ROLL_OUT,this.mouseEventHandler,false,0,true);
				}
				
				protected function mouseEventHandler(event:MouseEvent) : void {
						if(event.type == MouseEvent.MOUSE_DOWN) {
								this.setMouseState("down");
								this.startPress();
						} else if(event.type == MouseEvent.ROLL_OVER || event.type == MouseEvent.MOUSE_UP) {
								this.setMouseState("over");
								this.endPress();
						} else if(event.type == MouseEvent.ROLL_OUT) {
								this.setMouseState("up");
								this.endPress();
						}
				}
				
				protected function startPress() : void {
						if(this._autoRepeat) {
								this.pressTimer.delay = Number(getStyleValue("repeatDelay"));
								this.pressTimer.start();
						}
						dispatchEvent(new ComponentEvent(ComponentEvent.BUTTON_DOWN,true));
				}
				
				protected function buttonDown(event:TimerEvent) : void {
						if(!this._autoRepeat) {
								this.endPress();
								return;
						}
						if(this.pressTimer.currentCount == 1) {
								this.pressTimer.delay = Number(getStyleValue("repeatInterval"));
						}
						dispatchEvent(new ComponentEvent(ComponentEvent.BUTTON_DOWN,true));
				}
				
				protected function endPress() : void {
						this.pressTimer.reset();
				}
				
				override protected function draw() : void {
						if(isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
								this.drawBackground();
								invalidate(InvalidationType.SIZE,false);
						}
						if(isInvalid(InvalidationType.SIZE)) {
								this.drawLayout();
						}
						super.draw();
				}
				
				protected function drawBackground() : void {
						var styleName:* = this.enabled ? this.mouseState : "disabled";
						if(this.selected) {
								styleName = "selected" + styleName.substr(0,1).toUpperCase() + styleName.substr(1);
						}
						styleName += "Skin";
						var bg:DisplayObject = this.background;
						this.background = getDisplayObjectInstance(getStyleValue(styleName));
						addChildAt(this.background,0);
						if(bg != null && bg != this.background) {
								removeChild(bg);
						}
				}
				
				protected function drawLayout() : void {
						this.background.width = width;
						this.background.height = height;
				}
		}
}

