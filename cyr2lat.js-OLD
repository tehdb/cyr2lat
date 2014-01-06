var fs = require('fs');
var colors = require('colors');


var _args = {
	dir : process.argv[2],
	ext : process.argv[3]
}
var _logs = {
	filecount : 0,
	dircount : 0
}

if( _args.dir === undefined ) {
	console.log("ERROR\n".red + "\tusage: node cyr2lat.js path-to-diractory [file-extension]");
} else {

	if( _args.ext !== undefined ) {
		_args.ext = _args.ext.toLowerCase();
	}



	if( fs.existsSync( _args.dir ) && fs.statSync(_args.dir).isDirectory() ) {
		if( _args.dir.substr(-1) !== '/' ) {
			_args.dir += '/';
		}

		scanDir( _args.dir, function(){
			var logStr = _logs.dircount + ' direcotries and ' + _logs.filecount + ' files scanned';
			console.log(logStr.green);
		});
	} else {
		console.log("ERROR\n".red + "\t'" + _args.dir + "' not exists or is not a directory");
	}
}


function getExtension(filename) {
	var i = filename.lastIndexOf('.');
	return (i < 0) ? '' : filename.substr(i+1).toLowerCase();
}


function scanDir( dir, callback ) {
	var files = fs.readdirSync(dir);
	for( var i in files ) {
		if( !files.hasOwnProperty(i) ) continue;

		var name = dir + files[i],
			stats = fs.statSync(name);

		if( stats.isDirectory() ){
			prepToRename( name, 'dir', function(path){
				scanDir( path );
			});
		} else if(stats.isFile() ) {
			prepToRename( name, 'file' );
		}
	}

	if( typeof callback === 'function' ) {
		callback();
	}
}

function getLatin( word ) {
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

/*function doRename( oldPath, newPath, callback ) {

	if( fs.existsSync( newPath ) ) {
		console.log( newPath + " exists" );
	} else {
		console.log( "rename " + oldPath + " to " + newPath );
	}

	if( typeof callback === 'function' ) {
		callback( oldPath )
	}	
}*/

function getMultiExt( count ) {
	res = '';
	if( count === 1 ) {
		res = '-I';
	} else {
		for( var i=2, l = count; i < l; i++){
			res += 'I';
		}
	}
	return res;
}



function doRenameOld( path, type, count ) {
	type = type || '';
	count = count || 0;
	
	var newPath = path; 
	if( count === 0) {
		newPath = _args.dir + getLatin( path.substr( _args.dir.length ) );
	} else {

		switch(type) {
			case 'file':
				var pp = newPath.lastIndexOf('.');
				var ext = newPath.substr( pp );
				var tp = newPath.substr(0, pp);

				//console.log( tp, count, ext );

				newPath = tp + getMultiExt( count ) + ext;
			break
			case 'dir':
				newPath += getMultiExt(count );
			break;
		}
	}


	if( path === newPath ) {
		return path;
	} else {
		if( fs.existsSync( newPath ) ) {
			newPath = doRename( newPath, type, ++count );
		} else {
			console.log( newPath );
		}
		return newPath;
	}
}


function doRename( path, type ) {
	/*
		1 translate to latin
		2 check if file exists
		3 if exists 
			3.1 direcotry read (11)
			3.2 file read (11).ext
			3.3 incriment count
			3.4 go to 2 
		4 rename file


		dir-(1) dir-(1)bla

		file-(1).txt
		file-(1)bla.txt
	 */

	var latin = _args.dir + getLatin( path.substr( _args.dir.length ) ),
		
		checkExists = function( path ) {
			return fs.existsSync( path )
		},
		 incrimentCount = function( path, type ) {
			var pathWithoutExt = path, 
				ext = null,
				first = true;
			
			if( type === 'file') {
				var pointIdx = path.lastIndexOf('.');
				pathWithoutExt = path.substr( 0, pointIdx);
				ext = path.substr( pointIdx );
			}

			var openBraketIdx = pathWithoutExt.lastIndexOf('(');
			var closeBraketIdx = pathWithoutExt.lastIndexOf(')');
			var count = null;

			if( openBraketIdx !== -1 && closeBraketIdx === pathWithoutExt.length-1 ) {
				count =  parseInt( pathWithoutExt.substring( openBraketIdx+1, closeBraketIdx), 10);
				if( typeof count === 'number' && count > 0 ) {
					count++;
					path = path.substr(0,openBraketIdx+1) + count + ")";
					if( ext !== null ) {
						 path += ext;
					}
					first = false;
				}
			}
			
			if( first ) {
				if(type === 'file') {
					path = path.substr(0,path.lastIndexOf('.')) + '(1)' + ext;
				} else {
					path += '(1)';
				}
			}
			return path;
		}
}


function prepToRename( path, type, callback ) {

	if( type === 'file') {
		if( _args.ext !== undefined ) {
			var e = getExtension( path);
			if( ext === e ) {
				_logs.filecount++;
				doRename( path, type );
			}
		} else {
			_logs.filecount++;
			doRename( path, type );
		}
	} else if( type === 'dir' ) {
		_logs.dircount++;
		doRename( path, type );
	}

	if( typeof callback === 'function' ) {
		callback( path );
	}
}


