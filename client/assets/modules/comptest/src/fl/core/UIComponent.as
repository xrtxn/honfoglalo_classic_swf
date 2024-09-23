package fl.core {
		import fl.events.ComponentEvent;
		import fl.managers.FocusManager;
		import fl.managers.IFocusManager;
		import fl.managers.IFocusManagerComponent;
		import fl.managers.StyleManager;
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.InteractiveObject;
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.FocusEvent;
		import flash.events.KeyboardEvent;
		import flash.system.IME;
		import flash.system.IMEConversionMode;
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.text.TextFormatAlign;
		import flash.utils.Dictionary;
		import flash.utils.getDefinitionByName;
		import flash.utils.getQualifiedClassName;
		
		public class UIComponent extends Sprite {
				public static var createAccessibilityImplementation:Function;
				
				public static var inCallLaterPhase:Boolean = false;
				
				private static var defaultStyles:Object = {
						"focusRectSkin":"focusRectSkin",
						"focusRectPadding":2,
						"textFormat":new TextFormat("_sans",11,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
						"disabledTextFormat":new TextFormat("_sans",11,10066329,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
						"defaultTextFormat":new TextFormat("_sans",11,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
						"defaultDisabledTextFormat":new TextFormat("_sans",11,10066329,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0)
				};
				
				private static var focusManagers:Dictionary = new Dictionary(true);
				
				private static var focusManagerUsers:Dictionary = new Dictionary(true);
				
				public const version:String = "3.0.4.1";
				
				public var focusTarget:IFocusManagerComponent;
				
				protected var isLivePreview:Boolean = false;
				
				private var tempText:TextField;
				
				protected var instanceStyles:Object;
				
				protected var sharedStyles:Object;
				
				protected var callLaterMethods:Dictionary;
				
				protected var invalidateFlag:Boolean = false;
				
				protected var _enabled:Boolean = true;
				
				protected var invalidHash:Object;
				
				protected var uiFocusRect:DisplayObject;
				
				protected var isFocused:Boolean = false;
				
				private var _focusEnabled:Boolean = true;
				
				private var _mouseFocusEnabled:Boolean = true;
				
				protected var _width:Number;
				
				protected var _height:Number;
				
				protected var _x:Number;
				
				protected var _y:Number;
				
				protected var startWidth:Number;
				
				protected var startHeight:Number;
				
				protected var _imeMode:String = null;
				
				protected var _oldIMEMode:String = null;
				
				protected var errorCaught:Boolean = false;
				
				protected var _inspector:Boolean = false;
				
				public function UIComponent() {
						super();
						this.instanceStyles = {};
						this.sharedStyles = {};
						this.invalidHash = {};
						this.callLaterMethods = new Dictionary();
						StyleManager.registerInstance(this);
						this.configUI();
						this.invalidate(InvalidationType.ALL);
						tabEnabled = this is IFocusManagerComponent;
						focusRect = false;
						if(tabEnabled) {
								addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
								addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler);
								addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
								addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
						}
						this.initializeFocusManager();
						addEventListener(Event.ENTER_FRAME,this.hookAccessibility,false,0,true);
				}
				
				public static function getStyleDefinition() : Object {
						return defaultStyles;
				}
				
				public static function mergeStyles(... list) : Object {
						var styleList:Object = null;
						var n:String = null;
						var styles:Object = {};
						var l:uint = uint(list.length);
						for(var i:uint = 0; i < l; i++) {
								styleList = list[i];
								for(n in styleList) {
										if(styles[n] == null) {
												styles[n] = list[i][n];
										}
								}
						}
						return styles;
				}
				
				public function get componentInspectorSetting() : Boolean {
						return this._inspector;
				}
				
				public function set componentInspectorSetting(value:Boolean) : void {
						this._inspector = value;
						if(this._inspector) {
								this.beforeComponentParameters();
						} else {
								this.afterComponentParameters();
						}
				}
				
				protected function beforeComponentParameters() : void {
				}
				
				protected function afterComponentParameters() : void {
				}
				
				public function get enabled() : Boolean {
						return this._enabled;
				}
				
				public function set enabled(value:Boolean) : void {
						if(value == this._enabled) {
								return;
						}
						this._enabled = value;
						this.invalidate(InvalidationType.STATE);
				}
				
				public function setSize(width:Number, height:Number) : void {
						this._width = width;
						this._height = height;
						this.invalidate(InvalidationType.SIZE);
						dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE,false));
				}
				
				override public function get width() : Number {
						return this._width;
				}
				
				override public function set width(value:Number) : void {
						if(this._width == value) {
								return;
						}
						this.setSize(value,this.height);
				}
				
				override public function get height() : Number {
						return this._height;
				}
				
				override public function set height(value:Number) : void {
						if(this._height == value) {
								return;
						}
						this.setSize(this.width,value);
				}
				
				public function setStyle(style:String, value:Object) : void {
						if(this.instanceStyles[style] === value && !(value is TextFormat)) {
								return;
						}
						this.instanceStyles[style] = value;
						this.invalidate(InvalidationType.STYLES);
				}
				
				public function clearStyle(style:String) : void {
						this.setStyle(style,null);
				}
				
				public function getStyle(style:String) : Object {
						return this.instanceStyles[style];
				}
				
				public function move(x:Number, y:Number) : void {
						this._x = x;
						this._y = y;
						super.x = Math.round(x);
						super.y = Math.round(y);
						dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
				}
				
				override public function get x() : Number {
						return isNaN(this._x) ? super.x : this._x;
				}
				
				override public function set x(value:Number) : void {
						this.move(value,this._y);
				}
				
				override public function get y() : Number {
						return isNaN(this._y) ? super.y : this._y;
				}
				
				override public function set y(value:Number) : void {
						this.move(this._x,value);
				}
				
				override public function get scaleX() : Number {
						return this.width / this.startWidth;
				}
				
				override public function set scaleX(value:Number) : void {
						this.setSize(this.startWidth * value,this.height);
				}
				
				override public function get scaleY() : Number {
						return this.height / this.startHeight;
				}
				
				override public function set scaleY(value:Number) : void {
						this.setSize(this.width,this.startHeight * value);
				}
				
				protected function getScaleY() : Number {
						return super.scaleY;
				}
				
				protected function setScaleY(value:Number) : void {
						super.scaleY = value;
				}
				
				protected function getScaleX() : Number {
						return super.scaleX;
				}
				
				protected function setScaleX(value:Number) : void {
						super.scaleX = value;
				}
				
				override public function get visible() : Boolean {
						return super.visible;
				}
				
				override public function set visible(value:Boolean) : void {
						if(super.visible == value) {
								return;
						}
						super.visible = value;
						var t:String = value ? ComponentEvent.SHOW : ComponentEvent.HIDE;
						dispatchEvent(new ComponentEvent(t,true));
				}
				
				public function validateNow() : void {
						this.invalidate(InvalidationType.ALL,false);
						this.draw();
				}
				
				public function invalidate(property:String = "all", callLater:Boolean = true) : void {
						this.invalidHash[property] = true;
						if(callLater) {
								this.callLater(this.draw);
						}
				}
				
				public function setSharedStyle(name:String, style:Object) : void {
						if(this.sharedStyles[name] === style && !(style is TextFormat)) {
								return;
						}
						this.sharedStyles[name] = style;
						if(this.instanceStyles[name] == null) {
								this.invalidate(InvalidationType.STYLES);
						}
				}
				
				public function get focusEnabled() : Boolean {
						return this._focusEnabled;
				}
				
				public function set focusEnabled(b:Boolean) : void {
						this._focusEnabled = b;
				}
				
				public function get mouseFocusEnabled() : Boolean {
						return this._mouseFocusEnabled;
				}
				
				public function set mouseFocusEnabled(b:Boolean) : void {
						this._mouseFocusEnabled = b;
				}
				
				public function get focusManager() : IFocusManager {
						var o:DisplayObject = this;
						while(o) {
								if(UIComponent.focusManagers[o] != null) {
										return IFocusManager(UIComponent.focusManagers[o]);
								}
								o = o.parent;
						}
						return null;
				}
				
				public function set focusManager(f:IFocusManager) : void {
						UIComponent.focusManagers[this] = f;
				}
				
				public function drawFocus(focused:Boolean) : void {
						var focusPadding:Number = NaN;
						this.isFocused = focused;
						if(this.uiFocusRect != null && contains(this.uiFocusRect)) {
								removeChild(this.uiFocusRect);
								this.uiFocusRect = null;
						}
						if(focused) {
								this.uiFocusRect = this.getDisplayObjectInstance(this.getStyleValue("focusRectSkin")) as Sprite;
								if(this.uiFocusRect == null) {
										return;
								}
								focusPadding = Number(this.getStyleValue("focusRectPadding"));
								this.uiFocusRect.x = -focusPadding;
								this.uiFocusRect.y = -focusPadding;
								this.uiFocusRect.width = this.width + focusPadding * 2;
								this.uiFocusRect.height = this.height + focusPadding * 2;
								addChildAt(this.uiFocusRect,0);
						}
				}
				
				public function setFocus() : void {
						if(stage) {
								stage.focus = this;
						}
				}
				
				public function getFocus() : InteractiveObject {
						if(stage) {
								return stage.focus;
						}
						return null;
				}
				
				protected function setIMEMode(enabled:Boolean) : * {
						if(this._imeMode != null) {
								if(enabled) {
										IME.enabled = true;
										this._oldIMEMode = IME.conversionMode;
										try {
												if(!this.errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN) {
														IME.conversionMode = this._imeMode;
												}
												this.errorCaught = false;
										}
										catch(e:Error) {
												errorCaught = true;
												throw new Error("IME mode not supported: " + _imeMode);
										}
								} else {
										if(IME.conversionMode != IMEConversionMode.UNKNOWN && this._oldIMEMode != IMEConversionMode.UNKNOWN) {
												IME.conversionMode = this._oldIMEMode;
										}
										IME.enabled = false;
								}
						}
				}
				
				public function drawNow() : void {
						this.draw();
				}
				
				protected function configUI() : void {
						this.isLivePreview = this.checkLivePreview();
						var r:Number = rotation;
						rotation = 0;
						var w:Number = super.width;
						var h:Number = super.height;
						super.scaleX = super.scaleY = 1;
						this.setSize(w,h);
						this.move(super.x,super.y);
						rotation = r;
						this.startWidth = w;
						this.startHeight = h;
						if(numChildren > 0) {
								removeChildAt(0);
						}
				}
				
				protected function checkLivePreview() : Boolean {
						var className:String = null;
						if(parent == null) {
								return false;
						}
						try {
								className = getQualifiedClassName(parent);
						}
						catch(e:Error) {
						}
						return className == "fl.livepreview::LivePreviewParent";
				}
				
				protected function isInvalid(property:String, ... properties) : Boolean {
						if(Boolean(this.invalidHash[property]) || Boolean(this.invalidHash[InvalidationType.ALL])) {
								return true;
						}
						while(properties.length > 0) {
								if(this.invalidHash[properties.pop()]) {
										return true;
								}
						}
						return false;
				}
				
				protected function validate() : void {
						this.invalidHash = {};
				}
				
				protected function draw() : void {
						if(this.isInvalid(InvalidationType.SIZE,InvalidationType.STYLES)) {
								if(this.isFocused && this.focusManager.showFocusIndicator) {
										this.drawFocus(true);
								}
						}
						this.validate();
				}
				
				protected function getDisplayObjectInstance(skin:Object) : DisplayObject {
						var obj:Object = null;
						var classDef:Object = null;
						if(skin is Class) {
								obj = new skin();
								if(obj is BitmapData) {
										return new Bitmap(obj as BitmapData);
								}
								return obj as DisplayObject;
						}
						if(skin is DisplayObject) {
								(skin as DisplayObject).x = 0;
								(skin as DisplayObject).y = 0;
								return skin as DisplayObject;
						}
						if(skin is BitmapData) {
								return new Bitmap(skin as BitmapData);
						}
						try {
								classDef = getDefinitionByName(skin.toString());
						}
						catch(e:Error) {
								try {
										classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
								}
								catch(e:Error) {
								}
						}
						if(classDef == null) {
								return null;
						}
						obj = new classDef();
						if(obj is BitmapData) {
								return new Bitmap(obj as BitmapData);
						}
						return obj as DisplayObject;
				}
				
				protected function getStyleValue(name:String) : Object {
						return this.instanceStyles[name] == null ? this.sharedStyles[name] : this.instanceStyles[name];
				}
				
				protected function copyStylesToChild(child:UIComponent, styleMap:Object) : void {
						var n:String = null;
						for(n in styleMap) {
								child.setStyle(n,this.getStyleValue(styleMap[n]));
						}
				}
				
				protected function callLater(fn:Function) : void {
						if(inCallLaterPhase) {
								return;
						}
						this.callLaterMethods[fn] = true;
						if(stage != null) {
								try {
										stage.addEventListener(Event.RENDER,this.callLaterDispatcher,false,0,true);
										stage.invalidate();
								}
								catch(se:SecurityError) {
										addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
								}
						} else {
								addEventListener(Event.ADDED_TO_STAGE,this.callLaterDispatcher,false,0,true);
						}
				}
				
				private function callLaterDispatcher(event:Event) : void {
						var methods:Dictionary;
						var method:Object = null;
						if(event.type == Event.ADDED_TO_STAGE) {
								try {
										removeEventListener(Event.ADDED_TO_STAGE,this.callLaterDispatcher);
										stage.addEventListener(Event.RENDER,this.callLaterDispatcher,false,0,true);
										stage.invalidate();
										return;
								}
								catch(se1:SecurityError) {
										addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
								}
						} else {
								event.target.removeEventListener(Event.RENDER,this.callLaterDispatcher);
								event.target.removeEventListener(Event.ENTER_FRAME,this.callLaterDispatcher);
								try {
										if(stage == null) {
												addEventListener(Event.ADDED_TO_STAGE,this.callLaterDispatcher,false,0,true);
												return;
										}
								}
								catch(se2:SecurityError) {
								}
						}
						inCallLaterPhase = true;
						methods = this.callLaterMethods;
						for(method in methods) {
								method();
								delete methods[method];
						}
						inCallLaterPhase = false;
				}
				
				private function initializeFocusManager() : void {
						var fm:IFocusManager = null;
						var fmUserDict:Dictionary = null;
						if(stage == null) {
								addEventListener(Event.ADDED_TO_STAGE,this.addedHandler,false,0,true);
						} else {
								this.createFocusManager();
								fm = this.focusManager;
								if(fm != null) {
										fmUserDict = focusManagerUsers[fm];
										if(fmUserDict == null) {
												fmUserDict = new Dictionary(true);
												focusManagerUsers[fm] = fmUserDict;
										}
										fmUserDict[this] = true;
								}
						}
						addEventListener(Event.REMOVED_FROM_STAGE,this.removedHandler);
				}
				
				private function addedHandler(evt:Event) : void {
						removeEventListener(Event.ADDED_TO_STAGE,this.addedHandler);
						this.initializeFocusManager();
				}
				
				private function removedHandler(evt:Event) : void {
						var fmUserDict:Dictionary = null;
						var dictEmpty:Boolean = false;
						var key:* = undefined;
						var key2:* = undefined;
						var compFM:IFocusManager = null;
						removeEventListener(Event.REMOVED_FROM_STAGE,this.removedHandler);
						addEventListener(Event.ADDED_TO_STAGE,this.addedHandler);
						var fm:IFocusManager = this.focusManager;
						if(fm != null) {
								fmUserDict = focusManagerUsers[fm];
								if(fmUserDict != null) {
										delete fmUserDict[this];
										dictEmpty = true;
										var _loc8_:int = 0;
										var _loc9_:* = fmUserDict;
										for(key in _loc9_) {
												dictEmpty = false;
										}
										if(dictEmpty) {
												delete focusManagerUsers[fm];
												fmUserDict = null;
										}
								}
								if(fmUserDict == null) {
										fm.deactivate();
										for(key2 in focusManagers) {
												compFM = focusManagers[key2];
												if(fm == compFM) {
														delete focusManagers[key2];
												}
										}
								}
						}
				}
				
				protected function createFocusManager() : void {
						var myTopLevel:DisplayObjectContainer;
						var stageAccessOK:Boolean = true;
						try {
								stage.getChildAt(0);
						}
						catch(se:SecurityError) {
								stageAccessOK = false;
						}
						myTopLevel = null;
						if(stageAccessOK) {
								myTopLevel = stage;
						} else {
								myTopLevel = this;
								try {
										while(myTopLevel.parent != null) {
												myTopLevel = myTopLevel.parent;
										}
								}
								catch(se:SecurityError) {
								}
						}
						if(focusManagers[myTopLevel] == null) {
								focusManagers[myTopLevel] = new FocusManager(myTopLevel);
						}
				}
				
				protected function isOurFocus(target:DisplayObject) : Boolean {
						return target == this;
				}
				
				protected function focusInHandler(event:FocusEvent) : void {
						var fm:IFocusManager = null;
						if(this.isOurFocus(event.target as DisplayObject)) {
								fm = this.focusManager;
								if(Boolean(fm) && fm.showFocusIndicator) {
										this.drawFocus(true);
										this.isFocused = true;
								}
						}
				}
				
				protected function focusOutHandler(event:FocusEvent) : void {
						if(this.isOurFocus(event.target as DisplayObject)) {
								this.drawFocus(false);
								this.isFocused = false;
						}
				}
				
				protected function keyDownHandler(event:KeyboardEvent) : void {
				}
				
				protected function keyUpHandler(event:KeyboardEvent) : void {
				}
				
				protected function hookAccessibility(event:Event) : void {
						removeEventListener(Event.ENTER_FRAME,this.hookAccessibility);
						this.initializeAccessibility();
				}
				
				protected function initializeAccessibility() : void {
						if(UIComponent.createAccessibilityImplementation != null) {
								UIComponent.createAccessibilityImplementation(this);
						}
				}
		}
}

