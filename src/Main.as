package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import syscode;

	public class Main extends Sprite
	{
		public function Main()
		{
			var tf:TextField = new TextField();
			tf.text = "Hello World";
			addChild(tf);
			new syscode().Start(null, null, {});
		}
	}
}
