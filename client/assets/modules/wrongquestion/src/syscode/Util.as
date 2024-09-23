package syscode {
		import com.greensock.TweenMax;
		import flash.display.Bitmap;
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.MovieClip;
		import flash.display.Shape;
		import flash.filters.ColorMatrixFilter;
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.utils.Dictionary;
		
		public class Util {
				public static var thousand_separator:String = " ";
				
				public static var decimal_separator:String = ".";
				
				public static var textformat:TextFormat = null;
				
				public static var traceFilter:Array = [];
				
				public static var traceOutput:TextField = null;
				
				public static var debug_listeners:Boolean = true;
				
				public static var dic:Dictionary = new Dictionary(true);
				
				public static var aliasfunc:Dictionary = new Dictionary(true);
				
				public static var dispatch_count:int = 0;
				
				public static var trace_event_listeners:Boolean = false;
				
				public function Util() {
						super();
				}
				
				public static function StopAllChildrenMov(amc:MovieClip) : void {
				}
				
				public static function StartAllChildrenMov(amc:MovieClip) : void {
				}
				
				public static function RemoveChildren(doc:DisplayObjectContainer) : void {
				}
				
				public static function CountAllChildrenMov(amc:MovieClip, filter:Function = null) : int {
						return 0;
				}
				
				public static function LocalToGlobal(ado:DisplayObject) : Object {
						return null;
				}
				
				public static function LocalToGlobalBounded(ado:DisplayObject) : Object {
						return null;
				}
				
				public static function MoveTo(src_do:DisplayObject, dst_do:DisplayObject) : void {
				}
				
				public static function MoveToLocal(src_do:DisplayObject, dst_do:DisplayObject) : void {
				}
				
				public static function MoveToAndScale(src_do:DisplayObject, dst_do:DisplayObject) : void {
				}
				
				public static function SetColor(amc:DisplayObject, acolor:uint) : void {
				}
				
				public static function SetTint(amc:DisplayObject, acolor:uint, amult:Number) : void {
				}
				
				public static function GetSaturationFilter(amount:Number) : ColorMatrixFilter {
						return null;
				}
				
				public static function FormatTimeStamp(utc:Boolean = false, subsecond:Boolean = false) : String {
						return "";
				}
				
				public static function FormatDateTime(year:int, month:int, day:int, hour:int, minute:int, second:int) : String {
						return "";
				}
				
				public static function FormatNumber(number:Number, decimals:int = 0, usethousandsep:Boolean = true) : String {
						return "";
				}
				
				public static function IntToHex(d:uint, cnt:uint) : String {
						return "";
				}
				
				public static function HexToInt(h:String) : uint {
						return 0;
				}
				
				public static function StringVal(str:*, defval:* = "") : * {
				}
				
				public static function NumberVal(num:*, defval:* = 0) : * {
				}
				
				public static function CountBits(num:uint) : int {
						return 0;
				}
				
				public static function PaddingLeft(str:String, pad:String, len:int) : String {
						return "";
				}
				
				public static function PaddingRight(str:String, pad:String, len:int) : String {
						return "";
				}
				
				public static function FormatRemaining(asecs:Number, separatedays:Boolean = true, separatedate:Boolean = false) : String {
						return "";
				}
				
				public static function FormatRemaining2(asecs:Number) : String {
						return "";
				}
				
				public static function XMLTagToObject(axml:XML) : Object {
						return null;
				}
				
				public static function ShuffleArray(arr:Array) : Array {
						return null;
				}
				
				public static function ParseJsVar(text:String) : Object {
						return null;
				}
				
				public static function Random(max:int = 999999999, min:int = 0) : int {
						return 0;
				}
				
				public static function IdFromStringEnd(s:String) : int {
						return 0;
				}
				
				public static function CleanupChatMessage(amsg:String) : String {
						return "";
				}
				
				public static function MovName(amov:DisplayObject) : String {
						return "";
				}
				
				public static function FindTweenedObject(doc:DisplayObjectContainer, tween:TweenMax) : DisplayObject {
						return null;
				}
				
				public static function MovPathName(amov:DisplayObject) : String {
						return "";
				}
				
				public static function ObjByPath(path:String, obj:*) : Object {
						return null;
				}
				
				public static function ExtraRequest(url:String) : * {
				}
				
				public static function GetShot(dobj:DisplayObject) : Object {
						return null;
				}
				
				public static function BreakUp(width:int, height:int, space:int, dobj:DisplayObject) : Array {
						return null;
				}
				
				public static function StrTrim(s:String) : String {
						return "";
				}
				
				public static function StrXmlSafe(s:String) : String {
						return "";
				}
				
				public static function OnCheckBoxClicked(e:*) : * {
				}
				
				public static function CopyFilters(obj:DisplayObject) : Array {
						return null;
				}
				
				public static function UpperCase(str:String) : String {
						return "";
				}
				
				public static function NewPostId(userid:String) : String {
						return "";
				}
				
				public static function InitArabicUtils() : * {
				}
				
				public static function LoadArabicText(tf:TextField, str:String, keeplayout:Boolean = false) : void {
				}
				
				public static function SetText(tf:TextField, str:String, keeplayout:Boolean = false) : void {
				}
				
				public static function FormatArabicText(str:String, tf:TextField) : * {
				}
				
				public static function RTLSwap(id:String, obj1:DisplayObject, obj2:DisplayObject, keeplayout:Boolean = false) : * {
				}
				
				public static function RTLEditSetup(tf:TextField) : void {
				}
				
				public static function GetRTLEditText(tf:TextField) : String {
						return "";
				}
				
				public static function UpdateRTLEdit(eo:*) : * {
				}
				
				public static function SetRTLEditText(tf:TextField, value:String) : * {
				}
				
				public static function OnRTLEditChange(e:*) : * {
				}
				
				public static function OnRTLEditTextInput(e:*) : * {
				}
				
				public static function OnRTLEditKeyDown(e:*) : * {
				}
				
				public static function OnRTLEditKeyUp(e:*) : * {
				}
				
				public static function OnRTLEditClick(e:*) : * {
				}
				
				public static function FormatGetParams(obj:Object, addrnd:Boolean = false) : String {
						return "";
				}
				
				public static function GetFrameNum(aobj:MovieClip, frame:Object) : uint {
						return 0;
				}
				
				public static function ExternalCall(funcName:String, ... aargs) : * {
				}
				
				public static function FormatTrace(obj:*, prefix:String = "", postfix:String = "") : String {
						return "";
				}
				
				public static function CalcDelay(afromtime:int) : Number {
						return 0;
				}
				
				public static function Sleep(ms:int) : void {
				}
				
				public static function Trim(s:String) : String {
						return "";
				}
				
				public static function Trace(... arguments) : void {
				}
				
				public static function RenderText(textfield:TextField) : Bitmap {
						return null;
				}
				
				public static function SwapTextToBitmap(textfield:TextField) : void {
				}
				
				public static function GetPlayerVersion() : Number {
						return 0;
				}
				
				public static function AutoAlignText(amov:MovieClip, txt:String) : void {
				}
				
				public static function RemoveInvisibleChars(astr:String) : String {
						return "";
				}
				
				public static function DrawRectangleWithoutLine(_color:uint, _alpha:Number, _x:Number, _y:Number, _width:Number, _height:Number) : Shape {
						return null;
				}
				
				public static function FormatLocalDate(adate:*) : * {
				}
				
				public static function FormatDate(_date:String) : String {
						return "";
				}
				
				public static function DegreesToRadians(_degrees:Number) : Number {
						return 0;
				}
				
				public static function RadiansToDegrees(_radians:Number) : Number {
						return 0;
				}
				
				public static function RoundDecimalPlace(_n:Number, _decimals:int) : Number {
						return 0;
				}
				
				public static function TileImage(imageArea:DisplayObject, tileX:int = 512, tileY:int = 512) : MovieClip {
						return null;
				}
				
				public static function ShowChildrenOnScreen(obj:MovieClip) : void {
				}
				
				public static function SendProstatData(_cmd:String) : void {
				}
				
				public static function SwapSkin(_src:*, _targetSwf:String, _targetClass:String) : * {
				}
				
				public static function SwapTextcolor(_tf:TextField, _color:String, _targetSwf:String) : void {
				}
				
				public static function CountEventListeners() : int {
						return 0;
				}
				
				public static function AddEventListener(o:Object, s:String, f:Function, c:Boolean = false, p:int = 0, w:Boolean = false) : void {
				}
				
				public static function RemoveEventListener(o:Object, s:String, f:Function, c:Boolean = false) : void {
				}
		}
}

