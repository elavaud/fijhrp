<?php
/**
 * Class for creating zip archive of directories
 * @author http://www.ramui.com Ramui webblog
 */

class Zip {
	
	function recurse_zip($src,&$zip,$path_length) {
		$dir = opendir($src);
		while( $file = readdir($dir) ) {
			if (( $file != '.' ) && ( $file != '..' )) {
				if ( is_dir($src . '/' . $file) ) {
					$this->recurse_zip($src . '/' . $file,$zip,$path_length);
				}
				else {
					$zip->addFile($src . '/' . $file,substr($src . '/' . $file,$path_length));
				}
			}
		}
		closedir($dir);
	}
	//Call this function with argument = absolute path of file or directory name.
	function compress($src, $filename, $dest = null) {
		if(substr($src,-1)==='/'){
			$src=substr($src,0,-1);
		}
		$arr_src=explode('/',$src);

		unset($arr_src[count($arr_src)-1]);
		$path_length=strlen(implode('/',$arr_src).'/');
		$filename=$filename.".zip";
		
		$zip = new ZipArchive();
		$dest = $dest == null? $filename: $dest.$filename;
		if(!$zip->open($dest, ZipArchive::CREATE)){
			return false;
		}

		if(is_file($src)){
			$zip->addFile($src,substr($src,$path_length));
		}
		else{
			if(!is_dir($src)){
				$zip->close();
				@unlink($filename);
				return false;
			}
			$this->recurse_zip($src,$zip,$path_length);
		}
		$zip->close();		
	}
}

?>