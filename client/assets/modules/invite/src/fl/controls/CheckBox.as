package fl.controls {
		import flash.display.DisplayObject;
		import flash.display.Graphics;
		import flash.display.Shape;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol118")]
		public class CheckBox extends LabelButton {
				public static var createAccessibilityImplementation:Function;
				
				private static var defaultStyles:Object = {
						"icon":null,
						"upIcon":"CheckBox_upIcon",
						"downIcon":"CheckBox_downIcon",
						"overIcon":"CheckBox_overIcon",
						"disabledIcon":"CheckBox_disabledIcon",
						"selectedDisabledIcon":"CheckBox_selectedDisabledIcon",
						"focusRectSkin":null,
						"focusRectPadding":null,
						"selectedUpIcon":"CheckBox_selectedUpIcon",
						"selectedDownIcon":"CheckBox_selectedDownIcon",
						"selectedOverIcon":"CheckBox_selectedOverIcon",
						"textFormat":null,
						"disabledTextFormat":null,
						"embedFonts":null,
						"textPadding":5
				};
				
				public function CheckBox() {
						super();
				}
				
				public static function getStyleDefinition() : Object {
						return defaultStyles;
				}
				
				override public function get toggle() : Boolean {
						return true;
				}
				
				override public function set toggle(value:Boolean) : void {
						throw new Error("Warning: You cannot change a CheckBox\'s toggle.");
				}
				
				override public function get autoRepeat() : Boolean {
						return false;
				}
				
				override public function set autoRepeat(value:Boolean) : void {
				}
				
				override protected function drawLayout() : void {
						super.drawLayout();
						var textPadding:Number = Number(getStyleValue("textPadding"));
						switch(_labelPlacement) {
								case ButtonLabelPlacement.RIGHT:
										icon.x = textPadding;
										textField.x = icon.x + (icon.width + textPadding);
										background.width = textField.x + textField.width + textPadding;
										background.height = Math.max(textField.height,icon.height) + textPadding * 2;
										break;
								case ButtonLabelPlacement.LEFT:
										icon.x = width - icon.width - textPadding;
										textField.x = width - icon.width - textPadding * 2 - textField.width;
										background.width = textField.width + icon.width + textPadding * 3;
										background.height = Math.max(textField.height,icon.height) + textPadding * 2;
										break;
								case ButtonLabelPlacement.TOP:
								case ButtonLabelPlacement.BOTTOM:
										background.width = Math.max(textField.width,icon.width) + textPadding * 2;
										background.height = textField.height + icon.height + textPadding * 3;
						}
						background.x = Math.min(icon.x - textPadding,textField.x - textPadding);
						background.y = Math.min(icon.y - textPadding,textField.y - textPadding);
				}
				
				override protected function drawBackground() : void {
				}
				
				override public function drawFocus(focused:Boolean) : void {
						var focusPadding:Number = NaN;
						super.drawFocus(focused);
						if(focused) {
								focusPadding = Number(getStyleValue("focusRectPadding"));
								uiFocusRect.x = background.x - focusPadding;
								uiFocusRect.y = background.y - focusPadding;
								uiFocusRect.width = background.width + (focusPadding << 1);
								uiFocusRect.height = background.height + (focusPadding << 1);
						}
				}
				
				override protected function initializeAccessibility() : void {
						if(CheckBox.createAccessibilityImplementation != null) {
								CheckBox.createAccessibilityImplementation(this);
						}
				}
				
				override protected function configUI() : void {
						super.configUI();
						super.toggle = true;
						var bg:Shape = new Shape();
						var g:Graphics = bg.graphics;
						g.beginFill(0,0);
						g.drawRect(0,0,100,100);
						g.endFill();
						background = bg as DisplayObject;
						addChildAt(background,0);
				}
		}
}

