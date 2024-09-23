package fl.controls {
		import fl.core.InvalidationType;
		import fl.core.UIComponent;
		import fl.events.ComponentEvent;
		import fl.managers.IFocusManagerComponent;
		import flash.display.DisplayObject;
		import flash.events.Event;
		import flash.events.KeyboardEvent;
		import flash.events.MouseEvent;
		import flash.text.TextField;
		import flash.text.TextFieldType;
		import flash.text.TextFormat;
		import flash.ui.Keyboard;
		
		public class LabelButton extends BaseButton implements IFocusManagerComponent {
				public static var createAccessibilityImplementation:Function;
				
				private static var defaultStyles:Object = {
						"icon":null,
						"upIcon":null,
						"downIcon":null,
						"overIcon":null,
						"disabledIcon":null,
						"selectedDisabledIcon":null,
						"selectedUpIcon":null,
						"selectedDownIcon":null,
						"selectedOverIcon":null,
						"textFormat":null,
						"disabledTextFormat":null,
						"textPadding":5,
						"embedFonts":false
				};
				
				public var textField:TextField;
				
				protected var _labelPlacement:String = "right";
				
				protected var _toggle:Boolean = false;
				
				protected var icon:DisplayObject;
				
				protected var oldMouseState:String;
				
				protected var _label:String = "Label";
				
				protected var mode:String = "center";
				
				public function LabelButton() {
						super();
				}
				
				public static function getStyleDefinition() : Object {
						return mergeStyles(defaultStyles,BaseButton.getStyleDefinition());
				}
				
				public function get label() : String {
						return this._label;
				}
				
				public function set label(value:String) : void {
						this._label = value;
						if(this.textField.text != this._label) {
								this.textField.text = this._label;
								dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
						}
						invalidate(InvalidationType.SIZE);
						invalidate(InvalidationType.STYLES);
				}
				
				public function get labelPlacement() : String {
						return this._labelPlacement;
				}
				
				public function set labelPlacement(value:String) : void {
						this._labelPlacement = value;
						invalidate(InvalidationType.SIZE);
				}
				
				public function get toggle() : Boolean {
						return this._toggle;
				}
				
				public function set toggle(value:Boolean) : void {
						if(!value && super.selected) {
								this.selected = false;
						}
						this._toggle = value;
						if(this._toggle) {
								addEventListener(MouseEvent.CLICK,this.toggleSelected,false,0,true);
						} else {
								removeEventListener(MouseEvent.CLICK,this.toggleSelected);
						}
						invalidate(InvalidationType.STATE);
				}
				
				protected function toggleSelected(event:MouseEvent) : void {
						this.selected = !this.selected;
						dispatchEvent(new Event(Event.CHANGE,true));
				}
				
				override public function get selected() : Boolean {
						return this._toggle ? _selected : false;
				}
				
				override public function set selected(value:Boolean) : void {
						_selected = value;
						if(this._toggle) {
								invalidate(InvalidationType.STATE);
						}
				}
				
				override protected function configUI() : void {
						super.configUI();
						this.textField = new TextField();
						this.textField.type = TextFieldType.DYNAMIC;
						this.textField.selectable = false;
						addChild(this.textField);
				}
				
				override protected function draw() : void {
						if(this.textField.text != this._label) {
								this.label = this._label;
						}
						if(isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
								drawBackground();
								this.drawIcon();
								this.drawTextFormat();
								invalidate(InvalidationType.SIZE,false);
						}
						if(isInvalid(InvalidationType.SIZE)) {
								this.drawLayout();
						}
						if(isInvalid(InvalidationType.SIZE,InvalidationType.STYLES)) {
								if(isFocused && focusManager.showFocusIndicator) {
										drawFocus(true);
								}
						}
						validate();
				}
				
				protected function drawIcon() : void {
						var oldIcon:DisplayObject = this.icon;
						var styleName:* = enabled ? mouseState : "disabled";
						if(this.selected) {
								styleName = "selected" + styleName.substr(0,1).toUpperCase() + styleName.substr(1);
						}
						styleName += "Icon";
						var iconStyle:Object = getStyleValue(styleName);
						if(iconStyle == null) {
								iconStyle = getStyleValue("icon");
						}
						if(iconStyle != null) {
								this.icon = getDisplayObjectInstance(iconStyle);
						}
						if(this.icon != null) {
								addChildAt(this.icon,1);
						}
						if(oldIcon != null && oldIcon != this.icon) {
								removeChild(oldIcon);
						}
				}
				
				protected function drawTextFormat() : void {
						var uiStyles:Object = UIComponent.getStyleDefinition();
						var defaultTF:TextFormat = enabled ? uiStyles.defaultTextFormat as TextFormat : uiStyles.defaultDisabledTextFormat as TextFormat;
						this.textField.setTextFormat(defaultTF);
						var tf:TextFormat = getStyleValue(enabled ? "textFormat" : "disabledTextFormat") as TextFormat;
						if(tf != null) {
								this.textField.setTextFormat(tf);
						} else {
								tf = defaultTF;
						}
						this.textField.defaultTextFormat = tf;
						this.setEmbedFont();
				}
				
				protected function setEmbedFont() : * {
						var embed:Object = getStyleValue("embedFonts");
						if(embed != null) {
								this.textField.embedFonts = embed;
						}
				}
				
				override protected function drawLayout() : void {
						var tmpWidth:Number = NaN;
						var tmpHeight:Number = NaN;
						var txtPad:Number = Number(getStyleValue("textPadding"));
						var placement:String = this.icon == null && this.mode == "center" ? ButtonLabelPlacement.TOP : this._labelPlacement;
						this.textField.height = this.textField.textHeight + 4;
						var txtW:Number = this.textField.textWidth + 4;
						var txtH:Number = this.textField.textHeight + 4;
						var paddedIconW:Number = this.icon == null ? 0 : this.icon.width + txtPad;
						var paddedIconH:Number = this.icon == null ? 0 : this.icon.height + txtPad;
						this.textField.visible = this.label.length > 0;
						if(this.icon != null) {
								this.icon.x = Math.round((width - this.icon.width) / 2);
								this.icon.y = Math.round((height - this.icon.height) / 2);
						}
						if(this.textField.visible == false) {
								this.textField.width = 0;
								this.textField.height = 0;
						} else if(placement == ButtonLabelPlacement.BOTTOM || placement == ButtonLabelPlacement.TOP) {
								tmpWidth = Math.max(0,Math.min(txtW,width - 2 * txtPad));
								if(height - 2 > txtH) {
										tmpHeight = txtH;
								} else {
										tmpHeight = height - 2;
								}
								this.textField.width = txtW = tmpWidth;
								this.textField.height = txtH = tmpHeight;
								this.textField.x = Math.round((width - txtW) / 2);
								this.textField.y = Math.round((height - this.textField.height - paddedIconH) / 2 + (placement == ButtonLabelPlacement.BOTTOM ? paddedIconH : 0));
								if(this.icon != null) {
										this.icon.y = Math.round(placement == ButtonLabelPlacement.BOTTOM ? this.textField.y - paddedIconH : this.textField.y + this.textField.height + txtPad);
								}
						} else {
								tmpWidth = Math.max(0,Math.min(txtW,width - paddedIconW - 2 * txtPad));
								this.textField.width = txtW = tmpWidth;
								this.textField.x = Math.round((width - txtW - paddedIconW) / 2 + (placement != ButtonLabelPlacement.LEFT ? paddedIconW : 0));
								this.textField.y = Math.round((height - this.textField.height) / 2);
								if(this.icon != null) {
										this.icon.x = Math.round(placement != ButtonLabelPlacement.LEFT ? this.textField.x - paddedIconW : this.textField.x + txtW + txtPad);
								}
						}
						super.drawLayout();
				}
				
				override protected function keyDownHandler(event:KeyboardEvent) : void {
						if(!enabled) {
								return;
						}
						if(event.keyCode == Keyboard.SPACE) {
								if(this.oldMouseState == null) {
										this.oldMouseState = mouseState;
								}
								setMouseState("down");
								startPress();
						}
				}
				
				override protected function keyUpHandler(event:KeyboardEvent) : void {
						if(!enabled) {
								return;
						}
						if(event.keyCode == Keyboard.SPACE) {
								setMouseState(this.oldMouseState);
								this.oldMouseState = null;
								endPress();
								dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						}
				}
				
				override protected function initializeAccessibility() : void {
						if(LabelButton.createAccessibilityImplementation != null) {
								LabelButton.createAccessibilityImplementation(this);
						}
				}
		}
}

