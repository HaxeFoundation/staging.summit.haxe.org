import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

class Assets {
	public static function generate() {
		var config = Config.get();

		Sys.println('Copying assets from "www" to "${config.outputFolder}" ...');

		for (entry in FileSystem.readDirectory("www")) {
			copyFromDataFolder(entry, config.outputFolder);
		}
	}

	static function copyFromDataFolder(path:String, to:String) {
		var inPath = Path.join(["www", path]);
		var outPath = Path.join([to, path]);

		if (FileSystem.isDirectory(inPath)) {
			if (!FileSystem.exists(outPath)) {
				FileSystem.createDirectory(outPath);
			}
			for (entry in FileSystem.readDirectory(inPath)) {
				copyFromDataFolder(Path.join([path, entry]), to);
			}
		} else {
			File.copy(inPath, outPath);

			if (Path.extension(outPath) == "css") {
				File.saveContent(outPath, Utils.minifyCss(File.getContent(outPath)));
			}
		}
	}
}
