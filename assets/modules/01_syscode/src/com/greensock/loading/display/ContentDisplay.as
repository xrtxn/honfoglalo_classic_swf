package com.greensock.loading.display {
		import com.greensock.loading.core.LoaderItem;
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.Loader;
		import flash.display.LoaderInfo;
		import flash.display.Sprite;
		import flash.geom.Matrix;
		import flash.geom.Rectangle;
		
		public class ContentDisplay extends Sprite {
				protected static var _transformProps:Object = {
						"x":1,
						"y":1,
						"scaleX":1,
						"scaleY":1,
						"rotation":1,
						"alpha":1,
						"visible":true,
						"blendMode":"normal",
						"centerRegistration":false,
						"crop":false,
						"scaleMode":"stretch",
						"hAlign":"center",
						"vAlign":"center"
				};
				
				protected var _loader:LoaderItem;
				
				protected var _rawContent:DisplayObject;
				
				protected var _centerRegistration:Boolean;
				
				protected var _crop:Boolean;
				
				protected var _scaleMode:String = "stretch";
				
				protected var _hAlign:String = "center";
				
				protected var _vAlign:String = "center";
				
				protected var _bgColor:uint;
				
				protected var _bgAlpha:Number = 0;
				
				protected var _fitWidth:Number;
				
				protected var _fitHeight:Number;
				
				protected var _cropContainer:Sprite;
				
				public var gcProtect:*;
				
				public var data:*;
				
				public function ContentDisplay(loader:LoaderItem) {
						super();
						this.loader = loader;
				}
				
				public function dispose(unloadLoader:Boolean = true, disposeLoader:Boolean = true) : void {
						if(this.parent != null) {
								this.parent.removeChild(this);
						}
						this.rawContent = null;
						this.gcProtect = null;
						if(this._loader != null) {
								if(unloadLoader) {
										this._loader.unload();
								}
								if(disposeLoader) {
										this._loader.dispose(false);
										this._loader = null;
								}
						}
				}
				
				protected function _update() : void {
						var m:Matrix = null;
						var loaderInfo:LoaderInfo = null;
						var w:Number = NaN;
						var h:Number = NaN;
						var wGap:Number = NaN;
						var hGap:Number = NaN;
						var displayRatio:Number = NaN;
						var contentRatio:Number = NaN;
						var left:Number = this._centerRegistration && this._fitWidth > 0 ? this._fitWidth / -2 : 0;
						var top:Number = this._centerRegistration && this._fitHeight > 0 ? this._fitHeight / -2 : 0;
						graphics.clear();
						if(this._fitWidth > 0 && this._fitHeight > 0) {
								graphics.beginFill(this._bgColor,this._bgAlpha);
								graphics.drawRect(left,top,this._fitWidth,this._fitHeight);
								graphics.endFill();
						}
						if(this._rawContent == null) {
								return;
						}
						var mc:DisplayObject = this._rawContent;
						var contentWidth:Number = mc.width;
						var contentHeight:Number = mc.height;
						if(this._loader.hasOwnProperty("getClass")) {
								m = mc.transform.matrix;
								loaderInfo = mc is Loader ? Object(mc).contentLoaderInfo : mc.loaderInfo;
								contentWidth = loaderInfo.width * Math.abs(m.a) + loaderInfo.height * Math.abs(m.b);
								contentHeight = loaderInfo.width * Math.abs(m.c) + loaderInfo.height * Math.abs(m.d);
						}
						if(this._fitWidth > 0 && this._fitHeight > 0) {
								w = this._fitWidth;
								h = this._fitHeight;
								wGap = w - contentWidth;
								hGap = h - contentHeight;
								if(this._scaleMode != "none") {
										displayRatio = w / h;
										contentRatio = contentWidth / contentHeight;
										if(contentRatio < displayRatio && this._scaleMode == "proportionalInside" || contentRatio > displayRatio && this._scaleMode == "proportionalOutside") {
												w = h * contentRatio;
										}
										if(contentRatio > displayRatio && this._scaleMode == "proportionalInside" || contentRatio < displayRatio && this._scaleMode == "proportionalOutside") {
												h = w / contentRatio;
										}
										if(this._scaleMode != "heightOnly") {
												mc.width *= w / contentWidth;
												wGap = this._fitWidth - w;
										}
										if(this._scaleMode != "widthOnly") {
												mc.height *= h / contentHeight;
												hGap = this._fitHeight - h;
										}
								}
								if(this._hAlign == "left") {
										wGap = 0;
								} else if(this._hAlign != "right") {
										wGap /= 2;
								}
								if(this._vAlign == "top") {
										hGap = 0;
								} else if(this._vAlign != "bottom") {
										hGap /= 2;
								}
								if(this._crop) {
										if(this._cropContainer == null || mc.parent != this._cropContainer) {
												this._cropContainer = new Sprite();
												this.addChildAt(this._cropContainer,this.getChildIndex(mc));
												this._cropContainer.addChild(mc);
										}
										this._cropContainer.x = left;
										this._cropContainer.y = top;
										this._cropContainer.scrollRect = new Rectangle(0,0,this._fitWidth,this._fitHeight);
										mc.x = wGap;
										mc.y = hGap;
								} else {
										if(this._cropContainer != null) {
												this.addChildAt(mc,this.getChildIndex(this._cropContainer));
												this._cropContainer = null;
										}
										mc.x = left + wGap;
										mc.y = top + hGap;
								}
						} else {
								mc.x = this._centerRegistration ? contentWidth / -2 : 0;
								mc.y = this._centerRegistration ? contentHeight / -2 : 0;
						}
				}
				
				public function get fitWidth() : Number {
						return this._fitWidth;
				}
				
				public function set fitWidth(value:Number) : void {
						this._fitWidth = value;
						this._update();
				}
				
				public function get fitHeight() : Number {
						return this._fitHeight;
				}
				
				public function set fitHeight(value:Number) : void {
						this._fitHeight = value;
						this._update();
				}
				
				public function get scaleMode() : String {
						return this._scaleMode;
				}
				
				public function set scaleMode(value:String) : void {
						if(value == "none" && this._rawContent != null) {
								this._rawContent.scaleX = this._rawContent.scaleY = 1;
						}
						this._scaleMode = value;
						this._update();
				}
				
				public function get centerRegistration() : Boolean {
						return this._centerRegistration;
				}
				
				public function set centerRegistration(value:Boolean) : void {
						this._centerRegistration = value;
						this._update();
				}
				
				public function get crop() : Boolean {
						return this._crop;
				}
				
				public function set crop(value:Boolean) : void {
						this._crop = value;
						this._update();
				}
				
				public function get hAlign() : String {
						return this._hAlign;
				}
				
				public function set hAlign(value:String) : void {
						this._hAlign = value;
						this._update();
				}
				
				public function get vAlign() : String {
						return this._vAlign;
				}
				
				public function set vAlign(value:String) : void {
						this._vAlign = value;
						this._update();
				}
				
				public function get bgColor() : uint {
						return this._bgColor;
				}
				
				public function set bgColor(value:uint) : void {
						this._bgColor = value;
						this._update();
				}
				
				public function get bgAlpha() : Number {
						return this._bgAlpha;
				}
				
				public function set bgAlpha(value:Number) : void {
						this._bgAlpha = value;
						this._update();
				}
				
				public function get rawContent() : * {
						return this._rawContent;
				}
				
				public function set rawContent(value:*) : void {
						if(this._rawContent != null && this._rawContent != value) {
								if(this._rawContent.parent == this) {
										removeChild(this._rawContent);
								} else if(this._cropContainer != null && this._rawContent.parent == this._cropContainer) {
										this._cropContainer.removeChild(this._rawContent);
										removeChild(this._cropContainer);
										this._cropContainer = null;
								}
						}
						this._rawContent = value as DisplayObject;
						if(this._rawContent == null) {
								return;
						}
						addChildAt(this._rawContent as DisplayObject,0);
						this._update();
				}
				
				public function get loader() : LoaderItem {
						return this._loader;
				}
				
				public function set loader(value:LoaderItem) : void {
						var type:* = null;
						var p:String = null;
						this._loader = value;
						if(this._loader == null) {
								return;
						}
						if(!this._loader.hasOwnProperty("setContentDisplay")) {
								throw new Error("Incompatible loader used for a ContentDisplay");
						}
						this.name = this._loader.name;
						for(p in _transformProps) {
								if(p in this._loader.vars) {
										type = typeof _transformProps[p];
										this[p] = type == "number" ? Number(this._loader.vars[p]) : (type == "string" ? String(this._loader.vars[p]) : Boolean(this._loader.vars[p]));
								}
						}
						this._bgColor = uint(this._loader.vars.bgColor);
						this._bgAlpha = "bgAlpha" in this._loader.vars ? Number(this._loader.vars.bgAlpha) : ("bgColor" in this._loader.vars ? 1 : 0);
						this._fitWidth = "fitWidth" in this._loader.vars ? Number(this._loader.vars.fitWidth) : Number(this._loader.vars.width);
						this._fitHeight = "fitHeight" in this._loader.vars ? Number(this._loader.vars.fitHeight) : Number(this._loader.vars.height);
						this._update();
						if(this._loader.vars.container is DisplayObjectContainer) {
								(this._loader.vars.container as DisplayObjectContainer).addChild(this);
						}
						if(this._loader.content != this) {
								(this._loader as Object).setContentDisplay(this);
						}
						this.rawContent = (this._loader as Object).rawContent;
				}
		}
}

