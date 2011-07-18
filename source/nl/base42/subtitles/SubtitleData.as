package nl.base42.subtitles {
	/**
	 *  @author Jankees van Woezik <jankees@base42.nl>
	 */
	public class SubtitleData {
		public var text : String;
		public var start : Number;
		public var end : Number;

		public function SubtitleData(inText : String = "", inStart : Number = 0, inEnd : Number = 0) {
			text = inText;
			start = inStart;
			end = inEnd;
		}

		public function isVisibleOnTime(inCurrentTime : Number) : Boolean {
			return (inCurrentTime > start && inCurrentTime < end);
		}

		public function toString() : String {
			return "[SubtitleData text: '" + text + "...' start: " + start + " end: " + end + "]";
		}
	}
}