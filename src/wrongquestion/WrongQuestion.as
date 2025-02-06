package wrongquestion
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import syscode.*;
	import wrongquestion.compat.WrongQuestionButtonComponent;

	[Embed(source="/modules/wrongquestion_assets.swf", symbol="symbol19")]
	public class WrongQuestion extends MovieClip
	{
		public static var mc:WrongQuestion = null;

		public var A1:TextField;

		public var A2:TextField;

		public var A3:TextField;

		public var A4:TextField;

		public var BTNCANCEL:WrongQuestionButtonComponent;

		public var BTNREPORT:WrongQuestionButtonComponent;

		public var COMMENT:TextField;

		public var C_COMMENT:TextField;

		public var QUESTION:TextField;

		public var TITLE:TextField;

		public var qtype:int = 1;

		public function WrongQuestion()
		{
			super();
			this.__setProp_BTNREPORT_WrongQuestionMov_characters_0();
			this.__setProp_BTNCANCEL_WrongQuestionMov_characters_0();
		}

		public static function DrawScreen():*
		{
			if (!mc)
			{
				WinMgr.OpenWindow(WrongQuestion);
				return;
			}
		}

		public function Prepare(aparams:Object):void
		{
			var tag:Object = Sys.tag_wrongq;
			Util.StopAllChildrenMov(this);
			this.BTNREPORT.AddEventClick(this.OnReportClick);
			this.BTNCANCEL.AddEventClick(this.OnCancelClick);
			this.BTNREPORT.SetEnabled(false);
			Lang.Set(this.TITLE, "question_marked_as_wrong");
			Util.SetText(this.C_COMMENT, Lang.Get("description") + ":");
			this.BTNREPORT.SetLang("report");
			this.BTNCANCEL.SetLang("cancel");
			Util.AddEventListener(this.COMMENT, "change", this.OnCommentChange);
			this.COMMENT.maxChars = 250;
			Util.RTLEditSetup(this.COMMENT);
			Util.SetRTLEditText(this.COMMENT, "");
			Util.SetText(this.QUESTION, tag.QTXT);
			Util.SetText(this.A1, tag.A1);
			this.qtype = Util.NumberVal(tag.TYPE);
			if (this.qtype == 1)
			{
				Util.SetText(this.A2, tag.A2);
				Util.SetText(this.A3, tag.A3);
				Util.SetText(this.A4, tag.A4);
			}
			else
			{
				this.A2.text = "";
				this.A3.text = "";
				this.A4.text = "";
			}
		}

		public function AfterOpen():void
		{
		}

		public function Hide(e:* = null):void
		{
			if (this.COMMENT)
			{
				Util.RemoveEventListener(this.COMMENT, "change", this.OnCommentChange);
			}
			WinMgr.CloseWindow(this);
		}

		public function OnCommentChange(e:*):*
		{
			this.BTNREPORT.SetEnabled(Util.GetRTLEditText(this.COMMENT).length > 5);
		}

		public function OnReportClick(e:*):*
		{
			var s:* = "";
			s += " MISTAKES=\"" + 31 + "\"";
			s += " REASON=\"" + 1 + "\"";
			s += " COMMENT=\"" + Util.StrXmlSafe(Util.GetRTLEditText(this.COMMENT)) + "\"";
			Comm.SendCommand("WRQCONFIRM", s);
			this.Hide();
		}

		public function OnCancelClick(e:*):*
		{
			Comm.SendCommand("WRQCONFIRM", "REASON=\"0\" MISTAKES=\"0\"");
			this.Hide();
		}

		internal function __setProp_BTNREPORT_WrongQuestionMov_characters_0():*
		{
			try
			{
				this.BTNREPORT["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNREPORT.enabled = true;
			this.BTNREPORT.fontsize = "BIG";
			this.BTNREPORT.icon = "";
			this.BTNREPORT.skin = "OK";
			this.BTNREPORT.testcaption = "Küldés";
			this.BTNREPORT.visible = true;
			this.BTNREPORT.wordwrap = false;
			try
			{
				this.BTNREPORT["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_BTNCANCEL_WrongQuestionMov_characters_0():*
		{
			try
			{
				this.BTNCANCEL["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNCANCEL.enabled = true;
			this.BTNCANCEL.fontsize = "BIG";
			this.BTNCANCEL.icon = "";
			this.BTNCANCEL.skin = "NORMAL";
			this.BTNCANCEL.testcaption = "Mégsem";
			this.BTNCANCEL.visible = true;
			this.BTNCANCEL.wordwrap = false;
			try
			{
				this.BTNCANCEL["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
