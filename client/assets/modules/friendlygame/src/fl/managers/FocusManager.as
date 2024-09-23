package fl.managers {
		import fl.controls.Button;
		import fl.core.UIComponent;
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.InteractiveObject;
		import flash.display.SimpleButton;
		import flash.display.Stage;
		import flash.events.Event;
		import flash.events.FocusEvent;
		import flash.events.KeyboardEvent;
		import flash.events.MouseEvent;
		import flash.text.TextField;
		import flash.text.TextFieldType;
		import flash.ui.Keyboard;
		import flash.utils.*;
		
		public class FocusManager implements IFocusManager {
				private var _form:DisplayObjectContainer;
				
				private var focusableObjects:Dictionary;
				
				private var focusableCandidates:Array;
				
				private var activated:Boolean = false;
				
				private var calculateCandidates:Boolean = true;
				
				private var lastFocus:InteractiveObject;
				
				private var _showFocusIndicator:Boolean = true;
				
				private var lastAction:String;
				
				private var defButton:Button;
				
				private var _defaultButton:Button;
				
				private var _defaultButtonEnabled:Boolean = true;
				
				public function FocusManager(container:DisplayObjectContainer) {
						super();
						this.focusableObjects = new Dictionary(true);
						if(container != null) {
								this._form = container;
								this.activate();
						}
				}
				
				private function addedHandler(event:Event) : void {
						var target:DisplayObject = DisplayObject(event.target);
						if(target.stage) {
								this.addFocusables(DisplayObject(event.target));
						}
				}
				
				private function removedHandler(event:Event) : void {
						var i:int = 0;
						var io:InteractiveObject = null;
						var o:DisplayObject = DisplayObject(event.target);
						if(o is IFocusManagerComponent && this.focusableObjects[o] == true) {
								if(o == this.lastFocus) {
										IFocusManagerComponent(this.lastFocus).drawFocus(false);
										this.lastFocus = null;
								}
								o.removeEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler,false);
								delete this.focusableObjects[o];
								this.calculateCandidates = true;
						} else if(o is InteractiveObject && this.focusableObjects[o] == true) {
								io = o as InteractiveObject;
								if(io) {
										if(io == this.lastFocus) {
												this.lastFocus = null;
										}
										delete this.focusableObjects[io];
										this.calculateCandidates = true;
								}
								o.addEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler,false,0,true);
						}
						this.removeFocusables(o);
				}
				
				private function addFocusables(o:DisplayObject, skipTopLevel:Boolean = false) : void {
						var focusable:IFocusManagerComponent = null;
						var io:InteractiveObject = null;
						var doc:DisplayObjectContainer = null;
						var docParent:DisplayObjectContainer = null;
						var i:int = 0;
						var child:DisplayObject = null;
						if(!skipTopLevel) {
								if(o is IFocusManagerComponent) {
										focusable = IFocusManagerComponent(o);
										if(focusable.focusEnabled) {
												if(focusable.tabEnabled && this.isTabVisible(o)) {
														this.focusableObjects[o] = true;
														this.calculateCandidates = true;
												}
												o.addEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler,false,0,true);
												o.addEventListener(Event.TAB_INDEX_CHANGE,this.tabIndexChangeHandler,false,0,true);
										}
								} else if(o is InteractiveObject) {
										io = o as InteractiveObject;
										if(io && io.tabEnabled && this.findFocusManagerComponent(io) == io) {
												this.focusableObjects[io] = true;
												this.calculateCandidates = true;
										}
										io.addEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler,false,0,true);
										io.addEventListener(Event.TAB_INDEX_CHANGE,this.tabIndexChangeHandler,false,0,true);
								}
						}
						if(o is DisplayObjectContainer) {
								doc = DisplayObjectContainer(o);
								o.addEventListener(Event.TAB_CHILDREN_CHANGE,this.tabChildrenChangeHandler,false,0,true);
								docParent = null;
								try {
										docParent = doc.parent;
								}
								catch(se:SecurityError) {
										docParent = null;
								}
								if(doc is Stage || docParent is Stage || doc.tabChildren) {
										for(i = 0; i < doc.numChildren; i++) {
												try {
														child = doc.getChildAt(i);
														if(child != null) {
																this.addFocusables(doc.getChildAt(i));
														}
												}
												catch(error:SecurityError) {
												}
										}
								}
						}
				}
				
				private function removeFocusables(o:DisplayObject) : void {
						var p:Object = null;
						var dob:DisplayObject = null;
						if(o is DisplayObjectContainer) {
								o.removeEventListener(Event.TAB_CHILDREN_CHANGE,this.tabChildrenChangeHandler,false);
								o.removeEventListener(Event.TAB_INDEX_CHANGE,this.tabIndexChangeHandler,false);
								for(p in this.focusableObjects) {
										dob = DisplayObject(p);
										if(DisplayObjectContainer(o).contains(dob)) {
												if(dob == this.lastFocus) {
														this.lastFocus = null;
												}
												dob.removeEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler,false);
												delete this.focusableObjects[p];
												this.calculateCandidates = true;
										}
								}
						}
				}
				
				private function isTabVisible(o:DisplayObject) : Boolean {
						var p:DisplayObjectContainer = null;
						try {
								p = o.parent;
								while(p && !(p is Stage) && !(p.parent && p.parent is Stage)) {
										if(!p.tabChildren) {
												return false;
										}
										p = p.parent;
								}
						}
						catch(se:SecurityError) {
						}
						return true;
				}
				
				private function isValidFocusCandidate(o:DisplayObject, groupName:String) : Boolean {
						var tg:IFocusManagerGroup = null;
						if(!this.isEnabledAndVisible(o)) {
								return false;
						}
						if(o is IFocusManagerGroup) {
								tg = IFocusManagerGroup(o);
								if(groupName == tg.groupName) {
										return false;
								}
						}
						return true;
				}
				
				private function isEnabledAndVisible(o:DisplayObject) : Boolean {
						var formParent:DisplayObjectContainer = null;
						var tf:TextField = null;
						var sb:SimpleButton = null;
						try {
								formParent = DisplayObject(this.form).parent;
								while(o != formParent) {
										if(o is UIComponent) {
												if(!UIComponent(o).enabled) {
														return false;
												}
										} else if(o is TextField) {
												tf = TextField(o);
												if(tf.type == TextFieldType.DYNAMIC || !tf.selectable) {
														return false;
												}
										} else if(o is SimpleButton) {
												sb = SimpleButton(o);
												if(!sb.enabled) {
														return false;
												}
										}
										if(!o.visible) {
												return false;
										}
										o = o.parent;
								}
						}
						catch(se:SecurityError) {
						}
						return true;
				}
				
				private function tabEnabledChangeHandler(event:Event) : void {
						this.calculateCandidates = true;
						var o:InteractiveObject = InteractiveObject(event.target);
						var registeredFocusableObject:* = this.focusableObjects[o] == true;
						if(o.tabEnabled) {
								if(!registeredFocusableObject && this.isTabVisible(o)) {
										if(!(o is IFocusManagerComponent)) {
												o.focusRect = false;
										}
										this.focusableObjects[o] = true;
								}
						} else if(registeredFocusableObject) {
								delete this.focusableObjects[o];
						}
				}
				
				private function tabIndexChangeHandler(event:Event) : void {
						this.calculateCandidates = true;
				}
				
				private function tabChildrenChangeHandler(event:Event) : void {
						if(event.target != event.currentTarget) {
								return;
						}
						this.calculateCandidates = true;
						var o:DisplayObjectContainer = DisplayObjectContainer(event.target);
						if(o.tabChildren) {
								this.addFocusables(o,true);
						} else {
								this.removeFocusables(o);
						}
				}
				
				public function activate() : void {
						if(this.activated) {
								return;
						}
						this.addFocusables(this.form);
						this.form.addEventListener(Event.ADDED,this.addedHandler,false,0,true);
						this.form.addEventListener(Event.REMOVED,this.removedHandler,false,0,true);
						try {
								this.form.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false,0,true);
								this.form.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false,0,true);
								this.form.stage.addEventListener(Event.ACTIVATE,this.activateHandler,false,0,true);
								this.form.stage.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
						}
						catch(se:SecurityError) {
								form.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,mouseFocusChangeHandler,false,0,true);
								form.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler,false,0,true);
								form.addEventListener(Event.ACTIVATE,activateHandler,false,0,true);
								form.addEventListener(Event.DEACTIVATE,deactivateHandler,false,0,true);
						}
						this.form.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true,0,true);
						this.form.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true,0,true);
						this.form.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false,0,true);
						this.form.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true,0,true);
						this.activated = true;
						if(this.lastFocus) {
								this.setFocus(this.lastFocus);
						}
				}
				
				public function deactivate() : void {
						if(!this.activated) {
								return;
						}
						this.focusableObjects = new Dictionary(true);
						this.focusableCandidates = null;
						this.lastFocus = null;
						this.defButton = null;
						this.form.removeEventListener(Event.ADDED,this.addedHandler,false);
						this.form.removeEventListener(Event.REMOVED,this.removedHandler,false);
						try {
								this.form.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false);
								this.form.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false);
								this.form.stage.removeEventListener(Event.ACTIVATE,this.activateHandler,false);
								this.form.stage.removeEventListener(Event.DEACTIVATE,this.deactivateHandler,false);
						}
						catch(se:SecurityError) {
						}
						this.form.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false);
						this.form.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false);
						this.form.removeEventListener(Event.ACTIVATE,this.activateHandler,false);
						this.form.removeEventListener(Event.DEACTIVATE,this.deactivateHandler,false);
						this.form.removeEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true);
						this.form.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true);
						this.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false);
						this.form.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true);
						this.activated = false;
				}
				
				private function focusInHandler(event:FocusEvent) : void {
						var x:Button = null;
						if(!this.activated) {
								return;
						}
						var target:InteractiveObject = InteractiveObject(event.target);
						if(this.form.contains(target)) {
								this.lastFocus = this.findFocusManagerComponent(InteractiveObject(target));
								if(this.lastFocus is Button) {
										x = Button(this.lastFocus);
										if(this.defButton) {
												this.defButton.emphasized = false;
												this.defButton = x;
												x.emphasized = true;
										}
								} else if(Boolean(this.defButton) && this.defButton != this._defaultButton) {
										this.defButton.emphasized = false;
										this.defButton = this._defaultButton;
										this._defaultButton.emphasized = true;
								}
						}
				}
				
				private function focusOutHandler(event:FocusEvent) : void {
						if(!this.activated) {
								return;
						}
						var target:InteractiveObject = event.target as InteractiveObject;
				}
				
				private function activateHandler(event:Event) : void {
						if(!this.activated) {
								return;
						}
						var target:InteractiveObject = InteractiveObject(event.target);
						if(this.lastFocus) {
								if(this.lastFocus is IFocusManagerComponent) {
										IFocusManagerComponent(this.lastFocus).setFocus();
								} else {
										this.form.stage.focus = this.lastFocus;
								}
						}
						this.lastAction = "ACTIVATE";
				}
				
				private function deactivateHandler(event:Event) : void {
						if(!this.activated) {
								return;
						}
						var target:InteractiveObject = InteractiveObject(event.target);
				}
				
				private function mouseFocusChangeHandler(event:FocusEvent) : void {
						if(!this.activated) {
								return;
						}
						if(event.relatedObject is TextField) {
								return;
						}
						event.preventDefault();
				}
				
				private function keyFocusChangeHandler(event:FocusEvent) : void {
						if(!this.activated) {
								return;
						}
						this.showFocusIndicator = true;
						if((event.keyCode == Keyboard.TAB || event.keyCode == 0) && !event.isDefaultPrevented()) {
								this.setFocusToNextObject(event);
								event.preventDefault();
						}
				}
				
				private function keyDownHandler(event:KeyboardEvent) : void {
						if(!this.activated) {
								return;
						}
						if(event.keyCode == Keyboard.TAB) {
								this.lastAction = "KEY";
								if(this.calculateCandidates) {
										this.sortFocusableObjects();
										this.calculateCandidates = false;
								}
						}
						if(this.defaultButtonEnabled && event.keyCode == Keyboard.ENTER && this.defaultButton && this.defButton.enabled) {
								this.sendDefaultButtonEvent();
						}
				}
				
				private function mouseDownHandler(event:MouseEvent) : void {
						if(!this.activated) {
								return;
						}
						if(event.isDefaultPrevented()) {
								return;
						}
						var o:InteractiveObject = this.getTopLevelFocusTarget(InteractiveObject(event.target));
						if(!o) {
								return;
						}
						this.showFocusIndicator = false;
						if((o != this.lastFocus || this.lastAction == "ACTIVATE") && !(o is TextField)) {
								this.setFocus(o);
						}
						this.lastAction = "MOUSEDOWN";
				}
				
				public function get defaultButton() : Button {
						return this._defaultButton;
				}
				
				public function set defaultButton(value:Button) : void {
						var button:Button = !!value ? Button(value) : null;
						if(button != this._defaultButton) {
								if(this._defaultButton) {
										this._defaultButton.emphasized = false;
								}
								if(this.defButton) {
										this.defButton.emphasized = false;
								}
								this._defaultButton = button;
								this.defButton = button;
								if(button) {
										button.emphasized = true;
								}
						}
				}
				
				public function sendDefaultButtonEvent() : void {
						this.defButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				
				private function setFocusToNextObject(event:FocusEvent) : void {
						if(!this.hasFocusableObjects()) {
								return;
						}
						var o:InteractiveObject = this.getNextFocusManagerComponent(event.shiftKey);
						if(o) {
								this.setFocus(o);
						}
				}
				
				private function hasFocusableObjects() : Boolean {
						var o:Object = null;
						var _loc2_:int = 0;
						var _loc3_:* = this.focusableObjects;
						for(o in _loc3_) {
								return true;
						}
						return false;
				}
				
				public function getNextFocusManagerComponent(backward:Boolean = false) : InteractiveObject {
						var tg:IFocusManagerGroup = null;
						if(!this.hasFocusableObjects()) {
								return null;
						}
						if(this.calculateCandidates) {
								this.sortFocusableObjects();
								this.calculateCandidates = false;
						}
						var o:DisplayObject = this.form.stage.focus;
						o = DisplayObject(this.findFocusManagerComponent(InteractiveObject(o)));
						var g:String = "";
						if(o is IFocusManagerGroup) {
								tg = IFocusManagerGroup(o);
								g = tg.groupName;
						}
						var i:int = this.getIndexOfFocusedObject(o);
						var bSearchAll:Boolean = false;
						var start:int = i;
						if(i == -1) {
								if(backward) {
										i = int(this.focusableCandidates.length);
								}
								bSearchAll = true;
						}
						var j:int = this.getIndexOfNextObject(i,backward,bSearchAll,g);
						return this.findFocusManagerComponent(this.focusableCandidates[j]);
				}
				
				private function getIndexOfFocusedObject(o:DisplayObject) : int {
						var n:int = int(this.focusableCandidates.length);
						var i:int = 0;
						for(i = 0; i < n; i++) {
								if(this.focusableCandidates[i] == o) {
										return i;
								}
						}
						return -1;
				}
				
				private function getIndexOfNextObject(i:int, shiftKey:Boolean, bSearchAll:Boolean, groupName:String) : int {
						var o:DisplayObject = null;
						var tg1:IFocusManagerGroup = null;
						var j:int = 0;
						var obj:DisplayObject = null;
						var tg2:IFocusManagerGroup = null;
						var n:int = int(this.focusableCandidates.length);
						var start:int = i;
						while(true) {
								if(shiftKey) {
										i--;
								} else {
										i++;
								}
								if(bSearchAll) {
										if(shiftKey && i < 0) {
												break;
										}
										if(!shiftKey && i == n) {
												break;
										}
								} else {
										i = (i + n) % n;
										if(start == i) {
												break;
										}
								}
								if(this.isValidFocusCandidate(this.focusableCandidates[i],groupName)) {
										o = DisplayObject(this.findFocusManagerComponent(this.focusableCandidates[i]));
										if(o is IFocusManagerGroup) {
												tg1 = IFocusManagerGroup(o);
												for(j = 0; j < this.focusableCandidates.length; j++) {
														obj = this.focusableCandidates[j];
														if(obj is IFocusManagerGroup) {
																tg2 = IFocusManagerGroup(obj);
																if(tg2.groupName == tg1.groupName && tg2.selected) {
																		i = j;
																		break;
																}
														}
												}
										}
										return i;
								}
						}
						return i;
				}
				
				private function sortFocusableObjects() : void {
						var o:Object = null;
						var c:InteractiveObject = null;
						this.focusableCandidates = [];
						for(o in this.focusableObjects) {
								c = InteractiveObject(o);
								if(c.tabIndex && !isNaN(Number(c.tabIndex)) && c.tabIndex > 0) {
										this.sortFocusableObjectsTabIndex();
										return;
								}
								this.focusableCandidates.push(c);
						}
						this.focusableCandidates.sort(this.sortByDepth);
				}
				
				private function sortFocusableObjectsTabIndex() : void {
						var o:Object = null;
						var c:InteractiveObject = null;
						this.focusableCandidates = [];
						for(o in this.focusableObjects) {
								c = InteractiveObject(o);
								if(Boolean(c.tabIndex) && !isNaN(Number(c.tabIndex))) {
										this.focusableCandidates.push(c);
								}
						}
						this.focusableCandidates.sort(this.sortByTabIndex);
				}
				
				private function sortByDepth(aa:InteractiveObject, bb:InteractiveObject) : Number {
						var index:int = 0;
						var tmp:String = null;
						var tmp2:String = null;
						var val1:String = "";
						var val2:String = "";
						var zeros:String = "0000";
						var a:DisplayObject = DisplayObject(aa);
						var b:DisplayObject = DisplayObject(bb);
						try {
								while(a != DisplayObject(this.form) && Boolean(a.parent)) {
										index = this.getChildIndex(a.parent,a);
										tmp = index.toString(16);
										if(tmp.length < 4) {
												tmp2 = zeros.substring(0,4 - tmp.length) + tmp;
										}
										val1 = tmp2 + val1;
										a = a.parent;
								}
						}
						catch(se1:SecurityError) {
						}
						try {
								while(b != DisplayObject(this.form) && Boolean(b.parent)) {
										index = this.getChildIndex(b.parent,b);
										tmp = index.toString(16);
										if(tmp.length < 4) {
												tmp2 = zeros.substring(0,4 - tmp.length) + tmp;
										}
										val2 = tmp2 + val2;
										b = b.parent;
								}
						}
						catch(se2:SecurityError) {
						}
						return val1 > val2 ? 1 : (val1 < val2 ? -1 : 0);
				}
				
				private function getChildIndex(parent:DisplayObjectContainer, child:DisplayObject) : int {
						return parent.getChildIndex(child);
				}
				
				private function sortByTabIndex(a:InteractiveObject, b:InteractiveObject) : int {
						return a.tabIndex > b.tabIndex ? 1 : (a.tabIndex < b.tabIndex ? -1 : int(this.sortByDepth(a,b)));
				}
				
				public function get defaultButtonEnabled() : Boolean {
						return this._defaultButtonEnabled;
				}
				
				public function set defaultButtonEnabled(value:Boolean) : void {
						this._defaultButtonEnabled = value;
				}
				
				public function get nextTabIndex() : int {
						return 0;
				}
				
				public function get showFocusIndicator() : Boolean {
						return this._showFocusIndicator;
				}
				
				public function set showFocusIndicator(value:Boolean) : void {
						this._showFocusIndicator = value;
				}
				
				public function get form() : DisplayObjectContainer {
						return this._form;
				}
				
				public function set form(value:DisplayObjectContainer) : void {
						this._form = value;
				}
				
				public function getFocus() : InteractiveObject {
						var o:InteractiveObject = this.form.stage.focus;
						return this.findFocusManagerComponent(o);
				}
				
				public function setFocus(component:InteractiveObject) : void {
						if(component is IFocusManagerComponent) {
								IFocusManagerComponent(component).setFocus();
						} else {
								this.form.stage.focus = component;
						}
				}
				
				public function showFocus() : void {
				}
				
				public function hideFocus() : void {
				}
				
				public function findFocusManagerComponent(component:InteractiveObject) : InteractiveObject {
						var p:InteractiveObject = component;
						try {
								while(component) {
										if(component is IFocusManagerComponent && IFocusManagerComponent(component).focusEnabled) {
												return component;
										}
										component = component.parent;
								}
						}
						catch(se:SecurityError) {
						}
						return p;
				}
				
				private function getTopLevelFocusTarget(o:InteractiveObject) : InteractiveObject {
						try {
								while(o != InteractiveObject(this.form)) {
										if(o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled && IFocusManagerComponent(o).mouseFocusEnabled && UIComponent(o).enabled) {
												return o;
										}
										o = o.parent;
										if(o == null) {
												break;
										}
								}
						}
						catch(se:SecurityError) {
						}
						return null;
				}
		}
}

