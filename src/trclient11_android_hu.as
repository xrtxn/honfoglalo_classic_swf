package
{
	import syscode.platform.Desktop;

	public class trclient11_android_hu extends Desktop
	{
		public function trclient11_android_hu()
		{
			super();
			NewBootLoader.StartBoot(this, {
						"mobile": false,
						"desktop": false,
						"ios": false,
						"ruffle": true,
						"siteid": "hu",
						"clientparams": "../config/clientparams_hu.xml",
						"appbaseurl": "../"
					});
		}
	}
}
