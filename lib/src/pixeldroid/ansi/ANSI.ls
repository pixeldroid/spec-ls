package pixeldroid.ansi
{

	/*
		Provides chainable convenience methods for inserting ANSI codes into strings.

		@see http://ascii-table.com/ansi-escape-sequences-vt-100.php
		@see http://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
		@see http://superuser.com/a/270241
	*/
	public class ANSI
	{
		public const code_begin:String = '\x1b['; // aka CSI - Code Sequence Indicator
		public const sgr_end:String = 'm';

		private var _string:String = '';

		public function toString():String
		{
			reset;

			return _string;
		}

		public function get nl():ANSI          { return add('\n'); }

		public function get clear():ANSI       { _string = ''; return this; }
		public function get overwrite():ANSI   { return addCode('2K').addCode('1F'); }

		public function get reset():ANSI       { return addSGR( 0); }
		public function get bold():ANSI        { return addSGR( 1); }
		public function get nobold():ANSI      { return addSGR(22); } // CSI-21 is rarely implemented, use CSI-22 instead
		public function get faint():ANSI       { return addSGR( 2); }
		public function get nofaint():ANSI     { return addSGR(22); }
		public function get italic():ANSI      { return addSGR( 3); }
		public function get noitalic():ANSI    { return addSGR(23); }
		public function get underline():ANSI   { return addSGR( 4); }
		public function get nounderline():ANSI { return addSGR(24); }
		public function get blink():ANSI       { return addSGR( 5); }
		public function get noblink():ANSI     { return addSGR(25); }
		public function get reverse():ANSI     { return addSGR( 7); }
		public function get noreverse():ANSI   { return addSGR(27); }
		public function get conceal():ANSI     { return addSGR( 8); }
		public function get noconceal():ANSI   { return addSGR(28); }

		public function fg8(n:Number):ANSI     { return addSGR(30 + (n % 8)); }
		public function get fgBlack():ANSI     { return addSGR(30); }
		public function get fgRed():ANSI       { return addSGR(31); }
		public function get fgGreen():ANSI     { return addSGR(32); }
		public function get fgYellow():ANSI    { return addSGR(33); }
		public function get fgBlue():ANSI      { return addSGR(34); }
		public function get fgMagenta():ANSI   { return addSGR(35); }
		public function get fgCyan():ANSI      { return addSGR(36); }
		public function get fgWhite():ANSI     { return addSGR(37); }
		public function fg256(n:Number):ANSI   { return addSGR(38, ';5;' +(n % 256)); }
		public function get nofg():ANSI        { return addSGR(39); }

		public function bg8(n:Number):ANSI     { return addSGR(40 + (n % 8)); }
		public function get bgBlack():ANSI     { return addSGR(40); }
		public function get bgRed():ANSI       { return addSGR(41); }
		public function get bgGreen():ANSI     { return addSGR(42); }
		public function get bgYellow():ANSI    { return addSGR(43); }
		public function get bgBlue():ANSI      { return addSGR(44); }
		public function get bgMagenta():ANSI   { return addSGR(45); }
		public function get bgCyan():ANSI      { return addSGR(46); }
		public function get bgWhite():ANSI     { return addSGR(47); }
		public function bg256(n:Number):ANSI   { return addSGR(48, ';5;' +(n % 256)); }
		public function get nobg():ANSI        { return addSGR(49); }


		public function add(s:String):ANSI     { _string += s; return this; }


		private function addSGR(n:Number, args:String=''):ANSI
		{
			// SGR codes follow the CSIx[;y][;z]m format
			_string = _string.concat([code_begin, n, args, sgr_end]);

			return this;
		}

		private function addCode(code:String):ANSI
		{
			// regular codes are just CSIx format
			_string = _string.concat([code_begin, code]);

			return this;
		}
	}
}
