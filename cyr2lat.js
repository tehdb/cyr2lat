var fs = require('fs');
var colors = require('colors');

var dir = process.argv[2];
var ext = process.argv[3];

var logs = {
	filecount : 0,
	dircount : 0
}

if( dir === undefined ) {
	console.log("ERROR\n".red + "\tusage: node cyr2lat.js path-to-diractory [file-extension]");
} else {
	if( fs.existsSync( dir ) ) {
		scanDir( dir, function(){
			var logStr = logs.dircount + ' direcotries and ' + logs.filecount + ' files renamed ';
			console.log(logStr.green);
		});
	}
}


function getExtension(filename) {
	var i = filename.lastIndexOf('.');
	return (i < 0) ? '' : filename.substr(i+1);
}


function scanDir( dir, callback ) {
	var files = fs.readdirSync(dir);
	for( var i in files ) {
		if( !files.hasOwnProperty(i) ) continue;

		var name = dir+'/'+files[i];
		if( fs.statSync(name).isDirectory() ){
			rename( name, function(path){
				scanDir( path );
			});
		} else {
			rename( name );
		}
	}

	if( typeof callback === 'function' ) {
		callback();
	}
}

function renameToLatin( word ) {
	var cyrMap = {
		'А': 'A',
		'а': 'a',
		'Б': 'B',
		'б': 'b',
		'В': 'V',
		'в': 'v',
		'Г': 'G',
		'г': 'g',
		'Д': 'D',
		'д': 'd',
		'Е': 'E',
		'е': 'e',
		'Ё': 'Jo',
		'ё': 'jo',
		'Ж': 'Zh',
		'ж': 'zh',
		'З': 'Z',
		'з': 'z',
		'И': 'I',
		'и': 'i',
		'Й': 'J',
		'й': 'j',
		'К': 'K',
		'к': 'k',
		'Л': 'L',
		'л': 'l',
		'М': 'M',
		'м': 'm',
		'Н': 'N',
		'н': 'n',
		'О': 'O',
		'о': 'o',
		'П': 'P',
		'п': 'p',
		'Р': 'R',
		'р': 'r',
		'С': 'S',
		'с': 's',
		'Т': 'T',
		'т': 't',
		'У': 'U',
		'у': 'u',
		'Ф': 'F',
		'ф': 'f',
		'Х': 'H',
		'х': 'h',
		'Ц': 'C',
		'ц': 'c',
		'Ч': 'Ch',
		'ч': 'ch',
		'Ш': 'Sh',
		'ш': 'sh',
		'Щ': 'Ssh',
		'щ': 'ssh',
		'Ъ': '#',
		'ъ': '#',
		'Ы': 'Y',
		'ы': 'y',
		'Ь': '"',
		'ь': '\'',
		'Э': 'Je',
		'э': 'je',
		'Ю': 'Ju',
		'ю': 'ju',
		'Я': 'Ja',
		'я': 'ja'
	};

	return word.split('').map(function (char) { 
		return cyrMap[char] || char; 
	}).join("");
}

function rename( path, callback ) {
	var stats = fs.statSync(path),
		proc = false;

	if( stats.isFile() ) {
		if( ext !== undefined ) {
			var e = getExtension( path);
			if( ext === e ) {
				proc = true;
				logs.filecount++;
			}
		} else {
			proc = true;
			logs.filecount++;
		}
	} else if( stats.isDirectory() ) {
		proc = true;
		logs.dircount++;
	}

	if( proc ) {
		var newPath = renameToLatin( path.substr( dir.length+1 ) );
		fs.renameSync( path,  dir + "/" + newPath );
		if( typeof callback === 'function' ) {
			callback(newPath);
		}
	} 
}
