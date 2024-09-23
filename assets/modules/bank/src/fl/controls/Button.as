package fl.controls {
		import fl.core.InvalidationType;
		import fl.core.UIComponent;
		import fl.managers.IFocusManagerComponent;
		import flash.display.DisplayObject;
		
		public class Button extends LabelButton implements IFocusManagerComponent {
				public static var createAccessibilityImplementation:Function;
				
				private static var defaultStyles:Object = {
						"emphasizedSkin":"Button_emphasizedSkin",
						"emphasizedPadding":2
				};
				
				protected var _emphasized:Boolean = false;
				
				protected var emphasizedBorder:DisplayObject;
				
				public function Button() {
						super();
				}
				
				public static function getStyleDefinition() : Object {
						return UIComponent.mergeStyles(LabelButton.getStyleDefinition(),defaultStyles);
				}
				
				public function get emphasized() : Boolean {
						return this._emphasized;
				}
				
				public function set emphasized(value:Boolean) : void {
						this._emphasized = value;
						invalidate(InvalidationType.STYLES);
				}
				
				override protected function draw() : void {
						if(isInvalid(InvalidationType.STYLES) || isInvalid(InvalidationType.SIZE)) {
								this.drawEmphasized();
						}
						super.draw();
						if(this.emphasizedBorder != null) {
								setChildIndex(this.emphasizedBorder,numChildren - 1);
						}
				}
				
				protected function drawEmphasized() : void {
						var padding:Number = NaN;
						if(this.emphasizedBorder != null) {
								removeChild(this.emphasizedBorder);
						}
						this.emphasizedBorder = null;
						if(!this._emphasized) {
								return;
						}
						var emphasizedStyle:Object = getStyleValue("emphasizedSkin");
						if(emphasizedStyle != null) {
								this.emphasizedBorder = getDisplayObjectInstance(emphasizedStyle);
						}
						if(this.emphasizedBorder != null) {
								addChildAt(this.emphasizedBorder,0);
								padding = Number(getStyleValue("emphasizedPadding"));
								this.emphasizedBorder.x = this.emphasizedBorder.y = -padding;
								this.emphasizedBorder.width = width + padding * 2;
								this.emphasizedBorder.height = height + padding * 2;
						}
				}
				
				override public function drawFocus(focused:Boolean) : void {
						var emphasizedPadding:Number = NaN;
						var focusPadding:* = undefined;
						super.drawFocus(focused);
						if(focused) {
								emphasizedPadding = Number(getStyleValue("emphasizedPadding"));
								if(emphasizedPadding < 0 || !this._emphasized) {
										emphasizedPadding = 0;
								}
								focusPadding = getStyleValue("focusRectPadding");
								focusPadding = focusPadding == null ? 2 : focusPadding;
								focusPadding += emphasizedPadding;
								uiFocusRect.x = -focusPadding;
								uiFocusRect.y = -focusPadding;
								uiFocusRect.width = width + focusPadding * 2;
								uiFocusRect.height = height + focusPadding * 2;
						}
				}
				
				override protected function initializeAccessibility() : void {
						if(Button.createAccessibilityImplementation != null) {
								Button.createAccessibilityImplementation(this);
						}
				}
		}
}

