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
				
				public static function StopAllChildrenMov(param1:MovieClip) : void {
				}
				
				public static function StartAllChildrenMov(param1:MovieClip) : void {
				}
				
				public static function RemoveChildren(param1:DisplayObjectContainer) : void {
				}
				
				public static function CountAllChildrenMov(param1:MovieClip, param2:Function = null) : int {
						return 0;
				}
				
				public static function LocalToGlobal(param1:DisplayObject) : Object {
						return null;
				}
				
				public static function LocalToGlobalBounded(param1:DisplayObject) : Object {
						return null;
				}
				
				public static function MoveTo(param1:DisplayObject, param2:DisplayObject) : void {
				}
				
				public static function MoveToLocal(param1:DisplayObject, param2:DisplayObject) : void {
				}
				
				public static function MoveToAndScale(param1:DisplayObject, param2:DisplayObject) : void {
				}
				
				public static function SetColor(param1:DisplayObject, param2:uint) : void {
				}
				
				public static function SetTint(param1:DisplayObject, param2:uint, param3:Number) : void {
				}
				
				public static function GetSaturationFilter(param1:Number) : ColorMatrixFilter {
						return null;
				}
				
				public static function FormatTimeStamp(param1:Boolean = false, param2:Boolean = false) : String {
						return "";
				}
				
				public static function FormatDateTime(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : String {
						return "";
				}
				
				public static function FormatNumber(param1:Number, param2:int = 0, param3:Boolean = true) : String {
						return "";
				}
				
				public static function IntToHex(param1:uint, param2:uint) : String {
						return "";
				}
				
				public static function HexToInt(param1:String) : uint {
						return 0;
				}
				
				public static function StringVal(param1:*, param2:* = "") : * {
				}
				
				public static function NumberVal(param1:*, param2:* = 0) : * {
				}
				
				public static function CountBits(param1:uint) : int {
						return 0;
				}
				
				public static function PaddingLeft(param1:String, param2:String, param3:int) : String {
						return "";
				}
				
				public static function PaddingRight(param1:String, param2:String, param3:int) : String {
						return "";
				}
				
				public static function FormatRemaining(param1:Number, param2:Boolean = true, param3:Boolean = false) : String {
						return "";
				}
				
				public static function FormatRemaining2(param1:Number) : String {
						return "";
				}
				
				public static function XMLTagToObject(param1:XML) : Object {
						return null;
				}
				
				public static function ShuffleArray(param1:Array) : Array {
						return null;
				}
				
				public static function ParseJsVar(param1:String) : Object {
						return null;
				}
				
				public static function Random(param1:int = 999999999, param2:int = 0) : int {
						return 0;
				}
				
				public static function IdFromStringEnd(param1:String) : int {
						return 0;
				}
				
				public static function CleanupChatMessage(param1:String) : String {
						return "";
				}
				
				public static function MovName(param1:DisplayObject) : String {
						return "";
				}
				
				public static function FindTweenedObject(param1:DisplayObjectContainer, param2:TweenMax) : DisplayObject {
						return null;
				}
				
				public static function MovPathName(param1:DisplayObject) : String {
						return "";
				}
				
				public static function ObjByPath(param1:String, param2:*) : Object {
						return null;
				}
				
				public static function ExtraRequest(param1:String) : * {
				}
				
				public static function GetShot(param1:DisplayObject) : Object {
						return null;
				}
				
				public static function BreakUp(param1:int, param2:int, param3:int, param4:DisplayObject) : Array {
						return null;
				}
				
				public static function StrTrim(param1:String) : String {
						return "";
				}
				
				public static function StrXmlSafe(param1:String) : String {
						return "";
				}
				
				public static function OnCheckBoxClicked(param1:*) : * {
				}
				
				public static function CopyFilters(param1:DisplayObject) : Array {
						return null;
				}
				
				public static function UpperCase(param1:String) : String {
						return "";
				}
				
				public static function NewPostId(param1:String) : String {
						return "";
				}
				
				public static function InitArabicUtils() : * {
				}
				
				public static function LoadArabicText(param1:TextField, param2:String, param3:Boolean = false) : void {
				}
				
				public static function SetText(param1:TextField, param2:String, param3:Boolean = false) : void {
				}
				
				public static function FormatArabicText(param1:String, param2:TextField) : * {
				}
				
				public static function RTLSwap(param1:String, param2:DisplayObject, param3:DisplayObject, param4:Boolean = false) : * {
				}
				
				public static function RTLEditSetup(param1:TextField) : void {
				}
				
				public static function GetRTLEditText(param1:TextField) : String {
						return "";
				}
				
				public static function UpdateRTLEdit(param1:*) : * {
				}
				
				public static function SetRTLEditText(param1:TextField, param2:String) : * {
				}
				
				public static function OnRTLEditChange(param1:*) : * {
				}
				
				public static function OnRTLEditTextInput(param1:*) : * {
				}
				
				public static function OnRTLEditKeyDown(param1:*) : * {
				}
				
				public static function OnRTLEditKeyUp(param1:*) : * {
				}
				
				public static function OnRTLEditClick(param1:*) : * {
				}
				
				public static function FormatGetParams(param1:Object, param2:Boolean = false) : String {
						return "";
				}
				
				public static function GetFrameNum(param1:MovieClip, param2:Object) : uint {
						return 0;
				}
				
				public static function ExternalCall(param1:String, ... rest) : * {
				}
				
				public static function FormatTrace(param1:*, param2:String = "", param3:String = "") : String {
						return "";
				}
				
				public static function CalcDelay(param1:int) : Number {
						return 0;
				}
				
				public static function Sleep(param1:int) : void {
				}
				
				public static function Trim(param1:String) : String {
						return "";
				}
				
				public static function Trace(... rest) : void {
				}
				
				public static function RenderText(param1:TextField) : Bitmap {
						return null;
				}
				
				public static function SwapTextToBitmap(param1:TextField) : void {
				}
				
				public static function GetPlayerVersion() : Number {
						return 0;
				}
				
				public static function AutoAlignText(param1:MovieClip, param2:String) : void {
				}
				
				public static function RemoveInvisibleChars(param1:String) : String {
						return "";
				}
				
				public static function DrawRectangleWithoutLine(param1:uint, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Shape {
						return null;
				}
				
				public static function FormatLocalDate(param1:*) : * {
				}
				
				public static function FormatDate(param1:String) : String {
						return "";
				}
				
				public static function DegreesToRadians(param1:Number) : Number {
						return 0;
				}
				
				public static function RadiansToDegrees(param1:Number) : Number {
						return 0;
				}
				
				public static function RoundDecimalPlace(param1:Number, param2:int) : Number {
						return 0;
				}
				
				public static function TileImage(param1:DisplayObject, param2:int = 512, param3:int = 512) : MovieClip {
						return null;
				}
				
				public static function ShowChildrenOnScreen(param1:MovieClip) : void {
				}
				
				public static function SendProstatData(param1:String) : void {
				}
				
				public static function SwapSkin(param1:*, param2:String, param3:String) : * {
				}
				
				public static function SwapTextcolor(param1:TextField, param2:String, param3:String) : void {
				}
				
				public static function CountEventListeners() : int {
						return 0;
				}
				
				public static function AddEventListener(param1:Object, param2:String, param3:Function, param4:Boolean = false, param5:int = 0, param6:Boolean = false) : void {
				}
				
				public static function RemoveEventListener(param1:Object, param2:String, param3:Function, param4:Boolean = false) : void {
				}
				
				public static function VerticalSliceImage(param1:MovieClip, param2:*, param3:Array, param4:int) : Array {
						return null;
				}
		}
}

