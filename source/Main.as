package {
	import ca.turbulent.media.Pyro;

	import logmeister.LogMeister;
	import logmeister.connectors.TrazzleConnector;

	import nl.base42.subtitles.SubtitleParser;

	import com.bit101.components.Slider;
	import com.bit101.components.Text;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 *  @author Jankees van Woezik <jankees@base42.nl>
	 */
	public class Main extends Sprite {
		private static const WIDTH : Number = 480;
		private static const HEIGHT : Number = 274;
		private var _pyroInstance : Pyro;
		private var _slider : Slider;
		private var _subtitles : Array;
		private var _subtitlesText : Text;

		public function Main() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			// LogMeister.addLogger(new TrazzleConnector(stage, "Video"));

			_pyroInstance = new Pyro(WIDTH, HEIGHT);
			_pyroInstance.play("trailer_big_buck_bunny.m4v");
			addChild(_pyroInstance);

			_slider = new Slider("horizontal", this, 0, 0, handleSliderChange);
			_slider.width = WIDTH;
			_slider.y = HEIGHT;

			var subtitle : DataLoader = new DataLoader("subtitle.srt");
			subtitle.addEventListener(LoaderEvent.COMPLETE, handleSubtitleLoaded);
			subtitle.load(true);

			_subtitlesText = new Text();
			_subtitlesText.editable = false;
			_subtitlesText.width = WIDTH;
			_subtitlesText.height = 50;
			_subtitlesText.y = _slider.y + _slider.height;
			addChild(_subtitlesText);

			var textFormat : TextFormat = _subtitlesText.textField.getTextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			_subtitlesText.textField.defaultTextFormat = textFormat;

			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function handleSubtitleLoaded(event : LoaderEvent) : void {
			_subtitles = SubtitleParser.parseSRT(DataLoader(event.currentTarget).content);
		}

		private function handleSliderChange(event : Event) : void {
			_pyroInstance.seek(_pyroInstance.duration * (_slider.value / 100));
			_pyroInstance.play();
		}

		private function handleEnterFrame(event : Event) : void {
			_slider.value = _pyroInstance.progressRatio * 100;
			updateSubtitle();
		}

		private function updateSubtitle() : void {
			if (!_subtitles) return;
			_subtitlesText.text = SubtitleParser.getCurrentSubtitle(_pyroInstance.time, _subtitles);
		}
	}
}
