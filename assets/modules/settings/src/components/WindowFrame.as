package components {
		import fl.core.UIComponent;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol3")]
		public class WindowFrame extends UIComponent {
				public function WindowFrame() {
						super();
				}
				
				override protected function configUI() : void {
						super.configUI();
						callLater(this.draw);
				}
				
				override protected function draw() : void {
				}
		}
}

